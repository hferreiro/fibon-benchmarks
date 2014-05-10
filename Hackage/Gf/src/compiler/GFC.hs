module GFC (mainGFC, writePGF) where
-- module Main where

import PGF
import PGF.CId
import PGF.Data
import PGF.Optimize
import GF.Index
import GF.Compile
import GF.Compile.Export

import GF.Grammar.CF ---- should this be on a deeper level? AR 15/10/2008
import GF.Grammar (identC)

import GF.Infra.UseIO
import GF.Infra.Option
import GF.Data.ErrM

import Data.Maybe
import Data.Binary
import qualified Data.Map as Map
import qualified Data.ByteString as BSS
import qualified Data.ByteString.Lazy as BSL
import qualified Data.ByteString.Char8 as BS
import System.FilePath
import System.IO
import Control.Exception


mainGFC :: Options -> [FilePath] -> IO ()
mainGFC opts fs = do
  r <- appIOE (case () of
                 _ | null fs -> fail $ "No input files."
                 _ | all (extensionIs ".cf")  fs -> compileCFFiles opts fs
                 _ | all (\f -> extensionIs ".gf" f || extensionIs ".gfo" f)  fs -> compileSourceFiles opts fs
                 _ | all (extensionIs ".pgf") fs -> unionPGFFiles opts fs
                 _ -> fail $ "Don't know what to do with these input files: " ++ unwords fs)
  case r of
    Ok x    -> return x
    Bad msg -> die $ if flag optVerbosity opts == Normal
                       then ('\n':msg)
                       else msg
 where
   extensionIs ext = (== ext) .  takeExtension

compileSourceFiles :: Options -> [FilePath] -> IOE ()
compileSourceFiles opts fs = 
    do gr <- batchCompile opts fs
       let cnc = justModuleName (last fs)
       if flag optStopAfterPhase opts == Compile 
         then return ()
         else do pgf <- link opts (identC (BS.pack cnc)) gr
                 writePGF opts pgf
                 writeByteCode opts pgf
                 writeOutputs opts pgf

compileCFFiles :: Options -> [FilePath] -> IOE ()
compileCFFiles opts fs = 
    do s  <- ioeIO $ fmap unlines $ mapM readFile fs 
       let cnc = justModuleName (last fs)
       gf <- ioeErr $ getCF cnc s
       gr <- compileSourceGrammar opts gf
       if flag optStopAfterPhase opts == Compile 
         then return ()
         else do pgf <- link opts (identC (BS.pack cnc)) gr
                 writePGF opts pgf
                 writeOutputs opts pgf

unionPGFFiles :: Options -> [FilePath] -> IOE ()
unionPGFFiles opts fs = 
    do pgfs <- mapM readPGFVerbose fs
       let pgf0 = foldl1 unionPGF pgfs
           pgf1 = if flag optOptimizePGF opts then optimizePGF pgf0 else pgf0
           pgf = if flag optMkIndexPGF opts then addIndex pgf1 else pgf1
           pgfFile = grammarName opts pgf <.> "pgf"
       if pgfFile `elem` fs 
         then putStrLnE $ "Refusing to overwrite " ++ pgfFile
         else writePGF opts pgf
       writeOutputs opts pgf
  where readPGFVerbose f = putPointE Normal opts ("Reading " ++ f ++ "...") $ ioeIO $ readPGF f

writeOutputs :: Options -> PGF -> IOE ()
writeOutputs opts pgf = do
  sequence_ [writeOutput opts name str 
                 | fmt <- flag optOutputFormats opts,
                   fmt /= FmtByteCode,
                   (name,str) <- exportPGF opts fmt pgf]

writeByteCode :: Options -> PGF -> IOE ()
writeByteCode opts pgf
  | elem FmtByteCode (flag optOutputFormats opts) =
             let name = fromMaybe (showCId (abstractName pgf)) (flag optName opts)
                 file = name <.> "bc"
                 path = case flag optOutputDir opts of
                          Nothing  -> file
                          Just dir -> dir </> file
             in putPointE Normal opts ("Writing " ++ path ++ "...") $ ioeIO $
                   bracket
                      (openFile path WriteMode)
                      (hClose)
                      (\h -> do hSetBinaryMode h True
                                BSL.hPut h (encode addrs)
                                BSS.hPut h (code (abstract pgf)))
  | otherwise = return ()
  where
    addrs = 
      [(id,addr) | (id,(_,_,_,_,addr)) <- Map.toList (funs (abstract pgf))] ++
      [(id,addr) | (id,(_,_,addr))     <- Map.toList (cats (abstract pgf))]

writePGF :: Options -> PGF -> IOE ()
writePGF opts pgf = do
  let outfile = grammarName opts pgf <.> "pgf"
  putPointE Normal opts ("Writing " ++ outfile ++ "...") $ ioeIO $ encodeFile outfile pgf

grammarName :: Options -> PGF -> String
grammarName opts pgf = fromMaybe (showCId (absname pgf)) (flag optName opts)

writeOutput :: Options -> FilePath-> String -> IOE ()
writeOutput opts file str =
    putPointE Normal opts ("Writing " ++ path ++ "...") $ ioeIO $
      writeUTF8File path str
  where
    path = maybe id (</>) (flag optOutputDir opts) file

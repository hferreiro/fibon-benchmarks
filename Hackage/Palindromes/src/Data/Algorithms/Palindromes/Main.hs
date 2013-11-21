-----------------------------------------------------------------------------
-- |
-- Module      :  Data.Algorithms.Palindromes.Main
-- Copyright   :  (c) 2007 - 2013 Johan Jeuring
-- License     :  BSD3
--
-- Maintainer  :  johan@jeuring.net
-- Stability   :  experimental
-- Portability :  portable
--
-----------------------------------------------------------------------------
module Main where

import System.Environment (getArgs)
import System.Console.GetOpt 
import System.IO

import qualified Data.ByteString as B

import Data.Algorithms.Palindromes.Options

import Fibon.Run.BenchmarkHelper

-----------------------------------------------------------------------------
-- main
-----------------------------------------------------------------------------

handleFilesWith :: Int -> (B.ByteString -> String) -> [String] -> IO ()
handleFilesWith _     f [] = putStr $ f undefined 
handleFilesWith iters f xs = 
  let hFW filenames = 
        case filenames of
          []        ->  putStr ""
          (fn:fns)  ->  do fn' <- openFile fn ReadMode
                           hSetEncoding fn' latin1 
                           input <- B.hGetContents fn' 
                           fibonOutput (f input)
                           hClose fn'
                           hFW fns
      fibonOutput a = if iters == 1 then putStrLn a else deepseq a (return ())
  in hFW xs       

handleStandardInputWith :: (B.ByteString -> String) -> IO ()
handleStandardInputWith function = 
  do input <- B.getContents
     putStrLn (function input) 

main :: IO ()
main = fibonMain oldmain

oldmain :: Int -> IO ()
oldmain 0 = return ()
oldmain n = do args <- getArgs
               let (optionArgs,files,errors) = getOpt Permute options args
               if not (null errors) 
                 then putStrLn (concat errors) 
                 else let (function,standardInput) = handleOptions optionArgs
                      in  if standardInput 
                          then handleStandardInputWith function >> oldmain (n-1)
                          else handleFilesWith n function files >> oldmain (n-1)


{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
module Fibon.Benchmarks.Hackage.Pappy.Fibon.Instance(
  mkInstance
)
where
import Fibon.BenchmarkInstance

sharedConfig = BenchmarkInstance {
    flagConfig = FlagConfig {
        configureFlags = []
      , buildFlags     = []
      , runFlags       = []
      }
    , stdinInput     = Nothing
    , output         = [(Stdout, Diff "java-parser.stdout.expected")]
    , expectedExit   = ExitSuccess
    , exeName        = "Pappy"
  }
flgCfg = flagConfig sharedConfig
trainFiles = [ "BlockMessageDigest.java", "Blowfish.java", "CAST5.java",
               "DES2X.java", "DES_EDE3.java", "DES.java", "DESX.java",
               "HAVAL.java", "HexDump.java", "IDEA.java", "KAT.java",
               "LOKI91.java", "MCT.java", "MD2.java", "MD4.java", "MD5.java",
               "NativeLink.java", "RC2.java", "RC4.java", "Rijndael.java",
               "RIPEMD128.java", "RIPEMD160.java", "SAFER.java", "Scar.java",
               "SHA0.java", "SHA1.java", "SPEED.java", "Square.java",
               "Test3LFSR.java", "TestAll.java", "TestBase64Stream.java",
               "TestBlowfish.java", "TestBR.java", "TestCAST5.java",
               "TestDES_EDE3.java", "TestDES.java", "TestElGamal.java",
               "TestHAVAL.java", "TestHMAC.java", "TestIDEA.java",
               "TestIJCE.java", "TestInstall.java", "TestLOKI91.java",
               "TestMD2.java", "TestMD4.java", "TestMD5.java", "TestRC2.java",
               "TestRC4.java", "TestRijndael.java", "TestRIPEMD128.java",
               "TestRIPEMD160.java", "TestRSA.java", "TestSAFER.java",
               "TestScar.java", "TestSHA0.java", "TestSHA1.java",
               "TestSPEED.java", "TestSquare.java", "TestUnixCrypt.java",
               "UnixCrypt.java" ]

mkInstance Test = sharedConfig {
        flagConfig = flgCfg {runFlags = ["HexDump.java"]}
    }
mkInstance Train = sharedConfig {
        flagConfig = flgCfg {runFlags = trainFiles}
    }
mkInstance Ref  = sharedConfig {
        flagConfig = flgCfg {runFlags = trainFiles}
    }


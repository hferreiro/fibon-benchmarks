{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
module Fibon.Benchmarks.Hackage.Palindromes.Fibon.Instance(
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
    , output         = [(Stdout, Diff "palindromes.stdout.expected")]
    , expectedExit   = ExitSuccess
    , exeName        = "Palindromes"
  }
flgCfg = flagConfig sharedConfig
trainFiles = ["huckfinn.txt",
              "kjv.txt" ]
refFiles = ["annakarenina.txt",
            "huckfinn.txt",
             "kjv.txt",
             "olivertwist.txt",
             "swannsway.txt" ]

mkInstance Test = sharedConfig {
        flagConfig = flgCfg {runFlags = ["-tlr", "small"]}
    }
mkInstance Train = sharedConfig {
        flagConfig = flgCfg {runFlags = ["-tlr"] ++ trainFiles}
    }
mkInstance Ref  = sharedConfig {
        flagConfig = flgCfg {runFlags = ["-tlr"] ++ refFiles}
    }

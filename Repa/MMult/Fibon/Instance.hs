{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
module Fibon.Benchmarks.Repa.MMult.Fibon.Instance(
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
    , output         = [(Stdout, Diff "repa-mmult.stdout.expected")]
    , expectedExit   = ExitSuccess
    , exeName        = "MMult"
  }
flgCfg = flagConfig sharedConfig

mkInstance Test = sharedConfig {
        flagConfig = flgCfg {runFlags = words "-random 10 10 -random 10 10"}
    }
mkInstance Train = sharedConfig {
        flagConfig = flgCfg {runFlags = words "-random 1000 1000 -random 1000 1000"}
    }
mkInstance Ref  = sharedConfig {
        flagConfig = flgCfg {runFlags = words "-r 10 -random 1000 1000 -random 1000 1000"}
    }


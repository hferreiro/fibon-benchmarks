{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
module Fibon.Benchmarks.Hackage.Agum.Fibon.Instance(
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
    , stdinInput     = Just "eqn.txt"
    , output         = [(Stdout, Diff "agum.stdout.expected")]
    , expectedExit   = ExitSuccess
    , exeName        = "Agum"
  }
flgCfg = flagConfig sharedConfig

mkInstance Test = sharedConfig {
        flagConfig = flgCfg
    }
mkInstance Train = sharedConfig {
        flagConfig = flgCfg {runFlags = words "-r 40"}
    }
mkInstance Ref  = sharedConfig {
        flagConfig = flgCfg {runFlags = words "-r 100"}
    }


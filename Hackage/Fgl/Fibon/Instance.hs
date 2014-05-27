{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
module Fibon.Benchmarks.Hackage.Fgl.Fibon.Instance(
  mkInstance
)
where
import Fibon.BenchmarkInstance

import Data.List ( sort )

sharedConfig = BenchmarkInstance {
    flagConfig = FlagConfig {
        configureFlags = []
      , buildFlags     = []
      , runFlags       = []
      }
    , stdinInput     = Nothing
    , output         = [(Stdout, Diff "fgl.stdout.expected")]
    , expectedExit   = ExitSuccess
    , exeName        = "Fgl"
  }
flgCfg = flagConfig sharedConfig
trainGraphs = [
            "le450_25a.col",
            "le450_25b.col",
            "le450_25c.col",
            "le450_25d.col"
          ]
refGraphs = [
          "le450_15a.col",
          "le450_15b.col",
          "le450_15c.col",
          "le450_15d.col",
          "le450_5a.col",
          "le450_5b.col",
          "le450_5c.col",
          "le450_5d.col"
          ]

mkInstance Test = sharedConfig {
        flagConfig = flgCfg {
          runFlags = [
            "anna.col",
            "david.col",
            "homer.col",
            "huck.col"
          ]
        }
    }
mkInstance Train = sharedConfig {
        flagConfig = flgCfg {
          runFlags = trainGraphs
        }
    }
mkInstance Ref  = sharedConfig {
        flagConfig = flgCfg {
          runFlags = sort (refGraphs ++ trainGraphs)
        }
    }


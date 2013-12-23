{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
module Fibon.Benchmarks.Hackage.Cpsa.Fibon.Instance(
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
    , output         = [(Stdout, Diff "cpsa.stdout.expected")]
    , expectedExit   = ExitSuccess
    , exeName        = "Cpsa"
  }
flgCfg = flagConfig sharedConfig

mkInstance Test = sharedConfig {
        flagConfig = flgCfg {runFlags = ["ns.scm"]}
    }
mkInstance Train = sharedConfig {
        flagConfig   = flgCfg {runFlags = ["pca.tst"]}
    }
mkInstance Ref  = sharedConfig {
        flagConfig   = flgCfg {runFlags = ["nsl4cm1.lsp"]}
      , output       = output sharedConfig ++ [(Stderr, Diff "cpsa.stderr.expected")]
      , expectedExit = ExitFailure 1
    }


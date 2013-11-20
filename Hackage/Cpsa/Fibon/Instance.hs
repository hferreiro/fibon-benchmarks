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
        flagConfig   = flgCfg {runFlags = ["nsl5.lisp"]}
      , output       = output sharedConfig ++ [(Stderr, Diff "cpsa.stderr.expected")]
      , expectedExit = ExitFailure 1
    }
mkInstance Ref  = sharedConfig {
        flagConfig   = flgCfg {runFlags = ["nsl5.lisp"]} -- '-r n' is ignored
      , output       = output sharedConfig ++ [(Stderr, Diff "cpsa.stderr.expected")]
      , expectedExit = ExitFailure 1
    }


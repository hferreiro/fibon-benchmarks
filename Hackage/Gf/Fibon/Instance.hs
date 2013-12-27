{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
module Fibon.Benchmarks.Hackage.Gf.Fibon.Instance(
  mkInstance
)
where
import Fibon.BenchmarkInstance

sharedConfig = BenchmarkInstance {
    flagConfig = FlagConfig {
        configureFlags = []
      , buildFlags     = []
      , runFlags       = ["--quiet", "--src", "--make", "-f", "haskell"]
      }
    , output         = []
    , expectedExit   = ExitSuccess
    , stdinInput     = Nothing
    , exeName        = "Gf"
  }
flgCfg = flagConfig sharedConfig
trainFiles = ["AdjectiveEng.gf", "AdjectiveFre.gf", "Adjective.gf",
              "AdjectiveRomance.gf", "AdverbEng.gf", "AdverbFre.gf",
              "Adverb.gf", "AdverbRomance.gf", "AllEngAbs.gf", "AllEng.gf",
              "AllFreAbs.gf", "AllFre.gf", "BackwardEng.gf", "Backward.gf",
              "BeschFre.gf", "CatEng.gf", "CatFre.gf", "Cat.gf",
              "CatRomance.gf", "Common.gf", "CommonRomance.gf", "CommonX.gf",
              "CompatibilityCat.gf", "CompatibilityEng.gf",
              "CompatibilityFre.gf", "Compatibility.gf", "ConjunctionEng.gf",
              "ConjunctionFre.gf", "Conjunction.gf", "ConjunctionRomance.gf",
              "ConstructX.gf", "Coordination.gf", "DictEngAbs.gf",
              "DictEng.gf", "DiffFre.gf", "DiffRomance.gf", "ExtraEngAbs.gf",
              "ExtraEng.gf", "ExtraFreAbs.gf", "ExtraFre.gf", "Extra.gf",
              "ExtraRomanceAbs.gf", "ExtraRomanceFre.gf", "ExtraRomance.gf",
              "ExtRomance.gf", "Formal.gf", "GrammarEng.gf", "GrammarFre.gf",
              "Grammar.gf", "HTML.gf", "IdiomEng.gf", "IdiomFre.gf",
              "Idiom.gf", "IrregEngAbs.gf", "IrregEng.gf", "Irregf",
              "reAbs.gf", "Irregf", "re.gf", "LangEng.gf", "Langf", "re.gf",
              "Lang.gf", "Latex.gf", "LexiconEng.gf", "LexiconFre.gf",
              "Lexicon.gf", "MakeStructuralEng.gf", "MakeStructuralFre.gf",
              "MorphoEng.gf", "MorphoFre.gf", "NounEng.gf", "NounFre.gf",
              "Noun.gf", "NounRomance.gf", "NumeralEng.gf", "NumeralFre.gf",
              "Numeral.gf", "NumeralTransfer.gf", "OverloadEng.gf",
              "Overload.gf", "ParadigmsEng.gf", "ParadigmsFre.gf",
              "ParamX.gf", "PhonoFre.gf", "PhraseEng.gf", "PhraseFre.gf",
              "Phrase.gf", "PhraseRomance.gf", "Precedence.gf",
              "PredefAbs.gf", "PredefCnc.gf", "Predef.gf", "Prelude.gf",
              "QuestionEng.gf", "QuestionFre.gf", "Question.gf",
              "QuestionRomance.gf", "RelativeEng.gf", "RelativeFre.gf",
              "Relative.gf", "RelativeRomance.gf", "ResEng.gf", "ResFre.gf",
              "ResRomance.gf", "SentenceEng.gf", "SentenceFre.gf",
              "Sentence.gf", "SentenceRomance.gf", "StructuralEng.gf",
              "StructuralFre.gf", "Structural.gf", "SymbolEng.gf",
              "SymbolFre.gf", "Symbol.gf", "SymbolRomance.gf", "TenseFre.gf",
              "Tense.gf", "TenseRomance.gf", "TenseX.gf", "Text.gf",
              "TextX.gf", "VerbEng.gf", "VerbFre.gf", "Verb.gf",
              "VerbRomance.gf"] ++
             ["EngDescr.gf", "Eng.gf", "EngReal.gf",  "FreDescr.gf",
              "Fre.gf", "FreReal.gf"]

mkInstance Test = sharedConfig {
        output         = [(OutputFile "RDF.hs", Diff "RDF.hs.expected")]
      , flagConfig = flgCfg {runFlags = (runFlags flgCfg) ++ ["RDF.gf"]}
    }
mkInstance Train = sharedConfig {
        output         = [(OutputFile "Fre.hs", Diff "Fre.hs.expected")]
      , flagConfig = flgCfg {
          runFlags = (runFlags flgCfg) ++ trainFiles
        }
    }
mkInstance Ref  = sharedConfig {
        output         = [(OutputFile "Fre.hs", Diff "Fre.hs.expected")]
      , flagConfig = flgCfg {
          runFlags = (runFlags flgCfg) ++ trainFiles
        }
    }


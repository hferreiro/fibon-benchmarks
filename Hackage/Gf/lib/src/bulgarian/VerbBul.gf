concrete VerbBul of Verb = CatBul ** open Prelude, ResBul, ParadigmsBul in {
  flags coding=cp1251 ;


  flags optimize=all_subs ;

  lin
    UseV = predV ;

    SlashV2a v = slashV v v.c2 ;

    Slash2V3 v np = 
      insertSlashObj1 (\\_ => v.c2.s ++ np.s ! RObj v.c2.c) (slashV v v.c3) ;

    Slash3V3 v np = 
      insertSlashObj2 (\\_ => v.c3.s ++ np.s ! RObj v.c3.c) (slashV v v.c2) ;

    ComplVV vv vp =
      insertObj (case vv.typ of {
                   VVInf => daComplex Simul Pos vp ! Perf;
                   VVGerund => gerund vp ! Imperf
                 })
                (predV vv) ;

    ComplVS v s  = insertObj (\\_ => "," ++ "��" ++ s.s) (predV v) ;
    ComplVQ v q  = insertObj (\\_ => q.s ! QDir) (predV v) ;

    ComplVA v ap = 
      insertObj (\\agr => ap.s ! aform agr.gn Indef (RObj Acc)) (predV v) ;


    SlashV2A v ap = 
      insertSlashObj2 (\\a => ap.s ! aform a.gn Indef (RObj Acc)) (slashV v v.c2) ;

    -- test: I saw a boy to whom she said that they are here
    SlashV2S v s  = insertSlashObj2 (\\_ => "," ++ "��" ++ s.s) (slashV v v.c2) ;

    -- test: I saw a boy whom she asked who is here
    SlashV2Q v q  = insertSlashObj2 (\\_ => q.s ! QDir) (slashV v v.c2) ;

    -- test: I saw a boy whom she begged to walk 
    SlashV2V vv vp =
      insertSlashObj2 (\\agr => vv.c3.s ++ daComplex Simul Pos vp ! Perf ! agr) (slashV vv vv.c2) ;

    -- test: I saw a car whom she wanted to buy
    SlashVV vv slash = {
      s = vv.s ;
      ad = {isEmpty=True; s=[]};
      compl1 = daComplex Simul Pos {s=slash.s; ad=slash.ad; compl=slash.compl1; vtype=slash.vtype} ! Perf ;
      compl2 = slash.compl2 ;
      vtype  = vv.vtype ;
      c2 = slash.c2
      } ;

    -- test: I saw a car whom she begged me to buy
    SlashV2VNP vv np slash = {
      s = vv.s ;
      ad = {isEmpty=True; s=[]};
      compl1 = \\agr => vv.c2.s ++ np.s ! RObj vv.c2.c ++ 
                        daComplex Simul Pos {s=slash.s; ad=slash.ad; compl=slash.compl1; vtype=slash.vtype} ! Perf ! np.a ;
      compl2 = slash.compl2 ;
      vtype = vv.vtype ;
      c2 = slash.c2
      } ;

    ComplSlash slash np = {
      s   = slash.s ;
      ad  = slash.ad ;
      compl = \\a => slash.compl1 ! a ++ slash.c2.s ++ np.s ! RObj slash.c2.c ++ slash.compl2 ! a ;
      vtype = slash.vtype
      } ;

    UseComp comp = insertObj comp.s (predV verbBe) ;

    UseCopula = predV verbBe ;

    AdvVP vp adv = insertObj (\\_ => adv.s) vp ;
    AdvVPSlash vp adv = insertSlashObj1 (\\_ => adv.s) vp ;

    AdVVP adv vp = {
      s   = vp.s ;
      ad  = {isEmpty=False; s=vp.ad.s ++ adv.s} ;
      compl = vp.compl ;
      vtype = vp.vtype
      } ;

    ReflVP slash = {
      s = slash.s ;
      ad = slash.ad ;
      compl = \\agr => slash.compl1 ! agr ++ slash.compl2 ! agr ;
      vtype = VMedial slash.c2.c ;
      } ;
      
    PassV2 v = insertObj (\\a => v.s ! Perf ! VPassive (aform a.gn Indef (RObj Acc))) (predV verbBe) ;

    CompAP ap = {s = \\agr => ap.s ! aform agr.gn Indef (RObj Acc)} ;
    CompNP np = {s = \\_ => np.s ! RObj Acc} ;
    CompAdv a = {s = \\_ => a.s} ;
    CompCN cn = {s = \\agr => cn.s ! (NF (numGenNum agr.gn) Indef)} ;

    VPSlashPrep vp prep = vp ** {c2 = prep ; compl1 = vp.compl ; compl2 = \\_ => []} ; ---- AR

}

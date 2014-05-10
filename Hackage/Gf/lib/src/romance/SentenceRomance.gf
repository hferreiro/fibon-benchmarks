incomplete concrete SentenceRomance of Sentence = 
  CatRomance ** open Prelude, CommonRomance, ResRomance in {

  flags optimize=all_subs ;

  lin
    PredVP np vp = mkClausePol np.isNeg (np.s ! Nom).comp np.hasClit np.isPol np.a vp ;

    PredSCVP sc vp = mkClause (sc.s ! Nom) False False (agrP3 Masc Sg) vp ;

    ImpVP vp = {
      s = \\p,i,g => case i of {
        ImpF n b => mkImperative b P2 vp ! p ! g ! n ---- AgPol ?
        }
      } ;

    SlashVP np v2 = 
      -- agreement decided afterwards: la fille qu'il a trouv�e
      {s = \\a => 
          let 
-----            vp = v2
            vp = case <v2.c2.c, v2.c2.isDir> of {
              <Acc,True> => insertAgr a v2 ;
             _ => v2
              }
          in (mkClausePol np.isNeg (np.s ! Nom).comp False      np.isPol np.a vp).s ;
-----     in (mkClausePol np.isNeg (np.s ! Nom).comp np.hasClit np.isPol np.a vp).s ;
       c2 = v2.c2
      } ;

    AdvSlash slash adv = {
      s  = \\ag,d,t,a,b,m => slash.s ! ag ! d ! t ! a ! b ! m ++ adv.s ;
      c2 = slash.c2
      } ;

    SlashPrep cl prep = {
      s  = \\_ => cl.s ; 
      c2 = {s = prep.s ; c = prep.c ; isDir = False}
      } ;

    SlashVS np vs slash = 
      {s = \\ag =>
        (mkClausePol np.isNeg
          (np.s ! Nom).comp False np.isPol np.a
          (insertExtrapos (\\b => conjThat ++ slash.s ! ag ! (vs.m ! b))
            (predV vs))
        ).s ;
       c2 = slash.c2
      } ;

    EmbedS  s  = {s = \\_ => conjThat ++ s.s ! Indic} ; --- mood
    EmbedQS qs = {s = \\_ => qs.s ! QIndir} ;
    EmbedVP vp = {s = \\c => prepCase c ++ infVP vp (agrP3 Masc Sg)} ; --- agr ---- compl

    UseCl  t p cl = {
      s = \\o => t.s ++ p.s ++ cl.s ! DDir ! t.t ! t.a ! p.p ! o
    } ;
    UseQCl t p cl = {
      s = \\q => t.s ++ p.s ++ cl.s ! t.t ! t.a ! p.p ! q
    } ;
    UseRCl t p cl = {
      s = \\r,ag => t.s ++ p.s ++ cl.s ! ag ! t.t ! t.a ! p.p ! r ; 
      c = cl.c
      } ;
    UseSlash t p cl = {
      s = \\ag,mo => 
          t.s ++ p.s ++ cl.s ! ag ! DDir ! t.t ! t.a ! p.p ! mo ;
      c2 = cl.c2
    } ;

    AdvS a s = {s = \\o => a.s ++ s.s ! o} ;
    ExtAdvS a s = {s = \\o => a.s ++ "," ++ s.s ! o} ;

    SSubjS a s b = {s = \\m => a.s ! m ++ s.s ++ b.s ! s.m} ;

    RelS s r = {
      s = \\o => s.s ! o ++ "," ++ partQIndir ++ r.s ! Indic ! agrP3 Masc Sg
      } ;

}

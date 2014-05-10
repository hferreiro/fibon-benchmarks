--# -path=.:../abstract:../common:../../prelude

--1 Latlish auxiliary operations.

resource ResLat = ParamX ** open Prelude in {

param
  Gender = Masc | Fem | Neutr ;
  Case = Nom | Acc | Gen | Dat | Abl | Voc ;
--  Degree = DPos | DComp | DSup ;

oper
  Noun : Type = {s : Number => Case => Str ; g : Gender} ;
  Adjective : Type = {s : Gender => Number => Case => Str} ;

  -- worst case

  mkNoun : (n1,_,_,_,_,_,_,_,_,n10 : Str) -> Gender -> Noun = 
    \sn,sa,sg,sd,sab,sv,pn,pa,pg,pd, g -> {
    s = table {
      Sg => table {
        Nom => sn ;
        Acc => sa ;
        Gen => sg ;
        Dat => sd ;
        Abl => sab ;
        Voc => sv
        } ;
      Pl => table {
        Nom | Voc => pn ;
        Acc => pa ;
        Gen => pg ;
        Dat | Abl => pd
        }
      } ;
    g = g
    } ;

  -- declensions

  noun1 : Str -> Noun = \mensa ->
    let 
      mensae = mensa + "e" ;
      mensis = init mensa + "is" ;
    in
    mkNoun 
      mensa (mensa +"m") mensae mensae mensa mensa
      mensae (mensa + "s") (mensa + "rum") mensis
      Fem ;

  noun2us : Str -> Noun = \servus ->
    let
      serv = Predef.tk 2 servus ;
      servum = serv + "um" ;
      servi = serv + "i" ;
      servo = serv + "o" ;
    in
    mkNoun 
      servus servum servi servo servo (serv + "e")
      servi (serv + "os") (serv + "orum") (serv + "is")
      Masc ;

  noun2er : Str -> Noun = \puer ->
    let
      puerum = puer + "um" ;
      pueri = puer + "i" ;
      puero = puer + "o" ;
    in
    mkNoun 
      puer puerum pueri puero puero (puer + "e")
      pueri (puer + "os") (puer + "orum") (puer + "is")
      Masc ;

  noun2um : Str -> Noun = \bellum ->
    let
      bell = Predef.tk 2 bellum ;
      belli = bell + "i" ;
      bello = bell + "o" ;
      bella = bell + "a" ;
    in
    mkNoun 
      bellum bellum belli bello bello (bell + "e")
      bella bella (bell + "orum") (bell + "is")
      Neutr ;

-- smart paradigm for declensions 1&2

  noun12 : Str -> Noun = \verbum -> 
    case verbum of {
      _ + "a"  => noun1 verbum ;
      _ + "us" => noun2us verbum ;
      _ + "um" => noun2um verbum ;
      _ + "er" => noun2er verbum ;
      _  => Predef.error ("noun12 does not apply to" ++ verbum)
      } ;

  noun3c : Str -> Str -> Gender -> Noun = \rex,regis,g ->
    let
      reg = Predef.tk 2 regis ;
      rege : Str = case rex of {
        _ + "e" => reg + "i" ;
        _ + ("al" | "ar") => rex + "i" ;
        _ => reg + "e"
        } ;
      regemes : Str * Str = case g of {
        Neutr => <rex,reg + "a"> ;
        _     => <reg + "em", reg + "es">
        } ;
    in
    mkNoun
      rex regemes.p1 (reg + "is") (reg + "i") rege rex
      regemes.p2 regemes.p2 (reg + "um") (reg + "ibus") 
      g ;


  noun3 : Str -> Noun = \labor -> 
    case labor of {
      _    + "r"   => noun3c labor (labor + "is")    Masc ;
      fl   + "os"  => noun3c labor (fl    + "oris")  Masc ;
      lim  + "es"  => noun3c labor (lim   + "itis")  Masc ;
      cod  + "ex"  => noun3c labor (cod   + "icis")  Masc ;
      poem + "a"   => noun3c labor (poem  + "atis")  Neutr ;
      calc + "ar"  => noun3c labor (calc  + "aris")  Neutr ;
      mar  + "e"   => noun3c labor (mar   + "is")    Neutr ;
      car  + "men" => noun3c labor (car   + "minis") Neutr ;
      rob  + "ur"  => noun3c labor (rob   + "oris")  Neutr ;
      temp + "us"  => noun3c labor (temp  + "oris")  Neutr ;
      vers + "io"  => noun3c labor (vers  + "ionis") Fem ;
      imag + "o"   => noun3c labor (imag  + "inis")  Fem ;
      ae   + "tas" => noun3c labor (ae    + "tatis") Fem ;
      vo   + "x"   => noun3c labor (vo    + "cis")   Fem ;
      pa   + "rs"  => noun3c labor (pa    + "rtis")  Fem ;
      cut  + "is"  => noun3c labor (cut   + "is")    Fem ;
      urb  + "s"   => noun3c labor (urb   + "is")    Fem ;
      _  => Predef.error ("noun3 does not apply to" ++ labor)
      } ;

  noun4us : Str -> Noun = \fructus -> 
    let
      fructu = init fructus ;
      fruct  = init fructu
    in
    mkNoun
      fructus (fructu + "m") fructus (fructu + "i") fructu fructus
      fructus fructus (fructu + "um") (fruct + "ibus")
      Masc ;

  noun4u : Str -> Noun = \cornu -> 
    let
      corn = init cornu ;
      cornua = cornu + "a"
    in
    mkNoun
      cornu cornu (cornu + "s") (cornu + "i") cornu cornu
      cornua cornua (cornu + "um") (corn + "ibus")
      Neutr ;

  noun5 : Str -> Noun = \res -> 
    let
      re = init res ;
      rei = re + "i"
    in
    mkNoun
      res (re+ "m") rei rei re res
      res res (re + "rum") (re + "bus")
      Fem ;

-- to change the default gender

    nounWithGen : Gender -> Noun -> Noun = \g,n ->
      {s = n.s ; g = g} ;

-- smart paradigms

  noun_ngg : Str -> Str -> Gender -> Noun = \verbum,verbi,g -> 
    let s : Noun = case <verbum,verbi> of {
      <_ + "a",  _ + "ae"> => noun1 verbum ;
      <_ + "us", _ + "i">  => noun2us verbum ;
      <_ + "um", _ + "i">  => noun2um verbum ;
      <_ + "er", _ + "i">  => noun2er verbum ;
      <_ + "us", _ + "us"> => noun4us verbum ;
      <_ + "u",  _ + "us"> => noun4u verbum ;
      <_ + "es", _ + "ei"> => noun5 verbum ;
      _  => noun3c verbum verbi g
      }
    in  
    nounWithGen g s ;

  noun : Str -> Noun = \verbum -> 
    case verbum of {
      _ + "a"  => noun1 verbum ;
      _ + "us" => noun2us verbum ;
      _ + "um" => noun2um verbum ;
      _ + "er" => noun2er verbum ;
      _ + "u"  => noun4u verbum ;
      _ + "es" => noun5 verbum ;
      _  => noun3 verbum
      } ;



-- adjectives

  mkAdjective : (_,_,_ : Noun) -> Adjective = \bonus,bona,bonum -> {
    s = table {
      Masc  => bonus.s ;
      Fem   => bona.s ;
      Neutr => bonum.s 
      }
    } ;
    
  adj12 : Str -> Adjective = \bonus ->
    let
      bon : Str = case bonus of {
       pulch + "er" => pulch + "r" ;
       bon + "us" => bon ;
       _ => Predef.error ("adj12 does not apply to" ++ bonus)
       }
    in
    mkAdjective (noun12 bonus) (noun1 (bon + "a")) (noun2um (bon + "um")) ;

  adj3x : (_,_ : Str) -> Adjective = \acer,acris ->
   let
     ac = Predef.tk 2 acer ;
     acrise : Str * Str = case acer of {
       _ + "er" => <ac + "ris", ac + "re"> ; 
       _ + "is" => <acer      , ac + "e"> ;
       _        => <acer      , acer> 
       }
   in
   mkAdjective 
     (noun3adj acer acris Masc) 
     (noun3adj acrise.p1 acris Fem) 
     (noun3adj acrise.p2 acris Neutr) ;

  noun3adj : Str -> Str -> Gender -> Noun = \audax,audacis,g ->
    let 
      audac   = Predef.tk 2 audacis ;
      audacem = case g of {Neutr => audax ; _ => audac + "em"} ;
      audaces = case g of {Neutr => audac +"ia" ; _ => audac + "es"} ;
      audaci  = audac + "i" ;
    in
    mkNoun
      audax audacem (audac + "is") audaci audaci audax
      audaces audaces (audac + "ium") (audac + "ibus") 
      g ;


-- smart paradigm

  adj123 : Str -> Str -> Adjective = \bonus,boni ->
    case <bonus,boni> of {
      <_ + ("us" | "er"), _ + "i">  => adj12 bonus ;
      <_ + ("us" | "er"), _ + "is"> => adj3x bonus boni ;
      <_                , _ + "is"> => adj3x bonus boni ;
      _ => Predef.error ("adj123: not applicable to" ++ bonus ++ boni)
    } ;

  adj : Str -> Adjective = \bonus ->
    case bonus of {
      _ + ("us" | "er") => adj12 bonus ;
      facil + "is"      => adj3x bonus bonus ;
      feli  + "x"       => adj3x bonus (feli + "cis") ;
      _                 => adj3x bonus (bonus + "is") ---- any example?
    } ;


-- verbs

  param 
  VActForm  = VAct VAnter VTense Number Person ;
  VPassForm = VPass VTense Number Person ;
  VInfForm  = VInfActPres | VInfActPerf ;
  VImpForm  = VImpPres Number | VImpFut2 Number | VImpFut3 Number ;
  VGerund   = VGenAcc | VGenGen |VGenDat | VGenAbl ;
  VSupine   = VSupAcc | VSupAbl ;

  VAnter = VSim | VAnt ;
  VTense = VPres VMood | VImpf VMood | VFut ; 
  VMood  = VInd | VConj ;

  oper
  Verb : Type = {
    act  : VActForm => Str ;
--    pass : VPassForm => Str ;
    inf  : VAnter => Str ;
--    imp  : VImpForm => Str ;
--    ger  : VGerund => Str ;
--    sup  : VSupine => Str ;
--    partActPres  : Adjective ;
--    partActFut   : Adjective ;
--    partPassPerf : Adjective ;
--    partPassFut  : Adjective ;
    } ;

  mkVerb : 
    (cela,cele,celab,celo,celant,celare,celavi,celatus,celabo,celabunt,celabi : Str) 
      -> Verb = 
    \cela,cele,celab,celo,celant,celare,celavi,celatus,celabo,celabunt,celabi -> 
    let
      celav = init celavi
    in {
      act = table {
        VAct VSim (VPres VInd)  Sg P1 => celo ; 
        VAct VSim (VPres VInd)  Pl P3 => celant ; 
        VAct VSim (VPres VInd)  n  p  => cela + actPresEnding n p ;
        VAct VSim (VPres VConj) n  p  => cele + actPresEnding n p ;
        VAct VSim (VImpf VInd)  n  p  => celab + "ba" + actPresEnding n p ;
        VAct VSim (VImpf VConj) n  p  => celare + actPresEnding n p ;
        VAct VSim VFut          Sg P1 => celabo ;
        VAct VSim VFut          Pl P3 => celabunt ;
        VAct VSim VFut          n  p  => celabi + actPresEnding n p ;
        VAct VAnt (VPres VInd)  Pl P3 => celav + "erunt" ; 
        VAct VAnt (VPres VInd)  n  p  => celavi + actPerfEnding n p ;
        VAct VAnt (VPres VConj) n  p  => celav + "eri" + actPresEnding n p ;
        VAct VAnt (VImpf VInd)  n  p  => celav + "era" + actPresEnding n p ;
        VAct VAnt (VImpf VConj) n  p  => celav + "isse" + actPresEnding n p ;
        VAct VAnt VFut          Sg P1 => celav + "ero" ;
        VAct VAnt VFut          n  p  => celav + "eri" + actPresEnding n p
        } ;
      inf = table {
        VSim => celare ;
        VAnt => celav + "isse"
        }
      } ;

  actPresEnding : Number -> Person -> Str = 
    useEndingTable <"m", "s", "t", "mus", "tis", "nt"> ;

  actPerfEnding : Number -> Person -> Str = 
    useEndingTable <"", "sti", "t", "mus", "stis", "erunt"> ;

  useEndingTable : (Str*Str*Str*Str*Str*Str) -> Number -> Person -> Str = 
    \es,n,p -> case n of {
      Sg => case p of {
        P1 => es.p1 ;
        P2 => es.p2 ;
        P3 => es.p3
        } ;
      Pl => case p of {
        P1 => es.p4 ;
        P2 => es.p5 ;
        P3 => es.p6
        }
      } ;

  esse_V : Verb = 
    let
      esse = mkVerb "es" "si" "era" "sum" "sunt" "esse" "fui" "*futus"
                    "ero" "erunt" "eri" ;
    in {
      act = table {
        VAct VSim (VPres VInd)  Sg P2 => "es" ; 
        VAct VSim (VPres VInd)  Pl P1 => "sumus" ; 
        v => esse.act ! v
        } ;
      inf = esse.inf
      } ;

  verb1 : Str -> Verb = \celare ->
    let 
      cela = Predef.tk 2 celare ;
      cel  = init cela ;
      celo = cel + "o" ;
      cele = cel + "e" ;
      celavi = cela + "vi" ;
      celatus = cela + "tus" ;
    in mkVerb cela cele cela celo (cela + "nt") celare celavi celatus 
              (cela + "bo") (cela + "bunt") (cela + "bi") ;

  verb2 : Str -> Verb = \habere ->
    let 
      habe = Predef.tk 2 habere ;
      hab  = init habe ;
      habeo = habe + "o" ;
      habea = habe + "a" ;
      habui = hab + "ui" ;
      habitus = hab + "itus" ;
    in mkVerb habe habea habe habeo (habe + "nt") habere habui habitus
              (habe + "bo") (habe + "bunt") (habe + "bi") ;

  verb3 : (_,_,_ : Str) -> Verb = \gerere,gessi,gestus ->
    let 
      gere = Predef.tk 2 gerere ;
      ger  = init gere ;
      gero = ger + "o" ;
      geri = ger + "i" ;
      gera = ger + "a" ;
    in mkVerb geri gera gere gero (ger + "unt") gerere gessi gestus
              (ger + "am") (ger + "ent") gere ; 

  verb3i : (_,_,_ : Str) -> Verb = \iacere,ieci,iactus ->
    let 
      iac   = Predef.tk 3 iacere ;
      iaco  = iac + "io" ;
      iaci  = iac + "i" ;
      iacie = iac + "ie" ;
      iacia = iac + "ia" ;
    in mkVerb iaci iacia iacie iaco (iaci + "unt") iacere ieci iactus
              (iac + "iam") (iac + "ient") iacie ; 

  verb4 : (_,_,_ : Str) -> Verb = \sentire,sensi,sensus ->
    let 
      senti  = Predef.tk 2 sentire ;
      sentio = senti + "o" ;
      sentia = senti + "a" ;
      sentie = senti + "e" ;
    in mkVerb senti sentia sentie sentio (senti + "unt") sentire sensi sensus
              (senti + "am") (senti + "ent") sentie ; 


-- smart paradigms

  verb_pppi : (iacio,ieci,iactus,iacere : Str) -> Verb = 
    \iacio,ieci,iactus,iacere ->
    case iacere of {
    _ + "are" => verb1 iacere ;
    _ + "ire" => verb4 iacere ieci iactus ;
    _ + "ere" => case iacio of {
      _ + "eo" => verb2 iacere ;
      _ + "io" => verb3i iacere ieci iactus ;
      _ => verb3 iacere ieci iactus
      } ;
    _ => Predef.error ("verb_pppi: illegal infinitive form" ++ iacere) 
    } ;

  verb : (iacere : Str) -> Verb = 
    \iacere ->
    case iacere of {
    _ + "are" => verb1 iacere ;
    _ + "ire" => let iaci = Predef.tk 2 iacere 
                 in verb4 iacere (iaci + "vi") (iaci + "tus") ;
    _ + "ere" => verb2 iacere ;
    _ => Predef.error ("verb: illegal infinitive form" ++ iacere) 
    } ;

-- pronouns

  Pronoun : Type = {
    s : Case => Str ;
    g : Gender ;
    n : Number ;
    p : Person ;
    } ;

  mkPronoun : (_,_,_,_,_ : Str) -> Gender -> Number -> Person -> Pronoun = 
    \ego,me,mei,mihi,mee,g,n,p -> {
      s = pronForms ego me mei mihi mee ;
      g = g ;
      n = n ;
      p = p
      } ;

  pronForms : (_,_,_,_,_ : Str) -> Case => Str = 
    \ego,me,mei,mihi,mee -> table Case [ego ; me ; mei ; mihi ; mee ; ego] ;

  personalPronoun : Gender -> Number -> Person -> Pronoun = \g,n,p -> {
    s = case <g,n,p> of {
      <_,Sg,P1> => pronForms "ego" "me" "mei" "mihi" "me" ;
      <_,Sg,P2> => pronForms "tu"  "te" "tui" "tibi" "te" ;
      <_,Pl,P1> => pronForms "nos" "nos" "nostri" "nobis" "nobis" ; --- nostrum
      <_,Pl,P2> => pronForms "vos" "vos" "vestri" "vobis" "vobis" ; --- vestrum
      <Masc, Sg,P3> => pronForms "is" "eum" "eius" "ei" "eo" ;
      <Fem,  Sg,P3> => pronForms "ea" "eam" "eius" "ei" "ea" ;
      <Neutr,Sg,P3> => pronForms "id" "id"  "eius" "ei" "eo" ;
      <Masc, Pl,P3> => pronForms "ii" "eos" "eorum" "iis" "iis" ;
      <Fem,  Pl,P3> => pronForms "ii" "eas" "earum" "iis" "iis" ;
      <Neutr,Pl,P3> => pronForms "ea" "ea"  "eorum" "iis" "iis"
      } ;
    g = g ;
    n = n ;
    p = p
    } ;

  Preposition : Type = {s : Str ; c : Case} ;

  VP : Type = {
    fin : VActForm => Str ;
    inf : VAnter => Str ;
    obj : Str ;
    adj : Gender => Number => Str
  } ;

  VPSlash = VP ** {c2 : Preposition} ;

  predV : Verb -> VP = \v -> {
    fin = v.act ;
    inf = v.inf ;
    obj = [] ;
    adj = \\_,_ => []
  } ;

  predV2 : (Verb ** {c : Preposition}) -> VPSlash = \v -> predV v ** {c2 = v.c} ;

  appPrep : Preposition -> (Case => Str) -> Str = \c,s -> c.s ++ s ! c.c ;

  insertObj : Str -> VP -> VP = \obj,vp -> {
    fin = vp.fin ;
    inf = vp.inf ;
    obj = obj ++ vp.obj ;
    adj = vp.adj
  } ;

  insertAdj : (Gender => Number => Case => Str) -> VP -> VP = \adj,vp -> {
    fin = vp.fin ;
    inf = vp.inf ;
    obj = vp.obj ;
    adj = \\g,n => adj ! g ! n ! Nom ++ vp.adj ! g ! n
  } ;

  Clause = {s : VAnter => VTense => Polarity => Str} ;

  mkClause : Pronoun -> VP -> Clause = \np,vp -> {
    s = \\a,t,p => np.s ! Nom ++ vp.obj ++ vp.adj ! np.g ! np.n ++ negation p ++ 
        vp.fin ! VAct a t np.n np.p
  } ;
    
  negation : Polarity -> Str = \p -> case p of {
    Pos => [] ;   
    Neg => "non"
  } ;

-- determiners

  Determiner : Type = {
    s,sp : Gender => Case => Str ;
    n : Number
    } ;

  Quantifier : Type = {
    s,sp : Number => Gender => Case => Str ;
    } ;

  mkQuantifG : (_,_,_,_,_ : Str) -> (_,_,_,_ : Str) -> (_,_,_ : Str) -> 
    Gender => Case => Str = 
    \mn,ma,mg,md,mab, fno,fa,fg,fab, nn,ng,nab -> table {
      Masc  => pronForms mn  ma mg md mab ;
      Fem   => pronForms fno fa fg md fab ;
      Neutr => pronForms nn  nn ng md nab     
    } ;
      
  mkQuantifier : (sg,pl : Gender => Case => Str) -> Quantifier = \sg,pl ->
    let ssp = table {Sg => sg ; Pl => pl}
    in {
      s  = ssp ;
      sp = ssp 
      } ;

  hic_Quantifier = mkQuantifier
    (mkQuantifG 
       "hic" "hunc" "huius" "huic" "hoc"  "haec" "hanc" "huius" "hac"  "hoc" "huius" "hoc")
    (mkQuantifG 
       "hi" "hos" "horum" "his" "his"  "hae" "has" "harum" "his"  "haec" "horum" "his")
    ;

  ille_Quantifier = mkQuantifier
    (mkQuantifG 
       "ille" "illum" "illius" "illi" "illo"  
       "illa" "illam" "illius" "illa"  
       "illud" "illius" "illo")
    (mkQuantifG 
       "illi" "illos" "illorum" "illis" "illis"  
       "illae" "illas" "illarum" "illis"  
       "illa" "illorum" "illis")
    ;

  mkPrep : Str -> Case -> {s : Str ; c : Case} = \s,c -> {s = s ; c = c} ;

param
  Unit = one | ten | hundred | thousand | ten_thousand | hundred_thousand ;

}


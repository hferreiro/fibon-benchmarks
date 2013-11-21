--# -path=.:../scandinavian:../common:../abstract:../../prelude

concrete IrregSwe of IrregSweAbs = CatSwe ** open ParadigmsSwe in {

  flags optimize=values ;

  lin
  anfalla_V = irregV "anfalla" "anf�ll" "anfallit" ;
  angiva_V = irregV "angiva" "angav" "angivit" ;
  angripa_V = irregV "angripa" "angrep" "angripit" ;
  anh�lla_V = irregV "anh�lla" "anh�ll" "anh�llit" ;
  antaga_V = irregV "antaga" "antog" "antagit" ;
  �ta_V = irregV "�ta" "�t" "�tit" ;
  �terfinna_V = irregV "�terfinna" "�terfann" "�terfunnit" ;
  avbryta_V = irregV "avbryta" "avbr�t" "avbrutit" ;
  avfalla_V = irregV "avfalla" "avf�ll" "avfallit" ;
  avhugga_V = irregV "avhugga" "avh�gg" "avhuggit" ;
  avlida_V = irregV "avlida" "avled" "avlidit" ;
  avnjuta_V = irregV "avnjuta" "avnj�t" "avnjutit" ;
  avsitta_V = irregV "avsitta" "avsatt" "avsuttit" ;
  avskriva_V = irregV "avskriva" "avskrev" "avskrivit" ;
  avstiga_V = irregV "avstiga" "avsteg" "avstigit" ;
  b�ra_V = irregV "b�ra" "bar" "burit" ;
  bedraga_V = irregV "bedraga" "bedrog" "bedragit" ;
  bedriva_V = irregV "bedriva" "bedrev" "bedrivit" ;
  befinna_V = irregV "befinna" "befann" "befunnit" ;
  begrava_V = irregV "begrava" "begrov" "begravit" ;
  beh�lla_V = irregV "beh�lla" "beh�ll" "beh�llit" ;
  beljuga_V = irregV "beljuga" "belj�g" "beljugit" ;
  berida_V = irregV "berida" "bered" "beridit" ;
  besitta_V = irregV "besitta" "besatt" "besuttit" ;
  beskriva_V = irregV "beskriva" "beskrev" "beskrivit" ;
  besluta_V = irregV "besluta" "besl�t" "beslutit" ;
  bestiga_V = irregV "bestiga" "besteg" "bestigit" ;
  bestrida_V = irregV "bestrida" "bestred" "bestridit" ;
  bidraga_V = irregV "bidraga" "bidrog" "bidragit" ;
  bifalla_V = irregV "bifalla" "bif�ll" "bifallit" ;
  binda_V = irregV "binda" "band" "bundit" ;
  bita_V = irregV "bita" "bet" "bitit" ;
  bjuda_V = irregV "bjuda" "bj�d" "bjudit" ;
  bliva_V = irregV "bli" "blev" "blivit" ;
  borttaga_V = irregV "borttaga" "borttog" "borttagit" ;
  brinna_V = irregV "brinna" "brann" "brunnit" ;
  brista_V = irregV "brista" "brast" "brustit" ;
  bryta_V = irregV "bryta" "br�t" "brutit" ;
  d�_V = irregV "d�" "dog" "d�tt" ;
  draga_V = mkV (variants { "dra"; "draga"}) (variants { "drar" ;
                "drager"}) (variants { "dra" ; "drag" }) "drog" "dragit" "dragen" ;
  dricka_V = irregV "dricka" "drack" "druckit" ;
  driva_V = irregV "driva" "drev" "drivit" ;
  drypa_V = irregV "drypa" "dr�p" "drupit" ;
  duga_V = irregV "duga" "d�g" "dugit" ;
  dyka_V = irregV "dyka" "d�k" "dukit" ;
  erbjuda_V = irregV "erbjuda" "erbj�d" "erbjudit" ;
  erfara_V = irregV "erfara" "erfor" "erfarit" ;
  erh�lla_V = irregV "erh�lla" "erh�ll" "erh�llit" ;
  falla_V = irregV "falla" "f�ll" "fallit" ;
  f�nga_V = irregV "f�nga" "f�ng" "f�ngit" ;
  fara_V = irregV "fara" "for" "farit" ;
  finna_V = irregV "finna" "fann" "funnit" ;
  flyga_V = irregV "flyga" "fl�g" "flugit" ;
  flyta_V = irregV "flyta" "fl�t" "flutit" ;
  f�rbeh�lla_V = irregV "f�rbeh�lla" "f�rbeh�ll" "f�rbeh�llit" ;
  f�rbinda_V = irregV "f�rbinda" "f�rband" "f�rbundit" ;
  f�rbjuda_V = irregV "f�rbjuda" "f�rbj�d" "f�rbjudit" ;
  f�rdriva_V = irregV "f�rdriva" "f�rdrev" "f�rdrivit" ;
  f�reskriva_V = irregV "f�reskriva" "f�reskrev" "f�reskrivit" ;
  f�retaga_V = irregV "f�retaga" "f�retog" "f�retagit" ;
  f�rfrysa_V = irregV "f�rfrysa" "f�rfr�s" "f�rfrusit" ;
  f�rl�ta_V = irregV "f�rl�ta" "f�rl�t" "f�rl�tit" ;
  f�rnimma_V = irregV "f�rnimma" "f�rnamm" "f�rnummit" ;
  f�rsitta_V = irregV "f�rsitta" "f�rsatt" "f�rsuttit" ;
  f�rsvinna_V = irregV "f�rsvinna" "f�rsvann" "f�rsvunnit" ;
  f�rtiga_V = irregV "f�rtiga" "f�rteg" "f�rtigit" ;
  frysa_V = irregV "frysa" "fr�s" "frusit" ;
  g�_V = irregV "g�" "gick" "g�tt" ;
  g�ra_V = mkV "g�ra" "g�r" "g�r" "gjorde" "gjort" "gjord" ;
  genomdriva_V = irregV "genomdriva" "genomdrev" "genomdrivit" ;
  gilla_V = irregV "gilla" "gall" "gillit" ;
  giva_V = irregV "ge" "gav" "givit" ;
  gjuta_V = irregV "gjuta" "gj�t" "gjutit" ;
  glida_V = irregV "glida" "gled" "glidit" ;
  gnida_V = irregV "gnida" "gned" "gnidit" ;
  gr�ta_V = irregV "gr�ta" "gr�t" "gr�tit" ;
  gripa_V = irregV "gripa" "grep" "gripit" ;
  h�lla_V = irregV "h�lla" "h�ll" "h�llit" ;
  hinna_V = irregV "hinna" "hann" "hunnit" ;
  hugga_V = irregV "hugga" "h�gg" "huggit" ;
  iakttaga_V = irregV "iakttaga" "iakttog" "iakttagit" ;
  inbegripa_V = irregV "inbegripa" "inbegrep" "inbegripit" ;
  inbjuda_V = irregV "inbjuda" "inbj�d" "inbjudit" ;
  indraga_V = irregV "indraga" "indrog" "indragit" ;
  innesluta_V = irregV "innesluta" "innesl�t" "inneslutit" ;
  inskriva_V = irregV "inskriva" "inskrev" "inskrivit" ;
  intaga_V = irregV "intaga" "intog" "intagit" ;
  k�nna_V = irregV "k�nna" "k�nde" "k�nt" ;
  kl�mma_V = regV "kl�mmer" ;
  kliva_V = irregV "kliva" "klev" "klivit" ;
  klyva_V = irregV "klyva" "kl�v" "kluvit" ;
  knipa_V = irregV "knipa" "knep" "knipit" ;
  knyta_V = irregV "knyta" "kn�t" "knutit" ;
  komma_V = irregV "komma" "kom" "kommit" ;
  krypa_V = irregV "krypa" "kr�p" "krupit" ;
  kunna_V = mkV "kunna" "kan" "kan" "kunde" "kunnat" "k�nd" ;
  kvida_V = irregV "kvida" "kved" "kvidit" ;
  l�ta_V = irregV "l�ta" "l�t" "l�tit" ;
  leva_V = irregV "leva" "levde" "levt" ;
  ligga_V = irregV "ligga" "l�g" "legat" ;
  ljuda_V = irregV "ljuda" "lj�d" "ljudit" ;
  ljuga_V = irregV "ljuga" "lj�g" "ljugit" ;
  ljuta_V = irregV "ljuta" "lj�t" "ljutit" ;
  l�gga_V = irregV "l�gga" "lade" "lagt" ;
  mottaga_V = irregV "mottaga" "mottog" "mottagit" ;
  nerstiga_V = irregV "nerstiga" "nersteg" "nerstigit" ;
  niga_V = irregV "niga" "neg" "nigit" ;
  njuta_V = irregV "njuta" "nj�t" "njutit" ;
  omgiva_V = irregV "omgiva" "omgav" "omgivit" ;
  �verfalla_V = irregV "�verfalla" "�verf�ll" "�verfallit" ;
  �vergiva_V = irregV "�vergiva" "�vergav" "�vergivit" ;
  pipa_V = irregV "pipa" "pep" "pipit" ;
  rida_V = irregV "rida" "red" "ridit" ;
  rinna_V = irregV "rinna" "rann" "runnit" ;
  riva_V = irregV "riva" "rev" "rivit" ;
  ryta_V = irregV "ryta" "r�t" "rutit" ;
  s�ga_V = irregV "s�ga" "sade" "sagt" ;
  se_V = irregV "se" "s�g" "sett" ;
  sitta_V = irregV "sitta" "satt" "suttit" ;
  sjuda_V = irregV "sjuda" "sj�d" "sjudit" ;
  sjunga_V = irregV "sjunga" "sj�ng" "sjungit" ;
  sjunka_V = irregV "sjunka" "sj�nk" "sjunkit" ;
  sk�ra_V = mkV "sk�ra" "sk�r" "sk�r" "skar" "skurit" "skuren" ;
  skina_V = irregV "skina" "sken" "skinit" ;
  skita_V = irregV "skita" "sket" "skitit" ;
  skjuta_V = irregV "skjuta" "skj�t" "skjutit" ;
  skrida_V = irregV "skrida" "skred" "skridit" ;
  skrika_V = irregV "skrika" "skrek" "skrikit" ;
  skriva_V = irregV "skriva" "skrev" "skrivit" ;
  skryta_V = irregV "skryta" "skr�t" "skrutit" ;
  sl�_V = irregV "sl�" "slog" "slagit" ;
  slinka_V = irregV "slinka" "slank" "slunkit" ;
  slippa_V = irregV "slippa" "slapp" "sluppit" ;
  slita_V = irregV "slita" "slet" "slitit" ;
  sluta_V = irregV "sluta" "sl�t" "slutit" ;
  sm�rja_V = irregV "sm�rja" "smorjde" "smort" ;
  smita_V = irregV "smita" "smet" "smitit" ;
  snyta_V = irregV "snyta" "sn�t" "snutit" ;
  sova_V = irregV "sova" "sov" "sovit" ;
  spinna_V = irregV "spinna" "spann" "spunnit" ;
  spricka_V = irregV "spricka" "sprack" "spruckit" ;
  sprida_V = irregV "sprida" "spred" "spridit" ;
  springa_V = irregV "springa" "sprang" "sprungit" ;
  st�_V = irregV "st�" "stod" "st�tt" ;
  sticka_V = irregV "sticka" "stack" "stuckit" ;
  stiga_V = irregV "stiga" "steg" "stigit" ;
  stinka_V = irregV "stinka" "stank" "stunkit" ;
  strida_V = irregV "strida" "stred" "stridit" ;
  strypa_V = irregV "strypa" "str�p" "strupit" ;
  suga_V = irregV "suga" "s�g" "sugit" ;
  supa_V = irregV "supa" "s�p" "supit" ;
  sv�lla_V = irregV "sv�lla" "sv�llde" "sv�llt" ;
  svida_V = irregV "svida" "sved" "svidit" ;
  svika_V = irregV "svika" "svek" "svikit" ;
  sy_V = irregV "sy" "sydde" "sytt" ;
  s�tta_V = irregV "s�tta" "satte" "satt" ;
  taga_V = irregV "taga" "tog" "tagit" ;
  tiga_V = irregV "tiga" "teg" "tigit" ;
  till�ta_V = irregV "till�ta" "till�t" "till�tit" ;
  tillsluta_V = irregV "tillsluta" "tillsl�t" "tillslutit" ;
  tjuta_V = irregV "tjuta" "tj�t" "tjutit" ;
  tryta_V = irregV "tryta" "tr�t" "trutit" ;
  tvinga_V = irregV "tvinga" "tvang" "tvungit" ;
  uppfinna_V = irregV "uppfinna" "uppfann" "uppfunnit" ;
  uppgiva_V = irregV "uppgiva" "uppgav" "uppgivit" ;
  uppl�ta_V = irregV "uppl�ta" "uppl�t" "uppl�tit" ;
  uppstiga_V = irregV "uppstiga" "uppsteg" "uppstigit" ;
  upptaga_V = irregV "upptaga" "upptog" "upptagit" ;
  utbjuda_V = irregV "utbjuda" "utbj�d" "utbjudit" ;
  utbrista_V = irregV "utbrista" "utbrast" "utbrustit" ;
  utesluta_V = irregV "utesluta" "utesl�t" "uteslutit" ;
  utskriva_V = irregV "utskriva" "utskrev" "utskrivit" ;
  veta_V = mk6V "veta" "vet" "vet" "visste" "vetat" (variants {}) ;
  v�nda_V = irregV "v�nda" "v�nde" "v�nt" ;
  vina_V = irregV "vina" "ven" "vinit" ;
  vinna_V = irregV "vinna" "vann" "vunnit" ;
  vrida_V = irregV "vrida" "vred" "vridit" ;
}
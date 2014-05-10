--# -path=.:prelude:../abstract:../common

-- adapted from verb list in
-- http://www.iee.et.tu-dresden.de/~wernerr/grammar/verben_dt.html

concrete IrregGer of IrregGerAbs = CatGer ** open 
  ParadigmsGer,
  (M = MorphoGer)
in {

  flags optimize=values ;

  lin backen_V =  irregV "backen" "b�ckt" "backt" "backt" "gebacken" ;
  lin backen_u_V =  irregV "backen" "b�ckt" "buk" "buke" "gebacken" ;
  lin befehlen_V =  irregV "befehlen" "befiehlt" "befahl" "bef�hle" "bef�hle)" ;
  lin beginnen_V =  irregV "beginnen" "beginnt" "begann" "beg�nne" "beg�nne)" ;
  lin bei�en_V =  irregV "bei�en" "bei�t" "bi�" "bi�e" "gebissen" ;
  lin bergen_V =  irregV "bergen" "birgt" "barg" "b�rge" "geborgen" ;
  lin bersten_V =  irregV "bersten" "birst" "barst" "b�rste" "geborsten" ;
  lin bewegen_V =  irregV "bewegen" "bewegt" "bewog" "bew�ge" "bewogen" ;
  lin biegen_V =  irregV "biegen" "biegt" "bog" "b�ge" "gebogen" ;
  lin bieten_V =  irregV "bieten" "bietet" "bot" "b�te" "geboten" ;
  lin binden_V =  irregV "binden" "bindt" "band" "b�nde" "gebunden" ;
  lin bitten_V =  irregV "bitten" "bittet" "bat" "b�te" "gebeten" ;
  lin blasen_V =  irregV "blasen" "bl�st" "blies" "bliese" "geblasen" ;
  lin bleiben_V =  irregV "bleiben" "bleibt" "blieb" "bliebe" "geblieben" ;
  lin braten_V =  irregV "braten" "br�t" "briet" "briete" "gebraten" ;
  lin brechen_V =  irregV "brechen" "bricht" "brach" "br�che" "gebrochen" ;
  lin brennen_V =  irregV "brennen" "brennt" "brannte" "brennte" "gebrannt" ;
  lin bringen_V =  irregV "bringen" "bringt" "brachte" "brachte" "gebracht" ;
  lin denken_V =  irregV "denken" "denkt" "dachte" "dachte" "gedacht" ;
  lin dingen_V =  irregV "dingen" "dingt" "dingte" "dang" "gedungen" ;
  lin dreschen_V =  irregV "dreschen" "drischt" "drosch" "dr�sche" "gedroschen" ;
  lin dringen_V =  irregV "dringen" "dringt" "drang" "dr�nge" "gedrungen" ;
  lin d�rfen_V = M.mkV 
        "d�rfen" "darf" "darfst" "darf" "d�rft" "d�rf" 
        "durfte" "durftest" "durften" "durftet"
        "d�rfte" "gedurft" [] 
        M.VHaben ** {lock_V = <>} ;
  lin empfehlen_V =  irregV "empfehlen" "empfiehlt" "empfahl" 
    "empf�hle" "empfohlen" ;
  lin empfehlen_o_V =  irregV "empfehlen" "empfiehlt" "empfahl" 
    "empf�hle" "empfohlen" ;
  lin erl�schen_V =  irregV "erl�schen" "erlischt" "erlosch" "erl�sche" "erloschen" ;
  lin erkennen_V =  irregV "erkennen" "erkennt" "erkannte" "erkannte" "erkannt" ;
  lin erschrecken_V =  irregV "erschrecken" "erschrickt" "erschrak" "erschr�ke" "erschrocken" ;
  lin essen_V =  irregV "essen" "i�t" "a�" "��e" "gegessen" ;
  lin fahren_V =  irregV "fahren" "f�hrt" "fuhr" "f�hre" "gefahren" ;
  lin fallen_V =  irregV "fallen" "f�llt" "fiel" "fiele" "gefallen" ;
  lin fangen_V =  irregV "fangen" "f�ngt" "fing" "finge" "gefangen" ;
  lin fechten_V =  irregV "fechten" "fechtet" "focht" "f�chte" "gefochten" ;
  lin finden_V =  irregV "finden" "findt" "fand" "f�nde" "gefunden" ;
  lin flechten_V =  irregV "flechten" "flicht" "flocht" "fl�chte" "geflochten" ;
  lin fliegen_V =  irregV "fliegen" "fliegt" "flog" "fl�ge" "geflogen" ;
  lin fliehen_V =  irregV "fliehen" "flieht" "floh" "fl�he" "geflohen" ;
  lin flie�en_V =  irregV "flie�en" "flie�t" "flo�" "fl�sse" "geflossen" ;
  lin fressen_V =  irregV "fressen" "fri�t" "fra�" "fr��e" "gefressen" ;
  lin frieren_V =  irregV "frieren" "friert" "fror" "fr�re" "gefroren" ;
  lin g�ren_V =  irregV "g�ren" "g�rt" "g�rte" "g�re" "gegoren" ;
  lin g�ren_o_V =  irregV "g�ren" "g�rt" "gor" "g�re" "gegoren" ;
  lin geb�ren_V =  irregV "geb�ren" "gebiert" "gebar" "geb�re" "geboren" ;
  lin geben_V =  irregV "geben" "gibt" "gab" "g�be" "gegeben" ;
  lin gedeihen_V =  irregV "gedeihen" "gedeiht" "gedieh" "gediehe" "gediehen" ;
  lin gehen_V =  irregV "gehen" "geht" "ging" "ginge" "gegangen" ;
  lin gelingen_V =  irregV "gelingen" "gelingt" "gelang" "gelange" "gelungen" ;
  lin gelten_V =  irregV "gelten" "gilt" "galt" "galte" "gegolten" ;
  lin gelten_o_V =  irregV "gelten" "gilt" "galt" "golte" "gegolten" ;
  lin genesen_V =  irregV "genesen" "genest" "genas" "gen�se" "genesen" ;
  lin genie�en_V =  irregV "genie�en" "genie�t" "geno�" "gen�sse" "genossen" ;
  lin geschehen_V =  irregV "geschehen" "geschieht" "geschah" "geschehen" "gesch�he" ;
  lin gewinnen_V =  irregV "gewinnen" "gewinnt" "gewann" "gew�nne" "gewonnen" ;
  lin gewinnen_o_V =  irregV "gewinnen" "gewinnt" "gewann" "gew�nne" "gewonnen" ;
  lin gie�en_V =  irregV "gie�en" "gie�t" "go�" "g�sse" "gegossen" ;
  lin gleichen_V =  irregV "gleichen" "gleicht" "glich" "gliche" "geglichen" ;
  lin gleiten_V =  irregV "gleiten" "gleitet" "glitt" "glitte" "geglitten" ;
  lin glimmen_V =  irregV "glimmen" "glimmt" "glomm" "glimmte" "gl�mme" ;
  lin graben_V =  irregV "graben" "gr�bt" "grub" "gr�be" "gegraben" ;
  lin greifen_V =  irregV "greifen" "greift" "griff" "griffe" "gegriffen" ;
  lin haben_V =  irregV "haben" "hat" "hatte" "h�tte" "gehabt" ;
  lin halten_V =  irregV "halten" "h�lt" "hielt" "hielte" "gehalten" ;
  lin h�ngen_V =  irregV "h�ngen" "h�ngt" "hing" "hinge" "gehangen" ;
  lin hauen_V =  irregV "hauen" "haut" "hieb" "hiebe" "gehauen" ;
  lin hauen_te_V =  irregV "hauen" "haut" "haute" "haute" "gehauen" ;
  lin heben_V =  irregV "heben" "hebt" "hob" "h�be" "gehoben" ;
  lin hei�en_V =  irregV "hei�en" "hei�t" "hie�" "hie�e" "gehei�en" ;
  lin helfen_V =  irregV "helfen" "hilft" "half" "h�lfe" "geholfen" ;
  lin kennen_V =  irregV "kennen" "kennt" "kannte" "kennte" "gekannt" ;
  lin klimmen_V =  irregV "klimmen" "klimmt" "klomm" "kl�mme" "geklommen" ;
  lin klingen_V =  irregV "klingen" "klingt" "klang" "kl�nge" "geklungen" ;
  lin kneifen_V =  irregV "kneifen" "kneift" "kniff" "kniffe" "gekniffen" ;
  lin kommen_V =  irregV "kommen" "kommt" "kam" "k�me" "gekommen" ;
  lin k�nnen_V =  M.mkV 
        "k�nnen" "kann" "kannst" "kann" "k�nnt" "k�nn" 
        "konnte" "konntest" "konnten" "konntet"
        "k�nnte" "gekonnt" [] 
        M.VHaben  ** {lock_V = <>} ;
  lin kriechen_V =  irregV "kriechen" "kriecht" "kroch" "kr�che" "gekrochen" ;
  lin k�ren_V =  irregV "k�ren" "k�rt" "k�rte" "kor" "gek�rt" ;
  lin laden_V =  irregV "laden" "l�dt" "lud" "l�de" "geladen" ;
  lin lassen_V =  irregV "lassen" "l��t" "lie�" "lie�e" "gelassen" ;
  lin laufen_V =  irregV "laufen" "l�uft" "lief" "liefe" "gelaufen" ;
  lin leiden_V =  irregV "leiden" "leidt" "litt" "litte" "gelitten" ;
  lin leihen_V =  irregV "leihen" "leiht" "lieh" "liehe" "geliehen" ;
  lin lesen_V =  irregV "lesen" "liest" "las" "l�se" "gelesen" ;
  lin liegen_V =  irregV "liegen" "liegt" "lag" "l�ge" "gelegen" ;
  lin l�gen_V =  irregV "l�gen" "l�gt" "log" "l�ge" "gelogen" ;
  lin mahlen_V =  irregV "mahlen" "mahlt" "mahlte" "mahlte" "gemahlen" ;
  lin meiden_V =  irregV "meiden" "meidt" "mied" "miede" "gemieden" ;
  lin melken_V =  irregV "melken" "milkt" "molk" "m�lke" "gemolken" ;
  lin messen_V =  irregV "messen" "mi�t" "ma�" "m��e" "gemessen" ;
  lin mi�lingen_V =  irregV "mi�lingen" "mi�lingt" "mi�lang" "mi�lungen" "mi�l�nge" ;
  lin m�gen_V =  M.mkV 
        "m�gen" "mag" "magst" "mag" "m�gt" "m�g" 
        "mochte" "mochtest" "mochten" "mochtet"
        "m�chte" "gemocht" [] 
        M.VHaben ** {lock_V = <>} ;
  lin m�ssen_V = M.mkV 
        "m�ssen" "mu�" "mu�t" "mu�" "m��t" "m��" 
        "mu�te" "mu�test" "mu�ten" "mu�tet"
        "m��te" "gemu�t" [] 
        M.VHaben ** {lock_V = <>} ;
  lin nehmen_V = mk6V "nehmen" "nimmt" "nimm" "nahm" "n�hme" "genommen" ;
  lin nennen_V =  irregV "nennen" "nennt" "nannte" "nennte" "genannt" ;
  lin pfeifen_V =  irregV "pfeifen" "pfeift" "pfiff" "pfiffe" "gepfiffen" ;
  lin preisen_V =  irregV "preisen" "preist" "pries" "priese" "gepriesen" ;
  lin quellen_V =  irregV "quellen" "quillt" "quoll" "qu�lle" "gequollen" ;
  lin raten_V =  irregV "raten" "r�t" "riet" "riete" "geraten" ;
  lin reiben_V =  irregV "reiben" "reibt" "rieb" "riebe" "gerieben" ;
  lin rei�en_V =  irregV "rei�en" "rei�t" "ri�" "ri�e" "gerissen" ;
  lin reiten_V =  irregV "reiten" "reitet" "ritt" "ritte" "geritten" ;
  lin rennen_V =  irregV "rennen" "rennt" "rannte" "rennte" "gerannt" ;
  lin riechen_V =  irregV "riechen" "riecht" "roch" "r�che" "gerochen" ;
  lin ringen_V =  irregV "ringen" "ringt" "rang" "r�nge" "gerungen" ;
  lin rinnen_V =  irregV "rinnen" "rinnt" "rann" "r�nne" "geronnen" ;
  lin rufen_V =  irregV "rufen" "ruft" "rief" "riefe" "gerufen" ;
  lin salzen_V =  irregV "salzen" "salzt" "salzte" "salzte" "gesalzen" ;
  lin saufen_V =  irregV "saufen" "s�uft" "soff" "s�ffe" "gesoffen" ;
  lin saugen_V =  irregV "saugen" "saugt" "sog" "soge" "gesogen" ;
  lin schaffen_V =  irregV "schaffen" "schafft" "schuf" "sch�fe" "geschaffen" ;
  lin scheiden_V =  irregV "scheiden" "scheidt" "schied" "schiede" "geschieden" ;
  lin scheinen_V =  irregV "scheinen" "scheint" "schien" "schiene" "geschienen" ;
  lin schei�en_V =  irregV "schei�en" "schei�t" "schi�" "schi�e" "geschissen" ;
  lin schelten_V =  irregV "schelten" "schilt" "schalt" "sch�lte" "gescholten" ;
  lin scheren_V =  irregV "scheren" "schert" "schor" "sch�re" "geschoren" ;
  lin schieben_V =  irregV "schieben" "schiebt" "schob" "sch�be" "geschoben" ;
  lin schie�en_V =  irregV "schie�en" "schie�t" "scho�" "sch�sse" "geschossen" ;
  lin schinden_V =  irregV "schinden" "schindt" "schund" "schunde" "geschunden" ;
  lin schlafen_V =  irregV "schlafen" "schl�ft" "schlief" "schliefe" "geschlafen" ;
  lin schlagen_V =  irregV "schlagen" "schl�gt" "schlug" "schl�ge" "geschlagen" ;
  lin schleichen_V =  irregV "schleichen" "schleicht" "schlich" "schliche" "geschlichen" ;
  lin schleifen_V =  irregV "schleifen" "schleift" "schliff" "schliffe" "geschliffen" ;
  lin schlei�en_V =  irregV "schlei�en" "schlei�t" "schli�" "schli�" "geschlissen" ;
  lin schlie�en_V =  irregV "schlie�en" "schlie�t" "schlo�" "schl�sse" "geschlossen" ;
  lin schlingen_V =  irregV "schlingen" "schlingt" "schlang" "schl�nge" "geschlungen" ;
  lin schmei�en_V =  irregV "schmei�en" "schmei�t" "schmi�" "schmi�e" "geschmissen" ;
  lin schmelzen_V =  irregV "schmelzen" "schmilzt" "schmolz" "schm�lze" "geschmolzen" ;
  lin schneiden_V =  irregV "schneiden" "schneidt" "schnitt" "schnitte" "geschnitten" ;
  lin schreiben_V =  irregV "schreiben" "schreibt" "schrieb" "schriebe" "geschrieben" ;
  lin schreien_V =  irregV "schreien" "schreit" "schrie" "schrie" "geschrien" ;
  lin schreiten_V =  irregV "schreiten" "schreitet" "schritt" "schritte" "geschritten" ;
  lin schweigen_V =  irregV "schweigen" "schweigt" "schwieg" "schwiege" "geschwiegen" ;
  lin schwellen_V =  irregV "schwellen" "schwillt" "schwoll" "schw�lle" "geschwollen" ;
  lin schwimmen_V =  irregV "schwimmen" "schwimmt" "schwamm" "schw�mme" "geschwommen" ;
  lin schwimmen_o_V =  irregV "schwimmen" "schwimmt" "schwamm" "schw�mme" "geschwommen" ;
  lin schwinden_V =  irregV "schwinden" "schwindt" "schwand" "schw�nde" "geschwunden" ;
  lin schwingen_V =  irregV "schwingen" "schwingt" "schwang" "schw�nge" "geschwungen" ;
  lin schw�ren_V =  irregV "schw�ren" "schw�rt" "schwor" "schw�re" "geschworen" ;
  lin sehen_V =  irregV "sehen" "sieht" "sah" "s�he" "gesehen" ;
  lin sein_V =  irregV "sein" "ist" "war" "w�re" "gewesen" ;
  lin senden_V =  irregV "senden" "sendt" "sandte" "sandte" "gesandt" ;
  lin sieden_V =  irregV "sieden" "siedt" "sott" "sotte" "gesotten" ;
  lin singen_V =  irregV "singen" "singt" "sang" "s�nge" "gesungen" ;
  lin sinken_V =  irregV "sinken" "sinkt" "sank" "s�nke" "gesunken" ;
  lin sinnen_V =  irregV "sinnen" "sinnt" "sann" "s�nne" "gesonnen" ;
  lin sitzen_V =  irregV "sitzen" "sitzt" "sa�" "s��e" "gesessen" ;
  lin sollen_V =  M.mkV 
        "sollen" "soll" "sollst" "soll" "sollt" "soll" 
        "sollte" "solltest" "sollten" "solltet"
        "sollte" "gesollt" [] 
        M.VHaben ** {lock_V = <>} ;

  lin speien_V =  irregV "speien" "speit" "spie" "spie" "gespien" ;
  lin spinnen_V =  irregV "spinnen" "spinnt" "spann" "sp�nne" "gesponnen" ;
  lin spinnen_o_V =  irregV "spinnen" "spinnt" "spann" "sp�nne" "gesponnen" ;
  lin splei�en_V =  irregV "splei�en" "splei�t" "spli�" "spli�e" "gesplissen" ;
  lin sprechen_V =  irregV "sprechen" "spricht" "sprach" "spr�che" "gesprochen" ;
  lin sprie�en_V =  irregV "sprie�en" "sprie�t" "spro�" "spr�sse" "gesprossen" ;
  lin springen_V =  irregV "springen" "springt" "sprang" "spr�nge" "gesprungen" ;
  lin stechen_V =  irregV "stechen" "sticht" "stach" "st�che" "gestochen" ;
  lin stehen_V =  irregV "stehen" "steht" "stand" "st�nde" "gestanden" ;
  lin stehen_u_V =  irregV "stehen" "steht" "stand" "st�nde" "gestanden" ;
  lin stehlen_V =  irregV "stehlen" "stiehlt" "stahl" "st�hle" "gestohlen" ;
  lin steigen_V =  irregV "steigen" "steigt" "stieg" "stiege" "gestiegen" ;
  lin sterben_V =  irregV "sterben" "stirbt" "starb" "st�rbe" "gestorben" ;
  lin stieben_V =  irregV "stieben" "stiebt" "stob" "st�be" "gestoben" ;
  lin stinken_V =  irregV "stinken" "stinkt" "stank" "st�nke" "gestunken" ;
  lin sto�en_V =  irregV "sto�en" "st��t" "stie�" "stie�e" "gesto�en" ;
  lin streichen_V =  irregV "streichen" "streicht" "strich" "striche" "gestrichen" ;
  lin streiten_V =  irregV "streiten" "streitet" "stritt" "stritte" "gestritten" ;
  lin tragen_V =  irregV "tragen" "tr�gt" "trug" "tr�ge" "getragen" ;
  lin treffen_V =  irregV "treffen" "trifft" "traf" "tr�fe" "getroffen" ;
  lin treiben_V =  irregV "treiben" "treibt" "trieb" "triebe" "getrieben" ;
  lin treten_V =  irregV "treten" "tritt" "trat" "tr�te" "getreten" ;
  lin trinken_V =  irregV "trinken" "trinkt" "trank" "tr�nke" "getrunken" ;
  lin tr�gen_V =  irregV "tr�gen" "tr�gt" "trog" "tr�ge" "getrogen" ;
  lin tun_V =  irregV "tun" "tut" "tat" "t�te" "getan" ;
  lin verderben_V =  irregV "verderben" "verdirbt" "verdarb" "verdarbe" "verdorben" ;
  lin verlieren_V =  irregV "verlieren" "verliert" "verlor" "verl�re" "verloren" ;
  lin wachsen_V =  irregV "wachsen" "w�chst" "wuchs" "w�chse" "gewachsen" ;
  lin w�gen_V =  irregV "w�gen" "w�gt" "wog" "woge" "gewogen" ;
  lin waschen_V =  irregV "waschen" "w�scht" "wusch" "w�sche" "gewaschen" ;
  lin weben_V =  irregV "weben" "webt" "wob" "w�be" "gewoben" ;
  lin weichen_V =  irregV "weichen" "weicht" "wich" "wiche" "gewichen" ;
  lin weisen_V =  irregV "weisen" "weist" "wies" "wiese" "gewiesen" ;
  lin wenden_V =  irregV "wenden" "wendt" "wandte" "wandte" "gewandt" ;
  lin werben_V =  irregV "werben" "wirbt" "warb" "w�rbe" "geworben" ;
  lin werden_V = M.mkV 
        "werden" "werde" "wirst" "wird" "werdet" "werd" 
        "wurde" "wurdest" "wurden" "wurdet"
        "w�rde" "geworden" [] 
        M.VHaben ** {lock_V = <>} ;
  lin werfen_V =  irregV "werfen" "wirft" "warf" "w�rfe" "geworfen" ;
  lin wiegen_V =  irregV "wiegen" "wiegt" "wog" "w�ge" "gewogen" ;
  lin winden_V =  irregV "winden" "windt" "wand" "w�nde" "gewunden" ;
  lin wissen_V =  M.mkV 
        "wissen" "wei�" "wei�t" "wei�" "wisst" "wisse" 
        "wusste" "wusstest" "wussten" "wusstet"
        "w�sste" "gewusst" [] 
        M.VHaben ** {lock_V = <>} ;
  lin wollen_V =  M.mkV 
        "wollen" "will" "willst" "will" "wollt" "woll" 
        "wollte" "wolltest" "wollten" "wolltet"
        "wollte" "gewollt" [] 
        M.VHaben ** {lock_V = <>} ;


  lin wringen_V =  irregV "wringen" "wringt" "wrang" "wr�nge" "gewrungen" ;
  lin zeihen_V =  irregV "zeihen" "zeiht" "zieh" "ziehe" "geziehen" ;
  lin ziehen_V =  irregV "ziehen" "zieht" "zog" "z�ge" "gezogen" ;
  lin zwingen_V =  irregV "zwingen" "zwingt" "zwang" "zw�nge" "gezwungen" ;

}

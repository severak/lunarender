My replies to feedback from czech OSM community.

See [full thread](https://lists.openstreetmap.org/pipermail/talk-cz/2016-January/thread.html#13140).

---

Co se týká LunaRenderu, bylo položeno pár dotazů. Pokusím se je zodpovědět:

> A jaká je vlastně motivace pro podobný počin? Mapnik nevyhovuje?

LunaRender nemá konkurovat Mapniku, má sloužit převážně k příležitostným 
renderům. Například:

 - píšu článek o stavebním vývoji v nějaké oblasti, potřebuji si vygenerovat
pozadí pro situační mapku 
 - vydávám knížku týkající se nějakého města a rád bych použil 
charakteristickou kresbu uličního plánu jako obrázek na pozadí
 - chci si plán k pokladu pro děti nakreslit na počítači :-)

Proto použiju LunaRender. Výstup je do SVG, celkem jednoduchý (a bude ještě 
jednodušší až implementuju path simplification) a určený k následné ruční 
úpravě (třeba rozdělením na vrstvy pro inkscape).

Mapu jde při generování celkem snadno nastylovat podle toho, k čemu je 
určená. Konfigurace vykreslování není žádný pseudokonfig, ale regulérní 
programovací jazyk (takže to může být dost stručné).

Chci implementovat i vykreslování většího počtu dlaždic (třeba celé Prahy), 
ale to bude zatím jen doplňková funkce (čti hack).

K samotné motivaci - pro podobné účely jsem používal Maperative, ale ten na 
mém primárním stroji (starý až historický notebook s winxp) neběžel. Tak 
jsem zkusil napsat něco vlastního a ono to (k mému překvapení) fungovalo....

> A jak to vlastně provádí spatial dotazy, když ne přes postgis?

Nijak. Vstupní data jsou OSM XML nebo JSON výstup z Overpass API (to se hodí
třeba na vykreslování sítí MHD, kdy nemusíme stahovat celé město). Samotné 
vykreslování se pak provádí dost jednoduše, bez nějaké větší inteligence, 
dalo by se říct hrubou silou.

> máš prosím někde funkční demo? To na githubu hlásí "server nedostupný".

Ukázky obrázků v blogu https://www.openstreetmap.org/user/Sever%C3%A1k/diary
nebo na http://svita.cz/archiv/imgs/lunarender-demos/

(nemělo by to být nedostupné, nicméně je to jen freeweb -  za dostupnost 
nikdo neručí)

Na žádném serveru to zatím neběží, jelikož žádným nedisponuju. Uživatelé si 
to musí sami stáhnout a vyzkoušet.

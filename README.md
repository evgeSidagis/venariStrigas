# venariStrigas


Cambio del Domingo 19/07/2020
-Arreglado el problema con los mapas que estaban mal superpuestos. Ahora los pies del personaje son cubiertos en su totalidad en los dos mapas donde se presentaba ese error. Los demas mapas permanecen igual.


Bueno, este readme queda para la posteridad explicando un poco elementos basicos del juego, y un poco como funciona. Al final del readme estan los links de los assets utilizados en este juego.


Nombre:

Venari Strigas significa "Caceria de Brujas" en Latin.

Jugabilidad: 

Tu personaje esta armado inicialmente con una pistola, alto radio de fuego, animacion corta, la cual la hace ideal para hit and run, y poco daño. 
Al correr el primer nivel, desbloquearas una segunda arma, un lanzacohetes. Este tiene area de efecto (no muy grande, pero tiene), radio de fuego lento y mucho daño. Ideal para
grupos de enemigos, o en momentos donde no hay peligro de ser pegado.
Tu personaje podra saltar inicialmente una unica vez, pero desbloqueara un doble salto el cual puede ser usado incluso cayendo.
En el segundo nivel, desbloquearas la ultima habilidad especial de Homura, que es poder detener el flujo de tiempo por un par de segundos.

Si mueres o dejas el area jugable deberas empezar desde el primer nivel de vuelta.

Al morir quedan guardadas las armas/habilidades desbloqueadas y la vuelta (lap) donde estas parado.

Al pasar de nivel al siguiente la salud se reinicia. Esto es en parte por razones de balance, sobretodo considerando el sistema descrito a continuacion.

Ademas, existe un sistema de laps, que aumenta con cada corrida completa. Este sistema aumenta la dificultad linealmente, aumentando el daño de los enemigos y su salud.

Enemigos: 

Los enemigos basicos son los Pawns y las Megucas. 

Los pawns se activan a una distancia determinada y te persiguen, incluso saltando obstaculos de ser necesario. Tienen
un breve calentamiento antes de atacar, asi que dodgea. Tienen daño alto.

Las Megucas son cabezas flotantes a las cuales no se les puede pegar, y su proposito es llevarte puesto. Homura salta automaticamente en caso de ser golpeada, pero pierde el control
por un tiempo. En sitios cerrados, te empujaran. Cuidado con caer al vacio, porque puede ser el fin.

Raganos es el/la jefe del juego. Es una bruja que seguramente flote en agua si se la tire a ella, y pese lo mismo que un pato. Ni mas, ni menos. Deberia
convertir a Homura en una salamandra, pero no lo hace (lamentablemente). Ahora hablando de la bruja del juego, los patrones son la solucion a estos problemas.

Historia:

La historia es un fanfic basado en un anime llamado Puella Magi Madoka Magica.

Si bien la historia es relativamente basica, y es contada en formato de dialogo entre Homura y Kyubey, o para si misma, la premisa es simple. Estas buscando a Madoka Kaname, tu
unica amiga. Incluso descenderas al abismo de ser necesario para ello. Ella es tu guia y tu fuerza. Usala para vencer a lo que tienes adelante!

Es importante prestar atencion a los dialogos durante la primera corrida, proveen un poco de contexto con respecto a las habilidades y la premisa basica de estos 3 niveles.
(Y uno de bonus que es unicamente historia)

Mapas: 

Los mapas ven variaciones tanto en su color como en su diseño general, avanzando lentamente a colores irreales y diseños arquitectonicos similares a la antigua Roma.
El proposito de esto es crear una atmosfera cada vez mas "falsa" e "irreal", significando que Homura cada vez se encuentra mas cerca de su enemigo, la bruja.

Otros datos:

Si disparas a un grupo de enemigos con la pistola desde extremadamente cerca, es posible pegarle a todos con la misma bala.

Entrar a un area nuevo bajo tiempo detenido puede causar cambios en el comportamiento de las megucas.

Raganos significa "Brujas" en Lituano. "Ragana" seria bruja pero no sonaba tan bien como nombre de jefe.

El modelo utilizado para los Pawns esta basado en una version oscura de Sabrina Mickey, que a su vez es una version del personaje original de Sayaka Miki.

Bugs Conocidos: 

Obviando los mencionados anteriormente, a veces se pueden ver los pies del personaje por debajo del pasto en los mapas (Por alguna razon esta tomando como primer plano la segunda capa, lo cual causa que cubra al personaje mientras que la primera capa no lo hace).

La IA de los Pawns es medianamente abusable, mas que nada porque no "entienden" donde no deberian saltar. Ahora saltan y no atacan mientras estan en el aire, lo cual las hace mas dinamicas y menos estaticas.

Diseño: 

Por temas de tiempo no pude implementar una clase padre para todos los proyectiles (dado que tienen comportamientos similares), y de esta forma colocar a todos estos en una unica lista de proyectiles (en GGD) pero manteniendo los collision groups para cada uno de estos. Tambien se me paso por alto implementar dos metodos mas a la clase Enemy (resetTimeline y stopTimeline) dado que todos los hijos de Enemy tienen estos dos metodos. De todas maneras, hubiera mantenido separados estos CollisionGroups de la misma forma que para los proyectiles, dado que tienen formas diferentes de reaccionar a ciertos eventos. 

En estos ultimos dias previos a la entrega, el proyecto vio numerosos cambios en varias cuestiones mas que nada para dar lugar a la habilidad de detener el tiempo (deteniendo todas las colisiones y animaciones, excepto por ciertos casos), lo cual llevo a varios cambios en el diseño general del sistema. Entre ellos usar CollisionGroups en GGD, las listas de objetos en GGD, y alguna que otra cosa mas relacionada a Homura. 

Assets:

Sonidos:

Pistola Beretta 92FS - http://soundbible.com/tags-beretta.html

Raganos - http://soundbible.com/2052-Creepy-Laugh.html

AT-4 Rocket Launcher - http://soundbible.com/1151-Grenade.html

Espadazo - http://soundbible.com/706-Swoosh-3.html


Fondos del juego, intro y ending:


Ending: https://www.pixiv.net/en/artworks/18391722 - Modificado

Intro: https://wallhere.com/es/wallpaper/26735 - Modificado

Area del Jefe: https://papers.co/bb43-paris-dark-purple-city-illustration-art/

Primer Area: https://twitter.com/Scenograph_/status/1256807808328065024

Segunda Area: https://wallpapersden.com/purple-city-wallpaper/2560x1080/

Bonus Area: https://www.itl.cat/wallview/iTihiJJ_madoka-magica-wallpaper-witch/


Musica:


Ending: https://www.youtube.com/watch?v=IHpK1ADX7AI - Kyubey's Theme - Yuki Kajiura

Intro: https://sites.google.com/site/madokaost2/-nipponsei-puella-magi-madoka-magica-original-soundtrack-ii?tmpl=%2Fsystem%2Fapp%2Ftemplates%2Fprint%2F&showPrintDialog=1
Inevitabilis - Homura's Theme - Yuki Kajiura

Primer Area: https://sites.google.com/site/madokaost2/-nipponsei-puella-magi-madoka-magica-original-soundtrack-ii?tmpl=%2Fsystem%2Fapp%2Ftemplates%2Fprint%2F&showPrintDialog=1
Pugna Cum Maga - Yuki Kajiura

Segunda Area: https://sites.google.com/site/madokaost2/-nipponsei-puella-magi-madoka-magica-original-soundtrack-ii?tmpl=%2Fsystem%2Fapp%2Ftemplates%2Fprint%2F&showPrintDialog=1
Venari Strigas - Yuki Kajiura

Area del Jefe: https://www.nhaccuatui.com/bai-hat/numquam-vincar-puella-magi-madoka-magica-ost-va.2nWJaiKqLoFi.html
Numquam Vincar - Yuki Kajiura

Bonus Area: https://sites.google.com/site/madokaost1/-nipponsei-puella-magi-madoka-magica-original-soundtrack-i - Puella in Somnio - Yuki Kajiura


Plataformas - Tiles:


Todos los mapas - https://opengameart.org/content/2d-32x32-platformer-tileset - Modificado - Gracias a Bojidar Marinov


Enemigos:


Pawns - https://the-silly-princess-blog.tumblr.com/post/43700452290/sayaka-miki-grief-syndrome-sprites-and-gif - Modificado

Meguca - https://opengameart.org/content/bosses-and-monsters-spritesheets-ars-notoria - Gracias a Stephen Challener (Redshrike) por los sprites originales

Raganos - https://opengameart.org/content/bosses-and-monsters-spritesheets-ars-notoria - Gracias a Stephen Challener (Redshrike) por los sprites originales


Homura Akemi, Kyubey:
https://www.deviantart.com/konbe 

Con respecto a Homura Akemi, no encontre animaciones con respecto a saltar o hacer doble salto. Hubiera estado buena tenerlas, pero bueno, tuve que trabajar con lo que tenia disponible. Por algunos momentos del desarrollo pense en usar otro personaje principal (Seguramente Sayaka Miki) que tenia mas animaciones disponibles, pero me vi persuadido por el hecho de que Homura es mi personaje favorito del anime en particular y uno de mis favoritos en toda forma de historia o media.

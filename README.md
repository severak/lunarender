# LunaRender

experimental OpenStreetMap renderer. Despite its name it is used for rendering of earth surface [mostly](http://opengeofiction.net).

**Work in progress.** See [introduction post](https://www.openstreetmap.org/user/Sever%C3%A1k/diary/37673). 

## features

- input format: OSM XML, Overpass API JSON output
- output format: SVG
- rendering rules scriptable with lua
- no need for installing Postgres

## installation

Download [source package](https://github.com/severak/lunarender/archive/master.zip) and unzip it. Binaries for windows are already included.

For installation under linux see [this issue](https://github.com/severak/lunarender/issues/1).

Some rendering rules uses [Symbola font](http://zhm.github.io/symbola/), it's better to install it otherwise you got mojibake.

## usage

1. go to [OpenStreetMap](http://www.openstreetmap.org), select some nice place and export it
2. drop exported XML file to LunaRender working directory
3. run `cmdhere.bat` (or add `lunarender.bat` to `PATH`)
4. call `lunarender map.osm` from command line

### using data from Overpass API

1. go to [Overpass turbo](http://overpass-turbo.eu/) and enter your query. Note: you **have to** include `[out:json]` and `[bbox:{{bbox}}]` in your query.
2. export data as *raw data*
3. drop exported JSON file to LunaRender working directory
4. run `cmdhere.bat` (or add `lunarender.bat` to `PATH`)
5. call `lunarender export.json` from command line

## command line parameters

1. input file name - **required**
2. rendering rules file name - default `rules/default.lua`
3. zoom - default `15`

## rendering rules

Rendering rules are written in [lua](http://www.lua.org/manual/5.2/). 

Currently there is no documentation about rendering rules. You have to look into [source code ](https://github.com/severak/lunarender/tree/master/rules) of demo rules.

## acknowledgment

 - Joe Schwartz for [this article](https://msdn.microsoft.com/en-us/library/bb259689.aspx). I got projection code from there.
 - Igor Brejc for [Maperitive](http://maperitive.net/). This is great inspiration for me.
 - Matthew Wild for [LuaExpat](https://matthewwild.co.uk/projects/luaexpat/)
 - David Kolf for [dkjson](http://dkolf.de/src/dkjson-lua.fsl/home)
 - Paul Kulchenko for [Serpent](https://github.com/pkulchenko/serpent)
 - [LuaDist](http://luadist.org/) authors
 - [lua authors](http://www.lua.org/authors.html) for great language
 - and finally all OpenStreetMap contributors for test data
 
## pics or didnt happen

![default style](http://svita.cz/archiv/imgs/lunarender-demos/nymburk.png)

default style

![technology demo](http://svita.cz/archiv/imgs/lunarender-demos/shared.png)

technology demo

![Soviet map style](http://svita.cz/archiv/imgs/lunarender-demos/soviet_luziny.png)

[Soviet map style](https://www.openstreetmap.org/user/Sever%C3%A1k/diary/37681)
 

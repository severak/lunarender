# LunaRender

lua-based OpenStreetMap XML2SVG renderer. Despite its name it is used for rendering of earth surface [mostly](http://opengeofiction.net).

**Work in progress.**

## installation

Download [source package](https://github.com/severak/lunarender/archive/master.zip) and unzip it. Binaries for windows are already included.

## usage

1. go to [OpenStreetMap](http://www.openstreetmap.org), select some nice place and export it
2. drop exported XML file to LunaRender working directory
3. run `cmdhere.bat` (or add `lunarender.bat` to `PATH`)
4. call `lunarender map.osm` from command line

You can also experinent with other rendering rules.

## command line paramaters

1. input file name - **required**
2. rendering rules file name - default `rules.default.lua`
3. zoom - default `15`

## rules

*undocumented for now, look into rules.default.lua*
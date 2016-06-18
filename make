#!/bin/bash

set -e
elm-make Kings.elm --output kings_elm.js
./node_modules/uglify-js/bin/uglifyjs --compress --output kings_elm.min.js --mangle --  kings_elm.js

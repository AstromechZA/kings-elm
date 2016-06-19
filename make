#!/bin/bash

set -e

elm-make Main.elm --output main_elm.js
./node_modules/uglify-js/bin/uglifyjs --compress --output js/main_elm.min.js --mangle -- main_elm.js
ls -lh main_elm.js
ls -lh js/main_elm.min.js
rm main_elm.js

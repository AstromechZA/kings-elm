#!/bin/bash

set -e

elm-make Kings.elm --output kings_elm.js
./node_modules/uglify-js/bin/uglifyjs --compress --output web/js/kings_elm.min.js --mangle -- kings_elm.js
ls -lh kings_elm.js
ls -lh web/js/kings_elm.min.js
rm kings_elm.js

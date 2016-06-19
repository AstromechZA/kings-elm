# Kings-elm

Came upon Elm after a collegue mentioned it at work, sounded interesting so I
set out to build something in it to check it out. This app is the result. If you
haven't played it, Kings (or King's Cup) is a drinking game involving drawing
cards and enacting the rules they depict.

Go to https://astromechza.github.io/kings-elm/ to check out the live version.

## Stack & Dependencies

- Elm
    - elm-lang/core
    - elm-lang/html
    - elm-community/elm-random-extra
- Node.js + uglify-js for Javascript minification (not really necessary)
- Playing Card CSS from http://selfthinker.github.io/CSS-Playing-Cards/
- Bootstrap CSS library

## Conclusion

Elm has been one of the first functional languages I've written anything more
than 10 lines of and as such took a bit of getting used to - when the natural
way of thinking is imperative and procedural, declarative and functional is
quite different. I'm quite interested in using Elm again, and will watch it as
it grows and develops (it is only version 0.18 now) so I'll hopefully reach for
it again when a interactive web UI of sufficient complexity is required. A big
blocker is the lack of sufficient dead code elimination in the compiler, the
code from this app resulted in a 231KB Javascript file before minification.

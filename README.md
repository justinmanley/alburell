Alburrell
=========

This is an art project inspired by [Craig Dorety](http://craigdorety.com/) (and, more distantly, by [James Turrell](http://jamesturrell.com/) and [Josef Albers](https://en.wikipedia.org/wiki/Josef_Albers)).

Here's what it looks like:

![LED 'Homage to the Square'](https://pbs.twimg.com/media/CjJm2tRUgAAJ6HT.jpg:large)

### Overview

A sizing study is located in [sizing/](./sizing). We used this study to determine the dimensions of each layer
and the placement of each layer inside the frame. This study is written in Elm, so you'll need to install the
[Elm Platform](https://github.com/elm-lang/elm-platform) to run it. Once you have Elm installed, you can run:

```bash
cd sizing
elm package install # install the dependencies listed in elm-package.json
elm reactor # starts a web server so that the study can be viewed in the browser
```

Various color studies are located under [studies/](./studies). Each study is an Arduino sketch which can be
run in the frame. It's easiest to do this with the [Arduino IDE](https://www.arduino.cc/en/Main/Software).

By @justinmanley and @jbolling.

if [ -d arduino-cmake ]; then
    git clone https://github.com/queezythegreat/arduino-cmake
fi

if [ -d libraries/FastLED ]; then
    git clone https://github.com/FastLED/FastLED libraries/FastLED
    $(cd libraries/FastLED && git checkout v3.1.0)
    sed -i "21r fastled_config.txt" libraries/FastLED/fastled_config.h
fi

if [ -d build ]; then
    mkdir build
fi


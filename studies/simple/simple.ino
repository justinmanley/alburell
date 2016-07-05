#include "FastLED.h"
#include "math.h"
#include <stdio.h>

#define NEED_CXX_BITS

#define DATA_PIN 10
#define NUM_LEDS 74

/**
 * An RGB 88 is an RGB with 16 bits per channel; the 8 bits of CRGB color are augmented by 8
 * "fractional" bits, which are simulated using temporal dithering.
 */
class RGB88 {
  public:
    accum88 red, green, blue;

    RGB88() {};

    RGB88(accum88 _red, accum88 _green, accum88 _blue) {
        red = _red;
        green = _green;
        blue = _blue;
    }

    RGB88(CRGB color) {
      red = color.red << 8;
      green = color.green << 8;
      blue = color.blue << 8;
    }

    CRGB dither(unsigned long t) {
        return CRGB(
            ditherChannel(t, red),
            ditherChannel(t, green),
            ditherChannel(t, blue)
        );
    }

    unsigned short ditherChannel(unsigned long t, accum88 channel) {
        // The lower 8 bits of the accum88 are the fractional part.
        unsigned short fract = channel & 0xff;
       
        // No dithering necessary!
        if (fract <= 1) {
          return channel >> 8;
        } 
        
        if (t % round(256 / fract) == 0) {
          return (channel >> 8) + 1;
        }

        return channel >> 8;
    }
};

/*
 * An RGB88Animator animates smoothly between two RGB88 colors.
 */
class RGB88Animator {
  public:
    RGB88 color1, color2;

    // The sign for each color is -1 or 1.
    int redSign, greenSign, blueSign;

    unsigned int redDiff, greenDiff, blueDiff;

    RGB88Animator() {}
    RGB88Animator(RGB88 _color1, RGB88 _color2) {
      color1 = _color1;
      color2 = _color2;

      redSign = color1.red < color2.red ? 1 : -1;
      greenSign = color1.green < color2.green ? 1 : -1;
      blueSign = color1.blue < color2.blue ? 1 : -1;

      redDiff = abs(color1.red - color2.red);
      greenDiff = abs(color1.green - color2.green);
      blueDiff = abs(color1.blue - color2.blue);
    }

    RGB88Animator(CRGB _color1, CRGB _color2) : RGB88Animator(RGB88(_color1), RGB88(_color2)) {}

    RGB88 at(unsigned long t) {
      unsigned short rawAmplitude = sin16(t) + 32768;
      
      unsigned short redAmplitude = scale16(rawAmplitude, redDiff);
      unsigned short greenAmplitude = scale16(rawAmplitude, greenDiff);
      unsigned short blueAmplitude = scale16(rawAmplitude, blueDiff);

      return RGB88(
        color1.red + redSign * redAmplitude,
        color1.green + greenSign * greenAmplitude,
        color1.blue + blueSign * blueAmplitude  
      );
    };
};

unsigned long counter = 0;

RGB88Animator back;
RGB88Animator middle;
RGB88Animator front;

CRGB leds[NUM_LEDS];

void setup() {
  FastLED.addLeds<NEOPIXEL, DATA_PIN>(leds, NUM_LEDS);

  back = RGB88Animator(CRGB::Aquamarine, CRGB::Coral);
  middle = RGB88Animator(CRGB::Red, CRGB::Indigo);
  front = RGB88Animator(CRGB::Olive, CRGB::Purple);

  // Don't want FastLED's built-in dithering to interfere with our manual
  // dithering.
  FastLED.setDither(0);
}

void loop() {  
  // LED index.
  int i = 0;

  // Back layer
  CRGB backLED = back.at(counter << 4).dither(counter);
  for (i = 0; i < 16; i++) {
    leds[i] = backLED;
  }

  // Middle layer
  CRGB middleLED = middle.at(counter << 4).dither(counter);
  for (i = 16; i < 40; i++) {
    leds[i] = middleLED;  
  }

  // Front layer
  CRGB frontLED = front.at(counter << 4).dither(counter);
  for (i = 40; i < 74; i++) {
    leds[i] = frontLED;  
  }

  counter += 1;
  FastLED.show();
}

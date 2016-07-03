#include "FastLED.h"
#include "math.h"
#include <stdio.h>

#define NEED_CXX_BITS

#define DATA_PIN 10
#define NUM_LEDS 74

class RGBFract {
  public:
    accum88 red, green, blue;

    RGBFract() {};
    RGBFract(accum88 _red, accum88 _green, accum88 _blue) {
        red = _red;
        green = _green;
        blue = _blue;
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

unsigned long counter = 0;

RGBFract back;

CRGB leds[NUM_LEDS];

void setup() {
  FastLED.addLeds<NEOPIXEL, DATA_PIN>(leds, NUM_LEDS);

  // Don't want FastLED's built-in dithering to interfere with our manual
  // dithering.
  FastLED.setDither(0);

  Serial.begin(9600);
}

void loop() {  
  // Update the colors
  int amplitude = scale16(sin16(counter), 50 << 8);
  back = RGBFract(0, 0, (40 << 8) + amplitude);

  // LED index.
  int i = 0;

  // Back layer
  CRGB backLED = back.dither(counter);
  for (i = 0; i < 16; i++) {
    leds[i] = backLED;
  }

  counter += 1;
  FastLED.show();
}



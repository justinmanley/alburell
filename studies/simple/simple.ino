#include "FastLED.h"

#define DATA_PIN 10
#define NUM_LEDS 74

CRGB leds[NUM_LEDS];

void setup() {
  FastLED.addLeds<NEOPIXEL, DATA_PIN>(leds, NUM_LEDS);

  int i;

  // Bottom layer
  for (i = 0; i < 16; i++) {
    leds[i] = CRGB(0, 0, 255);  
  }

  // Middle layer
  for (i = 16; i < 40; i++) {
    leds[i] = CRGB(0, 255, 0);  
  }

  // Frontmost layer
  for (i = 40; i < 74; i++) {
    leds[i] = CRGB(255, 0, 0);
  }

  FastLED.show();
}

void loop() {}

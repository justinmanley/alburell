#include "FastLED.h"
#include "math.h"

#include "util.h"

#define NEED_CXX_BITS

#define DATA_PIN 10
#define NUM_LEDS 74

// The "base colors" for each layer.
#define BACK CRGB(0, 0, 25)
#define MIDDLE CRGB(0, 0, 50)
#define FRONT CRGB(0, 0, 75)

CRGB leds[NUM_LEDS];

using namespace __cxxabiv1;

// Counter which increases with each iteration of the loop and animates the colors of each layer.
int t = 0;

void setup() {
  FastLED.addLeds<NEOPIXEL, DATA_PIN>(leds, NUM_LEDS);

  // Middle layer
  for (int i = 16; i < 40; i++) {
    leds[i] = CRGB(0, 0, MIDDLE.blue );
  }
}

void loop() {
  // LED index.
  int i = 0;

  // Bottom layer
  for (i = 0; i < 16; i++) {
    // leds[i] = CRGB(0, 0, round(BACK.blue * sin(t)));
    leds[i] = CRGB(0, 0, BACK.blue + scaled_triangle_wave(t, BACK.blue));
  }

  // Middle layer stays the same

  // Frontmost layer
  for (i = 40; i < 74; i++) {
    // leds[i] = CRGB(0, 0, round(FRONT.blue * sin(t)));
    leds[i] = CRGB(0, 0, FRONT.blue + scaled_triangle_wave(BACK.blue + t, BACK.blue));
  }

  t += 1;
  FastLED.show();
  delay(200);
}

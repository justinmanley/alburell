#include <gtest/gtest.h>
#include "../src/util.h"

TEST(TriangleWave, Period) {
  // Check a few zeroes
  // The triangle wave should have a half-period of 2.
  for (int i : {-2, 0, 2}) {
    EXPECT_EQ(0, triangle_wave(i));
  }

  // Check a few maxima
  for (int i : {-3, 1, 5}) {
    EXPECT_EQ(1, triangle_wave(i));
  }

  // Check a few minima
  for (int i : {-5, -1, 3}) {
    EXPECT_EQ(-1, triangle_wave(i));
  }
}

TEST(EvenlyScaledTriangleWave, StepSize) {
  for (int i = 0; i < 5; i++) {
    EXPECT_EQ(1, scaled_triangle_wave(i + 1, 5) - scaled_triangle_wave(i, 5));
  }
}

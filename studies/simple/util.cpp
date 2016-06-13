#include "math.h"

double triangle_wave (double x) {
    int base = (int) floor((x + 1) / 2);
    return (x - base * 2) * pow(-1, base);
}

int triangle_wave(int x) {
    return (int) triangle_wave((double) x);
}

double scaled_triangle_wave(double x, double n) {
    return n * triangle_wave((1/n) * x);
}

int scaled_triangle_wave(int x, int n) {
    return (int) scaled_triangle_wave((double) x, (double) n);
}

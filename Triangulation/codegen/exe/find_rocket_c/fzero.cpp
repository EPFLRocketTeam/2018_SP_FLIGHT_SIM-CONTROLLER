//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
// File: fzero.cpp
//
// MATLAB Coder version            : 4.1
// C/C++ source code generated on  : 18-Jun-2019 08:46:07
//

// Include Files
#include <cmath>
#include "rt_nonfinite.h"
#include "find_rocket_c.h"
#include "fzero.h"

// Function Definitions

//
// Arguments    : const double FunFcn_tunableEnvironment_f1[8]
//                double FunFcn_tunableEnvironment_f2
//                double x
// Return Type  : double
//
double fzero(const double FunFcn_tunableEnvironment_f1[8], double
             FunFcn_tunableEnvironment_f2, double x)
{
  double b;
  int fx_tmp;
  double b_fx_tmp;
  double fx;
  double dx;
  double a;
  double fb;
  int exitg2;
  double fc;
  double c;
  double e;
  double d;
  bool exitg1;
  double m;
  double toler;
  double s;
  double r;
  fx_tmp = ((int)FunFcn_tunableEnvironment_f2 - 1) << 1;
  b_fx_tmp = FunFcn_tunableEnvironment_f1[1 + fx_tmp];
  fx = x * FunFcn_tunableEnvironment_f1[fx_tmp] + b_fx_tmp;
  if (fx == 0.0) {
    b = x;
  } else {
    if (x != 0.0) {
      dx = x / 50.0;
    } else {
      dx = 0.02;
    }

    a = x;
    b = x;
    fb = fx;
    do {
      exitg2 = 0;
      if ((fx > 0.0) == (fb > 0.0)) {
        dx *= 1.4142135623730951;
        a = x - dx;
        fx = a * FunFcn_tunableEnvironment_f1[((int)FunFcn_tunableEnvironment_f2
          - 1) << 1] + b_fx_tmp;
        if (rtIsInf(fx) || rtIsNaN(fx)) {
          b = rtNaN;
          exitg2 = 1;
        } else if (rtIsInf(a) || rtIsNaN(a)) {
          b = rtNaN;
          exitg2 = 1;
        } else if ((fx > 0.0) != (fb > 0.0)) {
          exitg2 = 2;
        } else {
          b = x + dx;
          fb = b * FunFcn_tunableEnvironment_f1[((int)
            FunFcn_tunableEnvironment_f2 - 1) << 1] + b_fx_tmp;
          if (rtIsInf(fb) || rtIsNaN(fb)) {
            b = rtNaN;
            exitg2 = 1;
          } else {
            if (rtIsInf(b) || rtIsNaN(b)) {
              b = rtNaN;
              exitg2 = 1;
            }
          }
        }
      } else {
        exitg2 = 2;
      }
    } while (exitg2 == 0);

    if (exitg2 == 1) {
    } else {
      fc = fb;
      c = b;
      e = 0.0;
      d = 0.0;
      exitg1 = false;
      while ((!exitg1) && ((fb != 0.0) && (a != b))) {
        if ((fb > 0.0) == (fc > 0.0)) {
          c = a;
          fc = fx;
          d = b - a;
          e = d;
        }

        if (std::abs(fc) < std::abs(fb)) {
          a = b;
          b = c;
          c = a;
          fx = fb;
          fb = fc;
          fc = fx;
        }

        m = 0.5 * (c - b);
        dx = std::abs(b);
        if (!(dx > 1.0)) {
          dx = 1.0;
        }

        toler = 4.4408920985006262E-16 * dx;
        if ((std::abs(m) <= toler) || (fb == 0.0)) {
          exitg1 = true;
        } else {
          if ((std::abs(e) < toler) || (std::abs(fx) <= std::abs(fb))) {
            d = m;
            e = m;
          } else {
            s = fb / fx;
            if (a == c) {
              dx = 2.0 * m * s;
              fx = 1.0 - s;
            } else {
              fx /= fc;
              r = fb / fc;
              dx = s * (2.0 * m * fx * (fx - r) - (b - a) * (r - 1.0));
              fx = (fx - 1.0) * (r - 1.0) * (s - 1.0);
            }

            if (dx > 0.0) {
              fx = -fx;
            } else {
              dx = -dx;
            }

            if ((2.0 * dx < 3.0 * m * fx - std::abs(toler * fx)) && (dx < std::
                 abs(0.5 * e * fx))) {
              e = d;
              d = dx / fx;
            } else {
              d = m;
              e = m;
            }
          }

          a = b;
          fx = fb;
          if (std::abs(d) > toler) {
            b += d;
          } else if (b > c) {
            b -= toler;
          } else {
            b += toler;
          }

          fb = b * FunFcn_tunableEnvironment_f1[((int)
            FunFcn_tunableEnvironment_f2 - 1) << 1] + b_fx_tmp;
        }
      }
    }
  }

  return b;
}

//
// File trailer for fzero.cpp
//
// [EOF]
//

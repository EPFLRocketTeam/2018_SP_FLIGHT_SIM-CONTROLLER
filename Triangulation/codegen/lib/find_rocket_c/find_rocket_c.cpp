//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
// File: find_rocket_c.cpp
//
// MATLAB Coder version            : 4.1
// C/C++ source code generated on  : 18-Jun-2019 08:48:19
//

// Include Files
#include <cmath>
#include <math.h>
#include "rt_nonfinite.h"
#include <float.h>
#include <string.h>
#include "find_rocket_c.h"

// Type Definitions
typedef struct {
  double Latitude[4];
  double Longitude[4];
} struct_T;

typedef struct {
  struct_T tunableEnvironment[1];
} c_coder_internal_anonymous_func;

// Function Declarations
static double eps(double x);
static void fminsearch(const struct_T funfcn_tunableEnvironment[1], double x[2]);
static double fzero(const double FunFcn_tunableEnvironment_f1[8], double
                    FunFcn_tunableEnvironment_f2, double x);
static double getCheckFcn(const c_coder_internal_anonymous_func *fcn, const
  double x[2]);
static void polyfit(const double x[2], const double y[2], double p[2]);
static double rt_hypotd_snf(double u0, double u1);
static double rt_remd_snf(double u0, double u1);
static void sortIdx(const double x[3], int idx[3]);
static void xgeqp3(double A[4], double tau[2], int jpvt[2]);
static double xnrm2(int n, const double x[4], int ix0);

// Function Definitions

//
// Arguments    : double x
// Return Type  : double
//
static double eps(double x)
{
  double r;
  double absxk;
  int exponent;
  absxk = std::abs(x);
  if ((!rtIsInf(absxk)) && (!rtIsNaN(absxk))) {
    if (absxk <= 2.2250738585072014E-308) {
      r = 4.94065645841247E-324;
    } else {
      frexp(absxk, &exponent);
      r = std::ldexp(1.0, exponent - 53);
    }
  } else {
    r = rtNaN;
  }

  return r;
}

//
// Arguments    : const struct_T funfcn_tunableEnvironment[1]
//                double x[2]
// Return Type  : void
//
static void fminsearch(const struct_T funfcn_tunableEnvironment[1], double x[2])
{
  c_coder_internal_anonymous_func fcn;
  double cfv;
  double fv[3];
  int lastCol;
  int colIdx;
  double v[6];
  int idx[3];
  bool doShrink;
  int itercount;
  int fun_evals;
  double xr_idx_1;
  int firstCol;
  double d0;
  bool exitg1;
  double d1;
  int i3;
  double maxfv;
  double z1[4];
  double cfv_tmp;
  double b_cfv_tmp;
  double c_cfv_tmp;
  double d2;
  double maxv;
  bool p;
  int colIdx_tmp;
  double xr_idx_0;
  double d3;
  double b_v;
  bool guard1 = false;
  double fvt[3];
  int idxb[3];
  fcn.tunableEnvironment[0] = funfcn_tunableEnvironment[0];
  cfv = getCheckFcn(&fcn, x);
  fv[0] = cfv;
  for (lastCol = 0; lastCol < 3; lastCol++) {
    colIdx = lastCol << 1;
    v[colIdx] = x[0];
    v[1 + colIdx] = x[1];
  }

  for (lastCol = 0; lastCol < 2; lastCol++) {
    colIdx = (lastCol + 1) << 1;
    if (x[lastCol] != 0.0) {
      v[lastCol + colIdx] = 1.05 * x[lastCol];
    } else {
      v[lastCol + colIdx] = 0.00025;
    }

    xr_idx_1 = v[1 + colIdx];
    d0 = funfcn_tunableEnvironment[0].Latitude[0] - xr_idx_1;
    d1 = d0 * d0;
    d0 = funfcn_tunableEnvironment[0].Longitude[0] - v[colIdx];
    d1 += d0 * d0;
    z1[0] = d1;
    d0 = funfcn_tunableEnvironment[0].Latitude[1] - xr_idx_1;
    d1 = d0 * d0;
    d0 = funfcn_tunableEnvironment[0].Longitude[1] - v[colIdx];
    d1 += d0 * d0;
    z1[1] = d1;
    d0 = funfcn_tunableEnvironment[0].Latitude[2] - xr_idx_1;
    d1 = d0 * d0;
    d0 = funfcn_tunableEnvironment[0].Longitude[2] - v[colIdx];
    d1 += d0 * d0;
    z1[2] = d1;
    d0 = funfcn_tunableEnvironment[0].Latitude[3] - xr_idx_1;
    d1 = d0 * d0;
    d0 = funfcn_tunableEnvironment[0].Longitude[3] - v[colIdx];
    d1 += d0 * d0;
    fv[lastCol + 1] = ((z1[0] + z1[1]) + z1[2]) + d1;
  }

  sortIdx(fv, idx);
  doShrink = false;
  itercount = 1;
  fun_evals = 3;
  lastCol = (idx[2] - 1) << 1;
  firstCol = (idx[0] - 1) << 1;
  exitg1 = false;
  while ((!exitg1) && ((fun_evals < 400) && (itercount < 400))) {
    maxfv = 0.0;
    cfv_tmp = fv[idx[0] - 1];
    b_cfv_tmp = fv[idx[1] - 1];
    cfv = std::abs(cfv_tmp - b_cfv_tmp);
    if (cfv > 0.0) {
      maxfv = cfv;
    }

    c_cfv_tmp = fv[idx[2] - 1];
    cfv = std::abs(cfv_tmp - c_cfv_tmp);
    if (cfv > maxfv) {
      maxfv = cfv;
    }

    cfv = 10.0 * eps(fv[idx[0] - 1]);
    cfv = 10.0 * eps(cfv);
    if ((0.0001 > cfv) || rtIsNaN(cfv)) {
      d2 = 0.0001;
    } else {
      d2 = cfv;
    }

    if (maxfv > d2) {
      p = false;
    } else {
      maxv = 0.0;
      i3 = (idx[0] - 1) << 1;
      colIdx_tmp = (idx[1] - 1) << 1;
      cfv = std::abs(v[i3] - v[colIdx_tmp]);
      if (cfv > 0.0) {
        maxv = cfv;
      }

      maxfv = v[1 + i3];
      cfv = std::abs(maxfv - v[1 + colIdx_tmp]);
      if (cfv > maxv) {
        maxv = cfv;
      }

      colIdx = (idx[2] - 1) << 1;
      cfv = std::abs(v[i3] - v[colIdx]);
      if (cfv > maxv) {
        maxv = cfv;
      }

      cfv = std::abs(maxfv - v[1 + colIdx]);
      if (cfv > maxv) {
        maxv = cfv;
      }

      cfv = v[i3];
      d0 = v[i3 + 1];
      if (d0 > v[i3]) {
        cfv = d0;
      }

      cfv = 10.0 * eps(cfv);
      if ((0.0001 > cfv) || rtIsNaN(cfv)) {
        d3 = 0.0001;
      } else {
        d3 = cfv;
      }

      p = (maxv <= d3);
    }

    if (!p) {
      i3 = (idx[1] - 1) << 1;
      d0 = (v[firstCol] + v[i3]) / 2.0;
      maxfv = d0;
      xr_idx_0 = 2.0 * d0 - v[lastCol];
      d0 = (v[1 + firstCol] + v[1 + i3]) / 2.0;
      maxv = v[1 + lastCol];
      xr_idx_1 = 2.0 * d0 - maxv;
      d1 = funfcn_tunableEnvironment[0].Latitude[0] - xr_idx_1;
      cfv = d1 * d1;
      d1 = funfcn_tunableEnvironment[0].Longitude[0] - xr_idx_0;
      cfv += d1 * d1;
      z1[0] = cfv;
      d1 = funfcn_tunableEnvironment[0].Latitude[1] - xr_idx_1;
      cfv = d1 * d1;
      d1 = funfcn_tunableEnvironment[0].Longitude[1] - xr_idx_0;
      cfv += d1 * d1;
      z1[1] = cfv;
      d1 = funfcn_tunableEnvironment[0].Latitude[2] - xr_idx_1;
      cfv = d1 * d1;
      d1 = funfcn_tunableEnvironment[0].Longitude[2] - xr_idx_0;
      cfv += d1 * d1;
      z1[2] = cfv;
      d1 = funfcn_tunableEnvironment[0].Latitude[3] - xr_idx_1;
      cfv = d1 * d1;
      d1 = funfcn_tunableEnvironment[0].Longitude[3] - xr_idx_0;
      cfv += d1 * d1;
      b_v = ((z1[0] + z1[1]) + z1[2]) + cfv;
      fun_evals++;
      if (b_v < cfv_tmp) {
        maxfv = 3.0 * maxfv - 2.0 * v[lastCol];
        maxv = 3.0 * d0 - 2.0 * v[1 + lastCol];
        d0 = funfcn_tunableEnvironment[0].Latitude[0] - maxv;
        d1 = d0 * d0;
        d0 = funfcn_tunableEnvironment[0].Longitude[0] - maxfv;
        d1 += d0 * d0;
        z1[0] = d1;
        d0 = funfcn_tunableEnvironment[0].Latitude[1] - maxv;
        d1 = d0 * d0;
        d0 = funfcn_tunableEnvironment[0].Longitude[1] - maxfv;
        d1 += d0 * d0;
        z1[1] = d1;
        d0 = funfcn_tunableEnvironment[0].Latitude[2] - maxv;
        d1 = d0 * d0;
        d0 = funfcn_tunableEnvironment[0].Longitude[2] - maxfv;
        d1 += d0 * d0;
        z1[2] = d1;
        d0 = funfcn_tunableEnvironment[0].Latitude[3] - maxv;
        d1 = d0 * d0;
        d0 = funfcn_tunableEnvironment[0].Longitude[3] - maxfv;
        d1 += d0 * d0;
        cfv = ((z1[0] + z1[1]) + z1[2]) + d1;
        fun_evals++;
        if (cfv < b_v) {
          v[lastCol] = maxfv;
          v[1 + lastCol] = maxv;
          fv[idx[2] - 1] = cfv;
        } else {
          v[lastCol] = xr_idx_0;
          v[1 + lastCol] = xr_idx_1;
          fv[idx[2] - 1] = b_v;
        }
      } else if (b_v < b_cfv_tmp) {
        v[lastCol] = xr_idx_0;
        v[1 + lastCol] = xr_idx_1;
        fv[idx[2] - 1] = b_v;
      } else {
        guard1 = false;
        if (b_v < c_cfv_tmp) {
          x[0] = 1.5 * maxfv - 0.5 * v[lastCol];
          x[1] = 1.5 * d0 - 0.5 * v[1 + lastCol];
          cfv = x[1];
          maxfv = x[0];
          d0 = funfcn_tunableEnvironment[0].Latitude[0] - cfv;
          d1 = d0 * d0;
          d0 = funfcn_tunableEnvironment[0].Longitude[0] - maxfv;
          d1 += d0 * d0;
          z1[0] = d1;
          d0 = funfcn_tunableEnvironment[0].Latitude[1] - cfv;
          d1 = d0 * d0;
          d0 = funfcn_tunableEnvironment[0].Longitude[1] - maxfv;
          d1 += d0 * d0;
          z1[1] = d1;
          d0 = funfcn_tunableEnvironment[0].Latitude[2] - cfv;
          d1 = d0 * d0;
          d0 = funfcn_tunableEnvironment[0].Longitude[2] - maxfv;
          d1 += d0 * d0;
          z1[2] = d1;
          d0 = funfcn_tunableEnvironment[0].Latitude[3] - cfv;
          d1 = d0 * d0;
          d0 = funfcn_tunableEnvironment[0].Longitude[3] - maxfv;
          d1 += d0 * d0;
          cfv = ((z1[0] + z1[1]) + z1[2]) + d1;
          fun_evals++;
          if (cfv <= b_v) {
            v[lastCol] = x[0];
            v[1 + lastCol] = x[1];
            fv[idx[2] - 1] = cfv;
          } else {
            doShrink = true;
            guard1 = true;
          }
        } else {
          x[0] = 0.5 * maxfv + 0.5 * v[lastCol];
          x[1] = 0.5 * d0 + 0.5 * maxv;
          cfv = x[1];
          maxfv = x[0];
          d0 = funfcn_tunableEnvironment[0].Latitude[0] - cfv;
          d1 = d0 * d0;
          d0 = funfcn_tunableEnvironment[0].Longitude[0] - maxfv;
          d1 += d0 * d0;
          z1[0] = d1;
          d0 = funfcn_tunableEnvironment[0].Latitude[1] - cfv;
          d1 = d0 * d0;
          d0 = funfcn_tunableEnvironment[0].Longitude[1] - maxfv;
          d1 += d0 * d0;
          z1[1] = d1;
          d0 = funfcn_tunableEnvironment[0].Latitude[2] - cfv;
          d1 = d0 * d0;
          d0 = funfcn_tunableEnvironment[0].Longitude[2] - maxfv;
          d1 += d0 * d0;
          z1[2] = d1;
          d0 = funfcn_tunableEnvironment[0].Latitude[3] - cfv;
          d1 = d0 * d0;
          d0 = funfcn_tunableEnvironment[0].Longitude[3] - maxfv;
          d1 += d0 * d0;
          b_v = ((z1[0] + z1[1]) + z1[2]) + d1;
          fun_evals++;
          if (b_v < c_cfv_tmp) {
            v[lastCol] = x[0];
            v[1 + lastCol] = x[1];
            fv[idx[2] - 1] = b_v;
          } else {
            doShrink = true;
            guard1 = true;
          }
        }

        if (guard1) {
          for (lastCol = 0; lastCol < 2; lastCol++) {
            colIdx_tmp = idx[lastCol + 1] - 1;
            colIdx = (colIdx_tmp << 1) - 1;
            v[1 + colIdx] = v[firstCol] + 0.5 * (v[1 + colIdx] - v[firstCol]);
            x[0] = v[1 + colIdx];
            cfv = v[firstCol + 1];
            v[2 + colIdx] = cfv + 0.5 * (v[2 + colIdx] - cfv);
            x[1] = v[2 + colIdx];
            cfv = x[1];
            maxfv = x[0];
            d0 = funfcn_tunableEnvironment[0].Latitude[0] - cfv;
            d1 = d0 * d0;
            d0 = funfcn_tunableEnvironment[0].Longitude[0] - maxfv;
            d1 += d0 * d0;
            z1[0] = d1;
            d0 = funfcn_tunableEnvironment[0].Latitude[1] - cfv;
            d1 = d0 * d0;
            d0 = funfcn_tunableEnvironment[0].Longitude[1] - maxfv;
            d1 += d0 * d0;
            z1[1] = d1;
            d0 = funfcn_tunableEnvironment[0].Latitude[2] - cfv;
            d1 = d0 * d0;
            d0 = funfcn_tunableEnvironment[0].Longitude[2] - maxfv;
            d1 += d0 * d0;
            z1[2] = d1;
            d0 = funfcn_tunableEnvironment[0].Latitude[3] - cfv;
            d1 = d0 * d0;
            d0 = funfcn_tunableEnvironment[0].Longitude[3] - maxfv;
            d1 += d0 * d0;
            fv[colIdx_tmp] = ((z1[0] + z1[1]) + z1[2]) + d1;
          }

          fun_evals += 2;
        }
      }

      if (doShrink) {
        fvt[0] = fv[idx[0] - 1];
        idxb[0] = idx[0];
        fvt[1] = fv[idx[1] - 1];
        idxb[1] = idx[1];
        fvt[2] = fv[idx[2] - 1];
        idxb[2] = idx[2];
        sortIdx(fvt, idx);
        idx[0] = idxb[idx[0] - 1];
        idx[1] = idxb[idx[1] - 1];
        idx[2] = idxb[idx[2] - 1];
        doShrink = false;
      } else {
        if (fv[idx[2] - 1] < fv[idx[1] - 1]) {
          colIdx = idx[2];
          idx[2] = idx[1];
          idx[1] = colIdx;
        }

        if (fv[idx[1] - 1] < fv[idx[0] - 1]) {
          colIdx = idx[1];
          idx[1] = idx[0];
          idx[0] = colIdx;
        }
      }

      itercount++;
      lastCol = (idx[2] - 1) << 1;
      firstCol = (idx[0] - 1) << 1;
    } else {
      exitg1 = true;
    }
  }

  i3 = (idx[0] - 1) << 1;
  x[0] = v[i3];
  x[1] = v[1 + i3];
}

//
// Arguments    : const double FunFcn_tunableEnvironment_f1[8]
//                double FunFcn_tunableEnvironment_f2
//                double x
// Return Type  : double
//
static double fzero(const double FunFcn_tunableEnvironment_f1[8], double
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
// Arguments    : const c_coder_internal_anonymous_func *fcn
//                const double x[2]
// Return Type  : double
//
static double getCheckFcn(const c_coder_internal_anonymous_func *fcn, const
  double x[2])
{
  double d4;
  double d5;
  double z1[4];
  d4 = fcn->tunableEnvironment[0].Latitude[0] - x[1];
  d5 = d4 * d4;
  d4 = fcn->tunableEnvironment[0].Longitude[0] - x[0];
  d5 += d4 * d4;
  z1[0] = d5;
  d4 = fcn->tunableEnvironment[0].Latitude[1] - x[1];
  d5 = d4 * d4;
  d4 = fcn->tunableEnvironment[0].Longitude[1] - x[0];
  d5 += d4 * d4;
  z1[1] = d5;
  d4 = fcn->tunableEnvironment[0].Latitude[2] - x[1];
  d5 = d4 * d4;
  d4 = fcn->tunableEnvironment[0].Longitude[2] - x[0];
  d5 += d4 * d4;
  z1[2] = d5;
  d4 = fcn->tunableEnvironment[0].Latitude[3] - x[1];
  d5 = d4 * d4;
  d4 = fcn->tunableEnvironment[0].Longitude[3] - x[0];
  d5 += d4 * d4;
  return ((z1[0] + z1[1]) + z1[2]) + d5;
}

//
// Arguments    : const double x[2]
//                const double y[2]
//                double p[2]
// Return Type  : void
//
static void polyfit(const double x[2], const double y[2], double p[2])
{
  double V[4];
  double tau[2];
  int jpvt[2];
  double B_idx_0;
  double B_idx_1;
  double wj;
  int i;
  double B;
  V[2] = 1.0;
  V[0] = x[0];
  V[3] = 1.0;
  V[1] = x[1];
  xgeqp3(V, tau, jpvt);
  B_idx_0 = y[0];
  p[0] = 0.0;
  B_idx_1 = y[1];
  p[1] = 0.0;
  if (tau[0] != 0.0) {
    wj = y[0];
    for (i = 2; i < 3; i++) {
      wj += V[1] * B_idx_1;
    }

    wj *= tau[0];
    if (wj != 0.0) {
      B_idx_0 = y[0] - wj;
      B = y[1];
      for (i = 2; i < 3; i++) {
        B -= V[1] * wj;
        B_idx_1 = B;
      }
    }
  }

  p[jpvt[0] - 1] = B_idx_0;
  if (tau[1] != 0.0) {
    wj = tau[1] * B_idx_1;
    if (wj != 0.0) {
      B_idx_1 -= wj;
    }
  }

  p[jpvt[1] - 1] = B_idx_1;
  p[jpvt[1] - 1] /= V[3];
  for (i = 0; i < 1; i++) {
    p[jpvt[0] - 1] -= p[jpvt[1] - 1] * V[2];
  }

  p[jpvt[0] - 1] /= V[0];
}

//
// Arguments    : double u0
//                double u1
// Return Type  : double
//
static double rt_hypotd_snf(double u0, double u1)
{
  double y;
  double a;
  double b;
  a = std::abs(u0);
  b = std::abs(u1);
  if (a < b) {
    a /= b;
    y = b * std::sqrt(a * a + 1.0);
  } else if (a > b) {
    b /= a;
    y = a * std::sqrt(b * b + 1.0);
  } else if (rtIsNaN(b)) {
    y = b;
  } else {
    y = a * 1.4142135623730951;
  }

  return y;
}

//
// Arguments    : double u0
//                double u1
// Return Type  : double
//
static double rt_remd_snf(double u0, double u1)
{
  double y;
  double b_u1;
  double q;
  if (rtIsNaN(u0) || rtIsInf(u0) || (rtIsNaN(u1) || rtIsInf(u1))) {
    y = rtNaN;
  } else {
    if (u1 < 0.0) {
      b_u1 = std::ceil(u1);
    } else {
      b_u1 = std::floor(u1);
    }

    if ((u1 != 0.0) && (u1 != b_u1)) {
      q = std::abs(u0 / u1);
      if (std::abs(q - std::floor(q + 0.5)) <= DBL_EPSILON * q) {
        y = 0.0 * u0;
      } else {
        y = std::fmod(u0, u1);
      }
    } else {
      y = std::fmod(u0, u1);
    }
  }

  return y;
}

//
// Arguments    : const double x[3]
//                int idx[3]
// Return Type  : void
//
static void sortIdx(const double x[3], int idx[3])
{
  if ((x[0] <= x[1]) || rtIsNaN(x[1])) {
    if ((x[1] <= x[2]) || rtIsNaN(x[2])) {
      idx[0] = 1;
      idx[1] = 2;
      idx[2] = 3;
    } else if ((x[0] <= x[2]) || rtIsNaN(x[2])) {
      idx[0] = 1;
      idx[1] = 3;
      idx[2] = 2;
    } else {
      idx[0] = 3;
      idx[1] = 1;
      idx[2] = 2;
    }
  } else if ((x[0] <= x[2]) || rtIsNaN(x[2])) {
    idx[0] = 2;
    idx[1] = 1;
    idx[2] = 3;
  } else if ((x[1] <= x[2]) || rtIsNaN(x[2])) {
    idx[0] = 2;
    idx[1] = 3;
    idx[2] = 1;
  } else {
    idx[0] = 3;
    idx[1] = 2;
    idx[2] = 1;
  }
}

//
// Arguments    : double A[4]
//                double tau[2]
//                int jpvt[2]
// Return Type  : void
//
static void xgeqp3(double A[4], double tau[2], int jpvt[2])
{
  double work[2];
  double beta1;
  double scale;
  int jy;
  double vn1[2];
  double smax;
  double t;
  int b;
  int ix;
  int itemp;
  int lastv;
  int lastc;
  int i1;
  int exitg1;
  int i2;
  int ijA;
  jpvt[0] = 1;
  work[0] = 0.0;
  beta1 = 0.0;
  scale = 3.3121686421112381E-170;
  for (jy = 1; jy < 3; jy++) {
    smax = std::abs(A[jy - 1]);
    if (smax > scale) {
      t = scale / smax;
      beta1 = 1.0 + beta1 * t * t;
      scale = smax;
    } else {
      t = smax / scale;
      beta1 += t * t;
    }
  }

  vn1[0] = scale * std::sqrt(beta1);
  jpvt[1] = 2;
  work[1] = 0.0;
  beta1 = 0.0;
  scale = 3.3121686421112381E-170;
  for (jy = 3; jy < 5; jy++) {
    smax = std::abs(A[jy - 1]);
    if (smax > scale) {
      t = scale / smax;
      beta1 = 1.0 + beta1 * t * t;
      scale = smax;
    } else {
      t = smax / scale;
      beta1 += t * t;
    }
  }

  vn1[1] = scale * std::sqrt(beta1);
  b = 0;
  ix = 0;
  smax = vn1[0];
  for (jy = 2; jy < 3; jy++) {
    ix++;
    if (vn1[ix] > smax) {
      b = 1;
      smax = vn1[ix];
    }
  }

  if (b != 0) {
    ix = b << 1;
    smax = A[ix];
    A[ix] = A[0];
    A[0] = smax;
    ix++;
    smax = A[ix];
    A[ix] = A[1];
    A[1] = smax;
    itemp = jpvt[b];
    jpvt[b] = 1;
    jpvt[0] = itemp;
  }

  scale = A[0];
  tau[0] = 0.0;
  smax = xnrm2(1, A, 2);
  if (smax != 0.0) {
    beta1 = rt_hypotd_snf(A[0], smax);
    if (A[0] >= 0.0) {
      beta1 = -beta1;
    }

    if (std::abs(beta1) < 1.0020841800044864E-292) {
      itemp = -1;
      do {
        itemp++;
        for (jy = 2; jy < 3; jy++) {
          A[1] *= 9.9792015476736E+291;
        }

        beta1 *= 9.9792015476736E+291;
        scale *= 9.9792015476736E+291;
      } while (!(std::abs(beta1) >= 1.0020841800044864E-292));

      beta1 = rt_hypotd_snf(scale, xnrm2(1, A, 2));
      if (scale >= 0.0) {
        beta1 = -beta1;
      }

      tau[0] = (beta1 - scale) / beta1;
      smax = 1.0 / (scale - beta1);
      for (jy = 2; jy < 3; jy++) {
        A[1] *= smax;
      }

      for (jy = 0; jy <= itemp; jy++) {
        beta1 *= 1.0020841800044864E-292;
      }

      scale = beta1;
    } else {
      tau[0] = (beta1 - A[0]) / beta1;
      smax = 1.0 / (A[0] - beta1);
      for (jy = 2; jy < 3; jy++) {
        A[1] *= smax;
      }

      scale = beta1;
    }
  }

  A[0] = scale;
  scale = A[0];
  A[0] = 1.0;
  if (tau[0] != 0.0) {
    lastv = 2;
    itemp = 1;
    while ((lastv > 0) && (A[itemp] == 0.0)) {
      lastv--;
      itemp--;
    }

    lastc = 1;
    itemp = 3;
    do {
      exitg1 = 0;
      if (itemp <= lastv + 2) {
        if (A[itemp - 1] != 0.0) {
          exitg1 = 1;
        } else {
          itemp++;
        }
      } else {
        lastc = 0;
        exitg1 = 1;
      }
    } while (exitg1 == 0);
  } else {
    lastv = 0;
    lastc = 0;
  }

  if (lastv > 0) {
    if (lastc != 0) {
      work[0] = 0.0;
      jy = 0;
      i1 = lastv + 2;
      for (b = 0; b <= 0; b += 2) {
        ix = 0;
        smax = 0.0;
        for (itemp = 3; itemp <= i1; itemp++) {
          smax += A[itemp - 1] * A[ix];
          ix++;
        }

        work[jy] += smax;
        jy++;
      }
    }

    if (!(-tau[0] == 0.0)) {
      itemp = 2;
      jy = 0;
      for (b = 0; b < lastc; b++) {
        if (work[jy] != 0.0) {
          smax = work[jy] * -tau[0];
          ix = 0;
          i1 = itemp + 1;
          i2 = lastv + itemp;
          for (ijA = i1; ijA <= i2; ijA++) {
            A[ijA - 1] += A[ix] * smax;
            ix++;
          }
        }

        jy++;
        itemp += 2;
      }
    }
  }

  A[0] = scale;
  tau[1] = 0.0;
}

//
// Arguments    : int n
//                const double x[4]
//                int ix0
// Return Type  : double
//
static double xnrm2(int n, const double x[4], int ix0)
{
  double y;
  double scale;
  int kend;
  int k;
  double absxk;
  double t;
  y = 0.0;
  if (n >= 1) {
    if (n == 1) {
      y = std::abs(x[ix0 - 1]);
    } else {
      scale = 3.3121686421112381E-170;
      kend = (ix0 + n) - 1;
      for (k = ix0; k <= kend; k++) {
        absxk = std::abs(x[k - 1]);
        if (absxk > scale) {
          t = scale / absxk;
          y = 1.0 + y * t * t;
          scale = absxk;
        } else {
          t = absxk / scale;
          y += t * t;
        }
      }

      y = scale * std::sqrt(y);
    }
  }

  return y;
}

//
// function rocket_location = find_rocket_c(people)
// Latitude (North south)
// Longitude (East West)
// Up to 4 positionings
// Arguments    : struct0_T *people
//                double rocket_location[2]
// Return Type  : void
//
void find_rocket_c(struct0_T *people, double rocket_location[2])
{
  int i0;
  int i;
  bool rEQ0;
  double P[8];
  bool b0;
  double lon_intersect;
  double absx;
  int P_tmp;
  double q;
  signed char n;
  double diff_polynom[8];
  double b_people[2];
  struct_T tunableEnvironment[1];
  double c_people[2];
  int b_P_tmp;
  double p[2];

  // 'find_rocket_c:6' max_length = 4;
  // 'find_rocket_c:8' figure;
  // 'find_rocket_c:8' hold on;
  // 'find_rocket_c:8' grid on;
  // 'find_rocket_c:9' for i =1:people.length
  i0 = (int)people->length;
  for (i = 0; i < i0; i++) {
    // 'find_rocket_c:10' lat = [people.Latitude(i); people.Latitude(i) + 0.02 * sind(90+people.degrees(i))]; 
    rEQ0 = rtIsInf(90.0 + people->degrees[i]);
    b0 = rtIsNaN(90.0 + people->degrees[i]);
    if (rEQ0 || b0) {
      lon_intersect = rtNaN;
    } else {
      lon_intersect = rt_remd_snf(90.0 + people->degrees[i], 360.0);
      absx = std::abs(lon_intersect);
      if (absx > 180.0) {
        if (lon_intersect > 0.0) {
          lon_intersect -= 360.0;
        } else {
          lon_intersect += 360.0;
        }

        absx = std::abs(lon_intersect);
      }

      if (absx <= 45.0) {
        lon_intersect *= 0.017453292519943295;
        n = 0;
      } else if (absx <= 135.0) {
        if (lon_intersect > 0.0) {
          lon_intersect = 0.017453292519943295 * (lon_intersect - 90.0);
          n = 1;
        } else {
          lon_intersect = 0.017453292519943295 * (lon_intersect + 90.0);
          n = -1;
        }
      } else if (lon_intersect > 0.0) {
        lon_intersect = 0.017453292519943295 * (lon_intersect - 180.0);
        n = 2;
      } else {
        lon_intersect = 0.017453292519943295 * (lon_intersect + 180.0);
        n = -2;
      }

      if (n == 0) {
        lon_intersect = std::sin(lon_intersect);
      } else if (n == 1) {
        lon_intersect = std::cos(lon_intersect);
      } else if (n == -1) {
        lon_intersect = -std::cos(lon_intersect);
      } else {
        lon_intersect = -std::sin(lon_intersect);
      }
    }

    // 'find_rocket_c:11' lon = [people.Longitude(i); people.Longitude(i) + 0.02 * cosd(90+people.degrees(i))]; 
    if (rEQ0 || b0) {
      q = rtNaN;
    } else {
      q = rt_remd_snf(90.0 + people->degrees[i], 360.0);
      absx = std::abs(q);
      if (absx > 180.0) {
        if (q > 0.0) {
          q -= 360.0;
        } else {
          q += 360.0;
        }

        absx = std::abs(q);
      }

      if (absx <= 45.0) {
        q *= 0.017453292519943295;
        n = 0;
      } else if (absx <= 135.0) {
        if (q > 0.0) {
          q = 0.017453292519943295 * (q - 90.0);
          n = 1;
        } else {
          q = 0.017453292519943295 * (q + 90.0);
          n = -1;
        }
      } else if (q > 0.0) {
        q = 0.017453292519943295 * (q - 180.0);
        n = 2;
      } else {
        q = 0.017453292519943295 * (q + 180.0);
        n = -2;
      }

      if (n == 0) {
        q = std::cos(q);
      } else if (n == 1) {
        q = -std::sin(q);
      } else if (n == -1) {
        q = std::sin(q);
      } else {
        q = -std::cos(q);
      }
    }

    // 'find_rocket_c:12' p = polyfit(lon,lat,1);
    b_people[0] = people->Longitude[i];
    b_people[1] = people->Longitude[i] + 0.02 * q;
    c_people[0] = people->Latitude[i];
    c_people[1] = people->Latitude[i] + 0.02 * lon_intersect;
    polyfit(b_people, c_people, p);

    // 'find_rocket_c:13' people.p(:,i) = p';
    P_tmp = i << 1;
    people->p[P_tmp] = p[0];
    people->p[1 + P_tmp] = p[1];

    // 'find_rocket_c:14' plot(people.Longitude(i), people.Latitude(i), 'r*');
    // 'find_rocket_c:15' line(lon, lat);
  }

  // alternative to circshift
  // 'find_rocket_c:19' P = zeros(2,max_length);
  memset(&P[0], 0, sizeof(double) << 3);

  // 'find_rocket_c:20' for i = 1:people.length
  i0 = (int)people->length;
  for (i = 0; i < i0; i++) {
    // 'find_rocket_c:21' P(:,i) = people.p(:, mod(i, people.length)+1);
    lon_intersect = 1.0 + (double)i;
    if ((!rtIsInf(people->length)) && (!rtIsNaN(people->length))) {
      if (people->length != 0.0) {
        lon_intersect = std::fmod(1.0 + (double)i, people->length);
        rEQ0 = (lon_intersect == 0.0);
        if ((!rEQ0) && (people->length > std::floor(people->length))) {
          q = std::abs((1.0 + (double)i) / people->length);
          rEQ0 = (std::abs(q - std::floor(q + 0.5)) <= 2.2204460492503131E-16 *
                  q);
        }

        if (rEQ0) {
          lon_intersect = people->length * 0.0;
        } else {
          if (people->length < 0.0) {
            lon_intersect += people->length;
          }
        }
      }
    } else {
      if (people->length != 0.0) {
        lon_intersect = rtNaN;
      }
    }

    P_tmp = ((int)(lon_intersect + 1.0) - 1) << 1;
    b_P_tmp = i << 1;
    P[b_P_tmp] = people->p[P_tmp];
    P[1 + b_P_tmp] = people->p[1 + P_tmp];
  }

  // 'find_rocket_c:24' diff_polynom = abs(P-people.p);
  for (P_tmp = 0; P_tmp < 8; P_tmp++) {
    lon_intersect = P[P_tmp] - people->p[P_tmp];
    diff_polynom[P_tmp] = std::abs(lon_intersect);
    P[P_tmp] = lon_intersect;
  }

  // 'find_rocket_c:26' intersection.Latitude = zeros(1,max_length);
  // 'find_rocket_c:27' intersection.Longitude = zeros(1,max_length);
  tunableEnvironment[0].Latitude[0] = 0.0;
  tunableEnvironment[0].Longitude[0] = 0.0;
  tunableEnvironment[0].Latitude[1] = 0.0;
  tunableEnvironment[0].Longitude[1] = 0.0;
  tunableEnvironment[0].Latitude[2] = 0.0;
  tunableEnvironment[0].Longitude[2] = 0.0;
  tunableEnvironment[0].Latitude[3] = 0.0;
  tunableEnvironment[0].Longitude[3] = 0.0;

  // calculate intersection
  // 'find_rocket_c:29' for i = 1:people.length
  for (i = 0; i < i0; i++) {
    // 'find_rocket_c:30' lon_intersect = fzero(@(x) polyval(diff_polynom(:,i), x),people.Longitude(i)); 
    lon_intersect = fzero(diff_polynom, (double)i + 1.0, people->Longitude[i]);

    // 'find_rocket_c:31' lat_intersect = polyval(people.p(1:2,i),lon_intersect); 
    P_tmp = i << 1;
    tunableEnvironment[0].Latitude[i] = lon_intersect * people->p[P_tmp] +
      people->p[1 + P_tmp];

    // 'find_rocket_c:32' plot(lon_intersect, lat_intersect,'g+');
    // 'find_rocket_c:33' intersection.Latitude(i) = lat_intersect;
    // 'find_rocket_c:34' intersection.Longitude(i) = lon_intersect;
    tunableEnvironment[0].Longitude[i] = lon_intersect;
  }

  // 'find_rocket_c:37' f_inter = @(point) sum((intersection.Latitude - point(2)).^2 + (intersection.Longitude - point(1)).^2); 
  // 'find_rocket_c:38' rocket_location = fminsearch(f_inter, [people.Latitude(1), people.Longitude(1)]); 
  rocket_location[0] = people->Latitude[0];
  rocket_location[1] = people->Longitude[0];
  fminsearch(tunableEnvironment, rocket_location);

  // 'find_rocket_c:39' plot(rocket_location(1), rocket_location(2), 'b*');
}

//
// Arguments    : void
// Return Type  : void
//
void find_rocket_c_initialize()
{
  rt_InitInfAndNaN(8U);
}

//
// Arguments    : void
// Return Type  : void
//
void find_rocket_c_terminate()
{
  // (no terminate code required)
}

//
// File trailer for find_rocket_c.cpp
//
// [EOF]
//

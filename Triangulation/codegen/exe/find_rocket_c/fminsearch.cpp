//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
// File: fminsearch.cpp
//
// MATLAB Coder version            : 4.1
// C/C++ source code generated on  : 18-Jun-2019 08:46:07
//

// Include Files
#include <cmath>
#include "rt_nonfinite.h"
#include "find_rocket_c.h"
#include "fminsearch.h"
#include "sortIdx.h"
#include "eps.h"

// Type Definitions
typedef struct {
  struct_T tunableEnvironment[1];
} c_coder_internal_anonymous_func;

// Function Declarations
static double getCheckFcn(const c_coder_internal_anonymous_func *fcn, const
  double x[2]);

// Function Definitions

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
// Arguments    : const struct_T funfcn_tunableEnvironment[1]
//                double x[2]
// Return Type  : void
//
void fminsearch(const struct_T funfcn_tunableEnvironment[1], double x[2])
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
// File trailer for fminsearch.cpp
//
// [EOF]
//

/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * fminsearch.cpp
 *
 * Code generation for function 'fminsearch'
 *
 */

/* Include files */
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "find_rocket_c.h"
#include "fminsearch.h"
#include "eps.h"
#include "sortIdx.h"

/* Function Definitions */

/*
 *
 */
void fminsearch(const struct_T funfcn_tunableEnvironment[1], real_T x[2])
{
  real_T cfv;
  real_T maxfv;
  real_T d0;
  real_T d1;
  real_T fvt[3];
  real_T fv[3];
  int32_T lastCol;
  int32_T colIdx;
  real_T v[6];
  int32_T idx[3];
  boolean_T doShrink;
  int32_T itercount;
  int32_T fun_evals;
  real_T xr_idx_1;
  int32_T firstCol;
  boolean_T exitg1;
  int32_T i1;
  real_T cfv_tmp;
  real_T b_cfv_tmp;
  real_T c_cfv_tmp;
  real_T maxv;
  boolean_T p;
  int32_T colIdx_tmp;
  real_T xr_idx_0;
  real_T b_v;
  boolean_T guard1 = false;
  int32_T idxb[3];
  cfv = x[1];
  maxfv = x[0];
  d0 = funfcn_tunableEnvironment[0].Latitude[0] - cfv;
  d1 = d0 * d0;
  d0 = funfcn_tunableEnvironment[0].Longitude[0] - maxfv;
  d1 += d0 * d0;
  fvt[0] = d1;
  d0 = funfcn_tunableEnvironment[0].Latitude[1] - cfv;
  d1 = d0 * d0;
  d0 = funfcn_tunableEnvironment[0].Longitude[1] - maxfv;
  d1 += d0 * d0;
  fvt[1] = d1;
  d0 = funfcn_tunableEnvironment[0].Latitude[2] - cfv;
  d1 = d0 * d0;
  d0 = funfcn_tunableEnvironment[0].Longitude[2] - maxfv;
  d1 += d0 * d0;
  fv[0] = (fvt[0] + fvt[1]) + d1;
  for (lastCol = 0; lastCol < 3; lastCol++) {
    colIdx = lastCol << 1;
    v[colIdx] = x[0];
    v[1 + colIdx] = x[1];
  }

  for (lastCol = 0; lastCol < 2; lastCol++) {
    colIdx = (1 + lastCol) << 1;
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
    fvt[0] = d1;
    d0 = funfcn_tunableEnvironment[0].Latitude[1] - xr_idx_1;
    d1 = d0 * d0;
    d0 = funfcn_tunableEnvironment[0].Longitude[1] - v[colIdx];
    d1 += d0 * d0;
    fvt[1] = d1;
    d0 = funfcn_tunableEnvironment[0].Latitude[2] - xr_idx_1;
    d1 = d0 * d0;
    d0 = funfcn_tunableEnvironment[0].Longitude[2] - v[colIdx];
    d1 += d0 * d0;
    fv[1 + lastCol] = (fvt[0] + fvt[1]) + d1;
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
    cfv = muDoubleScalarAbs(cfv_tmp - b_cfv_tmp);
    if (cfv > 0.0) {
      maxfv = cfv;
    }

    c_cfv_tmp = fv[idx[2] - 1];
    cfv = muDoubleScalarAbs(cfv_tmp - c_cfv_tmp);
    if (cfv > maxfv) {
      maxfv = cfv;
    }

    cfv = 10.0 * eps(fv[idx[0] - 1]);
    if (maxfv > muDoubleScalarMax(0.0001, 10.0 * eps(cfv))) {
      p = false;
    } else {
      maxv = 0.0;
      i1 = (idx[0] - 1) << 1;
      colIdx_tmp = (idx[1] - 1) << 1;
      cfv = muDoubleScalarAbs(v[i1] - v[colIdx_tmp]);
      if (cfv > 0.0) {
        maxv = cfv;
      }

      maxfv = v[1 + i1];
      cfv = muDoubleScalarAbs(maxfv - v[1 + colIdx_tmp]);
      if (cfv > maxv) {
        maxv = cfv;
      }

      colIdx = (idx[2] - 1) << 1;
      cfv = muDoubleScalarAbs(v[i1] - v[colIdx]);
      if (cfv > maxv) {
        maxv = cfv;
      }

      cfv = muDoubleScalarAbs(maxfv - v[1 + colIdx]);
      if (cfv > maxv) {
        maxv = cfv;
      }

      cfv = v[i1];
      d0 = v[i1 + 1];
      if (d0 > v[i1]) {
        cfv = d0;
      }

      p = (maxv <= muDoubleScalarMax(0.0001, 10.0 * eps(cfv)));
    }

    if (!p) {
      i1 = (idx[1] - 1) << 1;
      d0 = (v[firstCol] + v[i1]) / 2.0;
      maxfv = d0;
      xr_idx_0 = 2.0 * d0 - v[lastCol];
      d0 = (v[1 + firstCol] + v[1 + i1]) / 2.0;
      maxv = v[1 + lastCol];
      xr_idx_1 = 2.0 * d0 - maxv;
      d1 = funfcn_tunableEnvironment[0].Latitude[0] - xr_idx_1;
      cfv = d1 * d1;
      d1 = funfcn_tunableEnvironment[0].Longitude[0] - xr_idx_0;
      cfv += d1 * d1;
      fvt[0] = cfv;
      d1 = funfcn_tunableEnvironment[0].Latitude[1] - xr_idx_1;
      cfv = d1 * d1;
      d1 = funfcn_tunableEnvironment[0].Longitude[1] - xr_idx_0;
      cfv += d1 * d1;
      fvt[1] = cfv;
      d1 = funfcn_tunableEnvironment[0].Latitude[2] - xr_idx_1;
      cfv = d1 * d1;
      d1 = funfcn_tunableEnvironment[0].Longitude[2] - xr_idx_0;
      cfv += d1 * d1;
      b_v = (fvt[0] + fvt[1]) + cfv;
      fun_evals++;
      if (b_v < cfv_tmp) {
        maxfv = 3.0 * maxfv - 2.0 * v[lastCol];
        maxv = 3.0 * d0 - 2.0 * v[1 + lastCol];
        d0 = funfcn_tunableEnvironment[0].Latitude[0] - maxv;
        d1 = d0 * d0;
        d0 = funfcn_tunableEnvironment[0].Longitude[0] - maxfv;
        d1 += d0 * d0;
        fvt[0] = d1;
        d0 = funfcn_tunableEnvironment[0].Latitude[1] - maxv;
        d1 = d0 * d0;
        d0 = funfcn_tunableEnvironment[0].Longitude[1] - maxfv;
        d1 += d0 * d0;
        fvt[1] = d1;
        d0 = funfcn_tunableEnvironment[0].Latitude[2] - maxv;
        d1 = d0 * d0;
        d0 = funfcn_tunableEnvironment[0].Longitude[2] - maxfv;
        d1 += d0 * d0;
        cfv = (fvt[0] + fvt[1]) + d1;
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
          fvt[0] = d1;
          d0 = funfcn_tunableEnvironment[0].Latitude[1] - cfv;
          d1 = d0 * d0;
          d0 = funfcn_tunableEnvironment[0].Longitude[1] - maxfv;
          d1 += d0 * d0;
          fvt[1] = d1;
          d0 = funfcn_tunableEnvironment[0].Latitude[2] - cfv;
          d1 = d0 * d0;
          d0 = funfcn_tunableEnvironment[0].Longitude[2] - maxfv;
          d1 += d0 * d0;
          cfv = (fvt[0] + fvt[1]) + d1;
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
          fvt[0] = d1;
          d0 = funfcn_tunableEnvironment[0].Latitude[1] - cfv;
          d1 = d0 * d0;
          d0 = funfcn_tunableEnvironment[0].Longitude[1] - maxfv;
          d1 += d0 * d0;
          fvt[1] = d1;
          d0 = funfcn_tunableEnvironment[0].Latitude[2] - cfv;
          d1 = d0 * d0;
          d0 = funfcn_tunableEnvironment[0].Longitude[2] - maxfv;
          d1 += d0 * d0;
          b_v = (fvt[0] + fvt[1]) + d1;
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
            fvt[0] = d1;
            d0 = funfcn_tunableEnvironment[0].Latitude[1] - cfv;
            d1 = d0 * d0;
            d0 = funfcn_tunableEnvironment[0].Longitude[1] - maxfv;
            d1 += d0 * d0;
            fvt[1] = d1;
            d0 = funfcn_tunableEnvironment[0].Latitude[2] - cfv;
            d1 = d0 * d0;
            d0 = funfcn_tunableEnvironment[0].Longitude[2] - maxfv;
            d1 += d0 * d0;
            fv[colIdx_tmp] = (fvt[0] + fvt[1]) + d1;
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

  i1 = (idx[0] - 1) << 1;
  x[0] = v[i1];
  x[1] = v[1 + i1];
}

/* End of code generation (fminsearch.cpp) */

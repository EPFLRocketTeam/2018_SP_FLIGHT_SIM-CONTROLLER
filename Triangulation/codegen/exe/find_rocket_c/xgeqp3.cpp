//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
// File: xgeqp3.cpp
//
// MATLAB Coder version            : 4.1
// C/C++ source code generated on  : 18-Jun-2019 08:46:07
//

// Include Files
#include <cmath>
#include "rt_nonfinite.h"
#include "find_rocket_c.h"
#include "xgeqp3.h"
#include "xnrm2.h"

// Function Declarations
static double rt_hypotd_snf(double u0, double u1);

// Function Definitions

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
// Arguments    : double A[4]
//                double tau[2]
//                int jpvt[2]
// Return Type  : void
//
void xgeqp3(double A[4], double tau[2], int jpvt[2])
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
// File trailer for xgeqp3.cpp
//
// [EOF]
//

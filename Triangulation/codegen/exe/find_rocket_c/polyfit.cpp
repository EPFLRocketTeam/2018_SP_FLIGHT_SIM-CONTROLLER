//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
// File: polyfit.cpp
//
// MATLAB Coder version            : 4.1
// C/C++ source code generated on  : 18-Jun-2019 08:46:07
//

// Include Files
#include "rt_nonfinite.h"
#include "find_rocket_c.h"
#include "polyfit.h"
#include "xgeqp3.h"

// Function Definitions

//
// Arguments    : const double x[2]
//                const double y[2]
//                double p[2]
// Return Type  : void
//
void polyfit(const double x[2], const double y[2], double p[2])
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
// File trailer for polyfit.cpp
//
// [EOF]
//

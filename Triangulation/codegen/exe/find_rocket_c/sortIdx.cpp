//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
// File: sortIdx.cpp
//
// MATLAB Coder version            : 4.1
// C/C++ source code generated on  : 18-Jun-2019 08:46:07
//

// Include Files
#include "rt_nonfinite.h"
#include "find_rocket_c.h"
#include "sortIdx.h"

// Function Definitions

//
// Arguments    : const double x[3]
//                int idx[3]
// Return Type  : void
//
void sortIdx(const double x[3], int idx[3])
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
// File trailer for sortIdx.cpp
//
// [EOF]
//

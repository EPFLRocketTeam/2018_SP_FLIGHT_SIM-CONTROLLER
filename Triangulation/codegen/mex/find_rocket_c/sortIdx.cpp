/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * sortIdx.cpp
 *
 * Code generation for function 'sortIdx'
 *
 */

/* Include files */
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "find_rocket_c.h"
#include "sortIdx.h"

/* Function Definitions */

/*
 *
 */
void sortIdx(const real_T x[3], int32_T idx[3])
{
  if ((x[0] <= x[1]) || muDoubleScalarIsNaN(x[1])) {
    if ((x[1] <= x[2]) || muDoubleScalarIsNaN(x[2])) {
      idx[0] = 1;
      idx[1] = 2;
      idx[2] = 3;
    } else if ((x[0] <= x[2]) || muDoubleScalarIsNaN(x[2])) {
      idx[0] = 1;
      idx[1] = 3;
      idx[2] = 2;
    } else {
      idx[0] = 3;
      idx[1] = 1;
      idx[2] = 2;
    }
  } else if ((x[0] <= x[2]) || muDoubleScalarIsNaN(x[2])) {
    idx[0] = 2;
    idx[1] = 1;
    idx[2] = 3;
  } else if ((x[1] <= x[2]) || muDoubleScalarIsNaN(x[2])) {
    idx[0] = 2;
    idx[1] = 3;
    idx[2] = 1;
  } else {
    idx[0] = 3;
    idx[1] = 2;
    idx[2] = 1;
  }
}

/* End of code generation (sortIdx.cpp) */

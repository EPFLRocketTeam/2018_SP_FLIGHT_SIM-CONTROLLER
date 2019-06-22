/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xswap.cpp
 *
 * Code generation for function 'xswap'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "find_rocket_c.h"
#include "xswap.h"

/* Function Definitions */

/*
 *
 */
void xswap(real_T x[4], int32_T ix0, int32_T iy0)
{
  int32_T ix;
  int32_T iy;
  real_T temp;
  ix = ix0 - 1;
  iy = iy0 - 1;
  temp = x[ix];
  x[ix] = x[iy];
  x[iy] = temp;
  ix++;
  iy++;
  temp = x[ix];
  x[ix] = x[iy];
  x[iy] = temp;
}

/* End of code generation (xswap.cpp) */

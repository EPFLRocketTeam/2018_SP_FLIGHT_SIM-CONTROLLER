/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * sqrt.cpp
 *
 * Code generation for function 'sqrt'
 *
 */

/* Include files */
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "find_rocket_c.h"
#include "sqrt.h"
#include "error.h"

/* Variable Definitions */
static emlrtRSInfo r_emlrtRSI = { 12,  /* lineNo */
  "sqrt",                              /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/lib/matlab/elfun/sqrt.m"/* pathName */
};

/* Function Definitions */

/*
 *
 */
void b_sqrt(const emlrtStack *sp, real_T *x)
{
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  if (*x < 0.0) {
    st.site = &r_emlrtRSI;
    error(&st);
  }

  *x = muDoubleScalarSqrt(*x);
}

/* End of code generation (sqrt.cpp) */

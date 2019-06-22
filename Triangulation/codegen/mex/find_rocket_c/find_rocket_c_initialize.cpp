/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * find_rocket_c_initialize.cpp
 *
 * Code generation for function 'find_rocket_c_initialize'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "find_rocket_c.h"
#include "find_rocket_c_initialize.h"
#include "_coder_find_rocket_c_mex.h"
#include "find_rocket_c_data.h"

/* Function Definitions */
void find_rocket_c_initialize()
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (find_rocket_c_initialize.cpp) */

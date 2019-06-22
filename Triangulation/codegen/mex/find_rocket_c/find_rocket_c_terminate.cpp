/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * find_rocket_c_terminate.cpp
 *
 * Code generation for function 'find_rocket_c_terminate'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "find_rocket_c.h"
#include "find_rocket_c_terminate.h"
#include "_coder_find_rocket_c_mex.h"
#include "find_rocket_c_data.h"

/* Function Definitions */
void find_rocket_c_atexit()
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

void find_rocket_c_terminate()
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (find_rocket_c_terminate.cpp) */

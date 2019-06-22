/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_find_rocket_c_mex.cpp
 *
 * Code generation for function '_coder_find_rocket_c_mex'
 *
 */

/* Include files */
#include "find_rocket_c.h"
#include "_coder_find_rocket_c_mex.h"
#include "find_rocket_c_terminate.h"
#include "_coder_find_rocket_c_api.h"
#include "find_rocket_c_initialize.h"
#include "find_rocket_c_data.h"

/* Function Declarations */
static void find_rocket_c_mexFunction(int32_T nlhs, mxArray *plhs[1], int32_T
  nrhs, const mxArray *prhs[1]);

/* Function Definitions */
static void find_rocket_c_mexFunction(int32_T nlhs, mxArray *plhs[1], int32_T
  nrhs, const mxArray *prhs[1])
{
  const mxArray *outputs[1];
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 1, 4,
                        13, "find_rocket_c");
  }

  if (nlhs > 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 13,
                        "find_rocket_c");
  }

  /* Call the function. */
  find_rocket_c_api(prhs, nlhs, outputs);

  /* Copy over outputs to the caller. */
  emlrtReturnArrays(1, plhs, outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  mexAtExit(find_rocket_c_atexit);

  /* Module initialization. */
  find_rocket_c_initialize();

  /* Dispatch the entry-point. */
  find_rocket_c_mexFunction(nlhs, plhs, nrhs, prhs);

  /* Module termination. */
  find_rocket_c_terminate();
}

emlrtCTX mexFunctionCreateRootTLS()
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_find_rocket_c_mex.cpp) */

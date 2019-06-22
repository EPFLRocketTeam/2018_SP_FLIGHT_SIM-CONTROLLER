/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * error.cpp
 *
 * Code generation for function 'error'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "find_rocket_c.h"
#include "error.h"

/* Variable Definitions */
static emlrtRTEInfo emlrtRTEI = { 19,  /* lineNo */
  5,                                   /* colNo */
  "error",                             /* fName */
  "/Applications/MATLAB_R2018b.app/toolbox/shared/coder/coder/+coder/+internal/error.m"/* pName */
};

/* Function Definitions */

/*
 *
 */
void b_error(const emlrtStack *sp)
{
  emlrtErrorWithMessageIdR2018a(sp, &emlrtRTEI,
    "MATLAB:optimfun:fzero:ValueAtInitGuessComplexOrNotFinite",
    "MATLAB:optimfun:fzero:ValueAtInitGuessComplexOrNotFinite", 0);
}

/*
 *
 */
void error(const emlrtStack *sp)
{
  static const char_T varargin_1[4] = { 's', 'q', 'r', 't' };

  emlrtErrorWithMessageIdR2018a(sp, &emlrtRTEI, "Coder:toolbox:ElFunDomainError",
    "Coder:toolbox:ElFunDomainError", 3, 4, 4, *(char_T (*)[4])&varargin_1[0]);
}

/* End of code generation (error.cpp) */

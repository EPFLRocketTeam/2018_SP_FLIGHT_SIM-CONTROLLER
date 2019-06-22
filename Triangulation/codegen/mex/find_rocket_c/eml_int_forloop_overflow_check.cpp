/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * eml_int_forloop_overflow_check.cpp
 *
 * Code generation for function 'eml_int_forloop_overflow_check'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "find_rocket_c.h"
#include "eml_int_forloop_overflow_check.h"

/* Variable Definitions */
static emlrtRTEInfo b_emlrtRTEI = { 88,/* lineNo */
  9,                                   /* colNo */
  "eml_int_forloop_overflow_check",    /* fName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m"/* pName */
};

/* Function Definitions */

/*
 *
 */
void check_forloop_overflow_error(const emlrtStack *sp, boolean_T overflow)
{
  if (overflow) {
    emlrtErrorWithMessageIdR2018a(sp, &b_emlrtRTEI,
      "Coder:toolbox:int_forloop_overflow", "Coder:toolbox:int_forloop_overflow",
      3, 4, 5, "int32");
  }
}

/* End of code generation (eml_int_forloop_overflow_check.cpp) */

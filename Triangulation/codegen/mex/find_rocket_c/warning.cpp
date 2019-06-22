/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * warning.cpp
 *
 * Code generation for function 'warning'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "find_rocket_c.h"
#include "warning.h"

/* Variable Definitions */
static emlrtMCInfo i_emlrtMCI = { 14,  /* lineNo */
  25,                                  /* colNo */
  "warning",                           /* fName */
  "/Applications/MATLAB_R2018b.app/toolbox/shared/coder/coder/+coder/+internal/warning.m"/* pName */
};

static emlrtMCInfo j_emlrtMCI = { 14,  /* lineNo */
  9,                                   /* colNo */
  "warning",                           /* fName */
  "/Applications/MATLAB_R2018b.app/toolbox/shared/coder/coder/+coder/+internal/warning.m"/* pName */
};

static emlrtRSInfo vc_emlrtRSI = { 14, /* lineNo */
  "warning",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/shared/coder/coder/+coder/+internal/warning.m"/* pathName */
};

/* Function Declarations */
static void b_feval(const emlrtStack *sp, const mxArray *b, const mxArray *c,
                    emlrtMCInfo *location);
static const mxArray *c_feval(const emlrtStack *sp, const mxArray *b, const
  mxArray *c, emlrtMCInfo *location);
static const mxArray *feval(const emlrtStack *sp, const mxArray *b, const
  mxArray *c, const mxArray *d, const mxArray *e, emlrtMCInfo *location);

/* Function Definitions */
static void b_feval(const emlrtStack *sp, const mxArray *b, const mxArray *c,
                    emlrtMCInfo *location)
{
  const mxArray *pArrays[2];
  pArrays[0] = b;
  pArrays[1] = c;
  emlrtCallMATLABR2012b(sp, 0, NULL, 2, pArrays, "feval", true, location);
}

static const mxArray *c_feval(const emlrtStack *sp, const mxArray *b, const
  mxArray *c, emlrtMCInfo *location)
{
  const mxArray *pArrays[2];
  const mxArray *m7;
  pArrays[0] = b;
  pArrays[1] = c;
  return emlrtCallMATLABR2012b(sp, 1, &m7, 2, pArrays, "feval", true, location);
}

static const mxArray *feval(const emlrtStack *sp, const mxArray *b, const
  mxArray *c, const mxArray *d, const mxArray *e, emlrtMCInfo *location)
{
  const mxArray *pArrays[4];
  const mxArray *m6;
  pArrays[0] = b;
  pArrays[1] = c;
  pArrays[2] = d;
  pArrays[3] = e;
  return emlrtCallMATLABR2012b(sp, 1, &m6, 4, pArrays, "feval", true, location);
}

/*
 *
 */
void b_warning(const emlrtStack *sp)
{
  const mxArray *y;
  const mxArray *m3;
  static const int32_T iv12[2] = { 1, 7 };

  static const char_T u[7] = { 'w', 'a', 'r', 'n', 'i', 'n', 'g' };

  const mxArray *b_y;
  static const int32_T iv13[2] = { 1, 7 };

  static const char_T b_u[7] = { 'm', 'e', 's', 's', 'a', 'g', 'e' };

  const mxArray *c_y;
  static const int32_T iv14[2] = { 1, 44 };

  static const char_T msgID[44] = { 'C', 'o', 'd', 'e', 'r', ':', 'M', 'A', 'T',
    'L', 'A', 'B', ':', 'p', 'o', 'l', 'y', 'f', 'i', 't', '_', 'R', 'e', 'p',
    'e', 'a', 't', 'e', 'd', 'P', 'o', 'i', 'n', 't', 's', 'O', 'r', 'R', 'e',
    's', 'c', 'a', 'l', 'e' };

  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  y = NULL;
  m3 = emlrtCreateCharArray(2, iv12);
  emlrtInitCharArrayR2013a(sp, 7, m3, (char_T *)&u[0]);
  emlrtAssign(&y, m3);
  b_y = NULL;
  m3 = emlrtCreateCharArray(2, iv13);
  emlrtInitCharArrayR2013a(sp, 7, m3, (char_T *)&b_u[0]);
  emlrtAssign(&b_y, m3);
  c_y = NULL;
  m3 = emlrtCreateCharArray(2, iv14);
  emlrtInitCharArrayR2013a(sp, 44, m3, (char_T *)&msgID[0]);
  emlrtAssign(&c_y, m3);
  st.site = &vc_emlrtRSI;
  b_feval(&st, y, c_feval(&st, b_y, c_y, &i_emlrtMCI), &j_emlrtMCI);
}

/*
 *
 */
void warning(const emlrtStack *sp, int32_T varargin_1, const char_T varargin_2
             [14])
{
  const mxArray *y;
  const mxArray *m2;
  static const int32_T iv8[2] = { 1, 7 };

  static const char_T u[7] = { 'w', 'a', 'r', 'n', 'i', 'n', 'g' };

  const mxArray *b_y;
  static const int32_T iv9[2] = { 1, 7 };

  static const char_T b_u[7] = { 'm', 'e', 's', 's', 'a', 'g', 'e' };

  const mxArray *c_y;
  static const int32_T iv10[2] = { 1, 32 };

  static const char_T msgID[32] = { 'C', 'o', 'd', 'e', 'r', ':', 'M', 'A', 'T',
    'L', 'A', 'B', ':', 'r', 'a', 'n', 'k', 'D', 'e', 'f', 'i', 'c', 'i', 'e',
    'n', 't', 'M', 'a', 't', 'r', 'i', 'x' };

  const mxArray *d_y;
  const mxArray *e_y;
  static const int32_T iv11[2] = { 1, 14 };

  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  y = NULL;
  m2 = emlrtCreateCharArray(2, iv8);
  emlrtInitCharArrayR2013a(sp, 7, m2, (char_T *)&u[0]);
  emlrtAssign(&y, m2);
  b_y = NULL;
  m2 = emlrtCreateCharArray(2, iv9);
  emlrtInitCharArrayR2013a(sp, 7, m2, (char_T *)&b_u[0]);
  emlrtAssign(&b_y, m2);
  c_y = NULL;
  m2 = emlrtCreateCharArray(2, iv10);
  emlrtInitCharArrayR2013a(sp, 32, m2, (char_T *)&msgID[0]);
  emlrtAssign(&c_y, m2);
  d_y = NULL;
  m2 = emlrtCreateNumericMatrix(1, 1, mxINT32_CLASS, mxREAL);
  *(int32_T *)emlrtMxGetData(m2) = varargin_1;
  emlrtAssign(&d_y, m2);
  e_y = NULL;
  m2 = emlrtCreateCharArray(2, iv11);
  emlrtInitCharArrayR2013a(sp, 14, m2, (char_T *)&varargin_2[0]);
  emlrtAssign(&e_y, m2);
  st.site = &vc_emlrtRSI;
  b_feval(&st, y, feval(&st, b_y, c_y, d_y, e_y, &i_emlrtMCI), &j_emlrtMCI);
}

/* End of code generation (warning.cpp) */

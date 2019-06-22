/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * polyfit.cpp
 *
 * Code generation for function 'polyfit'
 *
 */

/* Include files */
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "find_rocket_c.h"
#include "polyfit.h"
#include "warning.h"
#include "xgeqp3.h"

/* Variable Definitions */
static emlrtRSInfo d_emlrtRSI = { 33,  /* lineNo */
  "polyfit",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/lib/matlab/polyfun/polyfit.m"/* pathName */
};

static emlrtRSInfo e_emlrtRSI = { 44,  /* lineNo */
  "polyfit",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/lib/matlab/polyfun/polyfit.m"/* pathName */
};

static emlrtRSInfo f_emlrtRSI = { 29,  /* lineNo */
  "qrsolve",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/qrsolve.m"/* pathName */
};

static emlrtRSInfo g_emlrtRSI = { 33,  /* lineNo */
  "qrsolve",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/qrsolve.m"/* pathName */
};

static emlrtRSInfo h_emlrtRSI = { 40,  /* lineNo */
  "qrsolve",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/qrsolve.m"/* pathName */
};

static emlrtRSInfo tb_emlrtRSI = { 124,/* lineNo */
  "qrsolve",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/qrsolve.m"/* pathName */
};

static emlrtRSInfo ub_emlrtRSI = { 123,/* lineNo */
  "qrsolve",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/qrsolve.m"/* pathName */
};

static emlrtRSInfo vb_emlrtRSI = { 73, /* lineNo */
  "qrsolve",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/qrsolve.m"/* pathName */
};

static emlrtRSInfo wb_emlrtRSI = { 80, /* lineNo */
  "qrsolve",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/qrsolve.m"/* pathName */
};

static emlrtRSInfo xb_emlrtRSI = { 87, /* lineNo */
  "qrsolve",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/qrsolve.m"/* pathName */
};

static emlrtRSInfo yb_emlrtRSI = { 90, /* lineNo */
  "qrsolve",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/qrsolve.m"/* pathName */
};

static emlrtRSInfo ac_emlrtRSI = { 34, /* lineNo */
  "xunormqr",                          /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+lapack/xunormqr.m"/* pathName */
};

static emlrtMCInfo h_emlrtMCI = { 53,  /* lineNo */
  19,                                  /* colNo */
  "flt2str",                           /* fName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/flt2str.m"/* pName */
};

static emlrtRSInfo uc_emlrtRSI = { 53, /* lineNo */
  "flt2str",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/flt2str.m"/* pathName */
};

/* Function Declarations */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, char_T y[14]);
static const mxArray *b_sprintf(const emlrtStack *sp, const mxArray *b, const
  mxArray *c, emlrtMCInfo *location);
static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *c_sprintf,
  const char_T *identifier, char_T y[14]);
static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, char_T ret[14]);

/* Function Definitions */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, char_T y[14])
{
  g_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static const mxArray *b_sprintf(const emlrtStack *sp, const mxArray *b, const
  mxArray *c, emlrtMCInfo *location)
{
  const mxArray *pArrays[2];
  const mxArray *m5;
  pArrays[0] = b;
  pArrays[1] = c;
  return emlrtCallMATLABR2012b(sp, 1, &m5, 2, pArrays, "sprintf", true, location);
}

static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *c_sprintf,
  const char_T *identifier, char_T y[14])
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = const_cast<const char *>(identifier);
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  b_emlrt_marshallIn(sp, emlrtAlias(c_sprintf), &thisId, y);
  emlrtDestroyArray(&c_sprintf);
}

static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, char_T ret[14])
{
  static const int32_T dims[2] = { 1, 14 };

  emlrtCheckBuiltInR2012b(sp, (const emlrtMsgIdentifier *)msgId, src, "char",
    false, 2U, *(int32_T (*)[2])&dims[0]);
  emlrtImportCharArrayR2015b(sp, src, &ret[0], 14);
  emlrtDestroyArray(&src);
}

/*
 *
 */
void polyfit(const emlrtStack *sp, const real_T x[2], const real_T y[2], real_T
             p[2])
{
  real_T V[4];
  real_T tau[2];
  int32_T jpvt[2];
  int32_T rr;
  real_T tol;
  const mxArray *b_y;
  const mxArray *m1;
  static const int32_T iv7[2] = { 1, 6 };

  static const char_T rfmt[6] = { '%', '1', '4', '.', '6', 'e' };

  real_T B_idx_1;
  const mxArray *c_y;
  char_T cv0[14];
  real_T wj;
  int32_T i;
  real_T B;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  V[2] = 1.0;
  V[0] = x[0];
  V[3] = 1.0;
  V[1] = x[1];
  st.site = &d_emlrtRSI;
  b_st.site = &f_emlrtRSI;
  xgeqp3(&b_st, V, tau, jpvt);
  b_st.site = &g_emlrtRSI;
  rr = 0;
  tol = 4.4408920985006262E-15 * muDoubleScalarAbs(V[0]);
  while ((rr < 2) && (!(muDoubleScalarAbs(V[rr + (rr << 1)]) <= tol))) {
    rr++;
  }

  if (rr < 2) {
    c_st.site = &tb_emlrtRSI;
    b_y = NULL;
    m1 = emlrtCreateCharArray(2, iv7);
    emlrtInitCharArrayR2013a(&c_st, 6, m1, (char_T *)&rfmt[0]);
    emlrtAssign(&b_y, m1);
    c_y = NULL;
    m1 = emlrtCreateDoubleScalar(tol);
    emlrtAssign(&c_y, m1);
    d_st.site = &uc_emlrtRSI;
    emlrt_marshallIn(&d_st, b_sprintf(&d_st, b_y, c_y, &h_emlrtMCI), "sprintf",
                     cv0);
    c_st.site = &ub_emlrtRSI;
    warning(&c_st, rr, cv0);
  }

  b_st.site = &h_emlrtRSI;
  tol = y[0];
  p[0] = 0.0;
  B_idx_1 = y[1];
  p[1] = 0.0;
  c_st.site = &vb_emlrtRSI;
  d_st.site = &ac_emlrtRSI;
  if (tau[0] != 0.0) {
    wj = y[0];
    for (i = 2; i < 3; i++) {
      wj += V[1] * B_idx_1;
    }

    wj *= tau[0];
    if (wj != 0.0) {
      tol = y[0] - wj;
      B = y[1];
      for (i = 2; i < 3; i++) {
        B -= V[1] * wj;
        B_idx_1 = B;
      }
    }
  }

  if (tau[1] != 0.0) {
    wj = tau[1] * B_idx_1;
    if (wj != 0.0) {
      B_idx_1 -= wj;
    }
  }

  c_st.site = &wb_emlrtRSI;
  p[jpvt[0] - 1] = tol;
  p[jpvt[1] - 1] = B_idx_1;
  c_st.site = &xb_emlrtRSI;
  p[jpvt[1] - 1] /= V[3];
  c_st.site = &yb_emlrtRSI;
  for (i = 0; i < 1; i++) {
    p[jpvt[0] - 1] -= p[jpvt[1] - 1] * V[2];
  }

  p[jpvt[0] - 1] /= V[0];
  c_st.site = &yb_emlrtRSI;
  if (rr <= 1) {
    st.site = &e_emlrtRSI;
    b_warning(&st);
  }
}

/* End of code generation (polyfit.cpp) */

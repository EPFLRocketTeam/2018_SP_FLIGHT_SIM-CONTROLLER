/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xnrm2.cpp
 *
 * Code generation for function 'xnrm2'
 *
 */

/* Include files */
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "find_rocket_c.h"
#include "xnrm2.h"
#include "eml_int_forloop_overflow_check.h"
#include "find_rocket_c_data.h"

/* Variable Definitions */
static emlrtRSInfo s_emlrtRSI = { 23,  /* lineNo */
  "xnrm2",                             /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+blas/xnrm2.m"/* pathName */
};

static emlrtRSInfo t_emlrtRSI = { 38,  /* lineNo */
  "xnrm2",                             /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+refblas/xnrm2.m"/* pathName */
};

/* Function Definitions */

/*
 *
 */
real_T b_xnrm2(const emlrtStack *sp, int32_T n, const real_T x[4], int32_T ix0)
{
  real_T y;
  real_T scale;
  int32_T kend;
  int32_T k;
  real_T absxk;
  real_T t;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &s_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  y = 0.0;
  if (n >= 1) {
    if (n == 1) {
      y = muDoubleScalarAbs(x[ix0 - 1]);
    } else {
      scale = 3.3121686421112381E-170;
      kend = (ix0 + n) - 1;
      b_st.site = &t_emlrtRSI;
      if ((ix0 <= kend) && (kend > 2147483646)) {
        c_st.site = &u_emlrtRSI;
        check_forloop_overflow_error(&c_st, true);
      }

      for (k = ix0; k <= kend; k++) {
        absxk = muDoubleScalarAbs(x[k - 1]);
        if (absxk > scale) {
          t = scale / absxk;
          y = 1.0 + y * t * t;
          scale = absxk;
        } else {
          t = absxk / scale;
          y += t * t;
        }
      }

      y = scale * muDoubleScalarSqrt(y);
    }
  }

  return y;
}

/*
 *
 */
real_T xnrm2(const emlrtStack *sp, const real_T x[4], int32_T ix0)
{
  real_T y;
  real_T scale;
  int32_T kend;
  int32_T k;
  real_T absxk;
  real_T t;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &s_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  y = 0.0;
  scale = 3.3121686421112381E-170;
  kend = ix0 + 1;
  b_st.site = &t_emlrtRSI;
  if ((ix0 <= ix0 + 1) && (ix0 + 1 > 2147483646)) {
    c_st.site = &u_emlrtRSI;
    check_forloop_overflow_error(&c_st, true);
  }

  for (k = ix0; k <= kend; k++) {
    absxk = muDoubleScalarAbs(x[k - 1]);
    if (absxk > scale) {
      t = scale / absxk;
      y = 1.0 + y * t * t;
      scale = absxk;
    } else {
      t = absxk / scale;
      y += t * t;
    }
  }

  return scale * muDoubleScalarSqrt(y);
}

/* End of code generation (xnrm2.cpp) */

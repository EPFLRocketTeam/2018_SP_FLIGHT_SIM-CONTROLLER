/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xzlarfg.cpp
 *
 * Code generation for function 'xzlarfg'
 *
 */

/* Include files */
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "find_rocket_c.h"
#include "xzlarfg.h"
#include "eml_int_forloop_overflow_check.h"
#include "xnrm2.h"
#include "find_rocket_c_data.h"

/* Variable Definitions */
static emlrtRSInfo x_emlrtRSI = { 20,  /* lineNo */
  "xzlarfg",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+reflapack/xzlarfg.m"/* pathName */
};

static emlrtRSInfo y_emlrtRSI = { 41,  /* lineNo */
  "xzlarfg",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+reflapack/xzlarfg.m"/* pathName */
};

static emlrtRSInfo ab_emlrtRSI = { 53, /* lineNo */
  "xzlarfg",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+reflapack/xzlarfg.m"/* pathName */
};

static emlrtRSInfo bb_emlrtRSI = { 68, /* lineNo */
  "xzlarfg",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+reflapack/xzlarfg.m"/* pathName */
};

static emlrtRSInfo cb_emlrtRSI = { 71, /* lineNo */
  "xzlarfg",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+reflapack/xzlarfg.m"/* pathName */
};

static emlrtRSInfo db_emlrtRSI = { 81, /* lineNo */
  "xzlarfg",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+reflapack/xzlarfg.m"/* pathName */
};

static emlrtRSInfo eb_emlrtRSI = { 31, /* lineNo */
  "xscal",                             /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+blas/xscal.m"/* pathName */
};

static emlrtRSInfo fb_emlrtRSI = { 18, /* lineNo */
  "xscal",                             /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+refblas/xscal.m"/* pathName */
};

/* Function Definitions */

/*
 *
 */
real_T xzlarfg(const emlrtStack *sp, int32_T n, real_T *alpha1, real_T x[4],
               int32_T ix0)
{
  real_T tau;
  real_T xnorm;
  real_T beta1;
  int32_T knt;
  int32_T b;
  boolean_T overflow;
  int32_T k;
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
  tau = 0.0;
  if (n > 0) {
    st.site = &x_emlrtRSI;
    xnorm = b_xnrm2(&st, n - 1, x, ix0);
    if (xnorm != 0.0) {
      beta1 = muDoubleScalarHypot(*alpha1, xnorm);
      if (*alpha1 >= 0.0) {
        beta1 = -beta1;
      }

      if (muDoubleScalarAbs(beta1) < 1.0020841800044864E-292) {
        knt = 0;
        b = (ix0 + n) - 2;
        overflow = ((ix0 <= b) && (b > 2147483646));
        do {
          knt++;
          st.site = &y_emlrtRSI;
          b_st.site = &eb_emlrtRSI;
          c_st.site = &fb_emlrtRSI;
          if (overflow) {
            d_st.site = &u_emlrtRSI;
            check_forloop_overflow_error(&d_st, true);
          }

          for (k = ix0; k <= b; k++) {
            x[k - 1] *= 9.9792015476736E+291;
          }

          beta1 *= 9.9792015476736E+291;
          *alpha1 *= 9.9792015476736E+291;
        } while (!(muDoubleScalarAbs(beta1) >= 1.0020841800044864E-292));

        st.site = &ab_emlrtRSI;
        xnorm = b_xnrm2(&st, n - 1, x, ix0);
        beta1 = muDoubleScalarHypot(*alpha1, xnorm);
        if (*alpha1 >= 0.0) {
          beta1 = -beta1;
        }

        tau = (beta1 - *alpha1) / beta1;
        xnorm = 1.0 / (*alpha1 - beta1);
        st.site = &bb_emlrtRSI;
        b_st.site = &eb_emlrtRSI;
        b = (ix0 + n) - 2;
        c_st.site = &fb_emlrtRSI;
        if ((ix0 <= b) && (b > 2147483646)) {
          d_st.site = &u_emlrtRSI;
          check_forloop_overflow_error(&d_st, true);
        }

        for (k = ix0; k <= b; k++) {
          x[k - 1] *= xnorm;
        }

        st.site = &cb_emlrtRSI;
        if ((1 <= knt) && (knt > 2147483646)) {
          b_st.site = &u_emlrtRSI;
          check_forloop_overflow_error(&b_st, true);
        }

        for (k = 0; k < knt; k++) {
          beta1 *= 1.0020841800044864E-292;
        }

        *alpha1 = beta1;
      } else {
        tau = (beta1 - *alpha1) / beta1;
        xnorm = 1.0 / (*alpha1 - beta1);
        st.site = &db_emlrtRSI;
        b_st.site = &eb_emlrtRSI;
        knt = (ix0 + n) - 2;
        c_st.site = &fb_emlrtRSI;
        if ((ix0 <= knt) && (knt > 2147483646)) {
          d_st.site = &u_emlrtRSI;
          check_forloop_overflow_error(&d_st, true);
        }

        for (k = ix0; k <= knt; k++) {
          x[k - 1] *= xnorm;
        }

        *alpha1 = beta1;
      }
    }
  }

  return tau;
}

/* End of code generation (xzlarfg.cpp) */

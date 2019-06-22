/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xgeqp3.cpp
 *
 * Code generation for function 'xgeqp3'
 *
 */

/* Include files */
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "find_rocket_c.h"
#include "xgeqp3.h"
#include "xnrm2.h"
#include "eml_int_forloop_overflow_check.h"
#include "xzlarfg.h"
#include "xswap.h"
#include "sqrt.h"
#include "find_rocket_c_data.h"

/* Variable Definitions */
static emlrtRSInfo i_emlrtRSI = { 17,  /* lineNo */
  "xgeqp3",                            /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+lapack/xgeqp3.m"/* pathName */
};

static emlrtRSInfo j_emlrtRSI = { 25,  /* lineNo */
  "xzgeqp3",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+reflapack/xzgeqp3.m"/* pathName */
};

static emlrtRSInfo k_emlrtRSI = { 32,  /* lineNo */
  "xzgeqp3",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+reflapack/xzgeqp3.m"/* pathName */
};

static emlrtRSInfo l_emlrtRSI = { 47,  /* lineNo */
  "xzgeqp3",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+reflapack/xzgeqp3.m"/* pathName */
};

static emlrtRSInfo m_emlrtRSI = { 64,  /* lineNo */
  "xzgeqp3",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+reflapack/xzgeqp3.m"/* pathName */
};

static emlrtRSInfo n_emlrtRSI = { 78,  /* lineNo */
  "xzgeqp3",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+reflapack/xzgeqp3.m"/* pathName */
};

static emlrtRSInfo o_emlrtRSI = { 83,  /* lineNo */
  "xzgeqp3",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+reflapack/xzgeqp3.m"/* pathName */
};

static emlrtRSInfo p_emlrtRSI = { 97,  /* lineNo */
  "xzgeqp3",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+reflapack/xzgeqp3.m"/* pathName */
};

static emlrtRSInfo q_emlrtRSI = { 104, /* lineNo */
  "xzgeqp3",                           /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+reflapack/xzgeqp3.m"/* pathName */
};

static emlrtRSInfo v_emlrtRSI = { 23,  /* lineNo */
  "ixamax",                            /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+blas/ixamax.m"/* pathName */
};

static emlrtRSInfo w_emlrtRSI = { 24,  /* lineNo */
  "ixamax",                            /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+refblas/ixamax.m"/* pathName */
};

static emlrtRSInfo gb_emlrtRSI = { 50, /* lineNo */
  "xzlarf",                            /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+reflapack/xzlarf.m"/* pathName */
};

static emlrtRSInfo hb_emlrtRSI = { 68, /* lineNo */
  "xzlarf",                            /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+reflapack/xzlarf.m"/* pathName */
};

static emlrtRSInfo ib_emlrtRSI = { 75, /* lineNo */
  "xzlarf",                            /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+reflapack/xzlarf.m"/* pathName */
};

static emlrtRSInfo jb_emlrtRSI = { 103,/* lineNo */
  "xzlarf",                            /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+reflapack/xzlarf.m"/* pathName */
};

static emlrtRSInfo kb_emlrtRSI = { 57, /* lineNo */
  "xgemv",                             /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+blas/xgemv.m"/* pathName */
};

static emlrtRSInfo lb_emlrtRSI = { 37, /* lineNo */
  "xgemv",                             /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+refblas/xgemv.m"/* pathName */
};

static emlrtRSInfo mb_emlrtRSI = { 71, /* lineNo */
  "xgemv",                             /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+refblas/xgemv.m"/* pathName */
};

static emlrtRSInfo nb_emlrtRSI = { 74, /* lineNo */
  "xgemv",                             /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+refblas/xgemv.m"/* pathName */
};

static emlrtRSInfo ob_emlrtRSI = { 45, /* lineNo */
  "xgerc",                             /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+blas/xgerc.m"/* pathName */
};

static emlrtRSInfo pb_emlrtRSI = { 45, /* lineNo */
  "xger",                              /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+blas/xger.m"/* pathName */
};

static emlrtRSInfo qb_emlrtRSI = { 15, /* lineNo */
  "xger",                              /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+refblas/xger.m"/* pathName */
};

static emlrtRSInfo rb_emlrtRSI = { 41, /* lineNo */
  "xgerx",                             /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+refblas/xgerx.m"/* pathName */
};

static emlrtRSInfo sb_emlrtRSI = { 54, /* lineNo */
  "xgerx",                             /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/+refblas/xgerx.m"/* pathName */
};

/* Function Definitions */

/*
 *
 */
void xgeqp3(const emlrtStack *sp, real_T A[4], real_T tau[2], int32_T jpvt[2])
{
  real_T work[2];
  real_T TOL3Z;
  real_T smax;
  real_T vn1[2];
  real_T vn2[2];
  int32_T b;
  int32_T ix;
  int32_T itemp;
  real_T s;
  int32_T lastv;
  int32_T lastc;
  int32_T jy;
  int32_T exitg1;
  int32_T iac;
  real_T temp1;
  real_T temp2;
  int32_T ijA;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  emlrtStack f_st;
  emlrtStack g_st;
  emlrtStack h_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &i_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  e_st.prev = &d_st;
  e_st.tls = d_st.tls;
  f_st.prev = &e_st;
  f_st.tls = e_st.tls;
  g_st.prev = &f_st;
  g_st.tls = f_st.tls;
  h_st.prev = &g_st;
  h_st.tls = g_st.tls;
  jpvt[0] = 1;
  work[0] = 0.0;
  jpvt[1] = 2;
  work[1] = 0.0;
  TOL3Z = 2.2204460492503131E-16;
  b_st.site = &j_emlrtRSI;
  b_sqrt(&b_st, &TOL3Z);
  b_st.site = &k_emlrtRSI;
  smax = xnrm2(&b_st, A, 1);
  vn1[0] = smax;
  vn2[0] = smax;
  b_st.site = &k_emlrtRSI;
  smax = xnrm2(&b_st, A, 3);
  vn1[1] = smax;
  vn2[1] = smax;
  b_st.site = &l_emlrtRSI;
  c_st.site = &v_emlrtRSI;
  b = 0;
  ix = 0;
  smax = muDoubleScalarAbs(vn1[0]);
  d_st.site = &w_emlrtRSI;
  for (itemp = 2; itemp < 3; itemp++) {
    ix++;
    s = muDoubleScalarAbs(vn1[ix]);
    if (s > smax) {
      b = 1;
      smax = s;
    }
  }

  if (b != 0) {
    xswap(A, 1 + (b << 1), 1);
    itemp = jpvt[b];
    jpvt[b] = 1;
    jpvt[0] = itemp;
    vn1[b] = vn1[0];
    vn2[b] = vn2[0];
  }

  s = A[0];
  b_st.site = &m_emlrtRSI;
  tau[0] = xzlarfg(&b_st, 2, &s, A, 2);
  A[0] = s;
  s = A[0];
  A[0] = 1.0;
  b_st.site = &n_emlrtRSI;
  if (tau[0] != 0.0) {
    lastv = 2;
    itemp = 0;
    while ((lastv > 0) && (A[itemp + 1] == 0.0)) {
      lastv--;
      itemp--;
    }

    c_st.site = &gb_emlrtRSI;
    lastc = 1;
    d_st.site = &jb_emlrtRSI;
    itemp = 3;
    do {
      exitg1 = 0;
      if (itemp <= lastv + 2) {
        if (A[itemp - 1] != 0.0) {
          exitg1 = 1;
        } else {
          itemp++;
        }
      } else {
        lastc = 0;
        exitg1 = 1;
      }
    } while (exitg1 == 0);
  } else {
    lastv = 0;
    lastc = 0;
  }

  if (lastv > 0) {
    c_st.site = &hb_emlrtRSI;
    d_st.site = &kb_emlrtRSI;
    if (lastc != 0) {
      e_st.site = &lb_emlrtRSI;
      work[0] = 0.0;
      jy = 0;
      e_st.site = &mb_emlrtRSI;
      b = lastv + 2;
      for (iac = 0; iac <= 0; iac += 2) {
        ix = 0;
        smax = 0.0;
        e_st.site = &nb_emlrtRSI;
        for (itemp = 3; itemp <= b; itemp++) {
          smax += A[itemp - 1] * A[ix];
          ix++;
        }

        work[jy] += smax;
        jy++;
      }
    }

    c_st.site = &ib_emlrtRSI;
    d_st.site = &ob_emlrtRSI;
    e_st.site = &pb_emlrtRSI;
    f_st.site = &qb_emlrtRSI;
    if (!(-tau[0] == 0.0)) {
      itemp = 3;
      jy = 0;
      g_st.site = &rb_emlrtRSI;
      for (iac = 0; iac < lastc; iac++) {
        if (work[jy] != 0.0) {
          smax = work[jy] * -tau[0];
          ix = 0;
          b = (lastv + itemp) - 1;
          g_st.site = &sb_emlrtRSI;
          if ((itemp <= b) && (b > 2147483646)) {
            h_st.site = &u_emlrtRSI;
            check_forloop_overflow_error(&h_st, true);
          }

          for (ijA = itemp; ijA <= b; ijA++) {
            A[ijA - 1] += A[ix] * smax;
            ix++;
          }
        }

        jy++;
        itemp += 2;
      }
    }
  }

  A[0] = s;
  b_st.site = &o_emlrtRSI;
  smax = vn1[1];
  s = vn2[1];
  for (iac = 2; iac < 3; iac++) {
    if (smax != 0.0) {
      temp1 = muDoubleScalarAbs(A[2]) / smax;
      temp1 = 1.0 - temp1 * temp1;
      if (temp1 < 0.0) {
        temp1 = 0.0;
      }

      temp2 = smax / s;
      temp2 = temp1 * (temp2 * temp2);
      if (temp2 <= TOL3Z) {
        b_st.site = &p_emlrtRSI;
        smax = b_xnrm2(&b_st, 1, A, 4);
        s = smax;
      } else {
        b_st.site = &q_emlrtRSI;
        smax *= muDoubleScalarSqrt(temp1);
      }
    }
  }

  b_st.site = &l_emlrtRSI;
  c_st.site = &v_emlrtRSI;
  tau[1] = 0.0;
  b_st.site = &o_emlrtRSI;
}

/* End of code generation (xgeqp3.cpp) */

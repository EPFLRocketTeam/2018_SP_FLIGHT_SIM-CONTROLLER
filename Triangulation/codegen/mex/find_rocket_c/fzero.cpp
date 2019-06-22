/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * fzero.cpp
 *
 * Code generation for function 'fzero'
 *
 */

/* Include files */
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "find_rocket_c.h"
#include "fzero.h"
#include "error.h"

/* Variable Definitions */
static emlrtRSInfo dc_emlrtRSI = { 74, /* lineNo */
  "fzero",                             /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/lib/matlab/optimfun/fzero.m"/* pathName */
};

static emlrtRSInfo ec_emlrtRSI = { 83, /* lineNo */
  "fzero",                             /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/lib/matlab/optimfun/fzero.m"/* pathName */
};

static emlrtRSInfo fc_emlrtRSI = { 91, /* lineNo */
  "fzero",                             /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/lib/matlab/optimfun/fzero.m"/* pathName */
};

static emlrtRSInfo gc_emlrtRSI = { 95, /* lineNo */
  "fzero",                             /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/lib/matlab/optimfun/fzero.m"/* pathName */
};

static emlrtRSInfo hc_emlrtRSI = { 111,/* lineNo */
  "fzero",                             /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/lib/matlab/optimfun/fzero.m"/* pathName */
};

static emlrtRSInfo ic_emlrtRSI = { 217,/* lineNo */
  "fzero",                             /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/lib/matlab/optimfun/fzero.m"/* pathName */
};

static emlrtRSInfo jc_emlrtRSI = { 37, /* lineNo */
  "function_handle",                   /* fcnName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/eml/+coder/+internal/function_handle.m"/* pathName */
};

static emlrtRTEInfo c_emlrtRTEI = { 72,/* lineNo */
  19,                                  /* colNo */
  "fzero",                             /* fName */
  "/Applications/MATLAB_R2018b.app/toolbox/eml/lib/matlab/optimfun/fzero.m"/* pName */
};

static emlrtDCInfo emlrtDCI = { 28,    /* lineNo */
  55,                                  /* colNo */
  "find_rocket_c",                     /* fName */
  "/Users/nikovertovec/Documents/MATLAB/ARIS-General/Triangulation/find_rocket_c.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo b_emlrtBCI = { 1,   /* iFirst */
  3,                                   /* iLast */
  28,                                  /* lineNo */
  55,                                  /* colNo */
  "diff_polynom",                      /* aName */
  "find_rocket_c",                     /* fName */
  "/Users/nikovertovec/Documents/MATLAB/ARIS-General/Triangulation/find_rocket_c.m",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */

/*
 *
 */
real_T fzero(const emlrtStack *sp, const real_T FunFcn_tunableEnvironment_f1[6],
             real_T FunFcn_tunableEnvironment_f2, real_T x)
{
  real_T b;
  int32_T fx_tmp;
  real_T b_fx_tmp;
  real_T fx;
  real_T dx;
  real_T a;
  real_T fb;
  int32_T exitg2;
  real_T fc;
  real_T c;
  real_T e;
  real_T d;
  boolean_T exitg1;
  real_T m;
  real_T toler;
  real_T s;
  real_T r;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  if (muDoubleScalarIsInf(x) || muDoubleScalarIsNaN(x)) {
    emlrtErrorWithMessageIdR2018a(sp, &c_emlrtRTEI,
      "MATLAB:optimfun:fzero:Arg2NotFinite",
      "MATLAB:optimfun:fzero:Arg2NotFinite", 0);
  }

  st.site = &dc_emlrtRSI;
  b_st.site = &jc_emlrtRSI;
  if (FunFcn_tunableEnvironment_f2 != (int32_T)muDoubleScalarFloor
      (FunFcn_tunableEnvironment_f2)) {
    emlrtIntegerCheckR2012b(FunFcn_tunableEnvironment_f2, &emlrtDCI, &b_st);
  }

  fx_tmp = (int32_T)FunFcn_tunableEnvironment_f2;
  if ((fx_tmp < 1) || (fx_tmp > 3)) {
    emlrtDynamicBoundsCheckR2012b(fx_tmp, 1, 3, &b_emlrtBCI, &b_st);
  }

  fx_tmp = (fx_tmp - 1) << 1;
  b_fx_tmp = FunFcn_tunableEnvironment_f1[1 + fx_tmp];
  fx = x * FunFcn_tunableEnvironment_f1[fx_tmp] + b_fx_tmp;
  if (fx == 0.0) {
    b = x;
  } else {
    if (muDoubleScalarIsInf(fx) || muDoubleScalarIsNaN(fx)) {
      st.site = &ec_emlrtRSI;
      b_error(&st);
    }

    if (x != 0.0) {
      dx = x / 50.0;
    } else {
      dx = 0.02;
    }

    st.site = &fc_emlrtRSI;
    a = x;
    b = x;
    fb = fx;
    do {
      exitg2 = 0;
      if ((fx > 0.0) == (fb > 0.0)) {
        dx *= 1.4142135623730951;
        a = x - dx;
        st.site = &gc_emlrtRSI;
        fx = a * FunFcn_tunableEnvironment_f1[((int32_T)
          FunFcn_tunableEnvironment_f2 - 1) << 1] + b_fx_tmp;
        if (muDoubleScalarIsInf(fx) || muDoubleScalarIsNaN(fx)) {
          b = rtNaN;
          exitg2 = 1;
        } else if (muDoubleScalarIsInf(a) || muDoubleScalarIsNaN(a)) {
          b = rtNaN;
          exitg2 = 1;
        } else if ((fx > 0.0) != (fb > 0.0)) {
          exitg2 = 2;
        } else {
          b = x + dx;
          st.site = &hc_emlrtRSI;
          fb = b * FunFcn_tunableEnvironment_f1[((int32_T)
            FunFcn_tunableEnvironment_f2 - 1) << 1] + b_fx_tmp;
          if (muDoubleScalarIsInf(fb) || muDoubleScalarIsNaN(fb)) {
            b = rtNaN;
            exitg2 = 1;
          } else {
            if (muDoubleScalarIsInf(b) || muDoubleScalarIsNaN(b)) {
              b = rtNaN;
              exitg2 = 1;
            }
          }
        }
      } else {
        exitg2 = 2;
      }
    } while (exitg2 == 0);

    if (exitg2 == 1) {
    } else {
      fc = fb;
      c = b;
      e = 0.0;
      d = 0.0;
      exitg1 = false;
      while ((!exitg1) && ((fb != 0.0) && (a != b))) {
        if ((fb > 0.0) == (fc > 0.0)) {
          c = a;
          fc = fx;
          d = b - a;
          e = d;
        }

        if (muDoubleScalarAbs(fc) < muDoubleScalarAbs(fb)) {
          a = b;
          b = c;
          c = a;
          fx = fb;
          fb = fc;
          fc = fx;
        }

        m = 0.5 * (c - b);
        toler = 4.4408920985006262E-16 * muDoubleScalarMax(muDoubleScalarAbs(b),
          1.0);
        if ((muDoubleScalarAbs(m) <= toler) || (fb == 0.0)) {
          exitg1 = true;
        } else {
          if ((muDoubleScalarAbs(e) < toler) || (muDoubleScalarAbs(fx) <=
               muDoubleScalarAbs(fb))) {
            d = m;
            e = m;
          } else {
            s = fb / fx;
            if (a == c) {
              dx = 2.0 * m * s;
              fx = 1.0 - s;
            } else {
              fx /= fc;
              r = fb / fc;
              dx = s * (2.0 * m * fx * (fx - r) - (b - a) * (r - 1.0));
              fx = (fx - 1.0) * (r - 1.0) * (s - 1.0);
            }

            if (dx > 0.0) {
              fx = -fx;
            } else {
              dx = -dx;
            }

            if ((2.0 * dx < 3.0 * m * fx - muDoubleScalarAbs(toler * fx)) && (dx
                 < muDoubleScalarAbs(0.5 * e * fx))) {
              e = d;
              d = dx / fx;
            } else {
              d = m;
              e = m;
            }
          }

          a = b;
          fx = fb;
          if (muDoubleScalarAbs(d) > toler) {
            b += d;
          } else if (b > c) {
            b -= toler;
          } else {
            b += toler;
          }

          st.site = &ic_emlrtRSI;
          fb = b * FunFcn_tunableEnvironment_f1[((int32_T)
            FunFcn_tunableEnvironment_f2 - 1) << 1] + b_fx_tmp;
        }
      }
    }
  }

  return b;
}

/* End of code generation (fzero.cpp) */

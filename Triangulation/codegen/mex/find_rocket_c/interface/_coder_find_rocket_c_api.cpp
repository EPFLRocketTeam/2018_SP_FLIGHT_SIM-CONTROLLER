/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_find_rocket_c_api.cpp
 *
 * Code generation for function '_coder_find_rocket_c_api'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "find_rocket_c.h"
#include "_coder_find_rocket_c_api.h"
#include "find_rocket_c_data.h"

/* Function Declarations */
static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *people,
  const char_T *identifier, struct0_T *y);
static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, struct0_T *y);
static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y[3]);
static const mxArray *emlrt_marshallOut(const real_T u[2]);
static void f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y[6]);
static void h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret[3]);
static void i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret[6]);

/* Function Definitions */
static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *people,
  const char_T *identifier, struct0_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = const_cast<const char *>(identifier);
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  d_emlrt_marshallIn(sp, emlrtAlias(people), &thisId, y);
  emlrtDestroyArray(&people);
}

static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, struct0_T *y)
{
  emlrtMsgIdentifier thisId;
  static const char * fieldNames[5] = { "degrees", "Latitude", "Longitude", "p",
    "intersection" };

  static const int32_T dims = 0;
  thisId.fParent = parentId;
  thisId.bParentIsCell = false;
  emlrtCheckStructR2012b(sp, parentId, u, 5, fieldNames, 0U, (int32_T *)&dims);
  thisId.fIdentifier = "degrees";
  e_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0, 0, "degrees")),
                     &thisId, y->degrees);
  thisId.fIdentifier = "Latitude";
  e_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0, 1, "Latitude")),
                     &thisId, y->Latitude);
  thisId.fIdentifier = "Longitude";
  e_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0, 2, "Longitude")),
                     &thisId, y->Longitude);
  thisId.fIdentifier = "p";
  f_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0, 3, "p")),
                     &thisId, y->p);
  thisId.fIdentifier = "intersection";
  e_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0, 4,
    "intersection")), &thisId, y->intersection);
  emlrtDestroyArray(&u);
}

static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y[3])
{
  h_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static const mxArray *emlrt_marshallOut(const real_T u[2])
{
  const mxArray *y;
  const mxArray *m4;
  static const int32_T iv15[2] = { 0, 0 };

  static const int32_T iv16[2] = { 1, 2 };

  y = NULL;
  m4 = emlrtCreateNumericArray(2, iv15, mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m4, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m4, *(int32_T (*)[2])&iv16[0], 2);
  emlrtAssign(&y, m4);
  return y;
}

static void f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y[6])
{
  i_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret[3])
{
  static const int32_T dims[2] = { 1, 3 };

  real_T (*r0)[3];
  emlrtCheckBuiltInR2012b(sp, (const emlrtMsgIdentifier *)msgId, src, "double",
    false, 2U, *(int32_T (*)[2])&dims[0]);
  r0 = (real_T (*)[3])emlrtMxGetData(src);
  ret[0] = (*r0)[0];
  ret[1] = (*r0)[1];
  ret[2] = (*r0)[2];
  emlrtDestroyArray(&src);
}

static void i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret[6])
{
  static const int32_T dims[2] = { 2, 3 };

  real_T (*r1)[6];
  int32_T i0;
  emlrtCheckBuiltInR2012b(sp, (const emlrtMsgIdentifier *)msgId, src, "double",
    false, 2U, *(int32_T (*)[2])&dims[0]);
  r1 = (real_T (*)[6])emlrtMxGetData(src);
  for (i0 = 0; i0 < 6; i0++) {
    ret[i0] = (*r1)[i0];
  }

  emlrtDestroyArray(&src);
}

void find_rocket_c_api(const mxArray * const prhs[1], int32_T, const mxArray
  *plhs[1])
{
  real_T (*rocket_location)[2];
  struct0_T people;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  rocket_location = (real_T (*)[2])mxMalloc(sizeof(real_T [2]));

  /* Marshall function inputs */
  c_emlrt_marshallIn(&st, emlrtAliasP(prhs[0]), "people", &people);

  /* Invoke the target function */
  find_rocket_c(&st, &people, *rocket_location);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(*rocket_location);
}

/* End of code generation (_coder_find_rocket_c_api.cpp) */

/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: _coder_find_rocket_c_api.h
 *
 * MATLAB Coder version            : 4.1
 * C/C++ source code generated on  : 18-Jun-2019 08:46:07
 */

#ifndef _CODER_FIND_ROCKET_C_API_H
#define _CODER_FIND_ROCKET_C_API_H

/* Include Files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_find_rocket_c_api.h"

/* Type Definitions */
#ifndef typedef_struct0_T
#define typedef_struct0_T

typedef struct {
  real_T length;
  real_T degrees[4];
  real_T Latitude[4];
  real_T Longitude[4];
  real_T p[8];
  real_T intersection[4];
} struct0_T;

#endif                                 /*typedef_struct0_T*/

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void find_rocket_c(struct0_T *people, real_T rocket_location[2]);
extern void find_rocket_c_api(const mxArray * const prhs[1], int32_T nlhs, const
  mxArray *plhs[1]);
extern void find_rocket_c_atexit(void);
extern void find_rocket_c_initialize(void);
extern void find_rocket_c_terminate(void);
extern void find_rocket_c_xil_terminate(void);

#endif

/*
 * File trailer for _coder_find_rocket_c_api.h
 *
 * [EOF]
 */

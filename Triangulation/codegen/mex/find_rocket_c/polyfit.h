/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * polyfit.h
 *
 * Code generation for function 'polyfit'
 *
 */

#ifndef POLYFIT_H
#define POLYFIT_H

/* Include files */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include "rtwtypes.h"
#include "find_rocket_c_types.h"

/* Function Declarations */
extern void polyfit(const emlrtStack *sp, const real_T x[2], const real_T y[2],
                    real_T p[2]);

#endif

/* End of code generation (polyfit.h) */

//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
// File: main.cpp
//
// MATLAB Coder version            : 4.1
// C/C++ source code generated on  : 18-Jun-2019 08:48:19
//

//***********************************************************************
// This automatically generated example C main file shows how to call
// entry-point functions that MATLAB Coder generated. You must customize
// this file for your application. Do not modify this file directly.
// Instead, make a copy of this file, modify it, and integrate it into
// your development environment.
//
// This file initializes entry-point function arguments to a default
// size and value before calling the entry-point functions. It does
// not store or use any values returned from the entry-point functions.
// If necessary, it does pre-allocate memory for returned values.
// You can use this file as a starting point for a main function that
// you can deploy in your application.
//
// After you copy the file, and before you deploy it, you must make the
// following changes:
// * For variable-size function arguments, change the example sizes to
// the sizes that your application requires.
// * Change the example values of function arguments to the values that
// your application requires.
// * If the entry-point functions return values, store these values or
// otherwise use them as required by your application.
//
//***********************************************************************
// Include Files
#include "rt_nonfinite.h"
#include "find_rocket_c.h"
#include "main.h"

// Function Declarations
static void argInit_1x4_real_T(double result[4]);
static void argInit_2x4_real_T(double result[8]);
static double argInit_real_T();
static void argInit_struct0_T(struct0_T *result);
static void main_find_rocket_c();

// Function Definitions

//
// Arguments    : double result[4]
// Return Type  : void
//
static void argInit_1x4_real_T(double result[4])
{
  double result_tmp;

  // Loop over the array to initialize each element.
  // Set the value of the array element.
  // Change this value to the value that the application requires.
  result_tmp = argInit_real_T();
  result[0] = result_tmp;

  // Set the value of the array element.
  // Change this value to the value that the application requires.
  result[1] = result_tmp;

  // Set the value of the array element.
  // Change this value to the value that the application requires.
  result[2] = argInit_real_T();

  // Set the value of the array element.
  // Change this value to the value that the application requires.
  result[3] = argInit_real_T();
}

//
// Arguments    : double result[8]
// Return Type  : void
//
static void argInit_2x4_real_T(double result[8])
{
  int idx0;
  double result_tmp;

  // Loop over the array to initialize each element.
  for (idx0 = 0; idx0 < 2; idx0++) {
    // Set the value of the array element.
    // Change this value to the value that the application requires.
    result_tmp = argInit_real_T();
    result[idx0] = result_tmp;

    // Set the value of the array element.
    // Change this value to the value that the application requires.
    result[idx0 + 2] = result_tmp;

    // Set the value of the array element.
    // Change this value to the value that the application requires.
    result[idx0 + 4] = argInit_real_T();

    // Set the value of the array element.
    // Change this value to the value that the application requires.
    result[idx0 + 6] = argInit_real_T();
  }
}

//
// Arguments    : void
// Return Type  : double
//
static double argInit_real_T()
{
  return 0.0;
}

//
// Arguments    : struct0_T *result
// Return Type  : void
//
static void argInit_struct0_T(struct0_T *result)
{
  double result_tmp_tmp[4];

  // Set the value of each structure field.
  // Change this value to the value that the application requires.
  result->length = argInit_real_T();
  argInit_1x4_real_T(result_tmp_tmp);
  result->degrees[0] = result_tmp_tmp[0];
  result->Latitude[0] = result_tmp_tmp[0];
  result->Longitude[0] = result_tmp_tmp[0];
  result->degrees[1] = result_tmp_tmp[1];
  result->Latitude[1] = result_tmp_tmp[1];
  result->Longitude[1] = result_tmp_tmp[1];
  result->degrees[2] = result_tmp_tmp[2];
  result->Latitude[2] = result_tmp_tmp[2];
  result->Longitude[2] = result_tmp_tmp[2];
  result->degrees[3] = result_tmp_tmp[3];
  result->Latitude[3] = result_tmp_tmp[3];
  result->Longitude[3] = result_tmp_tmp[3];
  argInit_2x4_real_T(result->p);
  argInit_1x4_real_T(result->intersection);
}

//
// Arguments    : void
// Return Type  : void
//
static void main_find_rocket_c()
{
  struct0_T r0;
  double rocket_location[2];

  // Initialize function 'find_rocket_c' input arguments.
  // Initialize function input argument 'people'.
  // Call the entry-point 'find_rocket_c'.
  argInit_struct0_T(&r0);
  find_rocket_c(&r0, rocket_location);
}

//
// Arguments    : int argc
//                const char * const argv[]
// Return Type  : int
//
int main(int, const char * const [])
{
  // Initialize the application.
  // You do not need to do this more than one time.
  find_rocket_c_initialize();

  // Invoke the entry-point functions.
  // You can call entry-point functions multiple times.
  main_find_rocket_c();

  // Terminate the application.
  // You do not need to do this more than one time.
  find_rocket_c_terminate();
  return 0;
}

//
// File trailer for main.cpp
//
// [EOF]
//

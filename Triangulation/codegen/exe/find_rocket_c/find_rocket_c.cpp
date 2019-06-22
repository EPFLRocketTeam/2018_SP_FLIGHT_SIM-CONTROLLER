//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
// File: find_rocket_c.cpp
//
// MATLAB Coder version            : 4.1
// C/C++ source code generated on  : 18-Jun-2019 08:46:07
//

// Include Files
#include <cmath>
#include <float.h>
#include "rt_nonfinite.h"
#include <string.h>
#include "find_rocket_c.h"
#include "fminsearch.h"
#include "fzero.h"
#include "polyfit.h"

// Function Declarations
static double rt_remd_snf(double u0, double u1);

// Function Definitions

//
// Arguments    : double u0
//                double u1
// Return Type  : double
//
static double rt_remd_snf(double u0, double u1)
{
  double y;
  double b_u1;
  double q;
  if (rtIsNaN(u0) || rtIsInf(u0) || (rtIsNaN(u1) || rtIsInf(u1))) {
    y = rtNaN;
  } else {
    if (u1 < 0.0) {
      b_u1 = std::ceil(u1);
    } else {
      b_u1 = std::floor(u1);
    }

    if ((u1 != 0.0) && (u1 != b_u1)) {
      q = std::abs(u0 / u1);
      if (std::abs(q - std::floor(q + 0.5)) <= DBL_EPSILON * q) {
        y = 0.0 * u0;
      } else {
        y = std::fmod(u0, u1);
      }
    } else {
      y = std::fmod(u0, u1);
    }
  }

  return y;
}

//
// Latitude (North south)
// Longitude (East West)
// Up to 4 positionings
// Arguments    : struct0_T *people
//                double rocket_location[2]
// Return Type  : void
//
void find_rocket_c(struct0_T *people, double rocket_location[2])
{
  int i0;
  int i;
  bool rEQ0;
  double P[8];
  bool b0;
  double lon_intersect;
  double absx;
  double q;
  int P_tmp;
  double b_people[2];
  struct_T tunableEnvironment[1];
  double diff_polynom[8];
  double c_people[2];
  signed char n;
  double p[2];
  int b_P_tmp;
  i0 = (int)people->length;
  for (i = 0; i < i0; i++) {
    rEQ0 = rtIsInf(90.0 + people->degrees[i]);
    b0 = rtIsNaN(90.0 + people->degrees[i]);
    if (rEQ0 || b0) {
      lon_intersect = rtNaN;
      q = rtNaN;
    } else {
      lon_intersect = rt_remd_snf(90.0 + people->degrees[i], 360.0);
      absx = std::abs(lon_intersect);
      if (absx > 180.0) {
        if (lon_intersect > 0.0) {
          lon_intersect -= 360.0;
        } else {
          lon_intersect += 360.0;
        }

        absx = std::abs(lon_intersect);
      }

      if (absx <= 45.0) {
        lon_intersect *= 0.017453292519943295;
        n = 0;
      } else if (absx <= 135.0) {
        if (lon_intersect > 0.0) {
          lon_intersect = 0.017453292519943295 * (lon_intersect - 90.0);
          n = 1;
        } else {
          lon_intersect = 0.017453292519943295 * (lon_intersect + 90.0);
          n = -1;
        }
      } else if (lon_intersect > 0.0) {
        lon_intersect = 0.017453292519943295 * (lon_intersect - 180.0);
        n = 2;
      } else {
        lon_intersect = 0.017453292519943295 * (lon_intersect + 180.0);
        n = -2;
      }

      if (n == 0) {
        lon_intersect = std::sin(lon_intersect);
      } else if (n == 1) {
        lon_intersect = std::cos(lon_intersect);
      } else if (n == -1) {
        lon_intersect = -std::cos(lon_intersect);
      } else {
        lon_intersect = -std::sin(lon_intersect);
      }

      q = rt_remd_snf(90.0 + people->degrees[i], 360.0);
      absx = std::abs(q);
      if (absx > 180.0) {
        if (q > 0.0) {
          q -= 360.0;
        } else {
          q += 360.0;
        }

        absx = std::abs(q);
      }

      if (absx <= 45.0) {
        q *= 0.017453292519943295;
        n = 0;
      } else if (absx <= 135.0) {
        if (q > 0.0) {
          q = 0.017453292519943295 * (q - 90.0);
          n = 1;
        } else {
          q = 0.017453292519943295 * (q + 90.0);
          n = -1;
        }
      } else if (q > 0.0) {
        q = 0.017453292519943295 * (q - 180.0);
        n = 2;
      } else {
        q = 0.017453292519943295 * (q + 180.0);
        n = -2;
      }

      if (n == 0) {
        q = std::cos(q);
      } else if (n == 1) {
        q = -std::sin(q);
      } else if (n == -1) {
        q = std::sin(q);
      } else {
        q = -std::cos(q);
      }
    }

    b_people[0] = people->Longitude[i];
    b_people[1] = people->Longitude[i] + 0.02 * q;
    c_people[0] = people->Latitude[i];
    c_people[1] = people->Latitude[i] + 0.02 * lon_intersect;
    polyfit(b_people, c_people, p);
    P_tmp = i << 1;
    people->p[P_tmp] = p[0];
    people->p[1 + P_tmp] = p[1];
  }

  // alternative to circshift
  memset(&P[0], 0, sizeof(double) << 3);
  i0 = (int)people->length;
  for (i = 0; i < i0; i++) {
    lon_intersect = 1.0 + (double)i;
    if ((!rtIsInf(people->length)) && (!rtIsNaN(people->length))) {
      if (people->length != 0.0) {
        lon_intersect = std::fmod(1.0 + (double)i, people->length);
        rEQ0 = (lon_intersect == 0.0);
        if ((!rEQ0) && (people->length > std::floor(people->length))) {
          q = std::abs((1.0 + (double)i) / people->length);
          rEQ0 = (std::abs(q - std::floor(q + 0.5)) <= 2.2204460492503131E-16 *
                  q);
        }

        if (rEQ0) {
          lon_intersect = people->length * 0.0;
        } else {
          if (people->length < 0.0) {
            lon_intersect += people->length;
          }
        }
      }
    } else {
      if (people->length != 0.0) {
        lon_intersect = rtNaN;
      }
    }

    P_tmp = ((int)(lon_intersect + 1.0) - 1) << 1;
    b_P_tmp = i << 1;
    P[b_P_tmp] = people->p[P_tmp];
    P[1 + b_P_tmp] = people->p[1 + P_tmp];
  }

  for (P_tmp = 0; P_tmp < 8; P_tmp++) {
    lon_intersect = P[P_tmp] - people->p[P_tmp];
    diff_polynom[P_tmp] = std::abs(lon_intersect);
    P[P_tmp] = lon_intersect;
  }

  tunableEnvironment[0].Latitude[0] = 0.0;
  tunableEnvironment[0].Longitude[0] = 0.0;
  tunableEnvironment[0].Latitude[1] = 0.0;
  tunableEnvironment[0].Longitude[1] = 0.0;
  tunableEnvironment[0].Latitude[2] = 0.0;
  tunableEnvironment[0].Longitude[2] = 0.0;
  tunableEnvironment[0].Latitude[3] = 0.0;
  tunableEnvironment[0].Longitude[3] = 0.0;

  // calculate intersection
  for (i = 0; i < i0; i++) {
    lon_intersect = fzero(diff_polynom, (double)i + 1.0, people->Longitude[i]);
    P_tmp = i << 1;
    tunableEnvironment[0].Latitude[i] = lon_intersect * people->p[P_tmp] +
      people->p[1 + P_tmp];
    tunableEnvironment[0].Longitude[i] = lon_intersect;
  }

  rocket_location[0] = people->Latitude[0];
  rocket_location[1] = people->Longitude[0];
  fminsearch(tunableEnvironment, rocket_location);
}

//
// File trailer for find_rocket_c.cpp
//
// [EOF]
//

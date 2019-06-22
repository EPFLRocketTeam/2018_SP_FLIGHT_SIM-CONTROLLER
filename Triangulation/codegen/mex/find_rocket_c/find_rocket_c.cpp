/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * find_rocket_c.cpp
 *
 * Code generation for function 'find_rocket_c'
 *
 */

/* Include files */
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "find_rocket_c.h"
#include "fminsearch.h"
#include "fzero.h"
#include "polyfit.h"
#include "find_rocket_c_data.h"

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = { 10,    /* lineNo */
  "find_rocket_c",                     /* fcnName */
  "/Users/nikovertovec/Documents/MATLAB/ARIS-General/Triangulation/find_rocket_c.m"/* pathName */
};

static emlrtRSInfo b_emlrtRSI = { 28,  /* lineNo */
  "find_rocket_c",                     /* fcnName */
  "/Users/nikovertovec/Documents/MATLAB/ARIS-General/Triangulation/find_rocket_c.m"/* pathName */
};

static emlrtRSInfo c_emlrtRSI = { 36,  /* lineNo */
  "find_rocket_c",                     /* fcnName */
  "/Users/nikovertovec/Documents/MATLAB/ARIS-General/Triangulation/find_rocket_c.m"/* pathName */
};

static emlrtMCInfo emlrtMCI = { 6,     /* lineNo */
  1,                                   /* colNo */
  "find_rocket_c",                     /* fName */
  "/Users/nikovertovec/Documents/MATLAB/ARIS-General/Triangulation/find_rocket_c.m"/* pName */
};

static emlrtMCInfo b_emlrtMCI = { 6,   /* lineNo */
  9,                                   /* colNo */
  "find_rocket_c",                     /* fName */
  "/Users/nikovertovec/Documents/MATLAB/ARIS-General/Triangulation/find_rocket_c.m"/* pName */
};

static emlrtMCInfo c_emlrtMCI = { 6,   /* lineNo */
  18,                                  /* colNo */
  "find_rocket_c",                     /* fName */
  "/Users/nikovertovec/Documents/MATLAB/ARIS-General/Triangulation/find_rocket_c.m"/* pName */
};

static emlrtMCInfo d_emlrtMCI = { 12,  /* lineNo */
  5,                                   /* colNo */
  "find_rocket_c",                     /* fName */
  "/Users/nikovertovec/Documents/MATLAB/ARIS-General/Triangulation/find_rocket_c.m"/* pName */
};

static emlrtMCInfo e_emlrtMCI = { 13,  /* lineNo */
  5,                                   /* colNo */
  "find_rocket_c",                     /* fName */
  "/Users/nikovertovec/Documents/MATLAB/ARIS-General/Triangulation/find_rocket_c.m"/* pName */
};

static emlrtMCInfo f_emlrtMCI = { 37,  /* lineNo */
  1,                                   /* colNo */
  "find_rocket_c",                     /* fName */
  "/Users/nikovertovec/Documents/MATLAB/ARIS-General/Triangulation/find_rocket_c.m"/* pName */
};

static emlrtMCInfo g_emlrtMCI = { 30,  /* lineNo */
  5,                                   /* colNo */
  "find_rocket_c",                     /* fName */
  "/Users/nikovertovec/Documents/MATLAB/ARIS-General/Triangulation/find_rocket_c.m"/* pName */
};

static emlrtBCInfo emlrtBCI = { 1,     /* iFirst */
  3,                                   /* iLast */
  19,                                  /* lineNo */
  26,                                  /* colNo */
  "people.p",                          /* aName */
  "find_rocket_c",                     /* fName */
  "/Users/nikovertovec/Documents/MATLAB/ARIS-General/Triangulation/find_rocket_c.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRSInfo pc_emlrtRSI = { 6,  /* lineNo */
  "find_rocket_c",                     /* fcnName */
  "/Users/nikovertovec/Documents/MATLAB/ARIS-General/Triangulation/find_rocket_c.m"/* pathName */
};

static emlrtRSInfo qc_emlrtRSI = { 37, /* lineNo */
  "find_rocket_c",                     /* fcnName */
  "/Users/nikovertovec/Documents/MATLAB/ARIS-General/Triangulation/find_rocket_c.m"/* pathName */
};

static emlrtRSInfo rc_emlrtRSI = { 30, /* lineNo */
  "find_rocket_c",                     /* fcnName */
  "/Users/nikovertovec/Documents/MATLAB/ARIS-General/Triangulation/find_rocket_c.m"/* pathName */
};

static emlrtRSInfo sc_emlrtRSI = { 12, /* lineNo */
  "find_rocket_c",                     /* fcnName */
  "/Users/nikovertovec/Documents/MATLAB/ARIS-General/Triangulation/find_rocket_c.m"/* pathName */
};

static emlrtRSInfo tc_emlrtRSI = { 13, /* lineNo */
  "find_rocket_c",                     /* fcnName */
  "/Users/nikovertovec/Documents/MATLAB/ARIS-General/Triangulation/find_rocket_c.m"/* pathName */
};

/* Function Declarations */
static void figure(const emlrtStack *sp, emlrtMCInfo *location);
static void grid(const emlrtStack *sp, const mxArray *b, emlrtMCInfo *location);
static void hold(const emlrtStack *sp, const mxArray *b, emlrtMCInfo *location);
static void line(const emlrtStack *sp, const mxArray *b, const mxArray *c,
                 emlrtMCInfo *location);
static void plot(const emlrtStack *sp, const mxArray *b, const mxArray *c, const
                 mxArray *d, emlrtMCInfo *location);

/* Function Definitions */
static void figure(const emlrtStack *sp, emlrtMCInfo *location)
{
  emlrtCallMATLABR2012b(sp, 0, NULL, 0, NULL, "figure", true, location);
}

static void grid(const emlrtStack *sp, const mxArray *b, emlrtMCInfo *location)
{
  const mxArray *pArray;
  pArray = b;
  emlrtCallMATLABR2012b(sp, 0, NULL, 1, &pArray, "grid", true, location);
}

static void hold(const emlrtStack *sp, const mxArray *b, emlrtMCInfo *location)
{
  const mxArray *pArray;
  pArray = b;
  emlrtCallMATLABR2012b(sp, 0, NULL, 1, &pArray, "hold", true, location);
}

static void line(const emlrtStack *sp, const mxArray *b, const mxArray *c,
                 emlrtMCInfo *location)
{
  const mxArray *pArrays[2];
  pArrays[0] = b;
  pArrays[1] = c;
  emlrtCallMATLABR2012b(sp, 0, NULL, 2, pArrays, "line", true, location);
}

static void plot(const emlrtStack *sp, const mxArray *b, const mxArray *c, const
                 mxArray *d, emlrtMCInfo *location)
{
  const mxArray *pArrays[3];
  pArrays[0] = b;
  pArrays[1] = c;
  pArrays[2] = d;
  emlrtCallMATLABR2012b(sp, 0, NULL, 3, pArrays, "plot", true, location);
}

/*
 * function rocket_location = find_rocket_c(people)
 */
void find_rocket_c(const emlrtStack *sp, struct0_T *people, real_T
                   rocket_location[2])
{
  const mxArray *y;
  const mxArray *m0;
  static const int32_T iv0[2] = { 1, 2 };

  static const char_T u[2] = { 'o', 'n' };

  static const int32_T iv1[2] = { 1, 2 };

  int32_T i;
  boolean_T b0;
  boolean_T b1;
  real_T x;
  real_T absx;
  int32_T k;
  real_T lat[2];
  real_T P[6];
  real_T diff_polynom[6];
  int32_T P_tmp;
  int8_T n;
  real_T lon[2];
  real_T lon_intersect;
  real_T lat_intersect;
  real_T p[2];
  const mxArray *b_y;
  const mxArray *c_y;
  static const int32_T iv2[2] = { 1, 2 };

  static const char_T b_u[2] = { 'g', '+' };

  static const int32_T iv3[2] = { 1, 2 };

  real_T intersection_Latitude_idx_0;
  static const char_T c_u[2] = { 'r', '*' };

  real_T intersection_Longitude_idx_0;
  static const int32_T iv4[1] = { 2 };

  real_T *pData;
  static const int32_T iv5[1] = { 2 };

  real_T intersection_Latitude_idx_1;
  real_T intersection_Longitude_idx_1;
  struct_T tunableEnvironment[1];
  static const int32_T iv6[2] = { 1, 2 };

  static const char_T d_u[2] = { 'b', '*' };

  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;

  /* Latitude (North south) */
  /* Longitude (East West) */
  /* 'find_rocket_c:6' figure; */
  st.site = &pc_emlrtRSI;
  figure(&st, &emlrtMCI);

  /* 'find_rocket_c:6' hold on; */
  y = NULL;
  m0 = emlrtCreateCharArray(2, iv0);
  emlrtInitCharArrayR2013a(sp, 2, m0, (char_T *)&u[0]);
  emlrtAssign(&y, m0);
  st.site = &pc_emlrtRSI;
  hold(&st, y, &b_emlrtMCI);

  /* 'find_rocket_c:6' grid on; */
  y = NULL;
  m0 = emlrtCreateCharArray(2, iv1);
  emlrtInitCharArrayR2013a(sp, 2, m0, (char_T *)&u[0]);
  emlrtAssign(&y, m0);
  st.site = &pc_emlrtRSI;
  grid(&st, y, &c_emlrtMCI);

  /* 'find_rocket_c:7' for i =1:length(people.Latitude) */
  for (i = 0; i < 3; i++) {
    /* 'find_rocket_c:8' lat = [people.Latitude(i); people.Latitude(i) + 0.02 * sind(90+people.degrees(i))]; */
    b0 = muDoubleScalarIsInf(90.0 + people->degrees[i]);
    b1 = muDoubleScalarIsNaN(90.0 + people->degrees[i]);
    if (b0 || b1) {
      x = rtNaN;
    } else {
      x = muDoubleScalarRem(90.0 + people->degrees[i], 360.0);
      absx = muDoubleScalarAbs(x);
      if (absx > 180.0) {
        if (x > 0.0) {
          x -= 360.0;
        } else {
          x += 360.0;
        }

        absx = muDoubleScalarAbs(x);
      }

      if (absx <= 45.0) {
        x *= 0.017453292519943295;
        n = 0;
      } else if (absx <= 135.0) {
        if (x > 0.0) {
          x = 0.017453292519943295 * (x - 90.0);
          n = 1;
        } else {
          x = 0.017453292519943295 * (x + 90.0);
          n = -1;
        }
      } else if (x > 0.0) {
        x = 0.017453292519943295 * (x - 180.0);
        n = 2;
      } else {
        x = 0.017453292519943295 * (x + 180.0);
        n = -2;
      }

      if (n == 0) {
        x = muDoubleScalarSin(x);
      } else if (n == 1) {
        x = muDoubleScalarCos(x);
      } else if (n == -1) {
        x = -muDoubleScalarCos(x);
      } else {
        x = -muDoubleScalarSin(x);
      }
    }

    lat[0] = people->Latitude[i];
    lat[1] = people->Latitude[i] + 0.02 * x;

    /* 'find_rocket_c:9' lon = [people.Longitude(i); people.Longitude(i) + 0.02 * cosd(90+people.degrees(i))]; */
    if (b0 || b1) {
      x = rtNaN;
    } else {
      x = muDoubleScalarRem(90.0 + people->degrees[i], 360.0);
      absx = muDoubleScalarAbs(x);
      if (absx > 180.0) {
        if (x > 0.0) {
          x -= 360.0;
        } else {
          x += 360.0;
        }

        absx = muDoubleScalarAbs(x);
      }

      if (absx <= 45.0) {
        x *= 0.017453292519943295;
        n = 0;
      } else if (absx <= 135.0) {
        if (x > 0.0) {
          x = 0.017453292519943295 * (x - 90.0);
          n = 1;
        } else {
          x = 0.017453292519943295 * (x + 90.0);
          n = -1;
        }
      } else if (x > 0.0) {
        x = 0.017453292519943295 * (x - 180.0);
        n = 2;
      } else {
        x = 0.017453292519943295 * (x + 180.0);
        n = -2;
      }

      if (n == 0) {
        x = muDoubleScalarCos(x);
      } else if (n == 1) {
        x = -muDoubleScalarSin(x);
      } else if (n == -1) {
        x = muDoubleScalarSin(x);
      } else {
        x = -muDoubleScalarCos(x);
      }
    }

    lon[0] = people->Longitude[i];
    lon[1] = people->Longitude[i] + 0.02 * x;

    /* 'find_rocket_c:10' p = polyfit(lon,lat,1); */
    st.site = &emlrtRSI;
    polyfit(&st, lon, lat, p);

    /* 'find_rocket_c:11' people.p(:,i) = p'; */
    k = i << 1;
    people->p[k] = p[0];
    people->p[1 + k] = p[1];

    /* 'find_rocket_c:12' plot(people.Longitude(i), people.Latitude(i), 'r*'); */
    y = NULL;
    m0 = emlrtCreateDoubleScalar(people->Longitude[i]);
    emlrtAssign(&y, m0);
    b_y = NULL;
    m0 = emlrtCreateDoubleScalar(people->Latitude[i]);
    emlrtAssign(&b_y, m0);
    c_y = NULL;
    m0 = emlrtCreateCharArray(2, iv3);
    emlrtInitCharArrayR2013a(sp, 2, m0, (char_T *)&c_u[0]);
    emlrtAssign(&c_y, m0);
    st.site = &sc_emlrtRSI;
    plot(&st, y, b_y, c_y, &d_emlrtMCI);

    /* 'find_rocket_c:13' line(lon, lat); */
    y = NULL;
    m0 = emlrtCreateNumericArray(1, iv4, mxDOUBLE_CLASS, mxREAL);
    pData = emlrtMxGetPr(m0);
    pData[0] = people->Longitude[i];
    pData[1] = lon[1];
    emlrtAssign(&y, m0);
    b_y = NULL;
    m0 = emlrtCreateNumericArray(1, iv5, mxDOUBLE_CLASS, mxREAL);
    pData = emlrtMxGetPr(m0);
    pData[0] = people->Latitude[i];
    pData[1] = lat[1];
    emlrtAssign(&b_y, m0);
    st.site = &tc_emlrtRSI;
    line(&st, y, b_y, &e_emlrtMCI);
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(sp);
    }
  }

  /* alternative to circshift */
  /* 'find_rocket_c:17' P = zeros(2,length(people.p)); */
  /* 'find_rocket_c:18' for i = 1:length(people.p) */
  for (i = 0; i < 3; i++) {
    /* 'find_rocket_c:19' P(:,i) = people.p(:, mod(i, length(people.p))+1); */
    k = (int32_T)muDoubleScalarRem(1.0 + (real_T)i, 3.0);
    if (k + 1 > 3) {
      emlrtDynamicBoundsCheckR2012b(4, 1, 3, &emlrtBCI, sp);
    }

    k <<= 1;
    P_tmp = i << 1;
    P[P_tmp] = people->p[k];
    P[1 + P_tmp] = people->p[1 + k];
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(sp);
    }
  }

  /* 'find_rocket_c:22' diff_polynom = abs(P-people.p); */
  for (k = 0; k < 6; k++) {
    x = P[k] - people->p[k];
    diff_polynom[k] = muDoubleScalarAbs(x);
  }

  /* 'find_rocket_c:24' intersection.Latitude = zeros(1,length(people.p)); */
  /* 'find_rocket_c:25' intersection.Longitude = zeros(1,length(people.p)); */
  /* calculate intersection */
  /* 'find_rocket_c:27' for i = 1:length(people.p) */
  /* 'find_rocket_c:28' lon_intersect = fzero(@(x) polyval(diff_polynom(:,i), x),people.Longitude(i)); */
  st.site = &b_emlrtRSI;
  lon_intersect = fzero(&st, diff_polynom, 1.0, people->Longitude[0]);

  /* 'find_rocket_c:29' lat_intersect = polyval(people.p(1:2,i),lon_intersect); */
  lat_intersect = lon_intersect * people->p[0] + people->p[1];

  /* 'find_rocket_c:30' plot(lon_intersect, lat_intersect,'g+'); */
  y = NULL;
  m0 = emlrtCreateDoubleScalar(lon_intersect);
  emlrtAssign(&y, m0);
  b_y = NULL;
  m0 = emlrtCreateDoubleScalar(lat_intersect);
  emlrtAssign(&b_y, m0);
  c_y = NULL;
  m0 = emlrtCreateCharArray(2, iv2);
  emlrtInitCharArrayR2013a(sp, 2, m0, (char_T *)&b_u[0]);
  emlrtAssign(&c_y, m0);
  st.site = &rc_emlrtRSI;
  plot(&st, y, b_y, c_y, &g_emlrtMCI);

  /* 'find_rocket_c:31' intersection.Latitude(i) = lat_intersect; */
  intersection_Latitude_idx_0 = lat_intersect;

  /* 'find_rocket_c:32' intersection.Longitude(i) = lon_intersect; */
  intersection_Longitude_idx_0 = lon_intersect;
  if (*emlrtBreakCheckR2012bFlagVar != 0) {
    emlrtBreakCheckR2012b(sp);
  }

  /* 'find_rocket_c:28' lon_intersect = fzero(@(x) polyval(diff_polynom(:,i), x),people.Longitude(i)); */
  st.site = &b_emlrtRSI;
  lon_intersect = fzero(&st, diff_polynom, 2.0, people->Longitude[1]);

  /* 'find_rocket_c:29' lat_intersect = polyval(people.p(1:2,i),lon_intersect); */
  lat_intersect = lon_intersect * people->p[2] + people->p[3];

  /* 'find_rocket_c:30' plot(lon_intersect, lat_intersect,'g+'); */
  y = NULL;
  m0 = emlrtCreateDoubleScalar(lon_intersect);
  emlrtAssign(&y, m0);
  b_y = NULL;
  m0 = emlrtCreateDoubleScalar(lat_intersect);
  emlrtAssign(&b_y, m0);
  c_y = NULL;
  m0 = emlrtCreateCharArray(2, iv2);
  emlrtInitCharArrayR2013a(sp, 2, m0, (char_T *)&b_u[0]);
  emlrtAssign(&c_y, m0);
  st.site = &rc_emlrtRSI;
  plot(&st, y, b_y, c_y, &g_emlrtMCI);

  /* 'find_rocket_c:31' intersection.Latitude(i) = lat_intersect; */
  intersection_Latitude_idx_1 = lat_intersect;

  /* 'find_rocket_c:32' intersection.Longitude(i) = lon_intersect; */
  intersection_Longitude_idx_1 = lon_intersect;
  if (*emlrtBreakCheckR2012bFlagVar != 0) {
    emlrtBreakCheckR2012b(sp);
  }

  /* 'find_rocket_c:28' lon_intersect = fzero(@(x) polyval(diff_polynom(:,i), x),people.Longitude(i)); */
  st.site = &b_emlrtRSI;
  lon_intersect = fzero(&st, diff_polynom, 3.0, people->Longitude[2]);

  /* 'find_rocket_c:29' lat_intersect = polyval(people.p(1:2,i),lon_intersect); */
  lat_intersect = lon_intersect * people->p[4] + people->p[5];

  /* 'find_rocket_c:30' plot(lon_intersect, lat_intersect,'g+'); */
  y = NULL;
  m0 = emlrtCreateDoubleScalar(lon_intersect);
  emlrtAssign(&y, m0);
  b_y = NULL;
  m0 = emlrtCreateDoubleScalar(lat_intersect);
  emlrtAssign(&b_y, m0);
  c_y = NULL;
  m0 = emlrtCreateCharArray(2, iv2);
  emlrtInitCharArrayR2013a(sp, 2, m0, (char_T *)&b_u[0]);
  emlrtAssign(&c_y, m0);
  st.site = &rc_emlrtRSI;
  plot(&st, y, b_y, c_y, &g_emlrtMCI);

  /* 'find_rocket_c:31' intersection.Latitude(i) = lat_intersect; */
  /* 'find_rocket_c:32' intersection.Longitude(i) = lon_intersect; */
  if (*emlrtBreakCheckR2012bFlagVar != 0) {
    emlrtBreakCheckR2012b(sp);
  }

  /* 'find_rocket_c:35' f_inter = @(point) sum((intersection.Latitude - point(2)).^2 + (intersection.Longitude - point(1)).^2); */
  tunableEnvironment[0].Latitude[0] = intersection_Latitude_idx_0;
  tunableEnvironment[0].Longitude[0] = intersection_Longitude_idx_0;
  tunableEnvironment[0].Latitude[1] = intersection_Latitude_idx_1;
  tunableEnvironment[0].Longitude[1] = intersection_Longitude_idx_1;
  tunableEnvironment[0].Latitude[2] = lat_intersect;
  tunableEnvironment[0].Longitude[2] = lon_intersect;

  /* 'find_rocket_c:36' rocket_location = fminsearch(f_inter, [people.Latitude(1), people.Longitude(1)]); */
  rocket_location[0] = people->Latitude[0];
  rocket_location[1] = people->Longitude[0];
  st.site = &c_emlrtRSI;
  fminsearch(tunableEnvironment, rocket_location);

  /* 'find_rocket_c:37' plot(rocket_location(1), rocket_location(2), 'b*'); */
  y = NULL;
  m0 = emlrtCreateDoubleScalar(rocket_location[0]);
  emlrtAssign(&y, m0);
  b_y = NULL;
  m0 = emlrtCreateDoubleScalar(rocket_location[1]);
  emlrtAssign(&b_y, m0);
  c_y = NULL;
  m0 = emlrtCreateCharArray(2, iv6);
  emlrtInitCharArrayR2013a(sp, 2, m0, (char_T *)&d_u[0]);
  emlrtAssign(&c_y, m0);
  st.site = &qc_emlrtRSI;
  plot(&st, y, b_y, c_y, &f_emlrtMCI);
}

/* End of code generation (find_rocket_c.cpp) */

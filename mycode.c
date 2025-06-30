/* START VAR D */
#define P(x,y) printf(x,y)
#define PP(x,y,z) printf(x,y,z)
#define N1 125.85
#define N2 41.95
#define N (N1/N2)
#define D "%d\n"
#define T "Int Cast Bug Example\n"
#define E "(%.2f / %.2f) = ?\n"
#define A   "float (10): %1.10f\n"
#define AA  "float (15): %1.15f\n"
#define AAA "float (20): %1.20f\n"
#define B "int cast  : %d\n"
#define C "round()   : %d\n"
/* END VAR D */
/* START VAR C */
#include <stdio.h>
#include <math.h>
int main(void){P("%s",T);PP(E,N1,N2);P(A,N);P(AA,N);P(AAA,N);P(B,(int)(N));P(C,(int)round(N));}
/* END VAR C */

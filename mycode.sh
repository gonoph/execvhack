#!/bin/sh

A='#!/bin/sh
cd /var/tmp
'
B='gcc -w -xc -o t - <<EOF
'
C='int main(void){P("%s\n",T);P(A,N);P(B,(int)(N));P(C,(int)round(N));}
EOF
./t;rm -f ./t'
D='#define P(x,y) printf(x,y)
#define N (125.85/41.95)
#define D "%d\n"
#define T "Rounding Bug Example"
#define A "double:   %1.f\n"
#define B "int cast: %d\n"
#define C "round() : %d\n"
'

echo "$A" "$B" "$C"
echo "$A" "$B" "$D" "$C" | sh

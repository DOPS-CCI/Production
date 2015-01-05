'/*
'   A C-program for MT19937, with initialization improved 2002/1/26.
'   Coded by Takuji Nishimura and Makoto Matsumoto.
'
'   Before using, initialize the state by using init_genrand(seed)
'   or init_by_array(init_key, key_length).
'
'   Copyright (C) 1997 - 2002, Makoto Matsumoto and Takuji Nishimura,
'   All rights reserved.
'
'   Redistribution and use in source and binary forms, with or without
'   modification, are permitted provided that the following conditions
'   are met:
'
'     1. Redistributions of source code must retain the above copyright
'        notice, this list of conditions and the following disclaimer.
'
'     2. Redistributions in binary form must reproduce the above copyright
'        notice, this list of conditions and the following disclaimer in the
'        documentation and/or other materials provided with the distribution.
'
'     3. The names of its contributors may not be used to endorse or promote
'        products derived from this software without specific prior written
'        permission.
'
'   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
'   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
'   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
'   A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
'   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
'   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
'   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
'   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
'   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
'   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
'   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
'
'
'   Any feedback is very welcome.
'   http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/emt.html
'   email: m-mat @ math.sci.hiroshima-u.ac.jp (remove space)
'*/
'
' Translated to FreeBASIC by Greg Lyon - April 2006
'
'OPTION EXPLICIT
'Option Base 0
'
'#include <stdio.h>
'#Include "vbcompat.bi"

'Declare Function main() As Long
'
'/* Period parameters */
'#define N 624
'#define M 397
'#define MATRIX_A 0x9908b0dfUL   /* constant vector a */
'#define UPPER_MASK 0x80000000UL /* most significant w-r bits */
'#define LOWER_MASK 0x7fffffffUL /* least significant r bits */
'
%N = 624???
%M = 397???
%MATRIX_A =  &H9908b0df??? ' constant vector a
%UPPER_MASK = &H80000000??? ' most significant w-r bits
%LOWER_MASK = &H7fffffff??? ' least significant r bits
'
'static unsigned long mt[N]; /* the array for the state vector  */
'static int mti=N+1; /* mti==N+1 means mt[N] is not initialized */
'
GLOBAL  mt() AS DWORD ' the array For the state vector
GLOBAL  mti AS LONG ' mti == N+1 means mt[N] Is Not initialized

'main()
'
'Print
'Print "Press any key to exit...";
'GetKey
'Print

'End 0

'
'-------------------------------------------------------
'/* initializes mt[N] with a seed */
'void init_genrand(unsigned long s)
'{
'    mt[0]= s & 0xffffffffUL;
'    for (mti=1; mti<N; mti++) {
'        mt[mti] =
'       (1812433253UL * (mt[mti-1] ^ (mt[mti-1] >> 30)) + mti);
'        /* See Knuth TAOCP Vol2. 3rd Ed. P.106 for multiplier. */
'        /* In the previous versions, MSBs of the seed affect   */
'        /* only MSBs of the array mt[].                        */
'        /* 2002/01/09 modified by Makoto Matsumoto             */
'        mt[mti] &= 0xffffffffUL;
'        /* for >32 bit machines */
'    }
'}
' initializes mt[N] with a seed
SUB init_MT_genrand(BYVAL s AS DWORD)

    mt(0)= s AND &Hffffffff???
    FOR mti = 1 TO %N-1
         mt(mti) = ( 1812433253??? * ( mt(mti-1) XOR (mt(mti-1) \ 2^30 ) ) + mti )
        ' See Knuth TAOCP Vol2. 3rd Ed. P.106 For multiplier.
        ' In the previous versions, MSBs of the seed affect
        ' only MSBs of the array mt[].
        ' 2002/01/09 modified by Makoto Matsumoto
        mt(mti) = mt(mti) AND &Hffffffff???
        ' For >32 Bit machines
    NEXT mti
END SUB
'-------------------------------------------------------
'/* initialize by an array with array-length */
'/* init_key is the array for initializing keys */
'/* key_length is its length */
'/* slight change for C++, 2004/2/26 */
'void init_by_array(unsigned long init_key[], int key_length)
'{
'    int i, j, k;
'    init_genrand(19650218UL);
'    i=1; j=0;
'    k = (N>key_length ? N : key_length);
'    for (; k; k--) {
'        mt[i] = (mt[i] ^ ((mt[i-1] ^ (mt[i-1] >> 30)) * 1664525UL))
'          + init_key[j] + j; /* non linear */
'        mt[i] &= 0xffffffffUL; /* for WORDSIZE > 32 machines */
'        i++; j++;
'        if (i>=N) { mt[0] = mt[N-1]; i=1; }
'        if (j>=key_length) j=0;
'    }
'    for (k=N-1; k; k--) {
'        mt[i] = (mt[i] ^ ((mt[i-1] ^ (mt[i-1] >> 30)) * 1566083941UL))
'          - i; /* non linear */
'        mt[i] &= 0xffffffffUL; /* for WORDSIZE > 32 machines */
'        i++;
'        if (i>=N) { mt[0] = mt[N-1]; i=1; }
'    }
'
'    mt[0] = 0x80000000UL; /* MSB is 1; assuring non-zero initial array */
'}
'
' initialize by an array with array-length
' init_key is the array for initializing keys
' key_length is its length
' slight change for C++, 2004/2/26
SUB init_MT_by_array()
   DIM  mt(%N) AS DWORD ' the array For the state vector
    'DIM  mti AS LONG ' mti == N+1 means mt[N] Is Not initialized
    DIM init_key(4) AS DWORD
    DIM key_length AS DWORD

     DIM i AS LONG
     DIM j AS LONG
     DIM k AS LONG

    RANDOMIZE TIMER
    ARRAY ASSIGN init_key() = RND, RND, RND, RND
    'ARRAY ASSIGN init_key() = &H123, &H234, &H345, &H456

    mti = %N + 1
    key_length = 4



     init_MT_genrand(19650218???)
     i = 1
     j = 0
     k = IIF(%N > key_length, %N, key_length)
     FOR k = k TO 1 STEP -1
         mt(i) = (mt(i) XOR ((mt(i-1) XOR (mt(i-1) \ 2^30)) * 1664525???)) + init_key(j) + j ' non linear
         mt(i) = mt(i) AND &Hffffffff??? ' for WORDSIZE > 32 machines */
         i = i + 1
         j = j + 1
         IF i >= %N THEN
             mt(0) = mt(%N-1)
             i = 1
         END IF
         IF j >= key_length THEN
            j = 0
         END IF
     NEXT
     FOR k = %N-1 TO 1 STEP -1
         mt(i) = (mt(i) XOR ((mt(i-1) XOR (mt(i-1) \ 2^30)) * 1566083941???)) - i ' non linear
         mt(i) = mt(i) AND &Hffffffff??? ' for WORDSIZE > 32 machines
         i = i + 1
         IF i >= %N THEN
            mt(0) = mt(%N-1)
            i = 1
         END IF
     NEXT

     mt(0) = &H80000000??? ' MSB is 1; assuring non-zero initial array

END SUB
'-------------------------------------------------------
'/* generates a random number on [0,0xffffffff]-interval */
'unsigned long genrand_int32(void)
'{
'    unsigned long y;
'    static unsigned long mag01[2]={0x0UL, MATRIX_A};
'    /* mag01[x] = x * MATRIX_A  for x=0,1 */
'
'    if (mti >= N) { /* generate N words at one time */
'        int kk;
'
'        if (mti == N+1)   /* if init_genrand() has not been called, */
'            init_genrand(5489UL); /* a default initial seed is used */
'
'        for (kk=0;kk<N-M;kk++) {
'            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
'            mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 0x1UL];
'        }
'        for (;kk<N-1;kk++) {
'            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
'            mt[kk] = mt[kk+(M-N)] ^ (y >> 1) ^ mag01[y & 0x1UL];
'        }
'        y = (mt[N-1]&UPPER_MASK)|(mt[0]&LOWER_MASK);
'        mt[N-1] = mt[M-1] ^ (y >> 1) ^ mag01[y & 0x1UL];
'
'        mti = 0;
'    }
'
'    y = mt[mti++];
'
'    /* Tempering */
'    y ^= (y >> 11);
'    y ^= (y << 7) & 0x9d2c5680UL;
'    y ^= (y << 15) & 0xefc60000UL;
'    y ^= (y >> 18);
'
'    return y;
'}
'
' generates a Random number On [0,0xffffffff]-interval
FUNCTION genrand_int32() AS DWORD

    LOCAL y AS DWORD
    LOCAL mag01() AS DWORD
    DIM mag01(2)

    ARRAY ASSIGN mag01() = &H0???, %MATRIX_A

    ' mag01[x] = x * MATRIX_A  For x=0,1

    IF mti >= %N THEN
       ' generate N words at one Time
        DIM kk AS LONG

        IF mti = %N + 1 THEN  ' If init_genrand() has Not been called,
            init_MT_genrand(5489???) ' a default initial seed Is used
        END IF

        FOR kk = 0 TO (%N-%M)-1
            y = (mt(kk) AND %UPPER_MASK) OR (mt(kk+1) AND %LOWER_MASK)
            mt(kk) = mt(kk+%M) XOR (y \ 2^1) XOR mag01(y AND &H1???)
        NEXT

        FOR kk = kk TO (%N-1)-1
            y = (mt(kk) AND %UPPER_MASK)OR (mt(kk+1) AND %LOWER_MASK)
            mt(kk) = mt(kk + (%M-%N)) XOR (y \ 2^1) XOR mag01(y AND &H1???)
        NEXT

        y = (mt(%N-1) AND %UPPER_MASK) OR (mt(0) AND %LOWER_MASK)
        mt(%N-1) = mt(%M-1) XOR (y \ 2^1) XOR mag01(y AND &H1???)

        mti = 0

    END IF

    y = mt(mti)
    mti = mti + 1

    LOCAL tmp AS DWORD

    ' Tempering
    y = y XOR (y \ 2^11)
    tmp = y
    SHIFT LEFT tmp, 7
    y = y XOR ((tmp) AND &H9d2c5680???)
    tmp = y
    SHIFT LEFT tmp, 15
    y = y XOR ((tmp) AND &Hefc60000???)
    y = y XOR (y \ 2^18)

    FUNCTION = y

END FUNCTION
'-------------------------------------------------------
'/* generates a random number on [0,0x7fffffff]-interval */
'long genrand_int31(void)
'{
'    return (long)(genrand_int32()>>1);
'}
'
' generates a random number on [0,0x7fffffff]-interval
FUNCTION genrand_int31() AS LONG
    ''''Function = CLng(shift right genrand_int32(), 1)
END FUNCTION
'-------------------------------------------------------
'/* generates a random number on [0,1]-real-interval */
'double genrand_real1(void)
'{
'    return genrand_int32()*(1.0/4294967295.0);
'    /* divided by 2^32-1 */
'}
'
' generates a random number on [0,1]-real-interval
FUNCTION genrand_real1() AS DOUBLE
    FUNCTION = genrand_int32() * (1.0# / 4294967295.0#)
    ' divided by 2^32-1
END FUNCTION
'-------------------------------------------------------
'/* generates a random number on [0,1)-real-interval */
'double genrand_real2(void)
'{
'    return genrand_int32()*(1.0/4294967296.0);
'    /* divided by 2^32 */
'}
'
' generates a Random number On [0,1)-real-interval
FUNCTION genrand_real2() AS DOUBLE
    FUNCTION = genrand_int32() * (1.0# / 4294967296.0#)
    ' divided by 2^32
END FUNCTION
'-------------------------------------------------------'
'/* generates a random number on (0,1)-real-interval */
'double genrand_real3(void)
'{
'    return (((double)genrand_int32()) + 0.5) * (1.0 / 4294967296.0);
'    /* divided by 2^32 */
'}
'
' generates a Random number On (0,1)-real-interval
FUNCTION genrand_real3() AS DOUBLE
    FUNCTION =  (CDBL(genrand_int32()) + 0.5#) * (1.0# / 4294967296.0#)
    ' divided by 2^32
END FUNCTION
'-------------------------------------------------------
'/* generates a random number on [0,1) with 53-bit resolution*/
'double genrand_res53(void)
'{
'    unsigned long a=genrand_int32()>>5, b=genrand_int32()>>6;
'    return(a*67108864.0+b)*(1.0/9007199254740992.0);
'}
'/* These real versions are due to Isaku Wada, 2002/01/09 added */
'
' generates a random number on [0,1) with 53-bit resolution
FUNCTION genrand_res53() AS DOUBLE
    DIM a AS DWORD
    '''''a = shift right genrand_int32(), 5
    DIM b AS DWORD
    ''''b = shift right genrand_int32(), 6

    FUNCTION = (a * 67108864.0# + b) * (1.0# / 9007199254740992.0#)
END FUNCTION

FUNCTION RandomNumber(maxNum AS LONG) AS LONG
    FUNCTION = (genrand_real2() * (maxNum - 1)) + 1
END FUNCTION

FUNCTION RandomNumber2(minNum AS LONG, maxNum AS LONG) AS LONG
    FUNCTION = (genrand_real2() * (maxNum - minNum)) + minNum
END FUNCTION





' These real versions are due to Isaku Wada, 2002/01/09 added
'-------------------------------------------------------
'int main(void)
'{
'    int i;
'    unsigned long init[4]={0x123, 0x234, 0x345, 0x456}, length=4;
'    init_by_array(init, length);
'    printf("1000 outputs of genrand_int32()\n");
'    for (i=0; i<1000; i++) {
'      printf("%10lu ", genrand_int32());
'      if (i%5==4) printf("\n");
'    }
'    printf("\n1000 outputs of genrand_real2()\n");
'    for (i=0; i<1000; i++) {
'      printf("%10.8f ", genrand_real2());
'      if (i%5==4) printf("\n");
'    }
'    return 0;
'}
'

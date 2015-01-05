
CLASS FFTClass
    INSTANCE stab() AS DOUBLE
    INSTANCE PI AS DOUBLE


    CLASS METHOD CREATE()
        ' Do initialization
        PI = 3.141592653589793##
    END METHOD




    INTERFACE FFTInterface

        INHERIT IUNKNOWN


        METHOD genstab(m AS INTEGER)
          LOCAL i,a,n AS INTEGER  : REM local variables
          n = 2^m
          DIM stab(0 TO n)
          FOR i=0 TO n-1
            a = 2 * Pi * i/n
            stab(i) = SIN(a)
          NEXT i
        END METHOD

        METHOD fft(flag AS INTEGER,  pvr AS DWORD, pvi AS DWORD, m AS INTEGER)
          LOCAL i,j,k,n,ki,kr,km, istep, is2 AS INTEGER
          LOCAL astep,a,wr,wi,tr,ti,qr,qi AS DOUBLE

          n = 2^m
          REDIM vr(0 TO n-1) AS DOUBLE AT pvr
          REDIM vi(0 TO n-1) AS DOUBLE AT pvi
          REM       *** shuffle data using bit reversed addressing ***
          FOR k=0 TO n-1
            REM     *** generate a bit reversed address vr k ***
            ki = k
            kr = 0
            FOR i=1 TO m
              kr = kr * 2   : REM  **  left shift result kr by 1 bit
              IF ki MOD 2 = 1 THEN kr = kr + 1
              ki = INT(ki/2)    : REM  **  right shift temp ki by 1 bit
            NEXT i
            REM     *** swap data vr k to bit reversed address kr
            IF (kr > k) THEN
              tr = vr(kr) : vr(kr) = vr(k) : vr(k) = tr
              ti = vi(kr) : vi(kr) = vi(k) : vi(k) = ti
            END IF
          NEXT k

          REM       *** do fft butterflys in place ***
          istep = 2
          WHILE ( istep <= n ) : REM  *** layers 2,4,8,16, ... ,n ***
            is2 = istep/2
            astep = n/istep
            FOR km = 0 TO (is2)-1   : REM   *** outer row loop ***
              a  = km * astep       : REM  twiddle angle index
              wr =  stab(a+(n/4))   : REM  get sin from table lookup
              wi =  stab(a)             : REM pos for fft , neg for ifft
              REM   stab(a) == sin(2 * pi * km / istep)  by table lookup
              IF (flag = -1) THEN wi = -wi
              FOR ki = 0 TO (n - istep) STEP istep : REM  *** inner column loop ***
                i = km + ki
                j = (is2) + i
                tr = wr * vr(j) - wi * vi(j)    : REM ** complex multiply **
                ti = wr * vi(j) + wi * vr(j)
                qr = vr(i)
                qi = vi(i)
                vr(j) = qr - tr
                vi(j) = qi - ti
                vr(i) = qr + tr
                vi(i) = qi + ti
              NEXT ki
            NEXT km
            istep = istep * 2
          WEND
          REM  *** scale fft (or ifft) by n ***
          IF (flag = -1)  THEN '  ifft scaling or test flag = 1 for fft scaling
            a = 1/n
            FOR i=0 TO n-1 : vr(i) = vr(i)*a : vi(i) = vi(i)*a : NEXT i
          END IF
    END METHOD  'fft

    METHOD four1(ptrDataArray AS DWORD, nn AS DWORD, isign AS WORD)

    LOCAL n, mmax, m, j, istep, i, x AS DWORD
    LOCAL wtemp, wr, wpr, wpi, wi, theta AS DOUBLE
    LOCAL tempr, tempi AS DOUBLE



        n = 2 * nn

        REDIM dataArray(1 TO n) AS DOUBLE AT ptrDataArray


        j = 1
        FOR i = 1 TO n STEP 2
            IF (j > i) THEN
                tempr = dataArray(j)
                tempi = dataArray(j + 1)
                dataArray(j) = dataArray(i)
                dataArray(j + 1) = dataArray(i + 1)
                dataArray(i) = tempr
                dataArray(i + 1) = tempi
            END IF
            m = n / 2
            WHILE (m >= 2 AND j > m)
                j = j - m
                m = m / 2
            WEND
            j = j + m
        NEXT i

        ' here begins the Danielson-Lanczos section
        mmax = 2
        WHILE (n > mmax)
            istep = 2 * mmax

            theta = (2 * PI) / (isign * mmax)
            wpr = -2.0 * SIN(0.5 * theta) ^ 2
            wpi = SIN(theta)
            wr = 1.0
            wi = 0.0
            FOR m = 1 TO mmax STEP  2
                FOR i = m TO n STEP istep
                    j = i + mmax
                    tempr = wr * dataArray(j) - wi * dataArray(j + 1)
                    tempi = wr * dataArray(j + 1) + wi * dataArray(j)

                    dataArray(j) = dataArray(i) - tempr
                    dataArray(j + 1) = dataArray(i + 1) - tempi
                    dataArray(i) = dataArray(i) + tempr
                    dataArray(i + 1) = dataArray(i + 1) + tempi
                NEXT i
                wtemp = wr
                wr = wr * wpr - wi * wpi + wr
                wi = wi * wpr + wtemp * wpi + wi
            NEXT m
            mmax = istep
        WEND
    END METHOD

    END INTERFACE

END CLASS

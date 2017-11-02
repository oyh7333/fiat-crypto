#!/bin/sh
set -eu

g++ -march=native -mtune=native -std=gnu++11 -O3 -flto -fomit-frame-pointer -fwrapv -Wno-attributes -Dmodulus_limbs='10' -Dmodulus_bytes_val='25.5' -Dlimb_t=uint32_t -Dlimb_weight_gaps_array='{26,25,26,25,26,25,26,25,26,25}' -Dmodulus_array='{0x7f,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xed}' -Dq_mpz='(1_mpz<<255) - 19 ' "$@"
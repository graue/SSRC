ifeq ($(CC),cc)
CC=gcc
endif

CFLAGS = -Wall -Wno-unused -g -O3 -I./dft
#CFLAGS = -Wall -Wno-unused -g -I./dft
#CFLAGS += -DBIGENDIAN
#CFLAGS += -DNDEBUG

all : ssrc

dft.a :
	cd dft;"$(MAKE)" -f Makefile.double CC=$(CC) clean dft.a
	mv dft/dft.a .

dftsp.a :
	cd dft;"$(MAKE)" -f Makefile.float clean dftsp.a
	mv dft/dftsp.a .

dither.o : dither.c
	$(CC) $(CFLAGS) -std=c99 -c dither.c -o dither.o

prng.o : prng.c
	$(CC) $(CFLAGS) -std=c99 -c prng.c -o prng.o

ssrc : ssrc.c dftsp.a dither.o prng.o
	$(CC) $(CFLAGS) -DSLEEFDFT_REAL_IS_FLOAT ssrc.c dither.o prng.o dftsp.a -o ssrc -lm
#	strip ssrc

ssrc_hp : ssrc.c dft.a dither.o prng.o
	$(CC) $(CFLAGS) -DHIGHPREC ssrc.c dither.o prng.o dft.a -o ssrc_hp -lm
	strip ssrc_hp

clean :
	rm -f ssrc ssrc_hp ssrc.exe ssrc_hp.exe *.o *~ *.a *.wav *.pkf
	cd dft;"$(MAKE)" -f Makefile.float clean

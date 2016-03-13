ifeq ($(CC),cc)
CC=gcc
endif

CFLAGS = -Wall -Wno-unused -g -I./dft
#CFLAGS += -DBIGENDIAN

all : ssrc

dft.a :
	cd dft;"$(MAKE)" -f Makefile.double CC=$(CC) clean dft.a
	mv dft/dft.a .

dftsp.a :
	cd dft;"$(MAKE)" -f Makefile.float clean dftsp.a
	mv dft/dftsp.a .

ssrc : ssrc.c dftsp.a
	$(CC) $(CFLAGS) -DSLEEFDFT_REAL_IS_FLOAT ssrc.c dftsp.a -o ssrc -lm
	strip ssrc

ssrc_hp : ssrc.c dft.a
	$(CC) $(CFLAGS) -DHIGHPREC ssrc.c dft.a -o ssrc_hp -lm
	strip ssrc_hp

clean :
	rm -f ssrc ssrc_hp ssrc.exe ssrc_hp.exe *.o *~ *.a
	cd dft;"$(MAKE)" -f Makefile.float clean

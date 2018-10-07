		list 	p=PIC18f8722
		#include	p18f8722.inc
;		#include	"Timer.inc"
		CONFIG	OSC=HS, WDT=OFF, LVP=OFF
	
#define	ROW	LATB
#define	ROW_IO	TRISB
#define	GCOL	LATC
#define	GCOL_IO	TRISC
#define	RCOL	LATD
#define	RCOL_IO	TRISD
#define	NUTNHAN	PORTA,RA5
#define	NUT_IO	TRISA,RA5

	code	0x00000
	goto	start
	
	udata_acs
G_DATA	equ	H'66'
R_DATA	equ	H'A5'

idx	res	.1
gbuff	res	.8
rbuff	res	.8

PRG	code
start	call	init
main	clrf	ROW		;xoa hang
	movlw	G_DATA
	movwf	GCOL		;du lieu xanh
	movlw	R_DATA
	movwf	RCOL		;du lieu do
	movlw	B'00000001'
	movwf	ROW		;chon hang
main1	btfsc	NUTNHAN
	bra	main1
	rlncf	ROW
nhaphim	btfss	NUTNHAN
	bra	nhaphim
	bra 	main1
;
init	movlw	H'0F'
	movwf	ADCON1
	clrf	ROW_IO
	clrf	GCOL_IO
	clrf	RCOL_IO
	bsf	NUT_IO
	clrf	idx
	return
	global	Timer_process
Timer_process
	return
	end

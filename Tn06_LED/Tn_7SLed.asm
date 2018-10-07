		list 	p=PIC18F8722
		#include 	p18f8722.inc
		#include	"Timer.inc"
		CONFIG	OSC=HS, WDT=OFF, LVP=OFF
		
#define	SELECT	LATB
#define	SELECT_IO	TRISB
#define	SMENT	LATD
#define	SMENT_IO	TRISD
#define	NUT		PORTA,RA5
#define	NUT_IO	TRISA,RA5

		code		H'00000'
		goto		start
		org		H'08'
		goto		isr_high
		org		H'18'
		goto		isr_low
	
		udata_acs
MAXIDX	equ		.8
sbuff	res		.8
idx		res		.1
ledsel	res		.1
dem		res		.1

SO		equ		.9
LED4		equ		B'00010000'

PRG		code
start	rcall	init
	rcall	Timer0_init
main	bra		main
;
init	movlw	H'0F'
	movwf	ADCON1
	bsf	NUT_IO
	clrf	SELECT_IO
	clrf	SMENT_IO
	clrf	SELECT
	clrf	idx
	rcall	rom2ram
	movlw	H'80'	;B'10000000'
	movwf	ledsel
	return
;	
rom2ram	movlw	upper dulieu
	movwf	TBLPTRU
	movlw	high dulieu
	movwf	TBLPTRH
	movlw	low dulieu
	movwf	TBLPTRL
	lfsr	FSR0,sbuff
	movlw	MAXIDX
	movwf	dem
chep1	TBLRD*+
	movf	TABLAT,W
	movwf	POSTINC0
	decfsz	dem
	bra	chep1
	return
dulieu	data	"18102016"
xuat_led
	clrf	SELECT
	lfsr	FSR1,sbuff
	movf	idx,W
	movf	PLUSW1,W
	rcall	gm_7doan	;giai ma 7 doan
	movwf	SMENT
	movf	ledsel,W
	movwf	SELECT
	rrncf	ledsel
	incf	idx
	movlw	MAXIDX
	cpfslt	idx
	clrf	idx
	return
gm_7doan	movwf	TBLPTRL
	movlw	' '
	cpfseq	TBLPTRL
	bra		gm_1
	clrf		WREG
	return
gm_1	movlw	H'0F'
	andwf	TBLPTRL		
	movlw	low Bang_7s
	addwf	TBLPTRL
	movlw	high Bang_7s
	movwf	TBLPTRH
	clrf		WREG
	addwfc	TBLPTRH
	movlw	upper Bang_7s
	movwf	TBLPTRU
	TBLRD*
	movf		TABLAT,W
	return
Bang_7s	db		H'3F',H'06',H'5B',H'4F',H'66',H'6D',H'7D',H'07'
	db		H'7F',H'6F',H'77',H'7C',H'39',H'5E',H'79',H'71'
	global	Timer_process
Timer_process
	rcall	xuat_led
	return

isr_high	retfie
isr_low
	rcall	Timer0_isr
	retfie
		end

	
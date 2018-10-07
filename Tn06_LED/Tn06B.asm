	list 	p=PIC18f8722
	#include	p18f8722.inc
	#include	"Timer.inc"
	CONFIG	OSC=HS, WDT=OFF, LVP=OFF
	
#define	ROW	LATB
#define	ROW_IO	TRISB
#define	GCOL	LATC
#define	GCOL_IO	TRISC
#define	RCOL	LATD
#define	RCOL_IO	TRISD
#define	NUTNHAN	PORTA,RA5
#define	NUT_IO	TRISA,RA5

	code	H'00000'
	goto	start
	org	H'08'
	goto	isr_high
	org	H'18'
	goto	isr_low
	udata_acs
MAXIDX	equ	.8
idx	res	.1
gbuff	res	.8
rbuff	res	.8
rsel	res	.1
dem	res	.1

PRG	code
start
	rcall	init
	rcall	Timer0_init
main	btfsc	NUTNHAN
	bra 	main
	rcall	rom2ram2
main1	btfss	NUTNHAN
	bra	main1
	rcall	rom2ram
	bra	main
;Khoi dong port, bien
init
	movlw	H'0F'
	movwf	ADCON1
	clrf	ROW_IO
	clrf	GCOL_IO
	clrf	RCOL_IO
	bsf	NUT_IO
	rcall	rom2ram
	clrf	idx
	movlw	B'00000001'
	movwf	rsel
	return
rom2ram
	movlw	upper bang1
	movwf	TBLPTRU
	movlw	high bang1
	movwf	TBLPTRH
	movlw	low bang1
	movwf	TBLPTRL
	lfsr	FSR0,gbuff
	movlw	.16
	movwf	dem
chep1
	TBLRD*+
	movf	TABLAT,W
	movwf	POSTINC0
	decfsz	dem
	bra	chep1
	return
rom2ram2
	movlw	upper bang2
	movwf	TBLPTRU
	movlw	high bang2
	movwf	TBLPTRH
	movlw	low bang2
	movwf	TBLPTRL
	lfsr	FSR0,gbuff
	movlw	.16
	movwf	dem
chep2
	TBLRD*+
	movf	TABLAT,W
	movwf	POSTINC0
	decfsz	dem
	bra	chep2
	return
bang1	db	0x01,0x02,0x3C,0x24,0x24,0x3C,0x40,0x80
	db	0x80,0x40,0x3C,0x24,0x24,0x3C,0x02,0x01
bang2	db	0x80,0x40,0x3C,0x24,0x24,0x3C,0x02,0x01	
	db	0x01,0x02,0x3C,0x24,0x24,0x3C,0x40,0x80

	global	Timer_process
Timer_process
	clrf	ROW	;tat het cac hang
	lfsr	FSR1,gbuff
	movf	idx,W
	movf	PLUSW1,W
	movwf	GCOL	;du lieu xanh
	lfsr	FSR2,rbuff
	movf	idx,W	
	movf	PLUSW2,W
	movwf	RCOL	;du lieu do
	movf	rsel,W	;chon hang
	movwf	ROW
	rlncf	rsel		;hang ke tiep
	incf	idx		;tang chi so
	movlw	MAXIDX
	cpfslt	idx
	clrf	idx
	return
	
isr_high	retfie
isr_low	rcall	Timer0_isr
	retfie
	end

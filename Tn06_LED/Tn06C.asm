		list 	p=PIC18f8722
		#include	p18f8722.inc
		#include	"Timer.inc"
		CONFIG	OSC=HS, WDT=OFF, LVP=OFF
	
#define	ROW		LATB
#define	ROW_IO	TRISB
#define	GCOL		LATC
#define	GCOL_IO	TRISC
#define	RCOL		LATD
#define	RCOL_IO	TRISD
#define	NUTNHAN	PORTA,RA5
#define	NUT_IO	TRISA,RA5

		code		H'00000'
		goto		start
		org		H'08'
		goto		isr_high
		org		H'18'
		goto		isr_low
		udata_acs
MAXIDX	equ		.8
idx		res		.1
gbuff	res		.8
rbuff	res		.8
rsel		res		.1
MAXCIDX	equ		.8
c_idx	res		.1
dem		res		.1

PRG		code
start
		rcall	init
		rcall	Timer0_init
main		btfsc	NUTNHAN
		bra		main
		rcall	doi_dl
nhaphim	btfss	NUTNHAN
		bra		nhaphim
		bra 		main

init
		movlw	H'0F'
		movwf	ADCON1
		clrf		ROW_IO
		clrf		GCOL_IO
		clrf		RCOL_IO
		bsf		NUT_IO
		clrf		idx
		movlw	B'00000001'
		movwf	rsel
		clrf		c_idx
		rcall	doi_dl
		return
chep
		lfsr		FSR0,gbuff
		movlw	.16
		movwf	dem
chep1
		TBLRD*+
		movf		TABLAT,W
		movwf	POSTINC0
		decfsz	dem
		bra		chep1
		return
;-------------------------------------------
;Chep ROM sang RAM 2 byte dau gbuff va rbuff
;-------------------------------------------
rom2ram
		movlw	upper bang1
		movwf	TBLPTRU
		movlw	high bang1
		movwf	TBLPTRH
		movlw	low bang1
		movwf	TBLPTRL
		rcall	chep
		return
;-------------------------------------------
;Chep ROM sang RAM 2 byte dau gbuff va rbuff
;-------------------------------------------
doi_dl
		movf		c_idx,W
		mullw	.16
		movlw	low bang1
		addwfc	PRODL,W
		movwf	TBLPTRL
		movlw	high bang1
		movwf	TBLPTRH
		movlw	0
		addwfc	TBLPTRH
		movlw	upper bang1
		movwf	TBLPTRU
		rcall	chep
		incf		c_idx
		movlw	MAXCIDX
		cpfslt	c_idx
		clrf		c_idx
		return
;----------------------------------------------------------		
bang1	db		0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x00
		db		0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01
bang2	db		0x40,0xC0,0x00,0x00,0x00,0x00,0x00,0x00
		db		0x00,0x00,0x00,0x00,0x00,0x00,0x03,0x02
bang3	db		0x20,0x20,0xE0,0x00,0x00,0x00,0x00,0x00
		db		0x00,0x00,0x00,0x00,0x00,0x07,0x04,0x04
bang4	db		0x10,0x10,0x10,0xF0,0x00,0x00,0x00,0x00
		db		0x00,0x00,0x00,0x00,0x0F,0x08,0x08,0x08
bang5	db		0x08,0x08,0x08,0x18,0xF8,0x00,0x00,0x00
		db		0x00,0x00,0x00,0x1F,0x18,0x10,0x10,0x10
bang6	db		0x04,0x04,0x3C,0x24,0x24,0xFC,0x00,0x00
		db		0x00,0x00,0x3F,0x24,0x24,0x3C,0x20,0x20
bang7	db		0x02,0x7E,0x42,0x42,0x42,0x42,0xFE,0x00
		db		0x02,0x7F,0x42,0x42,0x42,0x42,0x7E,0x40
bang8	db		0xFF,0x81,0x81,0x81,0x81,0x81,0x81,0xFF
		db		0xFF,0x81,0x81,0x81,0x81,0x81,0x81,0xFF
;----------------------------------------------------------		
		global	Timer_process
Timer_process
		clrf		ROW		;tat het cac hang
		lfsr		FSR1,gbuff
		lfsr		FSR2,rbuff
		movf		idx,W	;du lieu xanh
		movf		PLUSW1,W
		movwf	GCOL
		movf		idx,W	;du lieu do	
		movf		PLUSW2,W
		movwf	RCOL
		movf		rsel,W	;chon hang
		movwf	ROW
		rlncf	rsel		;hang ke tiep
		incf		idx		;tang chi so
		movlw	MAXIDX
		cpfslt	idx
		clrf		idx
		return
	
isr_high	retfie
isr_low	rcall	Timer0_isr
		retfie

		end

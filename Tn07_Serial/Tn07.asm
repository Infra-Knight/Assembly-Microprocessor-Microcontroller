	list	p=PIC18f8722
	#include	p18f8722.inc
	#include	"PIC18Lcd.inc"
	#include	"Serial.inc"
	CONFIG	OSC=HS,WDT=OFF,LVP=OFF

#define	LED	LATD
#define	LED_IO	TRISD
#define	NUT	PORTA,RA5
#define	NUT_IO	TRISA,RA5

	code	H'00000'
	goto	start
	org	H'08'
	goto	isr_high
	udata_acs
KYTU_DAU	equ	'A'
char	res	.1
COLMAX	equ	.16
tx_col	res	.1
rc_col	res	.1
row	res	.1
PRG	code	
start	rcall	init
	rcall	Lcd_init
	rcall	Serial_init
main	btfsc	NUT
	bra	main
	rcall	Truyen
nha	btfss	NUT
	bra	nha
	bra	main
init	movlw	H'0F'
	movwf	ADCON1
	bsf	NUT_IO
	clrf	LED_IO
	movlw	KYTU_DAU
	movwf	char
	clrf	tx_col
	clrf	rc_col
	return
;Truyen 1 ky tu dung giao tiep noi tiep
Truyen	clrf	row	;chon hang tren LCD
	gotovxy	row,tx_col;hien ky tu ra LCD
	putmch	char
	movf	char,W
	movwf	tx_char
	rcall	Send_char	;Truyen ky tu
	incf	char
	incf	tx_col	;tang cot LCD
	movlw	COLMAX
	cpfslt	tx_col
	clrf	tx_col
	return
;Hien ky tu nhan noi tiep ra hang duoi LCD
xuatLcd	bsf	row,0
	gotovxy	row,rc_col
	putmch	rc_char
	movf	rc_char,W
	movwf	LED
	incf	rc_col
	movlw	COLMAX
	cpfslt	rc_col
	clrf	rc_col
	return
	global	Serial_process
Serial_process
	movf	RCREG1,W
	movwf	rc_char
	rcall	xuatLcd
	return
	global	Rcerr_process
Rcerr_process
	setf	LED
	return
isr_high	rcall	Serial_isr
	retfie
	end
	
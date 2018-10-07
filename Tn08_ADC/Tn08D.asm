	list 	p=PIC18f8722
	#include	P18F8722.INC
	CONFIG	OSC=HS,WDT=OFF,LVP=OFF
	#include	"..\LcdModule\PIC18Lcd.inc"
	#include	"..\Timer0Module\Timer.inc"
	#include	"Adc.inc"
	
#define	NUT	PORTA,RA5
#define	NUT_IO	TRISA,RA5

	code	0
	goto	start		
	org	H'08'
	goto	isr_high
	org	H'18'
	goto	isr_low
		
	udata_acs
SODEM_1S	equ	.100
dems	res	.1
tV_buf	res	.6
temp	res	.1
PRG	code
start
	rcall	Lcd_init
	rcall	init
	rcall	Intro
	rcall	Adc_init
	rcall	Timer0_init
main	bra	main
	
init
	bsf	NUT_IO
	movlw	SODEM_1S
	movwf	dems
	movlw	' '
	movwf	tV_buf+3
	movlw	'V'
	movwf	tV_buf+4
	clrf	tV_buf+5
	return
;
adc_str	data	"AD conversion",0
Intro	gotoxy	0,0
	putsrom	adc_str
	return
;
tV_out	infsnz	ad_res
	incf	ad_res+1
	movf	ad_res+1,W
	mullw	.50
	movf	PRODL,W
	movwf	temp
	movf	ad_res,W
	mullw	.50
	movf	temp,W
	addwf	PRODH
	rcall	Div1024
	movf	PRODL,W
	lfsr	FSR0,tV_buf
	rcall	bcd2p
	putsram	tV_buf
	return	
	global	Adc_process
Adc_process
	gotoxy	.1,.11
	rcall	tV_out
	return
	global	Timer_process
Timer_process
	decfsz	dems
	return
	movlw	SODEM_1S
	movwf	dems
	bsf	ADCON0,GO
	return
isr_high	rcall	Adc_isr
	retfie
isr_low	rcall	Timer0_isr
	retfie
	end
		
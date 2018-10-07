	list 	p=PIC18f8722
	#include	P18F8722.INC
	CONFIG	OSC=HS,WDT=OFF,LVP=OFF
	#include	"..\LcdModule\PIC18Lcd.inc"
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
;
PRG	code
start
	rcall	init
	rcall	Lcd_init
	rcall	Intro
	rcall	Adc_init
main	bra	main
;	
init	bsf	NUT_IO
	return
;
adc_str	data	"AD conversion",0
Intro	gotoxy	0,0
	putsrom	adc_str
	return		
;
	global	Adc_process
Adc_process
	gotoxy	.1,.11
	putmw	ad_res
	return

isr_high	rcall	Adc_isr
	retfie

isr_low	retfie
	end
		
		list 	p=PIC18f8722
		#include	P18F8722.INC
		#include	"..\LcdModule\PIC18Lcd.inc"
		#include	"..\Timer0Module\Timer.inc"
		#include	"Adc.inc"
		CONFIG	OSC=HS,WDT=OFF,LVP=OFF
	
#define	LED		LATD
#define	LED_IO	TRISD
#define	NUT		PORTA,RA5
#define	NUT_IO	TRISA,RA5

	code	0
	goto	start
	org	H'08'
	goto	isr_high
	org	H'18'
	goto	isr_low
	udata_acs
SODEM_1S	equ	.100
dems	res	1
dem_led	res	1
PRG	code
start
	rcall	init
	rcall	Lcd_init
	rcall	Intro
	rcall	Adc_init
	rcall	Timer0_init
main	bra	main
	
init	clrf	TRISD
	bsf	NUT_IO
	clrf	LED
	movlw	SODEM_1S
	movwf	dems
	return
adc_str	data	"AD conversion",0
Intro	gotoxy	0,0
	putsrom	adc_str
	return		
Xuat_led	bcf	STATUS,C
	rlcf	ad_res,W
	rlcf	ad_res+1,W
	incf	WREG
	movwf	dem_led
	clrf	WREG
xuat_le1	bsf	STATUS,C
	rlcf	WREG
	decfsz	dem_led
	bra	xuat_le1
	movwf	LED
	return
	global	Adc_process
Adc_process
	gotoxy	1,.11
	putmw	ad_res
	rcall	Xuat_led
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
		
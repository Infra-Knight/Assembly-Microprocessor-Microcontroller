	list 	p=PIC18f8722
	#include	P18F8722.INC
	CONFIG	OSC=HS,WDT=OFF,LVP=OFF
	#include	"..\LcdModule\PIC18Lcd.inc"
	#include	"..\Timer0Module\Timer.inc"
	#include	"Adc.inc"
	
#define	NUT	PORTA,RA5
#define	NUT_IO	TRISA,RA5
;Program entry
	code	0
	goto	start
	org	H'08'
	goto	isr_high
	org	H'18'
	goto	isr_low
;Data RAM segment		
	udata_acs
SODEM_1S	equ	.100
dems	res	.1
;Code segment
PRG	code
start
	rcall	init
	rcall	Lcd_init
	rcall	Intro
	rcall	Adc_init
	rcall	Timer0_init
;main proc
main	bra	main
;Khoi dong bien	
init	bsf	NUT_IO
	movlw	SODEM_1S
	movwf	dems
	return
;Xuat cau mo dau ra LCD
adc_str	data	"AD conversion",0
Intro	gotoxy	0,0
	putsrom	adc_str
	return		
;Xu ly AD
	global	Adc_process
Adc_process
	gotoxy	.1,.11
	putmw	ad_res
	return
;Xu ly thoi gian
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
		
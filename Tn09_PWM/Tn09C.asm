	list 	p=PIC18f8722
	#include	P18F8722.INC
	#include	"..\LcdModule\PIC18Lcd.inc"
	#include	"..\Timer0Module\Timer.inc"
	CONFIG	OSC=HS,WDT=OFF,LVP=OFF

#define	PWMOUT_IO	TRISC,RC2
#define	TANG	flags,0
	
	code	H'00000'
	goto	start
	org	H'08'
	goto	isr_high
	org	H'18'
	goto	isr_low
	udata_acs
PWM_CFG	equ	H'0C'
T2_CFG	equ	H'07'
PR2_VAL	equ	.159
DUTY8_VAL	equ	.20
MAXDUTY8	equ	.140
MINDUTY8	equ	.5
duty8	res	.1
SODEM1S	equ	.20
dems	res	.1
flags	res	.1
PRG	code
start	rcall	Lcd_init
	rcall	init
	rcall	Pwm_init
	putmb	duty8
	rcall	Timer0_init
main1	btfss	TANG
	bra	main1
tang_led	bcf	INTCON,GIEH
	bcf	TANG
	bsf	INTCON,GIEH
	rcall	tang_sang
	bra	main1
	
tang_sang	gotoxy	1,7
	putmb	duty8
	movlw	MAXDUTY8
	cpfsgt	duty8
	bra	tang_1
	movlw	MINDUTY8
	movwf	duty8
	bra	tang_2
tang_1	movlw	MINDUTY8
	addwf	duty8
	movf	duty8,W
tang_2	movwf	CCPR1L
	return
init
	movlw	H'0F'
	movwf	ADCON1
	movlw	SODEM1S
	movwf	dems
	clrf	duty8
	movlw	MINDUTY8
	movwf	duty8
	bcf	TANG
	return
Pwm_init
	bcf	PWMOUT_IO
	movlw	PWM_CFG
	movwf	CCP1CON
	movlw	T2_CFG
	movwf	T2CON
	movlw	PR2_VAL
	movwf	PR2
	movf	duty8,W
	movwf	CCPR1L
	bcf	CCP1CON,CCP1X
	bcf	CCP1CON,CCP1Y
	return
	global	Timer_process
Timer_process
	decfsz	dems
	return
	movlw	SODEM1S
	movwf	dems
	bsf	TANG
	return
isr_high	retfie
isr_low	rcall	Timer0_isr
	retfie
	end

	list 	p=PIC18f8722
	#include	P18F8722.INC
	CONFIG	OSC=HS,WDT=OFF,LVP=OFF

	#define	PWMOUT_IO	TRISC,RC2
	
	code	H'00000'
	goto	start
	org	H'08'
	goto	isr_high
	org	H'18'
	goto	isr_low
	udata_acs
PWM_CFG	equ	H'0E'
T2_CFG	equ	H'07'
PR2_VAL	equ	.159
DUTY8_VAL	equ	.36
PRG	code
start	rcall	init
	rcall	Pwm_init
main1	bra	main1
init
	movlw	H'0F'
	movwf	ADCON1
	return
Pwm_init
	bcf	PWMOUT_IO
	movlw	PWM_CFG
	movwf	CCP1CON
	movlw	T2_CFG
	movwf	T2CON
	movlw	PR2_VAL
	movwf	PR2
	movlw	DUTY8_VAL
	movwf	CCPR1L
	bcf	CCP1CON,CCP1X
	bsf	CCP1CON,CCP1Y
	return
isr_high	retfie
isr_low	retfie
	end

		list	p=PIC18F8722
		#include	P18F8722.INC
		#include	timer.inc
		#define	NUT_NHAN	PORTA,RA5
		#define	TANG	flags,0
	
		code	H'00000'
		goto	start
		org	H'00008'
		goto	t0_isr
		udata
duty		res	.1
flags		res	.1
PRG		code
start
		rcall	pwm_init
		rcall	t0_init
main1	rcall	Delay100ms
		rcall	testnut
		btfss	TANG
		bra	giam_led
tang_led		rcall	tang_sang
		bra	main1
giam_led		rcall	giam_sang
		bra	main1
		
testnut
		btfsc	NUT_NHAN
		return
		btg	LATC,RC1
testn1		btfss	NUT_NHAN
		bra	testn1
		return
		
tang_sang		movlw	.155
		cpfseq	duty
		bra	tang_1
		bcf	TANG
		return
tang_1		movlw	.5
		addwf	duty,F
		movf	duty,W
		movwf	CCPR1L
		return

giam_sang		movlw	.5
		cpfseq	duty
		bra	giam_1
		bsf	TANG
		return
giam_1		subwf	duty,F
		movf	duty,W
		movwf	CCPR1L
		return

pwm_init
		movlw	H'0F'
		movwf	ADCON1
		clrf	TRISA
		bsf	TRISA,RA5
		clrf	TRISC
		movlw	H'0C'
		movwf	CCP1CON
		movlw	H'07'
		movwf	T2CON
		movlw	.159
		movwf	PR2
		movlw	.155
		movwf	duty
		movwf	CCPR1L
		bcf	CCP1CON,CCP1X
		bcf	CCP1CON,CCP1Y
		bcf	TANG
		bsf	LATA,RA0
		bcf	LATC,RC0
		bcf	LATC,RC1
		return
t0_isr		rcall	t0_load
		rcall	t0_time
		retfie
		end

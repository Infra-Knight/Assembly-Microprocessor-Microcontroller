	list	p=PIC18f8722
	#include	p18f8722.inc
	CONFIG	OSC = HS, WDT = OFF, LVP = OFF

#define	LED	LATD
#define	LED_IO	TRISD
#define	KEY_IO	TRISB
#define	ALLCOL	PORTB
#define	ALLROW	LATB

#define	COL1	PORTB,RB0
#define	COL2	PORTB,RB1
#define	COL3	PORTB,RB2
#define	COL4	PORTB,RB3
#define	ROW1	LATB,RB4
#define	ROW2	LATB,RB5
#define	ROW3	LATB,RB6
#define	ROW4	LATB,RB7

#define	MAXIDX	.4

	code	H'00000'
	goto	start
;	org	H'08'
;	goto	isr_high
;	org	H'18'
;	goto	isr_low
;
	udata_acs
KeyReg	res	.1
idx	res	.1
row	res	.1
key	res	.1
dl_quet	res	.1

PRG	code
start
	rcall	init
main
	bsf	ROW1	;hoac ALLROW=B'11101111'
	bsf	ROW2
	bsf	ROW3
	bcf	ROW4
main1
	movf	ALLCOL,W
	movwf	LED
	bra	main1

init
	movlw	H'0F'	;Digital input
	movwf	ADCON1
	movlw	H'0F'	;Sinh vien xac dinh gia tri XX
	movwf	KEY_IO	;cau hinh keyboard
	clrf	LED_IO	
  	clrf	LED
	;khoi dong cac bien can thiet
	return

	end

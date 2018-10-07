	list 	p=PIC18f8722
	#include	P18F8722.INC
	extern	Adc_process

#define	AN0_IO	TRISA,RA0	;cong chon IO cho AN0
#define	AN1_IO	TRISA,RA1	;temperature sensor
	global	ad_res
	udata_acs
ad_res	res	.2
ad_temp	res	.1
AD_CFG0	equ	H'01'	;chon AN0, GO=0, ADON=1
;AD_CFG0	equ	H'05'	;chon AN1, GO=0, ADON=1
AD_CFG1	equ	H'0E'	;AN0=Analog
;AD_CFG1	equ	H'0D'	;AN1, AN0=Analog
AD_CFG2	equ	H'81'	;ADFM=0(left justified), CLK=FOSC/8

PRG	code
	global	Adc_init
Adc_init
	movlw	AD_CFG0	;chon kenh
	movwf	ADCON0
	movlw	AD_CFG1	;chon analog
	movwf	ADCON1
	movlw	AD_CFG2	;chon clock, chinh bien ket qua
	movwf	ADCON2
	bsf	AN0_IO
	bsf	RCON,IPEN		;chon ngat theo uu tien
	bsf	IPR1,ADIP		; ngat AD uu tien thap
	bcf	PIR1,ADIF
	bsf	PIE1,ADIE
	bsf	INTCON,GIEH	;cho phep ngat uu tien cao
	bsf	INTCON,GIEL	;cho phep ngat uu tien thap
	return
;---------------------------------
;Adc_go bat dau AD va cho doc ket qua
;---------------------------------
	global	Adc_go
Adc_go	bsf	ADCON0,GO		;GO=1, bat dau qua trinh AD
Adc_wait	btfsc	ADCON0,DONE	;cho DONE=0, AD xong
	bra	Adc_wait
	movf	ADRESH,W		;doc ket qua cao
	movwf	ad_res+1
	movf	ADRESL,W		;doc ket qua thap
	movwf	ad_res
	rcall	Adc_process
	return
;---------------------------------
;Adc_isr phuc vu ngat, AD tu dong
;---------------------------------
	global	Adc_isr
Adc_isr
	btfss	PIR1,ADIF
	return
	bcf	PIR1,ADIF
	movf	ADRESH,W
	movwf	ad_res+1
	movf	ADRESL,W
	movwf	ad_res
	rcall	Adc_process
	return
	end
		
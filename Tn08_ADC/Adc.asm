	list 	p=PIC18f8722
	#include	P18F8722.INC
	extern	Adc_process

#define	AN0_IO	TRISA,RA0	;cong chon IO cho AN0
	global	ad_res
	udata_acs
ad_res	res	.2

PRG	code
	global	Adc_init
AD_CFG0	equ	H'01'	;chon AN0, GO=0, ADON=1
AD_CFG1	equ	H'0E'	;AN0=Analog
AD_CFG2	equ	H'81'	;ADFM=1(right justified), CLK=FOSC/8
Adc_init
	movlw	AD_CFG0	;chon kenh
	movwf	ADCON0
	movlw	AD_CFG1	;chon analog
	movwf	ADCON1
	movlw	AD_CFG2	;chon clock, chinh bien ket qua
	movwf	ADCON2
	bsf	AN0_IO
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
		
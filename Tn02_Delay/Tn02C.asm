;=====================================;
; Name: Tn02.asm
; Project: Xuat so dem 8 bit ra led. 
; Thoi gian tang so dem la 500 ms.
; Author: CE-CSE-HCMUT
; Creation Date: 07/08/2014
;======================================;
		list		p=PIC18f8722
		#include 	p18f8722.inc
		CONFIG	OSC=HS,WDT=OFF,LVP=OFF

		#define	LED		LATD
		#define	LED_IO	TRISD
		#define	NUT		PORTA,RA5
		#define	NUT_IO	TRISA,RA5
		#define	PHAI		chieu,0
; Dau chuong trinh
		code		0
		goto		start
; Vung du lieu RAM
		udata_acs	
CANDUOI	equ		.1
CANTREN	equ		.5
dem		res		1
dem1a	res		1	
dem1b	res		1		
dem2		res		1
dem_ngoai	res		1
chieu	res		1
dem5s	res		1
; Vung bat dau code
PRG		code
start	rcall	init
; chuong trinh chinh
main		rcall	xuat_led
		rcall	delay500ms
		rcall	doichieu
		bra		main
;
doichieu	incf		dem5s
		movlw	.6
		cpfseq	dem5s
		return
		clrf		dem5s
		btg		PHAI
		return
		
		btfsc	NUT
		bra		main
		btg		PHAI
swoff	btfss	NUT
		bra		swoff
		bra		main		; lap lai sau moi nua giay
;
xuat_led	btfsc	PHAI
		bra		tangled
		rlncf	LED
		return
tangled	rrncf	LED
		return
;
giamdem	movlw	CANDUOI
		cpfseq	dem_ngoai
		bra		giamdem2
		movlw	CANTREN
		movwf	dem_ngoai
		return
giamdem2	decf		dem_ngoai
		return
; Ham khoi dong ban dau
init		movlw	H'0F'
		movwf	ADCON1
		bsf		NUT_IO
		clrf		LED_IO
		bcf		PHAI
		movlw	H'03'
		movwf	LED
		movlw	CANDUOI
		movwf	dem_ngoai
		clrf		dem5s
		return
; Ham lam tre 1000T
; Fosc=10MHz => T=4/Fosc=4/10.000.000=0.4µs 
delay
		movlw	.249
		movwf	dem
		nop
lap1		
		nop		
		decfsz	dem
		bra		lap1
		return	
; Ham lam tre 500ms = 1250 x 0.4µs = 5 x 250 x 0.4µs 
delay500ms	
		movf		dem_ngoai,W
		movwf	dem1a
lap2		movlw	.250	; bat dau vong lap ngoai (5 lan)
		movwf	dem1b
lap3		call		delay	; bat dau vong lap trong (250 lan)
		decfsz	dem1b
		bra 		lap3	; ket thuc vong lap trong
		decfsz	dem1a
		bra 		lap2	; ket thuc vong lap ngoai
		return
		end
	;t=1+1+5x(1+1+250x(2+1000)+249x(1+2)+2)+4x(1+2)+2+2=1256273
	;t=1+1+10x(1+1+125x(2+1000)+124x(1+2)+2)+9x(1+2)+2+2=1256266
	;t=1+1+10x(1+1+124x(2+1000)+123x(1+2)+2)+9x(1+2)+2+2=1246216
	;t=1+1+25x(1+1+50x(2+1000)+49x(1+2)+2)+24x(1+2)+2+2=1256353T=502.5412ms
	;t=1+1+250x(1+1+5x(2+1000)+4x(1+2)+2)+249x(1+2)+2+2=1257253
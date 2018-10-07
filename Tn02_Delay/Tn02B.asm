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
; Dau chuong trinh
		code		H'00000'
		goto		start
; Vung du lieu RAM
		udata_acs	
dem		res		.1
dem1a	res		.1	
dem1b	res		.1
chieu	res		.1
#define	TANG		chieu,0
; Vung bat dau code
PRG		code
start	rcall	init
; chuong trinh chinh
main		btfsc	NUT		;kiem tra nhan nut RA5
		bra		main
		btg		TANG		;doi chieu
		rcall	xuat_led	;tang/giam so dem tren LED
nha		btfss	NUT		;cho nha nut RA5
		bra		nha
		bra		main		; lap lai kiem tra nut RA5
; Ham khoi dong ban dau
init		movlw	H'0F'	;chon ngo nhap RA5 la digital
		movwf	ADCON1
		bsf		NUT_IO	;RA5 là ngo nhap
		clrf		LED_IO	;cong LED xuat
		clrf		LED		;tat het LED
		return
; Ham lam tre 1000T
; Fosc=10MHz => T=4/Fosc=4/10.000.000=0.4µs 
delay	movlw	.249
		movwf	dem
		nop
lap1		nop		
		decfsz	dem
		bra		lap1
		return	
; Ham lam tre 500ms = 1250 x 0.4µs = 5 x 250 x 0.4µs 
delay500ms	
		movf		dem_ngoai,W
		movwf	dem1a
lap2		movlw	.250		;bat dau vong lap ngoai (5 lan)
		movwf	dem1b
lap3		call		delay	;bat dau vong lap trong (250 lan)
		decfsz	dem1b
		bra 		lap3		;ket thuc vong lap trong
		decfsz	dem1a
		bra 		lap2		;ket thuc vong lap ngoai
		return
;Ham tang giam LED
xuat_led	btfsc	TANG		;co TANG=0 la giam so dem LED
		bra		tang_led	;co TANG=1, chuyen den tang so dem LED
giam_led	decf		LED
		bra		ket_thuc
tang_led	incf		LED
ket_thuc	rcall	delay500ms;lam tre nua giay
		return
		end

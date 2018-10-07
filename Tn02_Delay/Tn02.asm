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
		code		0
		goto		start
; Vung du lieu RAM
		udata_acs	
MINDEM	equ		1
MAXDEM	equ		5
dem		res		1
dem1a	res		1	
dem1b	res		1		
dem_ngoai	res		1
chieu	res		1
; Vung bat dau code
PRG		code
start	rcall	init
; chuong trinh chinh
main		incf		LED
		rcall	delay500ms
		bra		main		
; Ham khoi dong ban dau
init		;movlw	H'0F'
		;movwf	ADCON1
		clrf		LED_IO
		clrf		LED
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
		;movf		dem_ngoai,W	;1T
		movlw	.5		; 1T
		movwf	dem1a	; 1T
lap2		movlw	.250		; 5x(1T) bat dau vong lap ngoai (5 lan)
		movwf	dem1b	; 5x(1T)
lap3		call		delay	; 5x(250x2T) bat dau vong lap trong (250 lan)
		decfsz	dem1b	; 5x(249x1T+2T) 	
		bra 		lap3		; 5x(249x2T) ket thuc vong lap trong
		decfsz	dem1a	; 4x1T+2T
		bra 		lap2		; 4x2T ket thuc vong lap ngoai
		return			; 2T
		end
	;t=1+1+5x(1+1+250x(2+1000)+249x(1+2)+2)+4x(1+2)+2+2=1256273
	;t=1+1+10x(1+1+125x(2+1000)+124x(1+2)+2)+9x(1+2)+2+2=1256266
	;t=1+1+10x(1+1+124x(2+1000)+123x(1+2)+2)+9x(1+2)+2+2=1246216
	;t=1+1+25x(1+1+50x(2+1000)+49x(1+2)+2)+24x(1+2)+2+2=1256353T=502.5412ms
	;t=1+1+250x(1+1+5x(2+1000)+4x(1+2)+2)+249x(1+2)+2+2=1257253
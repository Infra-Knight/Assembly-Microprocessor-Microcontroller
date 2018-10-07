;===================================================
; Chuong trinh: IO port.
; Noi dung: Su dung nut nhan RA5 de thay doi LED hien thi.
;	Ban dau, hien thi gia tri H'XX' ra LED va cho nhan nut RA5.
;	Khi nhan RA5, tang gia tri hien ra LED len 1.
;	Khi nha RA5 khong lam gi ca.
;===================================================
		list 	p=PIC18F8722
		#include 	p18f8722.inc
		CONFIG	OSC = HS, WDT = OFF, LVP = OFF
		#define	LED		LATD
		#define	LED_IO	TRISD
		#define	NUT		PORTA,RA5
		#define	NUT_IO	TRISA,RA5
		code		H'00000'
		goto 	start
;vung dinh nghia du lieu (neu co)
		udata_acs
TRI_BD	equ		H'00'		;XX phai la so cu the
dem		equ		0

;vung dinh nghia cac chuong trinh con
PRG		code	
start	rcall	init		;khoi dong cac thanh ghi va bien trong RAM
;chuong trinh chinh
main		btfsc	NUT		;nut RA5 duoc nhan ?
		bra		main		;khong: tiep tuc cho nhan
		rcall	xuat_led	;co: goi chuong trinh con tang gia tri port LED 
swoff	btfss	NUT		;nha nut RA5 ?
		bra		swoff	; khong: tiep tuc cho nha
						; co: khong lam gi ca
		bra 		main		;Tro len kiem tra nhan RA5
;chuong trinh khoi dong ban dau
init		movlw	H'0F'
		movwf	ADCON1	;cau hinh RA5 là Digital (mac dinh la Analog)
		bsf		NUT_IO	;cau hinh nut RA5 la cong nhap
		clrf	LED_IO	;cau hinh LED la cong xuat
		movlw	TRI_BD	;TRI_BD vao WREG
		movwf	LED		;WREG ra LED
		return
; cac chuong trinh con khac (neu co)
xuat_led	decf		LED
		return
		end				; chi thi ket thuc module hop ngu

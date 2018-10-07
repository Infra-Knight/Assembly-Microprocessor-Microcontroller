;===================================================
; Chuong trinh: Interrupt.asm
; Noi dung: Su dung nut nhan RB0 qua INT0.
;===================================================
	list	p=PIC18F8722
	#include	p18f8722.inc
	CONFIG	OSC = HS, WDT = OFF, LVP = OFF
	#define	LED	LATD
	#define	LED_IO	TRISD
	#define	NUTRB0	PORTB,RB0
	#define	NUTRB0_IO	TRISB,RB0
	
	code	0
	goto	start
	org	0x08
	goto	isr_high
	org	0x18
	goto	isr_low
	
	udata_acs
MAXIDX	EQU	.4
dem	res	.1
dem1a	res	.1
dem1b	res	.1
idx	res	.1
buffer	res	MAXIDX

PRG	code
start	rcall	init
	rcall	int0_init
main	bra	main
;
init	movlw	H'0F'
	movwf	ADCON1
	bsf	NUTRB0_IO
	clrf	LED_IO
	clrf	idx
	rcall	xuat_led
	return
int0_init	bsf	RCON,IPEN		;cho phep uu tien
	bcf	INTCON,INT0IF	;xoa co ngat IF
	bsf	INTCON,INT0IE	;cho phep ngat
	bsf	INTCON,GIEH	;cho phep ngat uu tien cao
	return
xuat_led	movlw	upper dulieu	;nap dia chi dau bang vao
	movwf	TBLPTRU		;thanh ghi 21 bit TBLPTR
	movlw	high dulieu
	movwf	TBLPTRH
	movlw	low dulieu
	movwf	TBLPTRL
	movf	idx,W		;chi so cua du lieu
	incf	WREG
trabang	TBLRD*+			;vong lap doc bo qua cac
	decfsz	WREG		;byte dung truoc
	bra	trabang
	movf	TABLAT,W		;WREG=dulieu[idx]
	movwf	LED
	rcall	inc_idx		;dieu chinh chi so
	return
dulieu	db	H'55',H'AA',H'C3',H'3C'
inc_idx	incf	idx
	movlw	MAXIDX
	cpfslt	idx
	clrf	idx
	return
isr_high	bcf	INTCON,INT0IF
	rcall	xuat_led
	retfie
isr_low	
	retfie
	end
			
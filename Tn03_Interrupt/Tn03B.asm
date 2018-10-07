;Noi dung: su dung nut nhan RB0 va INT0
;Bat dau chuong trinh	
	list	p = PIC18F8722
	#include	p18f8722.inc
	CONFIG	OSC = HS, WDT = OFF, LVP = OFF
	#define 	LED	LATD
	#define	LED_IO	TRISD
	#define	NUTRB0 	PORTB, RB0
	#define	NUTRB0_IO	TRISB, RB0

	code	H'00000'
	goto	start
	org	0x08
	goto	isr_high
	org	0x18
	goto	isr_low
;Vung du lieu
	udata_acs
idx	res	.1
MAXIDX	equ	.4
buffer	res	MAXIDX
;Vung viet code
PRG	code
start	rcall	init
	rcall	int0_init
main	bra	main

;Ham khoi dong
init	movlw	H'0F'	
	movwf	ADCON1	
	bsf	NUTRB0_IO	
	clrf	LED_IO
	movlw	H'00'
	movwf	idx
	rcall	rom2ram
	return

;Ham rom2ram
rom2ram	movlw	upper	dulieu	;nhap dia chi dau bang vao
	movwf	TBLPTRU	;thanh ghi 21 bit TBLPTR
	movlw	high 	dulieu
	movwf	TBLPTRH	
	movlw	low 	dulieu
	movwf	TBLPTRL
	lfsr	FSR0,buffer	;dau bang RAM
	movlw	MAXIDX	;so byte can chep
chep	TBLRD*+		;vong lap doc bo qua cac file dung truoc
	movff	TABLAT,POSTINC0	;chep sang RAM
	decfsz	WREG
	bra 	chep	
	return

;Ham khoi dong ngat INT0
int0_init	bsf	RCON,IPEN	;cho phep uu tien
	bcf	INTCON,INT0IF	;xoa co ngat IF
	bsf	INTCON,INT0IE	;cho phep ngat
	bsf	INTCON,GIEH	;cho phep ngat uu tien cao
	return

;Ham kiem tra bang lay du lieu tu ROM xuat ra LED
xuat_led	movlw	upper	dulieu	;nhap dia chi dau bang vao
	movwf	TBLPTRU	;thanh ghi 21 bit TBLPTR
	movlw	high 	dulieu
	movwf	TBLPTRH	
	movlw	low 	dulieu
	movwf	TBLPTRL	
	movf	idx,W	;chi so cua du lieu
	incf	WREG
trabang	TBLRD*+		;vong lap doc bo qua cac file dung truoc
	decfsz	WREG
	bra 	trabang
	movf	TABLAT,W	;WREG = dulieu[idx]
	movwf	LED
	rcall	inc_idx	;dieu chinh chi so
	return
dulieu	db	H'55',H'AA',H'C3',H'3C'

;Ham tang chi so bang
inc_idx	incf	idx
	movlw	MAXIDX
	cpfslt	idx
	clrf	idx
	return
;Ham phuc vu ngat uu tien cao
isr_high	bcf	INTCON,INT0IF
	rcall	xuat_led2
	retfie	
;Ham phuc vu ngat uu tien thap
isr_low	retfie

;Ham xuat_led2 lay du RAM
xuat_led2	lfsr	FSR1,buffer	;dau bang RAM
	movf	idx,W	;chi so cua du lieu
	movf	PLUSW1,W	;lay du lieu buffer[idx]
	movwf	LED
	rcall	inc_idx	;dieu chinh chi so
	return

	end	 	
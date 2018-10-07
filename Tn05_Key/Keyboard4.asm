	list	p=PIC18f8722
	#include	p18f8722.inc
	#include	"Timer.inc"
	#include	"PIC18Lcd.inc"
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

#define	FLAG_1S	flags,0
#define	FLAG_KBD	flags,1

	code	H'00000'
	goto	start
	org	H'08'
	goto	isr_high
	org	H'18'
	goto	isr_low

	udata_acs
MAXIDX	equ	.4
#define	MAXROW	.2
#define	MAXCOL	.16
#define	SODEM1S	.5
KEY_NUMBER equ	.15
row_idx	res	.1
old_code	res	.1
key_code	res	.1
key	res	.1	
scan_code	res	.1
flags	res	.1
row	res	.1
col	res	.1
char2	res	.1
dem	res	.1
PRG	code
start
	rcall	init
	rcall	Lcd_init
	rcall	Timer0_init
	rcall	Intro
main
	btfss	FLAG_1S
	bra	main1
	bcf	INTCON,GIEH
	bcf	FLAG_1S
	bsf	INTCON,GIEH
	rcall	Sec_process
main1	btfss	FLAG_KBD
	bra	main
	bcf	INTCON,GIEH
	bcf	FLAG_KBD
	bsf	INTCON,GIEH
	rcall	Key_process	;xu ly phim nhan
	bra	main
lcd_move
	incf	col
	movlw	MAXCOL
	cpfslt	col
	clrf	col
	return
init
	movlw	H'0F'
	movwf	KEY_IO
	movlw	H'0F'
	movwf	ADCON1
	setf	ALLROW
	clrf	row_idx
	setf	key_code
	movlw	'O'
	movwf	char2
	movlw	SODEM1S
	movwf	dem
	return
;
s1	data		"Keyboard test:",0
Intro	gotoxy	0,0
	putsrom	s1
	movlw	1
	movwf	row
	clrf	col
	return
;---------------------------------------
;Xu ly phim nhan
;---------------------------------------
Sec_process
	gotovxy	row,col
	putmch	char2
	incf	col
	movlw	.5
	cpfseq	col
	bra	key_p1
	clrf	col
	movlw	'O'
	cpfseq	char2
	bra	key_p2
	movlw	'o'
key_p2	movwf	char2
key_p1	return
;Xu ly phim
Key_process
	movlw	KEY_NUMBER
	cpfseq	key_code
	bra	Key_p1
Lcd_reset	rcall	Lcd_cls
	rcall	Intro
	movf	key_code,W
	iorlw	H'F0'
	bra	Key_end
Key_p1	gotoxy	.1,.13
	putmb	key_code
	movf	key_code,W
Key_end	movwf	LED
	return		

;---------------------------------------
;Doc du lieu cot, phat hien phim
;---------------------------------------
Getkey	
	movf	ALLCOL,W
	movwf	key
	movf	key_code,W
	movwf	old_code
	clrf	key_code
	btfss	key,0		; kiem tra cot 1
	bra	Getkeyend
	incf	key_code		; kiem tra cot 2
	btfss	key,1
	bra	Getkeyend
	incf	key_code		; kiem tra cot 3
	btfss	key,2
	bra	Getkeyend
	incf	key_code		; kiem tra cot 4
	btfss	key,3
	bra	Getkeyend
	setf	key_code		; khong nhan, key_code=H'FF'
	return
Getkeyend
	movf	row_idx,W
	rlncf	WREG			;row_idx X 4
	rlncf	WREG
	addwf	key_code
	return
		
;---------------------------------------		
;Scan keyboard, detect pressed key
;---------------------------------------
GetScancode0
	movf	row_idx,W
	incf	WREG
	dcfsnz	WREG
	bra	getrow1
	dcfsnz	WREG
	bra	getrow2
	dcfsnz	WREG
	bra	getrow3
getrow4	movlw	B'01111111'
	bra	getend
getrow3	movlw	B'10111111'
	bra	getend
getrow2	movlw	B'11011111'
	bra	getend
getrow1	movlw	B'11101111'
getend	movwf	scan_code
	return
GetScancode
	movlw	B'11101111'
	movwf	scan_code
	movf	row_idx,W
	incf	WREG
gets1	dcfsnz	WREG
	bra	gets2
	rlncf	scan_code
	bra	gets1
gets2	movf	scan_code,W
	return
;---------------------------------------		
;increment row index
;---------------------------------------
Inc_rowidx
	incf	row_idx		;tang chi so
	movlw	MAXIDX
	cpfslt	row_idx		;neu row_idx=MAXIDX cho ve 0
	clrf	row_idx
	return
;---------------------------------------		
;Scan keyboard, detect pressed key
;---------------------------------------
	global	Timer_process
Timer_process
	decfsz	dem
	bra	t_proc1
	bsf	FLAG_1S
	movlw	SODEM1S
	movwf	dem
t_proc1
	rcall	GetScancode
	movwf	ALLROW		;quet hang tuy theo row_idx
;kiem tra cot
	rcall 	Getkey		;doc du lieu cot, tinh key_code
	rcall	Inc_rowidx
	incf	key_code,W
	tstfsz	WREG			;=0:khong co phim nhan
	bsf	FLAG_KBD
	return	
;chuong trinh phuc vu ngat
isr_high
	retfie
isr_low	rcall	Timer0_isr
	retfie
	end

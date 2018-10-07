		list		p=PIC18f8722
		#include	p18f8722.inc
		#include	"Timer.inc"
		CONFIG	OSC = HS, WDT = OFF, LVP = OFF

#define	LED		LATD
#define	LED_IO	TRISD
#define	KEY_IO	TRISB
#define	ALLCOL	PORTB
#define	ALLROW	LATB

#define	COL1		PORTB,RB0
#define	COL2		PORTB,RB1
#define	COL3		PORTB,RB2
#define	COL4		PORTB,RB3
#define	ROW1		LATB,RB4
#define	ROW2		LATB,RB5
#define	ROW3		LATB,RB6
#define	ROW4		LATB,RB7

#define	MAXIDX	.4

		code		H'00000'
		goto		start
		org		H'08'
		goto		isr_high
		org		H'18'
		goto		isr_low

		udata_acs
row_idx	res		.1
;col_idx	res		.1
key_code	res		.1
key		res		.1	
scan_code	res		.1
temp		res		.1
PRG		code
start
		rcall	init
		rcall	Timer0_init
main
		bra		main

init
		clrf		LED_IO
	  	clrf		LED
		movlw	H'0F'
		movwf	KEY_IO
		movlw	H'0F'
		movwf	ADCON1
		setf		ALLROW
		clrf		row_idx
		setf		key_code
		return

;---------------------------------------
;Xu ly phim nhan
;---------------------------------------
Key_process
		movf		key_code,W
		movwf	LED
		return

;---------------------------------------
;Doc du lieu cot, phat hien phim
;---------------------------------------
GET_KEY	
		movf		ALLCOL,W
		movwf	key
		movlw	.0
		movwf	key_code
; test col1
		btfss	key,0
		bra		EXIT_GET_KEY
; test col2
		incf		key_code
		btfss	key,1
		bra		EXIT_GET_KEY
; test col3
		incf		key_code
		btfss	key,2
		bra		EXIT_GET_KEY
; test col4
		incf		key_code
		btfss	key,3
		bra		EXIT_GET_KEY
; no keypress, key_code=H'FF'
		setf		key_code
		return
EXIT_GET_KEY
		movf		temp,W
		addwf	key_code,F
		return
;---------------------------------------		
;Scan keyboard, detect pressed key
;---------------------------------------
		global	Timer_process
Timer_process
		setf		ALLROW
		movlw	B'11110111'
		movwf	scan_code
		movf		row_idx,W
		movwf	temp
		rlncf	temp			;nhan 2
		rlncf	temp			;nhan 4
		incf		WREG
scan_b1	rlncf	scan_code
		decfsz	WREG
		bra		scan_b1
Scan_Row	
		movf		scan_code,W	;quet theo chi so
		movwf	ALLROW
		incf		row_idx		;tang chi so
		movlw	MAXIDX
		cpfslt	row_idx			;idx=0-(MAXIDX-1)
		clrf		row_idx
;kiem tra cot
		rcall 	GET_KEY		;doc du lieu cot, phat hien phim
Scan_button1
		incf		key_code,W
		tstfsz	WREG			;=0:khong co phim nhan
		rcall	Key_process	;xu ly phim nhan
EXIT_SCAN_BUTTON
		return	
;chuong trinh phuc vu ngat
isr_high
		retfie
isr_low	rcall	Timer0_isr
		retfie
	end

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

		code		H'00000'
		goto		start
		org		H'08'
		goto		isr_high
		org		H'18'
		goto		isr_low

		udata_acs
MAXIDX	equ		.4
row_idx	res		.1
key_code	res		.1
key		res		.1	
KEY_NUMBER equ		.9
scan_code	res		.1
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
		movlw	KEY_NUMBER
		cpfseq	key_code
		bra		Key_p1
		movf		key_code,W
		iorlw	H'F0'
		bra		Key_end
Key_p1	movf		key_code,W
Key_end	movwf	LED
		return
;---------------------------------------
;Doc du lieu cot, phat hien phim
;---------------------------------------
Getkey	
		movf		ALLCOL,W
		movwf	key
		clrf		key_code
		btfss	key,0		; kiem tra cot 1
		bra		Getkeyend
		incf		key_code		; kiem tra cot 2
		btfss	key,1
		bra		Getkeyend
		incf		key_code		; kiem tra cot 3
		btfss	key,2
		bra		Getkeyend
		incf		key_code		; kiem tra cot 4
		btfss	key,3
		bra		Getkeyend
		setf		key_code		; khong nhan, key_code=H'FF'
		return
Getkeyend
		movf		row_idx,W
		rlncf	WREG			;row_idx X 4
		rlncf	WREG
		addwf	key_code
		return
		
;---------------------------------------		
;Scan keyboard, detect pressed key
;---------------------------------------
GetScancode
		movf		row_idx,W
		incf		WREG
		dcfsnz	WREG
		bra		getrow1
		dcfsnz	WREG
		bra		getrow2
		dcfsnz	WREG
		bra		getrow3
getrow4	movlw	B'01111111'
		bra		getend
getrow3	movlw	B'10111111'
		bra		getend
getrow2	movlw	B'11011111'
		bra		getend
getrow1	movlw	B'11101111'
getend	movwf	scan_code
		return
;---------------------------------------		
;Scan keyboard, detect pressed key
;---------------------------------------
		global	Timer_process
Timer_process
		rcall	GetScancode
		movwf	ALLROW
;kiem tra cot
		rcall 	Getkey		;doc du lieu cot, tinh key_code
		incf		row_idx		;tang chi so
		movlw	MAXIDX
		cpfslt	row_idx		;neu row_idx=MAXIDX cho ve 0
		clrf		row_idx
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

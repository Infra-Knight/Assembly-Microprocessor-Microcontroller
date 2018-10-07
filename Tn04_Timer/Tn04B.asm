;===========================================;
; Khoi dong Timer0 dem 16 bit.
; De tinh thoi khoan tao ra boi Timer0, ta can biet mot so diem
; 	1. Tan so xung clock ngoai:		FOSC=10Mhz
; 	2. Thang dem truoc (prescaler):	prescaler=2
; 	3. So dem: 					n=12500
; thoi gian tao ra ngat tu Timer0:		t = (1/(FOSC/4))*prescaler*n
;			        		  		  = 10 ms
;===========================================;
		list 	p=PIC18f8722 
		#include 	P18F8722.INC
		CONFIG	OSC = HS, WDT = OFF, LVP = OFF

		#include	"Timer.inc"
		#include	"PIC18Lcd.inc"

		#define	LED		LATD
		#define	LED_IO	TRISD
SODEM2S	equ		.200
SODEM1S	equ		.10
SODEMP5S	equ		.20
MAXROW	equ		.2
MAXCOL	equ		.16
		
		code		0
		goto		start
		org		H'08'
		goto		isr_high
		org		H'18'
		goto		isr_low

		#define	FLAG_1S	flags,0		
		udata_acs
dem		res		.1
flags	res		.1
row		res		.1
col		res		.1
char		res		.1
		


PRG		code
;main program
start	rcall	init
		rcall	Lcd_init
		rcall	Timer0_init
main		btfss	FLAG_1S
		bra		main
		bcf		INTCON,GIEH
		bcf		FLAG_1S
		bsf		INTCON,GIEH
		movf		char,W
		movwf	LED
		putmch	char
main1	incf		char
		incf		col
		movlw	MAXCOL
		cpfseq	col
		bra		main		
		clrf		col
		incf		row
		movlw	MAXROW
		cpfslt	row
		clrf		row
		gotovxy	row,col
		bra		main
;
init		movlw	H'0F'
		movwf	ADCON1
		clrf		LED_IO
		clrf		row
		clrf		col
		clrf		char
		movlw	SODEMP5S
		movwf	dem
		movlw	.1
		movwf	LED
		bcf		FLAG_1S
		return
;Ham lam tre n lan 10ms	
Delay1s	movlw	SODEM1S
		movwf	dem
Dl1s1	tstfsz	dem
		bra		Dl1s1
		return
;Chuong trinh xu ly dinh ky cua Timer (10ms/lan)	
		global	Timer_process
Timer_process
		decfsz	dem		;neu dem>0 moi giam
		return
		bsf		FLAG_1S
		movlw	SODEM1S
		movwf	dem
		return
;Phuc vu ngat uu tien thap	
isr_low	rcall	Timer0_isr
		retfie

isr_high
		retfie
Chuoi	data	"Minh",0
	end

;************************************************************************
;*	Module PIC18Lcd.asm: PICDEM PIC18 LCD interface.		  *
;*	Author: Nguyen Xuan Minh, CE-CSE-HCMUT-VNU			  *
;*	Filenames: 						  *
;*	PIC18Lcd.asm (functions) 				  *
;*	PIC18Lcd.inc (extern, MACRO)   			  *
;*	Update: April 1 ,2016					  *
;************************************************************************
	extern	Lcd_init,Lcd_cls,Lcd_gotoxy,Lcd_putc,Lcd_puth
	extern	Lcd_putrom,Lcd_putram,Lcd_putb,Lcd_putw
	extern	lcd_wr,lcd_row,lcd_col
	extern	bcd2d,bcd2p,Div1024
;Xoa man hinh
cls	MACRO
	rcall	Lcd_cls
	ENDM
;doi so bcd ra ascii 2 so
mputbcd2	MACRO	mem,buffer
	movf	mem,W
	lfsr	FSR0,buffer
	rcall	bcd2d
	ENDM
;Xuat ky tu
putch	MACRO	char
	movlw	char
	movwf	lcd_wr
	rcall	Lcd_putc
	ENDM
;Xuat so 1 byte ra he 10 co 3 so	
putb	MACRO	char
	movlw	char
	rcall	Lcd_putb
	ENDM
;Xuat so 16 bit ra he 10 co 5 so
putw	MACRO	word
	movlw	high word
	movwf	PRODH
	movlw	low word
	movwf	PRODL
	rcall	Lcd_putw
	ENDM
;Xuat bien 2 byte trong RAM ra he 10 co 5 so
putmw	MACRO	ramword
	movf	ramword+1,W
	movwf	PRODH
	movf	ramword,W
	movwf	PRODL
	rcall	Lcd_putw
	ENDM
;Xuat so 1 byte ra he 16 co 2 so
puth	MACRO	char
	movlw	char
	rcall	Lcd_puth
	ENDM
;Xuat 1 bien ky tu
putmch	MACRO	ramvar
	movf	ramvar,W
	movwf	lcd_wr
	rcall	Lcd_putc
	ENDM
;Xuat bien 1 byte ra he 10 co 3 so	
putmb	MACRO	ramvar
	movf	ramvar,W
	rcall	Lcd_putb
	ENDM
;Xuat bien 1 byte ra he 16 co 2 so
putmh	MACRO	ramvar
	movf	ramvar,W
	rcall	Lcd_puth
	ENDM
;Xuat chuoi ASCIIZ trong ROM
putsrom	MACRO	romstr
	movlw	upper romstr
	movwf	TBLPTRU
	movlw	high romstr
	movwf	TBLPTRH
	movlw	low romstr
	movwf	TBLPTRL
	rcall	Lcd_putrom
	ENDM
;Xuat chuoi ASCIIZ trong RAM
putsram	MACRO	ramstr
	lfsr	FSR1,ramstr
	rcall	Lcd_putram
	ENDM
;Dinh vi theo bien	
gotovxy	MACRO	vrow,vcol
	movf	vrow,W
	movwf	lcd_row
	movf	vcol,W
	movwf	lcd_col
	rcall	Lcd_gotoxy
	ENDM
;Dinh vi theo hang so
gotoxy	MACRO	crow,ccol
	movlw	crow
	movwf	lcd_row
	movlw	ccol
	movwf	lcd_col
	rcall	Lcd_gotoxy
	ENDM

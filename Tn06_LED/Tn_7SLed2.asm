	list 	p=PIC18F8722
	#include 	p18f8722.inc
	CONFIG	OSC=HS, WDT=OFF, LVP=OFF
	#include	"Timer.inc"
		
#define	SELECT	LATB
#define	SELECT_IO	TRISB
#define	SMENT	LATD
#define	SMENT_IO	TRISD
#define	NUT	PORTA,RA5
#define	NUT_IO	TRISA,RA5
	code	H'00000'
	goto	start
	org	H'08'
	goto	isr_high
	org	H'18'
	goto	isr_low
	udata_acs
MAXIDX	equ	.8
sbuff	res	.8
idx	res	.1
ledsel	res	.1
ANI_TIME	equ	.100
ani_cou	res	.1
count	res	.1
flag	res	.1
#define	FLAG_RL	flag,0
gm_tam	res	.1
temp	res	.1
dem	res	.1

PRG	code
start	rcall	init
	rcall	Timer0_init
main	btfsc	NUT	
	bra	main
	btg	FLAG_RL	;doi chieu quay
nha1	btfss	NUT
	bra	nha1
	bra	main
;
init	movlw	H'0F'
	movwf	ADCON1
	bsf	NUT_IO
	clrf	SELECT_IO
	clrf	SMENT_IO
	clrf	SELECT
	clrf	idx
	rcall	rom2ram
	movlw	H'80'
	movwf	ledsel
	movlw	ANI_TIME
	movwf	ani_cou
	clrf	flag
	return
;	
rom2ram	movlw	upper dulieu
	movwf	TBLPTRU
	movlw	high dulieu
	movwf	TBLPTRH
	movlw	low dulieu
	movwf	TBLPTRL
	lfsr	FSR0,sbuff
	movlw	MAXIDX
	movwf	count
chep1	TBLRD*+
	movf	TABLAT,W
	movwf	POSTINC0
	decfsz	count
	bra	chep1
	return
dulieu	data	"     123"
;Quay trai buffer RAM
rlbuff	lfsr	FSR0,sbuff
	lfsr	FSR1,sbuff+1
	movf	INDF0,W
	movwf	temp
	movlw	MAXIDX-1
	movwf	dem
rlb1	movf	POSTINC1,W
	movwf	POSTINC0
	decfsz	dem
	bra	rlb1
	movf	temp,W
	movwf	INDF0
	return
;Quay phai buffer RAM	
rrbuff	lfsr	FSR0,sbuff+7
	lfsr	FSR1,sbuff+6
	movf	INDF0,W
	movwf	temp
	movlw	MAXIDX-1
	movwf	dem
rrb1	movf	POSTDEC1,W
	movwf	POSTDEC0
	decfsz	dem
	bra	rrb1
	movf	temp,W
	movwf	INDF0
	return
xuat_led
	clrf	SELECT
	lfsr	FSR1,sbuff
	movf	idx,W
	movf	PLUSW1,W
	rcall	gm_7doan
	movwf	SMENT
	movf	ledsel,W
	movwf	SELECT
	rrncf	ledsel
	incf	idx
	movlw	MAXIDX
	cpfslt	idx
	clrf	idx
	return
;Giai ma 7 doan co kiem tra ky tu BLANK
gm_7doan	movwf	TBLPTRL
	movlw	' '
	cpfseq	TBLPTRL
	bra	gm_1
	clrf	WREG
	return
gm_1	movlw	H'0F'
	andwf	TBLPTRL		
	movlw	low Bang_7s
	addwf	TBLPTRL
	movlw	high Bang_7s
	movwf	TBLPTRH
	clrf	WREG
	addwfc	TBLPTRH
	movlw	upper Bang_7s
	movwf	TBLPTRU
	TBLRD*
	movf	TABLAT,W
	return
Bang_7s	db	H'3F',H'06',H'5B',H'4F',H'66',H'6D',H'7D',H'07'
	db	H'7F',H'6F',H'77',H'7C',H'39',H'5E',H'79',H'71'
;Xu ly dinh thi
	global	Timer_process
Timer_process
	rcall	xuat_led
	decfsz	ani_cou
	return
	movlw	ANI_TIME
	movwf	ani_cou
	btfsc	FLAG_RL
	bra	rotate_l
	rcall	rrbuff	;quay phai buffer RAM
	return
rotate_l	rcall	rlbuff	;quay trai buffer RAM
	return
isr_high	retfie
isr_low
	rcall	Timer0_isr
	retfie
	end

	
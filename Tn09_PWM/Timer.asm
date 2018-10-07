	list 	p=PIC18f8722
	#include	p18f8722.INC


FOSC	EQU	.10
DEM40MC	EQU	(.10*.4/FOSC)
DEM50MC	EQU	(.13*.4/FOSC)
DEM100MC	EQU	(.25*.4/FOSC)

T0_COUNT	EQU	(-.125)*FOSC

DEM1MS	EQU	.1
DEM2MS	EQU	.2
DEM5MS	EQU	.5
DEM10MS	EQU	.10
DEM30MS	EQU	.30
DEM40MS	EQU	.40
DEM100MS	EQU	.100
DEM1S	EQU	.10
DEM5S	EQU	.50

Timer_D	udata
dem_mc	res	.1
dem_ms	res	.1
dem_s	res	.1

Timer_M	CODE
	global	t0_init
	global	t0_load
t0_load
	bcf	INTCON,TMR0IF
	bcf	T0CON,TMR0ON
	movlw	high T0_COUNT
	movwf	TMR0H
	movlw	low  T0_COUNT
	movwf	TMR0L
	bsf	T0CON,TMR0ON
	return
t0_init
	bsf	RCON,IPEN		;enable priority interrupts.
	bsf	INTCON2,TMR0IP	;select high/low priority for timer0
	bsf	INTCON,TMR0IE
	bsf	INTCON,GIEH		;enable the high priority interrupts
	bsf	INTCON,GIEL		;enable the low priority interrupts
	clrf	T0CON
	rcall	t0_load
	return

	global	t0_time
t0_time	tstfsz	dem_ms
	decf	dem_ms
	return
	
	global	Delay40mc,Delay50mc,Delay100mc
Delay40mc
	movlw	DEM40MC
	bra	Delaymc_end
Delay50mc
	movlw	DEM50MC
	bra	Delaymc_end
Delay100mc
	movlw	DEM100MC
	bra	Delaymc_end
Delaymc_end
	movwf	dem_mc
tdelayXmc_1
	nop
	decfsz	dem_mc
	bra	tdelayXmc_1
	return
	
	global	Delay1ms,Delay2ms,Delay5ms,Delay10ms,Delay30ms,Delay40ms,Delay100ms
Delay1ms
	movlw	DEM1MS
	bra	Delayms_end
Delay2ms
	movlw	DEM2MS
	bra	Delayms_end
Delay5ms
	movlw	DEM5MS
	bra	Delayms_end
Delay10ms
	movlw	DEM10MS
	bra	Delayms_end
Delay30ms
	movlw	DEM30MS
	bra	Delayms_end
Delay40ms
	movlw	DEM40MS
	bra	Delayms_end
Delay100ms
	movlw	DEM100MS
Delayms_end
DelayXms	;delay X times Delay1ms
	movwf	dem_ms
delayXms_1	
	tstfsz	dem_ms
	bra	delayXms_1
	return

	global	Delay1s,Delay5s
Delay1s
	movlw	DEM1S
	bra	DelayXs_end
Delay5s
	movlw	DEM5S
DelayXs_end
DelayXs		;delay Xs 
	movwf	dem_s
delayXs_1	
	rcall	Delay100ms
	decfsz	dem_s
	bra	delayXs_1
	return
	end
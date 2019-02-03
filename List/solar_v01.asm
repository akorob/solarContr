
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATtiny10
;Program type             : Application
;Clock frequency          : 1,000000 MHz
;Memory model             : Tiny
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 8 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;'auto' var. watch in AVR Studio: Off

	#pragma AVRPART ADMIN PART_NAME ATtiny10
	#pragma AVRPART CORE CORE_VERSION AVR8L_0
	#pragma AVRPART MEMORY PROG_FLASH 1024
	#pragma AVRPART MEMORY EEPROM 0
	#pragma AVRPART MEMORY INT_SRAM SIZE 95
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x40

	.LISTMAC
	.EQU WDTCSR=0x31
	.EQU SMCR=0x3A
	.EQU RSTFLR=0x3B
	.EQU CCP=0x3C
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0040
	.EQU __SRAM_END=0x005F
	.EQU __DSTACK_SIZE=0x0008
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SUBI R24,1
	SBCI R25,0
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETBRS
	SUBI R28,-@1
	LD   R@0,Y
	.ENDM

	.MACRO __PUTBSR
	SUBI R28,-@1
	ST   Y,R@0
	.ENDM

	.MACRO __GETWRS
	SUBI R28,-@2
	LD   R@0,Y+
	LD   R@1,Y
	.ENDM

	.MACRO __PUTWSR
	SUBI R28,-@2
	ST   Y+,R@0
	ST   Y,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	SUBI R26,LOW(-@0-1)
	LDI  R27,0
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LD   R26,Y
	SUBI R26,-@0
	LDI  R27,0
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LD   R26,Y
	SUBI R26,-@0
	LDI  R27,0
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LD   R26,Y
	SUBI R26,-@0
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LD   R26,Y
	SUBI R26,-@0
	LDI  R27,0
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LD   R26,Y
	SUBI R26,-@0
	LDI  R27,0
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LD   R26,Y
	SUBI R26,-@0
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	LDI  R27,0
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	LDI  R27,0
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	LDI  R27,0
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	LDI  R27,0
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	LDI  R27,0
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	LDI  R27,0
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	LDI  R27,0
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	LDI  R27,0
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

__RESET:
	CLI
	CLR  R30

;DISABLE WATCHDOG
	LDI  R31,0xD8
	WDR
	IN   R26,RSTFLR
	CBR  R26,8
	OUT  RSTFLR,R26
	OUT  CCP,R31
	OUT  WDTCSR,R30

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x48

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Evaluation
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 09.09.2013
;Author  : Freeware, for evaluation and non-commercial use only
;Company :
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 1,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;
;#define ADC_VREF_TYPE 0x40
;
;#define seg_a PORTB.2
;#define seg_b PORTB.0
;#define seg_c PORTD.5
;#define seg_d PORTD.7
;#define seg_e PORTB.6
;#define seg_f PORTB.1
;#define seg_g PORTB.7
;#define seg_h PORTD.6
;#define com_cat1 PORTB.4
;#define com_cat2 PORTB.5
;#define com_cat3 PORTB.3
;
;void set_leds (char digit, char pos, char comma);
;unsigned int read_adc(unsigned char adc_input);
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 002F {

	.CSEG
; 0000 0030 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
; 0000 0031 // Delay needed for the stabilization of the ADC input voltage
; 0000 0032 delay_us(10);
; 0000 0033 // Start the AD conversion
; 0000 0034 ADCSRA|=0x40;
; 0000 0035 // Wait for the AD conversion to complete
; 0000 0036 while ((ADCSRA & 0x10)==0);
; 0000 0037 ADCSRA|=0x10;
; 0000 0038 return ADCW;
; 0000 0039 }
;
;void set_leds (char digit, char pos, char comma){
; 0000 003B void set_leds (char digit, char pos, char comma){
_set_leds:
; 0000 003C switch (pos){
;	digit -> Y+2
;	pos -> Y+1
;	comma -> Y+0
	SUBI R28,-1
	LD   R30,Y
	LDI  R31,0
	SUBI R28,1
; 0000 003D case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x9
; 0000 003E com_cat1=1; com_cat2=0; com_cat3=0;
	SBI  0x18,4
	CBI  0x18,5
	CBI  0x18,3
; 0000 003F break;
	RJMP _0x8
; 0000 0040 
; 0000 0041 case 2:
_0x9:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x10
; 0000 0042 com_cat1=0; com_cat2=1; com_cat3=0;
	CBI  0x18,4
	SBI  0x18,5
	CBI  0x18,3
; 0000 0043 break;
	RJMP _0x8
; 0000 0044 
; 0000 0045 case 3:
_0x10:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x8
; 0000 0046 com_cat1=0; com_cat2=0; com_cat3=1;
	CBI  0x18,4
	CBI  0x18,5
	SBI  0x18,3
; 0000 0047 break;
; 0000 0048     }
_0x8:
; 0000 0049 
; 0000 004A if (comma==1) seg_h=1; else seg_h=0;
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x1E
	SBI  0x12,6
	RJMP _0x21
_0x1E:
	CBI  0x12,6
; 0000 004B 
; 0000 004C 
; 0000 004D 
; 0000 004E switch (digit){
_0x21:
	SUBI R28,-2
	LD   R30,Y
	LDI  R31,0
	SUBI R28,2
; 0000 004F case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x27
; 0000 0050 seg_a=0; seg_b=1; seg_c=1; seg_d=0; seg_e=0; seg_f=0; seg_g=0;
	CBI  0x18,2
	SBI  0x18,0
	SBI  0x12,5
	CBI  0x12,7
	CBI  0x18,6
	CBI  0x18,1
	CBI  0x18,7
; 0000 0051 break;
	RJMP _0x26
; 0000 0052 case 2:
_0x27:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x36
; 0000 0053 seg_a=1; seg_b=1; seg_c=0; seg_d=1; seg_e=1; seg_f=0; seg_g=1 ;
	SBI  0x18,2
	SBI  0x18,0
	CBI  0x12,5
	SBI  0x12,7
	SBI  0x18,6
	CBI  0x18,1
	SBI  0x18,7
; 0000 0054 break;
	RJMP _0x26
; 0000 0055 case 3:
_0x36:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x45
; 0000 0056 seg_a=1; seg_b=1; seg_c=1; seg_d=1; seg_e=0; seg_f=0; seg_g=1;
	SBI  0x18,2
	SBI  0x18,0
	SBI  0x12,5
	SBI  0x12,7
	CBI  0x18,6
	CBI  0x18,1
	SBI  0x18,7
; 0000 0057 break;
	RJMP _0x26
; 0000 0058 case 4:
_0x45:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x54
; 0000 0059 seg_a=0; seg_b=0; seg_c=0; seg_d=0; seg_e=0; seg_f=0; seg_g=0;
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x12,5
	CBI  0x12,7
	CBI  0x18,6
	CBI  0x18,1
	CBI  0x18,7
; 0000 005A break;
	RJMP _0x26
; 0000 005B case 5:
_0x54:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x63
; 0000 005C seg_a=0; seg_b=1; seg_c=1; seg_d=0; seg_e=0; seg_f=1; seg_g=1;
	CBI  0x18,2
	SBI  0x18,0
	SBI  0x12,5
	CBI  0x12,7
	CBI  0x18,6
	SBI  0x18,1
	SBI  0x18,7
; 0000 005D break;
	RJMP _0x26
; 0000 005E case 6:
_0x63:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x72
; 0000 005F seg_a=1; seg_b=0; seg_c=1; seg_d=1; seg_e=1; seg_f=1; seg_g=1;
	SBI  0x18,2
	CBI  0x18,0
	SBI  0x12,5
	SBI  0x12,7
	SBI  0x18,6
	SBI  0x18,1
	SBI  0x18,7
; 0000 0060 break;
	RJMP _0x26
; 0000 0061 case 7:
_0x72:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x81
; 0000 0062 seg_a=1; seg_b=1; seg_c=1; seg_d=0; seg_e=0; seg_f=0; seg_g=0;
	SBI  0x18,2
	SBI  0x18,0
	SBI  0x12,5
	CBI  0x12,7
	CBI  0x18,6
	CBI  0x18,1
	CBI  0x18,7
; 0000 0063 break;
	RJMP _0x26
; 0000 0064 case 8:
_0x81:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x90
; 0000 0065 seg_a=1; seg_b=1; seg_c=1; seg_d=1; seg_e=1; seg_f=1; seg_g=1;
	SBI  0x18,2
	SBI  0x18,0
	SBI  0x12,5
	SBI  0x12,7
	SBI  0x18,6
	SBI  0x18,1
	SBI  0x18,7
; 0000 0066 break;
	RJMP _0x26
; 0000 0067 case 9:
_0x90:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x9F
; 0000 0068 seg_a=1; seg_b=1; seg_c=1; seg_d=1; seg_e=0; seg_f=1; seg_g=1;
	SBI  0x18,2
	SBI  0x18,0
	SBI  0x12,5
	SBI  0x12,7
	CBI  0x18,6
	SBI  0x18,1
	SBI  0x18,7
; 0000 0069 break;
	RJMP _0x26
; 0000 006A case 0:
_0x9F:
	SUBI R30,0
	SBCI R31,0
	BRNE _0x26
; 0000 006B seg_a=1; seg_b=1; seg_c=1; seg_d=1; seg_e=1; seg_f=1; seg_g=0;
	SBI  0x18,2
	SBI  0x18,0
	SBI  0x12,5
	SBI  0x12,7
	SBI  0x18,6
	SBI  0x18,1
	CBI  0x18,7
; 0000 006C break;
; 0000 006D 
; 0000 006E 
; 0000 006F }
_0x26:
; 0000 0070 
; 0000 0071 }
	SUBI R28,-3
	RET
;
;
;// Declare your global variables here
;
;
;void main(void)
; 0000 0078 {
_main:
; 0000 0079 // Declare your local variables here
; 0000 007A 
; 0000 007B // Input/Output Ports initialization
; 0000 007C // Port B initialization
; 0000 007D // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 007E // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 007F PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0080 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0081 
; 0000 0082 // Port C initialization
; 0000 0083 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out
; 0000 0084 // State6=T State5=T State4=P State3=P State2=P State1=0 State0=0
; 0000 0085 PORTC=0b00011110;
	LDI  R30,LOW(30)
	OUT  0x15,R30
; 0000 0086 DDRC=0x03;
	LDI  R30,LOW(3)
	OUT  0x14,R30
; 0000 0087 
; 0000 0088 // Port D initialization
; 0000 0089 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 008A // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 008B PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 008C DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 008D 
; 0000 008E // ADC initialization
; 0000 008F // ADC Clock frequency: 500,000 kHz
; 0000 0090 // ADC Voltage Reference: AVCC pin
; 0000 0091 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 0092 ADCSRA=0x81;
	LDI  R30,LOW(129)
	OUT  0x6,R30
; 0000 0093 
; 0000 0094 
; 0000 0095 
; 0000 0096 
; 0000 0097 
; 0000 0098  for (;;){
_0xBE:
; 0000 0099          set_leds(0, 1, 0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _set_leds
; 0000 009A          set_leds(5, 2, 1);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _set_leds
; 0000 009B          set_leds(9, 3, 0);
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _set_leds
; 0000 009C            delay_ms(5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 009D }
	RJMP _0xBE
; 0000 009E 
; 0000 009F }
_0xC0:
	RJMP _0xC0

	.CSEG

	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	subi r30,0
	sbci r31,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA
	wdr
	subi r30,1
	sbci r31,0
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:

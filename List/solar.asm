
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 4,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': No
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
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

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
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

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
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
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _voltage=R4
	.DEF _voltage_msb=R5
	.DEF _TOP=R6
	.DEF _TOP_msb=R7
	.DEF _GOAL=R8
	.DEF _GOAL_msb=R9
	.DEF _DELTA_GOAL=R10
	.DEF _DELTA_GOAL_msb=R11

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
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _adc_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0xFF,0x2,0x50,0x5
	.DB  0x2,0x0


__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  0x06
	.DW  __REG_VARS*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

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
	.ORG 0x160

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
;#define seg_a PORTD.3
;#define seg_b PORTB.0
;#define seg_c PORTD.5
;#define seg_d PORTD.7
;#define seg_e PORTB.6
;#define seg_f PORTD.2
;#define seg_g PORTB.7
;#define seg_h PORTD.6
;#define com_cat1 PORTB.4
;#define com_cat2 PORTB.5
;#define com_cat3 PORTB.3
;
;#define panel_sw PORTB.1
;#define load_sw PORTB.2
;#define load_led PORTD.4
;#define panel_led PORTD.1
;
;
;// Declare your global variables here
;unsigned int voltage;
;unsigned int TOP = 0x02ff; //ICR1H + ICR1L
;unsigned int GOAL = 1360;
;unsigned int DELTA_GOAL = 2;
;
;// ADC interrupt service routine
;interrupt [ADC_INT] void adc_isr(void)
; 0000 0036 {

	.CSEG
_adc_isr:
; .FSTART _adc_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0037         unsigned int  adc_data;
; 0000 0038         unsigned int  counter_value;
; 0000 0039         unsigned int delta;
; 0000 003A         adc_data = ADCW;
	RCALL __SAVELOCR6
;	adc_data -> R16,R17
;	counter_value -> R18,R19
;	delta -> R20,R21
	__INWR 16,17,4
; 0000 003B         voltage = (long int)adc_data*1000/366;
	MOVW R26,R16
	CLR  R24
	CLR  R25
	__GETD1N 0x3E8
	RCALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x16E
	RCALL __DIVD21
	MOVW R4,R30
; 0000 003C 
; 0000 003D         counter_value = OCR1A;
	__INWR 18,19,42
; 0000 003E         if (voltage > GOAL + DELTA_GOAL){
	MOVW R30,R10
	ADD  R30,R8
	ADC  R31,R9
	CP   R30,R4
	CPC  R31,R5
	BRSH _0x3
; 0000 003F             delta = voltage - GOAL;
	MOVW R30,R4
	SUB  R30,R8
	SBC  R31,R9
	RCALL SUBOPT_0x0
; 0000 0040             if ( delta > 100) {
	BRLO _0x4
; 0000 0041                 counter_value-=20;
	__SUBWRN 18,19,20
; 0000 0042             } else if (delta > 50){
	RJMP _0x5
_0x4:
	__CPWRN 20,21,51
	BRLO _0x6
; 0000 0043                 counter_value-=5;
	__SUBWRN 18,19,5
; 0000 0044             }
; 0000 0045             else if (delta > 20) {
	RJMP _0x7
_0x6:
	__CPWRN 20,21,21
	BRLO _0x8
; 0000 0046                 counter_value-=2;
	__SUBWRN 18,19,2
; 0000 0047             } else {
	RJMP _0x9
_0x8:
; 0000 0048                 counter_value-=1;
	__SUBWRN 18,19,1
; 0000 0049             }
_0x9:
_0x7:
_0x5:
; 0000 004A 
; 0000 004B             if (counter_value == 0 || counter_value > 0x3333) {
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BREQ _0xB
	__CPWRN 18,19,13108
	BRLO _0xA
_0xB:
; 0000 004C                counter_value = 0;
	__GETWRN 18,19,0
; 0000 004D             }
; 0000 004E             OCR1A = counter_value;
_0xA:
	__OUTWR 18,19,42
; 0000 004F         }
; 0000 0050 
; 0000 0051         if (voltage < GOAL + DELTA_GOAL){
_0x3:
	MOVW R30,R10
	ADD  R30,R8
	ADC  R31,R9
	CP   R4,R30
	CPC  R5,R31
	BRSH _0xD
; 0000 0052             delta = GOAL - voltage;
	MOVW R30,R8
	SUB  R30,R4
	SBC  R31,R5
	RCALL SUBOPT_0x0
; 0000 0053             if ( delta > 100) {
	BRLO _0xE
; 0000 0054                 counter_value+=20;
	__ADDWRN 18,19,20
; 0000 0055             } else if (delta > 50){
	RJMP _0xF
_0xE:
	__CPWRN 20,21,51
	BRLO _0x10
; 0000 0056                 counter_value+=5;
	__ADDWRN 18,19,5
; 0000 0057             }
; 0000 0058             else if (delta > 20) {
	RJMP _0x11
_0x10:
	__CPWRN 20,21,21
	BRLO _0x12
; 0000 0059                 counter_value+=2;
	__ADDWRN 18,19,2
; 0000 005A             } else {
	RJMP _0x13
_0x12:
; 0000 005B                 counter_value+=1;
	__ADDWRN 18,19,1
; 0000 005C             }
_0x13:
_0x11:
_0xF:
; 0000 005D 
; 0000 005E             if (counter_value > TOP) {
	__CPWRR 6,7,18,19
	BRSH _0x14
; 0000 005F                counter_value = TOP;
	MOVW R18,R6
; 0000 0060             }
; 0000 0061             OCR1A = counter_value;
_0x14:
	__OUTWR 18,19,42
; 0000 0062             //panel_led = 0;
; 0000 0063             //panel_sw = 1;
; 0000 0064         }
; 0000 0065 
; 0000 0066          if (voltage > 1250){
_0xD:
	LDI  R30,LOW(1250)
	LDI  R31,HIGH(1250)
	CP   R30,R4
	CPC  R31,R5
	BRSH _0x15
; 0000 0067             load_led = 0;
	CBI  0x12,4
; 0000 0068             load_sw = 1;
	SBI  0x18,2
; 0000 0069         }
; 0000 006A 
; 0000 006B         if (voltage < 1200){
_0x15:
	LDI  R30,LOW(1200)
	LDI  R31,HIGH(1200)
	CP   R4,R30
	CPC  R5,R31
	BRSH _0x1A
; 0000 006C             load_led = 1;
	SBI  0x12,4
; 0000 006D             load_sw = 0;
	CBI  0x18,2
; 0000 006E         }
; 0000 006F }
_0x1A:
	RCALL __LOADLOCR6
	ADIW R28,6
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;
;
;void set_leds (char digit, char pos, char comma);
;
;
;
;void set_leds (char digit, char pos, char comma){
; 0000 0078 void set_leds (char digit, char pos, char comma){
_set_leds:
; .FSTART _set_leds
; 0000 0079     #asm("cli")
	ST   -Y,R26
;	digit -> Y+2
;	pos -> Y+1
;	comma -> Y+0
	cli
; 0000 007A     switch (pos){
	LDD  R30,Y+1
; 0000 007B         case 1:
	CPI  R30,LOW(0x1)
	BRNE _0x22
; 0000 007C         com_cat1=1; com_cat2=0; com_cat3=0;
	SBI  0x18,4
	CBI  0x18,5
	CBI  0x18,3
; 0000 007D         break;
	RJMP _0x21
; 0000 007E 
; 0000 007F         case 2:
_0x22:
	CPI  R30,LOW(0x2)
	BRNE _0x29
; 0000 0080         com_cat1=0; com_cat2=1; com_cat3=0;
	CBI  0x18,4
	SBI  0x18,5
	CBI  0x18,3
; 0000 0081         break;
	RJMP _0x21
; 0000 0082 
; 0000 0083         case 3:
_0x29:
	CPI  R30,LOW(0x3)
	BRNE _0x21
; 0000 0084         com_cat1=0; com_cat2=0; com_cat3=1;
	CBI  0x18,4
	CBI  0x18,5
	SBI  0x18,3
; 0000 0085         break;
; 0000 0086     }
_0x21:
; 0000 0087 
; 0000 0088     if (comma==1) seg_h=1; else seg_h=0;
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x37
	SBI  0x12,6
	RJMP _0x3A
_0x37:
	CBI  0x12,6
; 0000 0089 
; 0000 008A     switch (digit){
_0x3A:
	LDD  R30,Y+2
; 0000 008B         case 1:
	CPI  R30,LOW(0x1)
	BRNE _0x40
; 0000 008C             seg_a=0; seg_b=1; seg_c=1; seg_d=0; seg_e=0; seg_f=0; seg_g=0;
	RCALL SUBOPT_0x1
	CBI  0x12,2
	CBI  0x18,7
; 0000 008D             break;
	RJMP _0x3F
; 0000 008E         case 2:
_0x40:
	CPI  R30,LOW(0x2)
	BRNE _0x4F
; 0000 008F             seg_a=1; seg_b=1; seg_c=0; seg_d=1; seg_e=1; seg_f=0; seg_g=1 ;
	RCALL SUBOPT_0x2
	CBI  0x12,5
	RCALL SUBOPT_0x3
	CBI  0x12,2
	SBI  0x18,7
; 0000 0090             break;
	RJMP _0x3F
; 0000 0091         case 3:
_0x4F:
	CPI  R30,LOW(0x3)
	BRNE _0x5E
; 0000 0092             seg_a=1; seg_b=1; seg_c=1; seg_d=1; seg_e=0; seg_f=0; seg_g=1;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x4
	CBI  0x12,2
	SBI  0x18,7
; 0000 0093             break;
	RJMP _0x3F
; 0000 0094         case 4:
_0x5E:
	CPI  R30,LOW(0x4)
	BRNE _0x6D
; 0000 0095             seg_a=0; seg_b=1; seg_c=1; seg_d=0; seg_e=0; seg_f=1; seg_g=1;
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x5
; 0000 0096             break;
	RJMP _0x3F
; 0000 0097         case 5:
_0x6D:
	CPI  R30,LOW(0x5)
	BRNE _0x7C
; 0000 0098             seg_a=1; seg_b=0; seg_c=1; seg_d=1; seg_e=0; seg_f=1; seg_g=1;
	SBI  0x12,3
	CBI  0x18,0
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
; 0000 0099             break;
	RJMP _0x3F
; 0000 009A         case 6:
_0x7C:
	CPI  R30,LOW(0x6)
	BRNE _0x8B
; 0000 009B             seg_a=1; seg_b=0; seg_c=1; seg_d=1; seg_e=1; seg_f=1; seg_g=1;
	SBI  0x12,3
	CBI  0x18,0
	SBI  0x12,5
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x5
; 0000 009C             break;
	RJMP _0x3F
; 0000 009D         case 7:
_0x8B:
	CPI  R30,LOW(0x7)
	BRNE _0x9A
; 0000 009E             seg_a=1; seg_b=1; seg_c=1; seg_d=0; seg_e=0; seg_f=0; seg_g=0;
	RCALL SUBOPT_0x2
	SBI  0x12,5
	RCALL SUBOPT_0x6
; 0000 009F             break;
	RJMP _0x3F
; 0000 00A0         case 8:
_0x9A:
	CPI  R30,LOW(0x8)
	BRNE _0xA9
; 0000 00A1             seg_a=1; seg_b=1; seg_c=1; seg_d=1; seg_e=1; seg_f=1; seg_g=1;
	RCALL SUBOPT_0x2
	SBI  0x12,5
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x5
; 0000 00A2             break;
	RJMP _0x3F
; 0000 00A3         case 9:
_0xA9:
	CPI  R30,LOW(0x9)
	BRNE _0xB8
; 0000 00A4             seg_a=1; seg_b=1; seg_c=1; seg_d=1; seg_e=0; seg_f=1; seg_g=1;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
; 0000 00A5             break;
	RJMP _0x3F
; 0000 00A6         case 0:
_0xB8:
	CPI  R30,0
	BRNE _0xC7
; 0000 00A7             seg_a=1; seg_b=1; seg_c=1; seg_d=1; seg_e=1; seg_f=1; seg_g=0;
	RCALL SUBOPT_0x2
	SBI  0x12,5
	RCALL SUBOPT_0x3
	SBI  0x12,2
	CBI  0x18,7
; 0000 00A8             break;
	RJMP _0x3F
; 0000 00A9         case 10:    //switch off
_0xC7:
	CPI  R30,LOW(0xA)
	BRNE _0x3F
; 0000 00AA             seg_a=0; seg_b=0; seg_c=0; seg_d=0; seg_e=0; seg_f=0; seg_g=0; seg_h=0;
	CBI  0x12,3
	CBI  0x18,0
	CBI  0x12,5
	RCALL SUBOPT_0x6
	CBI  0x12,6
; 0000 00AB             break;
; 0000 00AC     }
_0x3F:
; 0000 00AD     #asm("sei")
	sei
; 0000 00AE }
	ADIW R28,3
	RET
; .FEND
;
;
;
;void main(void){
; 0000 00B2 void main(void){
_main:
; .FSTART _main
; 0000 00B3     // Declare your local variables here
; 0000 00B4     char led_delay = 69;
; 0000 00B5     unsigned int volt_for_displ;
; 0000 00B6 
; 0000 00B7     // Input/Output Ports initialization
; 0000 00B8     // Port B initialization
; 0000 00B9     // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 00BA     // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 00BB     PORTB=0x00;
;	led_delay -> R17
;	volt_for_displ -> R18,R19
	LDI  R17,69
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00BC     DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 00BD 
; 0000 00BE     // Port C initialization
; 0000 00BF     // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out
; 0000 00C0     // State6=T State5=T State4=P State3=P State2=P State1=0 State0=0
; 0000 00C1     PORTC=0b00011110;
	LDI  R30,LOW(30)
	OUT  0x15,R30
; 0000 00C2     DDRC=0x03;
	LDI  R30,LOW(3)
	OUT  0x14,R30
; 0000 00C3 
; 0000 00C4     // Port D initialization
; 0000 00C5     // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 00C6     // State7=0 State6=0 State5=0 State4=1 State3=1 State2=0 State1=0 State0=1
; 0000 00C7     PORTD=0b00011001;
	LDI  R30,LOW(25)
	OUT  0x12,R30
; 0000 00C8     DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 00C9 
; 0000 00CA    // Timer/Counter 1 initialization
; 0000 00CB     // Clock source: System Clock
; 0000 00CC     // Clock value: 4000,000 kHz
; 0000 00CD     // Mode: Ph. correct PWM top=ICR1
; 0000 00CE     // OC1A output: Non-Inverted PWM
; 0000 00CF     // OC1B output: Disconnected
; 0000 00D0     // Noise Canceler: Off
; 0000 00D1     // Input Capture on Falling Edge
; 0000 00D2     // Timer Period: 0,5 ms
; 0000 00D3     // Output Pulse(s):
; 0000 00D4     // OC1A Period: 0,5 ms Width: 0,05 ms
; 0000 00D5     // Timer1 Overflow Interrupt: Off
; 0000 00D6     // Input Capture Interrupt: Off
; 0000 00D7     // Compare A Match Interrupt: Off
; 0000 00D8     // Compare B Match Interrupt: Off
; 0000 00D9     TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (1<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(130)
	OUT  0x2F,R30
; 0000 00DA     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (1<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(17)
	OUT  0x2E,R30
; 0000 00DB     TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 00DC     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00DD     ICR1H=0x02;
	LDI  R30,LOW(2)
	OUT  0x27,R30
; 0000 00DE     ICR1L=0xFF;
	LDI  R30,LOW(255)
	OUT  0x26,R30
; 0000 00DF     OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 00E0     OCR1AL=0x10;
	LDI  R30,LOW(16)
	OUT  0x2A,R30
; 0000 00E1     OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 00E2     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00E3 
; 0000 00E4    // ADC initialization
; 0000 00E5     // ADC Clock frequency: 7,813 kHz
; 0000 00E6     // ADC Voltage Reference: AVCC pin
; 0000 00E7     ADMUX=(0<<REFS1) | (1<<REFS0) | (0<<ADLAR)| (0<<MUX3) | (1<<MUX2) | (0<<MUX1) | (1<<MUX0);
	LDI  R30,LOW(69)
	OUT  0x7,R30
; 0000 00E8     ADCSRA=(1<<ADEN) | (1<<ADSC) | (1<<ADFR) | (1<<ADIF) | (1<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(255)
	OUT  0x6,R30
; 0000 00E9 
; 0000 00EA     SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00EB 
; 0000 00EC 
; 0000 00ED     delay_ms(100);
	LDI  R26,LOW(100)
	RCALL SUBOPT_0x7
; 0000 00EE 
; 0000 00EF     // Global enable interrupts
; 0000 00F0     #asm("sei")
	sei
; 0000 00F1 
; 0000 00F2     for (;;){
_0xE8:
; 0000 00F3         unsigned int volt_tmp;
; 0000 00F4         char tis;
; 0000 00F5         char sot;
; 0000 00F6         char des;
; 0000 00F7         char ed;
; 0000 00F8 
; 0000 00F9         if (++led_delay == 70){
	SBIW R28,6
;	volt_tmp -> Y+4
;	tis -> Y+3
;	sot -> Y+2
;	des -> Y+1
;	ed -> Y+0
	SUBI R17,-LOW(1)
	CPI  R17,70
	BRNE _0xEA
; 0000 00FA             volt_for_displ = voltage;
	MOVW R18,R4
; 0000 00FB             led_delay = 0;
	LDI  R17,LOW(0)
; 0000 00FC         }
; 0000 00FD 
; 0000 00FE         volt_tmp = volt_for_displ;
_0xEA:
	__PUTWSR 18,19,4
; 0000 00FF         tis = volt_tmp/1000;
	RCALL SUBOPT_0x8
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __DIVW21U
	STD  Y+3,R30
; 0000 0100         volt_tmp = volt_tmp - (int)tis*1000;
	LDD  R26,Y+3
	LDI  R27,0
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __MULW12
	RCALL SUBOPT_0x9
; 0000 0101         sot = volt_tmp/100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21U
	STD  Y+2,R30
; 0000 0102         volt_tmp=volt_tmp-(int)sot*100;
	LDD  R26,Y+2
	LDI  R30,LOW(100)
	MUL  R30,R26
	MOVW R30,R0
	RCALL SUBOPT_0x9
; 0000 0103         des=volt_tmp/10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	STD  Y+1,R30
; 0000 0104         volt_tmp=volt_tmp-(int)des*10;
	LDD  R26,Y+1
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	RCALL SUBOPT_0x8
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+4,R26
	STD  Y+4+1,R27
; 0000 0105         ed=volt_tmp;
	LDD  R30,Y+4
	ST   Y,R30
; 0000 0106 
; 0000 0107         set_leds(ed, 1, 0);
	ST   -Y,R30
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xA
; 0000 0108         delay_ms(1);
; 0000 0109         set_leds(des, 2, 0);
	LDD  R30,Y+1
	ST   -Y,R30
	LDI  R30,LOW(2)
	RCALL SUBOPT_0xA
; 0000 010A         delay_ms(1);
; 0000 010B         set_leds(sot, 3, 1);
	LDD  R30,Y+2
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _set_leds
; 0000 010C         delay_ms(1);
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x7
; 0000 010D         set_leds(10, 3, 0);
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(3)
	RCALL SUBOPT_0xA
; 0000 010E         delay_ms(1);
; 0000 010F     }
	ADIW R28,6
	RJMP _0xE8
; 0000 0110 }
_0xEB:
	RJMP _0xEB
; .FEND

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	MOVW R20,R30
	__CPWRN 20,21,101
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	CBI  0x12,3
	SBI  0x18,0
	SBI  0x12,5
	CBI  0x12,7
	CBI  0x18,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	SBI  0x12,3
	SBI  0x18,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	SBI  0x12,7
	SBI  0x18,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	SBI  0x12,5
	SBI  0x12,7
	CBI  0x18,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	SBI  0x12,2
	SBI  0x18,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	CBI  0x12,7
	CBI  0x18,6
	CBI  0x12,2
	CBI  0x18,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	RCALL SUBOPT_0x8
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+4,R26
	STD  Y+4+1,R27
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _set_leds
	LDI  R26,LOW(1)
	RJMP SUBOPT_0x7


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x3E8
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:

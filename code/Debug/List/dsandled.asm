
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16A
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	.DEF _hh=R4
	.DEF _hh_msb=R5
	.DEF _mm=R6
	.DEF _mm_msb=R7
	.DEF _ss=R8
	.DEF _ss_msb=R9
	.DEF _h3=R10
	.DEF _h3_msb=R11
	.DEF _m3=R12
	.DEF _m3_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x1
_0x4:
	.DB  0xA
_0x0:
	.DB  0x25,0x64,0x3A,0x25,0x64,0x3A,0x25,0x64
	.DB  0x0,0x73,0x65,0x74,0x20,0x68,0x6F,0x75
	.DB  0x72,0x0,0x73,0x65,0x74,0x20,0x6D,0x69
	.DB  0x6E,0x75,0x74,0x65,0x73,0x0,0x73,0x65
	.DB  0x74,0x20,0x73,0x65,0x63,0x6F,0x6E,0x64
	.DB  0x73,0x0,0x25,0x64,0x20,0x3A,0x20,0x25
	.DB  0x64,0x20,0x0,0x3C,0x73,0x65,0x74,0x20
	.DB  0x41,0x6C,0x61,0x72,0x6D,0x20,0x48,0x3E
	.DB  0x0,0x3C,0x73,0x65,0x74,0x20,0x41,0x6C
	.DB  0x61,0x72,0x6D,0x20,0x4D,0x3E,0x0,0x61
	.DB  0x6C,0x61,0x72,0x6D,0x0
_0x2020003:
	.DB  0x80,0xC0
_0x2060060:
	.DB  0x1
_0x2060000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _h4
	.DW  _0x3*2

	.DW  0x01
	.DW  _m4
	.DW  _0x4*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

	.DW  0x01
	.DW  __seed_G103
	.DW  _0x2060060*2

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

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;Chip type               : ATmega16A
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;#include <mega16a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;// I2C Bus functions
;#include <i2c.h>
;// DS1307 Real Time Clock functions
;#include <ds1307.h>
;// Alphanumeric LCD functions
;#include <alcd.h>
;#include <alcd.h>
;#include <delay.h>
;#include <stdio.h>
;#include <stdlib.h>
;
;#define down PINB.4
;#define up PINB.3
;#define ok_time PINB.5
;#define ok PINB.0         //
;#define offled PINB.7     //simulation
;
;#define led1 PORTD.0
;
;// Declare your global variables here
;
;int hh=0,mm=0,ss=0;
;int h3=0,m3=0,h4=1,m4=10;

	.DSEG
;char buffer[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},h=0,m=0,s=0;
;char n_led = 0;
;char start_time = 0;
;char alarm;
;int flag=0;
;int flag1=0;
;int flag2=0;
;int flag3=0;
;void main(void)
; 0000 002A {

	.CSEG
_main:
; .FSTART _main
; 0000 002B 
; 0000 002C // Declare your local variables here
; 0000 002D 
; 0000 002E // Input/Output Ports initialization
; 0000 002F // Port A initialization
; 0000 0030 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0031 DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0032 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0033 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0034 
; 0000 0035 // Port B initialization
; 0000 0036 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0037 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0038 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0039 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 003A 
; 0000 003B // Port C initialization
; 0000 003C // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 003D DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 003E // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 003F PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0040 
; 0000 0041 // Port D initialization
; 0000 0042 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0043 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0044 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0045 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0046 
; 0000 0047 // Timer/Counter 0 initialization
; 0000 0048 // Clock source: System Clock
; 0000 0049 // Clock value: Timer 0 Stopped
; 0000 004A // Mode: Normal top=0xFF
; 0000 004B // OC0 output: Disconnected
; 0000 004C TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 004D TCNT0=0x00;
	OUT  0x32,R30
; 0000 004E OCR0=0x00;
	OUT  0x3C,R30
; 0000 004F 
; 0000 0050 // Timer/Counter 1 initialization
; 0000 0051 // Clock source: System Clock
; 0000 0052 // Clock value: Timer1 Stopped
; 0000 0053 // Mode: Normal top=0xFFFF
; 0000 0054 // OC1A output: Disconnected
; 0000 0055 // OC1B output: Disconnected
; 0000 0056 // Noise Canceler: Off
; 0000 0057 // Input Capture on Falling Edge
; 0000 0058 // Timer1 Overflow Interrupt: Off
; 0000 0059 // Input Capture Interrupt: Off
; 0000 005A // Compare A Match Interrupt: Off
; 0000 005B // Compare B Match Interrupt: Off
; 0000 005C TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 005D TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 005E TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 005F TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0060 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0061 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0062 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0063 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0064 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0065 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0066 
; 0000 0067 // Timer/Counter 2 initialization
; 0000 0068 // Clock source: System Clock
; 0000 0069 // Clock value: Timer2 Stopped
; 0000 006A // Mode: Normal top=0xFF
; 0000 006B // OC2 output: Disconnected
; 0000 006C ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 006D TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 006E TCNT2=0x00;
	OUT  0x24,R30
; 0000 006F OCR2=0x00;
	OUT  0x23,R30
; 0000 0070 
; 0000 0071 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0072 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0073 
; 0000 0074 // External Interrupt(s) initialization
; 0000 0075 // INT0: Off
; 0000 0076 // INT1: Off
; 0000 0077 // INT2: Off
; 0000 0078 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 0079 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 007A 
; 0000 007B // USART initialization
; 0000 007C // USART disabled
; 0000 007D UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 007E 
; 0000 007F // Analog Comparator initialization
; 0000 0080 // Analog Comparator: Off
; 0000 0081 // The Analog Comparator's positive input is
; 0000 0082 // connected to the AIN0 pin
; 0000 0083 // The Analog Comparator's negative input is
; 0000 0084 // connected to the AIN1 pin
; 0000 0085 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0086 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0087 
; 0000 0088 // ADC initialization
; 0000 0089 // ADC disabled
; 0000 008A ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 008B 
; 0000 008C // SPI initialization
; 0000 008D // SPI disabled
; 0000 008E SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 008F 
; 0000 0090 // TWI initialization
; 0000 0091 // TWI disabled
; 0000 0092 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0093 
; 0000 0094 // Bit-Banged I2C Bus initialization
; 0000 0095 // I2C Port: PORTC
; 0000 0096 // I2C SDA bit: 1
; 0000 0097 // I2C SCL bit: 0
; 0000 0098 // Bit Rate: 100 kHz
; 0000 0099 // Note: I2C settings are specified in the
; 0000 009A // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 009B i2c_init();
	CALL _i2c_init
; 0000 009C 
; 0000 009D // DS1307 Real Time Clock initialization
; 0000 009E // Square wave output on pin SQW/OUT: Off
; 0000 009F // SQW/OUT pin state: 0
; 0000 00A0 rtc_init(0,0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _rtc_init
; 0000 00A1 
; 0000 00A2 // Alphanumeric LCD initialization
; 0000 00A3 // Connections are specified in the
; 0000 00A4 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00A5 // RS - PORTA Bit 0
; 0000 00A6 // RD - PORTA Bit 1
; 0000 00A7 // EN - PORTA Bit 2
; 0000 00A8 // D4 - PORTA Bit 4
; 0000 00A9 // D5 - PORTA Bit 5
; 0000 00AA // D6 - PORTA Bit 6
; 0000 00AB // D7 - PORTA Bit 7
; 0000 00AC // Characters/line: 16
; 0000 00AD lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 00AE 
; 0000 00AF 
; 0000 00B0 while (1)
_0x5:
; 0000 00B1       {
; 0000 00B2 
; 0000 00B3              if ( ok_time == 0 )        //set Time
	SBIC 0x16,5
	RJMP _0x8
; 0000 00B4             {
; 0000 00B5                 delay_ms(800);
	CALL SUBOPT_0x0
; 0000 00B6                 if ( ok_time == 0)
	SBIC 0x16,5
	RJMP _0x9
; 0000 00B7                 {
; 0000 00B8                     start_time = 1;
	LDI  R30,LOW(1)
	STS  _start_time,R30
; 0000 00B9                     while ( start_time == 1)
_0xA:
	LDS  R26,_start_time
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0xC
; 0000 00BA                     {                       //set hour
; 0000 00BB                     if(up == 0)
	SBIC 0x16,3
	RJMP _0xD
; 0000 00BC                         {delay_ms(200);
	CALL SUBOPT_0x1
; 0000 00BD                         hh++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 00BE                         if( hh == 24 ) hh=0; }
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0xE
	CLR  R4
	CLR  R5
_0xE:
; 0000 00BF                     if(down == 0)
_0xD:
	SBIC 0x16,4
	RJMP _0xF
; 0000 00C0                         {delay_ms(200);
	CALL SUBOPT_0x1
; 0000 00C1                         if( hh == 0 ) hh=23;
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x10
	LDI  R30,LOW(23)
	LDI  R31,HIGH(23)
	RJMP _0x73
; 0000 00C2                         else hh--;   }
_0x10:
	MOVW R30,R4
	SBIW R30,1
_0x73:
	MOVW R4,R30
; 0000 00C3                       rtc_set_time(hh,mm,ss);
_0xF:
	CALL SUBOPT_0x2
; 0000 00C4 
; 0000 00C5                       rtc_get_time(&h,&m,&s);
; 0000 00C6                       lcd_clear();
; 0000 00C7                       lcd_gotoxy(0,0);
; 0000 00C8                       sprintf(buffer,"%d:%d:%d",h,m,s);
; 0000 00C9                       lcd_puts(buffer);
; 0000 00CA                               lcd_gotoxy(0,1);
; 0000 00CB                               sprintf(buffer,"set hour");
	__POINTW1FN _0x0,9
	CALL SUBOPT_0x3
; 0000 00CC                               lcd_puts(buffer);
; 0000 00CD 
; 0000 00CE                       delay_ms(100);
; 0000 00CF                     if ( ok_time == 0 )
	SBIC 0x16,5
	RJMP _0x12
; 0000 00D0                       {
; 0000 00D1                       delay_ms(800);
	CALL SUBOPT_0x0
; 0000 00D2                       if ( ok_time == 0)
	SBIC 0x16,5
	RJMP _0x13
; 0000 00D3                       {
; 0000 00D4                         while ( start_time == 1)
_0x14:
	LDS  R26,_start_time
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x16
; 0000 00D5                         {                         //set minute
; 0000 00D6                                 if(up == 0)
	SBIC 0x16,3
	RJMP _0x17
; 0000 00D7                                 {delay_ms(200);
	CALL SUBOPT_0x1
; 0000 00D8                                 mm++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 00D9                                 if( mm == 60 ) mm=0;}
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x18
	CLR  R6
	CLR  R7
_0x18:
; 0000 00DA                             if(down == 0)
_0x17:
	SBIC 0x16,4
	RJMP _0x19
; 0000 00DB                                 {delay_ms(200);
	CALL SUBOPT_0x1
; 0000 00DC                                 if( mm == 0 ) mm=59;
	MOV  R0,R6
	OR   R0,R7
	BRNE _0x1A
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	RJMP _0x74
; 0000 00DD                                 else mm--; }
_0x1A:
	MOVW R30,R6
	SBIW R30,1
_0x74:
	MOVW R6,R30
; 0000 00DE                               rtc_set_time(hh,mm,ss);
_0x19:
	CALL SUBOPT_0x2
; 0000 00DF 
; 0000 00E0                               rtc_get_time(&h,&m,&s);
; 0000 00E1                               lcd_clear();
; 0000 00E2                               lcd_gotoxy(0,0);
; 0000 00E3                                sprintf(buffer,"%d:%d:%d",h,m,s);
; 0000 00E4                                lcd_puts(buffer);
; 0000 00E5                                lcd_gotoxy(0,1);
; 0000 00E6                                sprintf(buffer,"set minutes");
	__POINTW1FN _0x0,18
	CALL SUBOPT_0x3
; 0000 00E7                                lcd_puts(buffer);
; 0000 00E8                                delay_ms(100);
; 0000 00E9                             if ( ok_time == 0 )
	SBIC 0x16,5
	RJMP _0x1C
; 0000 00EA                             {
; 0000 00EB                               delay_ms(800);
	CALL SUBOPT_0x0
; 0000 00EC                               if ( ok_time == 0)
	SBIC 0x16,5
	RJMP _0x1D
; 0000 00ED                               {                                //set second
; 0000 00EE                                 while ( start_time == 1)
_0x1E:
	LDS  R26,_start_time
	CPI  R26,LOW(0x1)
	BRNE _0x20
; 0000 00EF                                 {
; 0000 00F0                                     if(up == 0)
	SBIC 0x16,3
	RJMP _0x21
; 0000 00F1                                         {delay_ms(200);
	CALL SUBOPT_0x1
; 0000 00F2                                         ss++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 00F3                                         if( ss == 60 ) ss=0; }
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x22
	CLR  R8
	CLR  R9
_0x22:
; 0000 00F4                                     if(down == 0)
_0x21:
	SBIC 0x16,4
	RJMP _0x23
; 0000 00F5                                         {delay_ms(200);
	CALL SUBOPT_0x1
; 0000 00F6                                         if( ss == 0 ) ss=59;
	MOV  R0,R8
	OR   R0,R9
	BRNE _0x24
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	RJMP _0x75
; 0000 00F7                                         else ss--; }
_0x24:
	MOVW R30,R8
	SBIW R30,1
_0x75:
	MOVW R8,R30
; 0000 00F8                                       rtc_set_time(hh,mm,ss);
_0x23:
	CALL SUBOPT_0x2
; 0000 00F9 
; 0000 00FA                                       rtc_get_time(&h,&m,&s);
; 0000 00FB                                       lcd_clear();                  //print Time
; 0000 00FC                                       lcd_gotoxy(0,0);
; 0000 00FD                                       sprintf(buffer,"%d:%d:%d",h,m,s);
; 0000 00FE                                       lcd_puts(buffer);
; 0000 00FF                                       lcd_gotoxy(0,1);
; 0000 0100                                       sprintf(buffer,"set seconds");
	__POINTW1FN _0x0,30
	CALL SUBOPT_0x3
; 0000 0101                                       lcd_puts(buffer);
; 0000 0102                                       delay_ms(100);
; 0000 0103                                     if ( ok_time == 0 )
	SBIC 0x16,5
	RJMP _0x26
; 0000 0104                                       {
; 0000 0105                                       delay_ms(800);
	CALL SUBOPT_0x0
; 0000 0106                                       if ( ok_time == 0)
	SBIC 0x16,5
	RJMP _0x27
; 0000 0107                                         {
; 0000 0108                                         start_time = 0;
	LDI  R30,LOW(0)
	STS  _start_time,R30
; 0000 0109                                         }
; 0000 010A                                       }
_0x27:
; 0000 010B                                 }
_0x26:
	RJMP _0x1E
_0x20:
; 0000 010C                               }
; 0000 010D                             }
_0x1D:
; 0000 010E                         }
_0x1C:
	RJMP _0x14
_0x16:
; 0000 010F                       }
; 0000 0110                     }
_0x13:
; 0000 0111                 }
_0x12:
	RJMP _0xA
_0xC:
; 0000 0112              }
; 0000 0113            }
_0x9:
; 0000 0114 
; 0000 0115             //set alarm
; 0000 0116             if (ok == 0)
_0x8:
	SBIC 0x16,0
	RJMP _0x28
; 0000 0117             {    delay_ms(800);
	CALL SUBOPT_0x0
; 0000 0118             if (ok == 0)
	SBIC 0x16,0
	RJMP _0x29
; 0000 0119              {
; 0000 011A                  alarm=1;
	LDI  R30,LOW(1)
	STS  _alarm,R30
; 0000 011B                  while (  alarm == 1 )
_0x2A:
	LDS  R26,_alarm
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x2C
; 0000 011C                  {
; 0000 011D                                 if(up == 0)
	SBIC 0x16,3
	RJMP _0x2D
; 0000 011E                                 {delay_ms(200);
	CALL SUBOPT_0x1
; 0000 011F                                 h3++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 0120                                 if( h3 == 13 ) h3=0;}
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x2E
	CLR  R10
	CLR  R11
_0x2E:
; 0000 0121                                 if(down == 0)
_0x2D:
	SBIC 0x16,4
	RJMP _0x2F
; 0000 0122                                 {delay_ms(200);
	CALL SUBOPT_0x1
; 0000 0123                                 if( h3 == 0 ) h3=12;
	MOV  R0,R10
	OR   R0,R11
	BRNE _0x30
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	RJMP _0x76
; 0000 0124                                 else h3--; }
_0x30:
	MOVW R30,R10
	SBIW R30,1
_0x76:
	MOVW R10,R30
; 0000 0125                             lcd_clear();
_0x2F:
	CALL SUBOPT_0x4
; 0000 0126                             lcd_gotoxy(0,0);
; 0000 0127                             sprintf(buffer,"%d : %d ",h3,m3);
; 0000 0128                             lcd_puts(buffer);
; 0000 0129                             lcd_gotoxy(0,1);
; 0000 012A                             sprintf(buffer,"<set Alarm H>");
	__POINTW1FN _0x0,51
	CALL SUBOPT_0x3
; 0000 012B                             lcd_puts(buffer);
; 0000 012C                             delay_ms(100);
; 0000 012D 
; 0000 012E                          if ( ok == 0 )
	SBIC 0x16,0
	RJMP _0x32
; 0000 012F                         {
; 0000 0130                              delay_ms(800);
	CALL SUBOPT_0x0
; 0000 0131                              if ( ok == 0)
	SBIC 0x16,0
	RJMP _0x33
; 0000 0132                             {                                //set Alarm Minute
; 0000 0133                                 while ( alarm == 1)
_0x34:
	LDS  R26,_alarm
	CPI  R26,LOW(0x1)
	BRNE _0x36
; 0000 0134                                 {
; 0000 0135                                         if(up == 0)
	SBIC 0x16,3
	RJMP _0x37
; 0000 0136                                         {delay_ms(200);
	CALL SUBOPT_0x1
; 0000 0137                                         m3++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 0138                                         if( m3 == 60 )   {m3=0;h3++;if(h3==24){h3=0;}}
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x38
	CLR  R12
	CLR  R13
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x39
	CLR  R10
	CLR  R11
_0x39:
; 0000 0139                                         }
_0x38:
; 0000 013A                                     if(down == 0)
_0x37:
	SBIC 0x16,4
	RJMP _0x3A
; 0000 013B                                         {delay_ms(200);
	CALL SUBOPT_0x1
; 0000 013C                                         if( m3 == 0 ) m3=60;
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x3B
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	RJMP _0x77
; 0000 013D                                         else m3--; }
_0x3B:
	MOVW R30,R12
	SBIW R30,1
_0x77:
	MOVW R12,R30
; 0000 013E 
; 0000 013F                                         lcd_clear();
_0x3A:
	CALL SUBOPT_0x4
; 0000 0140                                         lcd_gotoxy(0,0);
; 0000 0141                                         sprintf(buffer,"%d : %d ",h3,m3);
; 0000 0142                                         lcd_puts(buffer);
; 0000 0143                                         lcd_gotoxy(0,1);
; 0000 0144                                         sprintf(buffer,"<set Alarm M>");
	__POINTW1FN _0x0,65
	CALL SUBOPT_0x3
; 0000 0145                                         lcd_puts(buffer);
; 0000 0146                                         delay_ms(100);
; 0000 0147 
; 0000 0148                                       if ( ok == 0 )
	SBIC 0x16,0
	RJMP _0x3D
; 0000 0149                                       {
; 0000 014A                                       delay_ms(800);
	CALL SUBOPT_0x0
; 0000 014B                                         if ( ok == 0)
	SBIC 0x16,0
	RJMP _0x3E
; 0000 014C                                         {
; 0000 014D                                         alarm=0;
	LDI  R30,LOW(0)
	STS  _alarm,R30
; 0000 014E                                         h4=h3+hh;
	CALL SUBOPT_0x5
; 0000 014F                                         m4=m3+mm;
; 0000 0150                                         }
; 0000 0151                                       }
_0x3E:
; 0000 0152                                 }
_0x3D:
	RJMP _0x34
_0x36:
; 0000 0153 
; 0000 0154 
; 0000 0155                             }
; 0000 0156 
; 0000 0157 
; 0000 0158                       }
_0x33:
; 0000 0159                  }
_0x32:
	RJMP _0x2A
_0x2C:
; 0000 015A 
; 0000 015B              }
; 0000 015C             }
_0x29:
; 0000 015D 
; 0000 015E             //Get Alarm
; 0000 015F 
; 0000 0160                 if (offled==0 && flag==0)          //if offled switch pressed , then off the LED for 1 minute
_0x28:
	SBIC 0x16,7
	RJMP _0x40
	CALL SUBOPT_0x6
	SBIW R26,0
	BREQ _0x41
_0x40:
	RJMP _0x3F
_0x41:
; 0000 0161                 {
; 0000 0162                 delay_ms(800);
	CALL SUBOPT_0x0
; 0000 0163                 if (offled==0)   flag=1;
	SBIC 0x16,7
	RJMP _0x42
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _flag,R30
	STS  _flag+1,R31
; 0000 0164                 }
_0x42:
; 0000 0165 
; 0000 0166                 if (n_led==1 && flag==1)
_0x3F:
	LDS  R26,_n_led
	CPI  R26,LOW(0x1)
	BRNE _0x44
	CALL SUBOPT_0x6
	SBIW R26,1
	BREQ _0x45
_0x44:
	RJMP _0x43
_0x45:
; 0000 0167                 {
; 0000 0168                 flag1=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _flag1,R30
	STS  _flag1+1,R31
; 0000 0169                 }
; 0000 016A 
; 0000 016B                 if (n_led==2 && flag1==1 && offled==0)
_0x43:
	LDS  R26,_n_led
	CPI  R26,LOW(0x2)
	BRNE _0x47
	LDS  R26,_flag1
	LDS  R27,_flag1+1
	SBIW R26,1
	BRNE _0x47
	SBIS 0x16,7
	RJMP _0x48
_0x47:
	RJMP _0x46
_0x48:
; 0000 016C                 {
; 0000 016D                 delay_ms(800);
	CALL SUBOPT_0x0
; 0000 016E                 if (offled==0)   {flag1=0;
	SBIC 0x16,7
	RJMP _0x49
	LDI  R30,LOW(0)
	STS  _flag1,R30
	STS  _flag1+1,R30
; 0000 016F                                   flag2=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _flag2,R30
	STS  _flag2+1,R31
; 0000 0170                                  }
; 0000 0171                 }
_0x49:
; 0000 0172 
; 0000 0173                 if (offled==0 && n_led==3 && flag2==1)
_0x46:
	SBIC 0x16,7
	RJMP _0x4B
	LDS  R26,_n_led
	CPI  R26,LOW(0x3)
	BRNE _0x4B
	LDS  R26,_flag2
	LDS  R27,_flag2+1
	SBIW R26,1
	BREQ _0x4C
_0x4B:
	RJMP _0x4A
_0x4C:
; 0000 0174                 {
; 0000 0175                 delay_ms(800);
	CALL SUBOPT_0x0
; 0000 0176                 if (offled==0)   {flag3=1;
	SBIC 0x16,7
	RJMP _0x4D
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _flag3,R30
	STS  _flag3+1,R31
; 0000 0177                                   flag2=0;
	LDI  R30,LOW(0)
	STS  _flag2,R30
	STS  _flag2+1,R30
; 0000 0178                                  }
; 0000 0179                 }
_0x4D:
; 0000 017A 
; 0000 017B 
; 0000 017C                 if (offled==0 && n_led==4 && flag3==1)
_0x4A:
	SBIC 0x16,7
	RJMP _0x4F
	LDS  R26,_n_led
	CPI  R26,LOW(0x4)
	BRNE _0x4F
	LDS  R26,_flag3
	LDS  R27,_flag3+1
	SBIW R26,1
	BREQ _0x50
_0x4F:
	RJMP _0x4E
_0x50:
; 0000 017D                 {
; 0000 017E                 delay_ms(800);
	CALL SUBOPT_0x0
; 0000 017F                 if (offled==0)   {flag3=0;
	SBIC 0x16,7
	RJMP _0x51
	LDI  R30,LOW(0)
	STS  _flag3,R30
	STS  _flag3+1,R30
; 0000 0180                                   flag=0;
	STS  _flag,R30
	STS  _flag+1,R30
; 0000 0181                                   n_led=0;
	STS  _n_led,R30
; 0000 0182                                   h4=h3+hh;
	CALL SUBOPT_0x5
; 0000 0183                                   m4=m3+mm;
; 0000 0184                                  }
; 0000 0185                 }
_0x51:
; 0000 0186 
; 0000 0187 
; 0000 0188             if ( h==h4%24 && m==m4%60 && flag==0 )
_0x4E:
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
	BRNE _0x53
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	BRNE _0x53
	CALL SUBOPT_0x6
	SBIW R26,0
	BREQ _0x54
_0x53:
	RJMP _0x52
_0x54:
; 0000 0189             {
; 0000 018A                if(offled==1)   {
	SBIC 0x16,7
; 0000 018B                                 led1=1;
	SBI  0x12,0
; 0000 018C                               }
; 0000 018D                n_led=1;
	LDI  R30,LOW(1)
	STS  _n_led,R30
; 0000 018E 
; 0000 018F             }
; 0000 0190             else if ( h==((h4+h3)%24) && m==((m4+m3)%60) && flag1==1 )
	RJMP _0x58
_0x52:
	MOVW R30,R10
	CALL SUBOPT_0xB
	BRNE _0x5A
	MOVW R30,R12
	CALL SUBOPT_0xC
	BRNE _0x5A
	LDS  R26,_flag1
	LDS  R27,_flag1+1
	SBIW R26,1
	BREQ _0x5B
_0x5A:
	RJMP _0x59
_0x5B:
; 0000 0191             {
; 0000 0192                   if(offled==1)
	SBIC 0x16,7
; 0000 0193                             {
; 0000 0194                             led1=1;
	SBI  0x12,0
; 0000 0195                             }
; 0000 0196                n_led=2;
	LDI  R30,LOW(2)
	STS  _n_led,R30
; 0000 0197             }
; 0000 0198             else if ( h==((h4+h3*2)%24) && m==((m4+m3*2)%60 ) && flag2==1)
	RJMP _0x5F
_0x59:
	MOVW R30,R10
	LSL  R30
	ROL  R31
	CALL SUBOPT_0xB
	BRNE _0x61
	MOVW R30,R12
	LSL  R30
	ROL  R31
	CALL SUBOPT_0xC
	BRNE _0x61
	LDS  R26,_flag2
	LDS  R27,_flag2+1
	SBIW R26,1
	BREQ _0x62
_0x61:
	RJMP _0x60
_0x62:
; 0000 0199             {
; 0000 019A                if(offled==1)   {
	SBIC 0x16,7
; 0000 019B                             led1=1;
	SBI  0x12,0
; 0000 019C                            }
; 0000 019D                n_led=3;
	LDI  R30,LOW(3)
	STS  _n_led,R30
; 0000 019E             }
; 0000 019F             else if ( h==((h4+h3*3)%24) && m==((m4+m3*3)%60 ) && flag3==1 && n_led>=3)
	RJMP _0x66
_0x60:
	MOVW R30,R10
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12
	CALL SUBOPT_0xB
	BRNE _0x68
	MOVW R30,R12
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12
	CALL SUBOPT_0xC
	BRNE _0x68
	LDS  R26,_flag3
	LDS  R27,_flag3+1
	SBIW R26,1
	BRNE _0x68
	LDS  R26,_n_led
	CPI  R26,LOW(0x3)
	BRSH _0x69
_0x68:
	RJMP _0x67
_0x69:
; 0000 01A0             {                                                                             //for alarms less than 8 hours
; 0000 01A1                if(offled==1)   {
	SBIC 0x16,7
; 0000 01A2 
; 0000 01A3                     led1=1;
	SBI  0x12,0
; 0000 01A4 
; 0000 01A5                            }
; 0000 01A6                n_led=4;
	LDI  R30,LOW(4)
	STS  _n_led,R30
; 0000 01A7                flag=0;
	LDI  R30,LOW(0)
	STS  _flag,R30
	STS  _flag+1,R30
; 0000 01A8             }
; 0000 01A9             else {
	RJMP _0x6D
_0x67:
; 0000 01AA                     led1=0;
	CBI  0x12,0
; 0000 01AB                  }
_0x6D:
_0x66:
_0x5F:
_0x58:
; 0000 01AC 
; 0000 01AD                                 //printing The Time
; 0000 01AE 
; 0000 01AF           rtc_get_time(&h,&m,&s);
	LDI  R30,LOW(_h)
	LDI  R31,HIGH(_h)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_m)
	LDI  R31,HIGH(_m)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_s)
	LDI  R27,HIGH(_s)
	RCALL _rtc_get_time
; 0000 01B0           lcd_clear();
	RCALL _lcd_clear
; 0000 01B1           lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL SUBOPT_0xD
; 0000 01B2           sprintf(buffer,"%d:%d:%d",h,m,s);
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_h
	CALL SUBOPT_0xE
	LDS  R30,_m
	CALL SUBOPT_0xE
	LDS  R30,_s
	CALL SUBOPT_0xE
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 01B3           lcd_puts(buffer);
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	RCALL _lcd_puts
; 0000 01B4         if(led1==1)
	SBIS 0x12,0
	RJMP _0x70
; 0000 01B5         {
; 0000 01B6             lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL SUBOPT_0xD
; 0000 01B7             sprintf(buffer,"alarm");
	__POINTW1FN _0x0,79
	RJMP _0x78
; 0000 01B8             lcd_puts(buffer);
; 0000 01B9         }
; 0000 01BA         else
_0x70:
; 0000 01BB         {
; 0000 01BC             lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL SUBOPT_0xD
; 0000 01BD             sprintf(buffer,"");
	__POINTW1FN _0x0,8
_0x78:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
; 0000 01BE             lcd_puts(buffer);
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	RCALL _lcd_puts
; 0000 01BF         }
; 0000 01C0           delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 01C1 
; 0000 01C2     }
	RJMP _0x5
; 0000 01C3 }
_0x72:
	RJMP _0x72
; .FEND
;
;

	.CSEG
_rtc_init:
; .FSTART _rtc_init
	ST   -Y,R26
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2000003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2000003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2000004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2000004:
	CALL SUBOPT_0xF
	LDI  R26,LOW(7)
	CALL _i2c_write
	LDD  R26,Y+2
	CALL SUBOPT_0x10
	RJMP _0x2100003
; .FEND
_rtc_get_time:
; .FSTART _rtc_get_time
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0xF
	LDI  R26,LOW(0)
	CALL SUBOPT_0x10
	CALL _i2c_start
	LDI  R26,LOW(209)
	CALL _i2c_write
	CALL SUBOPT_0x11
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	CALL SUBOPT_0x11
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R26,LOW(0)
	CALL _i2c_read
	MOV  R26,R30
	CALL _bcd2bin
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	CALL _i2c_stop
	ADIW R28,6
	RET
; .FEND
_rtc_set_time:
; .FSTART _rtc_set_time
	ST   -Y,R26
	CALL SUBOPT_0xF
	LDI  R26,LOW(0)
	CALL _i2c_write
	LD   R26,Y
	CALL _bin2bcd
	MOV  R26,R30
	CALL _i2c_write
	LDD  R26,Y+1
	CALL _bin2bcd
	MOV  R26,R30
	CALL _i2c_write
	LDD  R26,Y+2
	CALL _bin2bcd
	MOV  R26,R30
	CALL SUBOPT_0x10
	RJMP _0x2100003
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x2100002
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 133
	RJMP _0x2100002
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x12
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x12
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2020004
_0x2020005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020007
	RJMP _0x2100002
_0x2020007:
_0x2020004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2100002
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
	LDD  R17,Y+0
_0x2100003:
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x13
	CALL SUBOPT_0x13
	CALL SUBOPT_0x13
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2100002:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G102:
; .FSTART _put_buff_G102
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2040010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2040012
	__CPWRN 16,17,2
	BRLO _0x2040013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2040012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2040013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2040014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2040014:
	RJMP _0x2040015
_0x2040010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2040015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G102:
; .FSTART __print_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x204001C
	CPI  R18,37
	BRNE _0x204001D
	LDI  R17,LOW(1)
	RJMP _0x204001E
_0x204001D:
	CALL SUBOPT_0x14
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BRNE _0x204001F
	CPI  R18,37
	BRNE _0x2040020
	CALL SUBOPT_0x14
	RJMP _0x20400CC
_0x2040020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2040021
	LDI  R16,LOW(1)
	RJMP _0x204001B
_0x2040021:
	CPI  R18,43
	BRNE _0x2040022
	LDI  R20,LOW(43)
	RJMP _0x204001B
_0x2040022:
	CPI  R18,32
	BRNE _0x2040023
	LDI  R20,LOW(32)
	RJMP _0x204001B
_0x2040023:
	RJMP _0x2040024
_0x204001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2040025
_0x2040024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040026
	ORI  R16,LOW(128)
	RJMP _0x204001B
_0x2040026:
	RJMP _0x2040027
_0x2040025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x204001B
_0x2040027:
	CPI  R18,48
	BRLO _0x204002A
	CPI  R18,58
	BRLO _0x204002B
_0x204002A:
	RJMP _0x2040029
_0x204002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x204001B
_0x2040029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x204002F
	CALL SUBOPT_0x15
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x16
	RJMP _0x2040030
_0x204002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2040032
	CALL SUBOPT_0x15
	CALL SUBOPT_0x17
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2040033
_0x2040032:
	CPI  R30,LOW(0x70)
	BRNE _0x2040035
	CALL SUBOPT_0x15
	CALL SUBOPT_0x17
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2040036
_0x2040035:
	CPI  R30,LOW(0x64)
	BREQ _0x2040039
	CPI  R30,LOW(0x69)
	BRNE _0x204003A
_0x2040039:
	ORI  R16,LOW(4)
	RJMP _0x204003B
_0x204003A:
	CPI  R30,LOW(0x75)
	BRNE _0x204003C
_0x204003B:
	LDI  R30,LOW(_tbl10_G102*2)
	LDI  R31,HIGH(_tbl10_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x204003D
_0x204003C:
	CPI  R30,LOW(0x58)
	BRNE _0x204003F
	ORI  R16,LOW(8)
	RJMP _0x2040040
_0x204003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2040071
_0x2040040:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x204003D:
	SBRS R16,2
	RJMP _0x2040042
	CALL SUBOPT_0x15
	CALL SUBOPT_0x18
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2040043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2040043:
	CPI  R20,0
	BREQ _0x2040044
	SUBI R17,-LOW(1)
	RJMP _0x2040045
_0x2040044:
	ANDI R16,LOW(251)
_0x2040045:
	RJMP _0x2040046
_0x2040042:
	CALL SUBOPT_0x15
	CALL SUBOPT_0x18
_0x2040046:
_0x2040036:
	SBRC R16,0
	RJMP _0x2040047
_0x2040048:
	CP   R17,R21
	BRSH _0x204004A
	SBRS R16,7
	RJMP _0x204004B
	SBRS R16,2
	RJMP _0x204004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x204004D
_0x204004C:
	LDI  R18,LOW(48)
_0x204004D:
	RJMP _0x204004E
_0x204004B:
	LDI  R18,LOW(32)
_0x204004E:
	CALL SUBOPT_0x14
	SUBI R21,LOW(1)
	RJMP _0x2040048
_0x204004A:
_0x2040047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x204004F
_0x2040050:
	CPI  R19,0
	BREQ _0x2040052
	SBRS R16,3
	RJMP _0x2040053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2040054
_0x2040053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2040054:
	CALL SUBOPT_0x14
	CPI  R21,0
	BREQ _0x2040055
	SUBI R21,LOW(1)
_0x2040055:
	SUBI R19,LOW(1)
	RJMP _0x2040050
_0x2040052:
	RJMP _0x2040056
_0x204004F:
_0x2040058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x204005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x204005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x204005A
_0x204005C:
	CPI  R18,58
	BRLO _0x204005D
	SBRS R16,3
	RJMP _0x204005E
	SUBI R18,-LOW(7)
	RJMP _0x204005F
_0x204005E:
	SUBI R18,-LOW(39)
_0x204005F:
_0x204005D:
	SBRC R16,4
	RJMP _0x2040061
	CPI  R18,49
	BRSH _0x2040063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2040062
_0x2040063:
	RJMP _0x20400CD
_0x2040062:
	CP   R21,R19
	BRLO _0x2040067
	SBRS R16,0
	RJMP _0x2040068
_0x2040067:
	RJMP _0x2040066
_0x2040068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2040069
	LDI  R18,LOW(48)
_0x20400CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x204006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x16
	CPI  R21,0
	BREQ _0x204006B
	SUBI R21,LOW(1)
_0x204006B:
_0x204006A:
_0x2040069:
_0x2040061:
	CALL SUBOPT_0x14
	CPI  R21,0
	BREQ _0x204006C
	SUBI R21,LOW(1)
_0x204006C:
_0x2040066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2040059
	RJMP _0x2040058
_0x2040059:
_0x2040056:
	SBRS R16,0
	RJMP _0x204006D
_0x204006E:
	CPI  R21,0
	BREQ _0x2040070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x16
	RJMP _0x204006E
_0x2040070:
_0x204006D:
_0x2040071:
_0x2040030:
_0x20400CC:
	LDI  R17,LOW(0)
_0x204001B:
	RJMP _0x2040016
_0x2040018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x19
	SBIW R30,0
	BRNE _0x2040072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2100001
_0x2040072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x19
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G102)
	LDI  R31,HIGH(_put_buff_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G102
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2100001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG
_bcd2bin:
; .FSTART _bcd2bin
	ST   -Y,R26
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret
; .FEND
_bin2bcd:
; .FSTART _bin2bcd
	ST   -Y,R26
    ld   r26,y+
    clr  r30
bin2bcd0:
    subi r26,10
    brmi bin2bcd1
    subi r30,-16
    rjmp bin2bcd0
bin2bcd1:
    subi r26,-10
    add  r30,r26
    ret
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG

	.DSEG
_h4:
	.BYTE 0x2
_m4:
	.BYTE 0x2
_buffer:
	.BYTE 0x10
_h:
	.BYTE 0x1
_m:
	.BYTE 0x1
_s:
	.BYTE 0x1
_n_led:
	.BYTE 0x1
_start_time:
	.BYTE 0x1
_alarm:
	.BYTE 0x1
_flag:
	.BYTE 0x2
_flag1:
	.BYTE 0x2
_flag2:
	.BYTE 0x2
_flag3:
	.BYTE 0x2
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G103:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(800)
	LDI  R27,HIGH(800)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(200)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:133 WORDS
SUBOPT_0x2:
	ST   -Y,R4
	ST   -Y,R6
	MOV  R26,R8
	CALL _rtc_set_time
	LDI  R30,LOW(_h)
	LDI  R31,HIGH(_h)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_m)
	LDI  R31,HIGH(_m)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_s)
	LDI  R27,HIGH(_s)
	CALL _rtc_get_time
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_h
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_m
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_s
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	CALL _lcd_puts
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x4:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,42
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R10
	CALL __CWD1
	CALL __PUTPARD1
	MOVW R30,R12
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	MOVW R30,R4
	ADD  R30,R10
	ADC  R31,R11
	STS  _h4,R30
	STS  _h4+1,R31
	MOVW R30,R6
	ADD  R30,R12
	ADC  R31,R13
	STS  _m4,R30
	STS  _m4+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDS  R26,_flag
	LDS  R27,_flag+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDS  R26,_h4
	LDS  R27,_h4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CALL __MODW21
	LDS  R26,_h
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDS  R26,_m4
	LDS  R27,_m4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __MODW21
	LDS  R26,_m
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	RCALL SUBOPT_0x7
	ADD  R26,R30
	ADC  R27,R31
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	RCALL SUBOPT_0x9
	ADD  R26,R30
	ADC  R27,R31
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	CALL _lcd_gotoxy
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	CALL _i2c_start
	LDI  R26,LOW(208)
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	CALL _i2c_write
	JMP  _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDI  R26,LOW(1)
	CALL _i2c_read
	MOV  R26,R30
	JMP  _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G101
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x14:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x15:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x17:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
	.equ __sda_bit=1
	.equ __scl_bit=0
	.equ __i2c_port=0x15 ;PORTC
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,13
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,27
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
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

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
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

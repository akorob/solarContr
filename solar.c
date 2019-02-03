/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Evaluation
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 09.09.2013
Author  : Freeware, for evaluation and non-commercial use only
Company : 
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 1,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>

#include <delay.h>

#define seg_a PORTD.3
#define seg_b PORTB.0
#define seg_c PORTD.5
#define seg_d PORTD.7
#define seg_e PORTB.6
#define seg_f PORTD.2
#define seg_g PORTB.7
#define seg_h PORTD.6
#define com_cat1 PORTB.4
#define com_cat2 PORTB.5
#define com_cat3 PORTB.3

#define panel_sw PORTB.1
#define load_sw PORTB.2
#define load_led PORTD.4
#define panel_led PORTD.1


// Declare your global variables here
unsigned int voltage;
unsigned int TOP = 0x02ff; //ICR1H + ICR1L
unsigned int GOAL = 1360;
unsigned int DELTA_GOAL = 2; 

// ADC interrupt service routine
interrupt [ADC_INT] void adc_isr(void)
{
        unsigned int  adc_data; 
        unsigned int  counter_value;
        unsigned int delta;
        adc_data = ADCW; 
        voltage = (long int)adc_data*1000/366; 
        
        counter_value = OCR1A;    
        if (voltage > GOAL + DELTA_GOAL){ 
            delta = voltage - GOAL;
            if ( delta > 100) {
                counter_value-=20;
            } else if (delta > 50){
                counter_value-=5;
            }
            else if (delta > 20) {
                counter_value-=2;
            } else { 
                counter_value-=1;
            }
            
            if (counter_value == 0 || counter_value > 0x3333) {
               counter_value = 0; 
            }
            OCR1A = counter_value; 
        } 
         
        if (voltage < GOAL + DELTA_GOAL){
            delta = GOAL - voltage;
            if ( delta > 100) {
                counter_value+=20;
            } else if (delta > 50){
                counter_value+=5;
            }
            else if (delta > 20) {
                counter_value+=2;
            } else { 
                counter_value+=1;
            }
            
            if (counter_value > TOP) {
               counter_value = TOP; 
            } 
            OCR1A = counter_value; 
            //panel_led = 0;
            //panel_sw = 1;
        } 
        
         if (voltage > 1250){
            load_led = 0;
            load_sw = 1; 
        }
        
        if (voltage < 1200){
            load_led = 1;
            load_sw = 0; 
        } 
}




void set_leds (char digit, char pos, char comma);



void set_leds (char digit, char pos, char comma){
    #asm("cli")
    switch (pos){       
        case 1:
        com_cat1=1; com_cat2=0; com_cat3=0;
        break;

        case 2:
        com_cat1=0; com_cat2=1; com_cat3=0;
        break;

        case 3:
        com_cat1=0; com_cat2=0; com_cat3=1;
        break;
    }

    if (comma==1) seg_h=1; else seg_h=0;

    switch (digit){
        case 1:
            seg_a=0; seg_b=1; seg_c=1; seg_d=0; seg_e=0; seg_f=0; seg_g=0; 
            break;
        case 2:
            seg_a=1; seg_b=1; seg_c=0; seg_d=1; seg_e=1; seg_f=0; seg_g=1 ;
            break;
        case 3:
            seg_a=1; seg_b=1; seg_c=1; seg_d=1; seg_e=0; seg_f=0; seg_g=1; 
            break;
        case 4:
            seg_a=0; seg_b=1; seg_c=1; seg_d=0; seg_e=0; seg_f=1; seg_g=1; 
            break;
        case 5:
            seg_a=1; seg_b=0; seg_c=1; seg_d=1; seg_e=0; seg_f=1; seg_g=1; 
            break;
        case 6:
            seg_a=1; seg_b=0; seg_c=1; seg_d=1; seg_e=1; seg_f=1; seg_g=1; 
            break;
        case 7:
            seg_a=1; seg_b=1; seg_c=1; seg_d=0; seg_e=0; seg_f=0; seg_g=0; 
            break;
        case 8:
            seg_a=1; seg_b=1; seg_c=1; seg_d=1; seg_e=1; seg_f=1; seg_g=1; 
            break;
        case 9:
            seg_a=1; seg_b=1; seg_c=1; seg_d=1; seg_e=0; seg_f=1; seg_g=1; 
            break;
        case 0:
            seg_a=1; seg_b=1; seg_c=1; seg_d=1; seg_e=1; seg_f=1; seg_g=0; 
            break;
        case 10:    //switch off
            seg_a=0; seg_b=0; seg_c=0; seg_d=0; seg_e=0; seg_f=0; seg_g=0; seg_h=0; 
            break;
    }
    #asm("sei")
}



void main(void){
    // Declare your local variables here
    char led_delay = 69;
    unsigned int volt_for_displ;

    // Input/Output Ports initialization
    // Port B initialization
    // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
    // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
    PORTB=0x00;
    DDRB=0xFF;

    // Port C initialization
    // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out 
    // State6=T State5=T State4=P State3=P State2=P State1=0 State0=0 
    PORTC=0b00011110;
    DDRC=0x03;

    // Port D initialization
    // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
    // State7=0 State6=0 State5=0 State4=1 State3=1 State2=0 State1=0 State0=1 
    PORTD=0b00011001;
    DDRD=0xFF;   
    
   // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: 4000,000 kHz
    // Mode: Ph. correct PWM top=ICR1
    // OC1A output: Non-Inverted PWM
    // OC1B output: Disconnected
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer Period: 0,5 ms
    // Output Pulse(s):
    // OC1A Period: 0,5 ms Width: 0,05 ms
    // Timer1 Overflow Interrupt: Off
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off
    // Compare B Match Interrupt: Off
    TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (1<<WGM11) | (0<<WGM10);
    TCCR1B=(0<<ICNC1) | (0<<ICES1) | (1<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
    TCNT1H=0x00;
    TCNT1L=0x00;
    ICR1H=0x02;
    ICR1L=0xFF;
    OCR1AH=0x00;
    OCR1AL=0x10;
    OCR1BH=0x00;
    OCR1BL=0x00;
    
   // ADC initialization
    // ADC Clock frequency: 7,813 kHz
    // ADC Voltage Reference: AVCC pin
    ADMUX=(0<<REFS1) | (1<<REFS0) | (0<<ADLAR)| (0<<MUX3) | (1<<MUX2) | (0<<MUX1) | (1<<MUX0);
    ADCSRA=(1<<ADEN) | (1<<ADSC) | (1<<ADFR) | (1<<ADIF) | (1<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);  
    
    SFIOR=(0<<ACME);


    delay_ms(100);
    
    // Global enable interrupts
    #asm("sei")
    
    for (;;){            
        unsigned int volt_tmp;
        char tis;
        char sot;
        char des;
        char ed;
        
        if (++led_delay == 70){
            volt_for_displ = voltage;
            led_delay = 0;
        }   
        
        volt_tmp = volt_for_displ;
        tis = volt_tmp/1000;  
        volt_tmp = volt_tmp - (int)tis*1000; 
        sot = volt_tmp/100;
        volt_tmp=volt_tmp-(int)sot*100;
        des=volt_tmp/10;
        volt_tmp=volt_tmp-(int)des*10;
        ed=volt_tmp;
         
        set_leds(ed, 1, 0);   
        delay_ms(1);
        set_leds(des, 2, 0); 
        delay_ms(1);
        set_leds(sot, 3, 1);
        delay_ms(1); 
        set_leds(10, 3, 0);
        delay_ms(1);  
    }
}
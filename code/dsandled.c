/*******************************************************
Chip type               : ATmega16A
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/
#include <mega16a.h>
// I2C Bus functions
#include <i2c.h>
// DS1307 Real Time Clock functions
#include <ds1307.h>
// Alphanumeric LCD functions
#include <alcd.h>
#include <alcd.h>  
#include <delay.h>
#include <stdio.h>
#include <stdlib.h>

#define down PINB.4
#define up PINB.3
#define ok_time PINB.5
#define ok PINB.0         //
#define offled PINB.7     //simulation 

#define led1 PORTD.0
 
// Declare your global variables here

int hh=0,mm=0,ss=0;
int h3=0,m3=0,h4=1,m4=10;
char buffer[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},h=0,m=0,s=0;
char n_led = 0;
char start_time = 0;
char alarm;
int flag=0;
int flag1=0;
int flag2=0;
int flag3=0;
void main(void)
{

// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Bit-Banged I2C Bus initialization
// I2C Port: PORTC
// I2C SDA bit: 1
// I2C SCL bit: 0
// Bit Rate: 100 kHz
// Note: I2C settings are specified in the
// Project|Configure|C Compiler|Libraries|I2C menu.
i2c_init();

// DS1307 Real Time Clock initialization
// Square wave output on pin SQW/OUT: Off
// SQW/OUT pin state: 0
rtc_init(0,0,0);

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTA Bit 0
// RD - PORTA Bit 1
// EN - PORTA Bit 2
// D4 - PORTA Bit 4
// D5 - PORTA Bit 5
// D6 - PORTA Bit 6
// D7 - PORTA Bit 7
// Characters/line: 16
lcd_init(16);


while (1)     
      {     
    
             if ( ok_time == 0 )        //set Time
            {
                delay_ms(800);
                if ( ok_time == 0)
                {    
                    start_time = 1;
                    while ( start_time == 1)
                    {                       //set hour  
                    if(up == 0)
                        {delay_ms(200);
                        hh++;
                        if( hh == 24 ) hh=0; }
                    if(down == 0)
                        {delay_ms(200);
                        if( hh == 0 ) hh=23;
                        else hh--;   }  
                      rtc_set_time(hh,mm,ss);  
                      
                      rtc_get_time(&h,&m,&s);
                      lcd_clear();
                      lcd_gotoxy(0,0);
                      sprintf(buffer,"%d:%d:%d",h,m,s);                      
                      lcd_puts(buffer);                                      
                              lcd_gotoxy(0,1);
                              sprintf(buffer,"set hour");
                              lcd_puts(buffer); 
                             
                      delay_ms(100);
                    if ( ok_time == 0 )
                      {
                      delay_ms(800);
                      if ( ok_time == 0)
                      { 
                        while ( start_time == 1)
                        {                         //set minute
                                if(up == 0)
                                {delay_ms(200);
                                mm++;
                                if( mm == 60 ) mm=0;} 
                            if(down == 0)
                                {delay_ms(200);
                                if( mm == 0 ) mm=59;
                                else mm--; }
                              rtc_set_time(hh,mm,ss);  
                              
                              rtc_get_time(&h,&m,&s);
                              lcd_clear();
                              lcd_gotoxy(0,0);
                               sprintf(buffer,"%d:%d:%d",h,m,s);   
                               lcd_puts(buffer);
                               lcd_gotoxy(0,1);
                               sprintf(buffer,"set minutes");
                               lcd_puts(buffer); 
                               delay_ms(100);
                            if ( ok_time == 0 )
                            {
                              delay_ms(800);
                              if ( ok_time == 0)
                              {                                //set second
                                while ( start_time == 1)
                                {  
                                    if(up == 0)
                                        {delay_ms(200);
                                        ss++;
                                        if( ss == 60 ) ss=0; }
                                    if(down == 0)
                                        {delay_ms(200);
                                        if( ss == 0 ) ss=59;
                                        else ss--; }  
                                      rtc_set_time(hh,mm,ss);  
                                          
                                      rtc_get_time(&h,&m,&s);
                                      lcd_clear();                  //print Time
                                      lcd_gotoxy(0,0);
                                      sprintf(buffer,"%d:%d:%d",h,m,s);
                                      lcd_puts(buffer);                                     
                                      lcd_gotoxy(0,1);
                                      sprintf(buffer,"set seconds");
                                      lcd_puts(buffer);  
                                      delay_ms(100);
                                    if ( ok_time == 0 )
                                      {
                                      delay_ms(800);
                                      if ( ok_time == 0)
                                        { 
                                        start_time = 0;
                                        } 
                                      }
                                }
                              }
                            }
                        }
                      }           
                    }   
                }
             }
           }                       
            
            //set alarm
            if (ok == 0)
            {    delay_ms(800); 
            if (ok == 0)
             { 
                 alarm=1;                      
                 while (  alarm == 1 )
                 {  
                                if(up == 0)
                                {delay_ms(200);
                                h3++;
                                if( h3 == 13 ) h3=0;} 
                                if(down == 0)
                                {delay_ms(200);
                                if( h3 == 0 ) h3=12;
                                else h3--; }                               
                            lcd_clear();          
                            lcd_gotoxy(0,0);
                            sprintf(buffer,"%d : %d ",h3,m3);
                            lcd_puts(buffer);                                     
                            lcd_gotoxy(0,1);
                            sprintf(buffer,"<set Alarm H>");
                            lcd_puts(buffer);  
                            delay_ms(100);
                                        
                         if ( ok == 0 )
                        {
                             delay_ms(800);
                             if ( ok == 0)
                            {                                //set Alarm Minute
                                while ( alarm == 1)
                                {  
                                        if(up == 0)
                                        {delay_ms(200);
                                        m3++;
                                        if( m3 == 60 )   {m3=0;h3++;if(h3==24){h3=0;}}     
                                        }
                                    if(down == 0)
                                        {delay_ms(200);
                                        if( m3 == 0 ) m3=60;
                                        else m3--; }  
                                      
                                        lcd_clear();          
                                        lcd_gotoxy(0,0);
                                        sprintf(buffer,"%d : %d ",h3,m3);
                                        lcd_puts(buffer);                                     
                                        lcd_gotoxy(0,1);
                                        sprintf(buffer,"<set Alarm M>");
                                        lcd_puts(buffer);  
                                        delay_ms(100);
                                  
                                      if ( ok == 0 )
                                      {
                                      delay_ms(800);
                                        if ( ok == 0)
                                        { 
                                        alarm=0;
                                        h4=h3+hh;
                                        m4=m3+mm;
                                        } 
                                      }
                                }
                                                    
                                            
                            }
                        
                        
                      }
                 }                         
                 
             }
            }          
            
            //Get Alarm
            
                if (offled==0 && flag==0)          //if offled switch pressed , then off the LED for 1 minute
                {
                delay_ms(800);
                if (offled==0)   flag=1;      
                } 
                
                if (n_led==1 && flag==1)  
                {
                flag1=1; 
                } 

                if (n_led==2 && flag1==1 && offled==0)  
                {
                delay_ms(800);
                if (offled==0)   {flag1=0;      
                                  flag2=1;  
                                 }                 
                }
                
                if (offled==0 && n_led==3 && flag2==1)  
                {
                delay_ms(800);
                if (offled==0)   {flag3=1;      
                                  flag2=0;  
                                 }                 
                }   
                
                
                if (offled==0 && n_led==4 && flag3==1)  
                {
                delay_ms(800);
                if (offled==0)   {flag3=0;      
                                  flag=0;
                                  n_led=0;    
                                  h4=h3+hh;
                                  m4=m3+mm;       
                                 }                 
                } 
 
                            
            if ( h==h4%24 && m==m4%60 && flag==0 )
            {
               if(offled==1)   {
                                led1=1; 
                              }
               n_led=1;

            } 
            else if ( h==((h4+h3)%24) && m==((m4+m3)%60) && flag1==1 )
            {
                  if(offled==1)   
                            {
                            led1=1;         
                            }
               n_led=2;
            }                
            else if ( h==((h4+h3*2)%24) && m==((m4+m3*2)%60 ) && flag2==1)
            {
               if(offled==1)   {
                            led1=1;         
                           }
               n_led=3;
            }
            else if ( h==((h4+h3*3)%24) && m==((m4+m3*3)%60 ) && flag3==1 && n_led>=3)
            {                                                                             //for alarms less than 8 hours
               if(offled==1)   {
                                       
                    led1=1;         
                            
                           }
               n_led=4;
               flag=0;
            }
            else {
                    led1=0;
                 } 
                       
                                //printing The Time
                     
          rtc_get_time(&h,&m,&s);
          lcd_clear();
          lcd_gotoxy(0,0);
          sprintf(buffer,"%d:%d:%d",h,m,s); 
          lcd_puts(buffer); 
        if(led1==1)
        {
            lcd_gotoxy(0,1);
            sprintf(buffer,"alarm");
            lcd_puts(buffer);  
        }
        else
        {
            lcd_gotoxy(0,1);
            sprintf(buffer,"");
            lcd_puts(buffer);  
        }
          delay_ms(100);
                  
    }
}
      
          
#include <lpc214x.h>
#include <Stdio.h> 
#include "lcd.h"
unsigned int adc_value=0,temp_adc=0;
float adc_ip;
char var[15],var1[15];
char *ptr2;
char arr[]= "ADC O/P= ";
char *ptr1,dis[]="A I/P  = ";
#define vol 3.3               	//Reference voltage
#define fullscale 0x3ff         //10 bit adc
int main()
{					    
	PINSEL1 = 0X00040000;   	//AD0.4 pin is selected(P0.25)
	IO0DIR = 0x000000FC;    	//configure o/p lines for lcd  
	lcd_init();				//LCD initialization  
  	delay(3200);
	ptr2 = dis;
	temp1 = 0x80;	//Display starting address	of first line 1 th pos
	lcd_com();
	delay(800); 
  	while(*ptr2!='\0')
  	 {
   	 temp1 = *ptr2;
   	  lcd_data();
	 ptr2++;
	} 
	ptr1 = arr;
	temp1 = 0xC0;		//Display starting address of second line 4 th pos
	lcd_com();
	delay(800); 
   	while(*ptr1!='\0')
   	 {
	     temp1 = *ptr1;
	     lcd_data();
	     ptr1 ++;
	 }
    //infinite loop	
    while(1)
     {			 
   //CONTROL register for ADC
   A0CR = 0x01200010;     	//command register for ADC-AD0.4
   while(((temp_adc = AD0GDR) &0x80000000)  == 0x00000000);//to check the interrupt bit
		   adc_value = AD0GDR;       //reading the ADC value
		   adc_value >>=6;
		   adc_value &= 0x000003ff;
		   adc_ip = ((float)adc_value * (float)vol)/(float)fullscale;
		   sprintf(var1,"%4.2fV",adc_ip);
		   sprintf(var,"%3x",adc_value); 		
	       temp1 = 0x89;
	 	   lcd_com();
	 	   delay(1200); 
	 	   ptr2 = var1;
		   while(*ptr2!='\0')
        {	        
  			  temp1=*ptr2;
			    lcd_data();	
          ptr2++;
		    }                  
       temp1 = 0xc9;
       lcd_com();
       delay(1200);
			 ptr1 = var;
       while(*ptr1!='\0')
        {	 	
        	temp1=*ptr1;
	    		lcd_data();
          ptr1++;
		    }       
	    }	 // end of while(1)		
} //end of main()
  

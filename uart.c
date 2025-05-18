#include<lpc214x.h>
const char *msg ="hello world"
int main(void)
{
    PINSEL0 = 0x00000005;
    U0LCR = 0x83;         
    U0DLM = 0x00;        
    U0DLL = 0x13;     
    U0LCR = 0x03;         
    while(1)
    {
        while(!(U0LSR & 0x20));
        U0THR = *msg;
        msg++;
    }
}

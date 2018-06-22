#include <avr/io.h>

#define F_CPU 16000000UL
#include <util/delay.h>

#include <stdint.h>
#include <stdbool.h>

static char LEDpins[] = {
    PD2, PD3, PD4, PD5, PD6,
    PB0, PB1, PB2, PB3, PB4
};

int main()
{
    // Set All pins on Port B and D to out
    DDRB = 0xFF;
    DDRD = 0xFF;

    bool direction = true;

    int i = 0;
    int p = 0;
    while (1)
    {
        if (i != p)
        {
            if (p < 5)
            {
                PORTD ^= (1 << LEDpins[p]);
            } else {
                PORTB ^= (1 << LEDpins[p]);
            }
        }

        if (i < 5)
        {
            PORTD ^= (1 << LEDpins[i]);
        } else {
            PORTB ^= (1 << LEDpins[i]);
        }

        p = i;
        if (direction) 
        {
            i++;
            if (i > 9)
            {
                direction = false;
                i = 8;
            }
        }
        else 
        {
            i--;
            if (i < 0)
            {
                direction = true;
                i = 1;
            }
        }
        _delay_ms(100);
    }
}

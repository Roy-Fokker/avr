#include <avr/io.h>

#define F_CPU 16000000UL
#include <util/delay.h>

#include <stdint.h>
#include <stdbool.h>

typedef unsigned char pin_no_t;
typedef volatile unsigned char *port_t;

static pin_no_t LEDpins[] = {
    PD2, PD3, PD4, PD5, PD6,
    PB0, PB1, PB2, PB3, PB4
};

static void toggle_pin(port_t port, pin_no_t pin)
{
    *port ^= (1 << pin);
}

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
            toggle_pin((p < 5) ? &PORTD : &PORTB, LEDpins[p]);
            // if (p < 5)
            // {
            //     PORTD ^= (1 << LEDpins[p]);
            // } else {
            //     PORTB ^= (1 << LEDpins[p]);
            // }
        }

        toggle_pin((i < 5) ? &PORTD : &PORTB, LEDpins[i]);
        // if (i < 5)
        // {
        //     PORTD ^= (1 << LEDpins[i]);
        // } else {
        //     PORTB ^= (1 << LEDpins[i]);
        // }

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

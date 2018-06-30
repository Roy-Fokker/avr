#include <avr/io.h>

#define F_CPU 16000000UL
#include <util/delay.h>

typedef unsigned char pin_no_t;
typedef volatile unsigned char *port_t;

void toggle_pin(port_t port, pin_no_t pin)
{
    *port ^= (1 << pin);
}

int main()
{
    DDRB |= (1 << PB0);

    while (1)
    {
        //PORTB ^= (1 << PB5);
        toggle_pin(&PORTB, PB0);
        _delay_ms(1000);
    }
}

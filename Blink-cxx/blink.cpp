#include <avr/io.h>

#define F_CPU 16000000UL
#include <util/delay.h>

#include <stdint.h>

namespace UNO
{
    using register_address = volatile uint8_t *;
    constexpr uint8_t _sfr_offset { 0x20 };

    enum class Port : uint8_t
    {
        B = 0x05,
        C = 0x08, 
        D = 0x0B
    };

    enum class Direction_Register : uint8_t
    {
        B = 0x04,
        C = 0x07, 
        D = 0x0A
    };

    enum class Pin : uint8_t
    {
        _0, _1, _2, _3, _4, _5, _6, _7
    };

    enum class Data_Direction : uint8_t
    {
        Input = 0,
        Output = 1
    };

    class IO
    {
    public:
        explicit IO(Port port_) :
            port{port_},
            dr{(static_cast<uint8_t>(port) - 0x01)}
        {
        };
        ~IO()
        {
        };

        void set_pin_mode(Pin pin, Data_Direction direction)
        {
            auto const dir_reg { reinterpret_cast<register_address>(static_cast<uint8_t>(dr) + _sfr_offset)};

            *dir_reg |= (1 << static_cast<uint8_t>(pin));
        };

        void toggle_pin(Pin pin)
        {
            auto const port_pin { reinterpret_cast<register_address>(static_cast<uint8_t>(port) + _sfr_offset)};

            *port_pin ^= (1 << static_cast<uint8_t>(pin));
        };

    private:
        Port port {};
        Direction_Register dr {};
    };
}

int main()
{
    UNO::IO uno(UNO::Port::B);

    uno.set_pin_mode(UNO::Pin::_0, UNO::Data_Direction::Output);

    while(true)
    {
        uno.toggle_pin(UNO::Pin::_0);
        _delay_ms(1000);
    }
}

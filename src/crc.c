#include "crc.h"

static unsigned short int crc16_table[256];
static unsigned int crc32_table[256];

// Initialize CRC-32 lookup table
void InitCRC32LookupTable(void)
{
    unsigned int crc;
    int i, j;

    for (i = 0; i < 256; i++)
    {
        crc = i;
        for (j = 0; j < 8; j++)
        {
            if (crc & 1)
                crc = (crc >> 1) ^ CRC32_POLYNOMIAL;
            else
                crc >>= 1;
        }
        crc32_table[i] = crc;
    }
}

// Calculate CRC-32
unsigned int CalculateCRC32(unsigned char *buffer, unsigned int length, unsigned int InitialChecksum)
{
    unsigned int crc = InitialChecksum, i;

    for (i = 0; i < length; i++)
    {
        crc = (crc >> 8) ^ crc32_table[(crc & 0xFF) ^ buffer[i]];
    }

    return crc;
}

unsigned int ReflectAndXORCRC32(unsigned int crc)
{
    return crc ^ CRC32_FINAL_XOR_VALUE;
}

void InitCRC16LookupTable(void)
{
    int i, j;
    unsigned short int crc;

    for (i = 0; i < 256; i++)
    {
        crc = (i << 8);
        for (j = 0; j < 8; j++)
            crc = (crc << 1) ^ ((crc & 0x8000) ? CRC16_POLYNOMIAL : 0);
        crc16_table[i] = crc & 0xFFFF;
    }
}

#define REFLECT_DATA(x)      ((unsigned char)reflect(x, 8))
#define REFLECT_REMAINDER(x) (reflect(x, 16))

static unsigned short int reflect(unsigned short int data, unsigned char nBits)
{
    unsigned short int reflection;
    unsigned char bit;

    reflection = 0;

    /* Reflect the data about the center bit. */
    for (bit = 0; bit < nBits; bit++)
    {
        /* If the LSB bit is set, set the reflection of it. */
        if (data & 1)
            reflection |= (1 << ((nBits - 1) - bit));

        data >>= 1;
    }

    return reflection;
}

unsigned short int CalculateCRC16(unsigned char *buffer, unsigned int length, unsigned short int InitialChecksum)
{
    unsigned short int crc16checksum;
    unsigned int i;

    crc16checksum = InitialChecksum;
    for (i = 0; i < length; i++)
    {
        crc16checksum = crc16_table[(((crc16checksum) >> 8) ^ REFLECT_DATA(buffer[i])) & 0xFF] ^ ((crc16checksum) << 8);
        crc16checksum &= 0xFFFF;
    }

    return crc16checksum;
}

unsigned short int ReflectAndXORCRC16(unsigned short int crc)
{
    return (REFLECT_REMAINDER(crc) ^ CRC16_FINAL_XOR_VALUE);
}

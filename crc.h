#define CRC16_POLYNOMIAL       0x8005
#define CRC16_INITIAL_CHECKSUM 0x0
#define CRC16_FINAL_XOR_VALUE  0x0
#define CRC32_POLYNOMIAL       0xEDB88320

void InitCRC16LookupTable(void);
unsigned short int CalculateCRC16(unsigned char *buffer, unsigned int length, unsigned short int InitialChecksum);
unsigned short int ReflectAndXORCRC16(unsigned short int crc);

void InitCRC32LookupTable(void);
unsigned int CalculateCRC32(unsigned char *buffer, unsigned int length, unsigned int InitialChecksum);

// #define DEBUG	1


#ifdef EE_UART
#include <SIOCookie.h>
#define DEBUG_INIT_PRINTF() ee_sio_start(38400, 0, 0, 0, 0, 1)
#else
#define DEBUG_INIT_PRINTF()
#endif

#ifdef DEBUG
#define DEBUG_PRINTF(args...) printf(args)
#else
#define DEBUG_PRINTF(args...)
#endif

#ifdef COH_SUPPORT
#define EXTRAVER "-COH"
#endif
#define PS2IDENT_VERSION "0.900" EXTRAVER

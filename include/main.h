// #define DEBUG	1


#ifdef EE_UART
#include <SIOCookie.h>
#define DEBUG_INIT_PRINTF() ee_sio_start(38400, 0, 0, 0, 0, 1)
#else
#define DEBUG_INIT_PRINTF()
#endif

#ifdef DEBUG
#include <sio.h>
#define DEBUG_PRINTF(args...) do { \
    printf(args); \
    sio_printf(args); \
} while (0)
#else
#define DEBUG_PRINTF(args...)
#endif

#ifdef COH_SUPPORT
#define PS2IDENT_VERSION "0.900-COH"
#else
#define PS2IDENT_VERSION "0.900"
#endif

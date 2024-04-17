// #define DEBUG	1
#ifdef DEBUG
#define DEBUG_PRINTF(args...) printf(args)
#else
#define DEBUG_PRINTF(args...)
#endif

#ifdef COH_SUPPORT
#define EXTRAVER "-COH"
#endif
#define PS2IDENT_VERSION "0.900" EXTRAVER

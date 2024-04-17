#Enable to build support for the TOOL's host interface
DSNET_HOST_SUPPORT ?= 0
DEBUG ?= 0
COH ?= 0

EE_SIO ?= 0
DISABLE_ILINK_DUMPING ?= 0

EE_BIN = PS2Ident_np.elf
EE_PACKED_BIN = PS2Ident.elf


EE_OBJS_DIR = obj/
EE_SRC_DIR = src/
EE_INC_DIR = include

#IOP modules
EE_IOP_OBJS = SIO2MAN_irx.o MCMAN_irx.o MCSERV_irx.o PADMAN_irx.o POWEROFF_irx.o PS2DEV9_irx.o USBD_irx.o BDM_irx.o BDMFS_FATFS_irx.o USBMASS_BD_irx.o USBHDFSDFSV_irx.o SYSMAN_irx.o IOPRP_img.o

EE_GRAPHICS_OBJS = buttons.o devices.o background_img.o font_Default.o
EE_OBJS = main.o system.o UI.o menu.o ident.o SYSMAN_rpc.o graphics.o font.o pad.o DeviceSupport.o crc.o libcdvd_add.o OSDInit.o modelname.o dvdplayer.o ps1.o $(EE_IOP_OBJS) $(EE_GRAPHICS_OBJS)

EE_OBJS := $(EE_OBJS:%=$(EE_OBJS_DIR)%)

EE_INCS := -I$(PS2SDK)/ports/include -I$(PS2SDK)/ports/include/freetype2 -I$(EE_INC_DIR)
EE_LDFLAGS := -L$(PS2SDK)/ports/lib
EE_LIBS := -lgs -lpng -lz -lcdvd -lmc -lpadx -lpatches -liopreboot -lfreetype -lm
EE_CFLAGS += $(EE_GPVAL) -Wno-missing-braces -O0 -g

EE_TEMP_FILES = SIO2MAN_irx.c MCMAN_irx.c MCSERV_irx.c PADMAN_irx.c POWEROFF_irx.c PS2DEV9_irx.c USBD_irx.c BDM_irx.c BDMFS_FATFS_irx.c USBMASS_BD_irx.c USBHDFSDFSV_irx.c SYSMAN_irx.c buttons.c devices.c background_img.c font_Default.c IOPRP_img.c

ifeq ($(DSNET_HOST_SUPPORT),1)
  EE_CFLAGS += -DDSNET_HOST_SUPPORT
  DEBUG = 1
endif

ifeq ($(DEBUG),1)
  IOP_CFLAGS += -DDEBUG
  EE_CFLAGS += -DDEBUG
endif

ifeq ($(EE_SIO),1)
  EE_CFLAGS += -DEE_UART
  EE_LIBS += -lsiocookie
endif

ifeq ($(COH),1)
  EE_CFLAGS += -DCOH_SUPPORT -DDISABLE_LIBCGLUE_INIT
  IOPRP_BIN = irx/ioprp_coh.img
else
  IOPRP_BIN = irx/ioprp.img
endif

ifeq ($(DISABLE_ILINK_DUMPING),1)
  IOP_CFLAGS += -DDISABLE_ILINK_DUMPING
  EE_CFLAGS += -DDISABLE_ILINK_DUMPING
endif

$(EE_PACKED_BIN): $(EE_BIN)
	ps2-packer $(EE_BIN) $(EE_PACKED_BIN)

all:
	$(MAKE) $(EE_PACKED_BIN)

clean:
	make clean -C sysman
	make clean -C usbhdfsdfsv
	rm -f $(EE_BIN) $(EE_PACKED_BIN) $(EE_BIN_REL) $(EE_OBJS) $(EE_TEMP_FILES)

SIO2MAN_irx.c:
	bin2c $(PS2SDK)/iop/irx/freesio2.irx SIO2MAN_irx.c SIO2MAN_irx

MCMAN_irx.c:
	bin2c $(PS2SDK)/iop/irx/mcman.irx MCMAN_irx.c MCMAN_irx

MCSERV_irx.c:
	bin2c $(PS2SDK)/iop/irx/mcserv.irx MCSERV_irx.c MCSERV_irx

PADMAN_irx.c:
	bin2c $(PS2SDK)/iop/irx/freepad.irx PADMAN_irx.c PADMAN_irx

POWEROFF_irx.c:
	bin2c $(PS2SDK)/iop/irx/poweroff.irx POWEROFF_irx.c POWEROFF_irx

PS2DEV9_irx.c:
	bin2c $(PS2SDK)/iop/irx/ps2dev9.irx PS2DEV9_irx.c PS2DEV9_irx

USBD_irx.c:
	bin2c $(PS2SDK)/iop/irx/usbd.irx USBD_irx.c USBD_irx

BDM_irx.c:
	bin2c $(PS2SDK)/iop/irx/bdm.irx BDM_irx.c BDM_irx

BDMFS_FATFS_irx.c:
	bin2c $(PS2SDK)/iop/irx/bdmfs_fatfs.irx BDMFS_FATFS_irx.c BDMFS_FATFS_irx

USBMASS_BD_irx.c:
	bin2c $(PS2SDK)/iop/irx/usbmass_bd.irx USBMASS_BD_irx.c USBMASS_BD_irx

USBHDFSDFSV_irx.c:
	$(MAKE) -C usbhdfsdfsv
	# bin2c irx/usbhdfsdfsv.irx USBHDFSDFSV_irx.c USBHDFSDFSV_irx
	bin2c usbhdfsdfsv/usbhdfsdfsv.irx USBHDFSDFSV_irx.c USBHDFSDFSV_irx

SYSMAN_irx.c:
	$(MAKE) -C sysman
	# $(BIN2C) irx/sysman.irx SYSMAN_irx.c SYSMAN_irx
	bin2c sysman/sysman.irx SYSMAN_irx.c SYSMAN_irx

background_img.c:
	bin2c resources/background.png background_img.c background

font_Default.c:
	bin2c resources/NotoSansMono-CondensedBold.ttf font_Default.c font_Default

buttons.c:
	bin2c resources/buttons.png buttons.c buttons

devices.c:
	bin2c resources/devices.png devices.c devices

IOPRP_img.c: $(IOPRP_BIN)
	bin2c $< IOPRP_img.c IOPRP_img


$(EE_OBJS_DIR)%.o: $(EE_SRC_DIR)%.c
	$(DIR_GUARD)
	$(EE_CC) $(EE_CFLAGS) $(EE_INCS) -c $< -o $@

$(EE_OBJS_DIR)%.o: $(EE_ASM_DIR)%.s
	$(DIR_GUARD)
	$(EE_AS) $(EE_ASFLAGS) $< -o $@

include $(PS2SDK)/samples/Makefile.pref
include $(PS2SDK)/samples/Makefile.iopglobal
include $(PS2SDK)/samples/Makefile.eeglobal

EXECUTABLE=STM32F4-Discovery_Demo.elf
BIN_IMAGE=STM32F4-Discovery_Demo.bin

CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy

CFLAGS=-g -O2 -mlittle-endian -mthumb
CFLAGS+=-mcpu=cortex-m4
CFLAGS+=-ffreestanding -nostdlib

#usb_conf.h
CFLAGS+=-DUSE_USB_OTG_FS=1

# to run from FLASH
CFLAGS+=-Wl,-T,stm32_flash.ld

CFLAGS+=-I./

CFLAGS+=-DUSE_STDPERIPH_DRIVER

#STM32F4xx_StdPeriph_Driver\inc
CFLAGS+=-I./stm32f4/STM32F4xx_StdPeriph_Driver/inc
CFLAGS+=-I./stm32f4/CMSIS/ST/STM32F4xx/Include/

# stm32f4_discovery lib
CFLAGS+=-I./stm32f4/STM32F4xx_StdPeriph_Driver/inc
CFLAGS+=-I./stm32f4/STM32F4xx_StdPeriph_Driver/inc/device_support
CFLAGS+=-I./stm32f4/STM32F4xx_StdPeriph_Driver/inc/core_support

CFLAGS+=-I./stm32f4/CMSIS/Include/

#STM32_USB_Device_Library
CFLAGS+=-I./stm32f4/STM32_USB_Device_Library/Class/cdc/inc
CFLAGS+=-I./stm32f4/STM32_USB_Device_Library/Core/inc

#STM32_USB_OTG_Driver
CFLAGS+=-I./stm32f4/STM32_USB_OTG_Driver/inc


#Utilities
CFLAGS+=-I./stm32f4/Utilities/STM32F4-Discovery

# LDFLAGS = -L./stm32f4/STM32F4xx_StdPeriph_Driver/build -lSTM32F4xx_StdPeriph_Driver -L./stm32f4/STM32F_USB_OTG_Driver/build

all: $(BIN_IMAGE)

$(BIN_IMAGE): $(EXECUTABLE)
	$(OBJCOPY) -O binary $^ $@

#stm32f4xx_it.c
$(EXECUTABLE): main.c system_stm32f4xx.c startup_stm32f4xx.s stm32fxxx_it.c \
	usb_bsp.c usbd_desc.c usbd_usr.c usb_core.c usbd_cdc_vcp.c\
	stm32f4_discovery.c \
	./stm32f4/STM32_USB_OTG_Driver/src/usb_dcd_int.c \
	./stm32f4/STM32_USB_OTG_Driver/src/usb_dcd.c \
	./stm32f4/STM32_USB_Device_Library/Core/src/usbd_core.c \
	./stm32f4/STM32_USB_Device_Library/Core/src/usbd_req.c \
	./stm32f4/STM32_USB_Device_Library/Core/src/usbd_ioreq.c \
	./stm32f4/STM32_USB_Device_Library/Class/cdc/src/usbd_cdc_core.c \
	./stm32f4/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rcc.c \
	./stm32f4/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_exti.c \
	./stm32f4/STM32F4xx_StdPeriph_Driver/src/misc.c \
	./stm32f4/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_gpio.c \
	./stm32f4/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_flash.c \
	./stm32f4/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_syscfg.c
	$(CC) $(CFLAGS) $^ -o $@  $(LDFLAGS)

clean:
	rm -rf $(EXECUTABLE)
	rm -rf $(BIN_IMAGE)

.PHONY: all clean

flash: STM32F4-Discovery_Demo.elf
	arm-none-eabi-gdb --command=gdbscript STM32F4-Discovery_Demo.elf


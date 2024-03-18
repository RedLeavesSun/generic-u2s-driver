SHELL := /bin/bash

ifneq ($(KERNELRELEASE),)
obj-m := generic-u2s.o
else
PWD  := $(shell pwd)
KVER := $(shell uname -r)
KDIR := /lib/modules/$(KVER)/build
HAS_USBSERIAL := $(shell lsmod | grep '^usbserial' | awk ' { print $4 } ')
HAS_GENERIC_U2S := $(shell lsmod | grep '^generic_u2s' | awk ' { print $4 } ')
GENERIC_USC_LOAD_AT_BOOT := $(shell grep -r generic_u2s /etc/modules)

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
	rm -f *.cmd *.o *.ko

install:
	cp -f generic-u2s.ko /lib/modules/$(KVER)/kernel/drivers/usb/serial
ifeq ($(HAS_USBSERIAL),)
	insmod /lib/modules/$(KVER)/kernel/drivers/usb/serial/usbserial.ko
endif
ifeq ($(HAS_GENERIC_U2S),)
	insmod /lib/modules/$(KVER)/kernel/drivers/usb/serial/generic-u2s.ko
endif
	if [ "$(GENERIC_USC_LOAD_AT_BOOT)" == "" ]; then echo "generic_u2s" >> /etc/modules; fi

uninstall:
ifneq ($(HAS_GENERIC_U2S),)
	rmmod /lib/modules/$(KVER)/kernel/drivers/usb/serial/generic-u2s.ko
endif
ifneq ($(HAS_USBSERIAL),)
	rmmod /lib/modules/$(KVER)/kernel/drivers/usb/serial/usbserial.ko
endif
	rm -f /lib/modules/$(KVER)/kernel/drivers/usb/serial/generic-u2s.ko
	if [ "$(GENERIC_USC_LOAD_AT_BOOT)" == "generic_u2s" ]; then sed -i '/generic_u2s/d' /etc/modules; fi
endif

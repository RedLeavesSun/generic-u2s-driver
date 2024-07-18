#include <linux/module.h>
#include <linux/tty.h>
#include <linux/usb.h>
#include <linux/usb/serial.h>

#include "generic-u2s.h"

static struct usb_device_id id_table[] = {
	{ USB_DEVICE_AND_INTERFACE_INFO(0x05c6, 0x900e, 0xff, 0xff, 0x10) },
	{ USB_DEVICE_AND_INTERFACE_INFO(0x05c6, 0x90db, 0xff, 0xff, 0x10) },
	{ USB_DEVICE_AND_INTERFACE_INFO(0x05c6, 0x90b8, 0xff, 0xff, 0x10) },
	{ USB_DEVICE_AND_INTERFACE_INFO(0x1782, 0x4d00, 0xff, 0x00, 0x00) },
	{}
};

static struct usb_serial_driver generic_u2s_driver = {
	.driver = {
		.owner = THIS_MODULE,
		.name = "generic_u2s",
	},
	.num_ports = 1,
	.id_table = id_table,
};

static struct usb_serial_driver *const serial_drivers[] = {
	&generic_u2s_driver,
	NULL
};

static int __init generic_u2s_init(void)
{
	int ret = 0;

	ret = usb_serial_register_drivers(serial_drivers, "generic-u2s", id_table);
	if (ret)
	{
		pr_err("%s: usb_serial_register_drivers failed, ret = %d\n", __func__, ret);
	}

	return 0;
}

static void __exit generic_u2s_exit(void)
{
	pr_info("%s: enter\n", __func__);

	usb_serial_deregister_drivers(serial_drivers);
}

module_init(generic_u2s_init);
module_exit(generic_u2s_exit);

MODULE_LICENSE("GPL");

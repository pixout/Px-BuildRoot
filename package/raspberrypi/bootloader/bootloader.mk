#BOOTLOADER_VERSION = e1e2823ab8729b61dd36e177d2db1ec20df59f09
BOOTLOADER_VERSION = ${BR2_BOOTLOADER_VERSION}
BOOTLOADER_SITE = http://github.com/raspberrypi/firmware/tarball/$(BOOTLOADER_VERSION)
BOOTLOADER_SOURCE = raspberrypi-bootloader-$(BOOTLOADER_VERSION).tar.gz
BOOTLOADER_LICENSE = BSD-3c
BOOTLOADER_LICENSE_FILE = boot/LICENCE.broadcom


define BOOTLOADER_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/boot
	cp $(@D)/boot/start.elf $(TARGET_DIR)/boot/start.elf
	cp $(@D)/boot/start_*.elf $(TARGET_DIR)/boot/
	cp $(@D)/boot/bootcode.bin $(TARGET_DIR)/boot/bootcode.bin
	cp $(@D)/boot/fixup.dat $(TARGET_DIR)/boot/fixup.dat
	cp $(@D)/boot/fixup_*.dat $(TARGET_DIR)/boot/
	cp $(@D)/boot/bcm2708-rpi-* $(TARGET_DIR)/boot/
	cp $(@D)/boot/bcm2709-rpi-* $(TARGET_DIR)/boot/
	cp $(@D)/boot/bcm2710-rpi-* $(TARGET_DIR)/boot/
	cp -R $(@D)/boot/overlays $(TARGET_DIR)/boot/
	# Generate boot config files
    echo "#Generated config.txt by RaspberryPi-Buildroot at "`date +%c` >  $(TARGET_DIR)/boot/config.txt

	echo "arm_freq=$(BR2_RASPBERRYPI_CPU_SPEED)" >> $(TARGET_DIR)/boot/config.txt
#	echo "core_freq=$(BR2_RPI_CONFIG_CPU_SPEED)" >> $(TARGET_DIR)/boot/config.txt
	echo "gpu_freq=$(BR2_RASPBERRYPI_GPU_SPEED)" >> $(TARGET_DIR)/boot/config.txt
	echo "gpu_mem="$(BR2_RASPBERRYPI_GPU_RAM_SIZE) >> $(TARGET_DIR)/boot/config.txt
	echo "init_uart_baud=$(BR2_RASPBERRYPI__UART_SPEED)" >> $(TARGET_DIR)/boot/config.txt

        -if [ "$(BR2_RASPBERRYPI_DISABLE_OVERSCAN)" = "y" ]; then \
	  echo "disable_overscan=1" >> $(TARGET_DIR)/boot/config.txt; \
        fi

        -if [ "$(BR2_RASPBERRYPI_DISABLE_L2CACHE)" = "y" ]; then \
	  echo "disable_l2cache=1" >> $(TARGET_DIR)/boot/config.txt; \
        fi

        -if [ "$(BR2_RASPBERRYPI_LICENSE_MPG2)" != "" ]; then \
          echo "decode_MPG2=$(BR2_RASPBERRYPI_LICENSE_MPG2)" >> $(TARGET_DIR)/boot/config.txt; \
        fi

        -if [ "$(BR2_RASPBERRYPI_LICENSE_VC1)" != "" ]; then \
          echo "decode_WVC1=$(BR2_RASPBERRYPI_LICENSE_VC1)" >> $(TARGET_DIR)/boot/config.txt; \
        fi

        -if [ "$(BR2_RASPBERRYPI_DISABLE_SAFEMODE)" = "y" ]; then \
          echo "avoid_safe_mode=1" >> $(TARGET_DIR)/boot/config.txt; \
        fi

        echo "framebuffer_depth=24" >> $(TARGET_DIR)/boot/config.txt #ERIC
        echo "over_voltage=6" >> $(TARGET_DIR)/boot/config.txt #ERIC
        echo "cma_lwm=16" >> $(TARGET_DIR)/boot/config.txt #ERIC
        echo "cma_hwm=32" >> $(TARGET_DIR)/boot/config.txt #ERIC
        echo "cma_offline_start=16" >> $(TARGET_DIR)/boot/config.txt #ERIC

        # add the _x files for csi camera support
        echo "#uncomment these lines to add CSI camera support:" >> $(TARGET_DIR)/boot/config.txt
        echo "#start_file=start_x.elf" >> $(TARGET_DIR)/boot/config.txt
        echo "#fixup_file=fixup_x.dat" >> $(TARGET_DIR)/boot/config.txt

	echo "$(BR2_RASPBERRYPI_CMDLINE)" > $(TARGET_DIR)/boot/cmdline.txt
endef

$(eval $(generic-package))

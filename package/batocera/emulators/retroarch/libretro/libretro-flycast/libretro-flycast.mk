################################################################################
#
# libretro-flycast
#
################################################################################
# Version: Commits on May 16, 2022
LIBRETRO_FLYCAST_VERSION = 221060cc707c66326efca7df9af229f6ac24d1ea
LIBRETRO_FLYCAST_SITE = https://github.com/flyinghead/flycast.git
LIBRETRO_FLYCAST_SITE_METHOD=git
LIBRETRO_FLYCAST_GIT_SUBMODULES=YES
LIBRETRO_FLYCAST_LICENSE = GPLv2
LIBRETRO_FLYCAST_DEPENDENCIES = retroarch

LIBRETRO_FLYCAST_PLATFORM = $(LIBRETRO_PLATFORM)

LIBRETRO_FLYCAST_CONF_OPTS = -DUSE_OPENMP=ON -DLIBRETRO=ON \
    -DBUILD_SHARED_LIBS=OFF -DBUILD_EXTERNAL=OFF

ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)
  # Batocera - SBC prefer GLES
  ifneq ($(BR2_PACKAGE_BATOCERA_SBC_XORG),y)
    LIBRETRO_FLYCAST_CONF_OPTS += -DUSE_OPENGL=ON
  else
    LIBRETRO_FLYCAST_CONF_OPTS += -DUSE_GLES=ON -DUSE_GLES2=OFF
  endif
else ifeq ($(BR2_PACKAGE_BATOCERA_GLES3),y)
    LIBRETRO_FLYCAST_CONF_OPTS += -DUSE_GLES=ON -DUSE_GLES2=OFF
else ifeq ($(BR2_PACKAGE_BATOCERA_GLES2),y)
    LIBRETRO_FLYCAST_CONF_OPTS += -DUSE_GLES2=ON -DUSE_GLES=OFF
endif

ifeq ($(BR2_PACKAGE_BATOCERA_VULKAN),y)
    LIBRETRO_FLYCAST_CONF_OPTS += -DUSE_VULKAN=ON
else
    LIBRETRO_FLYCAST_CONF_OPTS += -DUSE_VULKAN=OFF
endif

# RPI: use the legacy Broadcom GLES libraries
ifeq ($(BR2_PACKAGE_BATOCERA_RPI_VCORE),y)
    LIBRETRO_FLYCAST_CONF_OPTS += -DUSE_VIDEOCORE=ON
endif

ifeq ($(BR2_PACKAGE_HAS_LIBMALI),y)
    LIBRETRO_FLYCAST_CONF_OPTS += -DUSE_MALI=ON
endif

define LIBRETRO_FLYCAST_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/flycast_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/flycast_libretro.so
endef

$(eval $(cmake-package))

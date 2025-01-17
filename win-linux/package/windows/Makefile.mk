BUILD_DIR = win-linux/package/windows

ISCC := iscc

DESKTOP_EDITORS_EXE += $(BUILD_DIR)/$(PACKAGE_NAME)_$(PACKAGE_VERSION)_$(WIN_ARCH)$(WIN_ARCH_SUFFIX:%=_%).exe
DESKTOP_EDITORS_ZIP += $(BUILD_DIR)/$(PACKAGE_NAME)_$(PACKAGE_VERSION)_$(WIN_ARCH)$(WIN_ARCH_SUFFIX:%=_%).zip

VCREDIST13 := $(BUILD_DIR)/data/vcredist/vcredist_2013_$(WIN_ARCH).exe
VCREDIST15 := $(BUILD_DIR)/data/vcredist/vcredist_2015_$(WIN_ARCH).exe

ifeq ($(WIN_ARCH),x64)
 	VCREDIST13_URL := https://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe
	VCREDIST15_URL := http://download.microsoft.com/download/2/c/6/2c675af0-2155-4961-b32e-289d7addfcec/vc_redist.x64.exe
else ifeq ($(WIN_ARCH),x86)
 	VCREDIST13_URL := https://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x86.exe
	VCREDIST15_URL := http://download.microsoft.com/download/d/e/c/dec58546-c2f5-40a7-b38e-4df8d60b9764/vc_redist.x86.exe
endif

ifneq ($(COMPANY_NAME), ONLYOFFICE)
VCREDIST += $(VCREDIST13)
endif
VCREDIST += $(VCREDIST15)

EXE_UPDATE += $(BUILD_DIR)/update/editors_update_$(WIN_ARCH)$(WIN_ARCH_SUFFIX:%=_%).exe
APPCAST := $(BUILD_DIR)/update/appcast.xml
CHANGES_EN := $(BUILD_DIR)/update/changes.html
CHANGES_RU := $(BUILD_DIR)/update/changes_ru.html
CHANGES_DIR := $(BRANDING_DIR)/$(BUILD_DIR)/update/changes/$(PRODUCT_VERSION)

PACKAGES += $(DESKTOP_EDITORS_EXE)
PACKAGES += $(DESKTOP_EDITORS_ZIP)
WINSPARKLE += $(EXE_UPDATE)
ifndef _WIN_XP
ifeq ($(WIN_ARCH), x64)
WINSPARKLE += $(APPCAST)
ifeq ($(COMPANY_NAME), ONLYOFFICE)
WINSPARKLE += $(CHANGES_EN)
endif
WINSPARKLE += $(CHANGES_RU)
endif
endif

ISCC_PARAMS += //Qp
ISCC_PARAMS += //D_ARCH=$(ARCHITECTURE)
ifdef _WIN_XP
	ISCC_PARAMS += //D_WIN_XP=1
endif
ifeq ($(COMPANY_NAME), ONLYOFFICE)
	ISCC_PARAMS += //D_ONLYOFFICE=1
endif
ISCC_PARAMS += //D_UPDMODULE=1
ISCC_PARAMS += //DsAppVersion=$(PACKAGE_VERSION)
ISCC_PARAMS += //DsBrandingFolder="$(shell cygpath -a -w $(BRANDING_DIR))"
ISCC_PARAMS += //DsOutputFileName=$(notdir $(basename $@))
ISCC_PARAMS += //DDEPLOY_PATH="$(shell cygpath -a -w $(DEST_DIR))"
ifdef ENABLE_SIGNING
ISCC_PARAMS += //DENABLE_SIGNING=1
endif
ISCC_PARAMS += //S"byparam=signtool.exe sign /v /n $(word 1, $(PUBLISHER_NAME)) /t http://timestamp.digicert.com \$$f"

$(DESKTOP_EDITORS_EXE): $(DEST_DIR) $(VCREDIST)
$(DESKTOP_EDITORS_ZIP): $(DEST_DIR)

.PHONY : clean-package exe zip winsparkle packages

clean-package:
	rm -fv \
		$(VCREDIST) \
		$(BUILD_DIR)/*.exe \
		$(BUILD_DIR)/*.zip \
		$(BUILD_DIR)/update/*.exe \
		$(BUILD_DIR)/update/*.xml \
		$(BUILD_DIR)/update/*.html

exe: $(DESKTOP_EDITORS_EXE)

zip: $(DESKTOP_EDITORS_ZIP)

winsparkle: $(WINSPARKLE)

packages: $(PACKAGES) $(WINSPARKLE)

$(VCREDIST13):
	mkdir -p $(dir $(VCREDIST13))
	$(CURL) $(VCREDIST13) $(VCREDIST13_URL)

$(VCREDIST15):
	mkdir -p $(dir $(VCREDIST15))
	$(CURL) $(VCREDIST15) $(VCREDIST15_URL)

$(DEST_DIR): install

$(DESKTOP_EDITORS_EXE):
	cd $(BUILD_DIR) && $(ISCC) $(ISCC_PARAMS) common.iss

$(EXE_UPDATE): $(DESKTOP_EDITORS_EXE)
	cd $(BUILD_DIR) && $(ISCC) $(ISCC_PARAMS) //DTARGET_NAME="$(notdir $<)" update_common.iss

$(BUILD_DIR)/%.zip:
	7z a -y $@ $(DEST_DIR)/*
	
AWK_PARAMS += -v Version="$(PRODUCT_VERSION)"
AWK_PARAMS += -v Build="$(BUILD_NUMBER)"
AWK_PARAMS += -v Timestamp="$(shell date +%s)"
AWK_PARAMS += -i "$(BRANDING_DIR)/win-linux/package/windows/update/branding.awk"

%/appcast.xml: %/appcast.xml.awk
	LANG=en_US.UTF-8 \
	awk $(AWK_PARAMS) -f $< > $@

%/changes.html: %/changes.html.awk
	LANG=en_US.UTF-8 \
	awk $(AWK_PARAMS) -f $< "$(CHANGES_DIR)/en.html" > $@

%/changes_ru.html: %/changes.html.awk
	LANG=ru_RU.UTF-8 \
	awk $(AWK_PARAMS) -f $< "$(CHANGES_DIR)/ru.html" > $@

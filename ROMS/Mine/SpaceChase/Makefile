# Metadata and Filenames
PROJECTNAME_DMG    	= SpaceChase_DMG
PROJECTNAME_GBC    	= SpaceChase_GBC

# Main Directories
SRC         		= src
LIBS        		= libs
OBJ         	    = obj
DIST        	    = dist
GEN     	        = generated
RESOURCES         	= $(SRC)/resources
IMAGES              = $(RESOURCES)/images
APP                 = $(SRC)/app
BINS_DMG	    	= $(DIST)/$(PROJECTNAME_DMG).gb
BINS_GBC	    	= $(DIST)/$(PROJECTNAME_GBC).gbc

# Audio Directories
# AUDIO_MUSIC_TENOR   = $(RESOURCES)/audio
AUDIO_MUSIC     	= $(RESOURCES)/audio



# Image Directories
IMAGES_1BPP         = $(IMAGES)/1bpp
IMAGES_DMG          = $(IMAGES)/dmg
IMAGES_GBC          = $(IMAGES)/gbc

# DMG
IMAGES_DMG_8		    = $(IMAGES_DMG)/images8
IMAGES_DMG_16		    = $(IMAGES_DMG)/images16
IMAGES_DMG_BACKGROUNDS  = $(IMAGES_DMG)/backgrounds

# GBC
IMAGES_GBC_8		    = $(IMAGES_GBC)/images8
IMAGES_GBC_16		    = $(IMAGES_GBC)/images16
IMAGES_GBC_BACKGROUNDS  = $(IMAGES_GBC)/backgrounds



# Image Bins
GEN_1BPP            = $(GEN)/1bpp
GEN_DMG             = $(GEN)/dmg
GEN_GBC             = $(GEN)/gbc

# DMG
GEN_DMG_8   			= $(GEN_DMG)/images8
GEN_DMG_16		    	= $(GEN_DMG)/images16
GEN_DMG_BACKGROUNDS		= $(GEN_DMG)/backgrounds

# GBC
GEN_GBC_8		    	= $(GEN_GBC)/images8
GEN_GBC_16		    	= $(GEN_GBC)/images16
GEN_GBC_BACKGROUNDS		= $(GEN_GBC)/backgrounds



# Tools
RGBDS ?=
ASM := $(RGBDS)rgbasm
GFX := $(RGBDS)rgbgfx
LINK := $(RGBDS)rgblink
FIX := $(RGBDS)rgbfix
TENOR := teNOR

# Tool flags
FIXFLAGS_DMG := -v
FIXFLAGS_GBC := -v -c --overwrite
.DEFAULT_GOAL := default

# Extra functions
rwildcard = $(foreach d,\
		$(wildcard $(1:=/*)), \
		$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d) \
	)
unique = $(if $1,\
			$(firstword $1) $(call unique,$(filter-out $(firstword $1),$1)) \
		)



# Image inputs
DMG_PNGS_8           := $(call rwildcard,$(IMAGES_DMG_8),*.png)
DMG_PNGS_16          := $(call rwildcard,$(IMAGES_DMG_16),*.png)
DMG_PNGS_BACKGROUNDS := $(call rwildcard,$(IMAGES_DMG_BACKGROUNDS),*.png)

GBC_PNGS_8           := $(call rwildcard,$(IMAGES_GBC_8),*.png)
GBC_PNGS_16          := $(call rwildcard,$(IMAGES_GBC_16),*.png)
GBC_PNGS_BACKGROUNDS := $(call rwildcard,$(IMAGES_GBC_BACKGROUNDS),*.png)

1BPP_PNGS            := $(call rwildcard,$(IMAGES_1BPP),*.png)

# Image outputs
DMG_OUTPUT_8           := $(patsubst $(IMAGES_DMG_8)/%.png, $(GEN_DMG_8)/%.2bpp, $(DMG_PNGS_8))
DMG_OUTPUT_16          := $(patsubst $(IMAGES_DMG_16)/%.png, $(GEN_DMG_16)/%.2bpp, $(DMG_PNGS_16))
DMG_OUTPUT_BACKGROUNDS := $(patsubst $(IMAGES_DMG_BACKGROUNDS)/%.png, $(GEN_DMG_BACKGROUNDS)/%.2bpp, $(DMG_PNGS_BACKGROUNDS))
DMG_OUTPUT_TILEMAPS    := $(patsubst $(IMAGES_DMG_BACKGROUNDS)/%.png, $(GEN_DMG_BACKGROUNDS)/%.tilemap, $(DMG_PNGS_BACKGROUNDS))

GBC_OUTPUT_8           := $(patsubst $(IMAGES_GBC_8)/%.png, $(GEN_GBC_8)/%.2bpp, $(GBC_PNGS_8))
GBC_OUTPUT_16          := $(patsubst $(IMAGES_GBC_16)/%.png, $(GEN_GBC_16)/%.2bpp, $(GBC_PNGS_16))
GBC_OUTPUT_BACKGROUNDS := $(patsubst $(IMAGES_GBC_BACKGROUNDS)/%.png, $(GEN_GBC_BACKGROUNDS)/%.2bpp, $(GBC_PNGS_BACKGROUNDS))
GBC_OUTPUT_TILEMAPS    := $(patsubst $(IMAGES_GBC_BACKGROUNDS)/%.png, $(GEN_GBC_BACKGROUNDS)/%.tilemap, $(GBC_PNGS_BACKGROUNDS))
GBC_OUTPUT_ATTRMAPS    := $(patsubst $(IMAGES_GBC_BACKGROUNDS)/%.png, $(GEN_GBC_BACKGROUNDS)/%.attrmap, $(GBC_PNGS_BACKGROUNDS))

1BPP_OUTPUT            := $(patsubst $(IMAGES_1BPP)/%.png, $(GEN_1BPP)/%.1bpp, $(1BPP_PNGS))
1BPP_OUTPUT_TILEMAPS   := $(patsubst $(IMAGES_1BPP)/%.png, $(GEN_1BPP)/%.tilemap, $(1BPP_PNGS))

ALL_GRAPHICS := $(DMG_OUTPUT_8) $(DMG_OUTPUT_16) $(DMG_OUTPUT_BACKGROUNDS) $(DMG_OUTPUT_TILEMAPS) \
				$(GBC_OUTPUT_8) $(GBC_OUTPUT_16) $(GBC_OUTPUT_BACKGROUNDS) $(GBC_OUTPUT_TILEMAPS) $(GBC_OUTPUT_ATTRMAPS) \
				$(1BPP_OUTPUT)

# DMG Generation
$(GEN_DMG_8)/%.2bpp: $(IMAGES_DMG_8)/%.png
	@mkdir -p $(@D)
	$(GFX) --unique-tiles -o $@ $<

$(GEN_DMG_16)/%.2bpp: $(IMAGES_DMG_16)/%.png
	@mkdir -p $(@D)
	$(GFX) --columns --unique-tiles -o $@ $<

$(GEN_DMG_BACKGROUNDS)/%.2bpp: $(IMAGES_DMG_BACKGROUNDS)/%.png
	@mkdir -p $(@D)
	$(GFX) \
		--tilemap $@ \
		--unique-tiles \
		-o $(GEN_DMG_BACKGROUNDS)/$*.2bpp -b 128 \
		$<

$(GEN_DMG_BACKGROUNDS)/%.tilemap: $(IMAGES_DMG_BACKGROUNDS)/%.png
	@mkdir -p $(@D)
	$(GFX) \
		--tilemap $@ \
		--unique-tiles \
		-o $(GEN_DMG_BACKGROUNDS)/$*.2bpp -b 128 \
		$<

# GBC Generation
$(GEN_GBC_8)/%.2bpp: $(IMAGES_GBC_8)/%.png $(GEN_GBC_8)/%.pal
	@mkdir -p $(@D)
	$(GFX) --unique-tiles -C -p $(GEN_GBC_8)/%.pal -o $@ $<

$(GEN_GBC_8)/%.pal: $(IMAGES_GBC_8)/%.png
	@mkdir -p $(@D)
	$(GFX) --unique-tiles -C -p $@ $<

$(GEN_GBC_16)/%.2bpp: $(IMAGES_GBC_16)/%.png $(GEN_GBC_16)/%.pal
	@mkdir -p $(@D)
	$(GFX) --columns --unique-tiles -C -p $(GEN_GBC_16)/$*.pal -o $@ $<

$(GEN_GBC_16)/%.pal: $(IMAGES_GBC_16)/%.png
	@mkdir -p $(@D)
	$(GFX) --columns --unique-tiles -C -p $@ $<

$(GEN_GBC_BACKGROUNDS)/%.2bpp: $(IMAGES_GBC_BACKGROUNDS)/%.png
	@mkdir -p $(@D)
	$(GFX) \
		--tilemap $@ \
		--unique-tiles \
		-a $(GEN_GBC_BACKGROUNDS)/$*.attrmap \
		-C -p $(GEN_GBC_BACKGROUNDS)/$*.pal \
		-o $(GEN_GBC_BACKGROUNDS)/$*.2bpp -b 128 \
		$<

$(GEN_GBC_BACKGROUNDS)/%.tilemap: $(IMAGES_GBC_BACKGROUNDS)/%.png
	@mkdir -p $(@D)
	$(GFX) \
		--tilemap $@ \
		--unique-tiles \
		-a $(GEN_GBC_BACKGROUNDS)/$*.attrmap \
		-C -p $(GEN_GBC_BACKGROUNDS)/$*.pal \
		-o $(GEN_GBC_BACKGROUNDS)/$*.2bpp -b 128 \
		$<

# 1bpp
$(GEN_1BPP)/%.1bpp: $(IMAGES_1BPP)/%.png
	python3 convert1bpp.py $< $@



# Collect ASM sources
ASMSOURCES_COLLECTED = \
	$(call rwildcard,$(APP),*.asm) $(call rwildcard,$(LIBS),*.asm) \
	$(call rwildcard,$(AUDIO_MUSIC),*.asm)
# $(TENOR_ASM) 

OBJS = $(patsubst %.asm,$(OBJ)/%.o,$(notdir $(ASMSOURCES_COLLECTED)))

ASMSOURCES_DIRS = $(patsubst %,%%.asm,\
			$(call unique,$(dir $(ASMSOURCES_COLLECTED))) \
		)

# ASM -> Objects
define object-from-asm
$(OBJ)/%.o: $1 | $(OBJ)
	$$(ASM) --include "./include" -o $$@ $$<
endef

$(foreach i, $(ASMSOURCES_DIRS), $(eval $(call object-from-asm,$i)))

# Run linker
$(BINS_DMG): $(OBJS) | $(DIST) $(ALL_GRAPHICS)
	$(LINK) -m dist/$(PROJECTNAME_DMG).map -n dist/$(PROJECTNAME_DMG).sym -o $@ $^
	$(FIX) $(FIXFLAGS_DMG) $@

$(BINS_GBC): $(OBJS) | $(DIST) $(ALL_GRAPHICS)
	$(LINK) -m dist/$(PROJECTNAME_GBC).map -n dist/$(PROJECTNAME_GBC).sym -o $@ $^
	$(FIX) $(FIXFLAGS_GBC) $@



# Directory management
define ensure-directory
$1:
	mkdir -p $$@
endef

PREPARE_DIRECTORIES = \
	$(DIST) $(OBJ) $(AUDIO_MUSIC) \
	$(GEN_DMG) $(GEN_GBC) $(GEN_1BPP)

$(foreach i, $(PREPARE_DIRECTORIES), $(eval $(call ensure-directory,$i)))

compile.bat: Makefile
	@echo "REM Automatically generated from Makefile" > compile.bat
	@make -sn | sed y/\\/\\\\/\\\\\\\^/ | grep -v make >> compile.bat


clean:
	rm -rfv $(PREPARE_DIRECTORIES)
rom: $(BINS_DMG) $(BINS_GBC)
graphics: $(ALL_GRAPHICS)
.DEFAULT_GOAL := default
default: graphics rom
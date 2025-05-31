# You can set the name of the .gb ROM file here
PROJECTNAME    		= SpaceChase

SRC         		= src
LIBS        		= libs
OBJ         	    = obj
DIST        	    = dist
GEN     	        = generated

RESOURCES         	= $(SRC)/resources
APP                 = $(SRC)/app

IMAGES              = $(RESOURCES)/images
IMAGES_SPRITES      = $(IMAGES)/sprites
IMAGES_BACKGROUNDS  = $(IMAGES)/backgrounds
IMAGES_UI           = $(IMAGES)/ui

AUDIO           	= $(RESOURCES)/audio
AUDIO_MUSIC     	= $(AUDIO)/music
AUDIO_SOUNDS    	= $(AUDIO)/sounds

GEN_SPRITES	    	= $(GEN)/sprites
GEN_BACKGROUNDS		= $(GEN)/backgrounds
GEN_UI   			= $(GEN)/ui
BINS	    		= $(DIST)/$(PROJECTNAME).gb

# Tools
RGBDS ?=
ASM := $(RGBDS)rgbasm
GFX := $(RGBDS)rgbgfx
LINK := $(RGBDS)rgblink
FIX := $(RGBDS)rgbfix

# Tool flags
FIXFLAGS := -v -p 0xFF

.DEFAULT_GOAL := default

# https://stackoverflow.com/a/18258352
# Make does not offer a recursive wild card function, so here's one:
rwildcard = $(foreach d,\
		$(wildcard $(1:=/*)), \
		$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d) \
	)


# https://stackoverflow.com/a/16151140
# This makes it so every entry in a space-delimited list appears only once
unique = $(if $1,\
			$(firstword $1) $(call unique,$(filter-out $(firstword $1),$1)) \
		)

# Collect ASM sources
ASMSOURCES_COLLECTED = \
	$(call rwildcard,$(APP),*.asm) $(call rwildcard,$(LIBS),*.asm) \
	$(call rwildcard,$(AUDIO_MUSIC),*.asm) $(call rwildcard,$(AUDIO_SOUNDS),*.asm)

OBJS = $(patsubst %.asm,$(OBJ)/%.o,$(notdir $(ASMSOURCES_COLLECTED)))

rom: $(BINS)

default: rom

# ANCHOR: generate-graphics
NEEDED_GRAPHICS = \
	$(GEN_BACKGROUNDS)/star-field.tilemap \
	$(GEN_BACKGROUNDS)/title-screen.tilemap \
	\
	$(GEN_UI)/text-font.2bpp \
	$(GEN_UI)/display-box.2bpp \
	$(GEN_UI)/module-base.2bpp \
	\
	$(GEN_UI)/buttons.2bpp
	
# Generate sprites, ensuring the containing directories have been created.
$(GEN_SPRITES)/%.2bpp: $(IMAGES_SPRITES)/%.png | $(GEN_SPRITES)
	$(GFX) --columns --unique-tiles -o $@ $<

# Generate background tile set, ensuring the containing directories have been created.
$(GEN_BACKGROUNDS)/%.2bpp: $(IMAGES_BACKGROUNDS)/%.png | $(GEN_BACKGROUNDS)
	$(GFX) --unique-tiles -o $@ $<

$(GEN_UI)/%.2bpp: $(IMAGES_UI)/%.png | $(GEN_UI)
	$(GFX) --unique-tiles -o $@ $<

# Generate background tile map *and* tile set, ensuring the containing directories
# have been created.
$(GEN_BACKGROUNDS)/%.tilemap: $(IMAGES_BACKGROUNDS)/%.png | $(GEN_BACKGROUNDS)
	$(GFX) \
		--tilemap $@ \
		--unique-tiles \
		-o $(GEN_BACKGROUNDS)/$*.2bpp \
		$<
# ANCHOR_END: generate-graphics

compile.bat: Makefile
	@echo "REM Automatically generated from Makefile" > compile.bat
	@make -sn | sed y/\\/\\\\/\\\\\\\^/ | grep -v make >> compile.bat


# ANCHOR: generate-objects
# Extract directories from collected ASM sources and append "%.asm" to each one,
# creating a wildcard-rule.
ASMSOURCES_DIRS = $(patsubst %,%%.asm,\
			$(call unique,$(dir $(ASMSOURCES_COLLECTED))) \
		)

# This is a Makefile "macro".
# It defines a %.o target from a corresponding %.asm, ensuring the
# "prepare" step has ran and the graphics are already generated.
define object-from-asm
$(OBJ)/%.o: $1 | $(OBJ) $(NEEDED_GRAPHICS)
	$$(ASM) -o $$@ $$<
endef

# Run the macro for each directory listed in ASMSOURCES_DIRS, thereby
# creating the appropriate targets.
$(foreach i, $(ASMSOURCES_DIRS), $(eval $(call object-from-asm,$i)))
# ANCHOR_END: generate-objects

# Link and build the final ROM.
$(BINS): $(OBJS) | $(DIST)
	$(LINK) -m dist/$(PROJECTNAME).map -n dist/$(PROJECTNAME).sym -o $@ $^
	$(FIX) $(FIXFLAGS) $@
# Ensure directories for generated files exist.
define ensure-directory
$1:
	mkdir -p $$@
endef

PREPARE_DIRECTORIES = \
	$(OBJ) $(GEN_SPRITES) $(GEN_BACKGROUNDS) $(GEN_UI) $(DIST)

$(foreach i, $(PREPARE_DIRECTORIES), $(eval $(call ensure-directory,$i)))

# Clean up generated directories.
clean:
	rm -rfv  $(PREPARE_DIRECTORIES)

# Declare these targets as "not actually files".
.PHONY: default rom all
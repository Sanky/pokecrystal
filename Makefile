PYTHON := python
.SUFFIXES: .asm .tx .o .gbc .png .2bpp .lz

TEXTFILES := $(shell find ./ -type f -name '*.asm' | grep -v pokecrystal.asm | grep -v constants.asm | grep -v gbhw.asm | grep -v hram.asm | grep -v constants | grep -v wram.asm)
TEXTQUEUE :=

PNG_GFX    := $(shell find gfx/ -type f -name '*.png')
LZ_GFX     := $(shell find gfx/ -type f -name '*.lz')
TWOBPP_GFX := $(shell find gfx/ -type f -name '*.2bpp')

all: baserom.gbc pokecrystal.gbc
	cmp baserom.gbc pokecrystal.gbc
clean:
	rm -f pokecrystal.o pokecrystal.gbc
	@echo 'rm -f $(TEXTFILES:.asm=.tx)'
	@rm -f $(TEXTFILES:.asm=.tx)
pokecrystal.o: $(TEXTFILES:.asm=.tx) wram.asm constants.asm $(shell find constants/ -type f -name '*.asm') hram.asm gbhw.asm $(LZ_GFX) $(TWOBPP_GFX)
	$(PYTHON) prequeue.py $(TEXTQUEUE)
	rgbasm -o pokecrystal.o pokecrystal.asm
.asm.tx:
	$(eval TEXTQUEUE := $(TEXTQUEUE) $<)
	@rm -f $@
baserom.gbc:
	$(PYTHON) -c "import os; assert 'baserom.gbc' in os.listdir('.'), 'Wait! Need baserom.gbc first. Check README and INSTALL for details.';"

pokecrystal.gbc: pokecrystal.o
	rgblink -n pokecrystal.sym -m pokecrystal.map -o $@ $<
	rgbfix -Cjv -i BYTE -k 01 -l 0x33 -m 0x10 -p 0 -r 3 -t PM_CRYSTAL $@

pngs:
	$(PYTHON) extras/pokemontools/gfx.py mass-decompress
	$(PYTHON) extras/pokemontools/gfx.py dump-pngs

lzs: $(LZ_GFX) $(TWOBPP_GFX)
	@:

gfx/pics/%/front.lz: gfx/pics/%/tiles.2bpp gfx/pics/%/front.png
	$(PYTHON) extras/pokemontools/gfx.py png-to-lz --front $^
gfx/pics/%/tiles.2bpp: gfx/pics/%/tiles.png
	$(PYTHON) extras/pokemontools/gfx.py png-to-2bpp $<
gfx/pics/%/back.lz: gfx/pics/%/back.png
	$(PYTHON) extras/pokemontools/gfx.py png-to-lz --vert $<
gfx/trainers/%.lz: gfx/trainers/%.png
	$(PYTHON) extras/pokemontools/gfx.py png-to-lz --vert $<
.png.lz:
	$(PYTHON) extras/pokemontools/gfx.py png-to-lz $<
.png.2bpp:
	$(PYTHON) extras/pokemontools/gfx.py png-to-lz $<


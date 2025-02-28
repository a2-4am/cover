# https://sourceforge.net/projects/acme-crossass/
ACME=acme

# https://github.com/mach-kernel/cadius
CADIUS=cadius

BUILDDIR=build
SOURCES=$(wildcard src/*.a)
EXE=$(BUILDDIR)/COVER.SYSTEM\#FF2000
PRODOS=common/PRODOS\#FF0000
DATA=$(wildcard res/*)
DISKVOLUME=COVER
BUILDDISK=$(BUILDDIR)/$(DISKVOLUME).po

.PHONY: clean mount all

$(BUILDDISK): $(PRODOS) $(EXE) $(DATA)

$(EXE): $(SOURCES) | $(BUILDDIR)
	$(ACME) -r build/cover.lst src/cover.a
	$(CADIUS) REPLACEFILE "$(BUILDDISK)" "/$(DISKVOLUME)/" "$(EXE)" -C
	@touch "$@"

$(PRODOS): $(BUILDDIR)
	$(CADIUS) REPLACEFILE "$(BUILDDISK)" "/$(DISKVOLUME)/" "$@" -C
	@touch "$@"

$(DATA): $(BUILDDIR)
	$(CADIUS) REPLACEFILE "$(BUILDDISK)" "/$(DISKVOLUME)/" "$@" -C
	@touch "$@"

mount: $(BUILDDISK)
	@open "$(BUILDDISK)"

clean:
	rm -rf "$(BUILDDIR)"

$(BUILDDIR):
	mkdir -p "$@"
	$(CADIUS) CREATEVOLUME "$(BUILDDISK)" "$(DISKVOLUME)" 140KB -C

all: clean mount

.NOTPARALLEL:

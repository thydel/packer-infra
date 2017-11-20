top:; @date

Makefile:;

.DELETE_ON_ERROR:

yaml2json.py := import sys, yaml, json;
yaml2json.py += json.dump(yaml.load(sys.stdin), sys.stdout, indent=4, default=str, sort_keys=True)
yaml2json    := python -c '$(yaml2json.py)'

ifndef PACKER_DEBIAN_PASSWD
$(error PACKER_DEBIAN_PASSWD must be defined)
endif

PACKER_DEBIAN_PASSWD_CRYPTED := $(shell echo -n '$(PACKER_DEBIAN_PASSWD)' | mkpasswd -m sha-512 -s)
STEP := base
DISK_SIZE := 16384
VNC_PORT := 5959

~ := debian-921-amd64-netinst

jq := { builders, provisioners, variables }
$~.json: $~.yml; < $< $(yaml2json) | jq '$(jq)' > $@

$~.yml.dep := $~.yml.gpp $~.gpp $~.in.yml
$~.yml.gpp := gpp $(foreach _, STEP DISK_SIZE VNC_PORT, -D_$_='$($_)')
$~.yml: $($~.yml.dep); $($@.gpp) $< > $@

$~.preseed.dep := $~.preseed.gpp $~.gpp $~.in.preseed $~.part.preseed
$~.preseed.gpp := gpp $(foreach _, STEP PACKER_DEBIAN_PASSWD_CRYPTED, -D_$_='$($_)')
$~.preseed: $($~.preseed.dep); $($@.gpp) $< > $@

$(sort $($~.yml.dep) $($~.preseed.dep)): Makefile;

conf := $~.json $~.preseed
build := ~/packer/$~-$(STEP)/packer-$~-$(STEP).vmx
ifdef FULL
$(build): $(conf); packer build $(FORCE) $<
else
$(build):; packer build $(FORCE) $~.json
endif

conf: $(conf)
build: $(build)
main: conf build
run: main; @echo vmplayer $(build)
vnc:; @echo xtigervncviewer localhost:$(VNC_PORT)
.PHONY: main conf build run

partman-auto := http://ftp.fr.debian.org/debian/pool/main/p/partman-auto
tmp/partman-auto_137_amd64.udeb: tmp/.stone; (cd $(@D); curl -O $(partman-auto)/$(@F))
tmp/.stone:; mkdir -p $(@D); touch $@
tmp/partman-auto_137_amd64: tmp/partman-auto_137_amd64.udeb; dpkg -x $< $@
partman-auto_137_amd64-80multi: tmp/partman-auto_137_amd64; cp $</lib/partman/recipes/80multi $@
recipes := partman-auto_137_amd64-80multi
recipes: $(recipes)
.PHONY: recipes

stretch-example-preseed.txt := https://www.debian.org/releases/stretch/example-preseed.txt
stretch-example-preseed.txt:; curl $($@) > $@
example-preseed := example-preseed
example-preseed: $(example-preseed)
.PHONY: example-preseed

clean:; rm -f $~.json $~.yml $~.preseed $(recipes) $(example-preseed)

FORCE :=
force := FORCE := -force

vartar := force

$(vartar):; @: $(eval $($@))

top:; @date

Makefile:;

.DELETE_ON_ERROR:

yaml2json.py := import sys, yaml, json;
yaml2json.py += json.dump(yaml.load(sys.stdin), sys.stdout, indent=4, default=str, sort_keys=True)
yaml2json    := python -c '$(yaml2json.py)'

~ := debian-921-amd64-netinst

ifndef PACKER_DEBIAN_PASSWD
$(error PACKER_DEBIAN_PASSWD must be defined)
endif

PACKER_DEBIAN_PASSWD_CRYPTED := $(shell echo -n '$(PACKER_DEBIAN_PASSWD)' | mkpasswd -m sha-512 -s)

jq := { builders, provisioners, variables }
$~.json: $~.yml; < $< $(yaml2json) | jq '$(jq)' > $@

$~.yml.dep := $~.yml.gpp $~.gpp $~.in.yml
$~.yml: $($~.yml.dep); gpp $< > $@

$~.preseed.dep := $~.preseed.gpp $~.gpp $~.in.preseed $~.part.preseed
$~.preseed: $($~.preseed.dep); gpp -D_PACKER_DEBIAN_PASSWD_CRYPTED='$(PACKER_DEBIAN_PASSWD_CRYPTED)' $< > $@

conf := $~.json $~.preseed
~/packer/debian-921-amd64-netinst-2: $(conf); packer build $<

conf: $(conf)
build: ~/packer/debian-921-amd64-netinst-2
main: conf build
.PHONY: main conf build

clean:; rm $~.json $~.yml $~.preseed

partman-auto := http://ftp.fr.debian.org/debian/pool/main/p/partman-auto
tmp/partman-auto_137_amd64.udeb:; (cd $(@D); curl -O $(partman-auto)/$(@F))
tmp/partman-auto_137_amd64: tmp/partman-auto_137_amd64.udeb; dpkg -x $< $@
partman-auto_137_amd64-80multi: tmp/partman-auto_137_amd64; cp $</lib/partman/recipes/80multi $@
recipes: partman-auto_137_amd64-80multi
.PHONY: recipes

example-preseed.txt := https://www.debian.org/releases/stretch/example-preseed.txt
example-preseed.txt:; curl -O $($@)

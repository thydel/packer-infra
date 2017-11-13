top:; @date

Makefile:;

.DELETE_ON_ERROR:

yaml2json.py := import sys, yaml, json;
yaml2json.py += json.dump(yaml.load(sys.stdin), sys.stdout, indent=4, default=str, sort_keys=True)
yaml2json    := python -c '$(yaml2json.py)'

~ := debian-921-amd64-netinst

jq := { builders, provisioners, variables }
$~.json: $~.yml; < $< $(yaml2json) | jq '$(jq)' > $@

$~.yml.dep := $~.yml.gpp $~.gpp $~.in.yml
$~.yml: $($~.yml.dep); gpp $< > $@

$~.preseed.dep := $~.preseed.gpp $~.gpp $~.in.preseed $~.part.preseed
$~.preseed: $($~.preseed.dep); gpp $< > $@

main: $~.json $~.preseed
.PHONY: main

partman-auto := http://ftp.fr.debian.org/debian/pool/main/p/partman-auto
tmp/partman-auto_137_amd64.udeb:; (cd $(@D); curl -O $(partman-auto)/$(@F))
tmp/partman-auto_137_amd64: tmp/partman-auto_137_amd64.udeb; dpkg -x $< $@
partman-auto_137_amd64-80multi: tmp/partman-auto_137_amd64; cp $</lib/partman/recipes/80multi $@
recipes: partman-auto_137_amd64-80multi
.PHONY: recipes

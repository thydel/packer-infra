top:; @date

Makefile:;

.DELETE_ON_ERROR:

yaml2json.py := import sys, yaml, json;
yaml2json.py += json.dump(yaml.load(sys.stdin), sys.stdout, indent=4, default=str, sort_keys=True)
yaml2json    := python -c '$(yaml2json.py)'

~ := debian-921-amd64-netinst

$~.json: $~.yml; < $< $(yaml2json) > $@

$~.yml.dep := $~.yml.gpp $~.gpp $~.in.yml
$~.yml: $($~.yml.dep); gpp $< > $@

$~.preseed.dep := $~.preseed.gpp $~.gpp $~.in.preseed
$~.preseed: $($~.preseed.dep); gpp $< > $@

main: $~.json $~.preseed
.PHONY: main

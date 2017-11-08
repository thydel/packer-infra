top:; @date

.DELETE_ON_ERROR:

yaml2json.py := import sys, yaml, json;
yaml2json.py += json.dump(yaml.load(sys.stdin), sys.stdout, indent=4, default=str, sort_keys=True)
yaml2json    := python -c '$(yaml2json.py)'

debian-921-amd64-netinst.json: debian-921-amd64-netinst.yml; < $< $(yaml2json) > $@

main: debian-921-amd64-netinst.json
.PHONY: main

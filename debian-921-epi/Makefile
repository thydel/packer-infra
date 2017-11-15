top:; @date

Makefile:;

SHELL != which bash
SHELL += -o pipefail

.DELETE_ON_ERROR:

yaml2json.py := import sys, yaml, json;
yaml2json.py += json.dump(yaml.load(sys.stdin), sys.stdout, indent=4, default=str, sort_keys=True)
yaml2json    := python -c '$(yaml2json.py)'

ifndef PACKER_DEBIAN_PASSWD
$(error PACKER_DEBIAN_PASSWD must be defined)
endif

packer_dir := ~/packer
export OUTPUT_DIRECTORY ?= $(wildcard $(packer_dir))

build_name = $(strip $1)/packer-$(strip $1).vmx

NAME := debian-921-epi
step := adm
VM_NAME := $(NAME)-$(step)
clone := debian-921-amd64-netinst-base
SOURCE := $(call build_name, $(clone))
SSH_USERNAME := debian
VNC_PORT := 5959

gpp = gpp $(foreach _, $($(@F).vars), -D_$_='$($_)')

template.yml.vars := NAME VM_NAME SOURCE SSH_USERNAME VNC_PORT
template.yml.deps := template.gpp template.in.yml macros.gpp Makefile
tmp/template.yml: $(template.yml.deps); $(gpp) $< > $@

jq := { builders, provisioners, variables }
tmp/template.json: tmp/template.yml; < $< $(yaml2json) | jq '$(jq)' > $@

####

conf := tmp/template.json
conf: $(conf);

build := $(packer_dir)/$(call build_name, $(VM_NAME))
$(build): $(conf); packer build $<
build: $(build);

run: $(build); vmplayer $<

main: conf build;
vnc:; @echo xtigervncviewer localhost:$(VNC_PORT)

.PHONY: conf build run main vnc

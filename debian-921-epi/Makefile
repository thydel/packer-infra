top:; @date

Makefile template.gpp template.in.yml macros.gpp:;

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

build_name = $(strip $1)/packer-$(strip $1)
vmfmts := vmx ovf ova
$(strip $(foreach _, $(vmfmts), $(eval $__name = $$(call build_name, $$1).$_)))

NAME := debian-921-epi
step := adm
VM_NAME := $(NAME)-$(step)
clone_name := debian-921-amd64-netinst-base
VMX_SOURCE := $(call vmx_name, $(clone_name))
OVF_SOURCE := $(call ovf_name, $(clone_name))
SSH_USERNAME := debian
VNC_PORT := 5959
VRDP_PORT := $(VNC_PORT)

gpp = gpp $(foreach _, $($(@F).vars), -D_$_='$($_)')

template.yml.vars := NAME VM_NAME VMX_SOURCE OVF_SOURCE SSH_USERNAME VNC_PORT VRDP_PORT
template.yml.deps := template.gpp template.in.yml macros.gpp Makefile tmp/.stone
tmp/template.yml: $(template.yml.deps); $(gpp) $< > $@
tmp/.stone:; mkdir -p $(@D); touch $@

jq := { builders, provisioners, variables }
tmp/template.json: tmp/template.yml; < $< $(yaml2json) | jq '$(jq)' > $@

####

clone_vmx := $(packer_dir)/$(call vmx_name, $(clone_name))
clone_ovf := $(packer_dir)/$(call ovf_name, $(clone_name))
$(clone_ovf): $(clone_vmx); ovftool $< $@
$(clone_vmx):;
ovf: $(clone_ovf);

conf := tmp/template.json
conf: $(conf);

export PACKER_LOG := 1
export PACKER_LOG_PATH := tmp/$(VM_NAME).txt

build_ova := $(packer_dir)/$(call ova_name, $(VM_NAME))
ifdef NEVER
$(build_ova): $(conf) $(clone_ovf); packer build $(FORCE) -only=$(VM_NAME) $<
else
$(build_ova): $(clone_ovf); packer build $(FORCE) -only=$(VM_NAME) $(conf)
endif
build_ova: $(build_ova)

build_vmx := $(packer_dir)/$(call vmx_name, $(VM_NAME))
$(build_vmx): $(build_ova); ovftool --lax $< $@
build_vmx: $(build_vmx)

build: build_vmx

# ineffective
# export VBOX_USER_HOME := $(OUTPUT_DIRECTORY)
vbox-reset:; vboxmanage setproperty machinefolder ~/"VirtualBox VMs"
vbox: get :=   vboxmanage list systemproperties
vbox: get += | grep '^Default machine folder'
vbox: get += | cut -d: -f2
vbox: dir := $(strip $(shell $(get)))
vbox: import :=
vbox: import += vboxmanage setproperty machinefolder $(OUTPUT_DIRECTORY);
vbox: import += vboxmanage import $(clone_ovf) --vsys 0 --ostype Linux_64 --vmname $(clone_name)-vbox;
vbox: import += vboxmanage setproperty machinefolder "$(dir)";
vbox: $(clone_ovf); $(import)

run: $(build); vmplayer $<

main: conf build;
vnc:; @echo xtigervncviewer localhost:$(VNC_PORT)

.PHONY: conf build_ova build_vmx build ovf ova run main vnc

FORCE :=
force := FORCE := -force

vartar := force

$(vartar):; @: $(eval $($@))

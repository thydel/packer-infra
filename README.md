# Usage

Optionally

```
pass generate packer/debian-921-amd64-netinst/debian 16
```

# Generate base image

```bash
export PACKER_DEBIAN_PASSWD="$(pass packer/debian-921-amd64-netinst/debian)" # or
export PACKER_DEBIAN_PASSWD="$(pwgen -N1 16)"
make -C debian-921-amd64-netinst force build FULL=1
```

Will build a base `debian-9.2.1` image (default to
`~/packer/debian-921-amd64-netinst-base`) from
`debian-9.2.1-amd64-netinst.iso` using a modified stretch example
preseed file and a modified `partman-auto/text/multi_scheme` extracted
from `partman-auto_137_amd64.udeb`

- The `vmware-iso` builder is used
- A system group `sudo-nopasswd` is created
- A `/etc/sudoers.d/sudo-nopasswd` file allowing members of
  `sudo-nopasswd` to sudo without password is added
- A `debian` user with UID 999 and password `$PACKER_DEBIAN_PASSWD` is
  created and added to group `sudo-nopasswd`

On my debian9 workstation

- Gnu Make 4.1
- GPP 2.24
- Python 2.7.13
- jq-1.5rc2-171-g6f9646a
- packer 1.0.4
- VMware Player 12.5.7 build-5813279

# Generate derived images

```
export PACKER_DEBIAN_PASSWD="$(pass packer/debian-921-amd64-netinst/debian)"
make -C debian-921-epi force build FULL=1
```

Will build a `debian-921-epi` images from `debian-921-amd64-netinst-base`

- The `debian-921-amd64-netinst-base` is first converted to `ova`
- Then the `virtualbox-ovf` builder is used
- `open-vm-tools` is installed
- `ansible` is installed to allow using `ansible-local` provisioners
- A `users.yml` playbook is used to created team users using their
  public key from `github.com`
- Finally `debian-921-epi` is converted from `ova` to `vmx`

On my debian9 workstation

- VMware ovftool 4.1.0 (build-3634792)
- VirtualBox Version 5.1.30 r118389 (Qt5.7.1)

# Push image

Granted we first used `pass` to obscure private data about the vcenter config

```
export image=debian-921-epi
export i=packer/$image

export ova=~/$i/packer-$image.vmx

export      ds=$(pass $i/ds)
export     net=$(pass $i/net)
export    user=$(pass $i/vc/user)
export    pass=$(pass $i/vc/pass)
export vcenter=$(pass $i/vc/node)
export cluster=$(pass $i/vc/cluster)

ovftool --X:logToConsole=True --X:logLevel="verbose" --acceptAllEulas \
        -ds=$ds -dm=thin --net:nat=$net $ova \
        "vi://$user:$pass@$vcenter/$cluster"
```

Or more concisely `make -C debian-921-epi push`

# Test playbooks on a running image

To ease later provisioning steps you can also

```bash
make -C debian-921-epi run     # show how to run image
# run image
make -C debian-921-epi ansible # generate debian-921-epi/ansible/hosts.yml
(cd debian-921-epi/ansible; ansible-playbook playbook.yml)
```

# Comments

Obviously more ansible provisioning and/or more derived images could
easily be added and may not be documented here

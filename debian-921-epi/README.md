Now that we have a image built from a ISO, try to build a second stage
from the first image.

And failed because (See [packer/issues/2395][])

> Cloning and linked cloning are licensed / paid features in VMware
> Workstation and Fusion / Fusion Pro.

[packer/issues/2395]: https://github.com/hashicorp/packer/issues/2395 "github.com"

Thus try to clone our base image using virtualbox instead of vmware.

This require to change the `boot_command` of base template to add
`biosdevname=0 net.ifnames=0` because the `vmware-iso` builder (using
`vmplayer`) results in an image where first ethernet device has a
different name than the one computed by `VBoxManage` used by
`virtualbox-ovf` builder.

This also require to add `import_flags: [ --ostype, Linux_64 ]` to
avoid the imported image to hang after boot.

# Log

```
make clean              # remove generated files
make conf               # generate template
make build              # if no image yet
	                    # convert from vmx to ova and back to use virtualbox instead of vmplayer
make force build        # build --force
make build FULL=1       # build if template changed
make force build FULL=1 # build --force if template changed

make vnc                # show how to run vnd
make run                # show how to run vm
make ip                 # show ip of running vm
make password           # use pass to generate vm dedicated user password
make ansible            # generate ansible host file to run local ansible play
```

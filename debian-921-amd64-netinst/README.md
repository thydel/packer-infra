Starting from

- Some found repos

	- [Packer Example - Debian 8 minimal Vagrant Box][]
	- [Packer Automated VM Image and Vagrant Box Builds][]

[Packer Example - Debian 8 minimal Vagrant Box]: https://github.com/geerlingguy/packer-debian-9 "github.com"
[Packer Automated VM Image and Vagrant Box Builds]: https://github.com/tylert/packer-build "github.com"

- Some debian docs

	- [Debian GNU/Linux Installation Guide][]
	- [Contents of the preconfiguration file (for stretch)][]

[Debian GNU/Linux Installation Guide]: https://www.debian.org/releases/stretch/amd64/ "www.debian.org"
[Contents of the preconfiguration file (for stretch)]:
	https://www.debian.org/releases/stable/amd64/apbs04.html.en "www.debian.org"

- Obviously, the [Packer Documentation][]

[Packer Documentation]: https://www.packer.io/docs/ "www.packer.io"

- Because we want a `vmware` images

	- [VMX-file parameters][]

[VMX-file parameters]: http://sanbarrow.com/vmx.html "sanbarrow.com"

Try to make a simple `debian9` build for `vmware`

# First step using multi recipe for partitioning

- We want too keep a separate `root`, `var`, `tmp` and `home`
- But auto partitioning give to many space to `home`
- Then we want to make the minimal changes to the std multi recipe
- Which is rather difficult to find as [partman-auto][] because
  `apt-file` wont find `debian-installer` related packages

[partman-auto]: https://packages.debian.org/stretch/amd64/partman-auto "packages.debian.org"

# Second step altering std multi recipe

Starting from `lib/partman/recipes/80multi` in [partman-auto][] and
taking advices from [Understanding partman-auto/expert_recipe][] and
[Dynamic disk partitioning with Debian preseed][]

[Understanding partman-auto/expert_recipe]:
	https://www.bishnet.net/tim/blog/2015/01/29/understanding-partman-autoexpert_recipe/ "www.bishnet.net"

[Dynamic disk partitioning with Debian preseed]: https://www.claudioborges.org/?p=733 "www.claudioborges.org"

# Log

```
make clean              # remove generated template and preseed
make conf               # generate template and preseed
make build              # if no image yet
make force build        # build --force
make build FULL=1       # build if template or preseed changed
make force build FULL=1 # build --force if template or preseed changed

make vnc                # show how to run vnd
make run                # show how to run vm

make example-preseed    # get stretch example preseed file 
make recipes            # get partman-auto multi_scheme file
```

# xspec-build
A temporary repository for creating a reproducible way of building X-Spec, for supporting Sherpa

## Contents

This repo contains:

  * conda recipes for:
    * cfitsio
    * CCfits
    * Xspec models-only
  * a Vagrantfile that can be used to provision a VM that can be used to reproduce the conda builds
  
## How to run the VM

To run the vagrant box one needs:
  * Vagrant
  * VirtualBox

Once the repository is cloned, one can simply run:

~~~~
$ vagrant up
~~~~

and an Ubuntu 12.04 x86_64 system will be created and provisioned with everything required to build the conda binaries.

The Vagrantfile also contains some commented out lines with the interactive commands required to build
the binaries themselves.

To upload the results to `anaconda.org` one needs to have an account on the anaconda platform.
It is not particularly important where the account is,
as long as the Travis CI configuration uses this repository to suck in the binaries.

## Conda recipes

The conda recipes are not particularly sophisticated, but they serve their purpose. The binaries should
not be considered portable, but they are only supposed to run on the Travis CI workers, for now.

On the other hand, the Vagrantfile and the recipes in this repo might be used to write specific documentation on how to
build Xspec for Standalone Sherpa.

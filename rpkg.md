This file (makestuff/rpkg.mk) is meant to help manage and build an R package.

It is designed to be called from the main package directory, and it puts tar files there; these should be ignored .Rbuildignore. It also tracks progress using a directory called rpkgbuild/, which should be ignored

The main targets are
* pkgall: cleans, builds documentation, makes the NAMESPACE file, builds a tarball, installs and checks
* dinst: does a "quick" install from the directory

Under development:
* pkgtest: builds the tarball and does test().

If you are using the makestuff framework, it should work to `make VERSION.var` to see the current version name, parsed from the DESCRIPTION file. This is how the made tarball is named.

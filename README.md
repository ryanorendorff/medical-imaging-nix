Packaging Medical Imaging Software with Nix
===========================================

[![Build Status](https://travis-ci.org/ryanorendorff/medical-imaging-nix.svg?branch=master)](https://travis-ci.org/ryanorendorff/medical-imaging-nix)

Creating reproducible software installations is a tough challenge. This task
is especially challenging in medical imaging software, which often has to
communicate with custom hardware, FPGAs, GPUs, and many other physical
devices that have unusual or outdated software dependencies. In this talk we
will discuss how Nix and NixOS assists in making a reproducible environment
for our software, the benefits gained by this method, and some of the
challenges encountered along the way.

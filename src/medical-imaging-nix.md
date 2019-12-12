---
title: Packaging Medical Imaging Software with Nix
subtitle: https://github.com/ryanorendorff/medical-imaging-nix
date: December 12th, 2019
author: Ryan Orendorff
header-includes: |
  \definecolor{BerkeleyBlue}{RGB}{0,50,98}
  \definecolor{FoundersRock}{RGB}{59,126,161}
  \definecolor{Medalist}{RGB}{196,130,14}
  \setbeamercolor{frametitle}{fg=white,bg=FoundersRock}
  \setbeamercolor{title separator}{fg=Medalist,bg=white}
---


Overview of the talk
--------------------

- Introduction to Magnetic Particle Imaging (MPI).
- How to set up systems with tons of dependencies like MPI.
- What worked well, what did not work as well.


Magnetic Particle Imaging: Detecting Iron Nanoparticles using Magnetic Fields
=============================================================================

MPI detects iron in the blood 
-----------------------------

Magnetic Particle Imaging (MPI) is an emerging medical imaging technology that
images iron particle distribution in a body.\

![Left: MPI Hardware. Right: Image of rat cerebral circulation. Courtesy Conolly Lab, UC Berkeley](fig/mpi.png)


Components used in MPI systems
------------------------------

MPI systems require quite a few components to be handled by the software to
acquire an image.

::: incremental

- Acquisition devices (DAQs), to convert our input/output signals to digital form.
- Custom electronics with custom firmware.
- A Real-Time OS for correct timing.
- Motors to move the sample.
- Auxillary devices connected via ethernet.
- GPUs.
- Hardware and software safety systems/daemons.
- Service level access to debug information/tools.

:::

. . .

Pinning all this down can be hard!


System Diagram of what is required
----------------------------------

PUT A FIGURE HERE!


Prior challenges faced
----------------------

Previously the MPI systems have been run on Windows systems. This presents
some challenges.

::: incremental

- Creating the same setup twice is hard.
  - Easy for one developer to have different system level packages.
- Creating the same setup _over time_ is very hard.
  - Old files/packages can disappear from the internet, information lost
    between developers, etc.
- Windows likes to update itself.
  - Can cause driver issues, API issues, dependency issues, etc.
- Upgrading/servicing devices in the field detailed knowledge of the changes.
  - System level state is not easily tracked.

:::


Our Requirements for NixOS
--------------------------

To solve our pain points, we defined the following requirements.

- An easy deployment strategy that any developer/field technician can run.
- No knowledge of the system version changes required.
- Well defined system state, both for our software and the OS.


NixOS to the rescue! (mostly)
=============================


We used NixOS to pin down a bunch of our software stack
-------------------------------------------------------

PUT FIGURE HERE! Maybe of the same diagram but showing where Nix is involved?

In this section we are going to tackle how each component was "nixified".


How to package python environment
---------------------------------

Include example of a package that is not defined in the nixpkgs repository.

Describe how Python presents interesting challenges because system level
packages are not always defined in the setup.py file.


How to package GUI programs
---------------------------

Example: 3DSlicer


How to package developer tools
------------------------------

Use chroot to simulate where things should go.
Use a Windows VM


How to package system daemons
-----------------------------

Adding a system service works.


How to pin the whole system
---------------------------

Pin using the method Gabriel mentions.


Lessons Learned
===============


Lessons learned the hard way
----------------------------

We found out a few things the hard way.

::: incremental

- Don't trust that a repository will not switch out a file with one of the
  same name.
- Wrapping up proprietary code is difficult. Best avoided if possible.
- Defining the setup takes longer than on other systems (Ubuntu, Windows, etc).
  - This can be thought of as an "up front cost".

:::


Advantages gained by NixOS
--------------------------

We gained quite a bit by going to NixOS.

- Simple and robust deployments.
- Easier field service.
- Easier setup for developers.
- A text file completely defines the state of the system.


Advantages of the old method
----------------------------

The old Windows setup had some advantages over the new NixOS setup.

- Getting developers on board was easier.
- Faster to get to a working state.
  - Developers can spend non-trivial time setting up a nix expression before
    they can start their work.
- Better support for almost everything (drivers, etc)
- Nixpkgs/NixOS documentation is both underwhelming and overwhelming.


Questions?
----------

![](fig/question.jpg)

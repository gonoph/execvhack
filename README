# execvhack
shared library that overrides `execv()` and it's like and prints out the argv[] values to stderr.

## OVERVIEW OF USAGE
by Billy Holmes <billy@gonoph.net>

This library is an example of how to perform LD\_PRELOAD, and is an example of how certain system calls can be hijacked for other purposes. Imagine malloc() being  hijacked, and a new thread being created which monitors the memory pointers of everything returned by the original `malloc()` function. Based on other filters and logic, this thread could easedrop or change memory which the calling program assumed was secure or immutable.

While this is not a huge concern for normal open source software, proprietary software, or security software maybe concerned.

Additionally, a noble developer may use this solve a bug, or implement a feature that wasn't included in an existing library for which there is no original code (inherited systems anyone???). The sky is the limit here - it's just up to your imagination!

### To build it:

Only for the build step, you will need to download `shc` from http://www.datsi.fi.upm.es/~frosal/, and install it. Or you can use the pre-compiled RPM, I made here: http://www.gonoph.net/repos/gonoph.net/generic/dist/shc-3.8.9b-1.x86\_64.rpm

    $ make all

### To install the shared library under /usr/local:

    $ make install

### OR just install it from the execvhack.spec file.

    $ make dist && mkdir -p ~/rpmbuild/SOURCES && cp -v *.tgz ~/rpmbuild/SOURCES
    $ rpmbuild -ba execvhack.spec
    $ sudo yum install `ls ~/rpmbuild/RPMS/$(uname -p)/execvhack-*.rpm | head -1`

### OR just download it from my repository:

    $ sudo rpm -ivh http://www.gonoph.net/repos/gonoph.net/generic/dist/gonophnet-generic-1.0.0-1.x86_64.rpm
    $ sudo yum install -y execvhack

## HOW TO USE IT

    $ LD_PRELOAD=/usr/local/lib/execvhack.so sh -c 'sh -c "/bin/echo this is a test"'
    Loading hack.
    /usr/bin/sh: argv[0]: [[sh]]
    /usr/bin/sh: argv[1]: [[-c]]
    /usr/bin/sh: argv[2]: [[/bin/echo this is a test]]
    Loading hack.
    /bin/echo: argv[0]: [[/bin/echo]]
    /bin/echo: argv[1]: [[this]]
    /bin/echo: argv[2]: [[is]]
    /bin/echo: argv[3]: [[a]]
    /bin/echo: argv[4]: [[test]]
    Loading hack.
    this is a test

## REAL WORLD EXAMPLE

After it's built, there is a script in the build directory (or emedded in the archive) called `./secret`. It's built using a program called `shc` by Francisco Javier Rosales García (http://www.datsi.fi.upm.es/~frosal/). The binary is based on the source of `secret.sh`. If you built it, you can run it from there, if you installed it, based on your distro, it should reside in your "docs" directory. On fedora and gentoo type installs, that's in `/usr/share/doc/execvhack`. There maybe a version number behind it.

### When you run it:

    $ ./secret
    Type the secret:
    ERROR!! You don't know the SECRET!

### If you perform the preload trick:

    $ echo | LD_PRELOAD=/usr/local/lib/execvhack.so  ./secret 2>&1 > /dev/null | grep SECRET=
    _SECRET=### RANDOM ###

After the grep, you should see the secret password. If you use that secret code, it will compile and run an embedded C program that demostrates a rounding bug in casting int from a double. This bug exists in python, C, perl, and java.

You can look at the original "secret" shell script, the embedded shell script, and the embedded C program in the following files:

    secret.sh
    mycode.sh
    mycode.c

Additionally, to check the compiled script vs the original:

    $ echo | LD_PRELOAD=/usr/local/lib/execvhack.so  ./secret 2>&1 > /dev/null | sed -n '/#!\/bin\/sh$/,/]]/p' | \
    sed 's%^.*\(#!/bin/sh\)$%\1%' | head -n -1 | sha256sum ; sha256sum secret.sh
    aead59f0462b7438941c342bb59c914d27f84610cb97d1a75824199edea44170  -
    aead59f0462b7438941c342bb59c914d27f84610cb97d1a75824199edea44170  secret.sh

And to check the embedded shell script vs the original:

    $ ./secret --check ; sha256sum mycode.sh
    Checking sha256 checksum
    50e2581f858224d857eb854061b3dc2c95069abf730a8e29db26318ee8f51d07  -
    50e2581f858224d857eb854061b3dc2c95069abf730a8e29db26318ee8f51d07  mycode.sh

Happy hacking!!

--b

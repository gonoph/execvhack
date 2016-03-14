Name:		execvhack
Version:	1.0.0
Release:	1
Summary:	Library and example script used to show LD_PRELOAD

License:	GNU
URL:		http://www.gonoph.net
Source0:	execvhack-1.0.0.tgz

BuildRequires:	shc
# Requires:	

%description
Simple LD_PRELOAD example to show how to hijack execvp() system call to print out
arguments of programs that are being executed, especially when they are trying
to hide them via special ptrace() and /proc/$pid/kmem:EXCLUSIVE tricks to prevent
debugging or tracing.

%prep
%setup -q


%build
make %{?_smp_mflags}


%install
%make_install
gzip %{buildroot}/usr/local/man/man2/execvhack.so.2


%files
%attr(755, root, bin) /usr/local/lib/execvhack.so
%attr(644, root, bin) /usr/local/man/man2/execvhack.so.2.gz
%doc Copying README.md execvhack.c mycode.c mycode.sh sample.c secret secret.sh secret.sh.x.c



%changelog
* Sun Mar 13 2016 Billy Holmes <billy@gonoph.net - 1.0.0-1
- initial project creation


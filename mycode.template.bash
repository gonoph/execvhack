#!/bin/bash

cat<<CREATE_MYCODE.BASH > mycode.bash
#!/bin/bash

A='#!/bin/bash
set -e
T=\$(mktemp)
trap "rm -fv \$T" EXIT
'
B='gcc -w -xc -o \$T - <<EOF
'
C='$(sed -n '/START VAR C/,/END VAR C/p' mycode.c | grep -v 'VAR C')
EOF
\$T'
D='$(sed -n '/START VAR D/,/END VAR D/p' mycode.c | grep -v 'VAR D')
'

echo "\$A""\$B""\$C"
echo "\$A""\$B""\$D""\$C" | bash
CREATE_MYCODE.BASH

MYCODE_REPLACEMENT=$(gzip -c < mycode.bash | base64 -w 0)
sed "s,__MYCODE_REPLACEMENT__,$MYCODE_REPLACEMENT," secret.template

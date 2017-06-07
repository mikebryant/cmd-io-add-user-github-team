#!cmd alpine bash curl
#!/bin/bash

set -eux

# CGI env parsing
saveIFS=$IFS
IFS='=&'
parm=($QUERY_STRING)
IFS=$saveIFS

for ((i=0; i<${#parm[@]}; i+=2))
do
    declare var_${parm[i]}=${parm[i+1]}
done
# End CGI env parsing

# User filtering
if [ ! -n "`echo ${ALLOWED_USERS} | xargs -n1 echo | grep -e \"^${var_user_name}\$\"`" ]; then
  echo "User ${var_user_name} not whitelisted"
  exit 3
fi
# End User filtering

if curl \
  --fail \
  --silent \
  -o /dev/null \
  -H "Authorization: token ${AUTH_TOKEN}" \
  -X PUT \
  https://api.github.com/teams/${TEAM_ID}/memberships/${var_text} \
; then
  echo "Success :)"
else
  echo "Adding user failed :("
fi

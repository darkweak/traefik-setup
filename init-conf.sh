#!/usr/bin/env bash

#########   VARIABLE PARAMETERS SYNTAXS   ############
#     "domain:folder:service1,service2,service3"     #
################                      ################

parameters=(
  "devcv.fr:cv-spa:admin,api,cache,client,mercure,ssr"
)
text="[http.routers]"

for x in "${parameters[@]}"
do
  IFS=':'
  read -ra ADDR <<< "$x"
  domain="${ADDR[0]}"
  folder="${ADDR[1]}"
  IFS=','
  read -ra SERVICES <<< "${ADDR[2]}"
  for s in "${SERVICES[@]}"
  do
    text+="
  [http.routers.$s-$folder]
    [http.routers.$s-$folder.tls]
      [[http.routers.$s-$folder.tls.domains]]
        main = \"$domain\"
        sans = [\"*.$domain\"]
"
  done
done

echo "$text" > ./domains.toml

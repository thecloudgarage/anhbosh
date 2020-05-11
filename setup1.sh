#!/bin/bash
source /home/ubuntu/dns
export tanzuOpsmanDNSName=$tanzuOpsmanDNSName
  if [ -z "$1" ]; then
  echo "IP not given...trying EC2 metadata...";
  IP=$( curl http://169.254.169.254/latest/meta-data/public-ipv4 )
  else
  IP="$1"
  fi
  echo "IP to update: $IP"
  sudo sed "\$a$IP $tanzuOpsmanDNSName" /etc/hosts > /etc/hosts.temp && mv /etc/hosts.temp /etc/hosts
  curl -k "https://$tanzuOpsmanDNSName/api/v0/setup" \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{ "setup": {
  "decryption_passphrase": "admin",
  "decryption_passphrase_confirmation":"admin",
  "eula_accepted": "true",
  "identity_provider": "internal",
  "admin_user_name": "admin",
  "admin_password": "admin",
  "admin_password_confirmation": "admin"
} }'
sleep 2m
source /home/ubuntu/token
export pivnetToken=$pivnetToken
export stemcell456PivnetUrl=https://network.pivotal.io/api/v2/products/stemcells-ubuntu-xenial/releases/579634/product_files/613151/download
export stemcell456PivnetProductName=light-bosh-stemcell-456.98-aws-xen-hvm-ubuntu-xenial-go_agent.tgz
export stemcell621PivnetUrl=https://network.pivotal.io/api/v2/products/stemcells-ubuntu-xenial/releases/630534/product_files/667978/download
export stemcell621PivnetProductName=light-bosh-stemcell-621.71-aws-xen-hvm-ubuntu-xenial-go_agent.tgz
export stemcell315PivnetUrl=https://network.pivotal.io/api/v2/products/stemcells-ubuntu-xenial/releases/626507/product_files/663626/download
export stemcell315PivnetProductName=light-bosh-stemcell-315.179-aws-xen-hvm-ubuntu-xenial-go_agent.tgz
export stemcell2019PivnetUrl=https://network.pivotal.io/api/v2/products/stemcells-windows-server/releases/630457/product_files/666943/download
export stemcell2019PivnetProductName=light-bosh-stemcell-2019.20-aws-xen-hvm-windows2019-go_agent.tgz
export stemcell250PivnetUrl=https://network.pivotal.io/api/v2/products/stemcells-ubuntu-xenial/releases/630535/product_files/667986/download
export stemcell250PivnetProductName=light-bosh-stemcell-250.196-aws-xen-hvm-ubuntu-xenial-go_agent.tgz
export pasPivnetUrl=https://network.pivotal.io/api/v2/products/elastic-runtime/releases/582590/product_files/616376/download
export pasPivnetProductName=cf-2.8.4-build.16.pivotal
export pksPivnetUrl=https://network.pivotal.io/api/v2/products/pivotal-container-service/releases/551663/product_files/582811/download
export pksPivnetProductName=pivotal-container-service-1.6.1-build.6.pivotal
export harborPivnetUrl=https://network.pivotal.io/api/v2/products/harbor-container-registry/releases/579832/product_files/613396/download
export harborPivnetProductName=harbor-container-registry-1.10.1-build.7.pivotal
export mysqlPivnetUrl=https://network.pivotal.io/api/v2/products/pivotal-mysql/releases/584606/product_files/618567/download
export mysqlPivnetProductName=pivotal-mysql-2.7.6-build.21.pivotal
export rabbitmqPivnetUrl=https://network.pivotal.io/api/v2/products/p-rabbitmq/releases/601550/product_files/636892/download
export rabbitmqPivnetProductName=p-rabbitmq-1.18.4-build.83.pivotal
export paswindowsPivnetUrl=https://network.pivotal.io/api/v2/products/pas-windows/releases/625232/product_files/662163/download
export paswindowsPivnetProductName=pas-windows-2.9.1-build.2.pivotal
export redisPivnetUrl=https://network.pivotal.io/api/v2/products/p-redis/releases/626432/product_files/663536/download
export redisPivnetProductName=p-redis-2.3.3-build.2.pivotal
export awsservicebrokerPivnetUrl=https://network.pivotal.io/api/v2/products/aws-services/releases/567835/product_files/600335/download
export awsservicebrokerPivnetProductName=aws-services-1.4.16.256.pivotal
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $stemcell456PivnetUrl -O "$stemcell456PivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $stemcell621PivnetUrl -O "$stemcell621PivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $stemcell315PivnetUrl -O "$stemcell315PivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $stemcell2019PivnetUrl -O "$stemcell2019PivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $stemcell250PivnetUrl -O "$stemcell250PivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $pasPivnetUrl -O "$pasPivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $pksPivnetUrl -O "$pksPivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $harborPivnetUrl -O "$harborPivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $mysqlPivnetUrl -O "$mysqlPivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $rabbitmqPivnetUrl -O "$rabbitmqPivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $paswindowsPivnetUrl -O "$paswindowsPivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $redisPivnetUrl -O "$redisPivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $awsservicebrokerPivnetUrl -O "$awsservicebrokerPivnetProductName"
export uaaToken=$( sudo curl -s -k -H 'Accept: application/json;charset=utf-8' -d 'grant_type=password' -d 'username=admin' -d 'password=admin' \
  -u 'opsman:' https://localhost/uaa/oauth/token |  jq --raw-output '.access_token' )
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/stemcells -F \
  'stemcell[file]=@'"$stemcell456PivnetProductName"''
sudo rm -rf $stemcell456PivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/stemcells -F \
  'stemcell[file]=@'"$stemcell621PivnetProductName"''
sudo rm -rf $stemcell621PivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/stemcells -F \
  'stemcell[file]=@'"$stemcell315PivnetProductName"''
sudo rm -rf $stemcell315PivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/stemcells -F \
  'stemcell[file]=@'"$stemcell2109PivnetProductName"''
sudo rm -rf $stemcell2019PivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/stemcells -F \
  'stemcell[file]=@'"$stemcell250PivnetProductName"''
sudo rm -rf $stemcell250PivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/available_products -F \
  'product[file]=@'"$pasPivnetProductName"''
sudo rm -rf $pasPivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/available_products -F \
  'product[file]=@'"$pksPivnetProductName"''
sudo rm -rf $pksPivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/available_products -F \
  'product[file]=@'"$harborPivnetProductName"''
sudo rm -rf $harborPivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/available_products -F \
  'product[file]=@'"$mysqlPivnetProductName"''
sudo rm -rf $mysqlPivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/available_products -F \
  'product[file]=@'"$rabbitmqPivnetProductName"''
sudo rm -rf $rabbitmqPivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/available_products -F \
  'product[file]=@'"$paswindowsPivnetProductName"''
sudo rm -rf $paswindowsPivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/available_products -F \
  'product[file]=@'"$redisPivnetProductName"''
sudo rm -rf $redisPivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/available_products -F \
  'product[file]=@'"$awsservicebrokerPivnetProductName"''
sudo rm -rf $awsservicebrokerPivnetProductName
export uaaToken=$( sudo curl -s -k -H 'Accept: application/json;charset=utf-8' -d 'grant_type=password' -d 'username=admin' -d 'password=admin' \
                  -u 'opsman:' https://localhost/uaa/oauth/token |  jq --raw-output '.access_token' )
curl "https://localhost/api/v0/staged/products" -k \
  -X POST \
  -H 'Authorization: Bearer '"$uaaToken"'' \
  -H "Content-Type: application/json" \
  -d '{"name": "cf", "product_version": "2.8.4"}'
curl "https://localhost/api/v0/staged/products" -k \
  -X POST \
  -H 'Authorization: Bearer '"$uaaToken"'' \
  -H "Content-Type: application/json" \
  -d '{"name": "pivotal-container-service", "product_version": "1.6.1-build.6"}'
curl "https://localhost/api/v0/staged/products" -k \
  -X POST \
  -H 'Authorization: Bearer '"$uaaToken"'' \
  -H "Content-Type: application/json" \
  -d '{"name": "harbor-container-registry", "product_version": "1.10.1-build.7"}'

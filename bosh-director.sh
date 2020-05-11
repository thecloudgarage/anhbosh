#!/bin/bash

export uaaToken=$( sudo curl -s -k -H 'Accept: application/json;charset=utf-8' -d 'grant_type=password' -d 'username=admin' -d 'password=admin' \
	  -u 'opsman:' https://localhost/uaa/oauth/token |  jq --raw-output '.access_token' )


curl "https://localhost/api/v0/staged/director/properties" \
    -X PUT \
    -H 'Authorization: Bearer '"$uaaToken"'' \
    -H "Content-Type: application/json" \
    -d '{
        "director_configuration": {
          "ntp_servers_string": "0.amazon.pool.ntp.org,1.amazon.pool.ntp.org,2.amazon.pool.ntp.org,3.amazon.pool.ntp.org",
          "resurrector_enabled": true,
          "post_deploy_enabled": false,
          "bosh_recreate_on_next_deploy": false,
          "bosh_recreate_persistent_disks_on_next_deploy": false,
          "retry_bosh_deploys": false,
          "keep_unreachable_vms": false,
          "skip_director_drain": false,
          "job_configuration_on_tmpfs": false,
          "database_type": "internal",
          "hm_pager_duty_options": {"enabled": false},
          "hm_emailer_options": {"enabled": false},
          }
        }'



curl "https://localhost/api/v0/staged/director/availability_zones" \
    -X PUT \
    -H 'Authorization: Bearer '"$uaaToken"'' \
    -H "Content-Type: application/json" \
    -d '{
          "availability_zones": [
            { "name": "us-east-1a" }
			{ "name": "us-east-1b" }
          ]
        }'
	  
export boshguid=$( curl "https://localhost/api/v0/staged/products" -k \
          -X GET \
            -H 'Authorization: Bearer '"$uaaToken"'' \
              | jq --raw-output '.[] | select(.installation_name|test("p-.")) | .guid')
		  
	  
curl "https://localhost/api/v0/staged/products/$boshguid/networks_and_azs" \
    -X PUT \
    -H 'Authorization: Bearer '"$uaaToken"'' \
    -H "Content-Type: application/json" \
    -d '{
  "networks": [
    {
      "name": "TANZU-VPC-INFRA",
      "subnets": [
        {
          "iaas_identifier": "TANZU_VPC_INFRA_AZ1",
          "cidr": "10.0.1.0/24",
          "dns": "10.0.1.2",
          "gateway": "10.0.1.1",
          "reserved_ip_ranges": "10.0.1.0-10.0.1.10",
          "availability_zone_names": [
            "us-east-1a"
          ]
        },
		{
          "iaas_identifier": "TANZU_VPC_INFRA_AZ2",
          "cidr": "10.0.2.0/24",
          "dns": "10.0.2.2",
          "gateway": "10.0.2.1",
          "reserved_ip_ranges": "10.0.2.0-10.0.2.10",
          "availability_zone_names": [
            "us-east-1b"
          ]
        },
		{
          "iaas_identifier": "TANZU_VPC_TAS_AZ1",
          "cidr": "10.0.11.0/24",
          "dns": "10.0.11.2",
          "gateway": "10.0.11.1",
          "reserved_ip_ranges": "10.0.11.0-10.0.11.10",
          "availability_zone_names": [
            "us-east-1a"
          ]
        },
		{
          "iaas_identifier": "TANZU_VPC_TAS_AZ2",
          "cidr": "10.0.12.0/24",
          "dns": "10.0.12.2",
          "gateway": "10.0.12.1",
          "reserved_ip_ranges": "10.0.12.0-10.0.12.10",
          "availability_zone_names": [
            "us-east-1b"
          ]
        },
		{
          "iaas_identifier": "TANZU_VPC_TKG-I_AZ1",
          "cidr": "10.0.21.0/24",
          "dns": "10.0.21.2",
          "gateway": "10.0.21.1",
          "reserved_ip_ranges": "10.0.21.0-10.0.21.10",
          "availability_zone_names": [
            "us-east-1a"
          ]
        },
		{
          "iaas_identifier": "TANZU_VPC_TKG_I_AZ2",
          "cidr": "10.0.22.0/24",
          "dns": "10.0.22.2",
          "gateway": "10.0.22.1",
          "reserved_ip_ranges": "10.0.22.0-10.0.22.10",
          "availability_zone_names": [
            "us-east-1b"
          ]
        },
		{
          "iaas_identifier": "TANZU_VPC_SERVICES_AZ1",
          "cidr": "10.0.31.0/24",
          "dns": "10.0.31.2",
          "gateway": "10.0.31.1",
          "reserved_ip_ranges": "10.0.31.0-10.0.31.10",
          "availability_zone_names": [
            "us-east-1a"
          ]
        },
		{
          "iaas_identifier": "TANZU_VPC_SERVICES_AZ2",
          "cidr": "10.0.32.0/24",
          "dns": "10.0.32.2",
          "gateway": "10.0.32.1",
          "reserved_ip_ranges": "10.0.32.0-10.0.32.10",
          "availability_zone_names": [
            "us-east-1b"
          ]
        },
       ]
    }
  ]
}'

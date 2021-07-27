zone=k8s.it
dnsrecord=_spf.k8s.it

cloudflare_token=

ip=$(curl -s -X GET https://checkip.amazonaws.com)

echo "Current IP is $ip"

if dig +short TXT $dnsrecord | grep "$ip"; then
  echo "$dnsrecord is currently set to $ip; no changes needed"
  exit
fi


zoneid=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$zone&status=active" \
  -H "Authorization: Bearer $cloudflare_token" \
  -H "Content-Type: application/json" | jq -r '{"result"}[] | .[0] | .id')

echo "Zoneid for $zone is $zoneid"

dnsrecordid=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records?type=TXT&name=$dnsrecord" \
  -H "Authorization: Bearer $cloudflare_token" \
  -H "Content-Type: application/json" | jq -r '{"result"}[] | .[0] | .id')

echo "DNSrecordid for $dnsrecord is $dnsrecordid"

txt="v=spf1 ip4:$ip"

curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records/$dnsrecordid" \
  -H "Authorization: Bearer $cloudflare_token" \
  -H "Content-Type: application/json" \
  --data "{\"type\":\"TXT\",\"name\":\"$dnsrecord\",\"content\":\"$txt\",\"ttl\":1,\"proxied\":false}" | jq
# cloudflare-spf-txt-update
update txt record on cloudflare when the connection has dynamic ip

```
+ zone=k8s.it
+ dnsrecord=_spf.k8s.it
+ cloudflare_token=XXX
+ curl -s -X GET https://checkip.amazonaws.com
+ ip=87.5.136.222
+ echo Current IP is 87.5.136.222
Current IP is 87.5.136.222
+ dig +short TXT _spf.k8s.it
+ grep 87.5.136.222
"v=spf1 ip4:87.5.136.222"
+ echo _spf.k8s.it is currently set to 87.5.136.222; no changes needed
_spf.k8s.it is currently set to 87.5.136.222; no changes needed
```


```
+ zone=k8s.it
+ dnsrecord=_spf.k8s.it
+ cloudflare_token=XXX
+ curl -s -X GET https://checkip.amazonaws.com
+ ip=87.5.136.222
+ echo Current IP is 87.5.136.222
Current IP is 87.5.136.222
+ dig +short TXT _spf.k8s.it
+ grep 87.5.136.222
+ + jq -r {"result"}[] | .[0] | .id
curl -s -X GET https://api.cloudflare.com/client/v4/zones?name=k8s.it&status=active -H Authorization: Bearer XXX -H Content-Type: application/json
+ zoneid=YYY
+ echo Zoneid for k8s.it is ZZZ
Zoneid for k8s.it is YYY
+ curl -s -X GET https://api.cloudflare.com/client/v4/zones/YYY/dns_records?type=TXT&name=_spf.k8s.it -H Authorization: Bearer XXX -H Content-Type: application/json
+ jq -r {"result"}[] | .[0] | .id
+ dnsrecordid=ZZZ
+ echo DNSrecordid for _spf.k8s.it is ZZZ
DNSrecordid for _spf.k8s.it is ZZZ
+ txt=v=spf1 ip4:87.5.136.222
+ curl -s -X PUT https://api.cloudflare.com/client/v4/zones/YYY/dns_records/ZZZ -H Authorization: Bearer XXX -H Content-Type: application/json --data {"type":"TXT","name":"_spf.k8s.it","content":"v=spf1 ip4:87.5.136.222","ttl":1,"proxied":false}
+ jq
{
  "result": {
    "id": "YYY",
    "zone_id": "ZZZ",
    "zone_name": "k8s.it",
    "name": "_spf.k8s.it",
    "type": "TXT",
    "content": "v=spf1 ip4:87.5.136.222",
    "proxiable": false,
    "proxied": false,
    "ttl": 1,
    "locked": false,
    "meta": {
      "auto_added": false,
      "managed_by_apps": false,
      "managed_by_argo_tunnel": false,
      "source": "primary"
    },
    "created_on": "2021-07-26T20:22:17.276618Z",
    "modified_on": "2021-07-27T17:06:27.530111Z"
  },
  "success": true,
  "errors": [],
  "messages": []
}
```

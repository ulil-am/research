curl  -H "Content-Type:application/json" -H "x-request-id:c0d519ea-c3bd-4818-8f86-8b67dc876457" -H "x-real-ip:localhost" -H "x-caller-service:client" -H "x-caller-domain:caller-domain" -H "x-device:android" -H "datetime:2017-08-24T13:43:56.41906615Z" -H "accept:application/json" -H "x-b3-traceid: abcd" -H "x-b3-spanid:span-acc" -H "x-b3-parentspanid: partent-span-acc" -H "x-b3-sampled: spalmed" -H "x-b3-flags: yes" -H "x-ot-span-context:abcd" -d '{"rqBody":{"cif_number":34221334,"product_code":"DSAV1001","customer_name":"Bon for finX","cif_customer_type":"1010","account_branch":1,"user_id":"1","payment_condition":"สั่งจ่ายเพียงคนเดียว" } }' http://203.154.100.197:31380/dsav_account/v1/accounts
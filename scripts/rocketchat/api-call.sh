
curl -H "X-Auth-Token: UTUhwU4ZLIuysKHWPbdT1VZyXjUSAh74J2TaA7lWgyc" \
     -H "X-User-Id: 7Enc6wnrZW8C4Zhjd" \
     -H "Content-type:application/json" \
     -d "{ \"channel\": \"#myproject-pipeline\", \"text\": \"This is a test! API TEST @metehan.danaci \" }" \
     https://rocketchat.mydomain.com/api/v1/chat.postMessage
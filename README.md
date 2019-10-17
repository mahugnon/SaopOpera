# SaopOpera
Original: http://squeaksource.com/SoapOpera

SaopOpera is a client to consume Soap web service in pharo
```Smalltalk
	call := (SoapCallEntry tcpHost: '10.201.6.205' port: 8585) newCall.
	call namespace: 'http://service/'.
	call transport: #http.
	call targetObjectURI: '/BanqueWs'.	
	call addParameter: (SoapVariable name: 'montant' value: 8). 	
	call methodName: 'ConversionEuroToDh'.
	call invokeAndReturn.
	
```

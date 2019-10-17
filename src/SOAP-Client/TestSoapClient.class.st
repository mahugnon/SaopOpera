Class {
	#name : #TestSoapClient,
	#superclass : #TestCase,
	#category : #'SOAP-Client-Test'
}

{ #category : #asserting }
TestSoapClient >> testCalculatorShouldReturn24 [
	| call |
	call := (SoapCallEntry tcpHost: 'www.dneonline.com' port: 80) newCall.
	call namespace: 'http://tempuri.org/'.
	call transport: #http.
	call targetObjectURI: '/calculator.asmx'.
	call methodName: 'Add'.
	call
		addParameter:
			(SoapVariable
				name: 'm:intA'
				value: 15
				xsdType: 'http://www.w3.org/2001/XMLSchema:int').
	call
		addParameter:
			(SoapVariable
				name: 'm:intB'
				value: 9
				xsdType: 'http://www.w3.org/2001/XMLSchema:int').
	self assert: call invokeAndReturn asNumber equals: 24
]

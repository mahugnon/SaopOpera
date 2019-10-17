Class {
	#name : #SoapCalculatorExemple,
	#superclass : #Dictionary,
	#category : #'SOAP-Example-CustomComplexType'
}

{ #category : #asserting }
SoapCalculatorExemple >> shouldReturn24 [
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
	^ call invokeAndReturn
]

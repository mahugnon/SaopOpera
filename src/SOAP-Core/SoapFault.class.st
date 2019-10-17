"
SOAP Fault element.


---
mu 5/21/2001 22:24
"
Class {
	#name : #SoapFault,
	#superclass : #SoapElement,
	#instVars : [
		'faultcode',
		'faultstring',
		'faultactor',
		'detail'
	],
	#category : #'SOAP-Core-Elements'
}

{ #category : #'instance creation' }
SoapFault class >> client [
	^self new client
]

{ #category : #'instance creation' }
SoapFault class >> fromXmlElement: anXmlWrapElement [ 
	| inst faultcode faultstring faultactor detail others |
	inst := self named: anXmlWrapElement name.
	self addAttributesOf: anXmlWrapElement to: inst.
	faultcode := anXmlWrapElement findChildNamed: 'faultcode'.
	faultcode isNil	ifFalse: [inst faultcode: faultcode value].
	faultstring := anXmlWrapElement findChildNamed: 'faultstring'.
	faultstring isNil	ifFalse: [inst faultstring: faultstring value].
	faultactor := anXmlWrapElement findChildNamed: 'faultactor'.
	faultactor isNil	ifFalse: [inst faultactor: faultactor value].
	detail := anXmlWrapElement findChildNamed: 'detail'.
	detail isNil	ifFalse: [inst detail: (SoapFaultDetail fromXmlElement: detail)].
	others := anXmlWrapElement children
				reject: [:each | #('faultcode' 'faultstring' 'faultactor' 'detail') includes: each name].
	others	do: [:otherE | inst addSubElement: otherE].
	^ inst
]

{ #category : #constants }
SoapFault class >> localName [
	^'Fault'
]

{ #category : #'instance creation' }
SoapFault class >> mustUnderstand [
	^self new mustUnderstand
]

{ #category : #'instance creation' }
SoapFault class >> server [
	^self new server
]

{ #category : #'instance creation' }
SoapFault class >> versionMismatch [
	^self new versionMismatch
]

{ #category : #actions }
SoapFault >> addDetail [
	| de |
	de := SoapFaultDetail new.
	de parent: self.
	self detail: de.
	^de
]

{ #category : #actions }
SoapFault >> attachMinorFaultCodes: aArrayOfString [ 
	| origFaultCode wStr |
	origFaultCode := self faultcode.
	wStr := WriteStream with: origFaultCode.
	aArrayOfString
		do: [:each | 
			wStr nextPut: $..
			wStr nextPutAll: each].
	^self faultcode: wStr contents
]

{ #category : #'actions-faultcode' }
SoapFault >> client [
	self faultcode: (SoapConstants soapEnvPrefixColon, SoapConstants client)
]

{ #category : #elements }
SoapFault >> detail [
	^ detail
]

{ #category : #elements }
SoapFault >> detail: aValue [

	detail := aValue
]

{ #category : #elements }
SoapFault >> faultactor [

	^faultactor
]

{ #category : #elements }
SoapFault >> faultactor: aValue [

	faultactor := aValue
]

{ #category : #elements }
SoapFault >> faultcode [
	^faultcode
]

{ #category : #elements }
SoapFault >> faultcode: aValue [

	faultcode := aValue
]

{ #category : #elements }
SoapFault >> faultstring [
	^faultstring
]

{ #category : #elements }
SoapFault >> faultstring: aValue [

	faultstring := aValue
]

{ #category : #'initialize-release' }
SoapFault >> initialize [
	super initialize.
	faultcode := faultstring := ''
	
]

{ #category : #testing }
SoapFault >> isFault [
	^true
]

{ #category : #'actions-faultcode' }
SoapFault >> mustUnderstand [
	self faultcode: (SoapConstants soapEnvPrefixColon, SoapConstants mustUnderstand)
]

{ #category : #'private-printing' }
SoapFault >> privPrintChildrenOn: aStream indent: level [
	self writeValue: self faultcode on: aStream betweenTag: 'faultcode'.
	self writeValue: self faultstring on: aStream betweenTag: 'faultstring'.
	self faultactor isNil ifFalse:[self writeValue: self faultactor on: aStream betweenTag: 'faultactor'].
	self detail isNil ifFalse:[self detail printXmlOn: aStream].
	super privPrintChildrenOn: aStream indent: level
]

{ #category : #'actions-faultcode' }
SoapFault >> server [
	self faultcode: (SoapConstants soapEnvPrefixColon, SoapConstants server)
]

{ #category : #'actions-faultcode' }
SoapFault >> versionMismatch [
	self faultcode: (SoapConstants soapEnvPrefixColon, SoapConstants versionMismatch)
]

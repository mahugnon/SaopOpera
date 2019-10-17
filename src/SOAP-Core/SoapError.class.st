"
SOAP Abstract Error class
---
mu 5/21/2001 22:30
"
Class {
	#name : #SoapError,
	#superclass : #Error,
	#instVars : [
		'faultcode',
		'faultstring',
		'detail'
	],
	#category : #'SOAP-Core-Base'
}

{ #category : #defaults }
SoapError class >> client [
	^self faultcode: #Client
]

{ #category : #'instance creation' }
SoapError class >> faultcode: aFaultCodeSymbol [
	^self new faultcode: aFaultCodeSymbol
]

{ #category : #'instance creation' }
SoapError class >> fromSoapFault: aSoapFault [
	| inst |
	inst := self faultcode: aSoapFault faultcode.
	inst faultstring: aSoapFault faultstring.
	inst detail: aSoapFault detail.
	^inst 
]

{ #category : #defaults }
SoapError class >> mustUnderstand [
	^self faultcode: #MustUnderstand
]

{ #category : #defaults }
SoapError class >> server [
	^self faultcode: #Server
]

{ #category : #defaults }
SoapError class >> versionMismatch [
	^self faultcode: #VersionMismatch
]

{ #category : #exceptionDescription }
SoapError >> description [
	| desc |
	desc := super description.
	self faultcode isNil ifFalse: [desc := desc, ':', self faultcode].
	self faultstring isNil ifFalse: [desc := desc, '#', self faultstring].
	^desc
]

{ #category : #accessing }
SoapError >> detail [
	^detail
]

{ #category : #accessing }
SoapError >> detail: aValue [
	detail :=  aValue
]

{ #category : #accessing }
SoapError >> faultCode [
	^faultCode
]

{ #category : #accessing }
SoapError >> faultCode: aValue [
	faultCode := aValue
]

{ #category : #accessing }
SoapError >> faultcode [
	^faultcode
]

{ #category : #accessing }
SoapError >> faultcode: aValue [
	faultcode := aValue
]

{ #category : #accessing }
SoapError >> faultstring [
	^faultstring
]

{ #category : #accessing }
SoapError >> faultstring: aValue [
	faultstring := aValue
]

{ #category : #exceptionDescription }
SoapError >> isResumable [
	
	^ true
]

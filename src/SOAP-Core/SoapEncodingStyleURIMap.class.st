Class {
	#name : #SoapEncodingStyleURIMap,
	#superclass : #Object,
	#classInstVars : [
		'ariasURIDict'
	],
	#category : #'SOAP-Core-DataBinding'
}

{ #category : #accessing }
SoapEncodingStyleURIMap class >> ariasURIDict [
	^ariasURIDict
]

{ #category : #actions }
SoapEncodingStyleURIMap class >> at: anAriasSymbol [
	^self ariasURIDict at: anAriasSymbol ifAbsent:[SoapNoSuchEncodingArias signal: anAriasSymbol].
]

{ #category : #'default values' }
SoapEncodingStyleURIMap class >> initAriasURIDict [
	self ariasURIDict at: #nullEncoding put: SoapConstants nullEncURI.
	self ariasURIDict at: #soapEncoding put: SoapConstants soapEncURI.
	self ariasURIDict at: #soapSqEncoding put: SoapConstants soapSqEncURI.
]

{ #category : #'class initialization' }
SoapEncodingStyleURIMap class >> initialize [
	"SoapEncodingStyleURIMap initialize"
	ariasURIDict := IdentityDictionary new.
	self initAriasURIDict.
	
]

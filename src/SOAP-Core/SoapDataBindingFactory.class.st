Class {
	#name : #SoapDataBindingFactory,
	#superclass : #Object,
	#classVars : [
		'DataBindingDict'
	],
	#classInstVars : [
		'dataBindingDict'
	],
	#category : #'SOAP-Core-DataBinding'
}

{ #category : #actions }
SoapDataBindingFactory class >> createFrom: anArrayOfEncodingStyleURI [ 
	| uriArr key |
	anArrayOfEncodingStyleURI size > 1
		ifTrue: [self noSuchDataBinder signal: 'Currently multi encodingStyleURI is not supported'].
	uriArr := (anArrayOfEncodingStyleURI isNil
					or: [anArrayOfEncodingStyleURI isEmpty])
				ifTrue: [self defaultEncodingStyleURIs.]
				ifFalse: [anArrayOfEncodingStyleURI].
	key := uriArr first.	"##TODO: to support multi encoders"
	^ (self dataBindingDict
		at: key
		ifAbsent: [self noSuchDataBinder signal: key]) new
]

{ #category : #accessing }
SoapDataBindingFactory class >> dataBindingDict [
	dataBindingDict isNil
		ifTrue: [dataBindingDict := Dictionary new.
			self initDataBindingDict].
	^ dataBindingDict
]

{ #category : #'default values' }
SoapDataBindingFactory class >> defaultEncodingStyleURIs [
	^Array with: SoapConstants soapEncURI
]

{ #category : #'default values' }
SoapDataBindingFactory class >> initDataBindingDict [
	"Default do nothing"
	
]

{ #category : #'class initialization' }
SoapDataBindingFactory class >> initialize [
	"SoapDataBindingFactory initialize"
	dataBindingDict := nil
]

{ #category : #'class initialization' }
SoapDataBindingFactory class >> initializeAll [
	"SoapDataBindingFactory initializeAll"
	self allSubclassesDo:[:each | each initialize]
]

{ #category : #'accessing-error' }
SoapDataBindingFactory class >> noSuchDataBinder [
	^SoapNoSuchDataBinder
	
]

{ #category : #accessing }
SoapDataBindingFactory class >> uriEncoderDict [
	^UriEncoderDict
]

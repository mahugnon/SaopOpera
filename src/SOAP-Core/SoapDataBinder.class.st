Class {
	#name : #SoapDataBinder,
	#superclass : #Object,
	#classInstVars : [
		'typeDict'
	],
	#category : #'SOAP-Core-DataBinding'
}

{ #category : #'class initialization' }
SoapDataBinder class >> initTypeDict [

	^typeDict := IdentityDictionary new.
	
]

{ #category : #'class initialization' }
SoapDataBinder class >> initialize [
	self initTypeDict
]

{ #category : #accessing }
SoapDataBinder class >> typeDict [
	typeDict isNil ifTrue: [self initTypeDict].
	^typeDict
]

{ #category : #accessing }
SoapDataBinder >> typeDict [
	^self class typeDict
]

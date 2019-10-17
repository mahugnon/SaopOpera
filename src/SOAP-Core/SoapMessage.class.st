Class {
	#name : #SoapMessage,
	#superclass : #Object,
	#instVars : [
		'context',
		'envelope'
	],
	#category : #'SOAP-Core-RPC'
}

{ #category : #actions }
SoapMessage class >> envelope: aSoapEnvelope [
	^self envelope: aSoapEnvelope context: nil
]

{ #category : #actions }
SoapMessage class >> envelope: aSoapEnvelope context: aSoapContext [
	^self new envelope: aSoapEnvelope; context: aSoapContext
]

{ #category : #accessing }
SoapMessage >> context [
	context isNil ifTrue:[context := SoapContext new].
	^context
]

{ #category : #accessing }
SoapMessage >> context: aValue [

	context := aValue
]

{ #category : #accessing }
SoapMessage >> envelope [

	^envelope
]

{ #category : #accessing }
SoapMessage >> envelope: aValue [

	envelope := aValue
]

"
I represent a SOAP RPC context.

---
MU 5/12/2002 00:47
"
Class {
	#name : #SoapContext,
	#superclass : #Object,
	#instVars : [
		'propDict'
	],
	#category : #'SOAP-Core-RPC'
}

{ #category : #'actions-basic' }
SoapContext >> at: aSymbol [
	^self propDict at: aSymbol
]

{ #category : #'actions-basic' }
SoapContext >> at: aSymbol ifAbsent: aBlock [
	^self propDict at: aSymbol ifAbsent: aBlock
]

{ #category : #'actions-basic' }
SoapContext >> at: aSymbol put: anObject [
	^self propDict at: aSymbol put: anObject
]

{ #category : #actions }
SoapContext >> encodingStyleURIs [
	^self at: #encodingStyleURIs ifAbsent:[#()]
]

{ #category : #actions }
SoapContext >> encodingStyleURIs: anArrayOfEncodingStyleURI [
	self at: #encodingStyleURIs put: anArrayOfEncodingStyleURI
]

{ #category : #printing }
SoapContext >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: ${.
	self propDict keysAndValuesDo:[:k :v | aStream print: k; nextPutAll: '->'; print: v; space].
	aStream nextPut: $}.
]

{ #category : #accessing }
SoapContext >> propDict [
	propDict isNil ifTrue: [propDict := IdentityDictionary new].
	^propDict
]

{ #category : #accessing }
SoapContext >> propDict: aValue [

	propDict := aValue
]

{ #category : #actions }
SoapContext >> soapAction [
	^self at: #soapAction ifAbsent:[SoapAction intentByRequestURI]
]

{ #category : #actions }
SoapContext >> soapAction: aStringOrSoapAction [ 
	| soapAction |
	soapAction := aStringOrSoapAction isString
				ifTrue: [SoapAction intent: aStringOrSoapAction]
				ifFalse: [aStringOrSoapAction].
	self at: #soapAction put: soapAction
]

{ #category : #actions }
SoapContext >> targetObjectURI [
	^self at: #targetObjectURI ifAbsent:['']
]

{ #category : #actions }
SoapContext >> targetObjectURI: aString [
	self at: #targetObjectURI put: (SoPortableUtil relativeURIFrom: aString).
]

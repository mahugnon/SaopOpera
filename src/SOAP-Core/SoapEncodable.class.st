Class {
	#name : #SoapEncodable,
	#superclass : #Object,
	#instVars : [
		'encodingStyleURIs',
		'encoder',
		'parent'
	],
	#category : #'SOAP-Core-RPC'
}

{ #category : #accessing }
SoapEncodable >> encoder [
	encoder isNil
		ifTrue: [encoder := parent isNil
						ifTrue: [SoapEncoderFactory createFrom: self encodingStyleURIs]
						ifFalse: [parent encoder]].
	^ encoder
]

{ #category : #accessing }
SoapEncodable >> encoder: aValue [

	encoder := aValue
]

{ #category : #actions }
SoapEncodable >> encoding: aSymbol [
	self encodingStyleURI: (SoapEncodingStyleURIMap at: aSymbol).
	self encoder: (SoapEncoderFactory createFrom: self encodingStyleURIs).  
]

{ #category : #actions }
SoapEncodable >> encodingStyleURI: aURIString [
	self encodingStyleURIs: (Array with: aURIString)
]

{ #category : #actions }
SoapEncodable >> encodingStyleURIString [
	| uris wStr |
	uris := self encodingStyleURIs.
	wStr := WriteStream
				on: (String new: 64).
	uris size = 1
		ifTrue: [wStr nextPutAll: uris first]
		ifFalse: [self encodingStyleURIs
				do: [:each | wStr nextPutAll: each;
						 nextPut: Character space]].
	^ wStr contents
]

{ #category : #actions }
SoapEncodable >> encodingStyleURIString: anEncodingStyleURI [ 
	self
		encodingStyleURIs: (SoPortableUtil substringsFrom: anEncodingStyleURI)
]

{ #category : #accessing }
SoapEncodable >> encodingStyleURIs [
	encodingStyleURIs isNil ifTrue:[ encodingStyleURIs := Array with: SoapConstants soapEncURI].
	^encodingStyleURIs
]

{ #category : #accessing }
SoapEncodable >> encodingStyleURIs: aValue [

	encodingStyleURIs := aValue
]

{ #category : #accessing }
SoapEncodable >> parent [

	^parent
]

{ #category : #accessing }
SoapEncodable >> parent: aValue [

	parent := aValue
]

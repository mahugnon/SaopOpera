"
'SOAPAction: '. in http header.

MU 10/5/2002 01:29
"
Class {
	#name : #SoapAction,
	#superclass : #Object,
	#instVars : [
		'intent'
	],
	#category : #'SOAP-Core-Http'
}

{ #category : #'instance creation' }
SoapAction class >> intent: aString [
	^self new intent: aString
]

{ #category : #'instance creation' }
SoapAction class >> intentByRequestURI [
	^self intent: ''
]

{ #category : #'instance creation' }
SoapAction class >> noIntent [
	^self intent: nil
]

{ #category : #constants }
SoapAction >> headerString [
	^'SOAPAction'
]

{ #category : #accessing }
SoapAction >> intent [

	^intent
]

{ #category : #accessing }
SoapAction >> intent: aValue [

	intent := aValue
]

{ #category : #actions }
SoapAction >> intentString [
	| headerStream |
	self intent
		ifNil: [^ ''].
	headerStream := WriteStream on: ''.
	headerStream nextPut: $".
	headerStream nextPutAll: self intent.
	headerStream nextPut: $".
	^ headerStream contents
]

{ #category : #printing }
SoapAction >> printOn: aStream [
	aStream nextPutAll: self headerString, ': '.
	aStream nextPutAll: self intentString.
	aStream cr.
	aStream nextPut: Character lf.
]

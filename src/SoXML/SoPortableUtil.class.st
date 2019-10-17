"
An utility for providing adapter interfaces for various Smalltalk implementations. 

Currently I support Squeak only.

If you would like to use other Smalltalks, you should subclass me.


---
mu 5/3/2001 19:23
"
Class {
	#name : #SoPortableUtil,
	#superclass : #Object,
	#category : #'SoXML-Base'
}

{ #category : #actions }
SoPortableUtil class >> convertString: aString from: encoderName [
	^aString convertFromWithConverter: (TextConverter newForEncoding: encoderName).
]

{ #category : #actions }
SoPortableUtil class >> convertString: aString to: encoderName [
	^aString convertToWithConverter: (TextConverter newForEncoding: encoderName).
]

{ #category : #actions }
SoPortableUtil class >> isBlank: aString [ 
	"##ANSI ST specific##"
	^(aString allSatisfy: [:i | i isSeparator])
]

{ #category : #actions }
SoPortableUtil class >> relativeURIFrom: aString [ 
	"SoPortableUtil relativeURIFrom: 'urn:target:1' "
	"SoPortableUtil relativeURIFrom: 'http://localhost:80/target/1' "
	"SoPortableUtil relativeURIFrom: '/target1/' "
	"SoPortableUtil relativeURIFrom: 'target1' "
	"SoPortableUtil relativeURIFrom: '/' "

	"##Squeak specific##"
	| uriStr colonIdx schemeName slashIdx |
	aString isEmpty ifTrue: [^aString].
	uriStr := aString last = $/
				ifTrue: [aString copyFrom: 1 to: aString size - 1]
				ifFalse: [aString].
	colonIdx := uriStr
				indexOf: $:
				ifAbsent: [^(uriStr beginsWith: '/') ifTrue: [uriStr] ifFalse: ['/', uriStr]].
	schemeName := aString copyFrom: 1 to: colonIdx - 1.
	(schemeName
			allSatisfy: [:each | each isLetter])
		ifTrue: [uriStr := uriStr copyFrom: colonIdx + 1 to: uriStr size].
	((uriStr at: 1)
				= $/
			and: [(uriStr at: 2)
					= $/])
		ifTrue: [uriStr := uriStr copyFrom: 2 to: uriStr size].
	slashIdx := uriStr findString: '/' startingAt: 2.
	slashIdx = 0
		ifFalse: [uriStr := uriStr copyFrom: slashIdx to: uriStr size].
	^ uriStr
]

{ #category : #actions }
SoPortableUtil class >> stackTraceFrom: anError [
	| ctx |
	ctx := [anError signalerContext shortStack] on: Error do: [:ex | ex return: ''].
	^ctx
]

{ #category : #actions }
SoPortableUtil class >> substringsFrom: aString [ 
	"ToDo: Support other Smalltalks"
	"##Squeak specific##"
	aString isNil ifTrue: [^#()].
	^ aString substrings
]

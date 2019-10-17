Class {
	#name : #SoapHref,
	#superclass : #ProtoObject,
	#instVars : [
		'target',
		'referenceDict',
		'realObject'
	],
	#category : #'SOAP-Core-Decoding'
}

{ #category : #'instance creation' }
SoapHref class >> on: target in: referenceDict [ 
	^ self new target: target;
		 referenceDict: referenceDict;
		 yourself
]

{ #category : #actions }
SoapHref >> basicInspect [
	{self class.
		{#target->target. #referenceDict->referenceDict. #realObject->realObject}} inspect
	
]

{ #category : #actions }
SoapHref >> becomeReal [
	(realObject isNil) ifFalse: [^self safeBecomeForward: realObject].
	^self
	
]

{ #category : #'system primitives' }
SoapHref >> doesNotUnderstand: aMessage [ 
	| real |
	real := self realObject.
	(real isMemberOf: self class) ifFalse: [
		^real perform: aMessage selector withArguments: aMessage arguments.
	].

	
]

{ #category : #actions }
SoapHref >> inspect [
	self realObject inspect
]

{ #category : #accessing }
SoapHref >> realObject [
	realObject
		ifNil: [realObject := self referenceDict
						at: self target
						ifAbsent: [^ self]].
	^ realObject
]

{ #category : #accessing }
SoapHref >> referenceDict [
	"Answer the value of referenceDict"

	^ referenceDict
]

{ #category : #accessing }
SoapHref >> referenceDict: anObject [
	"Set the value of referenceDict"

	referenceDict := anObject
]

{ #category : #actions }
SoapHref >> resolve [
	self realObject
	
	
]

{ #category : #private }
SoapHref >> safeBecomeForward: anObject [

	anObject == true ifTrue: [^anObject].
	anObject == false ifTrue: [^anObject].
	anObject isNumber ifTrue: [^anObject].
	anObject class isBits ifTrue: [^anObject].
	anObject class isVariable ifTrue: [^anObject].

	self becomeForward: anObject.
	^self
]

{ #category : #accessing }
SoapHref >> target [
	"Answer the value of target"

	^ target
]

{ #category : #accessing }
SoapHref >> target: anObject [
	"Set the value of target"
	| str |
	str := anObject asString.
	str ifEmpty: [^nil].
	str := str copyFrom: 2 to: str size. "removing #"
	target := str
]

{ #category : #actions }
SoapHref >> yourself [
	^self resolve; becomeReal.
]

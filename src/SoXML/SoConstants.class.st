"
Abstract Constants provider.

---
mu 5/3/2001 19:22
"
Class {
	#name : #SoConstants,
	#superclass : #Object,
	#classInstVars : [
		'constDict'
	],
	#category : #'SoXML-Base'
}

{ #category : #private }
SoConstants class >> at: aKey ifAbsentPutValue: aValue [
	^self constDict at: aKey ifAbsent:[self constDict at: aKey put: aValue]
]

{ #category : #accessing }
SoConstants class >> constDict [
	constDict isNil
		ifTrue: [constDict := (super canUnderstand: #constDict)
						ifTrue: [super constDict copy]
						ifFalse: [IdentityDictionary new]].
	^ constDict
]

{ #category : #'class initialization' }
SoConstants class >> initialize [
	"SoConstants initialize"
	constDict := nil
]

{ #category : #private }
SoConstants class >> removeKey: aKey [ 
	^self constDict removeKey: aKey 
]

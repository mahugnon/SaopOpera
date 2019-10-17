"
SOAP Envelope element.


---
mu 5/21/2001 22:24
"
Class {
	#name : #SoapEnvelope,
	#superclass : #SoapElement,
	#instVars : [
		'header',
		'body'
	],
	#category : #'SOAP-Core-Elements'
}

{ #category : #'instance creation' }
SoapEnvelope class >> fromXmlElement: anXmlWrapElement [ 
	| inst headElem bodyElem others |
	inst := self named: anXmlWrapElement name.
	self addAttributesOf: anXmlWrapElement to: inst.
	headElem := anXmlWrapElement findChildLocalNamed: SoapHeader localName.
	headElem isNil
		ifFalse: [inst
				header: (SoapHeader fromXmlElement: headElem)].
	bodyElem := anXmlWrapElement findChildLocalNamed: SoapBody localName.
	bodyElem isNil
		ifFalse: [inst
				body: (SoapBody fromXmlElement: bodyElem)].
	others := anXmlWrapElement children
				reject: [:each | each localName = SoapHeader localName
						or: [each localName = SoapBody localName]]. "will be obsolete in SOAP 1.2"
	others
		do: [:otherE | inst addSubElement: otherE].
	^ inst
]

{ #category : #constants }
SoapEnvelope class >> localName [
	^'Envelope'
]

{ #category : #actions }
SoapEnvelope >> addBody [
	| bo |
	bo := SoapBody new.
	bo parent: self.
	self body: bo.
	^bo
	
]

{ #category : #actions }
SoapEnvelope >> addHeader [
	| he |
	he := SoapHeader new.
	he parent: self.
	self header: he.
	^he
]

{ #category : #elements }
SoapEnvelope >> body [
	body isNil
		ifTrue: [self addBody].
	^ body
]

{ #category : #elements }
SoapEnvelope >> body: aSoapBody [
	body := aSoapBody.
	aSoapBody parent: self
]

{ #category : #testing }
SoapEnvelope >> hasFault [
	^self body hasFault 
]

{ #category : #testing }
SoapEnvelope >> hasHeader [
	^self header notNil
	
]

{ #category : #elements }
SoapEnvelope >> header [
	^ header
]

{ #category : #elements }
SoapEnvelope >> header: aSoapHeader [
	header := aSoapHeader.
	aSoapHeader parent: self
]

{ #category : #'initialize-release' }
SoapEnvelope >> initialize [
	super initialize.
	
	self declareDefaultNamespace.
	
	
	
]

{ #category : #testing }
SoapEnvelope >> isEnvelope [
	^true
]

{ #category : #'private-printing' }
SoapEnvelope >> privPrintChildrenOn: aStream indent: level [
	self header isNil ifFalse:[self header printXmlOn: aStream indent: level].
	self body printXmlOn: aStream indent: level. "##body always exists##"
	super privPrintChildrenOn: aStream indent: level
]

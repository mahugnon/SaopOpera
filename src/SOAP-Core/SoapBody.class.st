"
SOAP Body element.


---
mu 5/21/2001 22:24
"
Class {
	#name : #SoapBody,
	#superclass : #SoapElement,
	#instVars : [
		'fault',
		'bodyEntries'
	],
	#category : #'SOAP-Core-Elements'
}

{ #category : #'instance creation' }
SoapBody class >> fromXmlElement: anXmlWrapElement [ 
	| inst faultElem |
	inst := self named: anXmlWrapElement name.
	self addAttributesOf: anXmlWrapElement to: inst.
	faultElem := anXmlWrapElement findChildLocalNamed: SoapFault localName.
	faultElem isNil
		ifTrue: [anXmlWrapElement children
				do: [:each | inst addBodyEntry: each]]
		ifFalse: [inst
				fault: (SoapFault fromXmlElement: faultElem)].
	^ inst
]

{ #category : #constants }
SoapBody class >> localName [
	^'Body'
]

{ #category : #actions }
SoapBody >> addBodyEntry: anXmlElement [
	"anXmlElement mustUnderstand:
		#printXmlOn:aStream
		#parent: anXmlElement"
	anXmlElement parent: self.
	^self bodyEntries add: anXmlElement.
]

{ #category : #actions }
SoapBody >> addChild: anXmlElement [
	^self addBodyEntry: anXmlElement
]

{ #category : #actions }
SoapBody >> addFault [
	| fa |
	fa := SoapFault new.
	fa parent: self.
	self fault: fa.
	^fa
]

{ #category : #elements }
SoapBody >> bodyEntries [
	bodyEntries isNil ifTrue: [bodyEntries := OrderedCollection new].
	^bodyEntries
]

{ #category : #elements }
SoapBody >> bodyEntries: aCollectionOfXmlElement [
	bodyEntries := aCollectionOfXmlElement
]

{ #category : #actions }
SoapBody >> clearBodyEntries [
	self bodyEntries
		do: [:each | each parent: nil].
	self bodyEntries: nil
]

{ #category : #elements }
SoapBody >> fault [
	^ fault
]

{ #category : #elements }
SoapBody >> fault: aSoapFault [
	fault := aSoapFault.
	aSoapFault parent: self
]

{ #category : #actions }
SoapBody >> findBodyEntriesNamed: anElemName [
	^self bodyEntries select: [:each | each name = anElemName]
]

{ #category : #actions }
SoapBody >> findBodyEntryNamed: anElemName [
	^self bodyEntries detect: [:each | each name = anElemName] ifNone:[]
]

{ #category : #testing }
SoapBody >> hasFault [
	^self fault notNil
]

{ #category : #testing }
SoapBody >> isBody [
	^false
]

{ #category : #actions }
SoapBody >> isMustUnderstandEnabled [
	self parent isNil
		ifTrue: [^ true].
	^ self parent hasHeader
		ifTrue: [self parent header isMustUnderstandEnabled]
		ifFalse: [true]
]

{ #category : #'private-printing' }
SoapBody >> privPrintChildrenOn: aStream indent: level [ 
	fault isNil
		ifFalse: [self fault printXmlOn: aStream indent: level].
	bodyEntries isNil
		ifFalse: [self bodyEntries
				do: [:each | each printXmlOn: aStream indent: level]].
	super privPrintChildrenOn: aStream indent: level
]

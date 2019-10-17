"
An utitily class for XML attribute handling.
	
---	
mu 5/3/2001 19:22
"
Class {
	#name : #SoXmlAttributesHolder,
	#superclass : #Object,
	#instVars : [
		'namespaceDict',
		'otherDict'
	],
	#category : #'SoXML-Base'
}

{ #category : #'instance creation' }
SoXmlAttributesHolder class >> new [
	^super new initialize
]

{ #category : #actions }
SoXmlAttributesHolder >> asDictionary [
	| dict |
	dict := Dictionary new.
	self namespaceDict
		keysAndValuesDo: [:k :v | dict at: k put: v].
	self otherDict
		keysAndValuesDo: [:k :v | dict at: k put: v].
	^ dict
]

{ #category : #private }
SoXmlAttributesHolder >> chopPrefix: attribName [
	^(SoXmlUtil prefixAndLocalNameFrom: attribName) last. 
	
]

{ #category : #actions }
SoXmlAttributesHolder >> declareNamespace: prefix uri: uri [ 
	prefix isEmpty
		ifTrue: [self namespaceDict at: SoXmlConstants xmlnsPrefix , prefix put: uri]
		ifFalse: [self namespaceDict at: SoXmlConstants xmlnsPrefixColon , prefix put: uri]
]

{ #category : #actions }
SoXmlAttributesHolder >> declaredNamespacePrefixes [
	^ self namespaceDict keys
		collect: [:each | each = SoXmlConstants xmlnsPrefix
				ifTrue: ['']
				ifFalse: [each copyFrom: SoXmlConstants xmlnsPrefixColon size + 1 to: each size]]
]

{ #category : #actions }
SoXmlAttributesHolder >> declaredNamespaceURIFor: prefix [
	^self declaredNamespaceURIFor: prefix ifAbsent: []
]

{ #category : #actions }
SoXmlAttributesHolder >> declaredNamespaceURIFor: prefix ifAbsent: aBlock [
	
	^self namespaceDict at: (SoXmlConstants xmlnsPrefixColon, prefix) ifAbsent: [
		self namespaceDict at: (SoXmlConstants xmlnsPrefix) ifAbsent: aBlock
	]
]

{ #category : #actions }
SoXmlAttributesHolder >> getAttributeLike: aNameString [ 
	| key |
	key := (self otherDict keys detect: [:each | aNameString match: each] ifNone:[] ).
	key isNil ifTrue: [key := self namespaceDict keys detect: [:each | aNameString match: each] ifNone:[]].
	^self getAttributeNamed: key
]

{ #category : #actions }
SoXmlAttributesHolder >> getAttributeNamed: aNameString [ 
	^ self otherDict
		at: aNameString
		ifAbsent: [self namespaceDict
				at: aNameString
				ifAbsent: []]
]

{ #category : #actions }
SoXmlAttributesHolder >> hasAttributeLike: aNameString [ 
	^ ((self otherDict keys detect: [:each | aNameString match: each] ifNone:[nil]) notNil)
		or: [(self namespaceDict keys detect: [:each | aNameString match: each] ifNone:[nil]) notNil]
]

{ #category : #actions }
SoXmlAttributesHolder >> hasAttributeNamed: aNameString [ 
	^ (self otherDict includesKey: aNameString)
		or: [self namespaceDict includesKey: aNameString]
]

{ #category : #'initialize-release' }
SoXmlAttributesHolder >> initialize [
	namespaceDict :=  Dictionary new.
	otherDict := Dictionary new.
]

{ #category : #accessing }
SoXmlAttributesHolder >> namespaceDict [
	^namespaceDict
]

{ #category : #accessing }
SoXmlAttributesHolder >> otherDict [
	^otherDict
]

{ #category : #printing }
SoXmlAttributesHolder >> printOn: aStream [
	"super printOn: aStream." "for Debug"
	self printXmlOn: aStream
]

{ #category : #printing }
SoXmlAttributesHolder >> printXmlOn: aStream [
	self namespaceDict keysAndValuesDo:[ :k :v |
		aStream nextPut: Character space.
		self writeName: k on: aStream.
		aStream nextPutAll: '="'.
		self writeValue: v asString on: aStream.
		aStream nextPut: $".
	].
	self otherDict keysAndValuesDo:[ :k :v |
		aStream nextPut: Character space.
		self writeName: k on: aStream.
		aStream nextPutAll: '="'.
		self writeValue: v asString on: aStream.
		aStream nextPut: $".
	]
]

{ #category : #actions }
SoXmlAttributesHolder >> putAttribute: aNameValueArray [
	self putAttributeNamed: aNameValueArray first asString value: aNameValueArray last asString
]

{ #category : #actions }
SoXmlAttributesHolder >> putAttributeNamed: attribName value: attribValue [ 
	((attribName beginsWith: SoXmlConstants xmlnsPrefixColon) 
			or: [attribName = SoXmlConstants xmlnsPrefix])
		ifTrue: [self namespaceDict at: attribName put: attribValue]
		ifFalse: [self otherDict at: attribName put: attribValue]
]

{ #category : #actions }
SoXmlAttributesHolder >> removeAttributeNamed: aNameString [
	^self otherDict removeKey: aNameString
]

{ #category : #actions }
SoXmlAttributesHolder >> trimAttributePrefixNamed: attribName [
	| value newKey |
	value := self otherDict at: attribName ifAbsent:[].
	value isNil ifTrue: [^nil].
	newKey := self chopPrefix: attribName. 
	self removeAttributeNamed: attribName.
	^ self putAttributeNamed: newKey value: value
		
]

{ #category : #actions }
SoXmlAttributesHolder >> undeclareNamespaces [
	namespaceDict := Dictionary new
]

{ #category : #private }
SoXmlAttributesHolder >> writeName: aCharacterArray on: aStream [ 
	"TODO: check illegal characters"
	^ aStream nextPutAll: aCharacterArray
]

{ #category : #private }
SoXmlAttributesHolder >> writeValue: aCharacterArray on: aStream [ 
	^SoXmlUtil writeXmlText: aCharacterArray on: aStream
]

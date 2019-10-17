Class {
	#name : #SoapEncArray,
	#superclass : #SoapWrapElement,
	#instVars : [
		'encoder'
	],
	#category : #'SOAP-Core-Encoding'
}

{ #category : #'instance creation' }
SoapEncArray class >> encoder: aSoapEncoder [
	^self new encoder: aSoapEncoder; yourself
]

{ #category : #'instance creation' }
SoapEncArray class >> fromArray: anArray [
	^self fromArray: anArray named: 'Array'
	
]

{ #category : #'instance creation' }
SoapEncArray class >> fromArray: anArray named: elemName [
	^self fromArray: anArray named: elemName elementType: (SoapConstants xsdAnyType)
	
]

{ #category : #'instance creation' }
SoapEncArray class >> fromArray: anArray named: elemName elementType: anXSDType [ 
	^self fromArray: anArray named: elemName elementType: anXSDType containerType: nil namespace: nil
]

{ #category : #'instance creation' }
SoapEncArray class >> fromArray: anArray named: elemName elementType: elementXSDType containerType: arrayXSDType namespace: namespaceURI [
	| inst |
	inst := self new.
	^inst fromArray: anArray named: elemName elementType: elementXSDType containerType: arrayXSDType namespace: namespaceURI
]

{ #category : #accessing }
SoapEncArray >> encoder [
	"Answer the value of encoder"
	^ encoder
]

{ #category : #accessing }
SoapEncArray >> encoder: anObject [
	
	encoder := anObject
]

{ #category : #'initialize-release' }
SoapEncArray >> fromArray: anArray [
	^self fromArray: anArray named: 'Array'
	
]

{ #category : #'initialize-release' }
SoapEncArray >> fromArray: anArray named: elemName [
	^self fromArray: anArray named: elemName elementType: (SoapConstants xsdAnyType)
	
]

{ #category : #'initialize-release' }
SoapEncArray >> fromArray: anArray named: elemName elementType: anXSDType [ 
	^self fromArray: anArray named: elemName elementType: anXSDType containerType: nil namespace: nil
]

{ #category : #'initialize-release' }
SoapEncArray >> fromArray: anArray named: elemName elementType: elementXSDType containerType: arrayXSDType namespace: namespaceURI [
	| encPrefix |
	self name: elemName.
	encPrefix := SoapConstants soapEncPrefix.
	self declareNamespace: encPrefix uri: SoapConstants soapEncURI.
	self declareXsdNamespace.
	self declareXsiNamespace.
	(namespaceURI notNil)
		ifTrue: [| prefix | 
			prefix := arrayXSDType isNil
						ifTrue: [SoXmlUtil randomPrefix]
						ifFalse: [SoXmlUtil prefixFrom: arrayXSDType].
			self declareNamespace: prefix uri: namespaceURI].
	self putAttributeNamed: SoapConstants arrayType value: elementXSDType , '[' , anArray size printString , ']'.
	anArray
		do: [:each | (each isNil
					or: [each == #nil])
				ifFalse: [| item child | 
					item := SoapVariable name: 'item' value: each.
					child := (self encoder ifNil: [item encoder]) encodeSoapVariable: item.
					self addChild: child]].
	
]

{ #category : #testing }
SoapEncArray >> isArrayType [
	"for performance"
	^true
	
]

{ #category : #private }
SoapEncArray >> trimElementTypeAttributePrefix [
	self attributesHolder trimAttributePrefixNamed: SoapConstants arrayType
]

{ #category : #actions }
SoapEncArray >> trimForNested [
	self beShortName.
	self undeclareNamespaces.
	self trimElementTypeAttributePrefix
]

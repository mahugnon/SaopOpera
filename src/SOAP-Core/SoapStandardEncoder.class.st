Class {
	#name : #SoapStandardEncoder,
	#superclass : #SoapAbstractEncoder,
	#instVars : [
		'complexTypeDict',
		'customComplexTypeDict'
	],
	#classInstVars : [
		'complexTypeDict',
		'customComplexTypeDict'
	],
	#category : #'SOAP-Core-Encoding'
}

{ #category : #accessing }
SoapStandardEncoder class >> complexTypeDict [
	complexTypeDict
		ifNil: [complexTypeDict := Dictionary new].
	^ complexTypeDict
]

{ #category : #accessing }
SoapStandardEncoder class >> customComplexTypeDict [
	customComplexTypeDict
		ifNil: [customComplexTypeDict := Dictionary new].
	^ customComplexTypeDict
]

{ #category : #private }
SoapStandardEncoder >> autoPrefixTo: anXmlElement [
	| autoPrefix |
	autoPrefix := SoXmlUtil randomPrefix.
	anXmlElement name: autoPrefix, ':', anXmlElement.
	^autoPrefix
]

{ #category : #accessing }
SoapStandardEncoder >> complexTypeDict [
	"Answer the value of complexTypeDict"
	complexTypeDict ifNil: [complexTypeDict := self class complexTypeDict].
	^ complexTypeDict
]

{ #category : #accessing }
SoapStandardEncoder >> complexTypeDict: anObject [
	"Set the value of complexTypeDict"

	complexTypeDict := anObject
]

{ #category : #accessing }
SoapStandardEncoder >> complexXsdTypeOf: anObject [
	^self complexTypeDict at: anObject class name ifAbsent: []
]

{ #category : #accessing }
SoapStandardEncoder >> customComplexTypeDict [
	"Answer the value of customComplexTypeDict"
	customComplexTypeDict ifNil: [customComplexTypeDict := self class customComplexTypeDict].
	^ customComplexTypeDict
]

{ #category : #accessing }
SoapStandardEncoder >> customComplexTypeDict: anObject [
	"Set the value of customComplexTypeDict"

	customComplexTypeDict := anObject
]

{ #category : #'private-encoding' }
SoapStandardEncoder >> encodeArraySoapVariable: aSoapVariable [ 
	| arr elem allTypes elemType |
	arr := aSoapVariable value.
	arr class name == #SoapEncArray
		ifTrue: [elem :=  arr trimForNested "temporary hack".
				self setXmlAttributesFrom: aSoapVariable into: elem.
				^elem].
	allTypes := arr
				collect: [:each | each class].
	elemType := (allTypes asSet size > 1
					or: [allTypes isEmpty])
				ifTrue: [SoapConstants xsdAnyType]
				ifFalse: [(self possibleTypeAt: allTypes first name) ifNil: [SoapConstants xsdAnyType]].
	
	elem :=  (SoapEncArray encoder: self)
			fromArray: arr
			named: aSoapVariable name
			elementType: elemType
			containerType: aSoapVariable xsdType
			namespace: aSoapVariable namespace.
	
	self setXmlAttributesFrom: aSoapVariable into: elem.
	^elem
]

{ #category : #'private-encoding' }
SoapStandardEncoder >> encodeDictionarySoapVariable: aSoapVariable [ 
	| elem dict |
	elem := self xmlElementClass named: aSoapVariable name.
	dict := aSoapVariable value.
	dict
		keysAndValuesDo: [:k :v | elem
				addChild: (self
						encodeSoapVariable: (SoapVariable name: k asString value: v))].
	self setXmlAttributesFrom: aSoapVariable into: elem.
	^ elem
]

{ #category : #'private-encoding' }
SoapStandardEncoder >> encodeStructSoapVariable: aSoapVariable [ 
	|  struct nm elem xsdType namespace |
	struct := aSoapVariable value.
	nm := aSoapVariable name isEmptyOrNil ifTrue:[struct name] ifFalse:[aSoapVariable name]. 
	elem := self xmlElementClass named: nm.

	xsdType := aSoapVariable xsdType ifNil: [struct xsdType].
	xsdType ifNotNil: [elem xsiType: xsdType].

	namespace := aSoapVariable namespace ifNil: [struct namespace].
	namespace ifNotNil: [| prefix | 
					prefix := aSoapVariable guessedPrefix ifNil: [struct prefix].
					prefix ifNil: [prefix := self autoPrefixTo: elem].
					elem
						declareNamespace: prefix
						uri: namespace].
	struct
		keysAndValuesDo: [:k :v | elem
				addChild: (self
						encodeSoapVariable: (SoapVariable name: k asString value: v))].
	self setXmlAttributesFrom: aSoapVariable into: elem.
	^ elem
]

{ #category : #private }
SoapStandardEncoder >> possibleTypeAt: typeName [ 
	^ self typeDict
		at: typeName
		ifAbsent: [self complexTypeDict
				at: typeName
				ifAbsent: []]
]

{ #category : #private }
SoapStandardEncoder >> setXmlAttributesFrom: aSoapVariable into: anXmlElement [
	self setXmlElementId: aSoapVariable into: anXmlElement.
	self setXmlElementHref: aSoapVariable into: anXmlElement.
	self setXmlElementNamespace: aSoapVariable into: anXmlElement.
	self setXmlElementPrefix: aSoapVariable into: anXmlElement.
	
]

{ #category : #private }
SoapStandardEncoder >> setXmlElementHref: aSoapVariable into: anXmlElement [ 
	| href |
	href := aSoapVariable href.
	href isNil
		ifFalse: [anXmlElement href: href.
			anXmlElement beEmpty].
	^ anXmlElement
]

{ #category : #private }
SoapStandardEncoder >> setXmlElementId: aSoapVariable into: anXmlElement [ 
	| id |
	id := aSoapVariable id.
	id isNil
		ifFalse: [anXmlElement id: id].
	^ anXmlElement
]

{ #category : #private }
SoapStandardEncoder >> setXmlElementNamespace: aSoapVariable into: anXmlElement [ 
	| ns |
	ns := aSoapVariable namespace.
	ns isNil
		ifFalse: [| prefix | 
			prefix := aSoapVariable guessedPrefix.
			prefix ifNil: [prefix := self autoPrefixTo: anXmlElement].
			anXmlElement declareNamespace: prefix uri: ns].
	^ anXmlElement
]

{ #category : #private }
SoapStandardEncoder >> setXmlElementPrefix: aSoapVariable into: anXmlElement [ 
	| prefix |
	prefix := aSoapVariable prefix.
	prefix isEmptyOrNil
		ifFalse: [aSoapVariable isPrefixedName ifFalse: [anXmlElement name: prefix , ':' , anXmlElement name]].
	^ anXmlElement
]

{ #category : #private }
SoapStandardEncoder >> setXmlElementValue: aSoapVariable into: anXmlElement [ 

	"default, just set raw data"
	anXmlElement value: aSoapVariable value.


]

{ #category : #private }
SoapStandardEncoder >> useSharedValuesWhile: block [
	
	block value.
	
]

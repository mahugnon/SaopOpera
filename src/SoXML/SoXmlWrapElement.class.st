"
Representing an XML element.
Using XmlUtil, I am independent of XML parser implementations.

--
mu 5/3/2001 19:28
"
Class {
	#name : #SoXmlWrapElement,
	#superclass : #Object,
	#instVars : [
		'prefixName',
		'localName',
		'name',
		'value',
		'attributesHolder',
		'children',
		'parent',
		'isEmptyBody',
		'isPrintCDATA'
	],
	#classVars : [
		'IsPrintCDATA'
	],
	#category : #'SoXML-Base'
}

{ #category : #'instance creation' }
SoXmlWrapElement class >> emptyNamed: anElemName [
	^(self named: anElemName) beEmpty
]

{ #category : #'from xml' }
SoXmlWrapElement class >> fromXml: xmlString [
	^self fromXmlElement: (SoXmlUtil parseXml: xmlString).
]

{ #category : #'from xml' }
SoXmlWrapElement class >> fromXmlElement: aParsedXmlElement [
	^self new initByDom: aParsedXmlElement
]

{ #category : #accessing }
SoXmlWrapElement class >> isPrintCDATA [
	IsPrintCDATA isNil ifTrue:[ IsPrintCDATA := false ].
	^IsPrintCDATA
]

{ #category : #accessing }
SoXmlWrapElement class >> isPrintCDATA: aBoolean [
	IsPrintCDATA := aBoolean
]

{ #category : #'instance creation' }
SoXmlWrapElement class >> named: anElemName [
	^self new name: anElemName
]

{ #category : #'instance creation' }
SoXmlWrapElement class >> named: anElemName withPrefix: prefix [
	prefix ifEmpty: [^self named: anElemName].
	^self named: prefix, ':', anElemName
]

{ #category : #'instance creation' }
SoXmlWrapElement class >> new [
	^super new initialize
]

{ #category : #actions }
SoXmlWrapElement >> addChild: anXMLEleemnt [
	anXMLEleemnt isNil ifTrue:[^nil].
	anXMLEleemnt parent: self.
	^self children add: anXMLEleemnt.
	
]

{ #category : #actions }
SoXmlWrapElement >> allDeclaredNamespacePrefixes [
	^ self attributesHolder declaredNamespacePrefixes
		ifNotEmptyDo: [:prefixes | prefixes]
		ifEmpty: [self parent ifNotNilDo: [:par | par declaredNamespacePrefixes]]
]

{ #category : #actions }
SoXmlWrapElement >> allDeclaredNamespaceURIFor: prefix [ 
	^ self attributesHolder
		declaredNamespaceURIFor: prefix
		ifAbsent: [self parent notNil
				ifTrue: [self parent declaredNamespaceURIFor: prefix]]
]

{ #category : #actions }
SoXmlWrapElement >> attributesDictionary [
	^self attributesHolder asDictionary
]

{ #category : #accessing }
SoXmlWrapElement >> attributesHolder [
	attributesHolder isNil ifTrue:[ attributesHolder := SoXmlAttributesHolder new].
	^attributesHolder
]

{ #category : #accessing }
SoXmlWrapElement >> attributesHolder: aValue [

	attributesHolder := aValue
]

{ #category : #accessing }
SoXmlWrapElement >> basicValue: aValue [ 
	"Exceptional Use: For debugging or performance tuning"
	value := aValue 
]

{ #category : #actions }
SoXmlWrapElement >> beEmpty [
	self isEmptyBody: true
	
]

{ #category : #actions }
SoXmlWrapElement >> beShortName [
	self name: self shortName
]

{ #category : #accessing }
SoXmlWrapElement >> children [
	children isNil ifTrue:[ children := OrderedCollection new].
	^children
]

{ #category : #accessing }
SoXmlWrapElement >> children: aValue [
	
	children := aValue
]

{ #category : #actions }
SoXmlWrapElement >> createChildNamed: anElemName [
	| child |
	child := self class named: anElemName.
	self addChild: child.
	^child
]

{ #category : #actions }
SoXmlWrapElement >> createParentNamed: anElemName [
	| pa |
	pa := self class named: anElemName.
	pa addChild: self.
	^pa
]

{ #category : #actions }
SoXmlWrapElement >> declareNamespace: prefix uri: uri [
	self attributesHolder declareNamespace: prefix uri: uri
]

{ #category : #actions }
SoXmlWrapElement >> declaredNamespacePrefixes [
	^ self attributesHolder declaredNamespacePrefixes 
]

{ #category : #actions }
SoXmlWrapElement >> declaredNamespaceURIFor: prefix [ 
	^ self attributesHolder declaredNamespaceURIFor: prefix
		
]

{ #category : #actions }
SoXmlWrapElement >> findChild: aBlock [
	^self children detect: aBlock ifNone:[]
]

{ #category : #actions }
SoXmlWrapElement >> findChildLocalNamed: anElemName [
	^self children detect: [:each | each localName = anElemName] ifNone:[]
]

{ #category : #actions }
SoXmlWrapElement >> findChildNamed: anElemName [
	^self children detect: [:each | each name = anElemName] ifNone:[]
]

{ #category : #actions }
SoXmlWrapElement >> findChildren: aBlock [
	^self children select: aBlock
]

{ #category : #actions }
SoXmlWrapElement >> findChildrenLocalNamed: anElemName [
	^self children select: [:each | each localName = anElemName]
]

{ #category : #actions }
SoXmlWrapElement >> findChildrenNamed: anElemName [
	^self children select: [:each | each name = anElemName]
]

{ #category : #actions }
SoXmlWrapElement >> firstChild [
	^self children first
]

{ #category : #actions }
SoXmlWrapElement >> getAttributeLike: aNameString [
	^self attributesHolder getAttributeLike: aNameString
]

{ #category : #actions }
SoXmlWrapElement >> getAttributeNamed: aNameString [
	^self attributesHolder getAttributeNamed: aNameString
]

{ #category : #actions }
SoXmlWrapElement >> hasAttributeLike: aNameString [
	^self attributesHolder hasAttributeLike: aNameString
]

{ #category : #actions }
SoXmlWrapElement >> hasAttributeNamed: aNameString [
	^self attributesHolder hasAttributeNamed: aNameString
]

{ #category : #'private-init' }
SoXmlWrapElement >> initAttributesBy: aDictionary [
	aDictionary keysAndValuesDo:[:k :v |
		self putAttributeNamed: k value: v.
	].
	
]

{ #category : #'private-init' }
SoXmlWrapElement >> initByDom: aParsedXmlElement [ 
	| prefixAndLocalName |
	self
		name: (SoXmlUtil elementNameFrom: aParsedXmlElement).
	prefixAndLocalName := SoXmlUtil prefixAndLocalNameFrom: self name.
	self prefixName: prefixAndLocalName first.
	self localName: prefixAndLocalName last.
	self
		initAttributesBy: (SoXmlUtil attribDictFrom: aParsedXmlElement).
	self
		value: (SoXmlUtil elementValueFrom: aParsedXmlElement).

	(SoXmlUtil elementsWithoutBlankTextsFrom: aParsedXmlElement)
		do: [:each | self initChildElementByDom: each]
]

{ #category : #'private-init' }
SoXmlWrapElement >> initChildElementByDom: aParsedXmlElement [ 
	| parentElem childElmClass child |
	(SoXmlUtil isTextElement: aParsedXmlElement)
		ifTrue: [^ self
				value: (SoXmlUtil elementValueFrom: aParsedXmlElement)].
	parentElem := SoXmlUtil elementNameFrom: aParsedXmlElement.
	childElmClass := self privElementClassFrom: parentElem.
	child := childElmClass fromXmlElement: aParsedXmlElement.
	self addChild: child
]

{ #category : #'initialize-release' }
SoXmlWrapElement >> initialize [
	isEmptyBody := false.

]

{ #category : #accessing }
SoXmlWrapElement >> isEmptyBody [

	^isEmptyBody
]

{ #category : #accessing }
SoXmlWrapElement >> isEmptyBody: aValue [

	isEmptyBody := aValue
]

{ #category : #accessing }
SoXmlWrapElement >> isPrintCDATA [
	isPrintCDATA isNil ifTrue:[ isPrintCDATA := self class isPrintCDATA].
	^isPrintCDATA
]

{ #category : #accessing }
SoXmlWrapElement >> isPrintCDATA: aValue [

	isPrintCDATA := aValue
]

{ #category : #private }
SoXmlWrapElement >> isXmlPrintable [
	^self name notNil
]

{ #category : #accessing }
SoXmlWrapElement >> localName [

	^localName
]

{ #category : #accessing }
SoXmlWrapElement >> localName: aValue [

	localName := aValue
]

{ #category : #accessing }
SoXmlWrapElement >> name [

	^name
]

{ #category : #accessing }
SoXmlWrapElement >> name: aValue [

	name := aValue
]

{ #category : #accessing }
SoXmlWrapElement >> parent [

	^parent
]

{ #category : #accessing }
SoXmlWrapElement >> parent: aValue [

	parent := aValue
]

{ #category : #accessing }
SoXmlWrapElement >> prefixName [

	^prefixName
]

{ #category : #accessing }
SoXmlWrapElement >> prefixName: aValue [

	prefixName := aValue
]

{ #category : #printing }
SoXmlWrapElement >> printOn: aStream [
	"super printOn: aStream" "for Debug"
	self printXmlOn: aStream
]

{ #category : #printing }
SoXmlWrapElement >> printXmlContentsOn: aStream indent: level [ 
	self isEmptyBody
		ifFalse: 
			[self value isNil ifFalse: [self privPrintXmlContentOn: aStream ].
			children isNil ifFalse:["ugly - but for performance"
			aStream cr.
			self privPrintChildrenOn: aStream indent: level + 1.
			level timesRepeat: [aStream space]]].
]

{ #category : #printing }
SoXmlWrapElement >> printXmlFooterOn: aStream [ 
	self isXmlPrintable ifFalse: [^ self].
	self isEmptyBody
		ifFalse: 
			[aStream nextPut: $<.
			aStream nextPut: $/.
			self writeName: self name on: aStream.
			aStream nextPut: $>].
]

{ #category : #printing }
SoXmlWrapElement >> printXmlHeaderOn: aStream [ 
	self isXmlPrintable ifFalse: [^ self].
	self isEmptyBody
		ifTrue: 
			[aStream nextPut: $<.
			self writeName: self name on: aStream.
			self privPrintAttribsOn: aStream.
			aStream nextPut: $/.
			aStream nextPut: $>]
		ifFalse: 
			[aStream nextPut: $<.
			self writeName: self name on: aStream.
			self privPrintAttribsOn: aStream.
			aStream nextPut: $>.].
]

{ #category : #printing }
SoXmlWrapElement >> printXmlOn: aStream [ 
	self printXmlOn: aStream indent: 0
]

{ #category : #printing }
SoXmlWrapElement >> printXmlOn: aStream indent: level [ 
	self isXmlPrintable
		ifFalse: [^ self].
	level
		timesRepeat: [aStream space].
	self printXmlHeaderOn: aStream.
	self printXmlContentsOn: aStream indent: level.
	self printXmlFooterOn: aStream.
	aStream cr
]

{ #category : #private }
SoXmlWrapElement >> privElementClassFrom: parentXmlElement [
	"override to return apporopriate XmlWrapElement"
	^self class
]

{ #category : #private }
SoXmlWrapElement >> privPrintAttribsOn: aStream [
	attributesHolder isNil ifTrue:[^self]. "ugly - but for performance"
	self attributesHolder printXmlOn: aStream
]

{ #category : #private }
SoXmlWrapElement >> privPrintChildrenOn: aStream indent: level [
	(self privSortChildren: children) do:[ :each |
		each printXmlOn: aStream indent: level.
	]
]

{ #category : #private }
SoXmlWrapElement >> privPrintXmlContentOn: aStream [ 
	self isPrintCDATA
		ifTrue: 
			[aStream nextPutAll: '<![CDATA['.
			aStream nextPutAll: self value.
			aStream nextPutAll: ']]>']
		ifFalse: [self writeValue: self value on: aStream.].
]

{ #category : #sorting }
SoXmlWrapElement >> privSortChildren: aCollectionOfXmlElement [
	"default do nothing"
	^aCollectionOfXmlElement
]

{ #category : #actions }
SoXmlWrapElement >> putAttribute: aNameValueArray [
	
	self putAttributeNamed: aNameValueArray first asString value: aNameValueArray last asString
]

{ #category : #actions }
SoXmlWrapElement >> putAttributeNamed: aNameString value: aValueString [
	^self attributesHolder putAttributeNamed: aNameString value: aValueString
]

{ #category : #actions }
SoXmlWrapElement >> removeAttributeNamed: aNameString [
	^self attributesHolder removeAttributeNamed: aNameString
]

{ #category : #actions }
SoXmlWrapElement >> removeChild: anXMLEleemnt [
	^self children remove: anXMLEleemnt ifAbsent:[nil].
	
]

{ #category : #actions }
SoXmlWrapElement >> shortName [
	| nm idx sz |
	nm := self name.
	idx := nm indexOf: $: ifAbsent: [^nm].
	sz := nm size.
	idx > sz ifTrue:[^nm].
	^nm copyFrom: idx + 1 to: sz
]

{ #category : #actions }
SoXmlWrapElement >> undeclareNamespaces [
	self attributesHolder undeclareNamespaces
]

{ #category : #accessing }
SoXmlWrapElement >> value [

	^value
]

{ #category : #accessing }
SoXmlWrapElement >> value: aValue [ 
	aValue isNil
		ifTrue: [^ self].
	value := aValue asString
]

{ #category : #private }
SoXmlWrapElement >> writeName: aCharacterArray on: aStream [ 
	"TODO: check illegal characters"
	^ aStream nextPutAll: aCharacterArray
]

{ #category : #private }
SoXmlWrapElement >> writeValue: aCharacterArray on: aStream [ 
	^SoXmlUtil writeXmlText: aCharacterArray on: aStream
]

{ #category : #printing }
SoXmlWrapElement >> xmlString [
	| wStr |
	wStr := WriteStream on: (String new: 64).
	self printXmlOn: wStr.
	^wStr contents
]

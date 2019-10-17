"
An abstract class for SOAP element.


---
mu 5/21/2001 22:24
"
Class {
	#name : #SoapElement,
	#superclass : #Object,
	#instVars : [
		'attributesHolder',
		'subElements',
		'prefixName',
		'localName',
		'name',
		'value',
		'parent'
	],
	#category : #'SOAP-Core-Elements'
}

{ #category : #private }
SoapElement class >> addAttributesOf: anXmlWrapElement to: aSoapElement [
	anXmlWrapElement attributesDictionary
		keysAndValuesDo: [:k :v | aSoapElement putAttributeNamed: k value: v].
]

{ #category : #private }
SoapElement class >> addSubElementsOf: anXmlWrapElement to: aSoapElement [
	anXmlWrapElement children
		do: [:each | aSoapElement addSubElement: each].
]

{ #category : #'instance creation' }
SoapElement class >> fromXmlElement: anXmlWrapElement [ 
	"Create a new SoapElement that wraps the passed XML element 
	or one of its children"
	| inst |
	inst := self named: anXmlWrapElement name.
	self addAttributesOf: anXmlWrapElement to: inst.
	self addSubElementsOf: anXmlWrapElement to: inst.
	^ inst
]

{ #category : #constants }
SoapElement class >> localName [
	^self name copyReplaceAll: 'Soap' with: ''
]

{ #category : #'instance creation' }
SoapElement class >> named: anElementName [ 
	| index readStream prefixName localName |
	index := anElementName indexOf: $:.
	index = 0
		ifTrue: [SoapNoNamespacePrefix signal: 'Namespace prefix must be provided!']
		ifFalse: [readStream := anElementName readStream.
			prefixName := readStream next: index - 1.
			readStream skip: 1.
			localName := readStream next: anElementName size - index].
	(localName isEmpty
			or: [localName ~= self localName])
		ifTrue: [SoapWrongTagName signal: '"' , localName , '"' , ' must be "' , self localName , '"'].
	^ self new prefixName: prefixName;
		 localName: localName;
		 name: anElementName
]

{ #category : #'instance creation' }
SoapElement class >> new [
	^super new initialize
]

{ #category : #actions }
SoapElement >> addChild: anXmlElement [
	^self addSubElement: anXmlElement
]

{ #category : #actions }
SoapElement >> addSubElement: anXmlElement [
	"anXmlElement mustUnderstand:
		#printXmlOn:aStream indent: anInteger
		#parent: anXmlElement"
	anXmlElement parent: self.
	^self subElements add: anXmlElement.
	
]

{ #category : #accessing }
SoapElement >> attributesHolder [

	^attributesHolder
]

{ #category : #accessing }
SoapElement >> attributesHolder: aValue [

	attributesHolder := aValue
]

{ #category : #actions }
SoapElement >> declareDefaultNamespace [
	self declareNamespace: SoapConstants soapEnvPrefix  uri: SoapConstants soapEnvURI.
	
]

{ #category : #actions }
SoapElement >> declareEncodingIn: nameSpacePrefix  uri: uriString [
	self putAttributeNamed: nameSpacePrefix, ':', SoapConstants encodingStyle value: uriString.
	
]

{ #category : #actions }
SoapElement >> declareNamespace: prefix uri: uri [
	self attributesHolder declareNamespace: prefix uri: uri
]

{ #category : #actions }
SoapElement >> declareSoapEncEncoding [
	self declareEncodingIn: SoapConstants soapEnvPrefix uri: SoapConstants soapEncURI.
]

{ #category : #actions }
SoapElement >> declareSoapEncNamespace [
	self declareNamespace: SoapConstants soapEncPrefix  uri: SoapConstants soapEncURI.
	
]

{ #category : #actions }
SoapElement >> declareTypicalNamespaces [
	self declareXsdNamespace.
	self declareXsiNamespace
]

{ #category : #actions }
SoapElement >> declareXsdNamespace [
	self declareNamespace: SoapConstants xsdPrefix  uri: SoapConstants xsdURI.
	
]

{ #category : #actions }
SoapElement >> declareXsiNamespace [
	self declareNamespace: SoapConstants xsiPrefix  uri: SoapConstants xsiURI.
	
]

{ #category : #actions }
SoapElement >> declaredNamespacePrefixes [
	^self attributesHolder declaredNamespacePrefixes
]

{ #category : #actions }
SoapElement >> encodingStyleURIs [
	"ToDo: take a more serious approach...Namespace conscious"
	| encs |
	encs := self attributesHolder encodingStyle.
	self parent notNil
		ifTrue: [| parentEncodeingURIs myURIs | 
			parentEncodeingURIs := self parent encodingStyleURIs.
			myURIs := SoPortableUtil substringsFrom: encs.
			^ (parentEncodeingURIs ~= myURIs and: [myURIs notEmpty])
				ifTrue: [myURIs]
				ifFalse: [parentEncodeingURIs]].
	^ SoPortableUtil substringsFrom: encs
]

{ #category : #actions }
SoapElement >> evaluate [
	"default do nothing"
]

{ #category : #actions }
SoapElement >> findSubElementLocalNamed: anElemName [
	^self subElements detect: [:each | each localName = anElemName] ifNone:[]
]

{ #category : #actions }
SoapElement >> findSubElementNamed: anElemName [
	^self subElements detect: [:each | each name = anElemName] ifNone:[]
]

{ #category : #actions }
SoapElement >> findSubElementsLocalNamed: anElemName [
	^self subElements select: [:each | each localName = anElemName]
]

{ #category : #actions }
SoapElement >> findSubElementsNamed: anElemName [
	^self subElements select: [:each | each name = anElemName]
]

{ #category : #actions }
SoapElement >> getAttributeNamed: aNameString [
	^self attributesHolder getAttributeNamed: aNameString
]

{ #category : #'initialize-release' }
SoapElement >> initialize [
	attributesHolder := SoapAttributesHolder new.
	
	
]

{ #category : #testing }
SoapElement >> isBody [
	^false
]

{ #category : #testing }
SoapElement >> isEnvelope [
	^false
]

{ #category : #testing }
SoapElement >> isFault [
	^false
]

{ #category : #testing }
SoapElement >> isFaultDetail [
	^false
]

{ #category : #testing }
SoapElement >> isHeader [
	^false
]

{ #category : #accessing }
SoapElement >> localName [

	^localName
]

{ #category : #accessing }
SoapElement >> localName: aString [
	name := nil.
	localName := aString
]

{ #category : #accessing }
SoapElement >> name [
	name isNil
		ifTrue: [prefixName := SoapConstants soapEnvPrefix.
			localName := self class localName.
			name := prefixName , ':' , localName].
	^ name
]

{ #category : #accessing }
SoapElement >> name: aString [
	
	name := aString
]

{ #category : #accessing }
SoapElement >> parent [
	^parent
]

{ #category : #accessing }
SoapElement >> parent: aSoapElement [
	parent := aSoapElement
]

{ #category : #factory }
SoapElement >> parser [
	
	^self class parser
]

{ #category : #accessing }
SoapElement >> prefixName [

	^prefixName
]

{ #category : #accessing }
SoapElement >> prefixName: aString [
	name := nil.
	prefixName := aString
]

{ #category : #printing }
SoapElement >> printOn: aStream [
	"super printOn: aStream" "for Debug"
	self printXmlOn: aStream
]

{ #category : #'private-printing' }
SoapElement >> printXmlContentsOn: aStream indent: level [ 
	aStream cr.
	self privPrintChildrenOn: aStream indent: level + 1.
	level timesRepeat: [aStream space].
]

{ #category : #'private-printing' }
SoapElement >> printXmlFooterOn: aStream [ 
	aStream nextPut: $<.
	aStream nextPut: $/.
	self writeName: self name on: aStream.
	aStream nextPut: $>
]

{ #category : #'private-printing' }
SoapElement >> printXmlHeaderOn: aStream [ 
	aStream nextPut: $<.
	self writeName: self name on: aStream.
	self privPrintAttribsOn: aStream.
	aStream nextPut: $>
]

{ #category : #printing }
SoapElement >> printXmlOn: stream [
	self printXmlOn: stream indent: 0
]

{ #category : #'private-printing' }
SoapElement >> printXmlOn: aStream indent: level [ 
	level
		timesRepeat: [aStream space].
	self printXmlHeaderOn: aStream.
	self printXmlContentsOn: aStream indent: level.
	self printXmlFooterOn: aStream.
	aStream cr
]

{ #category : #printing }
SoapElement >> printXmlString [
	| stream |
	stream := WriteStream on: (String new: 1024).
	self printOn: stream.
	^stream contents.
]

{ #category : #'private-printing' }
SoapElement >> privPrintAttribsOn: aStream [
	self attributesHolder printXmlOn: aStream
]

{ #category : #'private-printing' }
SoapElement >> privPrintChildrenOn: aStream indent: level [
	"$override$"
	subElements isNil ifFalse: [
		self subElements do:[:each | each  printXmlOn: aStream indent: level].
	]
]

{ #category : #actions }
SoapElement >> putAttribute: aNameValueArray [
	^self attributesHolder putAttribute: aNameValueArray
]

{ #category : #actions }
SoapElement >> putAttributeNamed: attribName value: attribValue [
	^self attributesHolder putAttributeNamed: attribName value: attribValue
]

{ #category : #accessing }
SoapElement >> subElements [
	subElements isNil ifTrue: [subElements := OrderedCollection new].
	^subElements
]

{ #category : #accessing }
SoapElement >> subElements: aValue [

	subElements := aValue
]

{ #category : #actions }
SoapElement >> undeclareNamespaces [
	self attributesHolder undeclareNamespaces
]

{ #category : #accessing }
SoapElement >> value [
	^value
]

{ #category : #accessing }
SoapElement >> value: aString [
	value := aString
]

{ #category : #private }
SoapElement >> writeName: aCharacterArray on: aStream [ 
	"ToDo: check illegal characters"
	^ aStream nextPutAll: aCharacterArray
]

{ #category : #private }
SoapElement >> writeValue: aCharacterArray on: aStream [ 
	^SoXmlUtil writeXmlText: aCharacterArray on: aStream
]

{ #category : #private }
SoapElement >> writeValue: aCharacterArray on: aStream betweenTag: aTagString [
	"ToDo: check illegal characters"
	aStream nextPutAll: ('<', aTagString, '>').
	SoXmlUtil writeXmlText: aCharacterArray on: aStream.
	aStream nextPutAll: ('</', aTagString, '>').
]

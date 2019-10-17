Class {
	#name : #SoapDecoder,
	#superclass : #SoapStandardDecoder,
	#classInstVars : [
		'useXsiNullAttribute'
	],
	#category : #'SOAP-Core-Decoding'
}

{ #category : #examples }
SoapDecoder class >> example1 [
	"SoapDecoder example1"
	self customComplexTypeDict at: 'apachens:Map' put: SoapApachensMap
]

{ #category : #'class initialization' }
SoapDecoder class >> initTypeDict [
	"Apparently this mapping is not so sophisticted. "
	"##TODO: Implement more serious mapping method "
	| pref |
	typeDict := super initTypeDict.
	pref := SoapConstants xsdPrefixColon.
	#(
	#(#double #Float)
	#(#decimal #ScaledDecimal)
	#(#base64Binary #ByteArray)
	#(#long #LargePositiveInteger)
	#(#dateTime #DateAndTime)
	) do:[:each | typeDict at: (pref, each first) asSymbol put: each last]. "for Poor Squeak!" 
	^typeDict

]

{ #category : #'class initialization' }
SoapDecoder class >> initialize [
	"SoapDecoder initialize"
	super initialize.
	useXsiNullAttribute := false.
	
	
]

{ #category : #setting }
SoapDecoder class >> useXsiNullAttribute [
	^useXsiNullAttribute
]

{ #category : #setting }
SoapDecoder class >> useXsiNullAttribute: aBoolean [
	useXsiNullAttribute := aBoolean
]

{ #category : #private }
SoapDecoder >> basicDecodeXmlElement: aSoapWrapElement [ 
	| value |
	aSoapWrapElement href ifNotNilDo: [:href | value := self referenceDict at: href ifAbsent:[].
		value ifNil: [^self referenceDict at: href put: (SoapHref on: href in: self referenceDict)].
		^value.
	].
	self class useXsiNullAttribute
		ifTrue: [value := self decodeNilXmlElement: aSoapWrapElement.
			value ifNil: [^ value]].
	(self isArrayType: aSoapWrapElement)
		ifTrue: [value := self decodeArrayXmlElement: aSoapWrapElement.
			self remember: value ifExistsId: aSoapWrapElement.
			^ value].
	value := aSoapWrapElement children isEmpty
				ifTrue: [self decodePrimitiveTyped: aSoapWrapElement xsiType value: aSoapWrapElement value]
				ifFalse: [self decodeComplexXmlElement: aSoapWrapElement].
	self remember: value ifExistsId: aSoapWrapElement.
	^ value
]

{ #category : #private }
SoapDecoder >> decodeNilXmlElement: aSoapWrapElement [ 
	| xsiNull |
	xsiNull := aSoapWrapElement getAttributeNamed: SoapConstants xsiNil.
	(xsiNull = '1'
			or: [xsiNull = 'true'])
		ifTrue: [^ nil].
	^#NOT:NILL "It is not nil"
]

{ #category : #private }
SoapDecoder >> isArrayType: aSoapWrapElement [ 
	^(aSoapWrapElement isArrayType or: [self arrayTypeDict includesKey: aSoapWrapElement xsiType])
		or: [self arrayTypeDict includesKey: aSoapWrapElement shortName] "temporal hack"
]

{ #category : #private }
SoapDecoder >> remember: object ifExistsId: aSoapXmlElement [
	aSoapXmlElement id ifNotNilDo: [:identifier | self referenceDict at: identifier put: object]
]

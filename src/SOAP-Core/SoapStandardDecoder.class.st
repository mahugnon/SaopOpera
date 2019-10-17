Class {
	#name : #SoapStandardDecoder,
	#superclass : #SoapAbstractDecoder,
	#instVars : [
		'complexTypeDict',
		'customComplexTypeDict',
		'arrayTypeDict'
	],
	#classInstVars : [
		'complexTypeDict',
		'customComplexTypeDict',
		'arrayTypeDict'
	],
	#category : #'SOAP-Core-Decoding'
}

{ #category : #accessing }
SoapStandardDecoder class >> arrayTypeDict [
	arrayTypeDict
		ifNil: [arrayTypeDict := Dictionary new].
	^ arrayTypeDict
]

{ #category : #accessing }
SoapStandardDecoder class >> complexTypeDict [
	complexTypeDict
		ifNil: [complexTypeDict := Dictionary new].
	^ complexTypeDict
]

{ #category : #accessing }
SoapStandardDecoder class >> customComplexTypeDict [
	customComplexTypeDict
		ifNil: [customComplexTypeDict := Dictionary new].
	^ customComplexTypeDict
]

{ #category : #'class initialization' }
SoapStandardDecoder class >> initTypeDict [
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
SoapStandardDecoder class >> initialize [
	"self initialize"
	super initialize.
	complexTypeDict := Dictionary new.
	customComplexTypeDict := Dictionary new.
	arrayTypeDict := Dictionary new.

	
	
]

{ #category : #accessing }
SoapStandardDecoder >> arrayTypeDict [
	"Answer the value of arrayTypeDict"
	arrayTypeDict ifNil: [arrayTypeDict := self class arrayTypeDict].
	^ arrayTypeDict
]

{ #category : #accessing }
SoapStandardDecoder >> arrayTypeDict: anObject [
	"Set the value of customComplexTypeDict"

	arrayTypeDict := anObject
]

{ #category : #private }
SoapStandardDecoder >> basicDecodeXmlElement: aSoapWrapElement [ 
	| value |
	(self isArrayType: aSoapWrapElement)
		ifTrue: [value := self decodeArrayXmlElement: aSoapWrapElement.
			^ value].
	value := aSoapWrapElement children isEmpty
				ifTrue: [self decodePrimitiveTyped: (self keyFor: aSoapWrapElement) value: aSoapWrapElement value]
				ifFalse: [self decodeComplexXmlElement: aSoapWrapElement].
	^ value
]

{ #category : #accessing }
SoapStandardDecoder >> complexTypeDict [
	"Answer the value of complexTypeDict"
	complexTypeDict ifNil: [complexTypeDict := self class complexTypeDict].
	^ complexTypeDict
]

{ #category : #accessing }
SoapStandardDecoder >> complexTypeDict: anObject [
	"Set the value of complexTypeDict"

	complexTypeDict := anObject
]

{ #category : #accessing }
SoapStandardDecoder >> customComplexTypeDict [
	"Answer the value of customComplexTypeDict"
	customComplexTypeDict ifNil: [customComplexTypeDict := self class customComplexTypeDict].
	^ customComplexTypeDict
]

{ #category : #accessing }
SoapStandardDecoder >> customComplexTypeDict: anObject [
	"Set the value of customComplexTypeDict"

	customComplexTypeDict := anObject
]

{ #category : #private }
SoapStandardDecoder >> decodeArrayXmlElement: aSoapWrapElement [ 
	| sz arrayClass array |
	sz := aSoapWrapElement size.
	arrayClass := self arrayTypeDict at: (self keyFor: aSoapWrapElement) ifAbsent:[Array].
	array :=  arrayClass new: sz.
	1 to: aSoapWrapElement children size
		do: [:idx | 
			| itemElem | 
			itemElem := aSoapWrapElement children at: idx ifAbsent: [].
			itemElem isNil
				ifFalse: [| itemType decodedItemValue | 
					itemType := aSoapWrapElement arrayItemType.
					decodedItemValue := (((itemType = SoapConstants xsdAnyType
										or: [self isArrayType: itemElem]) or: [itemElem href notNil ])
									or: [itemElem children isEmpty not])
								ifTrue: [self basicDecodeXmlElement: itemElem]
								ifFalse: [self decodePrimitiveTyped: itemType value: itemElem value].
					array at: idx put: decodedItemValue]].
	^ array
]

{ #category : #private }
SoapStandardDecoder >> decodeComplexXmlElement: aSoapXmlElement [ 
	| stClass |
	self customComplexTypeDict at: (self keyFor: aSoapXmlElement) ifPresent: [:p | ^p fromXmlElement: aSoapXmlElement with: self].
	
	stClass := self complexTypeDict at: aSoapXmlElement xsiType
				ifAbsent: [self class environment
					at: (self keyFor: aSoapXmlElement)
					ifAbsent: [self class environment
						at: (SoXmlUtil localNameFrom: aSoapXmlElement xsiType)
						ifAbsent: []]].
	stClass isNil
		ifTrue: [| structDict | 
			structDict := Dictionary new.
			aSoapXmlElement children
				do: [:eachChild | structDict
						at: (SoXmlUtil localNameFrom: eachChild name)
						put: (self basicDecodeXmlElement: eachChild)].
			^ structDict]
		ifFalse: [| structInst allInstVarNames | 
			structInst := stClass new.
			allInstVarNames := stClass allInstVarNames.
			aSoapXmlElement children
				do: [:eachChild | structInst
						instVarAt: (allInstVarNames
								indexOf: ((SoXmlUtil localNameFrom: eachChild name) withFirstCharacterDownshifted))
						put: (self basicDecodeXmlElement: eachChild)].
			^ structInst]
]

{ #category : #private }
SoapStandardDecoder >> decodePrimitiveTyped: xsiTypeName value: value [ 
	"quick hack - should see both prefix url and type"
	| xsiTypeShortName stClsName stClass val  |
	xsiTypeName isNil ifTrue:  [^value].
	xsiTypeShortName := SoXmlUtil localNameFrom: xsiTypeName.
	
	(xsiTypeShortName = SoapConstants boolean) ifTrue: [^(value = 'true' or: [value = '1'])].
	(xsiTypeShortName = SoapConstants string) ifTrue: [^value isNil ifTrue:[''] ifFalse:[value]].
	(xsiTypeShortName = SoapConstants time) ifTrue: [^value]. "quick hack"
	((xsiTypeShortName = SoapConstants base64Binary) or: [xsiTypeShortName = SoapConstants base64]) ifTrue:[^(Base64MimeConverter mimeDecodeToBytes: (value readStream)) contents].
	
	stClsName := self typeDict at: xsiTypeName asSymbol ifAbsent:[ SoapDecodingError signal: xsiTypeName, '''s decoding is not supported by ', self class printString].
	stClass := self class environment at: stClsName.
	val := [stClass readFrom: (ReadStream on: value)] on: Error
		 do: [:ex | SoapDecodingError signal: ('Error in {1}>>readFrom: {2}' translated format: {stClass. ex description}). nil].
	^val
]

{ #category : #actions }
SoapStandardDecoder >> decodeXmlElement: aSoapWrapElement [ 
	| value |
	value := self basicDecodeXmlElement: aSoapWrapElement.
	^value
	
]

{ #category : #private }
SoapStandardDecoder >> isArrayType: aSoapWrapElement [ 
	^aSoapWrapElement isArrayType
]

{ #category : #private }
SoapStandardDecoder >> keyFor: aSoapWrapElement [ 
	^aSoapWrapElement xsiType
]

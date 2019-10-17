"
I will do SOAP encoding which is documented in SOAP 1.1 (1.2) spec.
Note that I am only one of the eocodings for SOAP.

---
MU 10/5/2002 01:32
"
Class {
	#name : #SoapEncoder,
	#superclass : #SoapStandardEncoder,
	#instVars : [
		'useSharedValues'
	],
	#classInstVars : [
		'useXsiNullAttribute',
		'useSharedValues'
	],
	#category : #'SOAP-Core-Encoding'
}

{ #category : #'class initialiation' }
SoapEncoder class >> initTypeDict [
	"Apparently this mapping is not mature. "
	"##TODO: Implement more serious mapping"
	| pref |
	typeDict := super initTypeDict.
	pref := SoapConstants xsdPrefixColon.
	#(
	#(#Any #any)
	#(#DateAndTime #dateTime)
	#(#Time #time)
	#(#Date #date)
	#(#Boolean #boolean)
	#(#True #boolean)
	#(#False #boolean)
	#(#Array #Array)
	#(#ByteArray #base64Binary)
	#(#Float #float)
	#(#Double #double)
	#(#Integer #integer)
	#(#SmallInteger #integer)
	#(#LargePositiveInteger #positiveInteger)
	#(#LargeNegativeInteger #negativeInteger)
	#(#Byte #byte)
	#(#String #string)
	#(#ByteString #string)
	#(#WideString #string)
	#(#Symbol #string)
	#(#ByteSymbol #string)
	#(#WideSymbol #string)
	) do:[:each | typeDict at: each first put: (pref, each last) asSymbol].
	
]

{ #category : #'class initialiation' }
SoapEncoder class >> initialize [
	"SoapEncoder initialize"
	super initialize.
	useXsiNullAttribute := false.
	useSharedValues := true
	
	
]

{ #category : #setting }
SoapEncoder class >> useSharedValues [
	^useSharedValues
]

{ #category : #setting }
SoapEncoder class >> useSharedValues: aBoolean [
	useSharedValues := aBoolean
]

{ #category : #setting }
SoapEncoder class >> useXsiNullAttribute [
	^useXsiNullAttribute
]

{ #category : #setting }
SoapEncoder class >> useXsiNullAttribute: aBoolean [
	useXsiNullAttribute := aBoolean
]

{ #category : #defaults }
SoapEncoder >> arrayTypeCandidateNames [
	"Restricted to conservative"

	^#(Array OrderedCollection SoapEncArray)
	
]

{ #category : #private }
SoapEncoder >> convertedAsRef: aSoapVariable [ 
	| val pair masterXmlElem originalVar sharedId refVar |
	self useSharedValues ifFalse: [^ nil].
	val := aSoapVariable value.
	(self shouldShareValue: val) ifFalse: [^nil].
	pair := self referenceDict at: (self keyFor: val) ifAbsent: [^ nil].

	masterXmlElem := pair first.
	originalVar := pair second.

	sharedId := self keyFor: originalVar.
	refVar := SoapVariable name: aSoapVariable name hrefId: sharedId.
	masterXmlElem id: sharedId.
	^ refVar
]

{ #category : #defaults }
SoapEncoder >> dictionaryTypeCandidateNames [
	"Restricted to conservative"

	^#(Dictionary IdentityDictionary)
	
]

{ #category : #'private-encoding' }
SoapEncoder >> encodeArraySoapVariable: aSoapVariable [ 
	| elem |
	elem := super encodeArraySoapVariable: aSoapVariable.
	self remember: elem for: aSoapVariable.
	^elem 
]

{ #category : #'private-encoding' }
SoapEncoder >> encodeDictionarySoapVariable: aSoapVariable [ 
	| elem |
	elem := super encodeDictionarySoapVariable: aSoapVariable.
	self remember: elem for: aSoapVariable.
	^elem 
]

{ #category : #'private-encoding' }
SoapEncoder >> encodeNilSoapVariable: aSoapVariable [ 
	| elem |
	^self class useXsiNullAttribute
		ifTrue: [elem := self xmlElementClass emptyNamed: aSoapVariable name.
			elem putAttributeNamed: SoapConstants xsiNil value: 1.
			elem]
		ifFalse: [nil]
]

{ #category : #'private-encoding' }
SoapEncoder >> encodePrimitive: aSoapVariable typed: type [ 
	| elem xsiTypeAttVal |
	xsiTypeAttVal := aSoapVariable xsdType.
	xsiTypeAttVal isNil
		ifTrue: [xsiTypeAttVal := self typeDict
						at: type
						ifAbsent: [SoapEncodingError signal: type printString , '''s encoding is not supported by ' , self class printString]].
	elem := self xmlElementClass named: aSoapVariable name.
	elem xsiType: xsiTypeAttVal asString.
	self setXmlAttributesFrom: aSoapVariable into: elem.
	self setXmlElementValue: aSoapVariable into: elem. 
	self remember: elem for: aSoapVariable.
	^ elem
]

{ #category : #'private-encoding' }
SoapEncoder >> encodeRefSoapVariable: aSoapVariable [ 
	| elem |
	elem := self xmlElementClass named: aSoapVariable name.
	self setXmlAttributesFrom: aSoapVariable into: elem.
	^ elem
]

{ #category : #actions }
SoapEncoder >> encodeSoapVariable: aSoapVariable [ 
	| val type |
	aSoapVariable isRefValue ifTrue: [^ self encodeRefSoapVariable: aSoapVariable]. "legacy support"
	(self convertedAsRef: aSoapVariable) ifNotNil: [:var | ^ self encodeRefSoapVariable: var].
	val := aSoapVariable value.
	val isNil ifTrue: [^ self encodeNilSoapVariable: aSoapVariable].

	type := aSoapVariable type.
	type isNil ifTrue: [type := val class name].
	self customComplexTypeDict at: type ifPresent: [:p | ^ aSoapVariable value asXmlElement: aSoapVariable with: self].
	(self arrayTypeCandidateNames includes: type)
		ifTrue: [^ self encodeArraySoapVariable: aSoapVariable].
	(self dictionaryTypeCandidateNames includes: type)
		ifTrue: [^ self encodeDictionarySoapVariable: aSoapVariable].

	type == #SoapEncStruct ifTrue: [^ self encodeStructSoapVariable: aSoapVariable].
	self complexTypeDict at: type 
		ifPresent: [:p |  ^self encodeStructSoapVariable: 
					(aSoapVariable value: ((SoapEncStruct from: aSoapVariable value) xsdType: p))].

	^self encodePrimitive: aSoapVariable typed: type. 
	
]

{ #category : #'private-encoding' }
SoapEncoder >> encodeStructSoapVariable: aSoapVariable [ 
	| elem |
	elem := super encodeStructSoapVariable: aSoapVariable .
	self remember: elem for: aSoapVariable.
	^elem
]

{ #category : #testing }
SoapEncoder >> isSoapEncoder [
	^true
]

{ #category : #private }
SoapEncoder >> keyFor: anObject [
	^anObject soapIdKey
]

{ #category : #private }
SoapEncoder >> remember: anXmlElement for: aSoapVariable [ 
	| val |
	self useSharedValues ifFalse: [^ self].
	val := aSoapVariable value.
	(self shouldShareValue: val)
		ifTrue: [self referenceDict
				at: (self keyFor: val)
				put: {anXmlElement. aSoapVariable}]
]

{ #category : #private }
SoapEncoder >> setXmlElementValue: aSoapVariable into: anXmlElement [ 
	| type value |
	super setXmlElementValue: aSoapVariable into: anXmlElement. 

	"otherwise"
	type := anXmlElement xsiType.
	value := anXmlElement value.
	type = SoapConstants xsdBase64BinaryType
		ifTrue: [| encValue | 
			encValue := (Base64MimeConverter mimeEncode: value asByteArray readStream) contents.
			^ anXmlElement value: encValue]
]

{ #category : #private }
SoapEncoder >> shouldShareValue: soapVarValue [
	"Currently, Boolean and Number types are not shared"
	soapVarValue == true ifTrue: [^false].
	soapVarValue == false ifTrue: [^false].
	soapVarValue isNumber ifTrue: [^false].
	
	^true
]

{ #category : #accessing }
SoapEncoder >> useSharedValues [
	"Answer the value of useSharedValues"
	useSharedValues ifNil: [useSharedValues := self class useSharedValues].
	^ useSharedValues
]

{ #category : #accessing }
SoapEncoder >> useSharedValues: aBoolean [
	"Set the value of useSharedReferences"
	
	useSharedValues := aBoolean
]

{ #category : #private }
SoapEncoder >> useSharedValuesWhile: block [
	| origUseSharedValues |
	origUseSharedValues := self useSharedValues.
	self useSharedValues: true.
	block value.
	self useSharedValues: origUseSharedValues
]

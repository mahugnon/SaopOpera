Class {
	#name : #SoapAbstractEncoder,
	#superclass : #SoapDataBinder,
	#instVars : [
		'referenceDict'
	],
	#category : #'SOAP-Core-Encoding'
}

{ #category : #'class initialization' }
SoapAbstractEncoder class >> initTypeDict [
	"Apparently this mapping is not so sophisticted. "
	"##TODO: Implement more serious mapping method "
	| pref |
	typeDict := super initTypeDict.
	pref := SoapConstants xsdPrefixColon.
	#(
	#(#Boolean #boolean)
	#(#Float #float)
	#(#Double #double)
	#(#Integer #integer)
	#(#SmallInteger #integer)
	#(#LargePositiveInteger #positiveInteger)
	#(#LargeNegativeInteger #negativeInteger)
	#(#String #string)
	#(#ByteString #string)
	) do:[:each | typeDict at: each first put: (pref, each last)].
	^typeDict
]

{ #category : #actions }
SoapAbstractEncoder >> encodeSoapVariable: aSoapVariable [
	self subclassResponsibility
]

{ #category : #testing }
SoapAbstractEncoder >> isLiteralEncoder [
	^true
]

{ #category : #testing }
SoapAbstractEncoder >> isSoapEncoder [
	^false
]

{ #category : #accessing }
SoapAbstractEncoder >> referenceDict [
	"subclass may use this for resolving shared values"
	referenceDict ifNil: [referenceDict := Dictionary new].
	^referenceDict
]

{ #category : #accessing }
SoapAbstractEncoder >> referenceDict: aDictionary [
	"subclass may use this for resolving shared values"
	referenceDict := aDictionary
]

{ #category : #'initialize-release' }
SoapAbstractEncoder >> reset [
	referenceDict := nil
]

{ #category : #factory }
SoapAbstractEncoder >> xmlElementClass [
	^SoapWrapElement
]

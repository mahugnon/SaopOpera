Class {
	#name : #SoapAbstractDecoder,
	#superclass : #SoapDataBinder,
	#instVars : [
		'referenceDict'
	],
	#category : #'SOAP-Core-Decoding'
}

{ #category : #'class initialization' }
SoapAbstractDecoder class >> initTypeDict [
	"Apparently this mapping is not so sophisticted. "
	"##TODO: Implement more serious mapping method "
	| pref |
	typeDict := super initTypeDict.
	pref := SoapConstants xsdPrefixColon.
	#(
	#(#any #String)
	#(#anyType #String)
	#(#time #String)
	#(#boolean #Boolean)
	#(#float #Float)
	#(#double #Double)
	#(#integer #Integer)
	#(#positiveInteger #LargePositiveInteger )
	#(#negativeInteger #LargeNegativeInteger )
	#(#int #Integer)
	#(#string #String)
	) do:[:each | typeDict at: (pref, each first) asSymbol put: each last].
	^typeDict
]

{ #category : #actions }
SoapAbstractDecoder >> decodeXmlElement: aSoapWrapElement [
	self subclassResponsibility
]

{ #category : #'initialize-release' }
SoapAbstractDecoder >> initReferenceDict [
	referenceDict := nil
]

{ #category : #accessing }
SoapAbstractDecoder >> referenceDict [
	"subclass may use this for resolving shared values"
	referenceDict ifNil: [referenceDict := Dictionary new].
	^referenceDict
]

{ #category : #accessing }
SoapAbstractDecoder >> referenceDict: aDictionary [
	"subclass may use this for resolving shared values"
	referenceDict := aDictionary
]

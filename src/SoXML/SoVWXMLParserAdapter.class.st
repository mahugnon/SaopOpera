Class {
	#name : #SoVWXMLParserAdapter,
	#superclass : #Object,
	#category : #'SoXML-ParserAdapter'
}

{ #category : #actions }
SoVWXMLParserAdapter class >> attribDictFrom: aParsedXMLElement [
	"TODO: support multi parser"
	"assuming VWXML"
	| dict |
	dict := Dictionary new.
	aParsedXMLElement isText ifTrue:[^dict].
	aParsedXMLElement attributes do: [:each |
		dict add: (Association key: each tag asString value: each value)
	].
	^dict
]

{ #category : #actions }
SoVWXMLParserAdapter class >> elementNameFrom: aParsedXMLElement [
	"TODO: support multi parser"
	"assuming VWXML"
	^aParsedXMLElement tag asString.
	
]

{ #category : #actions }
SoVWXMLParserAdapter class >> elementShortNameFrom: aParsedXMLElement [
	"TODO: support multi parser"
	"assuming VWXML"
	^aParsedXMLElement tag type.
	
]

{ #category : #actions }
SoVWXMLParserAdapter class >> elementValueFrom: aParsedXMLElement [
	"TODO: support multi parser"
	"assuming VWXML"
	^aParsedXMLElement isText ifTrue: [aParsedXMLElement characterData] ifFalse:[nil].
	
]

{ #category : #actions }
SoVWXMLParserAdapter class >> elementsFrom: aParsedXMLElement [
	"TODO: support multi parser"
	"assuming VWXML"
	^aParsedXMLElement elements.
]

{ #category : #actions }
SoVWXMLParserAdapter class >> elementsWithoutBlankTextsFrom: aParsedXMLElement [
	"TODO: support multi parser"
	"assuming VWXML"
	aParsedXMLElement isText ifTrue:[^#()].
	^aParsedXMLElement elements reject: [:e | e isText and:[ SoPortableUtil isBlank: e characterData]].
]

{ #category : #actions }
SoVWXMLParserAdapter class >> elementsWithoutTextsFrom: aParsedXMLElement [
	"TODO: support multi parser"
	"assuming VWXML"
	^aParsedXMLElement elements select: [:e | e isText not].
]

{ #category : #actions }
SoVWXMLParserAdapter class >> isTextElement: aParsedXMLElement [
	"TODO: support multi parser"
	"assuming VWXML"
	^aParsedXMLElement isText
]

{ #category : #actions }
SoVWXMLParserAdapter class >> parseXml: xmlString [
	"TODO: support multi parser"
	"assuming VWXML"
	^(VWXMLXMLParser processDocumentString: xmlString beforeScanDo: [:p | p validate: false.]) root
	
]

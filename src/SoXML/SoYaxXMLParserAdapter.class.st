Class {
	#name : #SoYaxXMLParserAdapter,
	#superclass : #Object,
	#category : #'SoXML-ParserAdapter'
}

{ #category : #actions }
SoYaxXMLParserAdapter class >> attribDictFrom: aParsedXMLElement [
	aParsedXMLElement isStringNode ifTrue:[^Dictionary new].
	^aParsedXMLElement attributes
]

{ #category : #actions }
SoYaxXMLParserAdapter class >> elementNameFrom: aParsedXMLElement [
	"assuming Yax"
	^aParsedXMLElement name.
	
]

{ #category : #actions }
SoYaxXMLParserAdapter class >> elementShortNameFrom: aParsedXMLElement [
	"assuming Yax"
	^(SoXmlUtil prefixAndLocalNameFrom: (aParsedXMLElement tag)) last.
	
]

{ #category : #actions }
SoYaxXMLParserAdapter class >> elementValueFrom: aParsedXMLElement [
	"assuming Yax"
	| cData |
	cData := aParsedXMLElement contentString.
	^cData isEmpty ifTrue: [nil] ifFalse: [cData]
	
	
]

{ #category : #actions }
SoYaxXMLParserAdapter class >> elementsFrom: aParsedXMLElement [ 
	"assuming YAXO"
	^ aParsedXMLElement elements,  aParsedXMLElement contents
]

{ #category : #actions }
SoYaxXMLParserAdapter class >> elementsWithoutBlankTextsFrom: aParsedXMLElement [ 
	"assuming YAXO"
	^ aParsedXMLElement elements
		, (aParsedXMLElement stringNodes
				reject: [:each | SoPortableUtil isBlank: each contentString])
]

{ #category : #actions }
SoYaxXMLParserAdapter class >> elementsWithoutTextsFrom: aParsedXMLElement [
	"assuming YAXO"
	^aParsedXMLElement elements
]

{ #category : #actions }
SoYaxXMLParserAdapter class >> isTextElement: aParsedXMLElement [ 
	"assuming Yax"
	^ aParsedXMLElement isStringNode
]

{ #category : #actions }
SoYaxXMLParserAdapter class >> parseXml: xmlString [
	"assuming Yax"
	^(XMLDOMParser parse: (ReadStream on: xmlString)) root
	
]

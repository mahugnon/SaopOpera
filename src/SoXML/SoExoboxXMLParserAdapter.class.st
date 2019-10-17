Class {
	#name : #SoExoboxXMLParserAdapter,
	#superclass : #Object,
	#category : #'SoXML-ParserAdapter'
}

{ #category : #actions }
SoExoboxXMLParserAdapter class >> attribDictFrom: aParsedXMLElement [
	aParsedXMLElement isText ifTrue:[^Dictionary new].
	^aParsedXMLElement attributes
]

{ #category : #actions }
SoExoboxXMLParserAdapter class >> elementNameFrom: aParsedXMLElement [
	"assuming Exobox"
	^aParsedXMLElement tag.
	
]

{ #category : #actions }
SoExoboxXMLParserAdapter class >> elementShortNameFrom: aParsedXMLElement [
	^(SoXmlUtil prefixAndLocalNameFrom: (aParsedXMLElement tag)) last.
	
]

{ #category : #actions }
SoExoboxXMLParserAdapter class >> elementValueFrom: aParsedXMLElement [
	| cData |
	cData := aParsedXMLElement charactersData.
	^cData isEmpty ifTrue: [nil] ifFalse: [cData]
	
	
]

{ #category : #actions }
SoExoboxXMLParserAdapter class >> elementsFrom: aParsedXMLElement [
	
	^aParsedXMLElement contents.
]

{ #category : #actions }
SoExoboxXMLParserAdapter class >> elementsWithoutBlankTextsFrom: aParsedXMLElement [
	aParsedXMLElement isText ifTrue:[^#()].
	^aParsedXMLElement contents reject: [:e | e isText and:[ SoPortableUtil isBlank: e text]].
]

{ #category : #actions }
SoExoboxXMLParserAdapter class >> elementsWithoutTextsFrom: aParsedXMLElement [
	
	^aParsedXMLElement contents select: [:e | e isText not].
]

{ #category : #actions }
SoExoboxXMLParserAdapter class >> isTextElement: aParsedXMLElement [
	^aParsedXMLElement isStringNode 
]

{ #category : #actions }
SoExoboxXMLParserAdapter class >> parseXml: xmlString [
	"assuming Exobox"
	^(XMLReader fromString: xmlString) root
	
]

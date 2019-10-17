"
An utility for XML processing.
It includes:
	-Parsing XML
	-Writing XML text

I assume you have VWXMLParser.
If you would like to use other XML parsers, you should subclass me.


---
mu 5/3/2001 19:23
"
Class {
	#name : #SoXmlUtil,
	#superclass : #Object,
	#classInstVars : [
		'convertCharDict',
		'parserAdapter',
		'useNcr',
		'stringEncoding'
	],
	#category : #'SoXML-Base'
}

{ #category : #actions }
SoXmlUtil class >> asXmlText: aString [ 
	|  wStr |
	wStr := WriteStream
				on: (String new: aString size).
	^(self writeXmlText: aString on: wStr) contents
]

{ #category : #'actions-parse' }
SoXmlUtil class >> attribDictFrom: aParsedXMLElement [
	^self parserAdapter attribDictFrom: aParsedXMLElement
]

{ #category : #actions }
SoXmlUtil class >> contentsWithXmlDeclaration: aString [ 
	| wStr |
	wStr := WriteStream on: (String new: 1024).
	wStr nextPutAll: '<?xml version="1.0" encoding="' , self stringEncoding, '"?>'.
	2 timesRepeat: [wStr nextPut: Character cr.
			wStr nextPut: Character lf].
	wStr nextPutAll: aString.
	^SoPortableUtil convertString: wStr contents to: self stringEncoding.
	
]

{ #category : #accessing }
SoXmlUtil class >> convertCharDict [
	^convertCharDict
]

{ #category : #'actions-parse' }
SoXmlUtil class >> elementNameFrom: aParsedXMLElement [
	^self parserAdapter elementNameFrom: aParsedXMLElement
	
]

{ #category : #'actions-parse' }
SoXmlUtil class >> elementShortNameFrom: aParsedXMLElement [
	^self parserAdapter elementShortNameFrom: aParsedXMLElement
	
]

{ #category : #'actions-parse' }
SoXmlUtil class >> elementValueFrom: aParsedXMLElement [
	^self parserAdapter elementValueFrom: aParsedXMLElement
]

{ #category : #'actions-parse' }
SoXmlUtil class >> elementsFrom: aParsedXMLElement [
	^self parserAdapter elementsFrom: aParsedXMLElement
]

{ #category : #'actions-parse' }
SoXmlUtil class >> elementsWithoutBlankTextsFrom: aParsedXMLElement [
	^self parserAdapter elementsWithoutBlankTextsFrom: aParsedXMLElement
]

{ #category : #'actions-parse' }
SoXmlUtil class >> elementsWithoutTextsFrom: aParsedXMLElement [
	^self parserAdapter elementsWithoutTextsFrom: aParsedXMLElement
]

{ #category : #'private-initialize' }
SoXmlUtil class >> initConvertCharDict [
	convertCharDict := Dictionary new.
	0 to: 47 do: [:each | convertCharDict at: each put: '&#', each asString, ';'].
	convertCharDict 
		at: $& asciiValue put: '&amp;';
		at: $< asciiValue put: '&lt;';
		at: $> asciiValue put: '&gt;';
		at: $' asciiValue put: '&apos;';
		at: $" asciiValue put: '&quot;'.
	convertCharDict 
		removeKey: Character space asciiValue;
		removeKey: Character tab asciiValue;
		removeKey: Character cr asciiValue;
		removeKey: Character lf asciiValue.
	convertCharDict 
		removeKey: $/ asciiValue;
		removeKey: $- asciiValue;
		removeKey: $# asciiValue;
		removeKey: $. asciiValue.
]

{ #category : #'private-initialize' }
SoXmlUtil class >> initParserAdapter [
	"Currently YAXO and VWXML conscious"
	parserAdapter := self environment
				at: #SoYaxXMLParserAdapter
				ifAbsent: [self environment
						at: #SoVWXMLParserAdapter
						ifAbsent: [Transcript cr; show: '##failed to initParserAdapter##']]
]

{ #category : #'class initialization' }
SoXmlUtil class >> initialize [
	"SoXmlUtil initialize"
	self initConvertCharDict.
	parserAdapter := nil
	
	
]

{ #category : #actions }
SoXmlUtil class >> isPrefixedName: aString [
	"self isPrefixedName: 'aaa:bbb'"
	aString ifNil: [^false].
	^aString includes: $:
	
]

{ #category : #'actions-parse' }
SoXmlUtil class >> isTextElement: aParsedXMLElement [
	^self parserAdapter isTextElement: aParsedXMLElement
]

{ #category : #actions }
SoXmlUtil class >> localNameFrom: aString [ 
	aString ifNil: [^''].
	^(self prefixAndLocalNameFrom: aString) last
]

{ #category : #'actions-parse' }
SoXmlUtil class >> parseXml: xmlString [
	^self parserAdapter parseXml: xmlString
	
]

{ #category : #accessing }
SoXmlUtil class >> parserAdapter [
	parserAdapter ifNil:[self initParserAdapter]. 
	^parserAdapter
]

{ #category : #accessing }
SoXmlUtil class >> parserAdapter: xmlParserAdapter [
	parserAdapter := xmlParserAdapter
]

{ #category : #actions }
SoXmlUtil class >> prefixAndLocalNameFrom: aString [ 
	| index readStream prefixName localName |
	index := aString indexOf: $:.
	index = 0
		ifTrue: [prefixName := ''.
			localName := aString]
		ifFalse: [readStream := aString readStream.
			prefixName := readStream next: index - 1.
			readStream skip: 1.
			localName := readStream next: aString size - index].
	^ Array with: prefixName with: localName
]

{ #category : #actions }
SoXmlUtil class >> prefixFrom: aString [ 
	aString ifNil: [^nil].
	^(self prefixAndLocalNameFrom: aString) first
]

{ #category : #actions }
SoXmlUtil class >> randomPrefix [
	^'ns', (Random new nextInt: 100000000) printString
	
]

{ #category : #accessing }
SoXmlUtil class >> stringEncoding [
	stringEncoding ifNil: [stringEncoding := 'utf-8'].
	^stringEncoding
]

{ #category : #accessing }
SoXmlUtil class >> stringEncoding: aString [
	stringEncoding := aString
]

{ #category : #accessing }
SoXmlUtil class >> useNcr [
	useNcr ifNil: [useNcr := false].
	^useNcr
]

{ #category : #accessing }
SoXmlUtil class >> useNcr: aBoolean [
	useNcr := aBoolean == true
]

{ #category : #private }
SoXmlUtil class >> writeUnicodeChar: aCharacter code: charCode on: aWriteStream [ 
	self useNcr
		ifTrue: [aWriteStream nextPutAll: '&#';
				 nextPutAll: charCode asString;
				 nextPut: $;]
		ifFalse: [aWriteStream nextPut: aCharacter]
]

{ #category : #actions }
SoXmlUtil class >> writeXmlText: aString on: aWriteStream [
	| cDict wStr contentStr |
	cDict := self convertCharDict.
	wStr := aWriteStream.
	contentStr := aString asString.
	contentStr
		do: [:eachChar | 
			| val | 
			val := eachChar charCode.
			val >= 127
				ifTrue: [self writeUnicodeChar: eachChar code: val on: wStr ]
				ifFalse: [| conv | 
					conv := cDict
								at: val
								ifAbsent: [].
					conv isNil
						ifTrue: [wStr nextPut: eachChar]
						ifFalse: [wStr nextPutAll: conv]]].
	^wStr
]

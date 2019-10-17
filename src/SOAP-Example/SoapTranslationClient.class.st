Class {
	#name : #SoapTranslationClient,
	#superclass : #Object,
	#instVars : [
		'translateCall'
	],
	#classInstVars : [
		'callEntry',
		'targetObjectURI',
		'namespace',
		'host',
		'port',
		'modeMap'
	],
	#category : #'SOAP-Example-Translate'
}

{ #category : #accessing }
SoapTranslationClient class >> callEntry [
	callEntry isNil ifTrue: [ callEntry := SoapCallEntry tcpHost: self host port: self port].
	^callEntry
]

{ #category : #accessing }
SoapTranslationClient class >> callEntry: aValue [

	callEntry := aValue
]

{ #category : #accessing }
SoapTranslationClient class >> host [
	host isNil ifTrue: [host := 'www.webservicex.net'].
	^host
]

{ #category : #accessing }
SoapTranslationClient class >> host: aValue [

	host := aValue
]

{ #category : #documentation }
SoapTranslationClient class >> howToUse [
	"##SoapTranslationClient is an example that accesses Translate Engine at: http://www.webservicex.net##"
	
	"1: Usages (print it)"
	"SoapTranslationClient new
		translate: ' OpenCroquet ist eine verteilte, interaktive Plattform.'
		by: 'GermanToEnglish'.
	"

	"You can set one of these translate modes:"
	"SoapTranslationClient supportedModes 
	"
	
]

{ #category : #'class initialization' }
SoapTranslationClient class >> initialize [
	modeMap := nil.
	callEntry := targetObjectURI := namespace := host := port := nil.
]

{ #category : #accessing }
SoapTranslationClient class >> modeMap [
	modeMap isNil ifTrue: [ modeMap := self prepareModeMap].
	^modeMap
]

{ #category : #accessing }
SoapTranslationClient class >> modeMap: aDictionary [
	modeMap := aDictionary
]

{ #category : #accessing }
SoapTranslationClient class >> namespace [
	namespace isNil ifTrue: [namespace := 'http://www.webservicex.net'].
	^namespace
]

{ #category : #accessing }
SoapTranslationClient class >> namespace: aValue [

	namespace := aValue
]

{ #category : #actions }
SoapTranslationClient class >> newCall [
	| call |
	call := self callEntry newCall.
	call targetObjectURI: self targetObjectURI.
	call namespace: self namespace.
	call prefix: ''.
	call useLiteral: true.
	call soapAction: 'http://www.webservicex.net/Translate'.
	^call
]

{ #category : #accessing }
SoapTranslationClient class >> port [
	port isNil ifTrue: [port := 80].
	^port
]

{ #category : #accessing }
SoapTranslationClient class >> port: aValue [

	port := aValue
]

{ #category : #constants }
SoapTranslationClient class >> prepareModeMap [
	modeMap := Dictionary new.
	self supportedModes
		do: [:each | 
			| key | 
			key := each asLowercase.
			modeMap at: key put: each].
	^ modeMap
]

{ #category : #constants }
SoapTranslationClient class >> supportedModes [
	^ #(#EnglishTOChinese #EnglishTOFrench #EnglishTOGerman #EnglishTOItalian #EnglishTOJapanese #EnglishTOKorean #EnglishTOPortuguese #EnglishTOSpanish #ChineseTOEnglish #FrenchTOEnglish #FrenchTOGerman #GermanTOEnglish #GermanTOFrench #ItalianTOEnglish #JapaneseTOEnglish #KoreanTOEnglish #PortugueseTOEnglish #RussianTOEnglish #SpanishTOEnglish #SpanishToFrench #PortugueseToFrench #ItalianToFrench #GreekToFrench #GermanToFrench #FrenchToGreek #FrenchToItalian #FrenchToPortuguese #FrenchToDutch #FrenchToSpanish #EnglishToRussian #EnglishToDutch #DutchToEnglish #DutchToFrench #GreekToEnglish )
]

{ #category : #accessing }
SoapTranslationClient class >> targetObjectURI [
	targetObjectURI isNil ifTrue: [targetObjectURI := '/TranslateService.asmx'].
	^targetObjectURI
]

{ #category : #accessing }
SoapTranslationClient class >> targetObjectURI: aValue [

	targetObjectURI := aValue
]

{ #category : #private }
SoapTranslationClient >> buildTranslateCall [
	| call |
	call := self newCall.
	call methodName: 'Translate'.
	call addParameterNamed: #LanguageMode.
	call addParameterNamed: #Text.
	^call
]

{ #category : #accessing }
SoapTranslationClient >> modeMap [
	^self class modeMap
]

{ #category : #private }
SoapTranslationClient >> newCall [
	^self class newCall
]

{ #category : #actions }
SoapTranslationClient >> translate: aString by: translateMode [ 
	| mode |
	mode := translateMode asLowercase.
	mode := self modeMap
				at: mode
				ifAbsent: [self
						error: ('{1} is not supported' translated format: {mode})].
	^ self translateCall invokeAndReturnWithValues: {mode. aString}
]

{ #category : #accessing }
SoapTranslationClient >> translateCall [
	translateCall ifNil: [translateCall := self buildTranslateCall ].
	^translateCall
]

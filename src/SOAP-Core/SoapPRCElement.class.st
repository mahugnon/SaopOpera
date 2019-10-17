Class {
	#name : #SoapPRCElement,
	#superclass : #SoapEncodable,
	#instVars : [
		'targetObjectURI',
		'methodName',
		'parameters',
		'optionSignature',
		'optionHeaderProperties',
		'transport',
		'envelope',
		'context',
		'namespace',
		'prefix',
		'useLiteral',
		'style'
	],
	#classVars : [
		'DefaultNamespace',
		'DefaultPrefix'
	],
	#category : #'SOAP-Core-RPC'
}

{ #category : #accessing }
SoapPRCElement class >> defaultNamespace [
	DefaultNamespace isNil
		ifTrue: [DefaultNamespace := 'http://www.mars.dti.ne.jp/~umejava/smalltalk/soapOpera/rpc/'].
	^ DefaultNamespace
]

{ #category : #accessing }
SoapPRCElement class >> defaultNamespace: aString [
	DefaultNamespace := aString
]

{ #category : #accessing }
SoapPRCElement class >> defaultPrefix [
	DefaultPrefix isNil
		ifTrue: [DefaultPrefix := 'm'].
	^ DefaultPrefix

]

{ #category : #accessing }
SoapPRCElement class >> defaultPrefix: aString [
	DefaultPrefix := aString
]

{ #category : #'class initialization' }
SoapPRCElement class >> initialize [
	"SoapPRCElement initialize"
	DefaultPrefix := DefaultNamespace := nil
]

{ #category : #actions }
SoapPRCElement class >> unmarshallFrom: aSoapEnvelope [
	"create one of my family"
]

{ #category : #'building context' }
SoapPRCElement >> buildContext [
	| ctx | 
	ctx := SoapContext new.
	ctx targetObjectURI: self targetObjectURI.
	^ctx
]

{ #category : #accessing }
SoapPRCElement >> context [
	context isNil ifTrue: [context := self buildContext].
	^context
]

{ #category : #accessing }
SoapPRCElement >> context: aValue [

	context := aValue
]

{ #category : #'actions-encoding' }
SoapPRCElement >> encoder: aValue [ 
	parameters notNil
		ifTrue: [self parameters
				do: [:each | each encoder: aValue]].
	super encoder: aValue.
	
]

{ #category : #'actions-encoding' }
SoapPRCElement >> encoding: aSymbol [
	parameters notNil
		ifTrue: [self parameters
				do: [:each | each encoding: aSymbol]].
	super encoding: aSymbol.
]

{ #category : #'actions-encoding' }
SoapPRCElement >> encodingStyleURI: aURIString [
	parameters notNil
		ifTrue: [self parameters
				do: [:each | each encodingStyleURI: aURIString]].
	super encodingStyleURI: aURIString.
]

{ #category : #'actions-encoding' }
SoapPRCElement >> encodingStyleURIString: anEncodingStyleURI [ 
	parameters notNil
		ifTrue: [self parameters
				do: [:each | each encodingStyleURIString: anEncodingStyleURI]].
	super encodingStyleURIString: anEncodingStyleURI.
]

{ #category : #'actions-encoding' }
SoapPRCElement >> encodingStyleURIs: aValue [
	parameters notNil
		ifTrue: [self parameters
				do: [:each | each encodingStyleURIs: aValue]].
	super encodingStyleURIs: aValue.
	
]

{ #category : #accessing }
SoapPRCElement >> envelope [
	envelope isNil ifTrue: [envelope := SoapEnvelope new].
	^envelope
]

{ #category : #accessing }
SoapPRCElement >> envelope: aValue [

	envelope := aValue
]

{ #category : #testing }
SoapPRCElement >> isCall [
	^false
]

{ #category : #testing }
SoapPRCElement >> isResponse [
	^false
]

{ #category : #testing }
SoapPRCElement >> isVariable [
	^false
]

{ #category : #accessing }
SoapPRCElement >> methodName [
	methodName isNil ifTrue: [methodName := ''].
	^methodName
]

{ #category : #accessing }
SoapPRCElement >> methodName: aValue [

	methodName := aValue
]

{ #category : #accessing }
SoapPRCElement >> namespace [
	namespace isNil ifTrue: [namespace := self class defaultNamespace].
	^namespace
]

{ #category : #accessing }
SoapPRCElement >> namespace: aValue [

	namespace := aValue
]

{ #category : #accessing }
SoapPRCElement >> optionHeaderProperties [
	optionHeaderProperties isNil ifTrue: [optionHeaderProperties := Dictionary new].
	^optionHeaderProperties
]

{ #category : #accessing }
SoapPRCElement >> optionHeaderProperties: aValue [

	optionHeaderProperties := aValue
]

{ #category : #accessing }
SoapPRCElement >> optionSignature [

	^optionSignature
]

{ #category : #accessing }
SoapPRCElement >> optionSignature: aValue [

	optionSignature := aValue
]

{ #category : #accessing }
SoapPRCElement >> parameters [
	parameters isNil ifTrue: [parameters := OrderedCollection new].
	^parameters
]

{ #category : #accessing }
SoapPRCElement >> parameters: aValue [

	parameters := aValue
]

{ #category : #accessing }
SoapPRCElement >> prefix [
	prefix isNil ifTrue: [prefix := self class defaultPrefix].
	^prefix
]

{ #category : #accessing }
SoapPRCElement >> prefix: aValue [

	prefix := aValue
]

{ #category : #accessing }
SoapPRCElement >> style [
	style ifNil: [style := #rpc].
	^style
]

{ #category : #accessing }
SoapPRCElement >> style: aSymbol [
	"#rpc #document (note that #document is not 'document wrapped style')"
	| symbol |
	symbol := aSymbol asString asLowercase asSymbol.
	(#(#rpc #document) includes: symbol) ifFalse: [symbol := #rpc].
	^style := symbol
]

{ #category : #accessing }
SoapPRCElement >> targetObjectURI [
	targetObjectURI isNil ifTrue: [targetObjectURI := ''].
	^targetObjectURI
]

{ #category : #accessing }
SoapPRCElement >> targetObjectURI: aString [
	targetObjectURI := SoPortableUtil relativeURIFrom: aString.
]

{ #category : #accessing }
SoapPRCElement >> transport [
	transport isNil ifTrue: [transport := #http].
	^transport
]

{ #category : #accessing }
SoapPRCElement >> transport: aValue [

	transport := aValue
]

{ #category : #accessing }
SoapPRCElement >> useLiteral [
	useLiteral isNil ifTrue: [useLiteral := false].
	^useLiteral
]

{ #category : #accessing }
SoapPRCElement >> useLiteral: aBoolean [ 
	useLiteral := aBoolean.
	useLiteral
		ifTrue: [self encoder: SoapLiteralEncoder new]
		ifFalse: [self encoder isLiteralEncoder
				ifFalse: [self encoder: nil]]
]

{ #category : #factory }
SoapPRCElement >> xmlElementClass [
	^SoapWrapElement
]

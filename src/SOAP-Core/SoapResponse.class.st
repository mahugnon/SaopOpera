"
I represent a SOAP RPC response.

---
MU 5/12/2002 00:47
"
Class {
	#name : #SoapResponse,
	#superclass : #SoapPRCElement,
	#instVars : [
		'returnValue',
		'outparameters',
		'fault',
		'exceptionBuilder',
		'referenceDict'
	],
	#classInstVars : [
		'useDotNetStyleSharedValues'
	],
	#category : #'SOAP-Core-RPC'
}

{ #category : #'instance creation' }
SoapResponse class >> fromSoapMessage: aSoapMessage [
	^self new initialize: aSoapMessage
	
]

{ #category : #'class initialization' }
SoapResponse class >> initialize [
	super initialize.
	useDotNetStyleSharedValues := false
]

{ #category : #accessing }
SoapResponse class >> useDotNetStyleSharedValues [
	useDotNetStyleSharedValues ifNil: [useDotNetStyleSharedValues := true].
	^useDotNetStyleSharedValues
]

{ #category : #accessing }
SoapResponse class >> useDotNetStyleSharedValues: aBoolean [
	useDotNetStyleSharedValues := aBoolean == true
]

{ #category : #private }
SoapResponse >> buildAdditionalResults [
	| retValues sz |
	retValues := self envelope body bodyEntries.
	retValues
		ifEmpty: [^ retValues].
	sz := retValues size.
	sz <= 1
		ifTrue: [^ #()].
	2
		to: sz
		do: [:idx | self
				extractDecodedValueFrom: (retValues at: idx)]
]

{ #category : #private }
SoapResponse >> buildDocumentTypeReturnValueWith: methodElem [ 
	| decoder retValues |

	decoder := self decoderFrom: methodElem.
	retValues := methodElem children.
	
	(retValues size = 1 and: [(decoder isArrayType: methodElem) not])
		ifTrue: [^ self extractDecodedValueFrom: retValues first].

	^ retValues
		collect: [:each | self extractDecodedValueFrom: each]
]

{ #category : #private }
SoapResponse >> buildException [
	
	^self exceptionBuilder buildExceptionFrom: self fault
]

{ #category : #private }
SoapResponse >> buildOutparameters [
	| retValues retStruct sz outparams |
	retValues := self envelope body bodyEntries.
	retValues ifEmpty: [^retValues].

	retStruct := retValues first.
	sz := retStruct size.
	sz <= 1
		ifTrue: [^ #()].
	
	outparams := OrderedCollection new.
	2
		to: sz
		do: [:idx | outparams
				add: (self
						extractDecodedValueFrom: (retStruct children at: idx))].
	^outparams
]

{ #category : #private }
SoapResponse >> buildReturnValue [
	| retValueElem methodElem |
	methodElem := self envelope body bodyEntries first.
	self style = #document
		ifTrue: [^self buildDocumentTypeReturnValueWith: methodElem]
		ifFalse: [retValueElem := methodElem findChildNamed: SoapConstants returnValueAccessor.
			retValueElem isNil
				ifTrue: [retValueElem := methodElem children isEmpty
								ifFalse: [methodElem children first]]].
	^ self extractDecodedValueFrom: retValueElem
]

{ #category : #private }
SoapResponse >> decoderFrom: aSoapWrapElement [
	^SoapDecoderFactory createFrom: aSoapWrapElement encodingStyleURIs.
	
]

{ #category : #accessing }
SoapResponse >> exceptionBuilder [
	exceptionBuilder isNil ifTrue: [exceptionBuilder := SoapExceptionBuilder new].
	^exceptionBuilder
]

{ #category : #accessing }
SoapResponse >> exceptionBuilder: aSoapExceptionBuilder [
	exceptionBuilder := aSoapExceptionBuilder
]

{ #category : #private }
SoapResponse >> extractDecodedValueFrom: aSoapWrapElement [
	| decoder |
	aSoapWrapElement isNil ifTrue:[^nil].
	decoder := self decoderFrom: aSoapWrapElement.
	decoder referenceDict: self referenceDict.
	^decoder decodeXmlElement: aSoapWrapElement
]

{ #category : #accessing }
SoapResponse >> fault [
	fault isNil ifTrue: [fault := self envelope body fault].
	^fault
]

{ #category : #'initialize-release' }
SoapResponse >> initReferenceDict [
	referenceDict := nil
]

{ #category : #'initialize-release' }
SoapResponse >> initialize: aSoapMessage [
	self initReferenceDict.
	self envelope: aSoapMessage envelope.
	self context: aSoapMessage context
]

{ #category : #actions }
SoapResponse >> isFault [
	^self fault notNil
]

{ #category : #testing }
SoapResponse >> isResponse [
	^true
]

{ #category : #accessing }
SoapResponse >> methodName [
	(self isFault not
			and: [methodName isNil])
		ifTrue: [methodName := self envelope body bodyEntries first name copyReplaceAll: 'Responce' with: ''].
	^ methodName
]

{ #category : #actions }
SoapResponse >> outparameters [
	self isFault ifTrue: [^ nil].
	outparameters isNil
		ifTrue: [outparameters := self buildOutparameters.
			self class useDotNetStyleSharedValues
				ifTrue: [self buildAdditionalResults]].
	^ outparameters
]

{ #category : #printing }
SoapResponse >> printOn: aStream [
	aStream nextPutAll: 'a ', self class name.
	aStream nextPutAll: ' ['.
	aStream nextPutAll: ' isFault= ', self isFault printString.
	aStream nextPutAll: ' methodName= ', self methodName printString.
	aStream nextPutAll: ' ]'.
	
	
]

{ #category : #actions }
SoapResponse >> raiseException [
	"If you would like to details, do it: (self fault inspect)" 
	self isFault ifTrue: [self buildException signal].
]

{ #category : #accessing }
SoapResponse >> referenceDict [
	referenceDict ifNil: [referenceDict := Dictionary new].
	^referenceDict
]

{ #category : #accessing }
SoapResponse >> referenceDict: aDictionary [
	referenceDict := aDictionary
]

{ #category : #actions }
SoapResponse >> returnValue [
	self isFault ifTrue: [^ nil].
	returnValue isNil
		ifTrue: [returnValue := self buildReturnValue.
			self class useDotNetStyleSharedValues
				ifTrue: [self buildAdditionalResults]].
	^ returnValue
]

{ #category : #accessing }
SoapResponse >> targetObjectURI [
	targetObjectURI isNil ifTrue: [targetObjectURI := self context targetObjectURI ].
	^targetObjectURI
]

{ #category : #accessing }
SoapResponse >> transport [
	transport isNil ifTrue: [transport := self context at: #transport ifAbsent:[]].
	^transport
]

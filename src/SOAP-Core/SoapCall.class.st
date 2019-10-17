"
I represent a Remote Procedure Call in SOAP.

---
MU 5/12/2002 00:47
"
Class {
	#name : #SoapCall,
	#superclass : #SoapPRCElement,
	#instVars : [
		'connector',
		'locator',
		'useColocation',
		'autoSoapActionIntent'
	],
	#category : #'SOAP-Core-RPC'
}

{ #category : #'instance creation' }
SoapCall class >> locator: aLocatorObject [
	^self basicNew locator: aLocatorObject
]

{ #category : #'instance creation' }
SoapCall class >> new [
	"default locator is SoapTcpLocator for localhost"
	^ self
		locator: (SoapTcpLocator host: 'localhost' port: 8823)
]

{ #category : #'instance creation' }
SoapCall class >> url: anURLString [
	| url host port protocol targetObjectURI locator inst |
	url := anURLString asUrl.
	host := url authority.
	port := url port.
	protocol := url schemeName asSymbol.
	targetObjectURI := url fullPath.
	locator := SoapTcpLocator host: host port: port.
	inst := self locator: locator.
	inst targetObjectURI: targetObjectURI.
	inst transport: protocol.
	^inst

]

{ #category : #actions }
SoapCall >> addParameter: aSoapVariable [
	aSoapVariable parent: self.
	^self parameters add: aSoapVariable
]

{ #category : #actions }
SoapCall >> addParameterArray: parameterArray [
	"parameterArray -> {name. value(optional). xsdType(optional) }"
	| paramSize |
	paramSize := parameterArray size.
	paramSize = 1 ifTrue: [^self addParameterNamed: (parameterArray at: 1)].
	paramSize = 2 ifTrue: [^self addParameterNamed: (parameterArray at: 1) value: (parameterArray at: 2)].
	paramSize = 3 ifTrue: [^self addParameterNamed: (parameterArray at: 1) value: (parameterArray at: 2) xsdType: (parameterArray at: 3)].
	
	
]

{ #category : #actions }
SoapCall >> addParameterNamed: paramName [ 
	^self addParameter: (SoapVariable name: paramName). 
]

{ #category : #actions }
SoapCall >> addParameterNamed: paramName type: xsdType [
	^self addParameter: (SoapVariable name: paramName type: xsdType). 
]

{ #category : #actions }
SoapCall >> addParameterNamed: paramName value: paramValue [
	^self addParameter: (SoapVariable name: paramName value: paramValue). 
]

{ #category : #actions }
SoapCall >> addParameterNamed: paramName value: paramValue type: xsdType [
	^self addParameter: (SoapVariable name: paramName value: paramValue type: xsdType). 
]

{ #category : #actions }
SoapCall >> addParameterNamed: paramName value: paramValue xsdType: xsdType [
	^self addParameter: (SoapVariable name: paramName value: paramValue xsdType: xsdType). 
]

{ #category : #actions }
SoapCall >> addParameterNamed: paramName value: paramValue xsdType: xsdType namespace: namespaceURI [
	^self addParameter: (SoapVariable name: paramName value: paramValue xsdType: xsdType namespace: namespaceURI ). 
]

{ #category : #actions }
SoapCall >> addParameterNamed: paramName xsdType: xsdType [
	^self addParameter: (SoapVariable name: paramName xsdType: xsdType). 
]

{ #category : #actions }
SoapCall >> addParameterNamed: paramName xsdType: xsdType namespace: namespaceURI [
	^self addParameter: (SoapVariable name: paramName xsdType: xsdType namespace: namespaceURI). 
]

{ #category : #actions }
SoapCall >> addParameters: parameterArrays [
	^parameterArrays do: [:each | self addParameterArray: each]
]

{ #category : #accessing }
SoapCall >> autoSoapActionIntent [
	autoSoapActionIntent isNil ifTrue: [ autoSoapActionIntent := false].
	^autoSoapActionIntent
]

{ #category : #accessing }
SoapCall >> autoSoapActionIntent: aBoolean [
	autoSoapActionIntent := aBoolean
]

{ #category : #'building envelope' }
SoapCall >> buildEnvelope [
	| env |
	env := self envelope.
	env declareTypicalNamespaces.
	self encoder reset.
	self useLiteral
		ifFalse: [env declareEncodingIn: SoapConstants soapEnvPrefix uri: self encodingStyleURIString.
			self encoder isSoapEncoder
				ifTrue: [env declareSoapEncNamespace]].
	self optionHeaderProperties isEmpty
		ifFalse: [self buildSoapHeader: env addHeader].
	env addBody.
	self buildSoapBody: env body.
	^ env
]

{ #category : #'building envelope' }
SoapCall >> buildSoapBody: aSoapBody [ 
	| callElem |
	callElem := self callElementFor: aSoapBody.
	self parameters
		do: [:each | callElem
				addChild: (each asXmlElement)].
	^ aSoapBody
]

{ #category : #'building envelope' }
SoapCall >> buildSoapHeader: aSoapHeader [
	"##TODO: support additional header properties (like transaction id)"
	^aSoapHeader
	
	
]

{ #category : #private }
SoapCall >> callElementFor: aSoapBody [ 
	| pref callElem |
	(self style == #document and: [self methodName isEmpty]) ifTrue: [^aSoapBody].
	pref := self prefix.
	callElem := self xmlElementClass named: self methodName withPrefix: pref.
	callElem declareNamespace: pref uri: self namespace.
	aSoapBody addBodyEntry: callElem.
	^callElem
]

{ #category : #private }
SoapCall >> clear [
	self optionHeaderProperties: nil.
	self envelope: nil.
	self context: nil.
	
]

{ #category : #testing }
SoapCall >> colocated [
	^ self locator colocated
]

{ #category : #accessing }
SoapCall >> connector [
	connector isNil ifTrue: [ connector := self createConnector].
	^connector
]

{ #category : #accessing }
SoapCall >> connector: aValue [

	connector := aValue
]

{ #category : #factory }
SoapCall >> createConnector [
	| trans |
	trans := self transport.
	(self useColocation
			and: [self locator colocatedFor: self transport])
		ifTrue: [trans := #localRpc].
	^ SoapConnectorFactory createFrom: trans
]

{ #category : #actions }
SoapCall >> declareEnvelopeNamespace: prefixString uri: uri [
	self envelope declareNamespace: prefixString uri: uri
]

{ #category : #private }
SoapCall >> generateSoapActionIntent [
	"Especially for .Net server - that requires this type of SOAPAction format"
	self soapAction: (self namespace, '/', self methodName).
]

{ #category : #'actions-invoking' }
SoapCall >> invoke [
	| returnedMsg resp | 
	self autoSoapActionIntent ifTrue: [self generateSoapActionIntent].
	self optionHeaderProperties keysAndValuesDo:[:k :v | self context at: k put: v].
	returnedMsg := self connector send: self buildEnvelope to: self locator with: self context.
	resp := SoapResponse fromSoapMessage: returnedMsg.
	resp style: self style.
	self clear.
	^resp
	
]

{ #category : #'actions-invoking' }
SoapCall >> invokeAndReturn [
	| resp |
	resp := self invoke.
	^ resp isFault
		ifTrue: [resp raiseException]
		ifFalse: [resp returnValue]
]

{ #category : #'actions-invoking' }
SoapCall >> invokeAndReturnHandling: handlerBlock [ 
	^ [self invokeAndReturn]
		on: SoapError , SoapImplError
		do: [:ex | handlerBlock value: ex]
]

{ #category : #'actions-invoking' }
SoapCall >> invokeAndReturnWithValue: value [
	 | resp |
	resp := self invokeWithValue: value.
	^resp isFault
		ifTrue: [resp raiseException]
		ifFalse: [resp returnValue]
]

{ #category : #'actions-invoking' }
SoapCall >> invokeAndReturnWithValues: values [
	 | resp |
	resp :=  self invokeWithValues: values.
	^resp isFault
		ifTrue: [resp raiseException]
		ifFalse: [resp returnValue]
]

{ #category : #'actions-invoking' }
SoapCall >> invokeWithHeaderProperties: aHeaderProperties [
	self headerProperties: aHeaderProperties.
	^self invoke
]

{ #category : #'actions-invoking' }
SoapCall >> invokeWithValue: value [
	^self invokeWithValues: (Array with: value)
]

{ #category : #'actions-invoking' }
SoapCall >> invokeWithValues: values [
	"assuming parameters had been added"
	| paramSize |
	paramSize := self parameters size.
	1 to: paramSize do:[:idx | (self parameters at: idx ) value: (values at: idx ifAbsent:[])].
	^self invoke
]

{ #category : #testing }
SoapCall >> isCall [
	^true
]

{ #category : #accessing }
SoapCall >> locator [
	locator isNil ifTrue: [ locator := SoapCallEntry local locator].
	^locator
]

{ #category : #accessing }
SoapCall >> locator: aValue [

	locator := aValue
]

{ #category : #accessing }
SoapCall >> soapAction [
	^self context soapAction
	
]

{ #category : #accessing }
SoapCall >> soapAction: aStringOrSoapAction [
	self context soapAction: aStringOrSoapAction
	
]

{ #category : #accessing }
SoapCall >> targetObjectURI: aString [
	super targetObjectURI: aString.
	
]

{ #category : #actions }
SoapCall >> transport: aSymbol [
	"need to reset connector"
	self connector: nil.
	super transport: aSymbol.
]

{ #category : #accessing }
SoapCall >> useColocation [
	useColocation isNil ifTrue: [ useColocation := false].
	^useColocation
]

{ #category : #accessing }
SoapCall >> useColocation: aBoolean. [
	aBoolean ifTrue: [self connector: nil].
	useColocation := aBoolean 
]

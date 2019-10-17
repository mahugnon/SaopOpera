"
I connect to some server.
My subclasses will know what socket client should be used for connecting right server.

---
MU 10/5/2002 01:35
"
Class {
	#name : #SoapAbstractConnector,
	#superclass : #Object,
	#instVars : [
		'envelopeBuilder'
	],
	#classVars : [
		'ShowLog'
	],
	#category : #'SOAP-Client-Base'
}

{ #category : #'class initialization' }
SoapAbstractConnector class >> initialize [
	"SoapAbstractConnector initialize"
	ShowLog := false.
	
	self initializeAfterLoad
]

{ #category : #'class initialization' }
SoapAbstractConnector class >> initializeAfterLoad [
		
	self name == #SoapAbstractConnector
		ifFalse: [SoapConnectorMap at: self transportName asSymbol put: self].

]

{ #category : #'class initialization' }
SoapAbstractConnector class >> initializeAll [
	"SoapAbstractConnector initializeAll"
	
	self subclassesDo: [:each | each initialize]
]

{ #category : #'class initialization' }
SoapAbstractConnector class >> obsolete [
	self name == #SoapAbstractConnector
		ifFalse: [SoapConnectorMap removeAt: self transportName asSymbol].
	super obsolete
]

{ #category : #setting }
SoapAbstractConnector class >> showLog [
	^ShowLog
]

{ #category : #setting }
SoapAbstractConnector class >> showLog: aBoolean [
	ShowLog := aBoolean
]

{ #category : #constants }
SoapAbstractConnector class >> transportName [
	^#noName
]

{ #category : #actions }
SoapAbstractConnector >> debugReturn: aSoapMessage [ 

	self class showLog
		ifTrue: [
			| envelope context |
			envelope := aSoapMessage envelope.
			context := aSoapMessage context.
			Transcript cr; cr; show: '##'; show: super printString;
						show: ' Client:Return:{'; cr; show: envelope printString; cr; show: '}'.
			Transcript cr; show: '-> with ->'.
			Transcript cr; show: context printString]
]

{ #category : #actions }
SoapAbstractConnector >> debugSend: aSoapEnvelope to: anSoapLocatorObject with: aSoapContext [
	
	self class showLog 
		ifTrue: [Transcript cr; show: '##', super printString, ' Client:Request:{'.
			Transcript cr; show: aSoapEnvelope printString.
			Transcript cr; show: '} to ->'.
			Transcript cr; show: anSoapLocatorObject printString.
			Transcript cr; show: '-> with ->'.
			Transcript cr; show: aSoapContext printString].

]

{ #category : #accessing }
SoapAbstractConnector >> envelopeBuilder [
	envelopeBuilder isNil ifTrue: [envelopeBuilder := SoapEnvelopeBuilder new].
	^envelopeBuilder

]

{ #category : #accessing }
SoapAbstractConnector >> envelopeBuilder: aSoapEnvelopeBuilder [
	envelopeBuilder := aSoapEnvelopeBuilder
]

{ #category : #actions }
SoapAbstractConnector >> send: aSoapEnvelope to: anSoapLocatorObject with: aSoapContext [
	"1. add an addittinal protocolSpecific header to aSoapEnvelope"
	"2. send a SoapMessage to a remote server"
	"3. get the result and unmarshall it"
	"4. return aSoapMessage or nil"
	
	^self subclassResponsibility
]

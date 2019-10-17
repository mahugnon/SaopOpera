Class {
	#name : #SoapLocalRpcConnector,
	#superclass : #SoapAbstractConnector,
	#classInstVars : [
		'debugMode'
	],
	#category : #'SOAP-Client-Base'
}

{ #category : #'class initialization' }
SoapLocalRpcConnector class >> initialize [
	self initializeAfterLoad
]

{ #category : #constants }
SoapLocalRpcConnector class >> transportName [
	^#localRpc
]

{ #category : #actions }
SoapLocalRpcConnector >> send: aSoapEnvelope to: anSoapLocatorObject with: aSoapContext [ 
	| sercviceHandler returnEnv message |
	"ignore the locator and just invoke a local call"
	
	self debugSend: aSoapEnvelope to: anSoapLocatorObject with: aSoapContext.
	
	sercviceHandler := SoapServiceHandler default.
	returnEnv := sercviceHandler dispatch: aSoapEnvelope with: aSoapContext.
	message := SoapMessage envelope: returnEnv.
	self debugReturn: message.
	^message
]

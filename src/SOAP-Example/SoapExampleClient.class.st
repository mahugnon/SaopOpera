"
Simple SOAP client example.

- Call services implemented in SoapExampleServiceImpl

---
mu 1/4/2002 23:05
"
Class {
	#name : #SoapExampleClient,
	#superclass : #Object,
	#classInstVars : [
		'hostAddress',
		'port',
		'transport',
		'targetObjectURI'
	],
	#category : #'SOAP-Example'
}

{ #category : #accessing }
SoapExampleClient class >> hostAddress [
	^hostAddress
]

{ #category : #accessing }
SoapExampleClient class >> hostAddress: aString [
	hostAddress := aString
]

{ #category : #'class initialization' }
SoapExampleClient class >> initialize [
	"SoapExampleClient initialize" 
	hostAddress := 'localhost'.
	port := SoapSetting defaultSendingPort.
	transport := #http.
	targetObjectURI := ''
]

{ #category : #accessing }
SoapExampleClient class >> port [
	^port
]

{ #category : #accessing }
SoapExampleClient class >> port: anInteger [
	port := anInteger
]

{ #category : #accessing }
SoapExampleClient class >> targetObjectURI [
	^targetObjectURI
]

{ #category : #accessing }
SoapExampleClient class >> targetObjectURI: aString [
	targetObjectURI := aString
]

{ #category : #accessing }
SoapExampleClient class >> transport [
	^transport
]

{ #category : #accessing }
SoapExampleClient class >> transport: aSymbol [
	"SoapExampleClient transport: #sqtp"
	"#http or #sqtp"
	transport := aSymbol
]

{ #category : #actions }
SoapExampleClient >> callBrowseClassDefinition: aString [ 
	| call |
	call := (SoapCallEntry tcpHost: self hostAddress port: self port) newCall.
	call transport: self transport.
	call targetObjectURI: self targetObjectURI.
	call methodName: 'browseClassDefinition'.
	call
		addParameterNamed: #className value: aString.
	^call invokeAndReturn asString
]

{ #category : #actions }
SoapExampleClient >> callHelloWorld [	
	| call |
	call := (SoapCallEntry tcpHost: self hostAddress port: self port) newCall.
	call transport: self transport.
	call targetObjectURI: self targetObjectURI.
	call methodName: 'helloWorld'.
	
	^call invokeAndReturn
]

{ #category : #actions }
SoapExampleClient >> callReturnComplexDictionary [
	| call dict |
	call := (SoapCallEntry tcpHost: self hostAddress port: self port) newCall.
	call transport: self transport.
	call targetObjectURI: self targetObjectURI.
	call methodName: 'returnComplexDictionary'.
	dict := Dictionary new.
	dict at: #Java put: 'Forget it'.
	call addParameterNamed: #aDictionary value: dict.
	
	^call invokeAndReturn
]

{ #category : #actions }
SoapExampleClient >> callReverseArray: arrayOfSimpleType [
	| call |
	call := (SoapCallEntry tcpHost: self hostAddress port: self port) newCall.
	call transport: self transport.
	call targetObjectURI: self targetObjectURI.
	call methodName: 'reverseArray'.
	call addParameterNamed: #anArray value: arrayOfSimpleType.
	
	^call invokeAndReturn
]

{ #category : #actions }
SoapExampleClient >> callReverseString: aString [
	| call |
	call := (SoapCallEntry tcpHost: self hostAddress port: self port) newCall.
	call transport: self transport.
	call targetObjectURI: self targetObjectURI.
	call methodName: 'reverseString'.
	call addParameterNamed: #aString value: aString.
	
	^call invokeAndReturn
]

{ #category : #actions }
SoapExampleClient >> callTimeNow [
	| call |
	call := (SoapCallEntry tcpHost: self hostAddress port: self port) newCall.
	call transport: self transport.
	call targetObjectURI: self targetObjectURI.
	call methodName: 'timeNow'.
	
	^call invokeAndReturn
]

{ #category : #actions }
SoapExampleClient >> callTranscriptShow: aString [
	| call |
	call := (SoapCallEntry tcpHost: self hostAddress port: self port) newCall.
	call transport: self transport.
	call targetObjectURI: self targetObjectURI.
	call methodName: 'transcriptShow'.
	call addParameterNamed: #aString value: aString.
	
	^call invokeAndReturn
]

{ #category : #accessing }
SoapExampleClient >> hostAddress [
	^self class hostAddress
]

{ #category : #accessing }
SoapExampleClient >> port [
	^self class port
]

{ #category : #accessing }
SoapExampleClient >> targetObjectURI [
	^self class targetObjectURI
]

{ #category : #accessing }
SoapExampleClient >> transport [
	^self class transport
]

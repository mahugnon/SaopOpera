"
Simple SOAP server example.

- Implements very trivial services. (like just returning 'HelloWorld')

- To register services, see class side.

---
mu 1/4/2002 23:05
"
Class {
	#name : #SoapExampleServiceImpl,
	#superclass : #Object,
	#category : #'SOAP-Example'
}

{ #category : #registering }
SoapExampleServiceImpl class >> inspectRegisteredServices [
	"SoapExampleServiceImpl inspectRegisteredServices"
	SoapServiceHandler default serviceHome inspect
]

{ #category : #registering }
SoapExampleServiceImpl class >> registerAllServices [
	"SoapExampleServiceImpl registerAllServices"
	SoapServerSetup startAll.
	self registerHelloWorld.
	self registerTimeNow.
	self registerReverseString.
	self registerTranscriptShow.
	self registerBrowseClassDefinition.
	self registerReverseArray.
	self registerReturnComplexDictionary
]

{ #category : #private }
SoapExampleServiceImpl class >> registerBrowseClassDefinition [
	| impl serv |
	impl := self new.
	serv := SoapService implementor: impl selector: #browseClassDefinition:.
	serv setSignatureNamed: 'browseClassDefinition' paramNames: #(className).
	SoapServiceHandler default add: serv
]

{ #category : #private }
SoapExampleServiceImpl class >> registerHelloWorld [
	| impl serv |
	impl := self new.
	serv := SoapService implementor: impl selector: #helloWorld.
	serv setSignatureNamed: 'helloWorld'.
	SoapServiceHandler default add: serv
]

{ #category : #private }
SoapExampleServiceImpl class >> registerReturnComplexDictionary [
	| impl serv |
	impl := self new.
	serv := SoapService implementor: impl selector: #returnComplexDictionary:.
	serv setSignatureNamed: 'returnComplexDictionary' paramNames: #(aDictionary).
	SoapServiceHandler default add: serv
]

{ #category : #private }
SoapExampleServiceImpl class >> registerReverseArray [
	| impl serv |
	impl := self new.
	serv := SoapService implementor: impl selector: #reverseArray:.
	serv setSignatureNamed: 'reverseArray' paramNames: #(anArray).
	SoapServiceHandler default add: serv
]

{ #category : #private }
SoapExampleServiceImpl class >> registerReverseString [
	| impl serv |
	impl := self new.
	serv := SoapService implementor: impl selector: #reverseString:.
	serv setSignatureNamed: 'reverseString' paramNames: #(aString).
	SoapServiceHandler default add: serv
]

{ #category : #private }
SoapExampleServiceImpl class >> registerTimeNow [
	| impl serv |
	impl := self new.
	serv := SoapService implementor: impl selector: #timeNow.
	serv setSignatureNamed: 'timeNow'.
	SoapServiceHandler default add: serv
]

{ #category : #private }
SoapExampleServiceImpl class >> registerTranscriptShow [
	| impl serv |
	impl := self new.
	serv := SoapService implementor: impl selector: #transcriptShow:.
	serv setSignatureNamed: 'transcriptShow' paramNames: #(aString).
	SoapServiceHandler default add: serv
]

{ #category : #'server status' }
SoapExampleServiceImpl class >> runningTransportDescriptions [
	"SoapExampleServiceImpl runningTransportDescriptions"
	"Show what transport server(s) is running"
	^SoapServerSetup runningTransportDescriptions
]

{ #category : #actions }
SoapExampleServiceImpl >> browseClassDefinition: aClassName [
	
	| stream targetClass |
	stream := WriteStream on: (String new: 1024).
	targetClass := self class environment at: aClassName asSymbol.
	targetClass fileOutOn: (stream).
	^stream contents asByteArray
	
]

{ #category : #actions }
SoapExampleServiceImpl >> helloWorld [
	^'HelloWorld' 
]

{ #category : #actions }
SoapExampleServiceImpl >> returnComplexDictionary: aDictionary [
	| dictionary |
	dictionary := aDictionary.
	dictionary at: #Smalltlak put: 'Best'.
	dictionary at: #Ruby put: #('Beautiful' 'Need IDE').
	^dictionary
]

{ #category : #actions }
SoapExampleServiceImpl >> reverseArray: anArray [
	Transcript cr; show: 'rev: ', Time now printString.
	^anArray reverse
]

{ #category : #actions }
SoapExampleServiceImpl >> reverseString: aString [
	^aString reverse
]

{ #category : #actions }
SoapExampleServiceImpl >> timeNow [
	^Time now printString
]

{ #category : #actions }
SoapExampleServiceImpl >> transcriptShow: aString [ 
	[Transcript cr; show: '#soap> ' , aString.
	^ true]
		on: Error
		do: [:ex | 
			Transcript cr; show: '#soap> ' , ex description.
			^ false]
]

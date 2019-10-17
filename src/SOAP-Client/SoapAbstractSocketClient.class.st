"
I use some socket to send packets to server. 
My subclasses will know what tranport protocol should be used in that socket.

---
MU 10/5/2002 01:35
"
Class {
	#name : #SoapAbstractSocketClient,
	#superclass : #Object,
	#instVars : [
		'socket',
		'serverAddress',
		'host',
		'port',
		'reqURI'
	],
	#classVars : [
		'HostAddressCache',
		'UseHostAddressCache'
	],
	#classInstVars : [
		'showLog',
		'resolveTimeout',
		'connectionTimeout',
		'connectionPool'
	],
	#category : #'SOAP-Client-Base'
}

{ #category : #accessing }
SoapAbstractSocketClient class >> connectionPool [
	connectionPool isNil ifTrue: [self initConnectionPool].
	^connectionPool
]

{ #category : #setting }
SoapAbstractSocketClient class >> connectionTimeout [
	connectionTimeout isNil ifTrue: [connectionTimeout := 30].
	^connectionTimeout
]

{ #category : #setting }
SoapAbstractSocketClient class >> connectionTimeout: timeout [
	"SoapAbstractSocketClient connectionTimeout: 20"
	connectionTimeout := timeout
]

{ #category : #accessing }
SoapAbstractSocketClient class >> hostAddressCache [
	HostAddressCache isNil ifTrue: [self initHostAddressCache].
	^HostAddressCache
]

{ #category : #'class initialization' }
SoapAbstractSocketClient class >> initConnectionPool [
	connectionPool := IdentityDictionary new
]

{ #category : #'class initialization' }
SoapAbstractSocketClient class >> initHostAddressCache [
	"SoapAbstractSocketClient initHostAddressCache"
	HostAddressCache := Dictionary new.
	HostAddressCache at: 'localhost' put: (ByteArray with: 127 with: 0 with: 0 with: 1)
	
]

{ #category : #'class initialization' }
SoapAbstractSocketClient class >> initialize [
	"SoapAbstractSocketClient initialize"
	showLog := false.
	resolveTimeout := 20.

	self initHostAddressCache.
	self initConnectionPool.
	
	Smalltalk addToStartUpList: self.
	Smalltalk addToShutDownList: self
]

{ #category : #'class initialization' }
SoapAbstractSocketClient class >> obsolete [
	Smalltalk removeFromStartUpList: self.
	Smalltalk removeFromShutDownList: self
]

{ #category : #setting }
SoapAbstractSocketClient class >> resolveTimeout [
	resolveTimeout isNil ifTrue: [resolveTimeout := 20].
	^resolveTimeout
]

{ #category : #setting }
SoapAbstractSocketClient class >> resolveTimeout: timeout [
	"SoapAbstractSocketClient resolveTimeout: 20"
	resolveTimeout := timeout
]

{ #category : #setting }
SoapAbstractSocketClient class >> showLog [
	^showLog
]

{ #category : #setting }
SoapAbstractSocketClient class >> showLog: aBoolean [
	"SoapHttpClient showLog: true"
	"SoapHttpClient showLog: false"
	"SoapSqtpClient showLog: true"
	"SoapSqtpClient showLog: false"
	showLog := aBoolean
]

{ #category : #'start up/shut down' }
SoapAbstractSocketClient class >> shutDown [
	self initHostAddressCache
]

{ #category : #'start up/shut down' }
SoapAbstractSocketClient class >> startUp [
	self initHostAddressCache
]

{ #category : #setting }
SoapAbstractSocketClient class >> useHostAddressCache [
	UseHostAddressCache isNil ifTrue: [UseHostAddressCache := false].
	^UseHostAddressCache
]

{ #category : #setting }
SoapAbstractSocketClient class >> useHostAddressCache: aBoolean [
	"SoapAbstractSocketClient useHostAddressCache: true"
	self initHostAddressCache.
	UseHostAddressCache := aBoolean
]

{ #category : #private }
SoapAbstractSocketClient >> addressForName: hostNameOrIp timeout: timeout [
	| address |
	address :=  [NetNameResolver addressForName: hostNameOrIp timeout: timeout]
				on: NameLookupFailure
				do: [:ex | ex return: nil].
	^address
]

{ #category : #private }
SoapAbstractSocketClient >> cachedAddressFor: hostName [ 
	"utility for fast hostAddress lookup - if not found, just return nil"
	| timeout cache |
	hostName = 'localhost'
		ifTrue: [^ #(127 0 0 1 ) asByteArray].
	timeout := self class resolveTimeout.
	self class useHostAddressCache
		ifFalse: [^self addressForName: hostName timeout: timeout].
	cache := self class hostAddressCache.
	(cache includesKey: hostName)
		ifTrue: [^ cache at: hostName]
		ifFalse: [| resolvedAddress | 
			resolvedAddress := self addressForName: hostName timeout: timeout.
			^ resolvedAddress isNil
				ifFalse: [cache at: hostName put: resolvedAddress]]
]

{ #category : #'actions-hooks' }
SoapAbstractSocketClient >> getResponseContents [
	self subclassResponsibility
]

{ #category : #accessing }
SoapAbstractSocketClient >> host [

	^host
]

{ #category : #accessing }
SoapAbstractSocketClient >> host: aValue [

	host := aValue
]

{ #category : #private }
SoapAbstractSocketClient >> initializeNetwork [
	Socket initializeNetwork.
]

{ #category : #accessing }
SoapAbstractSocketClient >> port [

	^port
]

{ #category : #accessing }
SoapAbstractSocketClient >> port: aValue [

	port := aValue
]

{ #category : #'actions-hooks' }
SoapAbstractSocketClient >> prepareAdditionals [
	"By default - do nothing"
]

{ #category : #'actions-hooks' }
SoapAbstractSocketClient >> prepareEnvelope: soapEnvelope [
	self subclassResponsibility
]

{ #category : #'actions-hooks' }
SoapAbstractSocketClient >> prepareSocket [
	self subclassResponsibility
]

{ #category : #'actions-hooks' }
SoapAbstractSocketClient >> releaseSocket [
	socket destroy.
]

{ #category : #accessing }
SoapAbstractSocketClient >> reqURI [

	^reqURI
]

{ #category : #accessing }
SoapAbstractSocketClient >> reqURI: aValue [

	reqURI := aValue
]

{ #category : #private }
SoapAbstractSocketClient >> resolveServerAddress [
	serverAddress := self cachedAddressFor: host.
	serverAddress isNil
		ifTrue: [self class useHostAddressCache
				ifTrue: [self class hostAddressCache
						removeKey: host
						ifAbsent: []].
			SoapCannotResolveServer signal: 'Could not resolve the server named: ' , host]
]

{ #category : #actions }
SoapAbstractSocketClient >> send: soapEnvelope [ 
	
	^ ZnClient new post: ('http://' , host, reqURI)  contents: (self prepareEnvelope: soapEnvelope). 
	"| cont |
	cont := nil.
	self prepareEnvelope: soapEnvelope.
	self prepareHeader.
	self initializeNetwork.
	self resolveServerAddress.
	[self prepareSocket.
	self sendBySocket. 
	cont := self getResponseContents]
		ensure: [self releaseSocket].
	^ cont"
]

{ #category : #'actions-hooks' }
SoapAbstractSocketClient >> sendBySocket [
	self subclassResponsibility
]

{ #category : #accessing }
SoapAbstractSocketClient >> socket [

	^socket
]

{ #category : #accessing }
SoapAbstractSocketClient >> socket: aValue [

	socket := aValue
]

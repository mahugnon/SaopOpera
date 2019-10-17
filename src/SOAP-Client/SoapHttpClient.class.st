Class {
	#name : #SoapHttpClient,
	#superclass : #SoapAbstractSocketClient,
	#instVars : [
		'specifiedServer',
		'soapEnvelopeString',
		'headerString',
		'bodyString',
		'contents',
		'soapAction',
		'proxyPort',
		'proxyServer'
	],
	#classVars : [
		'CrLf'
	],
	#category : #'SOAP-Client-Http'
}

{ #category : #constants }
SoapHttpClient class >> defaultPort [
	"default port to connect on"
	^80
]

{ #category : #'instance creation' }
SoapHttpClient class >> host: hostnameString page: pageString [
	^ self host: hostnameString port: self defaultPort page: pageString
]

{ #category : #'instance creation' }
SoapHttpClient class >> host: hostnameString port: portNumberInteger page: pageString [ 
	
	^ self new
		host: hostnameString
		port: portNumberInteger
		page: pageString
]

{ #category : #'class initialization' }
SoapHttpClient class >> initialize [
	"SoapHttpClient initialize"
	showLog := false.

	CrLf := String with: Character cr with: Character lf.
	
	
]

{ #category : #accessing }
SoapHttpClient class >> proxyPort [
	(NetworkSystemSettings httpProxyPort) ifNil: [^HTTPSocket classPool at: #HTTPProxyPort]. "3.8 before"
	
	^NetworkSystemSettings httpProxyPort
]

{ #category : #accessing }
SoapHttpClient class >> proxyServer [
	(NetworkSystemSettings httpProxyServer) ifNil: [^HTTPSocket classPool at: #HTTPProxyServer]. "3.8 before"
	
	^(NetworkSystemSettings httpProxyServer) ifEmpty: [nil]
]

{ #category : #'instance creation' }
SoapHttpClient class >> url: urlString [
	^self new parseURL: urlString
]

{ #category : #constants }
SoapHttpClient >> defaultPort [
	^self class defaultPort
]

{ #category : #'actions-hooks' }
SoapHttpClient >> getResponseContents [
	
	| list header firstData length aStream responseCode responseCodeKind type |
	list := socket getResponseUpTo: CrLf, CrLf ignoring: (String with: Character cr).	"list = header, CrLf, CrLf, beginningOfData"
	header := list at: 1.
	firstData := list at: 3.
	(socket isConnected not and: [header isEmpty]) ifTrue: [SoapCannotConnectToServer signal: 'Server does not respond - ''host: ', host , ' port: ', port printString].
	
	self class showLog ifTrue: [Transcript cr; cr; show: 'Got following header response:'; 	cr; show: header.].

	"dig out some headers"
	socket header: header.
	length := socket getHeader: 'content-length'.
	length ifNotNil: [ length := length asNumber ].
	aStream := socket getRestOfBuffer: firstData totalLength: length.
	contents := aStream contents.
	
	responseCode := socket responseCode.
	responseCodeKind := responseCode first.
	responseCodeKind = $3 ifTrue: [^self redirectWith: responseCode].
	(responseCodeKind = $4 or: [responseCodeKind = $5]) ifTrue: [socket destroy. ^self signalHttpErrorWith: responseCode].
	
	type := socket getHeader: 'content-type'.
	type isNil ifTrue: [type := ''].
	(((type beginsWith: 'text/xml') not) and: [responseCodeKind = $2]) 
		ifTrue: [socket destroy. ^SoapContentTypeMismatch signal: 'Wrong type: ', type ,' It should be text/xml'].

	^contents 
]

{ #category : #'initialize-release' }
SoapHttpClient >> host: hostnameString port: portNumberInteger page: pageString [ 
	
	host := hostnameString.
	port := portNumberInteger.
	reqURI := (pageString isNil
					or: [pageString isEmpty])
				ifTrue: ['/']
				ifFalse: [pageString].
	

	specifiedServer := host , ':' , port printString.
	self proxyServer
		ifNotNil: [reqURI := 'http://' , host , ':' , port printString , reqURI.
			"put back together"
			host := self proxyServer.
			port := self proxyPort]
]

{ #category : #'initialize-release' }
SoapHttpClient >> parseURL: anUrlString [ 
	| url bare frm |
	url := anUrlString.
	bare := (url asLowercase beginsWith: 'http://')
				ifTrue: [url copyFrom: 8 to: url size]
				ifFalse: [url].
	host := bare copyUpTo: $/.
	specifiedServer := host.
	(host includes: $:)
		ifTrue: [port := (host copyFrom: (host indexOf: $:)
							+ 1 to: host size) asNumber.
			host := host copyUpTo: $:]
		ifFalse: [port := self defaultPort].
	(frm := (bare indexOf: $/) ) = 0 ifTrue:[frm := 1].
	reqURI := bare
				copyFrom: frm
				to: bare size.
	(reqURI size = 0 or: [reqURI = specifiedServer])
		ifTrue: [reqURI := '/'].
	self proxyServer
		ifNotNil: [reqURI := 'http://' , host , ':' , port printString , reqURI.
			"put back together"
			host := self proxyServer.
			port := self proxyPort]
]

{ #category : #'actions-hooks' }
SoapHttpClient >> prepareAdditionalsOn: aStream [
	
	"do nothing by default"
]

{ #category : #'actions-hooks' }
SoapHttpClient >> prepareEnvelope: soapEnvelopeOrString [
	
	soapEnvelopeString := soapEnvelopeOrString isString ifTrue: [ soapEnvelopeOrString ] ifFalse: [soapEnvelopeOrString printXmlString].
	
	bodyString := SoXmlUtil contentsWithXmlDeclaration: soapEnvelopeString.
	
	^ bodyString
	
]

{ #category : #'actions-hooks' }
SoapHttpClient >> prepareHeader [
	headerString := String
				streamContents: [:str | 
					str nextPutAll: 'POST ' , reqURI , ' HTTP/1.0';
						 nextPutAll: CrLf.
					str nextPutAll: 'Host: ' , specifiedServer;
						 nextPutAll: CrLf.
					str nextPutAll: 'User-Agent: ', SystemVersion current version;
						 nextPutAll: CrLf.
					str nextPutAll: 'Content-length: ' , (bodyString size - 1) printString;
						 nextPutAll: CrLf.
					str nextPutAll: 'Content-type: text/xml; charset="', SoapSetting stringEncoding, '"';
						 nextPutAll: CrLf.
					str nextPutAll: self soapAction printString;
						 nextPutAll: CrLf.
					self prepareAdditionalsOn: str].
	self class showLog
		ifTrue: [Transcript cr; cr; show: 'Sending following header:'; cr; show: headerString]
]

{ #category : #'actions-hooks' }
SoapHttpClient >> prepareSocket [
	[socket := HTTPSocket new.
	socket connectTo: serverAddress port: port.
	socket
		waitForConnectionUntil: (Socket deadlineSecs: self class connectionTimeout).
	] on: ConnectionTimedOut do:[SoapCannotConnectToServer signal: 'Server does not respond - ''host: ' , host , ' port: ' , port printString]
]

{ #category : #accessing }
SoapHttpClient >> proxyPort [

	proxyPort isNil ifTrue: [proxyPort := self class proxyPort].
	^proxyPort
]

{ #category : #accessing }
SoapHttpClient >> proxyServer [

	proxyServer isNil ifTrue: [proxyServer := self class proxyServer].
	^proxyServer
]

{ #category : #private }
SoapHttpClient >> redirectWith: responseCode [
	| newUrl |
	newUrl := socket getHeader: 'location'.
	socket destroy.
	newUrl
		ifNotNil: [self class showLog
				ifTrue: [Transcript show: ' redirecting to: ' , newUrl].
			^ (self class url: newUrl)
				send: soapEnvelopeString
				action: soapAction].
	
	^SoapHttpGenericError signal: 'failed to redirect by no ''location'' header' code: responseCode contents: contents
]

{ #category : #actions }
SoapHttpClient >> send: soapEnvelopeOrSrting action: aSoapAction [ 
	| return |
	self soapAction: aSoapAction.
	return := self send: soapEnvelopeOrSrting.
	^SoPortableUtil convertString: return from: SoapSetting stringEncoding.
	
]

{ #category : #'actions-hooks' }
SoapHttpClient >> sendBySocket [

	socket sendData: headerString.
	socket sendData: bodyString 
]

{ #category : #private }
SoapHttpClient >> signalHttpErrorWith: responseCode [

	^SoapHttpGenericError signal: '' code: responseCode contents: contents
]

{ #category : #accessing }
SoapHttpClient >> soapAction [
	soapAction isNil ifTrue: [soapAction := SoapAction noIntent].
	^soapAction
]

{ #category : #accessing }
SoapHttpClient >> soapAction: aValue [

	soapAction := aValue
]

{ #category : #accessing }
SoapHttpClient >> specifiedServer [

	^specifiedServer
]

{ #category : #accessing }
SoapHttpClient >> specifiedServer: aValue [

	specifiedServer := aValue
]

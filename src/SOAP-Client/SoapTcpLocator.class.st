Class {
	#name : #SoapTcpLocator,
	#superclass : #Object,
	#instVars : [
		'host',
		'port'
	],
	#classInstVars : [
		'localAddress',
		'localHost'
	],
	#category : #'SOAP-Client-Base'
}

{ #category : #'instance creation' }
SoapTcpLocator class >> host: hostnameString port: portNumberInteger [
	^self new host: hostnameString; port: portNumberInteger
]

{ #category : #private }
SoapTcpLocator class >> initLocalInfo [
	localAddress := localHost := nil.
	
]

{ #category : #'class initialization' }
SoapTcpLocator class >> initialize [
	"SoapTcpLocator initialize"

	Smalltalk addToStartUpList: self.
	
	self startUp
	
]

{ #category : #colocation }
SoapTcpLocator class >> isLocal: hostOrIp port: portNum [ 
	"Squeak specific"
	| setup |
	SoapConfigurationMap isServerInstalled
		ifFalse: [^ false].
	setup := self serverSetup.
	setup
		ifNil: [^ false].
	^ (setup runningPorts includes: portNum)
		and: [((hostOrIp = 'localhost'
						or: [hostOrIp = '127.0.0.1'])
					or: [hostOrIp = self localAddress])
				or: [hostOrIp = self localHost]]
]

{ #category : #private }
SoapTcpLocator class >> localAddress [
	"Squeak specific"
	localAddress isNil ifTrue: [localAddress := NetNameResolver localAddressString].
	^localAddress
]

{ #category : #private }
SoapTcpLocator class >> localHost [
	"Squeak specific"
	localHost isNil
		ifTrue: [[localHost := NetNameResolver nameForAddress: NetNameResolver localHostAddress timeout: 30]
				on: Error
				do: [:ex | 
					localHost := 'localhost'.
					ex return]].
	^ localHost
]

{ #category : #'class initialization' }
SoapTcpLocator class >> obsolete [
	"SoapTcpLocator obsolete"

	Smalltalk removeFromStartUpList: self.
	
]

{ #category : #colocation }
SoapTcpLocator class >> serverSetup [
	^ Smalltalk
		at: #SoapServerSetup
		ifAbsent: []
]

{ #category : #'system startup' }
SoapTcpLocator class >> startUp [
	self initLocalInfo.
]

{ #category : #testing }
SoapTcpLocator >> colocated [
	^self class isLocal: host port: port 
]

{ #category : #testing }
SoapTcpLocator >> colocatedFor: transportSymbol [
	| runningPort |
	self colocated ifFalse: [^false].
	runningPort := self class serverSetup runningPortAt: transportSymbol.
	^runningPort = self port
]

{ #category : #accessing }
SoapTcpLocator >> host [

	^host
]

{ #category : #accessing }
SoapTcpLocator >> host: hostnameOrIpAddressString [

	host := hostnameOrIpAddressString asLowercase
]

{ #category : #accessing }
SoapTcpLocator >> port [

	^port
]

{ #category : #accessing }
SoapTcpLocator >> port: aValue [

	port := aValue
]

{ #category : #printing }
SoapTcpLocator >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' host: '.
	aStream print: self host.
	aStream nextPutAll: ' port: '.
	aStream print: self port.
]

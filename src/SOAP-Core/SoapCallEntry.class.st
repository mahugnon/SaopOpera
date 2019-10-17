"
I represent a SOAP RPC access point.

---
MU 5/12/2002 00:47
"
Class {
	#name : #SoapCallEntry,
	#superclass : #Object,
	#instVars : [
		'locator'
	],
	#classInstVars : [
		'defaultSendingPort'
	],
	#category : #'SOAP-Core-RPC'
}

{ #category : #accessing }
SoapCallEntry class >> defaultSendingPort [
	^defaultSendingPort
]

{ #category : #accessing }
SoapCallEntry class >> defaultSendingPort: portNumber [
	defaultSendingPort := portNumber
]

{ #category : #'class initialization' }
SoapCallEntry class >> initialize [
	"SoapCallEntry initialize"
	defaultSendingPort := 8823
]

{ #category : #'instance creation' }
SoapCallEntry class >> local [
	^self tcpHost: 'localhost' port: self defaultSendingPort 
	
]

{ #category : #'instance creation' }
SoapCallEntry class >> local: portNumberInteger [
	^ self new
		locator: (SoapTcpLocator host: 'localhost' port: portNumberInteger)
]

{ #category : #'instance creation' }
SoapCallEntry class >> tcpHost: hostnameString [
	^self tcpHost: hostnameString port: self defaultSendingPort
]

{ #category : #'instance creation' }
SoapCallEntry class >> tcpHost: hostnameString port: portNumberInteger [
	"In many cases, these values are used for setting router server URI" 
	^ self new
		locator: (SoapTcpLocator host: hostnameString port: portNumberInteger)
]

{ #category : #accessing }
SoapCallEntry >> locator [

	^locator
]

{ #category : #accessing }
SoapCallEntry >> locator: aValue [

	locator := aValue
]

{ #category : #actions }
SoapCallEntry >> newCall [
	^SoapCall locator: (self locator)
]

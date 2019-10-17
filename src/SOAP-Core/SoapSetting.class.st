"
Facade for setting SOAP related parameters

---
mu 1/4/2002 22:51
"
Class {
	#name : #SoapSetting,
	#superclass : #Object,
	#classInstVars : [
		'defaultTransport'
	],
	#category : #'SOAP-Core-Base'
}

{ #category : #'transport setting' }
SoapSetting class >> connectionTimeout [
	^SoapAbstractSocketClient connectionTimeout
]

{ #category : #'transport setting' }
SoapSetting class >> connectionTimeout: timeout [
	"SoapSetting connectionTimeout: 20"
	SoapAbstractSocketClient connectionTimeout: timeout
]

{ #category : #'server setting' }
SoapSetting class >> defaultPort [
	"SoapSetting defaultPort"
	^SoapServerSetup defaultPortAt: (self defaultTransport)
]

{ #category : #'server setting' }
SoapSetting class >> defaultPort: anInteger [ 
	SoapServerSetup defaultPortAt: self defaultTransport put: anInteger.
	"Should I restart here?"
	self restart
]

{ #category : #'server setting' }
SoapSetting class >> defaultPortAt: tranportName [
	"SoapSetting defaultPortAt: #http"
	^SoapServerSetup defaultPortAt: tranportName
]

{ #category : #'server setting' }
SoapSetting class >> defaultPortAt: tranportName put: portNumber [
	"SoapSetting defaultPortAt: #http put: 8824"
	^SoapServerSetup defaultPortAt: tranportName put: portNumber
]

{ #category : #'client setting' }
SoapSetting class >> defaultSendingPort [
	"SoapSetting defaultSendingPort"
	^SoapCallEntry defaultSendingPort
]

{ #category : #'client setting' }
SoapSetting class >> defaultSendingPort: portNumber [
	"SoapSetting defaultSendingPort: 8823"
	^SoapCallEntry defaultSendingPort: portNumber
]

{ #category : #'transport setting' }
SoapSetting class >> defaultTransport [
	defaultTransport isNil ifTrue: [defaultTransport := #http].
	^defaultTransport
]

{ #category : #'transport setting' }
SoapSetting class >> defaultTransport: aSymbol [ 
	defaultTransport := aSymbol
]

{ #category : #'class initialization' }
SoapSetting class >> initialize [
	"SoapSetting initialize"
	defaultTransport := #http
]

{ #category : #'transport setting' }
SoapSetting class >> resolveTimeout [
	^SoapAbstractSocketClient resolveTimeout
]

{ #category : #'transport setting' }
SoapSetting class >> resolveTimeout: timeout [
	"SoapSetting resolveTimeout: 20"
	SoapAbstractSocketClient resolveTimeout: timeout
]

{ #category : #'server setting' }
SoapSetting class >> restart [
	SoapServerSetup startAll
]

{ #category : #'log setting' }
SoapSetting class >> showClientLog: aBoolean [
	"SoapSetting showClientLog: true"
	"SoapSetting showClientLog: false"
	SoapAbstractConnector showLog: aBoolean.
	
]

{ #category : #'log setting' }
SoapSetting class >> showClientLogHttpLevel: aBoolean [
	"SoapSetting showClientLogHttpLevel: true"
	"SoapSetting showClientLogHttpLevel: false"
	SoapHttpClient showLog: aBoolean.
	
]

{ #category : #'log setting' }
SoapSetting class >> showServerLog: aBoolean [ 
	"SoapSetting showServerLog: true"
	"SoapSetting showServerLog: false"
	Smalltalk at: #SoapHttpModule ifPresent: [:cls | cls showLog: aBoolean].
	Smalltalk at: #SoapSqtpHandler ifPresent: [:cls | cls showLog: aBoolean].
	
]

{ #category : #'log setting' }
SoapSetting class >> showingClientLog [
	"SoapSetting showingClientLog"
	^SoapAbstractConnector showLog
]

{ #category : #'log setting' }
SoapSetting class >> showingClientLogHttpLevel [
	"SoapSetting showingClientLogHttpLevel"
	^SoapHttpClient showLog
	
]

{ #category : #'log setting' }
SoapSetting class >> showingServerLog [
	"SoapSetting showingServerLog"
	| results |
	results := OrderedCollection new.
	results add: (Smalltalk at: #SoapHttpModule ifPresent: [:cls | cls showLog]). 
	results add: (Smalltalk at: #SoapSqtpHandler ifPresent: [:cls | cls showLog]).
	^results includesAnyOf: (Array with: true with: nil)
	


]

{ #category : #'encoding setting' }
SoapSetting class >> stringEncoding [
	^SoXmlUtil stringEncoding
]

{ #category : #'encoding setting' }
SoapSetting class >> stringEncoding: aString [
	SoXmlUtil stringEncoding: aString
]

{ #category : #'transport setting' }
SoapSetting class >> useHostAddressCache [
	^SoapAbstractSocketClient useHostAddressCache
]

{ #category : #'transport setting' }
SoapSetting class >> useHostAddressCache: aBoolean [
	"SoapSetting useHostAddressCache: true"
	"SoapSetting useHostAddressCache: false"
	SoapAbstractSocketClient useHostAddressCache: aBoolean
	
]

{ #category : #'encoding setting' }
SoapSetting class >> useSchemaDatatypes1999 [
	SoXmlConstants xsiURI: 'http://www.w3.org/1999/XMLSchema'.
	SoXmlConstants xsiURI: 'http://www.w3.org/1999/XMLSchema-instance'.
	
	
]

{ #category : #'encoding setting' }
SoapSetting class >> useSchemaDatatypes2001 [
	SoXmlConstants xsiURI: 'http://www.w3.org/2001/XMLSchema'.
	SoXmlConstants xsiURI: 'http://www.w3.org/2001/XMLSchema-instance'.
	
	
]

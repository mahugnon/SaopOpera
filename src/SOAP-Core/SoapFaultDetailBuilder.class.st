Class {
	#name : #SoapFaultDetailBuilder,
	#superclass : #Object,
	#classVars : [
		'DefaultNamespace',
		'DefaultPrefix'
	],
	#category : #'SOAP-Core-Base'
}

{ #category : #accessing }
SoapFaultDetailBuilder class >> defaultNamespace [
	DefaultNamespace isNil
		ifTrue: [DefaultNamespace := 'http://www.mars.dti.ne.jp/~umejava/smalltalk/soapOpera/error/'].
	^ DefaultNamespace
]

{ #category : #accessing }
SoapFaultDetailBuilder class >> defaultNamespace: aString [
	DefaultNamespace := aString
]

{ #category : #accessing }
SoapFaultDetailBuilder class >> defaultPrefix [
	DefaultPrefix isNil
		ifTrue: [DefaultPrefix := 'e'].
	^ DefaultPrefix

]

{ #category : #accessing }
SoapFaultDetailBuilder class >> defaultPrefix: aString [
	DefaultPrefix := aString
]

{ #category : #'class initialization' }
SoapFaultDetailBuilder class >> initialize [
	"SoapFaultDetailBuilder initialize"
	DefaultPrefix := DefaultNamespace := nil
]

{ #category : #actions }
SoapFaultDetailBuilder >> buildSoapFaultDetailOn: aSoapFault from: anError [ 
	| errorPrefix details stErrorClass isResumable messageText stack detail |
	aSoapFault faultstring: anError description.
	errorPrefix := self class defaultPrefix.
	details := SoapWrapElement named: 'details' withPrefix: errorPrefix.
	details declareNamespace: errorPrefix uri: self class defaultNamespace.
	stErrorClass := details createChildNamed: 'ErrorClass'.
	stErrorClass value: anError class name.
	isResumable := details createChildNamed: 'isResumable'.
	isResumable value: anError isResumable printString.
	anError messageText isNil
		ifFalse: [messageText := details createChildNamed: 'messageText'.
			messageText value: anError messageText].
	stack := details createChildNamed: 'stack'.
	stack value: (SoPortableUtil stackTraceFrom: anError).
	detail := aSoapFault addDetail.
	detail addSubElement: details.
	^ detail
]

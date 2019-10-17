Class {
	#name : #SoapExceptionBuilder,
	#superclass : #Object,
	#category : #'SOAP-Core-RPC'
}

{ #category : #actions }
SoapExceptionBuilder >> buildExceptionFrom: aSoapFault [ 
	| exception |
	aSoapFault detail isNil
		ifTrue: [exception := SoapError fromSoapFault: aSoapFault]
		ifFalse: [| exceptionDetail errorClassTag exceptionClassName messageText | 
			exceptionDetail := aSoapFault detail subElements ifNotEmpty: [:elem | elem first].
			errorClassTag := exceptionDetail ifNotNil: [:elem | elem findChildNamed: 'ErrorClass'].
			exceptionClassName := errorClassTag isNil
						ifTrue: ['Error']
						ifFalse: [errorClassTag value].
			exception := (Smalltalk
						at: exceptionClassName asSymbol
						ifAbsent: [SoapNoSuchExceptionClass signal: exceptionClassName]) new.
			messageText := exceptionDetail ifNotNil: [:elem | elem findChildNamed: 'messageText'].
			exception
				messageText: (messageText isNil
						ifTrue: [aSoapFault faultstring]
						ifFalse: [messageText value])].
	exception tag: '<<signaled in server>>'.
	"Should I use tag?"
	^ exception
]

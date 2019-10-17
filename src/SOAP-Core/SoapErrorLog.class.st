"
Write original error to a log file. 

---
mu 1/4/2002 22:51
"
Class {
	#name : #SoapErrorLog,
	#superclass : #Object,
	#category : #'SOAP-Core-Base'
}

{ #category : #actions }
SoapErrorLog class >> write: anError [ 
	| ex file stack |
	ex := anError.
	file := FileStream fileNamed: 'soapError.log'.
	file isNil ifTrue: [Transcript cr; show: 'File open failed in SoapErrorLog'. ^self].
	file setToEnd.
	file cr; nextPutAll: '### Original Error is... ###'.
	file cr; nextPutAll: TimeStamp current printString.
	file cr; nextPutAll: '#Receiver: ' , ex receiver printString.
	file cr; nextPutAll: '#Description: ' , ex description.
	stack := SoPortableUtil stackTraceFrom: ex.
	file cr; nextPutAll: '#Stack:'.
	file cr; cr; nextPutAll: stack.
	file close
]

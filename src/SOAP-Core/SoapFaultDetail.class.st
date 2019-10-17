"
SOAP Fault Detail element.


---
mu 5/21/2001 22:24
"
Class {
	#name : #SoapFaultDetail,
	#superclass : #SoapElement,
	#category : #'SOAP-Core-Elements'
}

{ #category : #constants }
SoapFaultDetail class >> localName [
	^'detail'
]

{ #category : #'instance creation' }
SoapFaultDetail class >> named: anElementName [ 
	"No namespace prefix check"
	^ self new name: anElementName
]

{ #category : #'initialize-release' }
SoapFaultDetail >> initialize [
	super initialize.
	name := self class localName
]

{ #category : #testing }
SoapFaultDetail >> isFaultDetail [
	^true
]

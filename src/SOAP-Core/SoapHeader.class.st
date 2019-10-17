"
SOAP Header element.


---
mu 5/21/2001 22:24
"
Class {
	#name : #SoapHeader,
	#superclass : #SoapElement,
	#instVars : [
		'headerEntries'
	],
	#category : #'SOAP-Core-Elements'
}

{ #category : #constants }
SoapHeader class >> localName [
	^'Header'
]

{ #category : #actions }
SoapHeader >> addHeaderEntry: anXmlElement [
	"anXmlElement mustUnderstand:
		#printXmlOn:aStream
		#parent: anXmlElement"
	anXmlElement parent: self.
	^self headerEntries add: anXmlElement.
]

{ #category : #actions }
SoapHeader >> disableMustUnderstand [
	self putAttributeNamed: SoapConstants soapEnvPrefixColon, SoapConstants mustUnderstand value: '0'
]

{ #category : #actions }
SoapHeader >> enableMustUnderstand [
	self putAttributeNamed: SoapConstants soapEnvPrefixColon, SoapConstants mustUnderstand value: '1'
]

{ #category : #elements }
SoapHeader >> headerEntries [
	headerEntries isNil ifTrue: [headerEntries := OrderedCollection new].
	^headerEntries
]

{ #category : #elements }
SoapHeader >> headerEntries: aCollectionOfXmlElement [
	headerEntries := aCollectionOfXmlElement
]

{ #category : #testing }
SoapHeader >> isHeader [
	^true
]

{ #category : #actions }
SoapHeader >> isMustUnderstandEnabled [
	^(self getAttributeNamed: SoapConstants soapEnvPrefixColon, SoapConstants mustUnderstand ) = '1'
]

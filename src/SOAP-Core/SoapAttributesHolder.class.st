"
A Container for XML attributes.


---
mu 5/21/2001 22:24
"
Class {
	#name : #SoapAttributesHolder,
	#superclass : #SoXmlAttributesHolder,
	#instVars : [
		'encodingStyle'
	],
	#category : #'SOAP-Core-Base'
}

{ #category : #accessing }
SoapAttributesHolder >> encodingStyle [
	^encodingStyle
]

{ #category : #accessing }
SoapAttributesHolder >> encodingStyle: aString [
	encodingStyle := aString
]

{ #category : #actions }
SoapAttributesHolder >> putAttributeNamed: attribName value: attribValue [
	| encs |
	"ToDo: take a more serious approach...Namespace conscious"
	encs := SoapConstants encodingStyle.
	('*:', encs match: attribName) ifTrue: [self encodingStyle: attribValue].
	super putAttributeNamed: attribName value: attribValue.
	
]

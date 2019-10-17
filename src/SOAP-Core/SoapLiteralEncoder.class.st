"
I will do SOAP ""literal' encoding. 
---
MU 3/31/2007 16:17
"
Class {
	#name : #SoapLiteralEncoder,
	#superclass : #SoapStandardEncoder,
	#category : #'SOAP-Core-Encoding'
}

{ #category : #actions }
SoapLiteralEncoder >> encodeSoapVariable: aSoapVariable [ 
	| type elem |
	type := aSoapVariable value class name.
	(type == #Dictionary
			or: [type == #IdentityDictionary])
		ifTrue: [^ self encodeDictionarySoapVariable: aSoapVariable].
	type == #SoapEncStruct
		ifTrue: [^ self encodeStructSoapVariable: aSoapVariable].
	self complexTypeDict
		at: type
		ifPresent: [:p | ^ self encodeStructSoapVariable: (aSoapVariable
					value: (SoapEncStruct from: aSoapVariable value);
					 yourself)].
	elem := self xmlElementClass named: aSoapVariable name.
	self setXmlAttributesFrom: aSoapVariable into: elem.
	self setXmlElementValue: aSoapVariable into: elem.
	^ elem
]

{ #category : #testing }
SoapLiteralEncoder >> isLiteralEncoder [
	^true
]

"
I will do Squeak specific encoding for SOAP, using ReferenceStream.
Note that I am only one of the eocodings for SOAP.

---
MU 10/5/2002 01:32
"
Class {
	#name : #SoapSqEncoder,
	#superclass : #SoapAbstractEncoder,
	#category : #'SOAP-Core-Encoding'
}

{ #category : #defaults }
SoapSqEncoder >> defaultObjectEncoderClass [
	^ReferenceStream
]

{ #category : #private }
SoapSqEncoder >> encodeNilSoapVariable: aSoapVariable [ 
	| elem |
	elem := self xmlElementClass emptyNamed: aSoapVariable name.
	elem putAttributeNamed: SoapConstants xsiPrefixColon , 'null' value: 1.
	^elem
]

{ #category : #private }
SoapSqEncoder >> encodeObjectSoapVariable: aSoapVariable [
	| val  valStr elem |
	val := aSoapVariable value.
	valStr := self stringFromObject: val.
	elem := self xmlElementClass named: aSoapVariable name.
	elem putAttributeNamed: (SoapConstants xsiType) value: (SoapConstants sqEncPrefixColon, self defaultObjectEncoderClass name).
	elem value: valStr.
	^elem
]

{ #category : #actions }
SoapSqEncoder >> encodeSoapVariable: aSoapVariable [
	| val type xsiTypeAttVal elem |
	val := aSoapVariable value.
	val isNil ifTrue:[^self encodeNilSoapVariable: aSoapVariable ].
	type := aSoapVariable type.
	type isNil ifTrue:[type := val class name].
	xsiTypeAttVal := self typeDict at: type ifAbsent:[ ^self encodeObjectSoapVariable: aSoapVariable].
	elem := self xmlElementClass named: aSoapVariable name.
	elem putAttributeNamed: (SoapConstants xsiType) value: xsiTypeAttVal.
	elem value: aSoapVariable value.
	^elem
]

{ #category : #private }
SoapSqEncoder >> stringFromObject: anObject [
	| file con |
	file := RWBinaryOrTextStream
				on: (ByteArray new: 5000).
	file binary.
	(self defaultObjectEncoderClass on: file)
		nextPut: anObject.
	con := Base64MimeConverter mimeEncode: file reset.
	file close.
	^ con contents
	
]

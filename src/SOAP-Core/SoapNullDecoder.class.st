Class {
	#name : #SoapNullDecoder,
	#superclass : #SoapAbstractDecoder,
	#category : #'SOAP-Core-Decoding'
}

{ #category : #actions }
SoapNullDecoder >> decodeXmlElement: aSoapWrapElement [

	^aSoapWrapElement value
]

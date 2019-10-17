Class {
	#name : #SoapDecoderFactory,
	#superclass : #SoapDataBindingFactory,
	#category : #'SOAP-Core-Decoding'
}

{ #category : #'default values' }
SoapDecoderFactory class >> initDataBindingDict [
	self dataBindingDict at: SoapConstants nullEncURI put: SoapNullDecoder.
	self dataBindingDict at: SoapConstants soapEncURI put: SoapDecoder.
	self dataBindingDict at: SoapConstants soapSqEncURI put: SoapSqDecoder.
]

{ #category : #'accessing-error' }
SoapDecoderFactory class >> noSuchDataBinder [
	^SoapNoSuchDecoder
	
]

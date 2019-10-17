Class {
	#name : #SoapEncoderFactory,
	#superclass : #SoapDataBindingFactory,
	#category : #'SOAP-Core-Encoding'
}

{ #category : #'default values' }
SoapEncoderFactory class >> initDataBindingDict [
	self dataBindingDict at: SoapConstants nullEncURI put: SoapNullEncoder.
	self dataBindingDict at: SoapConstants soapEncURI put: SoapEncoder.
	self dataBindingDict at: SoapConstants soapSqEncURI put: SoapSqEncoder.
]

{ #category : #'accessing-error' }
SoapEncoderFactory class >> noSuchDataBinder [
	^SoapNoSuchEncoder
	
]

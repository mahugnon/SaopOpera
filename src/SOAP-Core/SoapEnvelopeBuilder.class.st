Class {
	#name : #SoapEnvelopeBuilder,
	#superclass : #Object,
	#category : #'SOAP-Core-Base'
}

{ #category : #actions }
SoapEnvelopeBuilder >> buildClientSoapFaultEnvelope: anError [ 
	| env fault builder |
	env := SoapEnvelope new.
	fault := env addBody addFault client.
	builder := SoapFaultDetailBuilder new.
	builder buildSoapFaultDetailOn: fault from: anError.
	^ env
]

{ #category : #actions }
SoapEnvelopeBuilder >> buildServerSoapFaultEnvelope: anError [ 
	| env fault builder |
	env := SoapEnvelope new.
	fault := env addBody addFault server.
	builder := SoapFaultDetailBuilder new.
	builder buildSoapFaultDetailOn: fault from: anError.
	^ env
]

{ #category : #actions }
SoapEnvelopeBuilder >> buildSoapEnvelopeFromXmlString: anXmlString [ 
	[| elem envelope | 
	elem := SoapWrapElement fromXml: anXmlString.
	envelope :=  SoapEnvelope fromXmlElement: elem.
	envelope declareTypicalNamespaces.
	^envelope]
		on: Error
		do: [:ex | ^ self buildServerSoapFaultEnvelope: ex]
]

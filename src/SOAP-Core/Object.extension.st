Extension { #name : #Object }

{ #category : #'*soap-core' }
Object >> asXmlElement: aSoapVariable [

	^self asXmlElement: aSoapVariable with: nil
]

{ #category : #'*soap-core' }
Object >> asXmlElement: aSoapVariable with: aSoapEncoder [
	"Return a SoapWrapElement from aSoapVariable"
	"This is only useful for customized Soap encoding"

	^self
]

{ #category : #'*soap-core' }
Object class >> fromXmlElement: aSoapXmlElement [ 
	^self fromXmlElement: aSoapXmlElement with: nil
]

{ #category : #'*soap-core' }
Object class >> fromXmlElement: aSoapXmlElement with: aSoapDecoder [
	"Conrtol all deserialization from SoapWrapElement"
	"This is only useful for customized Soap encoding"

	^self new
]

{ #category : #'*soap-core' }
Object >> soapIdKey [
	^self identityHash
]

{ #category : #'*soap-core' }
Object >> soapIgnorableInstVarNames [
	"Override if you wish"
	"If you would like to omit some inst vars in serialization, List their names here."

	^#()
]

Class {
	#name : #SoapHttpConnector,
	#superclass : #SoapAbstractConnector,
	#category : #'SOAP-Client-Http'
}

{ #category : #'class initialization' }
SoapHttpConnector class >> initialize [
	self initializeAfterLoad
]

{ #category : #constants }
SoapHttpConnector class >> transportName [
	^#http
]

{ #category : #actions }
SoapHttpConnector >> send: aSoapEnvelope to: anSoapTcpLocator with: aSoapContext [ 
	"return aSoapMessage or nil"
	| page soapClient envBuilder rawString returnEnvelope message client |
	
	client := ZnClient new.
	client url: ('http://' , anSoapTcpLocator host, aSoapContext targetObjectURI);
		contents: aSoapEnvelope printXmlString;
		contentType: 'text/xml';
		post.
	
	rawString := client response entity contents. 
 
	1halt.
 
	returnEnvelope :=  self envelopeBuilder buildSoapEnvelopeFromXmlString: rawString.
	message := SoapMessage envelope: returnEnvelope.
	self debugReturn: message.
	^message
]

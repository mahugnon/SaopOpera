"
Convenient XML Element which is contained in SoapElement

---
mu 1/4/2002 22:54
"
Class {
	#name : #SoapWrapElement,
	#superclass : #SoXmlWrapElement,
	#category : #'SOAP-Core-Base'
}

{ #category : #constants }
SoapWrapElement class >> arrayTypeMatchString [
	^'*arrayType'.
	
]

{ #category : #actions }
SoapWrapElement >> arrayItemType [
	| arrType |
	arrType := self arrayType.
	^arrType isNil
		ifTrue: [(SoapConstants xsdAnyType)]
		ifFalse: [| end | 
			end := arrType findString: '[' startingAt: 0.
			(arrType copyFrom: 1 to: end - 1) ]
]

{ #category : #actions }
SoapWrapElement >> arrayType [
	^self getAttributeLike: self class arrayTypeMatchString.
	
]

{ #category : #accessing }
SoapWrapElement >> attributesHolder [
	attributesHolder isNil ifTrue:[ attributesHolder := SoapAttributesHolder new].
	^attributesHolder
]

{ #category : #actions }
SoapWrapElement >> declareEncodingIn: nameSpacePrefix  uri: uriString [
	self putAttributeNamed: nameSpacePrefix, ':', SoapConstants encodingStyle value: uriString.
]

{ #category : #actions }
SoapWrapElement >> declareSoapEncNamespace [
	self declareNamespace: SoapConstants soapEncPrefix  uri: SoapConstants soapEncURI.
	
]

{ #category : #actions }
SoapWrapElement >> declareTypicalEncoding [
	self declareEncodingIn: SoapConstants soapEnvPrefix uri: SoapConstants soapEncURI.
]

{ #category : #actions }
SoapWrapElement >> declareTypicalNamespaces [
	self declareSoapEncNamespace.
	self declareXsdNamespace.
	self declareXsiNamespace
]

{ #category : #actions }
SoapWrapElement >> declareXsdNamespace [
	self declareNamespace: SoapConstants xsdPrefix  uri: SoapConstants xsdURI.
	
]

{ #category : #actions }
SoapWrapElement >> declareXsiNamespace [

	self declareNamespace: SoapConstants xsiPrefix  uri: SoapConstants xsiURI.
	
]

{ #category : #actions }
SoapWrapElement >> encodingStyleURIs [
	"ToDo: take a more serious approach...Namespace conscious"
	| encs |
	encs := self attributesHolder encodingStyle.
	((encs isNil	or: [encs isEmpty]) and: [self parent notNil])
		ifTrue: [^ self parent encodingStyleURIs].
	^ SoPortableUtil substringsFrom: encs
]

{ #category : #actions }
SoapWrapElement >> href [
	^self getAttributeNamed: SoapConstants href
]

{ #category : #actions }
SoapWrapElement >> href: aString [
	^self putAttributeNamed: SoapConstants href value: aString
]

{ #category : #actions }
SoapWrapElement >> id [
	^self getAttributeNamed: SoapConstants id
]

{ #category : #actions }
SoapWrapElement >> id: aString [
	^self putAttributeNamed: SoapConstants id value: aString
]

{ #category : #testing }
SoapWrapElement >> isArrayType [
	^self hasAttributeLike: self class arrayTypeMatchString
]

{ #category : #actions }
SoapWrapElement >> size [
	| arrType |
	arrType := self arrayType.
	^arrType isNil
		ifTrue: [self children size]
		ifFalse: [| start | 
			start := arrType findString: '[' startingAt: 0.
			(arrType copyFrom: start + 1 to: arrType size - 1) asNumber]
]

{ #category : #actions }
SoapWrapElement >> xsiType [
	^self getAttributeNamed: SoapConstants xsiType
]

{ #category : #actions }
SoapWrapElement >> xsiType: aString [
	^self putAttributeNamed: SoapConstants xsiType value: aString
]

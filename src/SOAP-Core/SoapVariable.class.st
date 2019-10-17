"
I represent a SOAP RPC variable. Used as parameter and return value.

---
MU 5/12/2002 00:47
"
Class {
	#name : #SoapVariable,
	#superclass : #SoapEncodable,
	#instVars : [
		'name',
		'type',
		'id',
		'href',
		'value',
		'xsdType',
		'prefix',
		'namespace'
	],
	#category : #'SOAP-Core-RPC'
}

{ #category : #'instance creation' }
SoapVariable class >> name: aNameSymbol [
	^ self name: aNameSymbol value: nil type: nil
]

{ #category : #'instance creation' }
SoapVariable class >> name: aNameSymbol href: identifiable [
	^ self new name: aNameSymbol;
		 href: '#', identifiable assuredId.
]

{ #category : #'instance creation' }
SoapVariable class >> name: aNameSymbol hrefId: id [
	^ self new name: aNameSymbol;
		 href: '#', id asString
]

{ #category : #'instance creation' }
SoapVariable class >> name: aNameSymbol type: aSmalltalkTypeSymbol [
	^ self new name: aNameSymbol;
		 type: aSmalltalkTypeSymbol
]

{ #category : #'instance creation' }
SoapVariable class >> name: aNameSymbol value: anObject [
	^ self new name: aNameSymbol;
		value: anObject
]

{ #category : #'instance creation' }
SoapVariable class >> name: aNameSymbol value: anObject namespace: namespaceURI [ 
	^ self new name: aNameSymbol;
		 value: anObject;
		 namespace: namespaceURI
]

{ #category : #'instance creation' }
SoapVariable class >> name: aNameSymbol value: anObject prefix: prefix namespace: namespaceURI [ 
	^ self new name: aNameSymbol;
		 value: anObject;
		 prefix: prefix;
		 namespace: namespaceURI
]

{ #category : #'instance creation' }
SoapVariable class >> name: aNameSymbol value: anObject type: aSmalltalkTypeSymbol [
	^ self new name: aNameSymbol;
		 value: anObject;
		 type: aSmalltalkTypeSymbol
]

{ #category : #'instance creation' }
SoapVariable class >> name: aNameSymbol value: anObject xsdType: anXsdTypeSymbol [
	^ self new name: aNameSymbol;
		value: anObject;
		 xsdType: anXsdTypeSymbol
]

{ #category : #'instance creation' }
SoapVariable class >> name: aNameSymbol value: anObject xsdType: anXsdTypeSymbol namespace: namespaceURI [ 
	^ self new name: aNameSymbol;
		 value: anObject;
		 xsdType: anXsdTypeSymbol;
		 namespace: namespaceURI
]

{ #category : #'instance creation' }
SoapVariable class >> name: aNameSymbol xsdType: anXsdTypeSymbol [
	^ self new name: aNameSymbol;
		 xsdType: anXsdTypeSymbol
]

{ #category : #'instance creation' }
SoapVariable class >> name: aNameSymbol xsdType: anXsdTypeSymbol namespace: namespaceURI [ 
	^ self new name: aNameSymbol;
		 xsdType: anXsdTypeSymbol;
		 namespace: namespaceURI
]

{ #category : #converting }
SoapVariable >> asXmlElement [
	| elem |
	elem := self encoder encodeSoapVariable: self.
	(self parent isNil or:[ self parent encoder class ~= self encoder class])
		ifTrue: [elem declareEncodingIn: SoapConstants soapEnvPrefix uri: self encodingStyleURIString].
	^elem
]

{ #category : #actions }
SoapVariable >> assuredId [
	id isNil ifTrue: [id := self generateId].
	^id
]

{ #category : #private }
SoapVariable >> generateId [
	id := (Random new next * 1000000) truncated printString.
	^id
]

{ #category : #actions }
SoapVariable >> guessedPrefix [
	| xp p |
	^ (xp := self xsdPrefix) isEmptyOrNil
		ifTrue: [p := self prefix.
			p ifEmpty: [^ nil].
			p]
		ifFalse: [xp]
]

{ #category : #accessing }
SoapVariable >> href [
	^href
]

{ #category : #accessing }
SoapVariable >> href: aValue [

	href := aValue
]

{ #category : #accessing }
SoapVariable >> id [
	^id
]

{ #category : #accessing }
SoapVariable >> id: aValue [

	id := aValue
]

{ #category : #testing }
SoapVariable >> isPrefixedName [
	^SoXmlUtil isPrefixedName: self name
]

{ #category : #testing }
SoapVariable >> isRefValue [
	^self href notNil

]

{ #category : #accessing }
SoapVariable >> name [

	^name
]

{ #category : #accessing }
SoapVariable >> name: aValue [

	name := aValue
]

{ #category : #accessing }
SoapVariable >> namespace [

	^namespace
]

{ #category : #accessing }
SoapVariable >> namespace: aValue [

	namespace := aValue
]

{ #category : #accessing }
SoapVariable >> prefix [
	prefix ifNil: [prefix := SoXmlUtil prefixFrom: self name].
	^prefix
]

{ #category : #accessing }
SoapVariable >> prefix: aString [
	
	prefix := aString
]

{ #category : #accessing }
SoapVariable >> type [

	^type
]

{ #category : #accessing }
SoapVariable >> type: aValue [

	type := aValue
]

{ #category : #accessing }
SoapVariable >> value [
	self isRefValue ifTrue: [^nil].
	^value
]

{ #category : #accessing }
SoapVariable >> value: aValue [

	value := aValue
]

{ #category : #accessing }
SoapVariable >> xsdPrefix [
	^SoXmlUtil prefixFrom: self xsdType
]

{ #category : #accessing }
SoapVariable >> xsdType [

	^xsdType
]

{ #category : #accessing }
SoapVariable >> xsdType: aValue [

	xsdType := aValue
]

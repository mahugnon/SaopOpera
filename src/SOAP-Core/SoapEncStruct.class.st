Class {
	#name : #SoapEncStruct,
	#superclass : #Object,
	#instVars : [
		'name',
		'xsdType',
		'namespace',
		'keysAndValues',
		'dictionary',
		'keys',
		'referenceHash'
	],
	#category : #'SOAP-Core-Encoding'
}

{ #category : #'instance creation' }
SoapEncStruct class >> from: object [ 
	^self from: object named: nil
]

{ #category : #'instance-creation-basic' }
SoapEncStruct class >> from: object named: elemName [

	^self from: object named: elemName xsdType: nil
]

{ #category : #'instance-creation-basic' }
SoapEncStruct class >> from: object named: elemName xsdType: xsdType [

	^self from: object named: elemName xsdType: xsdType namespace: nil 
]

{ #category : #'instance-creation-basic' }
SoapEncStruct class >> from: object named: elemName xsdType: xsdType namespace: namespaceURI [ 

	| varNames assocs inst |
	varNames := object class allInstVarNames copyWithoutAll: object soapIgnorableInstVarNames.
	assocs := varNames collect: [:nm | nm -> (object instVarNamed: nm)].
	inst := self fromAssociations: assocs named: elemName xsdType: xsdType namespace: namespaceURI.
	inst referenceHash: object identityHash.
	^inst 
]

{ #category : #'instance creation' }
SoapEncStruct class >> fromAssociations: keysAndValues [
	^self fromAssociations: keysAndValues named: nil
]

{ #category : #'instance-creation-basic' }
SoapEncStruct class >> fromAssociations: keysAndValues named: elemName [
	^self fromAssociations: keysAndValues named: elemName xsdType: nil 
]

{ #category : #'instance-creation-basic' }
SoapEncStruct class >> fromAssociations: keysAndValues named: elemName xsdType: xsdType [ 
	^self fromAssociations: keysAndValues named: elemName xsdType: xsdType namespace: nil 
]

{ #category : #'instance-creation-basic' }
SoapEncStruct class >> fromAssociations: keysAndValues named: elemName xsdType: xsdType namespace: namespaceURI [ 
	| inst |
	inst := self new name: elemName;
				 xsdType: xsdType;
				 namespace: namespaceURI;
				 yourself.
	keysAndValues
		do: [:assoc | inst at: assoc key put: assoc value].
	^ inst
]

{ #category : #'instance-creation-basic' }
SoapEncStruct class >> fromAssociations: keysAndValues xsdType: xsdType namespace: namespaceURI [ 
	"obsolete"
	^self fromAssociations: keysAndValues named: xsdType xsdType: xsdType namespace: namespaceURI 
]

{ #category : #actions }
SoapEncStruct >> at: key [
	^self dictionary at: key
]

{ #category : #actions }
SoapEncStruct >> at: key ifAbsent: aBlock [
	^self dictionary at: key ifAbsent: aBlock
]

{ #category : #actions }
SoapEncStruct >> at: key put: value [
	"key is limited to String"
	"Note that it remembers order of key->value registrations"
	| stringKey |
	stringKey := key asString.
	(self keys includes: stringKey) ifFalse: [self keys add: stringKey].
	^self dictionary at: stringKey put: value
]

{ #category : #accessing }
SoapEncStruct >> dictionary [
	dictionary ifNil: [dictionary := Dictionary new].
	^dictionary
]

{ #category : #accessing }
SoapEncStruct >> dictionary: aDictionary [
	dictionary := aDictionary
]

{ #category : #accessing }
SoapEncStruct >> keys [
	keys ifNil: [keys := OrderedCollection new].
	^keys
]

{ #category : #actions }
SoapEncStruct >> keysAndValues [
	| ord |
	ord := OrderedCollection new.
	self keysAndValuesDo: [:k :v |
		ord add: k->v
	].
	^ord
]

{ #category : #actions }
SoapEncStruct >> keysAndValuesDo: aBlock [
	self keys do: [:eachKey |
		aBlock value: eachKey value: (self dictionary at: eachKey ifAbsent:[])
	]
]

{ #category : #accessing }
SoapEncStruct >> name [
	^name
]

{ #category : #accessing }
SoapEncStruct >> name: aString [
	name := aString
]

{ #category : #accessing }
SoapEncStruct >> namespace [
	^namespace
]

{ #category : #accessing }
SoapEncStruct >> namespace: namespaceURI [
	namespace := namespaceURI
]

{ #category : #accessing }
SoapEncStruct >> prefix [
	^SoXmlUtil prefixFrom: self name.
	
]

{ #category : #accessing }
SoapEncStruct >> referenceHash [
	referenceHash ifNil: [referenceHash := self identityHash].
	^referenceHash
]

{ #category : #accessing }
SoapEncStruct >> referenceHash: hash [
	referenceHash := hash
]

{ #category : #accessing }
SoapEncStruct >> soapIdKey [
	^self referenceHash
]

{ #category : #actions }
SoapEncStruct >> values [
	| values |
	values := OrderedCollection new.
	self keys do: [:eachKey | (self dictionary at: eachKey ifAbsent: []) ifNotNilDo: [:v | values add: v]].
	^ values
]

{ #category : #accessing }
SoapEncStruct >> xsdType [
	^xsdType
]

{ #category : #accessing }
SoapEncStruct >> xsdType: aString [
	xsdType := aString
]

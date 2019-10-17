Class {
	#name : #SoapSampleCustomer,
	#superclass : #Object,
	#instVars : [
		'name',
		'age',
		'dateOfBirth'
	],
	#category : #'SOAP-Example-CustomComplexType'
}

{ #category : #'sample instances' }
SoapSampleCustomer class >> customerA [
	| cust |
	cust := self new.
	cust name: 'Masashi'.
	cust age: 36.
	cust dateOfBirth: (DateAndTime fromString: '1970-11-22T00:00:00-07:00').
	^cust
]

{ #category : #'sample instances' }
SoapSampleCustomer class >> customerB [
	| cust |
	cust := self new.
	cust name: 'Mike'.
	cust age: 26.
	cust dateOfBirth: (DateAndTime fromString: '1980-10-20T00:00:00-07:00').
	^cust
]

{ #category : #'class initialization' }
SoapSampleCustomer class >> initialize [
	"SoapSampleCustomer initialize"

	SoapEncoder complexTypeDict at: self name put: 'types:Customer'.
	SoapLiteralEncoder complexTypeDict at: self name put: 'types:Customer'.

	SoapDecoder complexTypeDict at: 'types:Customer' put: self.
]

{ #category : #accessing }
SoapSampleCustomer >> age [
	"Answer the value of age"

	^ age
]

{ #category : #accessing }
SoapSampleCustomer >> age: anObject [
	"Set the value of age"

	age := anObject
]

{ #category : #accessing }
SoapSampleCustomer >> dateOfBirth [
	"Answer the value of dateOfBirth"

	^ dateOfBirth
]

{ #category : #accessing }
SoapSampleCustomer >> dateOfBirth: anObject [
	"Set the value of dateOfBirth"

	dateOfBirth := anObject
]

{ #category : #accessing }
SoapSampleCustomer >> name [
	^name
]

{ #category : #accessing }
SoapSampleCustomer >> name: anObject [
	"Set the value of name"

	name := anObject
]

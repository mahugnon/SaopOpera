Class {
	#name : #SoapSampleGroup,
	#superclass : #Object,
	#instVars : [
		'name',
		'members'
	],
	#category : #'SOAP-Example-CustomComplexType'
}

{ #category : #'sample instances' }
SoapSampleGroup class >> groupA [
	"SoapSampleGroup groupA"
	| group |
	group := self new.
	group name: 'Squeak support'.
	group members add: SoapSampleCustomer customerA.
	group members add: SoapSampleCustomer customerB.
	^group
]

{ #category : #'class initialization' }
SoapSampleGroup class >> initialize [
	"SoapSampleGroup initialize"

	SoapEncoder complexTypeDict at: self name put: 'types:Groups'.
	SoapLiteralEncoder complexTypeDict at: self name put: 'types:Groups'.

	SoapDecoder complexTypeDict at: 'types:Groups' put: self.
]

{ #category : #accessing }
SoapSampleGroup >> members [
	"Answer the value of members"
	members ifNil: [members := OrderedCollection new].
	^ members
]

{ #category : #accessing }
SoapSampleGroup >> members: anObject [
	"Set the value of members"

	members := anObject
]

{ #category : #accessing }
SoapSampleGroup >> name [
	^name
]

{ #category : #accessing }
SoapSampleGroup >> name: anObject [
	"Set the value of name"

	name := anObject
]

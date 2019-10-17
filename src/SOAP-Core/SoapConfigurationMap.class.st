Class {
	#name : #SoapConfigurationMap,
	#superclass : #Object,
	#classInstVars : [
		'implDict'
	],
	#category : #'SOAP-Core-Base'
}

{ #category : #actions }
SoapConfigurationMap class >> at: aSymbol [
	^self implDict at: aSymbol ifAbsent:[].
	
]

{ #category : #actions }
SoapConfigurationMap class >> at: aSymbol put: realClass [
	^self implDict at: aSymbol put: realClass
]

{ #category : #accessing }
SoapConfigurationMap class >> implDict [
	implDict isNil ifTrue: [implDict :=  IdentityDictionary new].
	^implDict
]

{ #category : #'class initialization' }
SoapConfigurationMap class >> initImplDict [
	implDict := nil
]

{ #category : #'class initialization' }
SoapConfigurationMap class >> initialize [
	"SoapConfigurationMap initialize"
	
	self initImplDict.
	
	Smalltalk at: self rootImplClassName ifPresent:[:found | found initializeAll].
	
]

{ #category : #'class initialization' }
SoapConfigurationMap class >> initializeAll [
	"SoapConfigurationMap initializeAll"
	
	self allSubclassesDo:[:each | each initialize]
]

{ #category : #utility }
SoapConfigurationMap class >> isKom6plus [
	^Smalltalk includesKey: #HttpService
]

{ #category : #utility }
SoapConfigurationMap class >> isNG [
	^Smalltalk includesKey: #ComancheHttpService
]

{ #category : #utility }
SoapConfigurationMap class >> isServerInstalled [
	^Smalltalk includesKey: #SoapServerSetup
]

{ #category : #actions }
SoapConfigurationMap class >> removeAt: aSymbol [
	^self implDict removeKey: aSymbol ifAbsent:[]
]

{ #category : #factory }
SoapConfigurationMap class >> rootImplClassName [
	"subclass should return a class name"
	^nil
]

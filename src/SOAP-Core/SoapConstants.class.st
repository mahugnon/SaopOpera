"
SOAP Constants provider.

(I hate to use Pool)
---
mu 5/3/2001 19:32
"
Class {
	#name : #SoapConstants,
	#superclass : #SoXmlConstants,
	#category : #'SOAP-Core-Base'
}

{ #category : #attributes }
SoapConstants class >> actor [
	^self at: #actor ifAbsentPutValue:'actor' 
  
]

{ #category : #attributes }
SoapConstants class >> arrayType [
	
	^self at: #arrayType ifAbsentPutValue: (self soapEncPrefixColon, 'arrayType')
]

{ #category : #'fault codes' }
SoapConstants class >> client [
	^self at: #client ifAbsentPutValue:'Client' 

]

{ #category : #attributes }
SoapConstants class >> encodingStyle [
	^self at: #encodingStyle ifAbsentPutValue:'encodingStyle' 
  
]

{ #category : #attributes }
SoapConstants class >> href [
	^self at: #href ifAbsentPutValue:'href' 
  
]

{ #category : #attributes }
SoapConstants class >> id [
	^self at: #id ifAbsentPutValue:'id' 
  
]

{ #category : #'fault codes' }
SoapConstants class >> mustUnderstand [
	^self at: #mustUnderstand ifAbsentPutValue:'MustUnderstand' 


]

{ #category : #prefixes }
SoapConstants class >> nullEncPrefix [
	^self at: #nullEncPrefix ifAbsentPutValue:'Null-ENC' 
]

{ #category : #prefixes }
SoapConstants class >> nullEncPrefixColon [
	^self withColon: self nullEncPrefix
]

{ #category : #URIs }
SoapConstants class >> nullEncURI [
	"non standard squeak specific encoding - MU"
	^ self at: #soapNullEncURI ifAbsentPutValue: 'http://www.mars.dti.ne.jp/~umejava/smalltalk/soapOpera/null/encoding/'
]

{ #category : #rpc }
SoapConstants class >> returnValueAccessor [
	^self at: #returnValueAccessor ifAbsentPutValue:'result' 

]

{ #category : #'fault codes' }
SoapConstants class >> server [
	^self at: #server ifAbsentPutValue:'Server' 

]

{ #category : #URIs }
SoapConstants class >> soapActorNextURI [
	^self at: #soapActorNextURI ifAbsentPutValue:'http://schemas.xmlsoap.org/soap/actor/next' 
]

{ #category : #prefixes }
SoapConstants class >> soapEncPrefix [
	^self at: #soapEncPrefix ifAbsentPutValue:'enc' 
]

{ #category : #prefixes }
SoapConstants class >> soapEncPrefixColon [
	^self withColon: self soapEncPrefix
]

{ #category : #URIs }
SoapConstants class >> soapEncURI [
	"ToDo: swith 1.2 value: http://www.w3.org/2001/12/soap-encoding"
	^self at: #soapEncURI ifAbsentPutValue:'http://schemas.xmlsoap.org/soap/encoding/' 
]

{ #category : #prefixes }
SoapConstants class >> soapEnvPrefix [
	^self at: #soapEnvPrefix ifAbsentPutValue:'env' 
]

{ #category : #prefixes }
SoapConstants class >> soapEnvPrefixColon [
	^self withColon: self soapEnvPrefix
]

{ #category : #URIs }
SoapConstants class >> soapEnvURI [
	^self at: #soapEnvURI ifAbsentPutValue:'http://schemas.xmlsoap.org/soap/envelope/' 
]

{ #category : #URIs }
SoapConstants class >> soapSixxEncURI [
	"sixx encoding - MU"
	^ self at: #soapSixxEncURI ifAbsentPutValue: 'http://www.mars.dti.ne.jp/~umejava/smalltalk/sixx/encoding/'
]

{ #category : #URIs }
SoapConstants class >> soapSqEncURI [
	"non standard squeak specific encoding - MU"
	^ self at: #soapSqEncURI ifAbsentPutValue: 'http://www.mars.dti.ne.jp/~umejava/smalltalk/soapOpera/encoding/'
]

{ #category : #URIs }
SoapConstants class >> soapSrpEncURI [
	"camp smalltalk SRP encoding - MU"
	^ self at: #srpEncURI ifAbsentPutValue: 'http://wiki.cs.uiuc.edu/CampSmalltalk/SRP/encoding/'
]

{ #category : #prefixes }
SoapConstants class >> sqEncPrefix [
	^self at: #sqEncPrefix ifAbsentPutValue:'Squeak-ENC' 
]

{ #category : #prefixes }
SoapConstants class >> sqEncPrefixColon [
	^self withColon: self sqEncPrefix
]

{ #category : #'fault codes' }
SoapConstants class >> versionMismatch [
	^self at: #versionMismatch ifAbsentPutValue:'VersionMismatch' 
]

{ #category : #attributes }
SoapConstants class >> xsiNil [
	"shortcut for performance"
	"xsi:null is Soap1.1"
	"xsi:nil is Soap1.2"
	^self at: #xsiNil ifAbsentPutValue: (self xsiPrefixColon, 'nil')
]

"
XML Constants provider.

(I hate to use Pool)
---
mu 5/3/2001 19:22
"
Class {
	#name : #SoXmlConstants,
	#superclass : #SoConstants,
	#category : #'SoXML-Base'
}

{ #category : #'xsd types' }
SoXmlConstants class >> anyType [
	^self at: #anyType ifAbsentPutValue: 'anyType'
]

{ #category : #'xsd types' }
SoXmlConstants class >> base64 [
	^self at: #base64 ifAbsentPutValue: 'base64'
]

{ #category : #'xsd types' }
SoXmlConstants class >> base64Binary [
	^self at: #base64Binary ifAbsentPutValue: 'base64Binary'
]

{ #category : #'xsd types' }
SoXmlConstants class >> boolean [
	^self at: #boolean ifAbsentPutValue: 'boolean'
]

{ #category : #'xsd types' }
SoXmlConstants class >> float [
	^self at: #float ifAbsentPutValue: 'float'
]

{ #category : #'xsd types' }
SoXmlConstants class >> integer [
	^self at: #integer ifAbsentPutValue: 'integer'
]

{ #category : #'xsd types' }
SoXmlConstants class >> string [
	^self at: #string ifAbsentPutValue: 'string'
]

{ #category : #'xsd types' }
SoXmlConstants class >> time [
	^self at: #time ifAbsentPutValue: 'time'
]

{ #category : #utility }
SoXmlConstants class >> withColon: aString [
	| wStr |
	wStr := WriteStream on: (String new: aString size).
	wStr nextPutAll: aString.
	wStr nextPut: $:.
	^wStr contents.
]

{ #category : #prefixes }
SoXmlConstants class >> xmlnsPrefix [
	^self at: #xmlnsPrefix ifAbsentPutValue: 'xmlns'
]

{ #category : #prefixes }
SoXmlConstants class >> xmlnsPrefixColon [
	^self withColon: self xmlnsPrefix
]

{ #category : #URIs }
SoXmlConstants class >> xmlnsURI [
	^self at: #xmlnsURI ifAbsentPutValue: 'http://www.w3.org/2000/xmlns/'
]

{ #category : #URIs }
SoXmlConstants class >> xmlnsURI: aString [
	^self constDict at: #xmlnsURI put: aString
]

{ #category : #'xsd types' }
SoXmlConstants class >> xsdAnyType [
	^self at: #xsdAnyType ifAbsentPutValue: (self xsdPrefixColon, 'anyType')
]

{ #category : #'xsd types' }
SoXmlConstants class >> xsdBase64BinaryType [
	^self at: #xsdBase64Binary ifAbsentPutValue: (self xsdPrefixColon, 'base64Binary')
]

{ #category : #'xsd types' }
SoXmlConstants class >> xsdFloatType [
	^self at: #xsdFloatType ifAbsentPutValue: (self xsdPrefixColon, 'float')
]

{ #category : #'xsd types' }
SoXmlConstants class >> xsdIntegerType [
	^self at: #xsdIntegerType ifAbsentPutValue: (self xsdPrefixColon, 'integer')
]

{ #category : #'xsd types' }
SoXmlConstants class >> xsdLongType [
	^self at: #xsdFloatType ifAbsentPutValue: (self xsdPrefixColon, 'long')
]

{ #category : #prefixes }
SoXmlConstants class >> xsdPrefix [
	^self at: #xsdPrefix ifAbsentPutValue: 'xsd'
]

{ #category : #prefixes }
SoXmlConstants class >> xsdPrefixColon [
	^self withColon: self xsdPrefix
]

{ #category : #'xsd types' }
SoXmlConstants class >> xsdStringType [
	^self at: #xsdStringType ifAbsentPutValue: (self xsdPrefixColon, 'string')
]

{ #category : #'xsd types' }
SoXmlConstants class >> xsdTimeType [
	^self at: #xsdTime ifAbsentPutValue: (self xsdPrefixColon, 'time')
]

{ #category : #URIs }
SoXmlConstants class >> xsdURI [
	^self at: #xsdURI ifAbsentPutValue: 'http://www.w3.org/2001/XMLSchema'
]

{ #category : #URIs }
SoXmlConstants class >> xsdURI: aString [ 
	^self constDict at: #xsdURI put: aString
]

{ #category : #prefixes }
SoXmlConstants class >> xsiPrefix [
	^self at: #xsiPrefix ifAbsentPutValue: 'xsi'
]

{ #category : #prefixes }
SoXmlConstants class >> xsiPrefixColon [
	^self withColon: self xsiPrefix
]

{ #category : #attributes }
SoXmlConstants class >> xsiType [
	"shortcut for performance"
	^self at: #xsiType ifAbsentPutValue: (self xsiPrefixColon, 'type')
]

{ #category : #URIs }
SoXmlConstants class >> xsiURI [
	^self at: #xsiURI ifAbsentPutValue: 'http://www.w3.org/2001/XMLSchema-instance'
]

{ #category : #URIs }
SoXmlConstants class >> xsiURI: aString [
	^self constDict at: #xsiURI put: aString
]

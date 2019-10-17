Class {
	#name : #SoapConnectorMap,
	#superclass : #SoapConfigurationMap,
	#category : #'SOAP-Client-Base'
}

{ #category : #actions }
SoapConnectorMap class >> at: aSymbol [
	| cls |
	cls := super at: aSymbol.
	^cls isNil ifTrue:[SoapNoSuchConnector signal: aSymbol] ifFalse:[cls new]
]

{ #category : #factory }
SoapConnectorMap class >> rootImplClassName [
	^#SoapAbstractConnector
]

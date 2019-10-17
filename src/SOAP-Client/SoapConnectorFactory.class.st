Class {
	#name : #SoapConnectorFactory,
	#superclass : #Object,
	#category : #'SOAP-Client-Base'
}

{ #category : #'instance creation' }
SoapConnectorFactory class >> createFrom: anTransportSymbol [
	^SoapConnectorMap at: anTransportSymbol
]

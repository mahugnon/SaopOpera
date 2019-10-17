Class {
	#name : #SoapTimeoutError,
	#superclass : #Warning,
	#category : #'SOAP-Core-Base'
}

{ #category : #exceptionDescription }
SoapTimeoutError >> defaultAction [
	Transcript show: self class name, ': data was late'; cr.
	self resume
]

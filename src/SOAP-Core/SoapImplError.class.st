"
Abstract class for Soap implementation error.

---
mu 5/21/2001 22:30
"
Class {
	#name : #SoapImplError,
	#superclass : #Error,
	#category : #'SOAP-Core-Base'
}

{ #category : #exceptionDescription }
SoapImplError >> isResumable [
	
	^ true
]

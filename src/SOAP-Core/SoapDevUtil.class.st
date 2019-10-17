Class {
	#name : #SoapDevUtil,
	#superclass : #Object,
	#category : #'SOAP-Core-Base'
}

{ #category : #'file out' }
SoapDevUtil class >> fileoutAllModules [
	"self fileoutAllModules"
#(
'SoXML-Base'
'SoXML-ParserAdapter'
'SOAP-Base'
'SOAP-Elements'
'SOAP-DataBinding'
'SOAP-Encoding'
'SOAP-Decoding'
'SOAP-ClientBase'
'SOAP-ServerBase'
'SOAP-Http'
'SOAP-Http-Client'
'SOAP-Http-Comanche'
'SOAP-RPC'
'SOAP-Example'
'SOAP-GoogleWebAPI'
'SOAP-TranslateExample'
'SOAP-CustomComplexType'
'SOAP-TestCases'
'SOAP-DataBinding-SRP'
'SOAP-TestCases-SRP'
'SOAP-DataBinding-SIXX'
'SOAP-TestCases-SIXX'
'SOAP-Sqtp'
'SOAP-Sqtp-Client'
'SOAP-Sqtp-Server'
'SOAP-TestCases-Sqtp'
) do: [:each |
SystemOrganization fileOutCategory: each.
].
]

{ #category : #'file out' }
SoapDevUtil class >> fileoutClientModules [
	"self fileoutClientModules"
#(
'SoXML-Base'
'SoXML-ParserAdapter'
'SOAP-Base'
'SOAP-Elements'
'SOAP-DataBinding'
'SOAP-Encoding'
'SOAP-Decoding'
'SOAP-ClientBase'
'SOAP-Http'
'SOAP-Http-Client'
'SOAP-RPC'
'SOAP-Example'
'SOAP-GoogleWebAPI'
'SOAP-TranslateExample'
'SOAP-CustomComplexType'
) do: [:each |
SystemOrganization fileOutCategory: each.
].
]

{ #category : #'file out' }
SoapDevUtil class >> fileoutServerModules [
	"self fileoutServerModules"
#(
'SoXML-Base'
'SoXML-ParserAdapter'
'SOAP-Base'
'SOAP-Elements'
'SOAP-DataBinding'
'SOAP-Encoding'
'SOAP-Decoding'
'SOAP-ServerBase'
'SOAP-Http'
'SOAP-Http-Comanche'
'SOAP-RPC'
'SOAP-Example'
) do: [:each |
SystemOrganization fileOutCategory: each.
].
]

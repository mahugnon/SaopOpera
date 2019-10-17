"
I am an example that accesses Google Web APIs by SoapOpera.

About Google Web API:
http://www.google.com/apis/index.html

---
MU 5/12/2002 00:51
"
Class {
	#name : #SoapGoogleClient,
	#superclass : #Object,
	#instVars : [
		'licenseKey',
		'doGetCachedPage',
		'doSpellingSuggestion',
		'doGoogleSearch'
	],
	#classInstVars : [
		'licenseKey',
		'callEntry',
		'targetObjectURI',
		'namespace',
		'host',
		'port'
	],
	#category : #'SOAP-Example-GoogleWebAPI'
}

{ #category : #accessing }
SoapGoogleClient class >> callEntry [
	callEntry isNil ifTrue: [ callEntry := SoapCallEntry tcpHost: self host port: self port].
	^callEntry
]

{ #category : #accessing }
SoapGoogleClient class >> callEntry: aValue [

	callEntry := aValue
]

{ #category : #accessing }
SoapGoogleClient class >> host [
	host isNil ifTrue: [host := 'api.google.com'].
	^host
]

{ #category : #accessing }
SoapGoogleClient class >> host: aValue [

	host := aValue
]

{ #category : #documentation }
SoapGoogleClient class >> howToUse [
	"##GoogleClient is an example that accesses Google Web APIs by SoapOpera.##"
	
	"1: Preparations
	 In order to call Google Web APIs, you need a Google Account license key. (It is free).
	 The license key is obtained from: http://www.google.com/apis/index.html
	 Then, please set the license key by: SoapGoogleClient licenseKey: 'yourkey' 
	"
	
	"2: Usages (explore or print it)
	 SoapGoogleClient new search: 'Google Web APIs Reference'. 
	 SoapGoogleClient new spellingSuggestionOf: 'Smmalltlaak and Soaap'.
	 SoapGoogleClient new cachedPageOf: 'http://www.squeak.org'
	"
	
]

{ #category : #'class initialization' }
SoapGoogleClient class >> initialize [
	"GoogleClient initialize"
	"GoogleClient licenseKey: 'your key' (see the 'documentation' category first)"

	licenseKey := '00000000000000000000000000000000'.
	
	callEntry := targetObjectURI := namespace := host := port := nil.
]

{ #category : #accessing }
SoapGoogleClient class >> licenseKey [
	^licenseKey
]

{ #category : #accessing }
SoapGoogleClient class >> licenseKey: aString [
	"GoogleClient licenseKey: 'your key'"
	licenseKey := aString
]

{ #category : #accessing }
SoapGoogleClient class >> namespace [
	namespace isNil ifTrue: [namespace := 'urn:GoogleSearch'].
	^namespace
]

{ #category : #accessing }
SoapGoogleClient class >> namespace: aValue [

	namespace := aValue
]

{ #category : #actions }
SoapGoogleClient class >> newCall [
	| call |
	call := self callEntry newCall.
	call targetObjectURI: self targetObjectURI.
	call namespace: self namespace.
	^call
]

{ #category : #accessing }
SoapGoogleClient class >> port [
	port isNil ifTrue: [port := 80].
	^port
]

{ #category : #accessing }
SoapGoogleClient class >> port: aValue [

	port := aValue
]

{ #category : #accessing }
SoapGoogleClient class >> targetObjectURI [
	targetObjectURI isNil ifTrue: [targetObjectURI := 'http://api.google.com/search/beta2'].
	^targetObjectURI
]

{ #category : #accessing }
SoapGoogleClient class >> targetObjectURI: aValue [

	targetObjectURI := aValue
]

{ #category : #private }
SoapGoogleClient >> buildDoGetCachedPage [
	| call |
	call := self newCall.
	call methodName: 'doGetCachedPage'.
	call addParameterNamed: #key.
	call addParameterNamed: #url.
	^call
]

{ #category : #private }
SoapGoogleClient >> buildDoGoogleSearch [
	| call |
	call := self newCall.
	call methodName: 'doGoogleSearch'.
	call addParameterNamed: #key.
	call addParameterNamed: #q. 
	call addParameterNamed: #start xsdType: 'xsd:int'.
	call addParameterNamed: #maxResults xsdType: 'xsd:int'.
	call addParameterNamed: #filter.
	call addParameterNamed: #restrict.
	call addParameterNamed: #safeSearch.
	call addParameterNamed: #lr.
	call addParameterNamed: #ie.
	call addParameterNamed: #oe.
	^call
]

{ #category : #private }
SoapGoogleClient >> buildDoSpellingSuggestion [
	| call |
	call := self newCall.
	call methodName: 'doSpellingSuggestion'.
	call addParameterNamed: #key.
	call addParameterNamed: #phrase.
	^call
]

{ #category : #actions }
SoapGoogleClient >> cachedPageOf: urlString [
	| params resp |
	params := OrderedCollection with: self licenseKey.
	params add: urlString.
	resp := self doGetCachedPage invokeWithValues: params.
	^ resp isFault
		ifTrue: [resp raiseException]
		ifFalse: [resp returnValue asString]
]

{ #category : #accessing }
SoapGoogleClient >> doGetCachedPage [
	doGetCachedPage isNil ifTrue: [doGetCachedPage := self buildDoGetCachedPage].
	^doGetCachedPage
]

{ #category : #accessing }
SoapGoogleClient >> doGoogleSearch [
	doGoogleSearch isNil ifTrue: [doGoogleSearch := self buildDoGoogleSearch].
	^doGoogleSearch
]

{ #category : #accessing }
SoapGoogleClient >> doSpellingSuggestion [
	doSpellingSuggestion isNil ifTrue: [doSpellingSuggestion := self buildDoSpellingSuggestion].
	^doSpellingSuggestion
]

{ #category : #accessing }
SoapGoogleClient >> licenseKey [
	licenseKey isNil ifTrue: [licenseKey := self class licenseKey].
	^licenseKey
]

{ #category : #accessing }
SoapGoogleClient >> licenseKey: key [
	licenseKey := key
]

{ #category : #private }
SoapGoogleClient >> newCall [
	^self class newCall
]

{ #category : #actions }
SoapGoogleClient >> search: query [
	^ self
		search: query
		start: 0
		maxResults: 10
		
]

{ #category : #actions }
SoapGoogleClient >> search: query start: start maxResults: maxResults [
	^ self
		search: query
		start: start
		maxResults: maxResults
		filter: true
		restrict: ''
		safeSearch: false
		languageRestrict: '' 
]

{ #category : #actions }
SoapGoogleClient >> search: query start: start maxResults: maxResults filter: filter restrict: restrict safeSearch: safeSearch languageRestrict: lr [ 
	^ self
		search: query
		start: start
		maxResults: maxResults
		filter: filter
		restrict: restrict
		safeSearch: safeSearch
		languageRestrict: lr
		inputEncoding: 'utf8'
		outputEncoding: 'utf8'
]

{ #category : #actions }
SoapGoogleClient >> search: query start: start maxResults: maxResults filter: filter restrict: restrict safeSearch: safeSearch languageRestrict: lr inputEncoding: ie outputEncoding: oe [ 
	| params resp |
	params := OrderedCollection with: self licenseKey.
	params add: query;
		 add: start;
		 add: maxResults;
		 add: filter;
		 add: restrict;
		 add: safeSearch;
		 add: lr;
		 add: ie;
		 add: oe.
	resp := self doGoogleSearch invokeWithValues: params.
	^ resp isFault
		ifTrue: [resp raiseException]
		ifFalse: [resp returnValue]
]

{ #category : #actions }
SoapGoogleClient >> spellingSuggestionOf: phrase [
	| params resp |
	params := OrderedCollection with: self licenseKey.
	params add: phrase.
	resp := self doSpellingSuggestion invokeWithValues: params.
	^ resp isFault
		ifTrue: [resp raiseException]
		ifFalse: [resp returnValue]
]

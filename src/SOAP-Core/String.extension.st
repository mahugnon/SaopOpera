Extension { #name : #String }

{ #category : #'*soap-core' }
String >> soapIdKey [
	^self hash
]

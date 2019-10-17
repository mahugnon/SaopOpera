"
-SoapCore example documentation- See class side

---
MU 5/2/2002 01:15
"
Class {
	#name : #SoapExampleDoc,
	#superclass : #Object,
	#category : #'SOAP-Example'
}

{ #category : #documentation }
SoapExampleDoc class >> calling [
^'
SoapCall >> addParameters: provides a handy way for attaching parameters to SoapCall.

| googleKey searchKey call |
googleKey := ''gAE2CMNBd1xA+bRPXOmLkmT9+X8Y3bwG''.
searchKey := ''squeak''. 

call := (SoapCallEntry tcpHost: ''api.google.com'' port: 80) newCall.
call targetObjectURI: ''http://api.google.com/search/beta2''.
call namespace: ''urn:GoogleSearch''.
call methodName: ''doGoogleSearch''.
call addParameters: {
    {#key. googleKey}.
    {#q. searchKey}. 
    {#start. 0. ''xsd:int''}.
    {#maxResults. 10. ''xsd:int''}.
    {#filter. true}.
    {#restrict. ''''}.
    {#safeSearch. false}.
    {#lr. ''''}.
    {#ie. ''latin1''}.
    {#oe. ''latin1''}
}.
call invokeAndReturn

---
MU 11/8/2005 10:07
'
]

{ #category : #documentation }
SoapExampleDoc class >> howToRunExample [
^'1:
	Register services.
	"SoapExampleServiceImpl registerAllServices"

2:
	Call services by SoapExampleClient (print it)
	"SoapExampleClient new callHelloWorld"
	"SoapExampleClient new callTimeNow"
	"SoapExampleClient new callReverseString: self name printString"
	"SoapExampleClient new callTranscriptShow: self name printString"
	"SoapExampleClient new callBrowseClassDefinition: #Array"
	"SoapExampleClient new callReverseArray: #(1 #two 3.0)"
	"SoapExampleClient new callReturnComplexDictionary"

	(If you register services in some remote machine, you have to set class inst var "hostAddress".)
	"SoapExampleClient hostAddress: #yourServerName"

	(If you register services in a different port number other than default 8823)
	Server Side: "SoapSetting defaultPort: 1212"
	Client Side: "SoapSetting defaultSendingPort: 1212" or "SoapExampleClient port: 1212"(Example only)

3:
	If you would like to see raw XMLs, do it. (Open Transcript.)
	"SoapSetting showClientLog: true" 
	"SoapSetting showServerLog: true" 
	
	If you would like to see raw HTML headers for debugging, do it. (Open Transcript.)
	"SoapSetting showClientLogHttpLevel: true"

4:
	Multiple transport protocols are supported in SoapCore. Default is well known HTTP. 
	But you can try another protocol, SQTP (Squeak Transport Protocol).
	SQTP is fast in sending bulky data (more than approximately 700 bytes).
	
	First check your server is running what transport protocols.
	"SoapExampleServiceImpl runningTransportDescriptions"

	Change the default transport protocol in the client side.
	"SoapExampleClient transport: #sqtp"	"SoapExampleClient port: 4649"
	"SoapExampleClient transport: #http"	"SoapExampleClient port: 8823"
	
	Call the services, especially #reverseString: ; you can see the difference.

---
MU 10/6/2002 00:24
'
]

{ #category : #documentation }
SoapExampleDoc class >> registeringServices [
^'
There are utility methods for registering services quickly.
 - SoapServiceHandler class >> registerAllIn: impl.
 - SoapServiceHandler class >> registerAllIn: impl category: methodCategory.

Removeing services, you can use:
 - SoapServiceHandler class >> removeAllIn: impl.

---
MU 11/8/2005 10:07
'
]

{ #category : #documentation }
SoapExampleDoc class >> supportedEncodings [
^'
SoapCore supports multi-encodings for passing data. There are merits and demerits. Please select what is appropriate for your purpose.

 ...building a call ...
 call encoding: #soapSqEncoding. "<-- you can specify encoding scheme here"
 ...invoking a call ...

Supported encoding symbols are:

#soapEncoding
    Default, not so cool, but SOAP 1.1 compliant 
#soapSqEncoding
    Squeak native base64 format, powerful for complex objects, but loses interoperability 
#soapSixxEncoding (included in full installation)
    Portable Smalltalk XML format, usable for complex objects, but need to translate XML for interoperability with other languages 
#soapSrpEncoding (included in full installation)
    Portable Smalltalk binary format, interoperable with other Smalltalks 
#nullEncoding
    tries to pass object `as is`, very fast, usable only for very primitive types (byte array, etc) 

---
MU 11/8/2005 10:07
'
]

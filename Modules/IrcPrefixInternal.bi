#ifndef BATCHEDFILES_IRCCLIENT_IRCPREFIXINTERNAL_BI
#define BATCHEDFILES_IRCCLIENT_IRCPREFIXINTERNAL_BI

#include "ValueBSTR.bi"

Type _IrcPrefixInternal
	Dim Nick As ValueBSTR
	Dim User As ValueBSTR
	Dim Host As ValueBSTR
End Type

Type IrcPrefixInternal As _IrcPrefixInternal

Type LPIRCPREFIXINTERNAL As _IrcPrefixInternal Ptr

Declare Function GetIrcPrefixInternal( _
	ByVal pIrcPrefixInternal As IrcPrefixInternal Ptr, _
	ByRef bstrIrcMessage As ValueBSTR _
)As Integer

#endif

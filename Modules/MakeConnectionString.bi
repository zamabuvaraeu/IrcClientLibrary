#ifndef BATCHEDFILES_IRCCLIENT_MAKECONNECTIONSTRING_BI
#define BATCHEDFILES_IRCCLIENT_MAKECONNECTIONSTRING_BI

#include "IrcClient.bi"

Declare Sub MakeConnectionString( _
	ByVal ConnectionString As WString Ptr, _
	ByVal Password As Const WString Ptr, _
	ByVal Nick As Const WString Ptr, _
	ByVal User As Const WString Ptr, _
	ByVal Description As Const WString Ptr, _
	ByVal ModeFlags As Long _
)

#endif

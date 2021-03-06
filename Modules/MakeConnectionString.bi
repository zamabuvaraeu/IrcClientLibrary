#ifndef BATCHEDFILES_IRCCLIENT_MAKECONNECTIONSTRING_BI
#define BATCHEDFILES_IRCCLIENT_MAKECONNECTIONSTRING_BI

#include "ValueBSTR.bi"

Declare Sub MakeConnectionString( _
	ByRef ConnectionString As ValueBSTR, _
	ByVal Password As BSTR, _
	ByVal Nick As BSTR, _
	ByVal User As BSTR, _
	ByVal ModeFlags As Long, _
	ByVal RealName As BSTR _
)

#endif

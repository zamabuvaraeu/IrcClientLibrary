#ifndef BATCHEDFILES_IRCCLIENT_PARSEDATA_BI
#define BATCHEDFILES_IRCCLIENT_PARSEDATA_BI

#include "IrcClient.bi"

Declare Function ParseData( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByRef bstrIrcMessage As ValueBSTR _
)As HRESULT

#endif

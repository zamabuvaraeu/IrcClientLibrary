#ifndef BATCHEDFILES_IRCCLIENT_SENDDATA_BI
#define BATCHEDFILES_IRCCLIENT_SENDDATA_BI

#include "IrcClient.bi"

Declare Function SendData( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal strData As LPCWSTR _
)As HRESULT
	
#endif

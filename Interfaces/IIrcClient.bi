#ifndef BATCHEDFILES_IRCCLIENT_IIRCCLIENT_BI
#define BATCHEDFILES_IRCCLIENT_IIRCCLIENT_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "win\ole2.bi"

' {068B4FA6-0B55-4E12-B0C8-E2EEF9EFEFF3}
Dim Shared IID_IIRCCLIENT As IID = Type(&h68b4fa6, &hb55, &h4e12, _
	{&hb0, &hc8, &he2, &hee, &hf9, &hef, &hef, &hf3} _
)

Type LPIIRCCLIENT As IIrcClient Ptr

Type IIrcClient As IIrcClient_

Type IIrcClientVirtualTable
	Dim InheritedTable As IUnknownVtbl
	
	Dim OpenIrcClient As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Server As WString Ptr, _
		ByVal Port As WString Ptr, _
		ByVal LocalAddress As WString Ptr, _
		ByVal LocalPort As WString Ptr, _
		ByVal Password As WString Ptr, _
		ByVal Nick As WString Ptr, _
		ByVal User As WString Ptr, _
		ByVal Description As WString Ptr, _
		ByVal Visible As Boolean _
	)As HRESULT
	
	Dim CloseIrcClient As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
	)As HRESULT
	
	Dim SendIrcMessage As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)As HRESULT
	
	Dim SendNotice As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal NoticeText As WString Ptr _
	)As HRESULT
	
	Dim ChangeTopic As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal TopicText As WString Ptr _
	)As HRESULT
	
	Dim QuitFromServer As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal MessageText As WString Ptr _
	)As HRESULT
	
	Dim ChangeNick As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Nick As WString Ptr _
	)As HRESULT
	
	Dim JoinChannel As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Channel As WString Ptr _
	)As HRESULT
	
	Dim PartChannel As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)As HRESULT
	
	Dim SendWho As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr _
	)As HRESULT
	
	Dim SendWhoIs As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr _
	)As HRESULT
	
	Dim SendAdmin As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Server As WString Ptr _
	)As HRESULT
	
	Dim SendInfo As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Server As WString Ptr _
	)As HRESULT
	
	Dim SendAway As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal MessageText As WString Ptr _
	)As HRESULT
	
	Dim SendIsON As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal NickList As WString Ptr _
	)As HRESULT
	
	Dim SendKick As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)As HRESULT
	
	Dim SendInvite As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal Channel As WString Ptr _
	)As HRESULT
	
	Dim SendCtcpPingRequest As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal TimeValue As WString Ptr _
	)As HRESULT
	
	Dim SendCtcpTimeRequest As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr _
	)As HRESULT
	
	Dim SendCtcpUserInfoRequest As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr _
	)As HRESULT
	
	Dim SendCtcpVersionRequest As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr _
	)As HRESULT
	
	Dim SendCtcpAction As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)As HRESULT
	
	Dim SendCtcpPingResponse As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal TimeValue As WString Ptr _
	)As HRESULT
	
	Dim SendCtcpTimeResponse As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal TimeValue As WString Ptr _
	)As HRESULT
	
	Dim SendCtcpUserInfoResponse As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal UserInfo As WString Ptr _
	)As HRESULT
	
	Dim SendCtcpVersionResponse As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal Version As WString Ptr _
	)As HRESULT
	
	Dim SendDccSend As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal FileName As WString Ptr, _
		ByVal IPAddress As WString Ptr, _
		ByVal Port As WString Ptr, _
		ByVal FileLength As ULongInt _
	)As HRESULT
	
	Dim SendPing As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Server As WString Ptr _
	)As HRESULT
	
	Dim SendPong As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Server As WString Ptr _
	)As HRESULT
	
	Dim SendRawMessage As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal RawText As WString Ptr _
	)As HRESULT
	
End Type

Type IIrcClient_
	Dim pVirtualTable As IIrcClientVirtualTable Ptr
End Type

#define IBaseStream_QueryInterface(pIIrcClient, riid, ppv) (pIIrcClient)->pVirtualTable->InheritedTable.QueryInterface(CPtr(IUnknown Ptr, pIIrcClient), riid, ppv)
#define IBaseStream_AddRef(pIIrcClient) (pIIrcClient)->pVirtualTable->InheritedTable.AddRef(CPtr(IUnknown Ptr, pIIrcClient))
#define IBaseStream_Release(pIIrcClient) (pIIrcClient)->pVirtualTable->InheritedTable.Release(CPtr(IUnknown Ptr, pIIrcClient))

#endif

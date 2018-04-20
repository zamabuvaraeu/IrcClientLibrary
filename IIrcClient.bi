#ifndef IIRCCLIENT_BI
#define IIRCCLIENT_BI

#ifndef unicode
#define unicode
#endif

#include once "windows.bi"
#include once "win\ole2.bi"

Const CLSIDS_IRCCLIENT = "{3037D21F-43B9-4BA0-B066-43E91CD7B1C2}"

Const ProgID_IrcClient = "BatchedFiles.IrcClient"

Dim Shared CLSID_IRCCLIENT As CLSID = Type(&h3037d21f, &h43b9, &h4ba0, _
	{&hb0, &h66, &h43, &he9, &h1c, &hd7, &hb1, &hc2})

Dim Shared IID_IIRCCLIENT As IID = Type(&h609fa596, &h1c4e, &h4bcb, _
	{&ha9, &hd1, &hca, &h0d, &hbb, &hf3, &hfc, &h95})

Type IIrcClient As IIrcClient_

Type LPIIRCCLIENT As IIrcClient Ptr

Type IIrcClientVirtualTable
	Dim VirtualTable As IDispatchVtbl
	
	Dim ShowMessageBox As Function( _
		ByVal This As IIrcClient Ptr, _
		ByVal lngParam As Long, _
		ByVal pResult As Long Ptr _
	)As HRESULT
End Type

Type IIrcClient_
	Dim VirtualTable As IIrcClientVirtualTable Ptr
End Type

#endif

#ifndef unicode
#define unicode
#endif

#include once "windows.bi"
#include once "win\objbase.bi"

Const CLSIDS_IRCCLIENT = "{609FA596-1C4E-4BCB-A9D1-CA0DBBF3FC95}"

Const ProgID_IrcClient = "IRC.IrcClient"

Dim Shared IID_IIRCCLIENT As IID = Type(&h609fa596, &h1c4e, &h4bcb, {&ha9, &hd1, &hca, &h0d, &hbb, &hf3, &hfc, &h95})

Dim Shared CLSID_IRCCLIENT As IID = Type(&h609fa596, &h1c4e, &h4bcb, {&ha9, &hd1, &hca, &h0d, &hbb, &hf3, &hfc, &h95})

Type IIrcClient As IIrcClient_

Type LPIIRCCLIENT As IIrcClient Ptr

Type IIrcClientVirtualTable
	Dim VirtualTable As IDispatchVtbl
	Dim ShowMessageBox As Function(ByVal This As IIrcClient Ptr, ByVal Param As Long, ByVal pResult As Long Ptr)As HRESULT
End Type

Type IIrcClient_
	Dim VirtualTable As IIrcClientVirtualTable Ptr
End Type

Const ShowMessageBoxParametersCount As Integer = 1
Const ShowMessageBoxDispatchIndex As DISPID = 8
Const ShowMessageBoxParamDispatchIndex As DISPID = 9
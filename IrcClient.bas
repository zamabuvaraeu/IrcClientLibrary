#include "IrcClient.bi"


Const ShowMessageBoxParametersCount As Integer = 1
Const ShowMessageBoxDispatchIndex As DISPID = 8
Const ShowMessageBoxParamDispatchIndex As DISPID = 9

Common Shared GlobalObjectsCount As Long
Common Shared GlobalIrcClientVirtualTable As IIrcClientVirtualTable

Sub MakeIIrcClientVirtualTable()
	GlobalIrcClientVirtualTable.VirtualTable.QueryInterface = @IrcClientQueryInterface
	GlobalIrcClientVirtualTable.VirtualTable.AddRef = @IrcClientAddRef
	GlobalIrcClientVirtualTable.VirtualTable.Release = @IrcClientRelease
	GlobalIrcClientVirtualTable.VirtualTable.GetTypeInfoCount = @IrcClientGetTypeInfoCount
	GlobalIrcClientVirtualTable.VirtualTable.GetTypeInfo = @IrcClientGetTypeInfo
	GlobalIrcClientVirtualTable.VirtualTable.GetIDsOfNames = @IrcClientGetIDsOfNames
	GlobalIrcClientVirtualTable.VirtualTable.Invoke = @IrcClientInvoke
	GlobalIrcClientVirtualTable.ShowMessageBox = @IrcClientShowMessageBox
End sub

Function ConstructorIrcClient( _
	)As IrcClient Ptr
	
	Dim pIrcClient As IrcClient Ptr = CPtr(IrcClient Ptr, Allocate(SizeOf(IrcClient)))
	If pIrcClient = 0 Then
		Return 0
	End If
	
	pIrcClient->VirtualTable = @GlobalIrcClientVirtualTable
	
	pIrcClient->ReferenceCounter = 0
	
	Return pIrcClient
End Function

Sub DestructorIrcClient( _
		ByVal pIrcClient As IrcClient Ptr _
	)
	DeAllocate(pIrcClient)
End Sub

Function IrcClientQueryInterface( _
		ByVal This As IDispatch Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	*ppv = 0
	
	If IsEqualIID(@IID_IUnknown, riid) Then
		*ppv = CPtr(IUnknown Ptr, This)
	End If
	
	If IsEqualIID(@IID_IDispatch, riid) Then
		*ppv = CPtr(IDispatch Ptr, This)
	End If
	
	If IsEqualIID(@IID_IIrcClient, riid) Then
		*ppv = CPtr(IIrcClient Ptr, This)
	End If
	
	If *ppv = 0 Then
		Return E_NOINTERFACE
	End If
	
	IrcClientAddRef(This)
	Return S_OK
	
End Function

Function IrcClientAddRef( _
		ByVal This As IDispatch Ptr _
	)As ULONG
	
	Dim pClient As IrcClient Ptr = CPtr(IrcClient Ptr, This)
	InterlockedIncrement(@GlobalObjectsCount)
	Return InterlockedIncrement(@pClient->ReferenceCounter)
End Function

Function IrcClientRelease( _
		ByVal This As IDispatch Ptr _
	)As ULONG
	
	Dim pClient As IrcClient Ptr = CPtr(IrcClient Ptr, This)
	
	InterlockedDecrement(@pClient->ReferenceCounter)
	
	If pClient->ReferenceCounter = 0 Then
		DestructorIrcClient(pClient)
		InterlockedDecrement(@GlobalObjectsCount)
		
		Return 0
	End If
	
	Return pClient->ReferenceCounter
End Function

Function IrcClientGetTypeInfoCount( _
		ByVal This As IDispatch Ptr, _
		ByVal pctinfo As UINT Ptr _
	)As HRESULT
	
	If pctinfo = 0 Then
		Return E_INVALIDARG
	End If
	
	*pctinfo = 0
	Return S_OK
End Function

Function IrcClientGetTypeInfo( _
		ByVal This As IDispatch Ptr, _
		ByVal iTInfo As UINT, _
		ByVal lcid As LCID, _
		ByVal ppTInfo As ITypeInfo Ptr Ptr _
	)As HRESULT
	
	If ppTInfo = 0 Then
		Return E_INVALIDARG
	End If
	
	*ppTInfo = 0
	
	If iTInfo <> 0 Then
		Return DISP_E_BADINDEX
	End If
	
	Return S_OK
End Function

Function IrcClientGetIDsOfNames( _
		ByVal This As IDispatch Ptr, _
		ByVal riid As Const IID Const ptr, _
		ByVal rgszNames As LPOLESTR Ptr, _
		ByVal cNames As UINT, _
		ByVal lcid As LCID, _
		ByVal rgDispId As DISPID Ptr _
	)As HRESULT
	
	If rgDispId = 0 Then
		Return E_INVALIDARG
	End If
	
	Dim SuccessFlag As Boolean = True
	
	If lstrcmpi(rgszNames[0], "ShowMessageBox") = 0 Then
		rgDispId[0] = ShowMessageBoxDispatchIndex
		
		For i As Integer = 1 To cNames - 1
			
			If lstrcmpi(rgszNames[i], "lngParam") = 0 Then
				rgDispId[i] = ShowMessageBoxParamDispatchIndex
			Else
				SuccessFlag = False
				rgDispId[i] = DISPID_UNKNOWN
			End If
		Next
	Else
		SuccessFlag = False
		rgDispId[0] = DISPID_UNKNOWN
	End If
	
	If SuccessFlag = False Then
		Return DISP_E_UNKNOWNNAME
	End If
	
	Return S_OK
End Function

Function IrcClientInvoke( _
		ByVal This As IDispatch Ptr, _
		ByVal dispIdMember As DISPID, _
		ByVal riid As Const IID Const Ptr, _
		ByVal lcid As LCID, _
		ByVal wFlags As WORD, _
		ByVal pDispParams As DISPPARAMS Ptr, _
		ByVal pVarResult As VARIANT Ptr, _
		ByVal pExcepInfo As EXCEPINFO Ptr, _
		ByVal puArgErr As UINT Ptr _
	)As HRESULT
	
	Dim pIrcClient As IIrcClient Ptr = CPtr(IIrcClient Ptr, This)
	
	If IsEqualIID(@IID_NULL, riid) = False Then
		Return DISP_E_UNKNOWNINTERFACE
	End If
	
	Select Case dispIdMember
		
		Case ShowMessageBoxDispatchIndex
			If pDispParams->cArgs + pDispParams->cNamedArgs <> ShowMessageBoxParametersCount Then
				Return DISP_E_BADPARAMCOUNT
			End If
			
			pVarResult->vt = VT_I4
			Return IrcClientShowMessageBox(pIrcClient, pDispParams->rgvarg[0].lVal, @pVarResult->lVal)
			
	End Select
	
	Return DISP_E_MEMBERNOTFOUND
End Function

Function IrcClientShowMessageBox( _
		ByVal This As IIrcClient Ptr, _
		ByVal Param As Long, _
		ByVal pResult As Long Ptr _
	)As HRESULT
	
	If pResult = 0 Then
		Return E_INVALIDARG
	End If
	
	Dim pClient As IrcClient Ptr = CPtr(IrcClient Ptr, This)
	
	Select Case Param
		Case 0
			MessageBox(0, "Это нулевое сообщение", "IRCClient COM Library", MB_OK)
			*pResult = 0
		Case 1
			MessageBox(0, "Это первое сообщение", "IRCClient COM Library", MB_OK)
			*pResult = 1
		Case Else
			MessageBox(0, "Это любое сообщение", "IRCClient COM Library", MB_OK)
			*pResult = 2
	End Select
	
	Return S_OK
End Function

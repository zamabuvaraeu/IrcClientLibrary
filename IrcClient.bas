#include once "IrcClient.bi"

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

Function ConstructorIrcClient()As IrcClient Ptr
	Dim pIrcClient As IrcClient Ptr = CPtr(IrcClient Ptr, Allocate(SizeOf(IrcClient)))
	If pIrcClient = 0 Then
		Return 0
	End If
	
	pIrcClient->VirtualTable = @GlobalIrcClientVirtualTable
	
	pIrcClient->ReferenceCounter = 0
	
	Return pIrcClient
End Function

Sub DestructorIrcClient(ByVal pIrcClient As IrcClient Ptr)
	DeAllocate(pIrcClient)
End Sub

Function IrcClientQueryInterface(ByVal This As IrcClient Ptr, ByVal riid As REFIID, ByVal ppv As Any Ptr Ptr)As HRESULT
	
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

Function IrcClientAddRef(ByVal This As IrcClient Ptr)As ULONG
	InterlockedIncrement(@GlobalObjectsCount)
	Return InterlockedIncrement(@This->ReferenceCounter)
End Function

Function IrcClientRelease(ByVal This As IrcClient Ptr)As ULONG
	InterlockedDecrement(@This->ReferenceCounter)
	
	If This->ReferenceCounter = 0 Then
		DestructorIrcClient(This)
		InterlockedDecrement(@GlobalObjectsCount)
		
		Return 0
	End If
	
	Return This->ReferenceCounter
End Function

Function IrcClientGetTypeInfoCount(ByVal This As IDispatch Ptr, ByVal pctinfo As UINT Ptr)As HRESULT
	If pctinfo = 0 Then
		Return E_INVALIDARG
	End If
	
	*pctinfo = 0
	Return S_OK
End Function

Function IrcClientGetTypeInfo(ByVal This As IDispatch Ptr, ByVal iTInfo As UINT, ByVal lcid As LCID, ByVal ppTInfo As ITypeInfo Ptr Ptr)As HRESULT
	If ppTInfo = 0 Then
		Return E_INVALIDARG
	End If
	
	*ppTInfo = 0
	
	If iTInfo <> 0 Then
		Return DISP_E_BADINDEX
	End If
	
	Return S_OK
End Function

Function IrcClientGetIDsOfNames(ByVal This As IDispatch Ptr, ByVal riid As Const IID Const ptr, ByVal rgszNames As LPOLESTR Ptr, ByVal cNames As UINT, ByVal lcid As LCID, ByVal rgDispId As DISPID Ptr)As HRESULT
	If rgDispId = 0 Then
		Return E_INVALIDARG
	End If
	
	Dim SuccessFlag As Boolean = True
	
	If lstrcmpi(rgszNames[0], "ShowMessageBox") = 0 Then
		rgDispId[0] = ShowMessageBoxDispatchIndex
		
		For i As Integer = 1 To cNames - 1
			
			If lstrcmpi(rgszNames[i], "Param") = 0 Then
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

Function IrcClientInvoke(ByVal This As IDispatch Ptr, ByVal dispIdMember As DISPID, ByVal riid As Const IID Const Ptr, ByVal lcid As LCID, ByVal wFlags As WORD, ByVal pDispParams As DISPPARAMS Ptr, ByVal pVarResult As VARIANT Ptr, ByVal pExcepInfo As EXCEPINFO Ptr, ByVal puArgErr As UINT Ptr)As HRESULT
	
	If IsEqualIID(@IID_NULL, riid) = False Then
		Return DISP_E_UNKNOWNINTERFACE
	End If
	
	Select Case dispIdMember
		
		Case ShowMessageBoxDispatchIndex
			If pDispParams->cArgs + pDispParams->cNamedArgs <> ShowMessageBoxParametersCount Then
				Return DISP_E_BADPARAMCOUNT
			End If
			
			pVarResult->vt = VT_I4
			Return IrcClientShowMessageBox(CPtr(IrcClient Ptr, This), pDispParams->rgvarg[0].lVal, @pVarResult->lVal)
			
	End Select
	
	Return DISP_E_MEMBERNOTFOUND
End Function

Function IrcClientShowMessageBox(ByVal This As IrcClient Ptr, ByVal Param As Long, ByVal pResult As Long Ptr)As HRESULT
	If pResult = 0 Then
		Return E_INVALIDARG
	End If
	
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

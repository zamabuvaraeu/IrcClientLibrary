#ifndef IRCCLIENT_BI
#define IRCCLIENT_BI

#include once "IIrcClient.bi"

Type IrcClient
	Dim VirtualTable As IIrcClientVirtualTable Ptr
	
	Dim ReferenceCounter As DWORD
	
End Type

Declare Sub MakeIIrcClientVirtualTable()

Declare Function ConstructorIrcClient( _
)As IrcClient Ptr

Declare Sub DestructorIrcClient( _
	ByVal pIrcClient As IrcClient Ptr _
)

Declare Function IrcClientQueryInterface( _
	ByVal This As IDispatch Ptr, _
	ByVal riid As REFIID, _
	ByVal ppv As Any Ptr Ptr _
)As HRESULT

Declare Function IrcClientAddRef( _
	ByVal This As IDispatch Ptr _
)As ULONG

Declare Function IrcClientRelease( _
	ByVal This As IDispatch Ptr _
)As ULONG

Declare Function IrcClientGetTypeInfoCount( _
	ByVal This As IDispatch Ptr, _
	ByVal pctinfo As UINT Ptr _
)As HRESULT

Declare Function IrcClientGetTypeInfo( _
	ByVal This As IDispatch Ptr, _
	ByVal iTInfo As UINT, _
	ByVal lcid As LCID, _
	ByVal ppTInfo As ITypeInfo Ptr Ptr _
)As HRESULT

Declare Function IrcClientGetIDsOfNames( _
	ByVal This As IDispatch Ptr, _
	ByVal riid As Const IID Const ptr, _
	ByVal rgszNames As LPOLESTR Ptr, _
	ByVal cNames As UINT, _
	ByVal lcid As LCID, _
	ByVal rgDispId As DISPID Ptr _
)As HRESULT

Declare Function IrcClientInvoke( _
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

Declare Function IrcClientShowMessageBox( _
	ByVal This As IIrcClient Ptr, _
	ByVal Param As Long, _
	ByVal pResult As Long Ptr _
)As HRESULT

#endif

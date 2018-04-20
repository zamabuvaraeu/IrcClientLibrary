#ifndef IRCCLIENTCLASSFACTORY_BI
#define IRCCLIENTCLASSFACTORY_BI

#ifndef unicode
#define unicode
#endif

#include once "windows.bi"
#include once "win\objbase.bi"

Type IrcClientClassFactory
	Dim VirtualTable As IClassFactoryVtbl Ptr
	
	Dim ReferenceCounter As DWORD
	
End Type

Declare Sub MakeIClassFactoryVtbl()

Declare Function ConstructorClassFactory( _
)As IrcClientClassFactory Ptr

Declare Sub DestructorClassFactory( _
	ByVal pClassFactory As IrcClientClassFactory Ptr _
)

Declare Function ClassFactoryQueryInterface( _
	ByVal This As IClassFactory Ptr, _
	ByVal riid As REFIID, _
	ByVal ppv As Any Ptr Ptr _
)As HRESULT

Declare Function ClassFactoryAddRef( _
	ByVal This As IClassFactory Ptr _
)As ULONG

Declare Function ClassFactoryRelease( _
	ByVal This As IClassFactory Ptr _
)As ULONG

Declare Function ClassFactoryCreateInstance( _
	ByVal This As IClassFactory Ptr, _
	ByVal pUnknownOuter As IUnknown Ptr, _
	ByVal riid As REFIID, _
	ByVal ppv As Any Ptr Ptr _
)As HRESULT

Declare Function ClassFactoryLockServer( _
	ByVal This As IClassFactory Ptr, _
	ByVal fLock As BOOL _
)As HRESULT

#endif

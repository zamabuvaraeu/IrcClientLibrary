#ifndef IRCCLIENTCOMSERVER_BI
#define IRCCLIENTCOMSERVER_BI

#ifndef unicode
#define unicode
#endif

#include once "windows.bi"
#include once "win\olectl.bi"
#include once "win\psapi.bi"
#include once "win\shlwapi.bi"

Declare Function DllMain Alias "DllMain"( _
	ByVal hinstDLL As HINSTANCE, _
	ByVal fdwReason As DWORD, _
	ByVal lpvReserved As LPVOID _
)As Integer

#endif

#include "IrcClient.bi"
#include "StringConstants.bi"
#include "AppendingBuffer.bi"
#include "Network.bi"
#include "SendData.bi"
#include "ReceiveData.bi"

Declare Sub MakeConnectionString( _
	ByVal ConnectionString As WString Ptr, _
	ByVal Password As WString Ptr, _
	ByVal Nick As WString Ptr, _
	ByVal User As WString Ptr, _
	ByVal Description As WString Ptr, _
	ByVal Visible As Boolean _
)

Function OpenIrcClient( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal Server As WString Ptr, _
		ByVal Nick As WString Ptr _
	) As Boolean
	
	Return OpenIrcClient(pIrcClient, Server, "6667", "0.0.0.0", "", "", Nick, Nick, Nick, False)
End Function

Function OpenIrcClient( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal Server As WString Ptr, _
		ByVal Port As WString Ptr, _
		ByVal Nick As WString Ptr, _
		ByVal User As WString Ptr, _
		ByVal Description As WString Ptr _
	) As Boolean
	
	Return OpenIrcClient(pIrcClient, Server, Port, "0.0.0.0", "", "", Nick, User, Description, False)

End Function

Function OpenIrcClient( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal Server As WString Ptr, _
		ByVal Port As WString Ptr, _
		ByVal LocalServer As WString Ptr, _
		ByVal LocalPort As WString Ptr, _
		ByVal Password As WString Ptr, _
		ByVal Nick As WString Ptr, _
		ByVal User As WString Ptr, _
		ByVal Description As WString Ptr, _
		ByVal Visible As Boolean _
	)As Boolean
	
	pIrcClient->hEvent = CreateEvent(NULL, True, False, NULL)
	
	If pIrcClient->hEvent = NULL Then
		Return False
	End If
	
	If pIrcClient->CodePage = 0 Then
		pIrcClient->CodePage = CP_UTF8
	End If
	
	pIrcClient->ClientRawBufferLength = 0
	pIrcClient->ClientRawBuffer[0] = 0
	lstrcpy(@pIrcClient->ClientNick, Nick)
	
	Dim ConnectionString As WString * ((IrcClient.MaxBytesCount + 1) * 3) = Any
	MakeConnectionString(@ConnectionString, Password, Nick, User, Description, Visible)
	
	pIrcClient->ClientSocket = ConnectToServer(Server, Port, LocalServer, LocalPort)
	
	If pIrcClient->ClientSocket = INVALID_SOCKET Then
		Return False
	End If
	
	If SendData(pIrcClient, @ConnectionString) = False Then
		CloseSocketConnection(pIrcClient->ClientSocket)
		Return False
	End If
	
	Return StartRecvOverlapped(pIrcClient)
	
End Function

Sub CloseIrcClient( _
		ByVal pIrcClient As IrcClient Ptr _
	)
	
	CloseSocketConnection(pIrcClient->ClientSocket)
	pIrcClient->ClientSocket = INVALID_SOCKET
	SetEvent(pIrcClient->hEvent)
	CloseHandle(pIrcClient->hEvent)
	
End Sub

Function IrcClientStartup( _
		ByVal pIrcClient As IrcClient Ptr _
	)As HRESULT
	
	Dim objWsaData As WSAData = Any
	Dim dwError As Long = WSAStartup(MAKEWORD(2, 2), @objWsaData)
	If dwError <> NO_ERROR Then
		Return HRESULT_FROM_WIN32(dwError)
	End If
	
	Return S_OK
	
End Function

Function IrcClientCleanup( _
		ByVal pIIrcClient As IrcClient Ptr _
	)As HRESULT
	
	Dim dwError As Long = WSACleanup()
	If dwError <> NO_ERROR Then
		Return HRESULT_FROM_WIN32(dwError)
	End If
	
	Return S_OK
	
End Function

Sub MakeConnectionString( _
		ByVal ConnectionString As WString Ptr, _
		ByVal Password As WString Ptr, _
		ByVal Nick As WString Ptr, _
		ByVal User As WString Ptr, _
		ByVal Description As WString Ptr, _
		ByVal Visible As Boolean _
	)
		
	'PASS password
	'NICK Paul
	'USER paul 8 * :Paul Mutton
	
	Dim StringBuilder As AppendingBuffer = Type<AppendingBuffer>(ConnectionString, 0)
	
	If lstrlen(Password) <> 0 Then
		StringBuilder.AppendWString(@PassStringWithSpace, PassStringWithSpaceLength)
		StringBuilder.AppendWLine(Password)
	End If
	
	StringBuilder.AppendWString(@NickStringWithSpace, NickStringWithSpaceLength)
	StringBuilder.AppendWLine(Nick)
	
	StringBuilder.AppendWString(@UserStringWithSpace, UserStringWithSpaceLength)
	StringBuilder.AppendWString(User)
	
	If Visible Then
		StringBuilder.AppendWString(@DefaultBotNameSepVisible, DefaultBotNameSepVisibleLength)
	Else
		StringBuilder.AppendWString(@DefaultBotNameSepInvisible, DefaultBotNameSepInvisibleLength)
	End If
	
	If lstrlen(Description) = 0 Then
		StringBuilder.AppendWString(Nick)
	Else
		StringBuilder.AppendWString(Description)
	End If
End Sub

Function IrcClientStartReceiveDataLoop( _
		ByVal pIrcClient As IrcClient Ptr _
	)As HRESULT
	
	Dim dwWaitResult As DWORD = WaitForSingleObjectEx( _
		pIrcClient->hEvent, _
		IrcClient.TenMinutesInMilliSeconds, _
		TRUE _
	)
	Do
		
		Select Case dwWaitResult
			
			Case WAIT_ABANDONED
				Return E_FAIL
				
			' Case WAIT_IO_COMPLETION
				' Завершилась асинхронная процедура, продолжаем ждать
				
			Case WAIT_OBJECT_0
				' Объект События установлено, выходим
				Exit Do
				
			Case WAIT_TIMEOUT
				' Данные не пришли по таймауту, выходим
				Return E_FAIL
				
			Case WAIT_FAILED
				' Ошибка
				Return E_FAIL
				
		End Select
		
		dwWaitResult = WaitForSingleObjectEx( _
			pIrcClient->hEvent, _
			IrcClient.TenMinutesInMilliSeconds, _
			TRUE _
		)
	Loop While dwWaitResult <> WAIT_OBJECT_0
	
	Return S_OK
	
End Function

#include "IrcClient.bi"
#include "MakeConnectionString.bi"
#include "Network.bi"
#include "SendData.bi"
#include "ReceiveData.bi"

Const TenMinutesInMilliSeconds As DWORD = 10 * 60 * 1000

Function IrcClientOpenConnection( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal Server As WString Ptr, _
		ByVal Nick As WString Ptr _
	) As Boolean
	Return IrcClientOpenConnection(pIrcClient, Server, "6667", "0.0.0.0", "", "", Nick, Nick, Nick, False)
End Function

Function IrcClientOpenConnection( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal Server As WString Ptr, _
		ByVal Port As WString Ptr, _
		ByVal Nick As WString Ptr, _
		ByVal User As WString Ptr, _
		ByVal Description As WString Ptr _
	) As Boolean
	Return IrcClientOpenConnection(pIrcClient, Server, Port, "0.0.0.0", "", "", Nick, User, Description, False)
End Function

Function IrcClientOpenConnection( _
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
	
	pIrcClient->ReceiveBuffer.Buffer[0] = 0
	pIrcClient->ReceiveBuffer.Length = 0
	lstrcpy(@pIrcClient->ClientNick, Nick)
	
	Dim ConnectionString As WString * ((IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) * 3) = Any
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

Sub IrcClientCloseConnection( _
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

Function IrcClientStartReceiveDataLoop( _
		ByVal pIrcClient As IrcClient Ptr _
	)As HRESULT
	
	Dim dwWaitResult As DWORD = WaitForSingleObjectEx( _
		pIrcClient->hEvent, _
		TenMinutesInMilliSeconds, _
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
			TenMinutesInMilliSeconds, _
			TRUE _
		)
	Loop While dwWaitResult <> WAIT_OBJECT_0
	
	Return S_OK
	
End Function

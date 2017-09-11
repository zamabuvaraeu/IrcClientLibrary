#include once "Irc.bi"
#include once "StringConstants.bi"

Function IrcClient.OpenIrc( _
	ByVal Server As WString Ptr, _
	ByVal Nick As WString Ptr) As Boolean
	Return OpenIrc(Server, "6667", "", "", "", Nick, Nick, Nick, False)
End Function

Function IrcClient.OpenIrc( _
	ByVal Server As WString Ptr, _
	ByVal Port As WString Ptr, _
	ByVal Nick As WString Ptr, _
	ByVal User As WString Ptr, _
	ByVal Description As WString Ptr) As Boolean
	Return OpenIrc(Server, Port, "", "", "", Nick, User, Description, False)

End Function

Function IrcClient.OpenIrc(ByVal Server As WString Ptr, _
				ByVal Port As WString Ptr, _
				ByVal LocalServer As WString Ptr, _
				ByVal LocalPort As WString Ptr, _
				ByVal Password As WString Ptr, _
				ByVal Nick As WString Ptr, _
				ByVal User As WString Ptr, _
				ByVal Description As WString Ptr, _
				ByVal Visible As Boolean)As Boolean
	If CodePage = 0 Then
		CodePage = CP_UTF8
	End If
	
	m_Buffer[0] = 0
	m_BufferLength = 0
	lstrcpy(@m_Nick, Nick)
	
	' Создание строки подключения
	Dim strSendString As WString * (3 * MaxBytesCount + 1) = Any
	
	' Пароль на сервер
	If lstrlen(Password) = 0 Then
		' нужно установить нулевую длину, чтобы lstrcat работала правильно
		strSendString[0] = 0
	Else
		'PASS password
		lstrcat(lstrcat(lstrcpy(@strSendString, @PassStringWithSpace), Password), @NewLineString)
	End If
	
	' Строка подключения:
	'NICK Paul
	'USER paul 8 * :Paul Mutton
	lstrcat(lstrcat(lstrcat(lstrcat(lstrcat(lstrcat(lstrcat(@strSendString, _
		@NickStringWithSpace), Nick), @NewLineString), _
		@UserStringWithSpace), User), Iif(Visible, @DefaultBotNameSepVisible, @DefaultBotNameSepInvisible)), Iif(lstrlen(Description) = 0, Nick, Description))
	
	' Сокеты
	Dim objWsaData As WSAData = Any
	If WSAStartup(MAKEWORD(2, 2), @objWsaData) <> 0 Then
		' Return ResultType.WSAError
		Return False
	End If
	
	' Открыть сокет
	m_Socket = ConnectToServer(Server, Port, LocalServer, LocalPort)
	
	If m_Socket = INVALID_SOCKET Then
		' Return ResultType.SocketError
		Return False
	End If
	
	' Ожидать чтения данных с клиента 10 минут
	Dim ReceiveTimeOut As DWORD = 10 * 60 * 1000
	If setsockopt(m_Socket, SOL_SOCKET, SO_RCVTIMEO, CPtr(ZString Ptr, @ReceiveTimeOut), SizeOf(DWORD)) <> 0 Then
		CloseSocketConnection(m_Socket)
		' Return ResultType.SocketError
		Return False
	End If
	
	' Отправить строку подключения
	If SendData(@strSendString) = False Then
		CloseSocketConnection(m_Socket)
		Return False
	End If
	
	Return True
	
End Function

Sub IrcClient.CloseIrc()
	CloseSocketConnection(m_Socket)
	m_Socket = INVALID_SOCKET
	WSACleanup()
End Sub

Sub IrcClient.Run()
	Dim ReceiveBuffer As WString * (IrcClient.MaxBytesCount + 1) = Any
	Dim Result As Boolean = Any
	
	Do
		If ReceiveData(@ReceiveBuffer) = False Then
			Exit Sub
		End If
		Result = ParseData(@ReceiveBuffer)
	Loop While Result <> False
End Sub
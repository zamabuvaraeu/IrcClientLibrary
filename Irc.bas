#include once "Irc.bi"
#include once "StringConstants.bi"
#include once "AppendingBuffer.bi"

Const TenMinutesInMilliSeconds As DWORD = 10 * 60 * 1000

Sub MakeConnectionString( _
		ByVal ConnectionString As WString Ptr, _
		ByVal Password As WString Ptr, _
		ByVal Nick As WString Ptr, _
		ByVal User As WString Ptr, _
		ByVal Description As WString Ptr, _
		ByVal Visible As Boolean)
		
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

Function IrcClient.OpenIrc( _
		ByVal Server As WString Ptr, _
		ByVal Nick As WString Ptr) As Boolean
	
	Return OpenIrc(Server, "6667", "0.0.0.0", "", "", Nick, Nick, Nick, False)
End Function

Function IrcClient.OpenIrc( _
		ByVal Server As WString Ptr, _
		ByVal Port As WString Ptr, _
		ByVal Nick As WString Ptr, _
		ByVal User As WString Ptr, _
		ByVal Description As WString Ptr) As Boolean
	
	Return OpenIrc(Server, Port, "0.0.0.0", "", "", Nick, User, Description, False)

End Function

Function IrcClient.OpenIrc( _
		ByVal Server As WString Ptr, _
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
	
	ClientRawBuffer[0] = 0
	ClientRawBufferLength = 0
	lstrcpy(@ClientNick, Nick)
	
	Dim ConnectionString As WString * ((MaxBytesCount + 1) * 3) = Any
	MakeConnectionString(@ConnectionString, Password, Nick, User, Description, Visible)
	
	Dim objWsaData As WSAData = Any
	If WSAStartup(MAKEWORD(2, 2), @objWsaData) <> 0 Then
		Return False
	End If
	
	ClientSocket = ConnectToServer(Server, Port, LocalServer, LocalPort)
	
	If ClientSocket = INVALID_SOCKET Then
		Return False
	End If
	
	Dim ReceiveTimeOut As DWORD = TenMinutesInMilliSeconds
	If setsockopt(ClientSocket, SOL_SOCKET, SO_RCVTIMEO, CPtr(ZString Ptr, @ReceiveTimeOut), SizeOf(DWORD)) <> 0 Then
		CloseSocketConnection(ClientSocket)
		Return False
	End If
	
	If SendData(@ConnectionString) = False Then
		CloseSocketConnection(ClientSocket)
		Return False
	End If
	
	Return True
	
End Function

Sub IrcClient.CloseIrc()
	CloseSocketConnection(ClientSocket)
	ClientSocket = INVALID_SOCKET
	WSACleanup()
End Sub

Sub IrcClient.Run()
	Dim ServerResponse As WString * (IrcClient.MaxBytesCount + 1) = Any
	Dim Result As Boolean = Any
	
	Do
		If ReceiveData(@ServerResponse) = False Then
			Exit Sub
		End If
		Result = ParseData(@ServerResponse)
	Loop While Result
End Sub
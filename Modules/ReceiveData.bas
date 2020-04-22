#include "ReceiveData.bi"
#include "CharacterConstants.bi"
#include "ParseData.bi"
#include "Network.bi"

Declare Sub ReceiveCompletionROUTINE( _
	ByVal dwError As DWORD, _
	ByVal cbTransferred As DWORD, _
	ByVal lpOverlapped As LPWSAOVERLAPPED, _
	ByVal dwFlags As DWORD _
)

Function StartRecvOverlapped( _
		ByVal pIrcClient As IrcClient Ptr _
	)As Boolean
	
	Dim RecvBuf As WSABUF = Any
	RecvBuf.len = Cast(ULONG, IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - pIrcClient->ReceiveBuffer.Length)
	RecvBuf.buf = @pIrcClient->ReceiveBuffer.Buffer[pIrcClient->ReceiveBuffer.Length]
	
	ZeroMemory(@pIrcClient->RecvOverlapped, SizeOf(WSAOVERLAPPED))
	pIrcClient->RecvOverlapped.hEvent = pIrcClient
	
	Dim Flags As DWORD = 0
	
	Dim res As Long = WSARecv( _
		pIrcClient->ClientSocket, _
		@RecvBuf, _
		1, _
		NULL, _
		@Flags, _
		@pIrcClient->RecvOverlapped, _
		@ReceiveCompletionROUTINE _
	)
	If res <> 0 Then
		
		If WSAGetLastError() <> WSA_IO_PENDING Then
			IrcClientCloseConnection(pIrcClient)
			Return False
		End If
		
	End If
	
	Return True
	
End Function

Function FindCrLfA( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal pFindIndex As Integer Ptr _
	)As Boolean
	
	' Минус 2 потому что один байт под Lf и один, чтобы не выйти за границу
	For i As Integer = 0 To pIrcClient->ReceiveBuffer.Length - 2
		
		If pIrcClient->ReceiveBuffer.Buffer[i] = 13 AndAlso pIrcClient->ReceiveBuffer.Buffer[i + 1] = 10 Then
			*pFindIndex = i
			Return True
		End If
		
	Next
	
	*pFindIndex = 0
	Return False
	
End Function

Sub ReceiveCompletionROUTINE( _
		ByVal dwError As DWORD, _
		ByVal cbTransferred As DWORD, _
		ByVal lpOverlapped As LPWSAOVERLAPPED, _
		ByVal dwFlags As DWORD _
	)
	
	Dim pIrcClient As IrcClient Ptr = lpOverlapped->hEvent
	
	If dwError <> 0 Then
		IrcClientCloseConnection(pIrcClient)
		Exit Sub
	End If
	
	pIrcClient->ReceiveBuffer.Length += CInt(cbTransferred)
	pIrcClient->ReceiveBuffer.Buffer[pIrcClient->ReceiveBuffer.Length] = 0
	
	Dim CrLfIndex As Integer = Any
	Dim FindCrLfResult As Boolean = FindCrLfA(pIrcClient, @CrLfIndex)
	
	If FindCrLfResult = False Then
		
		If pIrcClient->ReceiveBuffer.Length >= IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM Then
			FindCrLfResult = True
			CrLfIndex = IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - 2
			pIrcClient->ReceiveBuffer.Length = IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM
		End If
		
	End If
	
	Do While FindCrLfResult
		pIrcClient->ReceiveBuffer.Buffer[CrLfIndex] = Characters.NullChar
		
		Dim ServerResponse As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
		Dim cbServerResponse As Long = MultiByteToWideChar( _
			pIrcClient->CodePage, _
			0, _
			@pIrcClient->ReceiveBuffer.Buffer, _
			-1, _
			@ServerResponse, _
			IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1 _
		)
		
		Dim NewBufferStartingIndex As Integer = CrLfIndex + 2
		
		If NewBufferStartingIndex = pIrcClient->ReceiveBuffer.Length Then
			pIrcClient->ReceiveBuffer.Buffer[0] = 0
			pIrcClient->ReceiveBuffer.Length = 0
		Else
			memmove(@pIrcClient->ReceiveBuffer.Buffer, @pIrcClient->ReceiveBuffer.Buffer[NewBufferStartingIndex], IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - NewBufferStartingIndex + 1)
			pIrcClient->ReceiveBuffer.Length -= NewBufferStartingIndex
		End If
		
		If CUInt(pIrcClient->lpfnReceivedRawMessageEvent) Then
			pIrcClient->lpfnReceivedRawMessageEvent(pIrcClient->AdvancedClientData, @ServerResponse)
		End If
		
		If ParseData(pIrcClient, @ServerResponse) = False Then
			IrcClientCloseConnection(pIrcClient)
			Exit Sub
		End If
		
		FindCrLfResult = FindCrLfA(pIrcClient, @CrLfIndex)
	Loop
	
	StartRecvOverlapped(pIrcClient)
	
End Sub

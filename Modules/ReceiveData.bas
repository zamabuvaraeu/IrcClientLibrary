#include "ReceiveData.bi"
#include "CharacterConstants.bi"
#include "StringConstants.bi"
#include "ParseData.bi"
#include "Network.bi"

Declare Function FindCrLfA( _
		ByVal Buffer As ZString Ptr, _
		ByVal BufferLength As Integer, _
		ByVal pIndex As Integer Ptr _
)As Boolean

Declare Sub ReceiveCompletionROUTINE( _
	ByVal dwError As DWORD, _
	ByVal cbTransferred As DWORD, _
	ByVal lpOverlapped As LPWSAOVERLAPPED, _
	ByVal dwFlags As DWORD _
)

Function FindCrLfA( _
		ByVal Buffer As ZString Ptr, _
		ByVal BufferLength As Integer, _
		ByVal pIndex As Integer Ptr _
	)As Boolean
	
	For i As Integer = 0 To BufferLength - NewLineStringLength
		If Buffer[i] = Characters.CarriageReturn AndAlso Buffer[i + 1] = Characters.LineFeed Then
			*pIndex = i
			Return True
		End If
	Next
	
	*pIndex = 0
	Return False
	
End Function

Function StartRecvOverlapped( _
		ByVal pIrcClient As IrcClient Ptr _
	)As HRESULT
	
	Const WsaBufBuffersCount As DWORD = 1
	Dim RecvBuf As WSABUF = Any
	RecvBuf.len = Cast(ULONG, IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - pIrcClient->ReceiveBuffer.Length)
	RecvBuf.buf = @pIrcClient->ReceiveBuffer.Buffer[pIrcClient->ReceiveBuffer.Length]
	
	ZeroMemory(@pIrcClient->RecvOverlapped, SizeOf(WSAOVERLAPPED))
	pIrcClient->RecvOverlapped.hEvent = pIrcClient
	
	Dim Flags As DWORD = 0
	
	Dim res As Long = WSARecv( _
		pIrcClient->ClientSocket, _
		@RecvBuf, _
		WsaBufBuffersCount, _
		NULL, _
		@Flags, _
		@pIrcClient->RecvOverlapped, _
		@ReceiveCompletionROUTINE _
	)
	If res <> 0 Then
		
		res = WSAGetLastError()
		If res <> WSA_IO_PENDING Then
			Return HRESULT_FROM_WIN32(res)
		End If
		
	End If
	
	Return S_OK
	
End Function

Sub ReceiveCompletionROUTINE( _
		ByVal dwError As DWORD, _
		ByVal cbTransferred As DWORD, _
		ByVal lpOverlapped As LPWSAOVERLAPPED, _
		ByVal dwFlags As DWORD _
	)
	
	Dim pIrcClient As IrcClient Ptr = lpOverlapped->hEvent
	
	If dwError <> 0 Then
		pIrcClient->ErrorCode = HRESULT_FROM_WIN32(dwError)
		SetEvent(pIrcClient->hEvent)
		Exit Sub
	End If
	
	pIrcClient->ReceiveBuffer.Length += CInt(cbTransferred)
	pIrcClient->ReceiveBuffer.Buffer[pIrcClient->ReceiveBuffer.Length] = 0
	
	Dim CrLfIndex As Integer = Any
	Dim FindCrLfResult As Boolean = FindCrLfA( _
		@pIrcClient->ReceiveBuffer.Buffer, _
		pIrcClient->ReceiveBuffer.Length, _
		@CrLfIndex _
	)
	
	If FindCrLfResult = False Then
		
		If pIrcClient->ReceiveBuffer.Length >= IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM Then
			FindCrLfResult = True
			CrLfIndex = IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - 2
			pIrcClient->ReceiveBuffer.Length = IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM
		End If
		
	End If
	
	Do While FindCrLfResult
		' pIrcClient->ReceiveBuffer.Buffer[CrLfIndex] = Characters.NullChar
		
		Scope
			Dim ServerResponse As ValueBSTR = Any
			Dim ServerResponseLength As Long = MultiByteToWideChar( _
				pIrcClient->CodePage, _
				0, _
				@pIrcClient->ReceiveBuffer.Buffer, _
				CrLfIndex, _
				@ServerResponse.WChars(0), _
				IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM _
			)
			
			If ServerResponseLength <> 0 Then
				ServerResponse.BytesCount = ServerResponseLength * SizeOf(OLECHAR)
				ServerResponse.WChars(CInt(ServerResponseLength)) = Characters.NullChar
				
				If CUInt(pIrcClient->lpfnReceivedRawMessageEvent) Then
					pIrcClient->lpfnReceivedRawMessageEvent(pIrcClient->AdvancedClientData, Cast(BSTR, ServerResponse))
				End If
				
				Dim hr As HRESULT = ParseData(pIrcClient, ServerResponse)
				If FAILED(hr) Then
					pIrcClient->ErrorCode = hr
					SetEvent(pIrcClient->hEvent)
					Exit Sub
				End If
			' Else
				''Ошибка
				' GetLastError()
			End If
		End Scope
		
		Scope
			Dim NewStartingIndex As Integer = CrLfIndex + 2
			
			If NewStartingIndex = pIrcClient->ReceiveBuffer.Length Then
				' pIrcClient->ReceiveBuffer.Buffer[0] = Characters.NullChar
				pIrcClient->ReceiveBuffer.Length = 0
			Else
				memmove( _
					@pIrcClient->ReceiveBuffer.Buffer, _
					@pIrcClient->ReceiveBuffer.Buffer[NewStartingIndex], _
					IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - NewStartingIndex + 1 _
				)
				pIrcClient->ReceiveBuffer.Length -= NewStartingIndex
			End If
		End Scope
		
		FindCrLfResult = FindCrLfA( _
			@pIrcClient->ReceiveBuffer.Buffer, _
			pIrcClient->ReceiveBuffer.Length, _
			@CrLfIndex _
		)
	Loop
	
	Dim hr As HRESULT = StartRecvOverlapped(pIrcClient)
	If FAILED(hr) Then
		pIrcClient->ErrorCode = hr
		SetEvent(pIrcClient->hEvent)
	End If
	
End Sub

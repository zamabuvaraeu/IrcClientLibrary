#include once "Irc.bi"
#include once "StringConstants.bi"

Function IrcClient.SendData(ByVal strData As WString Ptr)As Boolean
	' Ограничение на отправку в 510 символов из данных
	Dim SafeBuffer As WString * (MaxBytesCount + 1) = Any
	lstrcpyn(@SafeBuffer, strData, MaxBytesCount - 2)
	
	' Перекодируем в байты utf8
	Dim SendBuffer As ZString * (MaxBytesCount * 3 + 1) = Any
	Dim SendBufferLength As Integer = WideCharToMultiByte(CodePage, 0, @SafeBuffer, -1, @SendBuffer, (MaxBytesCount + 1), 0, 0) - 1
	
	' Добавляем перевод строки для данных
	SendBuffer[SendBufferLength] = 13
	SendBuffer[SendBufferLength + 1] = 10
	
	If send(m_Socket, @SendBuffer, SendBufferLength + 1, 0) = SOCKET_ERROR Then
		' Ошибка
		Return False
	End If
	
	' Лог сообщений
	If CInt(SendedRawMessageEvent) Then
		SendedRawMessageEvent(AdvancedClientData, strData)
	End If
	
	Return True
	
End Function
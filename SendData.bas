#include once "AsmIrc.bi"

' Отправка строки на сервер
Function IrcClient.SendData(ByVal strData As WString Ptr)As ResultType
	Dim SendBuffer As ZString * (MaxBytesCount + 1) = Any
	Dim strDataWithNewLine As WString * (MaxBytesCount + 1) = Any
	' Добавляем перевод строки для данных
	lstrcpy(@strDataWithNewLine, strData)
	lstrcat(@strDataWithNewLine, @NewLineString)
	
	' Перекодируем в байты utf8
	' Отправляем intBytesCount - 1, чтобы не отправлять нулевой символ в конце
	If send(m_Socket, @SendBuffer, WideCharToMultiByte(CP_UTF8, 0, @strDataWithNewLine, -1, @SendBuffer, (MaxBytesCount + 1), 0, 0) - 1, 0) = SOCKET_ERROR Then
		' Ошибка
		Return ResultType.SocketError
	Else
		' Лог сообщений
		If CInt(SendedRawMessageEvent) Then
			SendedRawMessageEvent(ExtendedData, strData)
		End If
		Return ResultType.None
	End If
End Function
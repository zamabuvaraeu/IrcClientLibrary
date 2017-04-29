#include once "Irc.bi"
#include once "windows.bi"
#include once "win\shlwapi.bi"

' Получение строки от сервера
Function IrcClient.ReceiveData(ByVal strReceiveData As WString Ptr)As ResultType
	' Ищем в буфере символы \r\n
	' Если они есть, то возвращаем строку до \r\n
	' иначе получаем данные, добавляя их в буфер, до тех пор, пока не появятся \r\n
	Dim wNewLine As WString Ptr = StrStr(@m_Buffer, @NewLineString)
	
	Do While wNewLine = 0
		' Проверить размер текущего накопительного буфера
		' Если он заполнен, то вернуть его весь
		Dim BufferLength As Integer = lstrlen(@m_Buffer)
		
		If BufferLength >= MaxBytesCount Then
			lstrcpy(strReceiveData, @m_Buffer)
			m_Buffer[0] = 0
			Exit Do
		Else
			' Получаем данные
			Dim ReceiveBuffer As ZString * (MaxBytesCount + 1) = Any
			Dim intReceivedBytesCount As Integer = recv(m_Socket, @ReceiveBuffer, MaxBytesCount - BufferLength, 0)
			
			If intReceivedBytesCount > 0 Then
				' Теперь валидная строка для винапи
				ReceiveBuffer[intReceivedBytesCount] = 0
				
				' Преобразуем utf8 в WString
				' -1 — значит, длина строки будет проверяться самой функцией по завершающему нулю
				Dim TempCodeReceiveBuffer As WString * (MaxBytesCount + 1) = Any
				MultiByteToWideChar(CP_UTF8, 0, @ReceiveBuffer, -1, TempCodeReceiveBuffer, MaxBytesCount + 1)
				
				' Добавляем их в буфер и ищем \r\n
				wNewLine = StrStr(lstrcat(@m_Buffer, TempCodeReceiveBuffer), @NewLineString)
			Else
				' Ошибка, так как должно быть как минимум 1 байт на блокирующем сокете
				Return ResultType.SocketError
			End If
		End If
	Loop
	
	' Поставить ноль там, где найдены \r\n
	If wNewLine <> 0 Then
		wNewLine[0] = 0
		' Возвращаем строку
		lstrcpy(strReceiveData, @m_Buffer)
		
		' Удаляем из буфера полученную строку вместе с символами переноса строки
		Dim tmpBuffer As WString * (MaxBytesCount + 1) = Any
		lstrcpy(@tmpBuffer, @wNewLine[2])
		lstrcpy(@m_Buffer, @tmpBuffer)
	End If
	
	' Лог сообщений
	If CInt(ReceivedRawMessageEvent) Then
		ReceivedRawMessageEvent(ExtendedData, strReceiveData)
	End If
	Return ResultType.None
End Function
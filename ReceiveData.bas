#include once "Irc.bi"
#include once "windows.bi"
#include once "win\shlwapi.bi"

Function IrcClient.FindCrLfA()As Integer
	' Минус 2 потому что один байт под Lf и один, чтобы не выйти за границу
	For i As Integer = 0 To m_BufferLength - 2
		If m_Buffer[i] = 13 AndAlso m_Buffer[i + 1] = 10 Then
			Return i
		End If
	Next
	Return -1
End Function

' Получение строки от сервера
Function IrcClient.ReceiveData(ByVal strReceiveData As WString Ptr)As ResultType
	' Ищем в буфере символы \r\n
	' Если они есть, то возвращаем строку до \r\n
	' иначе получаем данные, добавляя их в буфер, до тех пор, пока не появятся \r\n
	Dim CrLfIndex As Integer = FindCrLfA()
	
	Do While CrLfIndex = -1
		' Проверить размер текущего накопительного буфера
		' Если он заполнен, то вернуть его весь
		
		If m_BufferLength >= MaxBytesCount Then
			' Буфер заполнен, вернуть его весь
			CrLfIndex = MaxBytesCount
			m_BufferLength = MaxBytesCount
			Exit Do
		Else
			' Получаем данные
			Dim intReceivedBytesCount As Integer = recv(m_Socket, @m_Buffer + m_BufferLength, MaxBytesCount - m_BufferLength, 0)
			
			Select Case intReceivedBytesCount
				Case SOCKET_ERROR
					' Ошибка, так как должно быть как минимум 1 байт на блокирующем сокете
					strReceiveData[0] = 0
					Return ResultType.SocketError
				Case 0
					' Клиент закрыл соединение
					strReceiveData[0] = 0
					Return ResultType.SocketError
				Case Else
					' Увеличить размер буфера на количество принятых байт
					m_BufferLength += intReceivedBytesCount
					' Заключительный нулевой символ
					m_Buffer[m_BufferLength] = 0
			End Select
		End If
		' Снова ищем CrLf
		CrLfIndex = FindCrLfA()
	Loop
	
	' Поставить ноль там, где найдены \r\n
	m_Buffer[CrLfIndex] = 0
	
	' Вернуть строку
	MultiByteToWideChar(CodePage, 0, @m_Buffer, -1, strReceiveData, MaxBytesCount + 1)
	
	' Сдвинуть буфер влево
	If MaxBytesCount - CrLfIndex = 0 Then
		m_Buffer[0] = 0
		m_BufferLength = 0
	Else
		Dim NextCharIndex As Integer = CrLfIndex + 2
		memmove(@m_Buffer, @m_Buffer + NextCharIndex, MaxBytesCount - NextCharIndex + 1)
		m_BufferLength -= NextCharIndex
	End If
	
	' Лог сообщений
	If CInt(ReceivedRawMessageEvent) Then
		ReceivedRawMessageEvent(ExtendedData, strReceiveData)
	End If
	Return ResultType.None
End Function
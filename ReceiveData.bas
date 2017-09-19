#include once "Irc.bi"
#include once "windows.bi"
#include once "win\shlwapi.bi"

Function IrcClient.FindCrLfA()As Integer
	' Минус 2 потому что один байт под Lf и один, чтобы не выйти за границу
	For i As Integer = 0 To ClientRawBufferLength - 2
		If ClientRawBuffer[i] = 13 AndAlso ClientRawBuffer[i + 1] = 10 Then
			Return i
		End If
	Next
	Return -1
End Function

' Получение строки от сервера
Function IrcClient.ReceiveData(ByVal strReceiveData As WString Ptr)As Boolean
	' Ищем в буфере символы \r\n
	' Если они есть, то возвращаем строку до \r\n
	' иначе получаем данные, добавляя их в буфер, до тех пор, пока не появятся \r\n
	Dim CrLfIndex As Integer = FindCrLfA()
	
	Do While CrLfIndex = -1
		' Проверить размер текущего накопительного буфера
		' Если он заполнен, то вернуть его весь
		
		If ClientRawBufferLength >= MaxBytesCount Then
			' Буфер заполнен, вернуть его весь
			CrLfIndex = MaxBytesCount
			ClientRawBufferLength = MaxBytesCount
			Exit Do
		Else
			' Получаем данные
			Dim intReceivedBytesCount As Integer = recv(ClientSocket, @ClientRawBuffer + ClientRawBufferLength, MaxBytesCount - ClientRawBufferLength, 0)
			
			Select Case intReceivedBytesCount
				Case SOCKET_ERROR
					' Ошибка, так как должно быть как минимум 1 байт на блокирующем сокете
					strReceiveData[0] = 0
					Return False
				Case 0
					' Клиент закрыл соединение
					strReceiveData[0] = 0
					Return False
				Case Else
					' Увеличить размер буфера на количество принятых байт
					ClientRawBufferLength += intReceivedBytesCount
					' Заключительный нулевой символ
					ClientRawBuffer[ClientRawBufferLength] = 0
			End Select
		End If
		' Снова ищем CrLf
		CrLfIndex = FindCrLfA()
	Loop
	
	ClientRawBuffer[CrLfIndex] = 0
	
	MultiByteToWideChar(CodePage, 0, @ClientRawBuffer, -1, strReceiveData, MaxBytesCount + 1)
	
	' Сдвинуть буфер влево
	If MaxBytesCount - CrLfIndex = 0 Then
		ClientRawBuffer[0] = 0
		ClientRawBufferLength = 0
	Else
		Dim NextCharIndex As Integer = CrLfIndex + 2
		If NextCharIndex = ClientRawBufferLength Then
			ClientRawBuffer[0] = 0
			ClientRawBufferLength = 0
		Else
			memmove(@ClientRawBuffer, @ClientRawBuffer + NextCharIndex, MaxBytesCount - NextCharIndex + 1)
			ClientRawBufferLength -= NextCharIndex
		End If
	End If
	
	If CInt(ReceivedRawMessageEvent) Then
		ReceivedRawMessageEvent(AdvancedClientData, strReceiveData)
	End If
	
	Return True
End Function
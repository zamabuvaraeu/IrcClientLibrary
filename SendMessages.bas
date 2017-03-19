#include once "AsmIrc.bi"

' Смена ника
Public Function IrcClient.ChangeNick(ByVal Nick As WString Ptr)As ResultType
	Dim strSend As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strSend, @NickStringWithSpace)
	lstrcpy(@m_Nick, Nick)
	lstrcat(@strSend, Nick)
	Return SendData(@strSend)
End Function

' Присоединение к каналу
Public Function IrcClient.JoinChannel(ByVal strChannel As WString Ptr)As ResultType
	Dim strSend As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strSend, @JoinStringWithSpace)
	lstrcat(@strSend, strChannel)
	Return SendData(@strSend)
End Function

' Выход с канала
Public Function IrcClient.PartChannel(ByVal strChannel As WString Ptr, ByVal strMessageText As WString Ptr)As ResultType
	Dim strTemp As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strTemp, @PartStringWithSpace)
	lstrcat(@strTemp, strChannel)
	If lstrlen(strMessageText) <> 0 Then
		lstrcat(@strTemp, @SpaceWithCommaString)
		lstrcat(@strTemp, strMessageText)
	End If
	Return SendData(@strTemp)
End Function

' Выход из сети
Public Function IrcClient.QuitFromServer(ByVal strMessageText As WString Ptr)As ResultType
	Dim strTemp As WString * (MaxBytesCount + 1) = Any
	If lstrlen(strMessageText) = 0 Then
		lstrcpy(@strTemp, @QuitString)
	Else
		lstrcpy(@strTemp, @QuitStringWithSpace)
		lstrcat(@strTemp, strMessageText)
	End If
	Return SendData(@strTemp)
End Function

' Отправка сырого сообщения
Public Function IrcClient.SendRawMessage(ByVal strRawText As WString Ptr)As ResultType
	Return SendData(strRawText)
End Function

' Отправка сообщения
Public Function IrcClient.SendIrcMessage(ByVal strChannel As WString Ptr, ByVal strMessageText As WString Ptr)As ResultType
	Dim strTemp As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strTemp, @PrivateMessageWithSpace)
	lstrcat(@strTemp, strChannel)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, strMessageText)
	Return SendData(@strTemp)
End Function

Public Function IrcClient.ChangeTopic(ByVal strChannel As WString Ptr, ByVal strTopic As WString Ptr)As ResultType
	Dim strTemp As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strTemp, @TopicStringWithSpace)
	lstrcat(@strTemp, strChannel)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, strTopic)
	Return SendData(@strTemp)
End Function

' Отправка уведомления
Public Function IrcClient.SendNotice(ByVal strChannel As WString Ptr, ByVal strNoticeText As WString Ptr)As ResultType
	Dim strTemp As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strTemp, @NoticeStringWithSpace)
	lstrcat(@strTemp, strChannel)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, strNoticeText)
	Return SendData(@strTemp)
End Function

' Отправка CTCP-запроса
Public Function IrcClient.SendCtcpMessage(ByVal strChannel As WString Ptr, ByVal iType As CtcpMessageType, ByVal Param As WString Ptr)As ResultType
	Dim strTemp As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strTemp, @PrivateMessageWithSpace)
	lstrcat(@strTemp, strChannel)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, @SohString)
	Select Case iType
		Case CtcpMessageType.Ping
			lstrcat(@strTemp, @PingStringWithSpace)
			lstrcat(@strTemp, Param)
		Case CtcpMessageType.Time
			lstrcat(@strTemp, @TimeString)
		Case CtcpMessageType.UserInfo
			lstrcat(@strTemp, @UserInfoString)
		Case CtcpMessageType.Version
			lstrcat(@strTemp, @VersionString)
	End Select
	lstrcat(@strTemp, @SohString)
	Return SendData(@strTemp)
End Function

' Отправка CTCP-ответа
Public Function IrcClient.SendCtcpNotice(ByVal strChannel As WString Ptr, ByVal iType As CtcpMessageType, ByVal NoticeText As WString Ptr)As ResultType
	Dim strTemp As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strTemp, @NoticeStringWithSpace)
	lstrcat(@strTemp, strChannel)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, @SohString)
	Select Case iType
		Case CtcpMessageType.Ping
			lstrcat(@strTemp, @PingStringWithSpace)
		Case CtcpMessageType.Time
			lstrcat(@strTemp, @TimeStringWithSpace)
		Case CtcpMessageType.UserInfo
			lstrcat(@strTemp, @UserInfoStringWithSpace)
		Case CtcpMessageType.Version
			lstrcat(@strTemp, @VersionStringWithSpace)
	End Select
	lstrcat(@strTemp, NoticeText)
	lstrcat(@strTemp, @SohString)
	Return SendData(@strTemp)
End Function

#include once "Irc.bi"
#include once "StringConstants.bi"

' Получаем имя пользователя
Sub GetIrcUserName(ByVal strReturn As WString Ptr, ByVal strData As WString Ptr)
	':Qubick!~miranda@192.168.1.1 JOIN ##freebasic
	
	Dim Start As Integer = Any
	If strData[0] = ColonChar Then
		Start = 1
	Else
		Start = 0
	End If
	
	' Скопировать без учёта начального двоеточия
	lstrcpy(strReturn, @strData[Start])
	
	' Найти знак "!" и удалить
	Dim w As WString Ptr = StrChr(strReturn, ExclamationChar)
	If w <> 0 Then
		w[0] = 0
	End If
	
End Sub

' Получаем текст сообщения
Function GetIrcMessageText(ByVal strData As WString Ptr)As WString Ptr
	':Qubick!~miranda@192.168.1.1 PRIVMSG ##freebasic :Hello World
	Dim w As WString Ptr = StrChr(strData, ColonChar)
	If w = 0 Then
		Return 0
	Else
		Return w + 1
	End If
End Function

' Получаем имя сервера
Function GetIrcServerName(ByVal strData As WString Ptr)As WString Ptr
	' Вернуть строку после двоеточия
	Dim w As WString Ptr = StrChr(strData, ColonChar)
	If w = 0 Then
		Return 0
	Else
		Return w + 1
	End If
	
End Function

' Определяем первое слово сервера
Function GetServerWord(ByVal w As WString Ptr)As ServerWord
	If lstrcmp(w, @PingString) = 0 Then
		Return ServerWord.PingWord
	End If
	If lstrcmp(w, @PongString) = 0 Then
		Return ServerWord.PongWord
	End If
	If lstrcmp(w, @ErrorString) = 0 Then
		Return ServerWord.ErrorWord
	End If
	
	Return ServerWord.ElseWord
End Function

' Определяем команду
Function GetServerCommand(ByVal w As WString Ptr)As ServerCommand
	If lstrcmp(w, @PrivateMessage) = 0 Then
		Return ServerCommand.PrivateMessage
	End If
	If lstrcmp(w, @NoticeString) = 0 Then
		Return ServerCommand.Notice
	End If
	If lstrcmp(w, @JoinString) = 0 Then
		Return ServerCommand.Join
	End If
	If lstrcmp(w, @QuitString) = 0 Then
		Return ServerCommand.Quit
	End If
	If lstrcmp(w, @InviteString) = 0 Then
		Return ServerCommand.Invite
	End If
	If lstrcmp(w, @KickString) = 0 Then
		Return ServerCommand.Kick
	End If
	If lstrcmp(w, @ModeString) = 0 Then
		Return ServerCommand.Mode
	End If
	If lstrcmp(w, @NickString) = 0 Then
		Return ServerCommand.Nick
	End If
	If lstrcmp(w, @PartString) = 0 Then
		Return ServerCommand.Part
	End If
	If lstrcmp(w, @SQuitString) = 0 Then
		Return ServerCommand.SQuit
	End If
	If lstrcmp(w, @TopicString) = 0 Then
		Return ServerCommand.Topic
	End If
	
	Return ServerCommand.Server
End Function

' Определяем команду CTCP сообщения
Function GetCtcpCommand(ByVal w As WString Ptr)As CtcpMessageType
	If lstrcmp(w, @PingString) = 0 Then
		Return CtcpMessageType.Ping
	End If
	If lstrcmp(w, @UserInfoString) = 0 Then
		Return CtcpMessageType.UserInfo
	End If
	If lstrcmp(w, @TimeString) = 0 Then
		Return CtcpMessageType.Time
	End If
	If lstrcmp(w, @VersionString) = 0 Then
		Return CtcpMessageType.Version
	End If
	If lstrcmp(w, @ActionString) = 0 Then
		Return CtcpMessageType.Version
	End If
	Return CtcpMessageType.None
End Function

' Отделение слова нулевым символом и возвращение указателя на следующее слово
Function GetNextWord(ByVal wStart As WString Ptr)As WString Ptr
	' Найти первый пробел и удалить
	Dim ws As WString Ptr = StrChr(wStart, WhiteSpaceChar)
	If ws = 0 Then
		Return wStart
	End If
	
	ws[0] = 0
	Return ws + 1
End Function
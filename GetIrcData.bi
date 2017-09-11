Enum ServerWord
	PingWord
	PongWord
	ErrorWord
	ElseWord
End Enum

Enum ServerCommand
	PrivateMessage
	Notice
	Join
	Quit
	Invite
	Kick
	Mode
	Nick
	Part
	Topic
	SQuit
	Server
End Enum

' Тип сообщения CTCP
Enum CtcpMessageType
	None
	Ping
	Time
	UserInfo
	Version
	Action
	ClientInfo
	Echo
	Finger
	Utc
End Enum

' Получаем имя пользователя
Declare Sub GetIrcUserName(ByVal strReturn As WString Ptr, ByVal strData As WString Ptr)

' Получаем текст сообщения
Declare Function GetIrcMessageText(ByVal strData As WString Ptr)As WString Ptr

' Получаем имя сервера
Declare Function GetIrcServerName(ByVal strData As WString Ptr)As WString Ptr

' Определяем первое слово сервера
Declare Function GetServerWord(ByVal w As WString Ptr)As ServerWord

' Определяем команду
Declare Function GetServerCommand(ByVal w As WString Ptr)As ServerCommand

' Определяем команду CTCP сообщения
Declare Function GetCtcpCommand(ByVal w As WString Ptr)As CtcpMessageType

' Отделение слова нулевым символом и возвращение указателя на следующее слово
Declare Function GetNextWord(ByVal wStart As WString Ptr)As WString Ptr

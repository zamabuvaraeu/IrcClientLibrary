''
'' Библиотека для работы с IRC
''
#ifndef unicode
	#define unicode
#endif
#include once "windows.bi"
#include once "win\shellapi.bi"
#include once "win\shlwapi.bi"

#include once "Network.bi"

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

' Результат выполнения запроса приёма отправки данных
Enum ResultType
	' Ошибки нет
	None
	' Ошибка инициализации
	WSAError
	' Ошибка сети
	SocketError
	' Ошибка сервера
	ServerError
End Enum

' Клиент
Type IrcClient
	
	' Максимальная длина принимаемых данных в IRC
	Const MaxBytesCount As Integer = 512
	
	' Методы
	
	' Запуск соединения с сервером
	Declare Function OpenIrc(ByVal Server As WString Ptr, _
		ByVal Port As WString Ptr, _
		ByVal LocalServer As WString Ptr, _
		ByVal LocalPort As WString Ptr, _
		ByVal Password As WString Ptr, _
		ByVal Nick As WString Ptr, _
		ByVal User As WString Ptr, _
		ByVal Description As WString Ptr, _
		ByVal Visible As Boolean)As ResultType
	
	' Получение сообщения от сервера
	Declare Function ReceiveData(ByVal strReturnedString As WString Ptr)As ResultType
	' Разбираем полученные данные
	Declare Function ParseData(ByVal strData As WString Ptr)As ResultType
	
	' Закрытие соединения
	Declare Sub CloseIrc()
	
	' Отправка сообщения
	Declare Function SendIrcMessage(ByVal strChannel As WString Ptr, ByVal strMessageText As WString Ptr)As ResultType
	' Отправка уведомления
	Declare Function SendNotice(ByVal strChannel As WString Ptr, ByVal strNoticeText As WString Ptr)As ResultType
	' Смена темы
	Declare Function ChangeTopic(ByVal strChannel As WString Ptr, ByVal strTopic As WString Ptr)As ResultType
	' Выход из сети
	Declare Function QuitFromServer(ByVal strMessageText As WString Ptr)As ResultType
	' Смена ника
	Declare Function ChangeNick(ByVal Nick As WString Ptr)As ResultType
	' Присоединение к каналу
	Declare Function JoinChannel(ByVal strChannel As WString Ptr)As ResultType
	' Отсоединение от канала
	Declare Function PartChannel(ByVal strChannel As WString Ptr, ByVal strMessageText As WString Ptr)As ResultType
	' Отправка CTCP-запроса
	Declare Function SendCtcpMessage(ByVal strChannel As WString Ptr, ByVal iType As CtcpMessageType, ByVal Param As WString Ptr)As ResultType
	' Отправка CTCP-ответа
	Declare Function SendCtcpNotice(ByVal strChannel As WString Ptr, ByVal iType As CtcpMessageType, ByVal NoticeText As WString Ptr)As ResultType
	' Отправка сообщения PONG
	Declare Function SendPong(ByVal strServer As WString Ptr)As ResultType
	' Отправка сообщения PING
	Declare Function SendPing(ByVal strServer As WString Ptr)As ResultType
	' Отправка сырого сообщения
	Declare Function SendRawMessage(ByVal strRawText As WString Ptr)As ResultType

	' Поля
	
	' Дополнительное поле для хранения разной информации
	' Оно будет отправляться в псевдособытия
	Dim ExtendedData As Any Ptr
	
	' Кодировка
	Dim CodePage As Integer
	
	' Псевдособытия
	Dim SendedRawMessageEvent As Sub(ByVal AdvData As Any Ptr, ByVal MessageText As WString Ptr)
	Dim ReceivedRawMessageEvent As Sub(ByVal AdvData As Any Ptr, ByVal MessageText As WString Ptr)
	Dim ServerErrorEvent As Sub(ByVal AdvData As Any Ptr, ByVal Message As WString Ptr)
	Dim ServerMessageEvent As Sub(ByVal AdvData As Any Ptr, ByVal ServerCode As WString Ptr, ByVal MessageText As WString Ptr)
	Dim NoticeEvent As Sub(ByVal AdvData As Any Ptr, ByVal Channel As WString Ptr, ByVal NoticeText As WString Ptr)
	Dim ChannelMessageEvent As Sub(ByVal AdvData As Any Ptr, ByVal Channel As WString Ptr, ByVal User As WString Ptr, ByVal MessageText As WString Ptr)
	Dim PrivateMessageEvent As Sub(ByVal AdvData As Any Ptr, ByVal User As WString Ptr, ByVal MessageText As WString Ptr)
	Dim UserJoinedEvent As Sub(ByVal AdvData As Any Ptr, ByVal Channel As WString Ptr, ByVal UserName As WString Ptr)
	Dim UserLeavedEvent As Sub(ByVal AdvData As Any Ptr, ByVal Channel As WString Ptr, ByVal UserName As WString Ptr, ByVal MessageText As WString Ptr)
	Dim NickChangedEvent As Sub(ByVal AdvData As Any Ptr, ByVal OldNick As WString Ptr, ByVal NewNick As WString Ptr)
	Dim TopicEvent As Sub(ByVal AdvData As Any Ptr, ByVal Channel As WString Ptr, ByVal UserName As WString Ptr, ByVal Text As WString Ptr)
	Dim QuitEvent As Sub(ByVal AdvData As Any Ptr, ByVal UserName As WString Ptr, ByVal MessageText As WString Ptr)
	Dim KickEvent As Sub(ByVal AdvData As Any Ptr, ByVal AdminName As WString Ptr, ByVal Channel As WString Ptr, ByVal KickedUser As WString Ptr)
	Dim InviteEvent As Sub(ByVal AdvData As Any Ptr, ByVal FromuserName As WString Ptr, ByVal Channel As WString Ptr)
	Dim PingEvent As Sub(ByVal AdvData As Any Ptr, ByVal Server As WString Ptr)
	Dim PongEvent As Sub(ByVal AdvData As Any Ptr, ByVal Server As WString Ptr)
	Dim ModeEvent As Sub(ByVal AdvData As Any Ptr, ByVal AdminName As WString Ptr, ByVal Channel As WString Ptr, ByVal UserName As WString Ptr, ByVal Mode As WString Ptr)
	Dim CtcpMessageEvent As Sub(ByVal AdvData As Any Ptr, ByVal FromUser As WString Ptr, ByVal UserName As WString Ptr, ByVal MessageType As CtcpMessageType, ByVal Param As WString Ptr)
	Dim CtcpNoticeEvent As Sub(ByVal AdvData As Any Ptr, ByVal FromUser As WString Ptr, ByVal UserName As WString Ptr, ByVal MessageType As CtcpMessageType, ByVal MessageText As WString Ptr)
	
	' Отпавка строки на сервер
	Declare Function SendData(ByVal strData As WString Ptr)As ResultType
	' Поиск CrLf в накопительном буфере
	Declare Function FindCrLfA()As Integer
	
	' Инкапсуляция свойств
	
	' Ник пользователя
	Dim m_Nick As WString * (MaxBytesCount + 1)
	
	' Накопительный буфер приёма данных
	Dim m_Buffer As ZString * (MaxBytesCount + 1)
	Dim m_BufferLength As Integer
	Dim m_Socket As SOCKET
	
End Type

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

#ifndef unicode
	#define unicode
#endif
#include once "windows.bi"
#include once "win\winsock2.bi"
#include once "win\ws2tcpip.bi"

' Результат выполнения запроса приёма отправки данных
Public Enum ReadLineResultType
	' Ошибки нет
	None
	' Ошибка инициализации
	WSAError
	' Ошибка сети
	SocketError
	' Пользователь отменил данные
	UserCancel
	' Ошибка сервера
	ServerError
	' Переполнение буфера
	BufferOverFlow
End Enum

' Чтение строки от сервера размером MaxBytesCount
' m_Socket — сокет, откуда буду читать данные
' m_Buffer — накопительный буфер для сохранения промежуточного результата
' strReceiveData — строка, куда будут записаны данные
' Накопительный буфер и строка в юникоде

' Соединиться с сервером и вернуть сокет
Declare Function ConnectToServer(ByVal sServer As WString Ptr, ByVal ServiceName As WString Ptr, ByVal localServer As WString Ptr, ByVal LocalServiceName As WString Ptr)As SOCKET

' Создать сокет, привязанный к адресу
Declare Function CreateSocketAndBind(ByVal sServer As WString Ptr, ByVal ServiceName As WString Ptr)As SOCKET

' Создать прослушивающий сокет, привязанный к адресу
Declare Function CreateSocketAndListen(ByVal localServer As WString Ptr, ByVal ServiceName As WString Ptr)As SOCKET

' Закрывает сокет
Declare Sub CloseSocketConnection(ByVal mSock As SOCKET)

' Разрешение доменного имени
Declare Function ResolveHost(ByVal sServer As WString Ptr, ByVal ServiceName As WString Ptr)As addrinfoW Ptr

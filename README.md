﻿# IrcClientLibrary

Клиентская библиотека для работы с протоколом IRC. Инкапсулирует низкоуровневую работу с сокетами, приём и отправку сообщений, автоматические ответы на пинг от сервера. Пригодна для создания ботов, клиентских программ и мессенджеров для работы с IRC‐протоколом.

Библиотека использует синхронную событийную модель функций обратного вызова. Каждое пришедшее сообщение от сервера разбирается по шаблонам, вызывая соответствующие обработчики событий.

Функции библиотеки инкапсулированы в класс `IrcClient`.


## Компиляция

```Batch
fbc -lib Irc.bas SendData.bas ReceiveData.bas ParseData.bas GetIrcData.bas SendMessages.bas Network.bas AppendingBuffer.bas
```


## Быстрый старт

Этот пример показывает как легко создать соединение с сервером IRC, зайти на канал и отправить сообщение.

```FreeBASIC
#include once "Irc.bi"
#include once "IrcEvents.bi"
#include once "IrcReplies.bi"

Dim Shared Client As IrcClient
Client.PrivateMessageEvent = @IrcPrivateMessage

If Client.OpenIrc("chat.freenode.net", "LeoFitz") Then
	Client.JoinChannel("#freebasic-ru")
	Client.Run()
End If

Client.CloseIrc()

Sub IrcPrivateMessage(ByVal AdvData As Any Ptr, _
		ByVal User As WString Ptr, _
		ByVal MessageText As WString Ptr)
	
	Client.SendIrcMessage(UserName, "Yes, me too.")
End Sub
```


## Константы


### MaxBytesCount

Максимальное количество байт, которое можно отправить на сервер в одной строке.

```FreeBASIC
Const MaxBytesCount As Integer = 512
```

Необходимо помнить, что длина строки измеряется в символах, а размер одного символа не всегда равен одному байту. Для кодировки UTF-8 размер одного символа может быть от одного до шести байт.


### DefaultServerPort

Стандартный порт по умолчанию для соединения с сервером.

```FreeBASIC
Const DefaultServerPort As Integer = 6667
```


## Поля


### ExtendedData

Дополнительное поле для хранения указателя на любые данные. Этот указатель будет отправляться в каждом событии, генерируемом классом `IrcClient`.

```FreeBASIC
Dim ExtendedData As Any Ptr
```

### CodePage

Номер кодировочной таблицы, используемой для преобразования байт в строку.

```FreeBASIC
Dim CodePage As Integer
```

В стандарте IRC‐протокола не определено, каким образом строки будут преобразовываться в байты, эта задача возлагается на самого клиента. Клиент для преобразования строк использует кодировочную таблицу. Например: 65001 (UTF-8), 1251 (кодировка Windows для кириллицы), 866 (кодировка DOS для кириллицы), 20866 (KOI8-R), 21866 (KOI8-U).

Библиотека по умолчанию использует кодировку UTF-8, так как она позволяет представить всё множество символов юникода. Однако в ней длина одного символа может занимать от одного до шести байтов.

Нельзя использовать кодировки, в символах которых присутствуют нули. Например: 1200 (UTF-16), 1201 (UTF-16 BE). Нули в данном случае будут интерпретироваться как символ с кодом 0, что в большинстве случаев означает конец последовательности символов. IRC‐протокол накладывает ограничение на использование нулевого символа.


### ClientVersion

Версия используемой программы. Если установлена, то будет отправлена серверу на CTCP‐запрос `VERSION`.

```FreeBASIC
Dim ClientVersion As WString Ptr
```


### ClientUserInfo

Информация о пользователе. Если установлена, то будет отправлена серверу на CTCP‐запрос `USERINFO`.

```FreeBASIC
Dim ClientUserInfo As WString Ptr
```


## Методы


### OpenIrc

Открывает соединение с сервером.

```FreeBASIC
Declare Function OpenIrc( _
	ByVal Server As WString Ptr, _
	ByVal Port As WString Ptr, _
	ByVal LocalAddress As WString Ptr, _
	ByVal LocalPort As WString Ptr, _
	ByVal Password As WString Ptr, _
	ByVal Nick As WString Ptr, _
	ByVal User As WString Ptr, _
	ByVal Description As WString Ptr, _
	ByVal Visible As Boolean _
) As Boolean
```


#### Параметры

<dl>
<dt>Server</dt>
<dd>Имя сервера для соединения: доменное имя или IP‐адрес, например, chat.freenode.net.</dd>

<dt>Port</dt>
<dd>Строка, содержащая номер порта для соединения. Стандартный порт для IRC сети — 6667. Однако также доступны некоторые другие порты, на каждом из которых используется определённая кодировка для преобразования байт в строку. Необходимо смотреть в описании сервера на его официальном сайте.</dd>

<dt>LocalAddress</dt>
<dd>Локальный IP‐адрес, к которому будет привязан клиент и с которого будет идти соединение. Можно указать конкретный IP‐адрес сетевой карты, чтобы соединение шло через неё, или оставить пустой строкой, в таком случае операционная система сама выберет сетевую карту для подключения.</dd>

<dt>LocalPort</dt>
<dd>Локальный порт, к которому будет привязан клиент и с которго будет идти соединение. Если указан 0, то операционная система сама выберет свободный порт.</dd>

<dt>Password</dt>
<dd>Пароль на IRC‐сервер, если для соединения с сервером нужен пароль, иначе нужно оставить пустой строкой.</dd>

<dt>Nick</dt>
<dd>Ник (имя пользователя), не должен содержать пробелов и спец‐символов.</dd>

<dt>User</dt>
<dd>Строка‐идентификатор пользователя, обычно имя программы‐клиента, которым пользуются, не может содержать пробелов, не меняется в течение всего соединения.</dd>

<dt>Description</dt>
<dd>Описание пользователя, любые дополнительные данные, которые могут быть полезны, например, настоящие имя и фамилия пользователя, может содержать пробелы и спецсимволы, не меняется в течение всего соединения.</dd>

<dt>Visible</dt>
<dd>Флаг видимости для других пользователей. Если установлен в `True`, то пользователя можно будет найти командой WHO. Обычно все серверы устанавливают его в `False`.</dd>

</dl>


#### Описание

Если длина пароля на сервер равна нулю, то функция создаёт строку подключения вида:

```
NICK Paul
USER paul 8 * :Paul Mutton
```

Если пароль не пустой, то создаёт строку подключения вида:

```
PASS password
NICK Paul
USER paul 8 * :Paul Mutton
```

Затем инициализирует библиотеку сокетов функцией WSAStartup(), открывает соединение с сервером и отправляет строку подключения на сервер. Также функция устанавливает интервал ожидания чтения данных от сервера в течение десяти минут.


#### Возвращаемое значение

В случае успеха функция возвращает `True`, в случае ошибки возвращает `False`.

Если функция завершается ошибкой, то закрывать соединение не требуется.


### Run

Запускает цикл обработки данных от сервера, разбирает их по шаблону и вызывает события.

```FreeBASIC
Declare Sub Run()
```


#### Параметры

Функция не имеет параметров.


#### Описание

Функция разбирает строку по шаблону и вызывает следующие события:

* SendedRawMessageEvent
* ReceivedRawMessageEvent
* ServerErrorEvent
* ServerMessageEvent
* NoticeEvent
* ChannelMessageEvent
* PrivateMessageEvent
* UserJoinedEvent
* UserLeavedEvent
* NickChangedEvent
* TopicEvent
* QuitEvent
* KickEvent
* InviteEvent
* PingEvent
* PongEvent
* ModeEvent
* CtcpTimeRequestEvent
* CtcpUserInfoRequestEvent
* CtcpVersionRequestEvent
* CtcpActionEvent
* CtcpPingResponseEvent
* CtcpTimeResponseEvent
* CtcpUserInfoResponseEvent
* CtcpVersionResponseEvent

Функция самостоятельно обрабатывает сообщения `PING` и отправляет на него сообщения `PONG`. Если установлен обработчик события `PingEvent`, то обработкой сообщения `PING` клиент должен заниматься самостоятельно, вызывая функцию `SendPong`.

Цикл обработки сообщений прерывается когда получение данных от сервера завершается ошибкой.


#### Возвращаемое значение

Функция не возваращает значений.


### CloseIrc

Закрывает соединение с сервером.

```FreeBASIC
Declare Sub CloseIrc()
```


#### Параметры

Функция не имеет параметров.


#### Описание

Функция немедленно закрывает соединение с сервером, без отправки сообщения `QUIT` о выходе из сети и освобождает ресурсы библиотеки сокетов. Функцию `CloseIrc` рекомендуется вызывать при любых ошибках сети и для освобождения ресурсов библиотеки сокетов.


#### Возвращаемое значение

Функция не возвращает значений.


### SendIrcMessage

Отправляет сообщение на канал или пользователю.

```FreeBASIC
Declare Function SendIrcMessage( _
	ByVal Channel As WString Ptr, _
	ByVal MessageText As WString Ptr _
) As Boolean
```


#### Параметры

<dl>
<dt>Channel</dt>
<dd>Имя пользователя или канал. Если указан канал, то сообщение получат все пользователи, сидящие на канале. Если указано имя пользователя, то сообщение получит только этот пользователь.</dd>

<dt>MessageText</dt>
<dd>Текст сообщения</dd>
</dl>


#### Описание

Функция создаёт строку вида:

```
PRIVMSG target :Message Text
```

Где `target` — это канал или имя пользователя. Эта строка преобразуется в массив байт в соответствии с текущей кодировкой и отправляется на сервер.


#### Возвращаемое значение

В случае успеха функция возвращает `True`, в случае ошибки возвращает `False`.


### SendNotice

Отправляет уведомление пользователю.

```FreeBASIC
Declare Function SendNotice( _
	ByVal Channel As WString Ptr, _
	ByVal NoticeText As WString Ptr _
) As Boolean
```

#### Параметры

<dl>
<dt>Channel</dt>
<dd>Имя пользователя, получателя уведомления.</dd>

<dt>NoticeText</dt>
<dd>Текст уведомления.</dd>
</dl>


#### Описание

Функция создаёт строку вида:

```
NOTICE target :Notice Text
```

Где `target` — это имя пользователя. Эта строка преобразуется в массив байт в соответствии с текущей кодировкой и отправляется на сервер.

Уведомление аналогично сообщению с тем отличием, что на него не следует отвечать автоматически.


#### Возвращаемое значение

В случае успеха функция возвращает `True`, в случае ошибки возвращает `False`.


### ChangeTopic

Устанавливает, удаляет или получает тему канала.

```FreeBASIC
Declare Function ChangeTopic( _
	ByVal Channel As WString Ptr, _
	ByVal TopicText As WString Ptr _
) As Boolean
```


#### Параметры

<dl>
<dt>Channel</dt>
<dd>Канал для установки или запроса темы.</dd>

<dt>TopicText</dt>
<dd>Текст темы.</dd>
</dl>


#### Описание

Если `TopicText` — нулевой указатель `NULL`, то на сервер отправляется строка:

```
Topic
```

В ответ сервер отправит тему канала. Сервер ответит кодами `RPL_TOPIC`, если тема существует, или `RPL_NOTOPIC`, если тема не установлена.

Если `TopicText` — указатель на пустую строку, на сервер отправляется строка:

```
Topic :
```

В этом случае сервер удалит тему канала.

Иначе на сервер отправляется строка:

```
Topic :TopicText
```

В этом случае сервер установит тему канала, указанную в `TopicText`.


#### Возвращаемое значение

В случае успеха функция возвращает `True`, в случае ошибки возвращает `False`.


### QuitFromServer

Отправляет на сервер сообщение о выходе, что вынуждает сервер закрыть соединение.

```FreeBASIC
Declare Function QuitFromServer( _
	ByVal MessageText As WString Ptr _
) As Boolean
```


#### Параметры

<dl>
<dt>MessageText</dt>
<dd>Текст прощального сообщения.</dd>
</dl>


#### Описание

Если длина прощального сообщения равна нулю, то функция отправляет на сервер строку:

```
QUIT
```

Иначе функция отправляет строку

```
QUIT :Прощальное сообщение
```

Это вынуждает сервер закрыть соединение с клиентом.


#### Возвращаемое значение

В случае успеха функция возвращает `True`, в случае ошибки возвращает `False`.


### ChangeNick

Меняет ник пользователя.

```FreeBASIC
Declare Function ChangeNick( _
	ByVal Nick As WString Ptr _
) As Boolean
```


#### Параметры

<dl>
<dt>Nick</dt>
<dd>Новый ник.</dd>
</dl>


### Описание

Функция отправляет на сервер строку:

```
NICK новый ник
```


#### Возвращаемое значение

В случае успеха функция возвращает `True`, в случае ошибки возвращает `False`.


### JoinChannel

Присоединяет к каналу или каналам.

```
Declare Function JoinChannel( _
	ByVal Channel As WString Ptr _
) As Boolean
```


#### Параметры

<dl>
<dt>Channel</dt>
<dd>Список каналов, разделённый запятыми без пробелов. Если на канале установлен пароль, то через пробел указываются пароли для входа, разделённые запятыми без пробелов.</dd>
</dl>


#### Описание

Функция отправляет на сервер строку:

```
JOIN channel
```

#### Пример

```FreeBASIC
' Присоединение к каналам
Client.JoinChannel("#freebasic,#freebasic-ru")

' Присоединение к каналам с указанием для первого канала пароля
Client.JoinChannel("#freebasic,#freebasic-ru password1")
```


#### Возвращаемое значение

В случае успеха функция возвращает `True`, в случае ошибки возвращает `False`.


### PartChannel

Отключает от канала.

```
Declare Function PartChannel( _
	ByVal Channel As WString Ptr, _
	ByVal MessageText As WString Ptr _
) As Boolean
```


#### Параметры

<dl>
<dt>Channel</dt>
<dd>Канал для выхода.</dd>

<dt>MessageText</dt>
<dd>Текст прощального сообщения.</dd>
</dl>


#### Описание

Функция отправляет на сервер строку:

```
PART channel: прощальное сообщение
```

Это вынуждает сервер отсоединить пользователя от канала.


#### Возвращаемое значение

В случае успеха функция возвращает `True`, в случае ошибки возвращает `False`.


### SendCtcpPingRequest

Отправляет CTCP‐запрос PING.

```
Declare Function SendCtcpPingRequest( _
	ByVal UserName As WString Ptr, _
	ByVal TimeValue As WString Ptr _
) As Boolean
```


#### Параметры

<dl>
<dt>UserName</dt>
<dd>Имя пользователя, у которого запрашивают PING.</dd>

<dt>TimeValue</dt>
<dd>Текущее время.</dd>
</dl>

#### Описание

Функция отправляет на сервер строку:

```
PRIVMSG UserName: PING TimeValue
```

Это вынуждает сервер отсоединить пользователя от канала.


#### Возвращаемое значение

В случае успеха функция возвращает `True`, в случае ошибки возвращает `False`.





### SendCtcpNotice

Отправляет ответ на CTCP запрос. Эту функцию обычно вызывают в событии `f`.

Параметры:

`strChannel` — получатель сообщения: имя канала канала или пользователя.

`iType` — тип сообщения.

`NoticeText` — текст ответа.


#### iType

Может принимать одно из следующих значений:

`Ping` — ответ на PING пользователя. В `NoticeText` необходимо число, которое пришло.

`Time` — запрашивается локальное время пользователя. В `NoticeText` необходимо отправить локальное время пользователя.

`UserInfo` — запрашивается информация о пользователе. В `NoticeText` необходимо указать данные пользователя.

`Version` — запрашивается версия клиента. В `NoticeText` необходимо указать версию программы.

В случае успеха функция возвращает значение `ResultType.None`, в случае ошибки возвращает код ошибки.
	






Declare Function SendCtcpPingRequest( _
	ByVal UserName As WString Ptr, _
	ByVal TimeValue As WString Ptr _
) As Boolean

Declare Function SendCtcpTimeRequest( _
	ByVal UserName As WString Ptr _
) As Boolean

Declare Function SendCtcpUserInfoRequest( _
	ByVal UserName As WString Ptr _
) As Boolean

Declare Function SendCtcpVersionRequest( _
	ByVal UserName As WString Ptr _
) As Boolean

Declare Function SendCtcpAction( _
	ByVal UserName As WString Ptr, _
	ByVal MessageText As WString Ptr _
) As Boolean

Declare Function SendCtcpPingResponse( _
	ByVal UserName As WString Ptr, _
	ByVal TimeValue As WString Ptr _
) As Boolean

Declare Function SendCtcpTimeResponse( _
	ByVal UserName As WString Ptr, _
	ByVal TimeValue As WString Ptr _
) As Boolean

Declare Function SendCtcpUserInfoResponse( _
	ByVal UserName As WString Ptr, _
	ByVal UserInfo As WString Ptr _
) As Boolean

Declare Function SendCtcpVersionResponse( _
	ByVal UserName As WString Ptr, _
	ByVal Version As WString Ptr _
) As Boolean





















### SendPing

Отправляет сообщение PING.

Параметры:

`strServer` — сервер, к которому подключён клиент.

На сообщение PING сервер ответит сообщением PONG.

В случае успеха функция возвращает значение `ResultType.None`, в случае ошибки возвращает код ошибки.



















### SendPong

Отправляет сообщение PONG.

Параметры:

`strServer` — сервер, к которому подключён клиент.

Сервер отправляет сообщения PING для проверки подключённости пользователя. Если пользователь вовремя не ответит сообщением PONG, то сервер закроет соединение. Обычно отправка PONG вручную не требуется, так как это берёт на себя библиотека.

В случае успеха функция возвращает значение `ResultType.None`, в случае ошибки возвращает код ошибки.






























### SendRawMessage

Отправляет данные на сервер как они есть.

```
Declare Function SendRawMessage( _
	ByVal RawText As WString Ptr _
) As Boolean
```

#### Параметры

<dl>
<dt>RawText</dt>
<dd>Данные.</dd>
</dl>


#### Описание

Функция отправляет данные на сервер без обработки. Используется в тех случаях, когда стандартные функции отправки сообщений не подходят.


#### Возвращаемое значение

В случае успеха функция возвращает `True`, в случае ошибки возвращает `False`.























	
## События

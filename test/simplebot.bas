#include "IrcClient.bi"

Dim Shared Client As IrcClient

Sub OnIrcPrivateMessage( _
		ByVal ClientData As LPCLIENTDATA, _
		ByVal pIrcPrefix As LPIRCPREFIX, _
		ByVal MessageText As BSTR _
	)
	IrcClientSendPrivateMessage(@Client, pIrcPrefix->Nick, SysAllocString("Да, я тоже."))
End Sub

Client.Events.lpfnPrivateMessageEvent = @OnIrcPrivateMessage

IrcClientOpenConnectionSimple1(@Client, SysAllocString("chat.freenode.net"), SysAllocString("LeoFitz"))
IrcClientJoinChannel(@Client, SysAllocString("#freebasic-ru"))

IrcClientStartReceiveDataLoop(@Client)

IrcClientCloseConnection(@Client)

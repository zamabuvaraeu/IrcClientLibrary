#include "IrcClient.bi"

Sub OnIrcPrivateMessage( _
		ByVal ClientData As LPCLIENTDATA, _
		ByVal pIrcPrefix As LPIRCPREFIX, _
		ByVal MessageText As LPWSTR _
	)
	IrcClientSendIrcMessage(CPtr(IrcClient Ptr, ClientData), pIrcPrefix->Nick, "Да, я тоже.")
End Sub

Sub OnRawMessage( _
		ByVal ClientData As LPCLIENTDATA, _
		ByVal MessageText As LPWSTR _
	)
	Print *MessageText
End Sub

Dim Client As IrcClient
Client.AdvancedClientData = @Client
Client.lpfnPrivateMessageEvent = @OnIrcPrivateMessage
Client.lpfnReceivedRawMessageEvent = @OnRawMessage
Client.lpfnSendedRawMessageEvent = @OnRawMessage

Dim hr As HRESULT = IrcClientStartup(@Client)
If FAILED(hr) Then
	Print HEX(hr)
	End(1)
End If

If IrcClientOpenConnection(@Client, "chat.freenode.net", "LeoFitz") Then
	IrcClientJoinChannel(@Client, "#freebasic-ru")
	IrcClientStartReceiveDataLoop(@Client)
	IrcClientCloseConnection(@Client)
End If

IrcClientCleanup(@Client)

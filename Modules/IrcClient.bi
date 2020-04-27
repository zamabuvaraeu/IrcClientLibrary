#ifndef BATCHEDFILES_IRCCLIENT_IRCCLIENT_BI
#define BATCHEDFILES_IRCCLIENT_IRCCLIENT_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "win\shlwapi.bi"
#include "win\winsock2.bi"
#include "win\ws2tcpip.bi"
#include "IrcPrefix.bi"

Type LPCLIENTDATA As Any Ptr

Type OnSendedRawMessageEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal MessageText As LPWSTR)
Type OnReceivedRawMessageEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal MessageText As LPWSTR)
Type OnServerErrorEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal Message As LPWSTR)
Type OnServerMessageEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal IrcCommand As LPWSTR, ByVal MessageText As LPWSTR)
Type OnNoticeEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal NoticeText As LPWSTR)
Type OnChannelNoticeEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal Channel As LPWSTR, ByVal NoticeText As LPWSTR)
Type OnChannelMessageEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal Channel As LPWSTR, ByVal MessageText As LPWSTR)
Type OnPrivateMessageEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal MessageText As LPWSTR)
Type OnUserJoinedEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal Channel As LPWSTR)
Type OnUserLeavedEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal Channel As LPWSTR, ByVal MessageText As LPWSTR)
Type OnNickChangedEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal NewNick As LPWSTR)
Type OnTopicEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal Channel As LPWSTR, ByVal TopicText As LPWSTR)
Type OnQuitEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal MessageText As LPWSTR)
Type OnKickEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal Channel As LPWSTR, ByVal KickedUser As LPWSTR)
Type OnInviteEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal ToUser As LPWSTR, ByVal Channel As LPWSTR)
Type OnPingEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal Server As LPWSTR)
Type OnPongEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal Server As LPWSTR)
Type OnModeEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal Channel As LPWSTR, ByVal Mode As LPWSTR, ByVal UserName As LPWSTR)
Type OnCtcpPingRequestEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal ToUser As LPWSTR, ByVal TimeValue As LPWSTR)
Type OnCtcpTimeRequestEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal ToUser As LPWSTR)
Type OnCtcpUserInfoRequestEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal ToUser As LPWSTR)
Type OnCtcpVersionRequestEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal ToUser As LPWSTR)
Type OnCtcpActionEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal ToUser As LPWSTR, ByVal ActionText As LPWSTR)
Type OnCtcpPingResponseEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal ToUser As LPWSTR, ByVal TimeValue As LPWSTR)
Type OnCtcpTimeResponseEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal ToUser As LPWSTR, ByVal TimeValue As LPWSTR)
Type OnCtcpUserInfoResponseEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal ToUser As LPWSTR, ByVal UserInfo As LPWSTR)
Type OnCtcpVersionResponseEvent As Sub(ByVal ClientData As LPCLIENTDATA, ByVal pIrcPrefix As LPIRCPREFIX, ByVal ToUser As LPWSTR, ByVal Version As LPWSTR)

Const IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM As Integer = 512
Const IRCPROTOCOL_NICKLENGTHMAXIMUM As Integer = 16
Const IRCPROTOCOL_CHANNELNAMELENGTHMAXIMUM As Integer = 50
Const IRCPROTOCOL_DEFAULTPORT As Integer = 6667
Const DefaultLocalServer = "0.0.0.0"
Const DefaultLocalPort = 0

Const IRCPROTOCOL_MODEFLAG_WALLOPS As Long =       &b0000000000000100 ' w
Const IRCPROTOCOL_MODEFLAG_INVISIBLE As Long =     &b0000000000001000 ' i
Const IRCPROTOCOL_MODEFLAG_AWAY As Long =          &b0000000000010000 ' a
Const IRCPROTOCOL_MODEFLAG_RESTRICTED As Long =    &b0000000000100000 ' r
Const IRCPROTOCOL_MODEFLAG_OPERATOR As Long =      &b0000000001000000 ' o
Const IRCPROTOCOL_MODEFLAG_LOCALOPERATOR As Long = &b0000000010000000 ' O
Const IRCPROTOCOL_MODEFLAG_SERVERNOTICES As Long = &b0000000100000000 ' s

Type _RawBuffer
	Dim Buffer As ZString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM)
	Dim Length As Integer
End Type

Type RawBuffer As _RawBuffer

Type LPRAWBUFFER As _RawBuffer Ptr

Type _CWSTRLength
	Dim Length As Long
	Dim lpCData As LPCWSTR
End Type

Type CWSTRLength As _CWSTRLength

Type LPCWSTRLength As _CWSTRLength Ptr

Type _WSTRLength
	Dim Length As Long
	Dim lpData As LPWSTR
End Type

Type WSTRLength As _WSTRLength

Type LPWSTRLength As _WSTRLength Ptr

Type _IrcClient
	
	Dim RecvOverlapped As WSAOVERLAPPED
	Dim hEvent As HANDLE
	Dim hHeap As HANDLE
	Dim ClientSocket As SOCKET
	Dim ErrorCode As HRESULT
	Dim ReceiveBuffer As RawBuffer
	
	Dim ClientNick As WString * (IRCPROTOCOL_NICKLENGTHMAXIMUM + 1)
	Dim ClientVersion As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1)
	Dim ClientVersionLength As Integer
	Dim ClientUserInfo As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1)
	Dim ClientUserInfoLength As Integer
	Dim CodePage As Integer
	Dim AdvancedClientData As LPCLIENTDATA
	Dim lpfnSendedRawMessageEvent As OnSendedRawMessageEvent
	Dim lpfnReceivedRawMessageEvent As OnReceivedRawMessageEvent
	Dim lpfnServerErrorEvent As OnServerErrorEvent
	Dim lpfnServerMessageEvent As OnServerMessageEvent
	Dim lpfnNoticeEvent As OnNoticeEvent
	Dim lpfnChannelNoticeEvent As OnChannelNoticeEvent
	Dim lpfnChannelMessageEvent As OnChannelMessageEvent
	Dim lpfnPrivateMessageEvent As OnPrivateMessageEvent
	Dim lpfnUserJoinedEvent As OnUserJoinedEvent
	Dim lpfnUserLeavedEvent As OnUserLeavedEvent
	Dim lpfnNickChangedEvent As OnNickChangedEvent
	Dim lpfnTopicEvent As OnTopicEvent
	Dim lpfnQuitEvent As OnQuitEvent
	Dim lpfnKickEvent As OnKickEvent
	Dim lpfnInviteEvent As OnInviteEvent
	Dim lpfnPingEvent As OnPingEvent
	Dim lpfnPongEvent As OnPongEvent
	Dim lpfnModeEvent As OnModeEvent
	Dim lpfnCtcpPingRequestEvent As OnCtcpPingRequestEvent
	Dim lpfnCtcpTimeRequestEvent As OnCtcpTimeRequestEvent
	Dim lpfnCtcpUserInfoRequestEvent As OnCtcpUserInfoRequestEvent
	Dim lpfnCtcpVersionRequestEvent As OnCtcpVersionRequestEvent
	Dim lpfnCtcpActionEvent As OnCtcpActionEvent
	Dim lpfnCtcpPingResponseEvent As OnCtcpPingResponseEvent
	Dim lpfnCtcpTimeResponseEvent As OnCtcpTimeResponseEvent
	Dim lpfnCtcpUserInfoResponseEvent As OnCtcpUserInfoResponseEvent
	Dim lpfnCtcpVersionResponseEvent As OnCtcpVersionResponseEvent
	
End Type

Type IrcClient As _IrcClient

Type LPIRCCLIENT As _IrcClient Ptr

#define IrcClientOpenConnectionSimple1(pIrcClient, Server, Nick) IrcClientOpenConnection((pIrcClient), (Server), IRCPROTOCOL_DEFAULTPORT, @DefaultLocalServer, DefaultLocalPort, NULL, (Nick), (Nick), IRCPROTOCOL_MODEFLAG_INVISIBLE, (Nick))
#define IrcClientOpenConnectionSimple2(pIrcClient, Server, Port, Nick, User, RealName) IrcClientOpenConnection((pIrcClient), (Server), (Port), @DefaultLocalServer, DefaultLocalPort, NULL, (Nick), (User), IRCPROTOCOL_MODEFLAG_INVISIBLE, (RealName))

Declare Function IrcClientStartup( _
	ByVal pIrcClient As IrcClient Ptr _
)As HRESULT

Declare Function IrcClientCleanup( _
	ByVal pIIrcClient As IrcClient Ptr _
)As HRESULT

Declare Function IrcClientOpenConnection( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Server As LPCWSTR, _
	ByVal Port As Integer, _
	ByVal LocalAddress As LPCWSTR, _
	ByVal LocalPort As Integer, _
	ByVal Password As LPCWSTR, _
	ByVal Nick As LPCWSTR, _
	ByVal User As LPCWSTR, _
	ByVal ModeFlags As Long, _
	ByVal RealName As LPCWSTR _
)As HRESULT

Declare Sub IrcClientCloseConnection( _
	ByVal pIrcClient As IrcClient Ptr _
)

Declare Function IrcClientStartReceiveDataLoop( _
	ByVal pIrcClient As IrcClient Ptr _
)As HRESULT

Declare Function IrcClientMsgStartReceiveDataLoop( _
	ByVal pIrcClient As IrcClient Ptr _
)As HRESULT

Declare Function IrcClientSendPrivateMessage Overload( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal MessageTarget As LPCWSTR, _
	ByVal MessageText As LPCWSTR _
)As HRESULT

Declare Function IrcClientSendPrivateMessage Overload( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal MessageTarget As LPCWSTRLength, _
	ByVal MessageText As LPCWSTRLength _
)As HRESULT

Declare Function IrcClientSendNotice( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal MessageTarget As LPCWSTR, _
	ByVal NoticeText As LPCWSTR _
)As HRESULT

Declare Function IrcClientChangeTopic( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Channel As LPCWSTR, _
	ByVal TopicText As LPCWSTR _
)As HRESULT


#define IrcClientQuitFromServerSimple(pIrcClient) IrcClientQuitFromServer((pIrcClient), NULL)

Declare Function IrcClientQuitFromServer( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal QuitText As LPCWSTR _
)As HRESULT

Declare Function IrcClientChangeNick( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Nick As LPCWSTR _
)As HRESULT

Declare Function IrcClientJoinChannel( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Channel As LPCWSTR _
)As HRESULT

#define IrcClientPartChannelSimple(pIrcClient) IrcClientPartChannel((pIrcClient), NULL)

Declare Function IrcClientPartChannel( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Channel As LPCWSTR, _
	ByVal MessageText As LPCWSTR _
)As HRESULT

Declare Function IrcClientSendWho( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As LPCWSTR _
)As HRESULT

Declare Function IrcClientSendWhoIs( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As LPCWSTR _
)As HRESULT

#define IrcClientSendAdminSimple(pIrcClient) IrcClientSendAdmin((pIrcClient), NULL)

Declare Function IrcClientSendAdmin( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Server As LPCWSTR _
)As HRESULT

#define IrcClientSendInfoSimple(pIrcClient) IrcClientSendInfo((pIrcClient), NULL)

Declare Function IrcClientSendInfo( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Server As LPCWSTR _
)As HRESULT

#define IrcClientSendAwaySimple(pIrcClient) IrcClientSendAway((pIrcClient), NULL)

Declare Function IrcClientSendAway( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal MessageText As LPCWSTR _
)As HRESULT

Declare Function IrcClientSendIsON( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal NickList As LPCWSTR _
)As HRESULT

#define IrcClientSendKickSimple(pIrcClient, Channel, UserName) IrcClientSendKick((pIrcClient), (Channel), (UserName), NULL)

Declare Function IrcClientSendKick( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Channel As LPCWSTR, _
	ByVal UserName As LPCWSTR, _
	ByVal MessageText As LPCWSTR _
)As HRESULT

Declare Function IrcClientSendInvite( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As LPCWSTR, _
	ByVal Channel As LPCWSTR _
)As HRESULT

Declare Function IrcClientSendCtcpPingRequest( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As LPCWSTR, _
	ByVal TimeValue As LPCWSTR _
)As HRESULT

Declare Function IrcClientSendCtcpTimeRequest( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As LPCWSTR _
)As HRESULT

Declare Function IrcClientSendCtcpUserInfoRequest( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As LPCWSTR _
)As HRESULT

Declare Function IrcClientSendCtcpVersionRequest( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As LPCWSTR _
)As HRESULT

Declare Function IrcClientSendCtcpAction( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As LPCWSTR, _
	ByVal MessageText As LPCWSTR _
)As HRESULT

Declare Function IrcClientSendCtcpPingResponse( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As LPCWSTR, _
	ByVal TimeValue As LPCWSTR _
)As HRESULT

Declare Function IrcClientSendCtcpTimeResponse( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As LPCWSTR, _
	ByVal TimeValue As LPCWSTR _
)As HRESULT

Declare Function IrcClientSendCtcpUserInfoResponse( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As LPCWSTR, _
	ByVal UserInfo As LPCWSTR _
)As HRESULT

Declare Function IrcClientSendCtcpVersionResponse( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As LPCWSTR, _
	ByVal Version As LPCWSTR _
)As HRESULT

#define IrcClientSendDccSendSimple(pIrcClient, UserName, FileName, IPAddress, Port) IrcClientSendDccSend((pIrcClient), (UserName), (FileName), (IPAddress), (Port), 0)

Declare Function IrcClientSendDccSend( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As LPCWSTR, _
	ByVal FileName As LPCWSTR, _
	ByVal IPAddress As LPCWSTR, _
	ByVal Port As Integer, _
	ByVal FileLength As ULongInt _
)As HRESULT

Declare Function IrcClientSendPing( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Server As LPCWSTR _
)As HRESULT

Declare Function IrcClientSendPong( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Server As LPCWSTR _
)As HRESULT

Declare Function IrcClientSendRawMessage( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal RawText As LPCWSTR _
)As HRESULT

#endif

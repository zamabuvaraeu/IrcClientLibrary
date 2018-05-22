#ifndef BATCHEDFILES_IRCCLIENT_IRCCLIENT_BI
#define BATCHEDFILES_IRCCLIENT_IRCCLIENT_BI

#ifndef unicode
#define unicode
#endif
#include once "windows.bi"
#include once "win\shellapi.bi"
#include once "win\shlwapi.bi"
#include once "win\winsock2.bi"
#include once "win\ws2tcpip.bi"

Type IrcClient
	
	Const MaxBytesCount As Integer = 512
	Const DefaultServerPort As Integer = 6667
	
	Dim AdvancedClientData As Any Ptr
	Dim CodePage As Integer
	Dim ClientVersion As WString Ptr
	Dim ClientUserInfo As WString Ptr
	
	Dim ClientNick As WString * (MaxBytesCount + 1)
	Dim ClientRawBuffer As ZString * (MaxBytesCount + 1)
	Dim ClientRawBufferLength As Integer
	Dim ClientSocket As SOCKET
	
	Dim SendedRawMessageEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal MessageText As WString Ptr _
	)
	
	Dim ReceivedRawMessageEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal MessageText As WString Ptr _
	)
	
	Dim ServerErrorEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal Message As WString Ptr _
	)
	
	Dim ServerMessageEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal ServerCode As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)
	
	Dim NoticeEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal NoticeText As WString Ptr _
	)
	
	Dim ChannelMessageEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)
	
	Dim PrivateMessageEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)
	
	Dim UserJoinedEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal UserName As WString Ptr _
	)
	
	Dim UserLeavedEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)
	
	Dim NickChangedEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal OldNick As WString Ptr, _
		ByVal NewNick As WString Ptr _
	)
	
	Dim TopicEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal TopicText As WString Ptr _
	)
	
	Dim QuitEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)
	
	Dim KickEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal AdminName As WString Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal KickedUser As WString Ptr _
	)
	
	Dim InviteEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal FromUser As WString Ptr, _
		ByVal Channel As WString Ptr _
	)
	
	Dim PingEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal Server As WString Ptr _
	)
	
	Dim PongEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal Server As WString Ptr _
	)
	
	Dim ModeEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal AdminName As WString Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal Mode As WString Ptr _
	)
	
	Dim CtcpPingRequestEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal FromUser As WString Ptr, _
		ByVal ToUser As WString Ptr, _
		ByVal TimeValue As WString Ptr _
	)
	
	Dim CtcpTimeRequestEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal FromUser As WString Ptr, _
		ByVal ToUser As WString Ptr _
	)
	
	Dim CtcpUserInfoRequestEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal FromUser As WString Ptr, _
		ByVal ToUser As WString Ptr _
	)
	
	Dim CtcpVersionRequestEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal FromUser As WString Ptr, _
		ByVal ToUser As WString Ptr _
	)
	
	Dim CtcpActionEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal FromUser As WString Ptr, _
		ByVal ToUser As WString Ptr, _
		ByVal ActionText As WString Ptr _
	)
	
	Dim CtcpPingResponseEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal FromUser As WString Ptr, _
		ByVal ToUser As WString Ptr, _
		ByVal TimeValue As WString Ptr _
	)
	
	Dim CtcpTimeResponseEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal FromUser As WString Ptr, _
		ByVal ToUser As WString Ptr, _
		ByVal TimeValue As WString Ptr _
	)
	
	Dim CtcpUserInfoResponseEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal FromUser As WString Ptr, _
		ByVal ToUser As WString Ptr, _
		ByVal UserInfo As WString Ptr _
	)
	
	Dim CtcpVersionResponseEvent As Sub( _
		ByVal ClientData As Any Ptr, _
		ByVal FromUser As WString Ptr, _
		ByVal ToUser As WString Ptr, _
		ByVal Version As WString Ptr _
	)
	
End Type

Declare Function OpenIrc Overload( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Server As WString Ptr, _
	ByVal Nick As WString Ptr _
) As Boolean

Declare Function OpenIrc Overload( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Server As WString Ptr, _
	ByVal Port As WString Ptr, _
	ByVal Nick As WString Ptr, _
	ByVal User As WString Ptr, _
	ByVal Description As WString Ptr _
) As Boolean

Declare Function OpenIrc Overload( _
	ByVal pIrcClient As IrcClient Ptr, _
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

Declare Sub RunIrcClient( _
	ByVal pIrcClient As IrcClient Ptr _
)

Declare Sub CloseIrcClient( _
	ByVal pIrcClient As IrcClient Ptr _
)

Declare Function SendIrcMessage( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal MessageText As WString Ptr _
) As Boolean

Declare Function SendNotice( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal NoticeText As WString Ptr _
) As Boolean

Declare Function ChangeTopic( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal TopicText As WString Ptr _
) As Boolean

Declare Function QuitFromServer Overload( _
	ByVal pIrcClient As IrcClient Ptr _
) As Boolean

Declare Function QuitFromServer Overload( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal MessageText As WString Ptr _
) As Boolean

Declare Function ChangeNick( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Nick As WString Ptr _
) As Boolean

Declare Function JoinChannel( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Channel As WString Ptr _
) As Boolean

Declare Function PartChannel Overload( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Channel As WString Ptr _
) As Boolean

Declare Function PartChannel Overload( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal MessageText As WString Ptr _
) As Boolean

Declare Function SendWho( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As WString Ptr _
) As Boolean

Declare Function SendWhoIs( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As WString Ptr _
) As Boolean

Declare Function SendAdmin Overload( _
	ByVal pIrcClient As IrcClient Ptr _
) As Boolean

Declare Function SendAdmin Overload( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Server As WString Ptr _
) As Boolean

Declare Function SendInfo Overload( _
	ByVal pIrcClient As IrcClient Ptr _
) As Boolean

Declare Function SendInfo Overload( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Server As WString Ptr _
) As Boolean

Declare Function SendAway Overload( _
	ByVal pIrcClient As IrcClient Ptr _
) As Boolean

Declare Function SendAway Overload( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal MessageText As WString Ptr _
) As Boolean

Declare Function SendIsON( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal NickList As WString Ptr _
) As Boolean

Declare Function SendKick Overload( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal UserName As WString Ptr _
) As Boolean

Declare Function SendKick Overload( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal UserName As WString Ptr, _
	ByVal MessageText As WString Ptr _
) As Boolean

Declare Function SendInvite( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As WString Ptr, _
	ByVal Channel As WString Ptr _
) As Boolean

Declare Function SendCtcpPingRequest( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As WString Ptr, _
	ByVal TimeValue As WString Ptr _
) As Boolean

Declare Function SendCtcpTimeRequest( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As WString Ptr _
) As Boolean

Declare Function SendCtcpUserInfoRequest( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As WString Ptr _
) As Boolean

Declare Function SendCtcpVersionRequest( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As WString Ptr _
) As Boolean

Declare Function SendCtcpAction( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As WString Ptr, _
	ByVal MessageText As WString Ptr _
) As Boolean

Declare Function SendCtcpPingResponse( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As WString Ptr, _
	ByVal TimeValue As WString Ptr _
) As Boolean

Declare Function SendCtcpTimeResponse( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As WString Ptr, _
	ByVal TimeValue As WString Ptr _
) As Boolean

Declare Function SendCtcpUserInfoResponse( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As WString Ptr, _
	ByVal UserInfo As WString Ptr _
) As Boolean

Declare Function SendCtcpVersionResponse( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal UserName As WString Ptr, _
	ByVal Version As WString Ptr _
) As Boolean

Declare Function SendPing( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Server As WString Ptr _
) As Boolean

Declare Function SendPong( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal Server As WString Ptr _
) As Boolean

Declare Function SendRawMessage( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal RawText As WString Ptr _
) As Boolean

#endif

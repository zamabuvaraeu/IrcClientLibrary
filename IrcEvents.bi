Declare Sub SendedRawMessage( _
	ByVal ClientData As Any Ptr, _
	ByVal MessageText As WString Ptr)

Declare Sub ReceivedRawMessage( _
	ByVal ClientData As Any Ptr, _
	ByVal MessageText As WString Ptr)

Declare Sub ServerMessage( _
	ByVal ClientData As Any Ptr, _
	ByVal ServerCode As WString Ptr, _
	ByVal MessageText As WString Ptr)

Declare Sub Notice( _
	ByVal ClientData As Any Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal NoticeText As WString Ptr)

Declare Sub ChannelMessage( _
	ByVal ClientData As Any Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal UserName As WString Ptr, _
	ByVal MessageText As WString Ptr)

Declare Sub IrcPrivateMessage( _
	ByVal ClientData As Any Ptr, _
	ByVal UserName As WString Ptr, _
	ByVal MessageText As WString Ptr)

Declare Sub UserJoined( _
	ByVal ClientData As Any Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal UserName As WString Ptr)

Declare Sub UserLeaved( _
	ByVal ClientData As Any Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal UserName As WString Ptr, _
	ByVal MessageText As WString Ptr)

Declare Sub NickChanged( _
	ByVal ClientData As Any Ptr, _
	ByVal OldNick As WString Ptr, _
	ByVal NewNick As WString Ptr)

Declare Sub Topic( _
	ByVal ClientData As Any Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal UserName As WString Ptr, _
	ByVal TopicText As WString Ptr)

Declare Sub UserQuit( _
	ByVal ClientData As Any Ptr, _
	ByVal UserName As WString Ptr, _
	ByVal MessageText As WString Ptr)

Declare Sub Kick( _
	ByVal ClientData As Any Ptr, _
	ByVal AdminName As WString Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal KickedUser As WString Ptr)

Declare Sub Invite( _
	ByVal ClientData As Any Ptr, _
	ByVal FromUser As WString Ptr, _
	ByVal Channel As WString Ptr)

Declare Sub Ping( _
	ByVal ClientData As Any Ptr, _
	ByVal Server As WString Ptr)

Declare Sub Pong( _
	ByVal ClientData As Any Ptr, _
	ByVal Server As WString Ptr)

Declare Sub Mode( _
	ByVal ClientData As Any Ptr, _
	ByVal AdminName As WString Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal UserName As WString Ptr, _
	ByVal Mode As WString Ptr)

Declare Sub ServerError( _
	ByVal ClientData As Any Ptr, _
	ByVal Message As WString Ptr)

Declare Sub CtcpPingRequest( _
	ByVal ClientData As Any Ptr, _
	ByVal FromUser As WString Ptr, _
	ByVal ToUser As WString Ptr, _
	ByVal TimeValue As WString Ptr)

Declare Sub CtcpTimeRequest( _
	ByVal ClientData As Any Ptr, _
	ByVal FromUser As WString Ptr, _
	ByVal ToUser As WString Ptr)

Declare Sub CtcpUserInfoRequest( _
	ByVal ClientData As Any Ptr, _
	ByVal FromUser As WString Ptr, _
	ByVal ToUser As WString Ptr)

Declare Sub CtcpVersionRequest( _
	ByVal ClientData As Any Ptr, _
	ByVal FromUser As WString Ptr, _
	ByVal ToUser As WString Ptr)

Declare Sub CtcpAction As Sub( _
	ByVal ClientData As Any Ptr, _
	ByVal FromUser As WString Ptr, _
	ByVal ToUser As WString Ptr, _
	ByVal ActionText As WString Ptr)

Declare Sub CtcpPingResponse( _
	ByVal ClientData As Any Ptr, _
	ByVal FromUser As WString Ptr, _
	ByVal ToUser As WString Ptr, _
	ByVal TimeValue As WString Ptr)

Declare Sub CtcpTimeResponse( _
	ByVal ClientData As Any Ptr, _
	ByVal FromUser As WString Ptr, _
	ByVal ToUser As WString Ptr, _
	ByVal TimeValue As WString Ptr)

Declare Sub CtcpUserInfoResponse( _
	ByVal ClientData As Any Ptr, _
	ByVal FromUser As WString Ptr, _
	ByVal ToUser As WString Ptr, _
	ByVal UserInfo As WString Ptr)

Declare Sub CtcpVersionResponse( _
	ByVal ClientData As Any Ptr, _
	ByVal FromUser As WString Ptr, _
	ByVal ToUser As WString Ptr, _
	ByVal Version As WString Ptr)

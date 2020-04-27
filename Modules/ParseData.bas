#include "ParseData.bi"
#include "CharacterConstants.bi"
#include "GetIrcData.bi"
#include "StringConstants.bi"

Function IsCtcpMessage( _
		ByVal pwszMessageText As WString Ptr, _
		ByVal MessageTextLength As Integer _
	)As Boolean
	
	If MessageTextLength > 2 Then
		If pwszMessageText[0] = Characters.StartOfHeading Then
			If pwszMessageText[MessageTextLength - 1] = Characters.StartOfHeading Then
				Return True
			End If
		End If
	End If
	
	Return False
	
End Function

Function ParseData( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal pwszIrcMessage As WString Ptr, _
		ByVal IrcMessageLength As Integer _
	)As HRESULT
	
	Dim Prefix As IrcPrefix = Any
	Dim PrefixLength As Integer = GetIrcPrefix(@Prefix, pwszIrcMessage, IrcMessageLength)
	
	Dim pwszIrcCommand As WString Ptr = Any
	Dim IrcCommandLength As Integer = Any
	If PrefixLength = 0 Then
		pwszIrcCommand = pwszIrcMessage
	Else
		pwszIrcCommand = @pwszIrcMessage[PrefixLength + 1 + 1] ' colon + space
	End If
	
	Dim pwszIrcParam1 As WString Ptr = GetNextWord(pwszIrcCommand)
	Dim pwszIrcParam1Length As Integer = Any
	IrcCommandLength = pwszIrcParam1 - pwszIrcCommand - 1
	
	Select Case GetIrcCommand(pwszIrcCommand)
		
		Case IrcCommand.PingWord
			'PING :barjavel.freenode.net
			Dim ServerName As WString Ptr = GetIrcServerName(pwszIrcParam1)
			If ServerName <> 0 Then
				If CUInt(pIrcClient->lpfnPingEvent) Then
					pIrcClient->lpfnPingEvent(pIrcClient->AdvancedClientData, @Prefix, ServerName)
				Else
					Return IrcClientSendPong(pIrcClient, ServerName)
				End If
			End If
			
		Case IrcCommand.PrivateMessage
			':Angel!wings@irc.org PRIVMSG Wiz :Are you receiving this message ?
			':Angel!wings@irc.org PRIVMSG Qubick :PING 1402355972
			':Angel!wings@irc.org PRIVMSG Qubick :VERSION
			':Angel!wings@irc.org PRIVMSG Qubick :TIME
			':Angel!wings@irc.org PRIVMSG Qubick :USERINFO
			
			Dim pwszMsgTarget As WString Ptr = pwszIrcParam1
			Dim pwszStartIrcParam2 As WString Ptr = GetNextWord(pwszIrcParam1)
	
			Dim pwszMessageText As WString Ptr = GetIrcMessageText(pwszStartIrcParam2)
			
			If pwszMessageText <> 0 Then
				Dim MessageTextLength As Integer = @pwszIrcMessage[IrcMessageLength] - pwszMessageText
				
				If IsCtcpMessage(pwszMessageText, MessageTextLength) Then
					pwszMessageText[MessageTextLength - 1] = 0
					Dim wStartCtcpParam As WString Ptr = GetNextWord(@pwszMessageText[1])
					
					Select Case GetCtcpCommand(@pwszMessageText[1])
						
						Case CtcpMessageKind.Ping
							
							If CUInt(pIrcClient->lpfnCtcpPingRequestEvent) = 0 Then
								IrcClientSendCtcpPingResponse(pIrcClient, Prefix.Nick, wStartCtcpParam)
							Else
								pIrcClient->lpfnCtcpPingRequestEvent(pIrcClient->AdvancedClientData, @Prefix, pwszMsgTarget, wStartCtcpParam)
							End If
							
						Case CtcpMessageKind.UserInfo
							If CUInt(pIrcClient->lpfnCtcpUserInfoRequestEvent) = 0 Then
								If pIrcClient->ClientUserInfoLength <> 0 Then
									IrcClientSendCtcpUserInfoResponse(pIrcClient, Prefix.Nick, @pIrcClient->ClientUserInfo)
								End If
							Else
								pIrcClient->lpfnCtcpUserInfoRequestEvent(pIrcClient->AdvancedClientData, @Prefix, pwszMsgTarget)
							End If
							
						Case CtcpMessageKind.Time
							If CUInt(pIrcClient->lpfnCtcpTimeRequestEvent) = 0 Then
								' Tue, 15 Nov 1994 12:45:26 GMT
								Const DateFormatString = "ddd, dd MMM yyyy "
								Const TimeFormatString = "HH:mm:ss GMT"
								Dim TimeValue As WString * 64 = Any
								Dim dtNow As SYSTEMTIME = Any
								
								GetSystemTime(@dtNow)
								
								Dim dtBufferLength As Integer = GetDateFormat(LOCALE_INVARIANT, 0, @dtNow, @DateFormatString, @TimeValue, 31) - 1
								GetTimeFormat(LOCALE_INVARIANT, 0, @dtNow, @TimeFormatString, @TimeValue[dtBufferLength], 31 - dtBufferLength)
								
								Return IrcClientSendCtcpTimeResponse(pIrcClient, Prefix.Nick, @TimeValue)
							Else
								pIrcClient->lpfnCtcpTimeRequestEvent(pIrcClient->AdvancedClientData, @Prefix, pwszMsgTarget)
							End If
							
						Case CtcpMessageKind.Version
							If CUInt(pIrcClient->lpfnCtcpVersionRequestEvent) = 0 Then
								If pIrcClient->ClientVersionLength <> 0 Then
									Return IrcClientSendCtcpVersionResponse(pIrcClient, Prefix.Nick, @pIrcClient->ClientVersion)
								End If
							Else
								pIrcClient->lpfnCtcpVersionRequestEvent(pIrcClient->AdvancedClientData, @Prefix, pwszMsgTarget)
							End If
							
						Case CtcpMessageKind.Action
							If CUInt(pIrcClient->lpfnCtcpActionEvent) Then
								pIrcClient->lpfnCtcpActionEvent(pIrcClient->AdvancedClientData, @Prefix, pwszMsgTarget, wStartCtcpParam)
							End If
							
					End Select
				Else
					If lstrcmp(pwszMsgTarget, @pIrcClient->ClientNick) = 0 Then
						If CUInt(pIrcClient->lpfnPrivateMessageEvent) Then
							pIrcClient->lpfnPrivateMessageEvent(pIrcClient->AdvancedClientData, @Prefix, pwszMessageText)
						End If
					Else
						If CUInt(pIrcClient->lpfnChannelMessageEvent) Then
							pIrcClient->lpfnChannelMessageEvent(pIrcClient->AdvancedClientData, @Prefix, pwszMsgTarget, pwszMessageText)
						End If
					End If
				End If
			End If
			
		Case IrcCommand.Join
			':Qubick!~Qubick@irc.org JOIN ##freebasic
			If CUInt(pIrcClient->lpfnUserJoinedEvent) Then
				pIrcClient->lpfnUserJoinedEvent(pIrcClient->AdvancedClientData, @Prefix, pwszIrcParam1)
			End If
			
		Case IrcCommand.Quit, IrcCommand.SQuit
			' :syrk!kalt@millennium.stealth.net QUIT :Gone to have lunch
			If CUInt(pIrcClient->lpfnQuitEvent) Then
				Dim QuitText As WString Ptr = GetIrcMessageText(pwszIrcParam1)
				If QuitText = 0 Then
					pIrcClient->lpfnQuitEvent(pIrcClient->AdvancedClientData, @Prefix, @EmptyString)
				Else
					pIrcClient->lpfnQuitEvent(pIrcClient->AdvancedClientData, @Prefix, QuitText)
				End If
			End If
			
		Case IrcCommand.Part
			':WiZ!jto@tolsun.oulu.fi PART #playzone :I lost
			If CUInt(pIrcClient->lpfnUserLeavedEvent) Then
				Dim pwszStartIrcParam2 As WString Ptr = GetNextWord(pwszIrcParam1)
				Dim PartText As WString Ptr = GetIrcMessageText(pwszStartIrcParam2)
				If PartText = 0 Then
					pIrcClient->lpfnUserLeavedEvent(pIrcClient->AdvancedClientData, @Prefix, pwszIrcParam1, @EmptyString)
				Else
					pIrcClient->lpfnUserLeavedEvent(pIrcClient->AdvancedClientData, @Prefix, pwszIrcParam1, PartText)
				End If
			End If
			
		Case IrcCommand.Notice
			':Angel!wings@irc.org NOTICE Wiz :Are you receiving this message ?
			':Angel!wings@irc.org NOTICE Qubick :PING 1402355972
			
			Dim pwszMsgTarget As WString Ptr = pwszIrcParam1
			Dim pwszStartIrcParam2 As WString Ptr = GetNextWord(pwszIrcParam1)
			
			Dim pwszNoticeText As WString Ptr = GetIrcMessageText(pwszStartIrcParam2)
			
			If pwszNoticeText <> 0 Then
				Dim NoticeTextLength As Integer = @pwszIrcMessage[IrcMessageLength] - pwszNoticeText
				
				If IsCtcpMessage(pwszNoticeText, NoticeTextLength) Then
					pwszNoticeText[NoticeTextLength - 1] = 0
					Dim wStartCtcpParam As WString Ptr = GetNextWord(@pwszNoticeText[1])
					
					Select Case GetCtcpCommand(@pwszNoticeText[1])
						
						Case CtcpMessageKind.Ping
							If CUInt(pIrcClient->lpfnCtcpPingResponseEvent) Then
								pIrcClient->lpfnCtcpPingResponseEvent(pIrcClient->AdvancedClientData, @Prefix, pwszMsgTarget, wStartCtcpParam)
							End If
							
						Case CtcpMessageKind.UserInfo
							If CUInt(pIrcClient->lpfnCtcpUserInfoResponseEvent) Then
								pIrcClient->lpfnCtcpUserInfoResponseEvent(pIrcClient->AdvancedClientData, @Prefix, pwszMsgTarget, wStartCtcpParam)
							End If
							
						Case CtcpMessageKind.Time
							If CUInt(pIrcClient->lpfnCtcpTimeResponseEvent) Then
								pIrcClient->lpfnCtcpTimeResponseEvent(pIrcClient->AdvancedClientData, @Prefix, pwszMsgTarget, wStartCtcpParam)
							End If
							
						Case CtcpMessageKind.Version
							If CUInt(pIrcClient->lpfnCtcpVersionResponseEvent) Then
								pIrcClient->lpfnCtcpVersionResponseEvent(pIrcClient->AdvancedClientData, @Prefix, pwszMsgTarget, wStartCtcpParam)
							End If
							
					End Select
					
				Else
					If lstrcmp(pwszMsgTarget, @pIrcClient->ClientNick) = 0 Then
						If CUInt(pIrcClient->lpfnNoticeEvent) Then
							pIrcClient->lpfnNoticeEvent(pIrcClient->AdvancedClientData, @Prefix, pwszNoticeText)
						End If
					Else
						If CUInt(pIrcClient->lpfnChannelNoticeEvent) Then
							pIrcClient->lpfnChannelNoticeEvent(pIrcClient->AdvancedClientData, @Prefix, pwszMsgTarget, pwszNoticeText)
						End If
					End If
				End If
			End If
			
		Case IrcCommand.Nick
			':WiZ!jto@tolsun.oulu.fi NICK Kilroy
			If CUInt(pIrcClient->lpfnNickChangedEvent) Then
				pIrcClient->lpfnNickChangedEvent(pIrcClient->AdvancedClientData, @Prefix, pwszIrcParam1)
			End If
			
		Case IrcCommand.ErrorWord
			'ERROR :Closing Link: 89.22.170.64 (Client Quit)
			Dim MessageText As WString Ptr = GetIrcMessageText(pwszIrcParam1)
			If MessageText <> 0 Then
				If CUInt(pIrcClient->lpfnServerErrorEvent) Then
					pIrcClient->lpfnServerErrorEvent(pIrcClient->AdvancedClientData, @Prefix, MessageText)
				End If
			End If
			
			Return E_FAIL
			
		Case IrcCommand.Kick
			':WiZ!jto@tolsun.oulu.fi KICK #Finnish John
			If CUInt(pIrcClient->lpfnKickEvent) Then
				Dim pwszStartIrcParam2 As WString Ptr = GetNextWord(pwszIrcParam1)
				pIrcClient->lpfnKickEvent(pIrcClient->AdvancedClientData, @Prefix, pwszIrcParam1, pwszStartIrcParam2)
			End If
			
		Case IrcCommand.Mode
			':ChanServ!ChanServ@services. MODE #freebasic +v ssteiner
			':FreeBasicCompile MODE FreeBasicCompile :+i
			If CUInt(pIrcClient->lpfnModeEvent) Then
				Dim pwszStartIrcParam2 As WString Ptr = GetNextWord(pwszIrcParam1)
				Dim wStartIrcParam3 As WString Ptr = GetNextWord(pwszStartIrcParam2)
				pIrcClient->lpfnModeEvent(pIrcClient->AdvancedClientData, @Prefix, pwszIrcParam1, pwszStartIrcParam2, wStartIrcParam3)
			End If
			
		Case IrcCommand.Topic
			':WiZ!jto@tolsun.oulu.fi TOPIC #test :New topic
			If CUInt(pIrcClient->lpfnTopicEvent) Then
				Dim pwszStartIrcParam2 As WString Ptr = GetNextWord(pwszIrcParam1)
				Dim TopicText As WString Ptr = GetIrcMessageText(pwszStartIrcParam2)
				If TopicText = 0 Then
					pIrcClient->lpfnTopicEvent(pIrcClient->AdvancedClientData, @Prefix, pwszIrcParam1, @EmptyString)
				Else
					pIrcClient->lpfnTopicEvent(pIrcClient->AdvancedClientData, @Prefix, pwszIrcParam1, TopicText)
				End If
			End If
			
		Case IrcCommand.Invite
			':Angel!wings@irc.org INVITE Wiz #Dust
			If CUInt(pIrcClient->lpfnInviteEvent) Then
				Dim pwszStartIrcParam2 As WString Ptr = GetNextWord(pwszIrcParam1)
				pIrcClient->lpfnInviteEvent(pIrcClient->AdvancedClientData, @Prefix, pwszIrcParam1, pwszStartIrcParam2)
			End If
			
		Case IrcCommand.PongWord
			'PONG :barjavel.freenode.net
			Dim ServerName As WString Ptr = GetIrcServerName(pwszIrcParam1)
			If ServerName <> 0 Then
				If CUInt(pIrcClient->lpfnPongEvent) Then
					pIrcClient->lpfnPongEvent(pIrcClient->AdvancedClientData, @Prefix, ServerName)
				End If
			End If
			
		Case IrcCommand.Server
			':orwell.freenode.net 376 FreeBasicCompile :End of /MOTD command.
			If CUInt(pIrcClient->lpfnServerMessageEvent) Then
				pIrcClient->lpfnServerMessageEvent(pIrcClient->AdvancedClientData, @Prefix, pwszIrcCommand, pwszIrcParam1)
			End If
			
	End Select
	
	Return S_OK
	
End Function

#include "GetIrcData.bi"
#include "CharacterConstants.bi"
#include "StringConstants.bi"

Function GetIrcPrefix( _
		ByVal pIrcPrefix As IrcPrefix Ptr, _
		ByVal IrcData As WString Ptr _
	)As WString Ptr
	
	If IrcData[0] = Characters.Colon Then
		'prefix     =  servername / ( nickname [ [ "!" user ] "@" host ] )
		':Qubick!~miranda@192.168.1.1 JOIN ##freebasic
		Dim wWhiteSpaceChar As WString Ptr = StrChr(IrcData, Characters.WhiteSpace)
		
		If wWhiteSpaceChar <> 0 Then
			wWhiteSpaceChar[0] = 0
			
			pIrcPrefix->Nick = @IrcData[1]
			
			Dim wExclamationChar As WString Ptr = StrChr(@IrcData[1], Characters.ExclamationMark)
			If wExclamationChar = 0 Then
				pIrcPrefix->User = @EmptyString
				pIrcPrefix->Host = @EmptyString
			Else
				wExclamationChar[0] = 0
				pIrcPrefix->User = @wExclamationChar[1]
				
				Dim wCommercialAtChar As WString Ptr = StrChr(@wExclamationChar[1], Characters.CommercialAt)
				If wCommercialAtChar = 0 Then
					pIrcPrefix->Host = @EmptyString
				Else
					wCommercialAtChar[0] = 0
					pIrcPrefix->Host = @wCommercialAtChar[1]
				End If
			End If
			
			Return @wWhiteSpaceChar[1]
		End If
	End If
	
	pIrcPrefix->Nick = @EmptyString
	pIrcPrefix->User = @EmptyString
	pIrcPrefix->Host = @EmptyString
	
	Return IrcData
	
End Function

Function GetIrcCommand( _
		ByVal w As WString Ptr _
	)As IrcCommand
	
	If lstrcmp(w, @PingString) = 0 Then
		Return IrcCommand.PingWord
	End If
	
	If lstrcmp(w, @PongString) = 0 Then
		Return IrcCommand.PongWord
	End If
	
	If lstrcmp(w, @ErrorString) = 0 Then
		Return IrcCommand.ErrorWord
	End If
	
	If lstrcmp(w, @PrivateMessage) = 0 Then
		Return IrcCommand.PrivateMessage
	End If
	
	If lstrcmp(w, @NoticeString) = 0 Then
		Return IrcCommand.Notice
	End If
	
	If lstrcmp(w, @JoinString) = 0 Then
		Return IrcCommand.Join
	End If
	
	If lstrcmp(w, @QuitString) = 0 Then
		Return IrcCommand.Quit
	End If
	
	If lstrcmp(w, @InviteString) = 0 Then
		Return IrcCommand.Invite
	End If
	
	If lstrcmp(w, @KickString) = 0 Then
		Return IrcCommand.Kick
	End If
	
	If lstrcmp(w, @ModeString) = 0 Then
		Return IrcCommand.Mode
	End If
	
	If lstrcmp(w, @NickString) = 0 Then
		Return IrcCommand.Nick
	End If
	
	If lstrcmp(w, @PartString) = 0 Then
		Return IrcCommand.Part
	End If
	
	If lstrcmp(w, @SQuitString) = 0 Then
		Return IrcCommand.SQuit
	End If
	
	If lstrcmp(w, @TopicString) = 0 Then
		Return IrcCommand.Topic
	End If
	
	Return IrcCommand.Server
	
End Function

Function GetIrcServerName( _
		ByVal strData As WString Ptr _
	)As WString Ptr
	
	Dim w As WString Ptr = StrChr(strData, Characters.Colon)
	
	If w = 0 Then
		Return 0
	Else
		Return w + 1
	End If
	
End Function

Function GetNextWord( _
		ByVal wStart As WString Ptr _
	)As WString Ptr
	
	Dim ws As WString Ptr = StrChr(wStart, Characters.WhiteSpace)
	
	If ws = 0 Then
		Return wStart
	End If
	
	ws[0] = 0
	
	Return ws + 1
	
End Function

Function GetIrcMessageText( _
		ByVal strData As WString Ptr _
	)As WString Ptr
	
	':Qubick!~miranda@192.168.1.1 PRIVMSG ##freebasic :Hello World
	Dim w As WString Ptr = StrChr(strData, Characters.Colon)
	
	If w = 0 Then
		Return 0
	Else
		Return w + 1
	End If
	
End Function

Function GetCtcpCommand( _
		ByVal w As WString Ptr _
	)As CtcpMessageKind
	
	If lstrcmp(w, @PingString) = 0 Then
		Return CtcpMessageKind.Ping
	End If
	
	If lstrcmp(w, @UserInfoString) = 0 Then
		Return CtcpMessageKind.UserInfo
	End If
	
	If lstrcmp(w, @TimeString) = 0 Then
		Return CtcpMessageKind.Time
	End If
	
	If lstrcmp(w, @VersionString) = 0 Then
		Return CtcpMessageKind.Version
	End If
	
	If lstrcmp(w, @ActionString) = 0 Then
		Return CtcpMessageKind.Action
	End If
	
	Return CtcpMessageKind.None
	
End Function

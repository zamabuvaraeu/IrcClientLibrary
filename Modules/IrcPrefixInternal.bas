#include "IrcPrefixInternal.bi"
#include "CharacterConstants.bi"
#include "StringConstants.bi"
#include "win\shlwapi.bi"

Function GetIrcPrefixInternal( _
		ByVal pIrcPrefixInternal As IrcPrefixInternal Ptr, _
		ByRef bstrIrcMessage As ValueBSTR _
	)As Integer
	
	'prefix     =  servername / ( nickname [ [ "!" user ] "@" host ] )
	':Qubick!~miranda@192.168.1.1 JOIN ##freebasic
	
	Dim IrcPrefixLength As Integer = Any
	Dim pNick As WString Ptr = Any
	Dim NickLength As Integer = Any
	Dim pUser As WString Ptr = Any
	Dim UserLength As Integer = Any
	Dim pHost As WString Ptr = Any
	Dim HostLength As Integer = Any
	
	If bstrIrcMessage.WChars(0) = Characters.Colon Then
		
		Dim pwszIrcMessage As WString Ptr = Cast(WString Ptr, @bstrIrcMessage.WChars(0))
		Dim pPrefixStart As WString Ptr = @bstrIrcMessage.WChars(1)
		Dim wWhiteSpaceChar As WString Ptr = StrChrW(pPrefixStart, Characters.WhiteSpace)
		
		If wWhiteSpaceChar <> NULL Then
			IrcPrefixLength = wWhiteSpaceChar - pwszIrcMessage - 1
			
			wWhiteSpaceChar[0] = Characters.NullChar
			
			pNick = pPrefixStart
			
			Dim wExclamationChar As WString Ptr = StrChrW(pPrefixStart, Characters.ExclamationMark)
			If wExclamationChar = NULL Then
				NickLength = wWhiteSpaceChar - pwszIrcMessage - 1
				pUser = @EmptyString
				UserLength = 0
				pHost = @EmptyString
				HostLength = 0
			Else
				NickLength = wExclamationChar - pwszIrcMessage - 1
				wExclamationChar[0] = Characters.NullChar
				
				pUser = @wExclamationChar[1]
				
				Dim wCommercialAtChar As WString Ptr = StrChrW(@wExclamationChar[1], Characters.CommercialAt)
				If wCommercialAtChar = NULL Then
					UserLength = wWhiteSpaceChar - wExclamationChar - 1
					
					pHost = @EmptyString
					HostLength = 0
				Else
					UserLength = wCommercialAtChar - wExclamationChar - 1
					wCommercialAtChar[0] = Characters.NullChar
					
					pHost = @wCommercialAtChar[1]
					HostLength = wWhiteSpaceChar - wCommercialAtChar - 1
				End If
			End If
			
		Else
			IrcPrefixLength = 0
			pNick = @EmptyString
			NickLength = 0
			pUser = @EmptyString
			UserLength = 0
			pHost = @EmptyString
			HostLength = 0
		End If
	Else
		IrcPrefixLength = 0
		pNick = @EmptyString
		NickLength = 0
		pUser = @EmptyString
		UserLength = 0
		pHost = @EmptyString
		HostLength = 0
	End If
	
	pIrcPrefixInternal->Nick = Type<ValueBSTR>(*pNick, NickLength)
	pIrcPrefixInternal->User = Type<ValueBSTR>(*pUser, UserLength)
	pIrcPrefixInternal->Host = Type<ValueBSTR>(*pHost, HostLength)
	
	Return IrcPrefixLength
	
End Function

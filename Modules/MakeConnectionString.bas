#include "MakeConnectionString.bi"
#include "IrcClient.bi"
#include "StringConstants.bi"

Sub MakeConnectionString( _
		ByRef ConnectionString As ValueBSTR, _
		ByVal Password As BSTR, _
		ByVal Nick As BSTR, _
		ByVal User As BSTR, _
		ByVal ModeFlags As Long, _
		ByVal RealName As BSTR _
	)
		
	'PASS password
	'<password>
	
	'NICK Paul
	'<nickname>
	
	'USER paul 8 * :Paul Mutton
	'<user> <mode> <unused> :<realname>
	
	'USER paul 0 * :Paul Mutton
	'<user> <mode> <unused> :<realname>
	
	If SysStringLen(Password) <> 0 Then
		ConnectionString.Append(PassStringWithSpace, PassStringWithSpaceLength)
		ConnectionString &= Password
		ConnectionString.Append(NewLineString, NewLineStringLength)
	End If
	
	ConnectionString.Append(NickStringWithSpace, NickStringWithSpaceLength)
	ConnectionString &= Nick
	ConnectionString.Append(NewLineString, NewLineStringLength)
	
	ConnectionString.Append(UserStringWithSpace, UserStringWithSpaceLength)
	ConnectionString &= User
	
	If ModeFlags And IRCPROTOCOL_MODEFLAG_INVISIBLE Then
		ConnectionString.Append(DefaultBotNameSepInvisible, DefaultBotNameSepInvisibleLength)
	Else
		ConnectionString.Append(DefaultBotNameSepVisible, DefaultBotNameSepVisibleLength)
	End If
	
	If SysStringLen(RealName) = 0 Then
		ConnectionString &= Nick
	Else
		ConnectionString &= RealName
	End If
	
End Sub

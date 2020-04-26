#include "MakeConnectionString.bi"
#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "AppendingBuffer.bi"
#include "StringConstants.bi"

Sub MakeConnectionString( _
		ByVal ConnectionString As WString Ptr, _
		ByVal Password As Const WString Ptr, _
		ByVal Nick As Const WString Ptr, _
		ByVal User As Const WString Ptr, _
		ByVal Description As Const WString Ptr, _
		ByVal ModeFlags As Long _
	)
		
	'PASS password
	'<password>
	
	'NICK Paul
	'<nickname>
	
	'USER paul 8 * :Paul Mutton
	'<user> <mode> <unused> :<realname>
	
	'USER paul 0 * :Paul Mutton
	'<user> <mode> <unused> :<realname>
	
	Dim StringBuilder As AppendingBuffer = Type<AppendingBuffer>(ConnectionString, 0)
	
	If lstrlen(Password) <> 0 Then
		StringBuilder.AppendWString(@PassStringWithSpace, PassStringWithSpaceLength)
		StringBuilder.AppendWLine(Password)
	End If
	
	StringBuilder.AppendWString(@NickStringWithSpace, NickStringWithSpaceLength)
	StringBuilder.AppendWLine(Nick)
	
	StringBuilder.AppendWString(@UserStringWithSpace, UserStringWithSpaceLength)
	StringBuilder.AppendWString(User)
	
	If ModeFlags And IRCPROTOCOL_MODEFLAG_INVISIBLE Then
		StringBuilder.AppendWString(@DefaultBotNameSepInvisible, DefaultBotNameSepInvisibleLength)
	Else
		StringBuilder.AppendWString(@DefaultBotNameSepVisible, DefaultBotNameSepVisibleLength)
	End If
	
	If lstrlen(Description) = 0 Then
		StringBuilder.AppendWString(Nick)
	Else
		StringBuilder.AppendWString(Description)
	End If
End Sub

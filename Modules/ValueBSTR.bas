#include "ValueBSTR.bi"

Constructor ValueBSTR()
	
	BytesCount = 0
	WChars(0) = 0
	
End Constructor

Constructor ValueBSTR(ByRef lhs As Const WString)
	
	Dim lhsLength As Integer = lstrlenW(lhs)
	Dim m As Integer = min(MAX_VALUEBSTR_BUFFER_LENGTH, lhsLength)
	
	BytesCount = m * SizeOf(OLECHAR)
	lstrcpynW(@WChars(0), lhs, m + 1)
	
End Constructor

Constructor ValueBSTR(ByRef lhs As Const WString, ByVal NewLength As Const Integer)
	
	Dim m As Integer = min(MAX_VALUEBSTR_BUFFER_LENGTH, NewLength)
	
	BytesCount = m * SizeOf(OLECHAR)
	lstrcpynW(@WChars(0), lhs, m + 1)
	
End Constructor

Constructor ValueBSTR(ByRef lhs As Const ValueBSTR)
	
	BytesCount = lhs.BytesCount
	CopyMemory(@WChars(0), @lhs.WChars(0), BytesCount + SizeOf(OLECHAR))
	
End Constructor

Constructor ValueBSTR(ByRef lhs As Const BSTR)
	
	Dim lhsLength As UINT = SysStringLen(lhs)
	Dim m As Integer = min(MAX_VALUEBSTR_BUFFER_LENGTH, lhsLength)
	
	BytesCount = m * SizeOf(OLECHAR)
	CopyMemory(@WChars(0), lhs, BytesCount + SizeOf(OLECHAR))
	
End Constructor

Operator ValueBSTR.Let(ByRef lhs As Const WString)
	
	Dim lhsLength As Integer = lstrlenW(lhs)
	Dim m As Integer = min(MAX_VALUEBSTR_BUFFER_LENGTH, lhsLength)
	
	BytesCount = m * SizeOf(OLECHAR)
	lstrcpynW(@WChars(0), lhs, m + 1)
	
End Operator

Operator ValueBSTR.Let(ByRef lhs As Const ValueBSTR)
	
	BytesCount = lhs.BytesCount
	CopyMemory(@WChars(0), @lhs.WChars(0), BytesCount + SizeOf(OLECHAR))
	
End Operator

Operator ValueBSTR.Let(ByRef lhs As Const BSTR)
	
	Dim lhsLength As UINT = SysStringLen(lhs)
	Dim m As Integer = min(MAX_VALUEBSTR_BUFFER_LENGTH, lhsLength)
	
	BytesCount = m * SizeOf(OLECHAR)
	CopyMemory(@WChars(0), lhs, BytesCount + SizeOf(OLECHAR))
	
End Operator

Operator ValueBSTR.Cast()ByRef As Const WString
	
	Return WChars(0)
	
End Operator

Operator ValueBSTR.Cast()As Const BSTR
	
	Return @WChars(0)
	
End Operator

Operator ValueBSTR.Cast()As Const Any Ptr
	
	Return CPtr(Any Ptr, @WChars(0))
	
End Operator

Operator ValueBSTR.&=(ByRef rhs As Const WString)
	
	Append(rhs, lstrlenW(rhs))
	
End Operator

' Declare Operator &=(ByRef rhs As Const ValueBSTR)
' Declare Operator &=(ByRef rhs As Const BSTR)

Operator ValueBSTR.+=(ByRef rhs As Const WString)
	
#if __FB_DEBUG__
	Print "Append", lstrlenW(rhs), rhs
#endif
	Append(rhs, lstrlenW(rhs))
	
End Operator

' Declare Operator +=(ByRef rhs As Const ValueBSTR)
' Declare Operator +=(ByRef rhs As Const BSTR)

Sub ValueBSTR.Append(ByRef rhs As Const WString, ByVal NewLength As Const Integer)
	
	Dim meLength As Integer = Len(this)
#if __FB_DEBUG__
	Print "meLength", meLength
#endif
	Dim EmptySpace As Integer = MAX_VALUEBSTR_BUFFER_LENGTH - meLength
#if __FB_DEBUG__
	Print "EmptySpace", EmptySpace
#endif
	
	If EmptySpace > 0 Then
		
		Dim m As Integer = min(EmptySpace, NewLength)
#if __FB_DEBUG__
		Print "m", m, rhs
#endif
		
		BytesCount = (m + meLength) * SizeOf(OLECHAR)
		lstrcpynW(@WChars(meLength), rhs, m + 1)
		
	End If

End Sub

Operator Len(ByRef b As Const ValueBSTR)As Integer
	
	Return CInt(b.BytesCount \ SizeOf(OLECHAR))
	' Return SysStringLen(b)
	
End Operator

Property ValueBSTR.Length(ByVal NewLength As Const Integer)
	Dim m As Integer = min(MAX_VALUEBSTR_BUFFER_LENGTH, NewLength)
	BytesCount = m * SizeOf(OLECHAR)
	WChars(m) = 0
End Property

Property ValueBSTR.Length()As Const Integer
	Return CInt(BytesCount \ SizeOf(OLECHAR))
End Property

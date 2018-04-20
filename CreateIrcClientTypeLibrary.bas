#include "IIrcClient.bi"

Const IrcClientTypeLibName = "BatchedFilesIrcClient.tlb"
Const IrcClientTypeLibDescription = "Клиентская библиотека для поддержки протокола IRC"
Const IrcClientClassDescription = "Класс для Ircclient"
Const IIrcClientInterfaceName = "IIrcClient"
Const IIrcClientInterfaceDescription = "Интерфейс для поддержки протокола IRC"
Const StdOleLibrary = "stdole32.tlb"

' Функция ShowMessageBox

Const ShowMessageBoxFunctionMemberId = 0
Const ShowMessageBoxFunctionName = "ShowMessageBox"
Const ShowMessageBoxFunctionDescription = "Отображает окошко MessageBox"
Const ParamParamName = "lngParam"

/'
	
	TKIND_ALIAS
	Тип, который является псевдонимом для другого типа.
	
	TKIND_COCLASS
	Набор реализованных интерфейсов компонентов.
	
	TKIND_DISPATCH
	Набор методов и свойств, доступных через IDispatch::Invoke. По умолчанию двойные интерфейсы возвращают TKIND_DISPATCH.
	
	TKIND_ENUM
	Набор перечислителей.
	
	TKIND_INTERFACE
	Тип, содержащий виртуальные функции, каждая из которых — чистая.
	
	TKIND_MAX
	Метка окончания перечисления.
	
	TKIND_MODULE
	Модуль, который может содержать только статические функции и данные (например, DLL).
	
	TKIND_RECORD
	Структура без методов.
	
	TKIND_UNION
	Объединение всех методов, имеющих нулевое смещение.
	
	
	INVOKE_FUNC
	С помощью синтаксиса вызова обычной функции вызывается член.
	
	INVOKE_PROPERTYGET
	Функция, вызываемая при помощи синтаксиса доступа через обычное свойство.
	
	INVOKE_PROPERTYPUT
	Функция, вызываемая при помощи синтаксиса присвоения значения свойству.
	
	INVOKE_PROPERTYPUTREF
	Функция, вызываемая при помощи синтаксиса присвоения свойству ссылки.
	
	
	IDLFLAG_NONE
	Whether the parameter passes or receives information is unspecified.
	
	IDLFLAG_FIN
	Parameter passes information from the caller to the callee.
	
	IDLFLAG_FOUT
	Parameter returns information from the callee to the caller.
	
	IDLFLAG_FRETVAL
	Parameter is the return value of the member.
	
	IDLFLAG_FLCID
	Parameter is the local identifier of a client application.
'/

' {522E5895-8BC8-4E78-BDAC-98DD8C108F68}
Dim Shared LIBID_IrcClientLibrary As GUID = Type(&h522e5895, &h8bc8, &h4e78, _
	{&hbd, &hac, &h98, &hdd, &h8c, &h10, &h8f, &h68})

CoInitialize(0)

Dim hr As HRESULT = Any

' Загрузка библиотеки типов stdole32.tlb и получение интерфейсов

Dim pIUnknownTypeInfo As ITypeInfo Ptr = Any
Dim pIDispatchTypeInfo As ITypeInfo Ptr = Any

Scope
	Dim pStdOleTypeLib As ITypeLib Ptr = Any
	hr = LoadTypeLib(@StdOleLibrary, @pStdOleTypeLib)
	If FAILED(hr) Then
		Print "Ошибка загрузки библиотеки stdole32.tlb", Hex(hr)
		End(1)
	End If
	
	hr = pStdOleTypeLib->lpVtbl->GetTypeInfoOfGuid(pStdOleTypeLib, @IID_IUnknown, @pIUnknownTypeInfo)
	If FAILED(hr) Then
		Print "Ошибка загрузки интерфейса IUnknown", Hex(hr)
		End(1)
	End If
	
	hr = pStdOleTypeLib->lpVtbl->GetTypeInfoOfGuid(pStdOleTypeLib, @IID_IDispatch, @pIDispatchTypeInfo)
	If FAILED(hr) Then
		Print "Ошибка загрузки интерфейса IDispatch", Hex(hr)
		End(1)
	End If
	
	pStdOleTypeLib->lpVtbl->Release(pStdOleTypeLib)
End Scope


' Настройка библиотеки типов

Dim pCreateTypeLib As ICreateTypeLib Ptr = Any

Scope
	hr = CreateTypeLib(SYS_WIN32, @IrcClientTypeLibName, @pCreateTypeLib)
	If FAILED(hr) Then
		Print "Ошибка получения интерфейса ICreateTypeLib", Hex(hr)
		End(1)
	End If
	
	hr = pCreateTypeLib->lpVtbl->SetName(pCreateTypeLib, @IrcClientTypeLibName)
	If FAILED(hr) Then
		Print "Не могу добавить имя библиотеке", Hex(hr)
	End If
	
	hr = pCreateTypeLib->lpVtbl->SetGuid(pCreateTypeLib, @LIBID_IrcClientLibrary)
	If FAILED(hr) Then
		Print "Не могу добавить GUID к библиотеке", Hex(hr)
	End If
	
	hr = pCreateTypeLib->lpVtbl->SetVersion(pCreateTypeLib, 1, 0)
	If FAILED(hr) Then
		Print "Не могу добавить версию к библиотеке", Hex(hr)
	End If
	
	hr = pCreateTypeLib->lpVtbl->SetLcid(pCreateTypeLib, 1049) ' русский язык
	If FAILED(hr) Then
		Print "Не могу добавить язык к библиотеке", Hex(hr)
	End If
	
	hr = pCreateTypeLib->lpVtbl->SetDocString(pCreateTypeLib, @IrcClientTypeLibDescription)
	If FAILED(hr) Then
		Print "Не могу добавить описание к библиотеке", Hex(hr)
	End If
End Scope

' Интерфейс IIrcClient
Dim pIIrcClientTypeInfo As ITypeInfo Ptr = Any

Scope
	Dim pCreateTypeInfoIIrcClient As ICreateTypeInfo Ptr = Any
	
	' Настройка интерфейса IIrcClient
	
	Scope
		hr = pCreateTypeLib->lpVtbl->CreateTypeInfo(pCreateTypeLib, @IIrcClientInterfaceName, TKIND_INTERFACE, @pCreateTypeInfoIIrcClient)
		If FAILED(hr) Then
			Print "Не могу получить ICreateTypeInfo для интерфейса IIrcClient", Hex(hr)
		End If
		
		hr = pCreateTypeInfoIIrcClient->lpVtbl->SetGuid(pCreateTypeInfoIIrcClient, @IID_IIrcClient)
		If FAILED(hr) Then
			Print "Не могу добавить GUID к интерфейсу IIrcClient", Hex(hr)
		End If
		
		hr = pCreateTypeInfoIIrcClient->lpVtbl->SetDocString(pCreateTypeInfoIIrcClient, @IIrcClientInterfaceDescription)
		If FAILED(hr) Then
			Print "Не могу добавить описание к интерфейсу IIrcClient", Hex(hr)
		End If
		
		' hr = pCreateTypeInfoIIrcClient->lpVtbl->SetTypeFlags(pCreateTypeInfoIIrcClient, TYPEFLAG_FDUAL Or TYPEFLAG_FOLEAUTOMATION)
		' If FAILED(hr) Then
			' Print "Не могу добавить флаги в IIrcClient", Hex(hr)
		' End If
		
		Dim RefType As HREFTYPE = Any
		hr = pCreateTypeInfoIIrcClient->lpVtbl->AddRefTypeInfo(pCreateTypeInfoIIrcClient, pIDispatchTypeInfo, @RefType)
		If FAILED(hr) Then
			Print "Не могу добавить ссылку на IDispatch в IIrcClient", Hex(hr)
		End If
		
		hr = pCreateTypeInfoIIrcClient->lpVtbl->AddImplType(pCreateTypeInfoIIrcClient, 0, RefType)
		If FAILED(hr) Then
			Print "Не могу добавить наследование от IDispatch в IIrcClient", Hex(hr)
		End If
		
	End Scope
	
	' Добавление функций
	Dim CurrentFunctionIndex As Long = 0
	
	' ShowMessageBox
	
	Scope
		
		Dim FunctionArgNames(1) As WString Ptr = Any
		' Название функции
		FunctionArgNames(0) = @ShowMessageBoxFunctionName
		' Название параметров
		FunctionArgNames(1) = @ParamParamName
		
		Dim ParamDefinition(0) As ELEMDESC = Any
		With ParamDefinition(0)
			.tdesc.lptdesc = 0
			.tdesc.lpadesc = 0
			.tdesc.hreftype = 0
			.tdesc.vt = VT_I4 ' Long
			.idldesc.dwReserved = NULL
			.idldesc.wIDLFlags = IDLFLAG_FIN ' IDLFLAG_NONE, IDLFLAG_FIN, IDLFLAG_FOUT, IDLFLAG_FLCID, IDLFLAG_FRETVAL
		End With
		
		Dim ShowMessageBoxDefinition As FUNCDESC = Any
		With ShowMessageBoxDefinition
			.memid = ShowMessageBoxFunctionMemberId ' Индекс в виртуальной таблице функций
			.lprgscode = NULL
			.lprgelemdescParam = @ParamDefinition(0)
			.funckind = FUNC_PUREVIRTUAL ' Чисто виртуальная функция
			.invkind = INVOKE_FUNC ' INVOKE_PROPERTYGET, INVOKE_PROPERTYPUT, INVOKE_PROPERTYPUTREF
			.callconv = CC_STDCALL ' Соглашение о вызове
			.cParams = 1 ' Количество параметров
			.cParamsOpt = 0 ' Количество опциональных параметров
			.oVft = 0 ' Индекс функции в виртуальной таблице, указывается только для FUNC_VIRTUAL
			.cScodes = 0
			.elemdescFunc.tdesc.lptdesc = 0
			.elemdescFunc.tdesc.lpadesc = 0
			.elemdescFunc.tdesc.hreftype = 0
			.elemdescFunc.tdesc.vt = VT_I4
			.elemdescFunc.idldesc.dwReserved = NULL
			.elemdescFunc.idldesc.wIDLFlags = IDLFLAG_FOUT Or IDLFLAG_FRETVAL
			.wFuncFlags = 0
		End With
		
		hr = pCreateTypeInfoIIrcClient->lpVtbl->AddFuncDesc(pCreateTypeInfoIIrcClient, CurrentFunctionIndex, @ShowMessageBoxDefinition)
		If FAILED(hr) Then
			Print "Не могу добавить функцию ShowMessageBox в интерфейс IIrcClient", Hex(hr)
		End If
		
		hr = pCreateTypeInfoIIrcClient->lpVtbl->SetFuncAndParamNames(pCreateTypeInfoIIrcClient, CurrentFunctionIndex, @FunctionArgNames(0), 2)
		If FAILED(hr) Then
			Print "Не могу добавить имена функций и параметров ShowMessageBox в интерфейс IIrcClient", Hex(hr)
		End If
		
		hr = pCreateTypeInfoIIrcClient->lpVtbl->SetFuncDocString(pCreateTypeInfoIIrcClient, CurrentFunctionIndex, @ShowMessageBoxFunctionDescription)
		If FAILED(hr) Then
			Print "Не могу добавить описание функции ShowMessageBox в интерфейс IIrcClient", Hex(hr)
		End If
	End Scope
	
	CurrentFunctionIndex += 1
	
	hr = pCreateTypeInfoIIrcClient->lpVtbl->QueryInterface(pCreateTypeInfoIIrcClient, @IID_ITypeInfo, @pIIrcClientTypeInfo)
	If FAILED(hr) Then
		Print "Не могу получить ITypeInfo от интерфейса IIrcClient", Hex(hr)
	End If
	
	pCreateTypeInfoIIrcClient->lpVtbl->LayOut(pCreateTypeInfoIIrcClient)
	
	pCreateTypeInfoIIrcClient->lpVtbl->Release(pCreateTypeInfoIIrcClient)
End Scope

' Настройка класса IrcClient

Scope
	Dim pCreateTypeInfoIrcClient As ICreateTypeInfo Ptr = Any
	hr = pCreateTypeLib->lpVtbl->CreateTypeInfo(pCreateTypeLib, @"IrcClient", TKIND_COCLASS, @pCreateTypeInfoIrcClient)
	If FAILED(hr) Then
		Print "Не могу получить ICreateTypeInfo для класса IrcClient", Hex(hr)
	End If
	
	hr = pCreateTypeInfoIrcClient->lpVtbl->SetGuid(pCreateTypeInfoIrcClient, @CLSID_IRCCLIENT)
	If FAILED(hr) Then
		Print "Не могу добавить GUID к классу IrcClient", Hex(hr)
	End If
	
	hr = pCreateTypeInfoIrcClient->lpVtbl->SetDocString(pCreateTypeInfoIrcClient, @IrcClientClassDescription)
	If FAILED(hr) Then
		Print "Не могу добавить описание к классу IrcClient", Hex(hr)
	End If
	
	Dim RefType As HREFTYPE = Any
	hr = pCreateTypeInfoIrcClient->lpVtbl->AddRefTypeInfo(pCreateTypeInfoIrcClient, pIIrcClientTypeInfo, @RefType)
	If FAILED(hr) Then
		Print "Не могу добавить ссылку на IIrcClient в класс IrcClient", Hex(hr)
	End If
	
	hr = pCreateTypeInfoIrcClient->lpVtbl->AddImplType(pCreateTypeInfoIrcClient, 0, RefType)
	If FAILED(hr) Then
		Print "Не могу добавить наследование от IIrcClient в класс IrcClient", Hex(hr)
	End If
	
	pCreateTypeInfoIrcClient->lpVtbl->LayOut(pCreateTypeInfoIrcClient)
	
	pCreateTypeInfoIrcClient->lpVtbl->Release(pCreateTypeInfoIrcClient)
End Scope

' Сохранение изменений на диске

hr = pCreateTypeLib->lpVtbl->SaveAllChanges(pCreateTypeLib)
If FAILED(hr) Then
	Print "Не могу сохранить изменения на диск", Hex(hr)
End If

' Завершение
pIIrcClientTypeInfo->lpVtbl->Release(pIIrcClientTypeInfo)
pCreateTypeLib->lpVtbl->Release(pCreateTypeLib)

CoUnInitialize()

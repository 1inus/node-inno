[code]
type
	TPBProc			= function(h:hWnd; Msg, wParam, lParam:Longint):Longint;
	TTimerProc		= procedure(h:longword; msg:longword; idevent:longword; dwTime:longword);
	TBtnEventProc = procedure(h:HWND);

function WrapBtnCallback(Callback: TBtnEventProc; ParamCount: Integer): Longword;  external 'wrapcallback@files:innocallback.dll stdcall';
function WrapTimerProc(callback: TTimerProc; Paramcount: Integer): Longword;
external 'wrapcallback@files:innocallback.dll stdcall';

//#include 'Win6TaskBar.mad8834671'
function GetSysColor(nIndex: Integer): DWORD; external 'GetSysColor@user32.dll stdcall';
function GetSystemMetrics(nIndex: Integer): Integer; external 'GetSystemMetrics@user32.dll stdcall';
function LoadCursorFromFile(FileName: String): Cardinal;external 'LoadCursorFromFile{#A}@user32 stdcall';
function DeleteObject(p1: Longword): BOOL; external 'DeleteObject@gdi32.dll stdcall';
function GetPM(nIndex:Integer):Integer; external 'GetSystemMetrics@user32.dll stdcall';
function SetLayeredWindowAttributes(hwnd:HWND; crKey:Longint; bAlpha:byte; dwFlags:longint ):longint;
external 'SetLayeredWindowAttributes@user32 stdcall'; //��������

//botva2
function ImgLoad(Wnd :HWND; FileName :PAnsiChar; Left, Top, Width, Height :integer; Stretch, IsBkg :boolean) :Longint; external 'ImgLoad@{tmp}\botva2.dll stdcall delayload';
function BtnCreate(hParent:HWND; Left,Top,Width,Height:integer; FileName:PAnsiChar; ShadowWidth:integer; IsCheckBtn:boolean):HWND;  external 'BtnCreate@{tmp}\botva2.dll stdcall delayload';
function GetSysCursorHandle(id:integer):Cardinal; external 'GetSysCursorHandle@{tmp}\botva2.dll stdcall delayload';
function BtnGetChecked(h:HWND):boolean; external 'BtnGetChecked@{tmp}\botva2.dll stdcall delayload';
function SetTimer(hWnd: LongWord; nIDEvent, uElapse: LongWord; lpTimerFunc: LongWord): LongWord; external 'SetTimer@user32.dll stdcall';
function KillTimer(hWnd: LongWord; nIDEvent: LongWord): LongWord; external 'KillTimer@user32.dll stdcall';
function GetWindowLong(Wnd: HWnd; Index: Integer): Longint; external 'GetWindowLongA@user32.dll stdcall';
function ReleaseCapture(): Longint; external 'ReleaseCapture@user32.dll stdcall';
function SetWindowLong(Wnd: HWnd; Index: Integer; NewLong: Longint): Longint; external 'SetWindowLongA@user32.dll stdcall';
function PBCallBack(P:TPBProc;ParamCount:integer):LongWord; external 'wrapcallback@files:innocallback.dll stdcall';
function CallWindowProc(lpPrevWndFunc: Longint; hWnd: HWND; Msg: UINT; wParam, lParam: Longint): Longint; external 'CallWindowProcA@user32.dll stdcall';

procedure ImgSetVisibility(img :Longint; Visible :boolean); external 'ImgSetVisibility@{tmp}\botva2.dll stdcall delayload';
procedure ImgApplyChanges(h:HWND); external 'ImgApplyChanges@{tmp}\botva2.dll stdcall delayload';
procedure ImgSetPosition(img :Longint; NewLeft, NewTop, NewWidth, NewHeight :integer); external 'ImgSetPosition@files:botva2.dll stdcall';
procedure ImgRelease(img :Longint); external 'ImgRelease@{tmp}\botva2.dll stdcall delayload';
procedure gdipShutdown;  external 'gdipShutdown@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetText(h:HWND; Text:PAnsiChar);  external 'BtnSetText@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetVisibility(h:HWND; Value:boolean); external 'BtnSetVisibility@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetFont(h:HWND; Font:Cardinal); external 'BtnSetFont@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetFontColor(h:HWND; NormalFontColor, FocusedFontColor, PressedFontColor, DisabledFontColor: Cardinal); external 'BtnSetFontColor@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetEvent(h:HWND; EventID:integer; Event:Longword); external 'BtnSetEvent@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetCursor(h:HWND; hCur:Cardinal); external 'BtnSetCursor@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetEnabled(h:HWND; Value:boolean); external 'BtnSetEnabled@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetChecked(h:HWND; Value:boolean); external 'BtnSetChecked@{tmp}\botva2.dll stdcall delayload';
procedure CreateFormFromImage(h:HWND; FileName:PAnsiChar); external 'CreateFormFromImage@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetPosition(h:HWND; NewLeft, NewTop, NewWidth, NewHeight: integer);  external 'BtnSetPosition@{tmp}\botva2.dll stdcall delayload';
procedure ImgSetVisiblePart(img:Longint; NewLeft, NewTop, NewWidth, NewHeight : integer); external 'ImgSetVisiblePart@files:botva2.dll stdcall';

////////////////////////////////////////////////////////////////////////////////////
// 检查网络连接是否正常
// lpszURL: 网址，如果这里设置为空网址，检测将会简单的检查网络状态，返回状态标志
// lpdwState: 状态标志，以下是标志值的解释
// 注意：当不用网址来检测网络连接时，只是检查当前是否符合网络连接的条件，但是并不等于
//       能正常连接 Internet，但是这种检测方式相当迅速，如果使用网址连接测试，如果网
//       络处于正常连接，检查速度也相当快，但是如果非正常，那么将会有一点时间延迟，因
//       为实际的连接测试有一个超时的限制来判断是否能够连接。但是这种检测方式是最直接
//       的，并能确实知道是否能够连接网络，所以你按照实际要求来选择检测方式。
//
//得到的 lpdwState 返回值可能是以下值的一个或几个值之和：
//  INTERNET_STATE_CONNECTED           ：$00000001 连接状态；
//  INTERNET_STATE_DISCONNECTED        ：$00000002 非连接状态（和 INTERNET_STATE_CONNECTED 对应）；
//  INTERNET_STATE_DISCONNECTED_BY_USER：$00000010 用户请求的非连接状态
//  INTERNET_STATE_IDLE                ：$00000100 连接状态，并且空闲
//  INTERNET_STATE_BUSY                ：$00000200 连接状态，正在响应连接请求
function CheckConnectState(lpsURL: PChar; var lpdwState: dword): boolean; external 'checkconnectstate@files:webctrl.dll stdcall';

// 创建 WEB 窗口
function NewWebWnd(hWndParent: HWND; X, Y, nWidth, nHeight: Integer): HWND; external 'newwebwnd@files:webctrl.dll stdcall';

// 释放 WEB 窗口
function FreeWebWnd(hWndWeb: HWND): Boolean; external 'freewebwnd@files:webctrl.dll stdcall';

// 释放所有 WEB 窗口, 此函数对于卸载插件很重要, 必须在结束安装之前调用才能顺利卸载插件.
function FreeAllWebWnd(): Boolean; external 'freeallwebwnd@files:webctrl.dll stdcall';

// 设置 WEB 窗口的父窗口
function WebWndSetParent(hWndWeb: HWND; hWndParent: HWND): Boolean; external 'webwndsetparent@files:webctrl.dll stdcall';

// 设置 WEB 窗口的位置大小
function WebWndSetBounds(hWndWeb: HWND; X, Y, nWidth, nHeight: Integer): Boolean; external 'webwndsetbounds@files:webctrl.dll stdcall';

// 显示 HTML 网页
function DisplayHTMLPage(hWndWeb: HWND; lpsURL: PChar): Boolean; external 'displayhtmlpage@files:webctrl.dll stdcall';

// 显示 HTML 字符串
function DisplayHTMLStr(hWndWeb: HWND; lpsHtmlText: PChar): Boolean; external 'displayhtmlstr@files:webctrl.dll stdcall';

// Web 页面 动作
function WebPageAction(hWndWeb: HWND; action: DWord): Boolean; external 'webpageaction@files:webctrl.dll stdcall';


//圆角
function CreateRoundRectRgn(p1, p2, p3, p4, p5, p6: Integer): THandle; external 'CreateRoundRectRgn@gdi32 stdcall';
function SetWindowRgn(hWnd: HWND; hRgn: THandle; bRedraw: Boolean): Integer; external 'SetWindowRgn@user32 stdcall';
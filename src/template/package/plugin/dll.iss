[code]
type
	TPBProc			= function(h:hWnd; Msg, wParam, lParam:Longint):Longint;
	TTimerProc		= procedure(h:longword; msg:longword; idevent:longword; dwTime:longword);
	TBtnEventProc = procedure(h:HWND);
	TAddingFinishCallbackProc = procedure(FrameCount: Integer);
  	TPlayFinishCallbackProc = procedure();

function WrapBtnCallback(Callback: TBtnEventProc; ParamCount: Integer): Longword;  external 'wrapcallback@files:innocallback.dll stdcall';
function WrapTimerProc(callback: TTimerProc; Paramcount: Integer): Longword; external 'wrapcallback@files:innocallback.dll stdcall';

//#include 'Win6TaskBar.mad8834671'
function GetSysColor(nIndex: Integer): DWORD; external 'GetSysColor@user32.dll stdcall';
function GetSystemMetrics(nIndex: Integer): Integer; external 'GetSystemMetrics@user32.dll stdcall';
function LoadCursorFromFile(FileName: String): Cardinal;external 'LoadCursorFromFile{#A}@user32 stdcall';
function DeleteObject(p1: Longword): BOOL; external 'DeleteObject@gdi32.dll stdcall';
function GetPM(nIndex:Integer):Integer; external 'GetSystemMetrics@user32.dll stdcall';
function SetLayeredWindowAttributes(hwnd:HWND; crKey:Longint; bAlpha:byte; dwFlags:longint ):longint; external 'SetLayeredWindowAttributes@user32 stdcall'; //��������

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

procedure ImgSetTransparent(img:Longint; Value:integer); external 'ImgSetTransparent@{tmp}\botva2.dll stdcall delayload';
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
// 检查网络连接是否正�??
// lpszURL: 网址，如果这里设置为空网址，检测将会简单的检查网络状态，返回状态标�??
// lpdwState: 状态标志，以下是标志值的解释
// 注意：当不用网址来检测网络连接时，只是检查当前是否符合网络连接的条件，但是并不等�??
//       能正常连�?? Internet，但是这种检测方式相当迅速，如果使用网址连接测试，如果网
//       络处于正常连接，检查速度也相当快，但是如果非正常，那么将会有一点时间延迟，�??
//       为实际的连接测试有一个超时的限制来判断是否能够连接。但是这种检测方式是最直接
//       的，并能确实知道是否能够连接网络，所以你按照实际要求来选择检测方式�?
//
//得到�?? lpdwState 返回值可能是以下值的一个或几个值之和：
//  INTERNET_STATE_CONNECTED           �??$00000001 连接状态；
//  INTERNET_STATE_DISCONNECTED        �??$00000002 非连接状态（�?? INTERNET_STATE_CONNECTED 对应）；
//  INTERNET_STATE_DISCONNECTED_BY_USER�??$00000010 用户请求的非连接状�?
//  INTERNET_STATE_IDLE                �??$00000100 连接状态，并且空闲
//  INTERNET_STATE_BUSY                �??$00000200 连接状态，正在响应连接请求
function CheckConnectState(lpsURL: PChar; var lpdwState: dword): boolean; external 'checkconnectstate@files:webctrl.dll stdcall';

// 创建 WEB 窗口
function NewWebWnd(hWndParent: HWND; X, Y, nWidth, nHeight: Integer): HWND; external 'newwebwnd@files:webctrl.dll stdcall';

// 释放 WEB 窗口
function FreeWebWnd(hWndWeb: HWND): Boolean; external 'freewebwnd@files:webctrl.dll stdcall';

// 释放所�?? WEB 窗口, 此函数对于卸载插件很重要, 必须在结束安装之前调用才能顺利卸载插�??.
function FreeAllWebWnd(): Boolean; external 'freeallwebwnd@files:webctrl.dll stdcall';

// 设置 WEB 窗口的父窗口
function WebWndSetParent(hWndWeb: HWND; hWndParent: HWND): Boolean; external 'webwndsetparent@files:webctrl.dll stdcall';

// 设置 WEB 窗口的位置大�??
function WebWndSetBounds(hWndWeb: HWND; X, Y, nWidth, nHeight: Integer): Boolean; external 'webwndsetbounds@files:webctrl.dll stdcall';

// 显示 HTML 网页
function DisplayHTMLPage(hWndWeb: HWND; lpsURL: PChar): Boolean; external 'displayhtmlpage@files:webctrl.dll stdcall';

// 显示 HTML 字符�??
function DisplayHTMLStr(hWndWeb: HWND; lpsHtmlText: PChar): Boolean; external 'displayhtmlstr@files:webctrl.dll stdcall';

// Web 页面 动作
function WebPageAction(hWndWeb: HWND; action: DWord): Boolean; external 'webpageaction@files:webctrl.dll stdcall';


//圆角
function CreateRoundRectRgn(p1, p2, p3, p4, p5, p6: Integer): THandle; external 'CreateRoundRectRgn@gdi32 stdcall';
function SetWindowRgn(hWnd: HWND; hRgn: THandle; bRedraw: Boolean): Integer; external 'SetWindowRgn@user32 stdcall';


function InitFairy(hParentWnd: HWND; RelativePos: Integer; Interval: Cardinal): Boolean;
external 'InitFairy@files:fairy.dll stdcall';
// 初始化精灵插�??:
// hParentWnd: 需要粘附的窗口句柄, 精灵会跟随这个窗口移�??.
// RelativePos: 精灵跟随窗口移动的相对位�??.
//        0: 以窗口左上角为原�??, 所有制定的 X, Y 坐标都是相对于该原点的距�??.
//        1: 以窗口右上角为原�??.
//        2: 以窗口左下角为原�??.
//        3: 以窗口右下角为原�??.
// Interval: 每个图片更新的速度(时间间隔, 单位: ms). 用来微调动作的快�??. 但是动作演示的快慢主要还是由制定图片序列的时候处�??,
//           例如 100ms 下的更新速度是比较合理的, 也就�?? 1 秒钟更新 10 张图�??. 所以在制定动作的时候以这个作为参考就好处理了.

function AddImgsToList(BmpFiles: AnsiString; FinishCallback: TAddingFinishCallbackProc): Boolean;
external 'AddImgsToList@files:fairy.dll stdcall';
// 添加图片到精灵插件中.
// BmpFiles: 批量图片处理的序�??.
//        格式: X1|Y1|BlendAlpha1|TransparentColor1|ImgFile1|X2|Y2|BlendAlpha2|TransparentColor2|ImgFile2|X3|Y3|BlendAlpha3|TransparentColor3|ImgFile3|.........
//              X: 相对于原点的水平坐标.
//              Y: 相对于原点的垂直坐标.
//              BlendAlpha: 精灵的整体透明程度. 不同于图片自身的透明通道, 即使图片有自身的 Alpha 通道,
//                   不透明的部分仍然会�?? BlendAlpha 的影�??.
//              TransparentColor: 透明颜色. 当图片没�?? Alpha 通道的时�??, 就会由该颜色定义透明部分.
//              ImgFile: 图片文件. 因为改用 GDI+ 作为精灵的图片引�??, 所以将会支持多�??(bmp, gif, tiff, emf, jpg)图片格式.
//                   当图片带�?? Alpha 通道的时�??, 将会按照通道来调整图片透明�??, 当没�?? Alpha 通道的时�??, 就会按照 TransparentColor
//                   来定义透明部分. 另外, 对于 GIF, 如果属于动画的多帧图�??, 精灵将会在载入时自动把图片分帧载�??.
//                   所以将会非常方便精灵的制作.
// FinishCallback: 因为批量添加大量图片可能会引起程序假�??, 所以我采用线程处理, 所以在载入图片的过程中, 安装程序仍然可以同步运行.
//        所�?? FinishCallback 就是添加图片过程完成的时候调用的回调函数, 通常都是在这个函数中调用 AnimateFairy 来运行精�??.

function AddImgToList(X, Y: Integer; BlendAlpha: Byte; TransparentColor: Integer; ImgFile: AnsiString): Integer;
external 'AddImgToList@files:fairy.dll stdcall';
// 添加图片到精灵插件中.
// 属于单图片添�??, 基本上这个函数只是给用户在程序中灵活运用而已, 上一函数已能完成此任�??.
// 参数请参看上一函数中的解释.

function ClearImgList(): Boolean; external 'ClearImgList@files:fairy.dll stdcall';
// 清除图片序列中的所有图�??.
// 因为图片是顺序添加到序列中的, 所以如果需要重新排列图�??, 必须清除所有图�??, 重新添加.

function AnimateFairy(IndexList: AnsiString; FinishCallback: TPlayFinishCallbackProc): Boolean;
external 'AnimateFairy@files:fairy.dll stdcall';
// 运行精灵, 也就是相当于序列图片的连续显�??.
// IndexList: 播放序列, 具体的使用方法请看以下几个例�??.
//        例子:
//          0-53,(54-79)
//          解释: 0 �?? 53 �??, 然后 54 �?? 79 帧循环播�??, 无限循环, 不会结束, 也就是说不会触发 FinishCallback 事件.
//          0-53,3(54-79)
//          解释: 具体跟上一例子的差别是 54 �?? 79 帧循环播�?? 3 次后结束, 并调�?? FinishCallback 回调函数.
//          10-2,13,45,60,54,2(70-0),(50-70)
//          解释: 10 �?? 2 帧倒序播放, 然后顺序显示 13,45,60,54 �??, 然后倒序循环播放 2 �?? 70 �?? 0 �??, 再然后无限循环播�?? 50 �?? 70 �??.
// FinishCallback: 如果播放序列没有无限循环, 则在结束播放�??, 就会调用这个回调函数.

function StopFairy(): Boolean; external 'StopFairy@files:fairy.dll stdcall';
// 停止播放.

function ResumeFairy(): Boolean; external 'ResumeFairy@files:fairy.dll stdcall';
// 显示并恢复播�??.

function HideFairy(): Boolean; external 'HideFairy@files:fairy.dll stdcall';
// 隐藏并停止播�??.

function ShowFairy(): Boolean; external 'ShowFairy@files:fairy.dll stdcall';
// 显示精灵.

function ShowFairyEx(ImgIndex: Integer): Boolean; external 'ShowFairyEx@files:fairy.dll stdcall';
// 显示某一帧的精灵.

procedure UninitFairy(); external 'UninitFairy@files:fairy.dll stdcall';
// 解除精灵插件.

// 精灵虽然会显示在主窗口的上面, 但是并不会遮挡鼠标的操作, 即使精灵下有一个按�??, 鼠标仍然可以穿透精灵点击后面的按钮.
// 但是对于非主窗口的其他窗�??, 鼠标操作并不能穿�??.
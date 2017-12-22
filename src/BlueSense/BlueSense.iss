#define MyAppId "BlueSense"
[Setup]
AppId={#MyAppId}
AppName={#MyAppId}
AppVersion=0.0.0.0
AppVerName={#MyAppId}
AppPublisher=mad8834671
DefaultDirName={pf}\{#MyAppId}
DefaultGroupName={#MyAppId}
AllowNoIcons=yes
OutputDir=.
OutputBaseFilename={#MyAppId}
SetupIconFile=installer.ico
UninstallIconFile=Uninstall.ico
Compression=lzma/ultra64
SolidCompression=yes
VersionInfoVersion=0.0.0.0
VersionInfoTextVersion=0.0.0.0
VersionInfoDescription={#MyAppId}
DisableReadyPage=yes
DisableProgramGroupPage=yes
InternalCompressLevel=ultra64
DirExistsWarning=no

[Messages]
BeveledLabel=mad8834671
DiskSpaceMBLabel=����ռ�: [mb] MB
ButtonBack=
ButtonNext=
ButtonInstall=
ButtonFinish=
ButtonBrowse=���...
ButtonWizardBrowse=���...
SetupAppTitle={#MyAppId}

[Icons]
Name: {commondesktop}\{#MyAppId}; Filename: {app}\1.exe; WorkingDir: {app}; Check: Desktop;
;Name: {group}\xxx; Filename: {app}\xxx.exe; WorkingDir: {app};
;Name: {group}\ж�� xxx; Filename: {uninstallexe}; WorkingDir: {app};
;Name: {commondesktop}\xxx; Filename: {app}\xxx.exe; WorkingDir: {app}; Check: Desktop;
;Name: {userappdata}\Microsoft\Internet Explorer\Quick Launch\xxx; Filename: {app}\bin\QQ.exe; WorkingDir: {app};

[Files]
Source: {tmp}\*; DestDir: {tmp}; Flags: dontcopy solidbreak;
Source: {app}\*; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs;

[code]
type
  TBtnEventProc = procedure (h:HWND);
  TPBProc = function(h:hWnd;Msg,wParam,lParam:Longint):Longint;  //�ٷֱ�

Const
  Radius  = 9;
  GWL_EXSTYLE = (-20);
//�����ƶ�
  WM_SYSCOMMAND = $0112;
//ж��
//  WS_EX_APPWINDOW = $40000;
//��ť
  BtnClickEventID      = 1;
  BtnMouseEnterEventID = 2;
//botva2
function GetWindowLong(Wnd: HWnd; Index: Integer): Longint; external 'GetWindowLongA@user32.dll stdcall';
function ImgLoad(Wnd :HWND; FileName :PAnsiChar; Left, Top, Width, Height :integer; Stretch, IsBkg :boolean) :Longint; external 'ImgLoad@{tmp}\botva2.dll stdcall delayload';
procedure ImgSetVisibility(img :Longint; Visible :boolean); external 'ImgSetVisibility@{tmp}\botva2.dll stdcall delayload';
procedure ImgApplyChanges(h:HWND); external 'ImgApplyChanges@{tmp}\botva2.dll stdcall delayload';
procedure ImgSetPosition(img :Longint; NewLeft, NewTop, NewWidth, NewHeight :integer); external 'ImgSetPosition@files:botva2.dll stdcall';
procedure gdipShutdown;  external 'gdipShutdown@{tmp}\botva2.dll stdcall delayload';
function WrapBtnCallback(Callback: TBtnEventProc; ParamCount: Integer): Longword; external 'wrapcallback@{tmp}\innocallback.dll stdcall delayload';
function BtnCreate(hParent:HWND; Left,Top,Width,Height:integer; FileName:PAnsiChar; ShadowWidth:integer; IsCheckBtn:boolean):HWND;  external 'BtnCreate@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetText(h:HWND; Text:PAnsiChar);  external 'BtnSetText@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetVisibility(h:HWND; Value:boolean); external 'BtnSetVisibility@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetFont(h:HWND; Font:Cardinal); external 'BtnSetFont@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetFontColor(h:HWND; NormalFontColor, FocusedFontColor, PressedFontColor, DisabledFontColor: Cardinal); external 'BtnSetFontColor@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetEvent(h:HWND; EventID:integer; Event:Longword); external 'BtnSetEvent@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetEnabled(h:HWND; Value:boolean); external 'BtnSetEnabled@{tmp}\botva2.dll stdcall delayload';
function BtnGetChecked(h:HWND):boolean; external 'BtnGetChecked@{tmp}\botva2.dll stdcall delayload';
function BtnGetEnabled(h:HWND):boolean; external 'BtnGetChecked@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetChecked(h:HWND; Value:boolean); external 'BtnSetChecked@{tmp}\botva2.dll stdcall delayload';
procedure CreateFormFromImage(h:HWND; FileName:PAnsiChar); external 'CreateFormFromImage@{tmp}\botva2.dll stdcall delayload';
function SetWindowLong(Wnd: HWnd; Index: Integer; NewLong: Longint): Longint; external 'SetWindowLongA@user32.dll stdcall';
function PBCallBack(P:TPBProc;ParamCount:integer):LongWord; external 'wrapcallback@files:innocallback.dll stdcall';
function CallWindowProc(lpPrevWndFunc: Longint; hWnd: HWND; Msg: UINT; wParam, lParam: Longint): Longint; external 'CallWindowProcA@user32.dll stdcall';
procedure ImgSetVisiblePart(img:Longint; NewLeft, NewTop, NewWidth, NewHeight : integer); external 'ImgSetVisiblePart@files:botva2.dll stdcall';
//Բ��
function CreateRoundRectRgn(p1, p2, p3, p4, p5, p6: Integer): THandle; external 'CreateRoundRectRgn@gdi32 stdcall';
function SetWindowRgn(hWnd: HWND; hRgn: THandle; bRedraw: Boolean): Integer; external 'SetWindowRgn@user32 stdcall';
function ReleaseCapture(): Longint; external 'ReleaseCapture@user32.dll stdcall';

procedure ShapeForm(aForm: TForm; edgeSize: integer);
var
  FormRegion:LongWord;
begin
  FormRegion:=CreateRoundRectRgn(0,0,aForm.Width,aForm.Height,edgeSize,edgeSize);
  SetWindowRgn(aForm.Handle,FormRegion,True);
end;

var
ErrorCode: Integer;
CancelForm: TSetupForm;
OKButton: TButton;
GerenfolderForm: TSetupForm;
WizardFormImage,DHIMG1: Longint;
SelectDirline, Gerenfolderline, Zidingyiline: Longint; 
MinBtn,CloseBtn: HWND;
CancelBtn,NextBtn, BackBtn, DirBrowseBtn,DirBrowseBtn2: HWND;
WFButtonFont : TFont;
M1,sversion,bigLabel,SelectDirLabel,ZidingyiLabe,FinishedLabel: Tlabel;
NewDirEdit: Tlabel;
setbtn,setbcbtn:Tlabel;
Frame1,Frame : TForm;
dx,dy,dh1 : integer;
IsFrameDragging : boolean;
web1Check,web2Check,DesktopCheck,Run1Check,Run2Check: HWND; //
web1Label,web2Label,Run1Label,DesktopLabel: TLabel;//  ,Run1Label,Run2Label
progressbgImg: Longint;
PrLabel: TLabel;
Jddh: TTimer;
PBOldProc : Longint;

//�ٷֱ�                   
function PBProc(h:hWnd;Msg,wParam,lParam:Longint):Longint;
var
  pr,i1,i2 : Extended;
//  p : string;
  w : integer;
begin
  Result:=CallWindowProc(PBOldProc,h,Msg,wParam,lParam);
  if (Msg=$402) and (WizardForm.ProgressGauge.Position>WizardForm.ProgressGauge.Min) then begin
    i1:=WizardForm.ProgressGauge.Position-WizardForm.ProgressGauge.Min;
    i2:=WizardForm.ProgressGauge.Max-WizardForm.ProgressGauge.Min;
    pr:=i1*100/i2;
    PrLabel.Caption:='���ڰ�װ'+IntToStr(Round(pr))+'%';
    w:=Round(460*pr/100);
    ImgSetPosition(progressbgImg,4,250,w,10);
    ImgSetVisiblePart(progressbgImg,0,0,w,10);
    ImgApplyChanges(WizardForm.Handle);
  end;
end;

//����

procedure WizardMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture
  SendMessage(WizardForm.Handle, WM_SYSCOMMAND, $F012, 0)
end;

procedure WizardFormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IsFrameDragging:=True;
  dx:=X;
  dy:=Y;
end;

procedure WizardFormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IsFrameDragging:=False;
  WizardForm.Show;
end;

procedure WizardFormMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
begin
  if IsFrameDragging then begin
    WizardForm.Left:=WizardForm.Left+X-dx;
    WizardForm.Top:=WizardForm.Top+Y-dy;
    Frame.Left:=WizardForm.Left-10;
    Frame.Top:=WizardForm.Top-10;
  end;
end;
procedure frameFormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  WizardForm.Show;
end;

procedure WizardFormcc;
begin
    WizardForm.OnMouseDown:=@WizardFormMouseDown;
    WizardForm.OnMouseUp:=@WizardFormMouseUp;
    WizardForm.OnMouseMove:=@WizardFormMouseMove;
end;

procedure CreateFrame;
begin
  IsFrameDragging:=False;
  Frame:=TForm.Create(nil);;
  Frame.BorderStyle:=bsNone;
  CreateFormFromImage(Frame.Handle,ExpandConstant('{tmp}\frame.png'));
  with WizardForm do begin
    Left:=Frame.Left+10;
    Top:=Frame.Top+10;
    ClientWidth:=Frame.ClientWidth-10*2;
    ClientHeight:=Frame.ClientHeight-10*2;

    AutoScroll := False;
		BorderStyle:=bsNone;
		InnerNotebook.Hide;
		OuterNotebook.Hide;
		Bevel.Hide;
		Center;
		NextButton.Width:=0;
		BackButton.Width:=0;
		CancelButton.Width:=0;
  end
  SetWindowLong(WizardForm.Handle, GWL_EXSTYLE, GetWindowLong(WizardForm.Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
	SetLayeredWindowAttributes(WizardForm.Handle, TransparentColor, 250, LWA_COLORKEY or LWA_ALPHA);
  Frame.Show;
end;


procedure CancelFormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture
  SendMessage(CancelForm.Handle, WM_SYSCOMMAND, $F012, 0)
end;

//���� //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//��·������
procedure GerenfolderFormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture
  SendMessage(GerenfolderForm.Handle, WM_SYSCOMMAND, $F012, 0)
end;

procedure GerenfoldeFormCancleBtnOnClick(hBtn:HWND);
begin
GerenfolderForm.close;
end;

procedure GerenfoldeBtnOnClick(hBtn:HWND);
begin
GerenfolderForm.close;
end;

//ȡ�����ڹرհ�ť
procedure CancelCloseBtnOnClick(hBtn:HWND);
begin
CancelForm.close;
end;

procedure CancelClose1BtnOnClick(hBtn:HWND);
begin
CancelForm.close;
Frame1.Close;
end;

procedure OKBtnOnClick(hBtn:HWND);
begin
OKButton.Click;
Frame1.Close;
end;

procedure CancelBtnOnClick(hBtn:HWND);
begin
CancelForm.close;
end;

//��С����ť
procedure MinBtnOnClick(hBtn:HWND);
begin
SendMessage(WizardForm.Handle,WM_SYSCOMMAND,61472,0);
end;
//�رհ�ť
procedure CloseBtnOnClick(hBtn:HWND);
begin
WizardForm.Close;
end;

procedure BackBtnClick(hBtn:HWND);
begin
WizardForm.BackButton.Click;
end;

procedure NextBtnClick(hBtn:HWND);
begin
WizardForm.NextButton.Click;
end;

procedure CancelBtnClick(hBtn:HWND);
begin
WizardForm.CancelButton.Click;
end;

procedure DirBrowseBtnClick(hBtn:HWND);
begin
WizardForm.DirBrowseButton.Click;
end;

//�߼�ѡ��
procedure setting(Sender: TObject);
begin
  bigLabel.Hide;
  sversion.Hide;
  web1label.show;
  web2label.show;
  setbcbtn.show;
  DesktopLabel.show;
  setbtn.hide;
  SelectDirLabel.hide;
  NewDirEdit.hide;
  ZidingyiLabe.show;
  BtnSetEnabled(NextBtn,False);
  BtnSetVisibility(DesktopCheck,true);
  Run1Label.Show;                //���п�1
  BtnSetVisibility(Run1Check,True);
  BtnSetVisibility(web1check,true);
  BtnSetVisibility(web2check,true);
end;
//����
procedure settingbcbtn(Sender: TObject);
begin
  bigLabel.show;
  sversion.show;
  web1label.hide;
  web2label.hide;
  setbcbtn.hide;
  setbtn.show;
  DesktopLabel.hide;
  ZidingyiLabe.hide;
  SelectDirLabel.show;
  NewDirEdit.show;
  BtnSetEnabled(NextBtn,true);
  BtnSetVisibility(DesktopCheck,False);
  Run1Label.hide;                //���п�1
  BtnSetVisibility(Run1Check,false);
  BtnSetVisibility(web1check,False);
  BtnSetVisibility(web2check,False);
end;

//����·��
procedure NewDirBrowseButtonClick(Sender: TObject);
begin
  WizardForm.DirBrowseButton.Click;
  NewDirEdit.Caption:=WizardForm.DirEdit.Text;
end;

//��ݷ�ʽѡ��
function Desktop: Boolean;     
begin
  Result:= BtnGetChecked(DesktopCheck);
end;

procedure DesktopLabelClick(Sender:TObject);
begin
  BtnSetChecked(DesktopCheck, not BtnGetChecked(DesktopCheck));
end;

procedure web1LabelClick(Sender:TObject);
begin
  BtnSetChecked(web1Check, not BtnGetChecked(web1Check));
end;
procedure web2LabelClick(Sender:TObject);
begin
  BtnSetChecked(web2Check, not BtnGetChecked(web2Check));
end;

//sͼƬ����
procedure Jddhj_pro(Sender:TObject);
begin
  dh1:=dh1+1;
  DHIMG1:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\D'+IntToStr(dH1)+'.png'),(14), (24),440,150,True,True);
if dh1>3 then
  begin
  dh1:=1
  DHIMG1:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\D1.png'),(14), (24),440,150,True,True);
  end
  ImgApplyChanges(WizardForm.Handle)
end;

//���п�
procedure Run1LabelClick(Sender:TObject);
begin
  BtnSetChecked(Run1Check, not BtnGetChecked(Run1Check));
end;

procedure Run2LabelClick(Sender:TObject);
begin
  BtnSetChecked(Run2Check, not BtnGetChecked(Run2Check));
end;


//��������
function ShouldSkipPage(PageID: Integer): Boolean;
begin
if PageID=wpSelectComponents then    //���������װ����
  result := true;
if PageID=wpWelcome then
  result := true;
if PageID=wpFinished then
  result := true;
end;

procedure InitializeWizard(); //1399
begin
ExtractTemporaryFile('frame.png');
ExtractTemporaryFile('MinBtn.png');
ExtractTemporaryFile('CloseBtn.png');
ExtractTemporaryFile('btnIn.png');
ExtractTemporaryFile('CheckBox.png');
ExtractTemporaryFile('line.png');
ExtractTemporaryFile('progressbar.png');
ExtractTemporaryFile('window.png');
ExtractTemporaryFile('D1.png');
ExtractTemporaryFile('D2.png');
ExtractTemporaryFile('D3.png');
WFButtonFont:=TFont.Create;
WizardForm.BorderStyle:=bsNone; //ȥ�߿�
WizardForm.ClientWidth:=468;
WizardForm.ClientHeight:=287;
WizardFormcc;
CreateFrame;
//����ͼ
WizardFormImage:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\frame.png'),(-10), (-10),WizardForm.ClientWidth,WizardForm.ClientHeight,True,True);

setbtn := TLabel.Create(WizardForm);
setbtn.Parent := WizardForm;
setbtn.Font.Name := '΢���ź�';
setbtn.Font.Size := 9
setbtn.Font.Color := $3cef3c;
setbtn.Font.Style := [fsUnderline];
setbtn.Transparent := True;
setbtn.AutoSize := False;
setbtn.WordWrap := True;
setbtn.OnClick :=@setting;
setbtn.Caption := ExpandConstant('�߼�ѡ��');
setbtn.SetBounds((10), (245), WizardForm.Width, (16));

setbcbtn := TLabel.Create(WizardForm);
setbcbtn.Parent := WizardForm;
setbcbtn.Font.Name := '΢���ź�';
setbcbtn.Font.Size := 9
setbcbtn.Font.Color := $3cef3c;
setbcbtn.Font.Style := [fsUnderline];
setbcbtn.Transparent := True;
setbcbtn.AutoSize := False;
setbcbtn.WordWrap := True;
setbcbtn.OnClick :=@settingbcbtn;
setbcbtn.Caption := ExpandConstant('���ذ�װ');
setbcbtn.SetBounds(setbtn.left, setbtn.top, WizardForm.Width, (16));

//��С����ť
MinBtn:=BtnCreate(WizardForm.Handle,428,4,16,16,ExpandConstant('{tmp}\MinBtn.png'),3,False);
BtnSetEvent(MinBtn,BtnClickEventID,WrapBtnCallback(@MinBtnOnClick,1));
//�رհ�ť
CloseBtn:=BtnCreate(WizardForm.Handle,448,4,16,16,ExpandConstant('{tmp}\CloseBtn.png'),3,False);
BtnSetEvent(CloseBtn,BtnClickEventID,WrapBtnCallback(@CloseBtnOnClick,1));

//WizardForm
WizardForm.OuterNotebook.Hide;
WizardForm.Bevel.Hide;
WizardForm.BeveledLabel.Width := 0
WizardForm.BeveledLabel.Height := 0

//��ť
//��һ��
NextBtn:=BtnCreate(WizardForm.Handle,200,230,80,28,ExpandConstant('{tmp}\btnIn.png'),1,False);
BtnSetEvent(NextBtn,BtnClickEventID,WrapBtnCallback(@NextBtnClick,1));
BtnSetFont(NextBtn,WFButtonFont.Handle);
BtnSetFontColor(NextBtn,Clblack,Clblack,Clblack,$B6B6B6);
WizardForm.NextButton.Width:=0;
WizardForm.NextButton.Height:=0;

//���ǩ
bigLabel := TLabel.Create(WizardForm);
bigLabel.Parent := WizardForm;
bigLabel.Font.Name := '΢���ź�';
bigLabel.Font.Size := 20
bigLabel.Font.Style := [fsBold];
bigLabel.Font.Color := clWhite;
bigLabel.Transparent := True;
bigLabel.AutoSize := True;
bigLabel.SetBounds((10), (25), (300), (30));
bigLabel.Caption := 'Blue Sense ��ʾ��װ��'
bigLabel.OnMouseDown:=@WizardFormMouseDown;
bigLabel.OnMouseUp:=@WizardFormMouseUp;

//��װ�汾
sversion := TLabel.Create(WizardForm);
sversion.Parent := WizardForm;
sversion.Font.Name := '΢���ź�';
sversion.Font.Size := 9
bigLabel.Font.Style := [fsBold];
sversion.Font.Color := clWhite;
sversion.Transparent := True;
sversion.AutoSize := False;
sversion.SetBounds((10), (75), (150), (16));
sversion.Caption := '��װ�汾��1.21.2903.11'

//��װĿ¼
SelectDirLabel := TLabel.Create(WizardForm);
SelectDirLabel.Parent := WizardForm;
SelectDirLabel.Font.Name := '΢���ź�';
SelectDirLabel.Font.Size := 9
SelectDirLabel.Font.Color := $3cef3c;
SelectDirLabel.Transparent := True;
SelectDirLabel.AutoSize := False;
SelectDirLabel.WordWrap := True;
SelectDirLabel.SetBounds((10), (120), (100), (16));
SelectDirLabel.Caption := 'Ĭ�ϰ�װ·��:'  //�ؼ�����  '#13'



//����·��
NewDirEdit:=TLabel.Create(WizardForm);
NewDirEdit.Parent:=WizardForm;
NewDirEdit.Transparent:=True;
NewDirEdit.Left:=SelectDirLabel.Left + 19;
NewDirEdit.Top:=SelectDirLabel.Top + 15
NewDirEdit.Caption:=WizardForm.DirEdit.Text;
NewDirEdit.Font.Style := [fsBold,fsUnderline];
NewDirEdit.Font.Color := $3cef3c;
NewDirEdit.OnClick := @NewDirBrowseButtonClick;


//�Զ��尲װѡ��
ZidingyiLabe := TLabel.Create(WizardForm);
ZidingyiLabe.Parent := WizardForm;
ZidingyiLabe.Font.Name := '΢���ź�';
ZidingyiLabe.Font.Size := 20
ZidingyiLabe.Font.Style := [fsBold];
ZidingyiLabe.Font.Color := clWhite;
ZidingyiLabe.Transparent := True;
ZidingyiLabe.AutoSize := False;
ZidingyiLabe.WordWrap := True;
ZidingyiLabe.SetBounds(10, 25, (120), (35));
ZidingyiLabe.Caption := '��װѡ��'  //�ؼ�����  '#13'


//��ݷ�ʽѡ��
//�����ݷ�ʽ
DesktopCheck:=BtnCreate(WizardForm.Handle,SelectDirLabel.Left  + (16), ZidingyiLabe.Top + (76), (15), (15),ExpandConstant('{tmp}\CheckBox.png'),1,True);
DesktopLabel := TLabel.Create(WizardForm);
DesktopLabel.AutoSize:=False;
DesktopLabel.SetBounds(SelectDirLabel.Left  + (35), ZidingyiLabe.Top + (75), (98), (16));
DesktopLabel.OnClick:= @DesktopLabelClick;
DesktopLabel.Transparent:=True;
DesktopLabel.Font.Color := clWhite;
DesktopLabel.Font.Name := '΢���ź�'
DesktopLabel.Font.Size := 9
DesktopLabel.Caption := '�����ݷ�ʽ';
DesktopLabel.Parent := WizardForm;
//web1
web1Check:=BtnCreate(WizardForm.Handle,SelectDirLabel.Left  + (16), DesktopLabel.Top + (31), (15), (15),ExpandConstant('{tmp}\CheckBox.png'),1,True);
web1Label := TLabel.Create(WizardForm);
web1Label.AutoSize:=False;
web1Label.SetBounds(SelectDirLabel.Left  + (35), DesktopLabel.Top + (30), (98), (16));
web1Label.OnClick:= @web1LabelClick;
web1Label.Transparent:=True;
web1Label.Font.Color := clWhite;
web1Label.Font.Name := '΢���ź�'
web1Label.Font.Size := 9
web1Label.Caption := '�򿪰ٶ�';
web1Label.Parent := WizardForm;

//web2
web2Check:=BtnCreate(WizardForm.Handle,SelectDirLabel.Left  + (16), web1Label.Top + (31), (15), (15),ExpandConstant('{tmp}\CheckBox.png'),1,True);
web2Label := TLabel.Create(WizardForm);
web2Label.AutoSize:=False;
web2Label.SetBounds(SelectDirLabel.Left  + (35), web1Label.Top + (30), (98), (16));
web2Label.OnClick:= @web2LabelClick;
web2Label.Transparent:=True;
web2Label.Font.Color := clWhite;
web2Label.Font.Name := '΢���ź�'
web2Label.Font.Size := 9
web2Label.Caption := '���Ա�';
web2Label.Parent := WizardForm;

//�ٷֱ�                     1211
PrLabel:=TLabel.Create(WizardForm);
PrLabel.Parent:=WizardForm;
PrLabel.Left:=3;
PrLabel.Top:=230;;
PrLabel.Caption:='0%';
PrLabel.Font.Style := [fsBold];
PrLabel.Font.Color:=clWhite;
PrLabel.Font.Size:= 10
PrLabel.Transparent:=True;
PBOldProc:=SetWindowLong(WizardForm.ProgressGauge.Handle,-4,PBCallBack(@PBProc,4));

Jddh:= TTimer.Create(WizardForm);
  with Jddh do
  begin
    Enabled:=true;
    Interval:=0;
    OnTimer:=@Jddhj_pro;
  end;
  
//��װ���
FinishedLabel := TLabel.Create(WizardForm);
FinishedLabel.Parent := WizardForm;
FinishedLabel.Font.Name := '΢���ź�';
FinishedLabel.Font.Size := 9
FinishedLabel.Transparent := True;
FinishedLabel.AutoSize := False;
FinishedLabel.WordWrap := True;
FinishedLabel.SetBounds((60), (50), (100), (16));
FinishedLabel.Caption := '��װ���';  //�ؼ�����  '#13'

//���п�                            //
Run1Check:=BtnCreate(WizardForm.Handle,SelectDirLabel.left  + (16),web2Label.Top + (31),(15),(15),ExpandConstant('{tmp}\CheckBox.png'),1,True);
Run1Label := TLabel.Create(WizardForm);
Run1Label.AutoSize:=False;
Run1Label.SetBounds(DesktopLabel.Left, web2Label.Top + (30), (135), (16));
Run1Label.OnClick:= @Run1LabelClick;
Run1Label.Transparent:=True;
Run1Label.Font.Color := clWhite;
Run1Label.Font.Name := '΢���ź�'
Run1Label.Font.Size := 9
Run1Label.Caption := '��װ����������{#MyAppId}';
Run1Label.Parent := WizardForm;

//Run2Check:=BtnCreate(WizardForm.Handle,(85),(100),(16),(16),ExpandConstant('{tmp}\CheckBox.png'),1,True);
//Run2Label := TLabel.Create(WizardForm);
//Run2Label.AutoSize:=False;
//Run2Label.SetBounds(Run1Label.Left, (102), (150), (16));
//Run2Label.OnClick:= @Run2LabelClick;
//Run2Label.Transparent:=True;
//Run2Label.Caption := '�� {#MyAppId}';
//Run2Label.Parent := WizardForm;
end;


//ȡ������
procedure CancelButtonClick(CurPageID: Integer; var Cancel, Confirm: Boolean);
begin
Confirm:= false;
Cancel:=True;
end;
                

procedure CurPageChanged(CurPageID: Integer);
begin
    BtnSetText(BackBtn,WizardForm.BackButton.Caption);
    BtnSetVisibility(BackBtn,WizardForm.BackButton.Visible);

    BtnSetText(NextBtn,WizardForm.NextButton.Caption);
    BtnSetVisibility(NextBtn,WizardForm.NextButton.Visible);

    BtnSetText(CancelBtn,WizardForm.CancelButton.Caption);
    BtnSetVisibility(CancelBtn,WizardForm.CancelButton.Visible);

    BtnSetText(DirBrowseBtn,WizardForm.DirBrowseButton.Caption);
    BtnSetVisibility(DirBrowseBtn,False);
    
    ImgSetVisibility(SelectDirline,False);
    ImgSetVisibility(Gerenfolderline,False);
    ImgSetVisibility(Zidingyiline,False);
    
    NewDirEdit.hide
//��ݷ�ʽѡ��
    DesktopLabel.Hide;
    Run1Label.Hide;
//    Run2Label.Hide;
    BtnSetVisibility(DesktopCheck,False);
    BtnSetVisibility(Run1Check,False);
    BtnSetVisibility(web1check,False);
    BtnSetVisibility(web2check,False);
//    BtnSetVisibility(Run2Check,False);
    bigLabel.Hide;
    sversion.Hide;
    setbcbtn.hide
    SelectDirLabel.hide
    ZidingyiLabe.hide
    web1Label.hide;
    web2label.Hide;
    WizardForm.DirEdit.hide
    BtnSetVisibility(DirBrowseBtn2,False);
    WizardForm.ComponentsList.hide;
    WizardForm.DiskSpaceLabel.hide
    FinishedLabel.hide
    PrLabel.hide
  if CurPageID = wpWelcome then     
    begin
    WizardFormImage:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\frame.png'),(-10), (-10),520 ,340,True,True);
    BtnSetVisibility(CancelBtn,True);
    BtnSetEnabled(CancelBtn,False)
    end;
  if CurPageID = wpSelectDir then
    begin
    WizardFormImage:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\frame.png'),(-10), (-10),520 ,340,True,True);
    WizardFormImage:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\line.png'),(10), (65), (350), (3),True,True);
    SelectDirLabel.show
    NewDirEdit.show
    sversion.show;
    biglabel.show
    BtnSetVisibility(CancelBtn,True);
    BtnSetEnabled(CancelBtn,True)
    
    end;
  if CurPageID = wpInstalling then
    begin
    WizardFormImage:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\frame.png'),(-10), (-10),520 ,340,True,True);
    DHIMG1:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\D1.png'),(14), (24),440,150,True,True);
    progressbgImg:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\progressbar.png'),0,0,0,0,True,True);
    Jddh.Interval:=2000;
    PrLabel.show
    setbtn.Hide;
//��װ���̻ҵ�ť

    BtnSetVisibility(BackBtn,False);
    BtnSetVisibility(NextBtn,False);
    BtnSetText(NextBtn,'    '); //��װ��ť����
    BtnSetEnabled(BackBtn,False)
    BtnSetEnabled(NextBtn,False)
    BtnSetVisibility(CancelBtn,False);
    BtnSetEnabled(CancelBtn,False)
    end; 
    if CurPageID = wpFinished then
    begin
    Jddh.Interval:=0;
    end;
ImgApplyChanges(WizardForm.Handle);
end;

procedure DeinitializeSetup();
begin
gdipShutdown;
if PBOldProc<>0 then SetWindowLong(WizardForm.ProgressGauge.Handle,-4,PBOldProc);
end;

//��װ��������"���"֮�����г���
procedure CurStepChanged(CurStep: TSetupStep);
var
RCode: Integer;
begin
if (CurStep=ssDone) and (BtngetChecked(Run1Check)) then
Exec(ExpandConstant('{app}\1.exe'), '', '', SW_SHOW, ewNoWait, RCode);
if (CurStep=ssDone) and (BtngetChecked(web1Check)) then
ShellExec('open', 'http://www.baidu.com/', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
if (CurStep=ssDone) and (BtngetChecked(web2Check)) then
ShellExec('open', 'http://www.taobao.com/', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
////if (CurStep=ssDone) and (BtngetChecked(Run2Check)) then
////Exec(ExpandConstant('{app}\Bin\QQ.exe'), '', '', SW_SHOW, ewNoWait, RCode);
end;

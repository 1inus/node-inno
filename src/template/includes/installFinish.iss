var
	finishedBtn: Longint;

//安装完启动app
procedure RunApp(hBtn:HWND);
var RCode: Integer;
begin
	Exec(ExpandConstant('{app}\{#appName}' + '.exe'), '', '', SW_SHOW, ewNoWait, RCode);
	WizardForm.NextButton.Click;
end;

//初始化正在安装中界面
procedure createFinishPanel(panelLeft, panelTop, btnWidth, btnHeight:Longint);
var btnLeft, btnTop:Longint;
begin
	btnLeft:=(win_width-btnWidth)/2;
	btnTop:=panelTop+(win_Height-panelTop-btnHeight)/2;
	finishedBtn:=BtnCreate(WizardForm.Handle, btnLeft, btnTop, btnWidth, btnHeight, ExpandConstant('{tmp}\startAppBtn.png'), 3, False);
	BtnSetEvent(finishedBtn, BtnClickEventID, WrapBtnCallback(@RunApp, 1));
	BtnSetVisibility(finishedBtn, false);
end;

//显示安装完毕页面
procedure showFinishedPanel;
begin
	BtnSetVisibility(finishedBtn, true);
end;
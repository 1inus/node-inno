var
	finishedBtn: Longint;
	finishedText:TLabel;

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
	finishedBtn:=BtnCreate(WizardForm.Handle, 275, 428, 250, 50, ExpandConstant('{tmp}\startAppBtn.png'), 3, False);
	BtnSetEvent(finishedBtn, BtnClickEventID, WrapBtnCallback(@RunApp, 1));
	BtnSetVisibility(finishedBtn, false);

	finishedText := TLabel.Create(WizardForm);
	with finishedText do begin
		Alignment:=taCenter;
		AutoSize:=false;
		Transparent:=true;
		Parent:=WizardForm;
		Left := 0;
		Top := 385;
		Width := 800;
		height := 30;
		Caption:='安装完毕';
		Font.Name := fontName;
		Font.Color:=$20ad11;
		Font.Size:= 30-12;
		OnMouseDown:=@WizardFormMouseDown;
		OnMouseUp:=@WizardFormMouseUp;
		OnMouseMove:=@WizardFormMouseMove;
		hide;
	end;
end;

//显示安装完毕页面
procedure showFinishedPanel;
begin
	BtnSetVisibility(finishedBtn, true);
	finishedText.show;
end;
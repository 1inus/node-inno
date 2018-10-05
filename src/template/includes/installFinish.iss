var
	finishedBtn: Longint;
	finishedText:TLabel;

//安装完启动app
procedure RunApp(hBtn:HWND);
var RCode: Integer;
begin
	Exec(ExpandConstant('{app}\{#exeName}'), '', '', SW_SHOW, ewNoWait, RCode);
	WizardForm.NextButton.Click;
end;

//初始化正在安装中界面
procedure createFinishPanel();
var btnLeft, btnTop:Longint;
begin
	finishedBtn:=BtnCreate(WizardForm.Handle, {{ui.finishButton.left}}, {{ui.finishButton.top}}, {{ui.finishButton.width}}, {{ui.finishButton.height}}, ExpandConstant('{tmp}\startAppBtn.png'), 3, False);
	BtnSetEvent(finishedBtn, BtnClickEventID, WrapBtnCallback(@RunApp, 1));
	BtnSetVisibility(finishedBtn, false);

	finishedText := TLabel.Create(WizardForm);
	with finishedText do begin
		Alignment:=taCenter;
		AutoSize:=false;
		Transparent:=true;
		Parent:=WizardForm;
		Left := ScaleX({{ui.finishText.left}});
		Top := ScaleY({{ui.finishText.top}});
		Width := ScaleX({{ui.finishText.width}});
		height := ScaleY({{ui.finishText.height}});
		Caption:='{{ui.finishText.text}}';
		Font.Name := fontName;
		Font.Color:=${{ui.finishText.color}};
		Font.Size:= {{ui.finishText.height}}-12;
		OnMouseDown:=@WizardFormMouseDown;
		hide;
	end;
end;

//显示安装完毕页面
procedure showFinishedPanel;
begin
	BtnSetVisibility(finishedBtn, true);
	finishedText.show;
end;
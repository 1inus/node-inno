procedure _checkboxLabelClick(Sender: TObject);
var btnId : HWND;
begin
	btnId := TLabel(Sender).Tag;
	BtnSetChecked(btnId, not BtnGetChecked(btnId));
end;

function createCheckBoxBtn(posiLeft:Longint; posiTop:Longint; btnParent:TWinControl; labelText:string; labelWdith:Longint; isChecked:Boolean):TLabel;
var btnId:HWND;
	mylabel:TLabel;
	offsetY:Integer;
begin
	btnId :=BtnCreate(btnParent.Handle, ScaleX(posiLeft), ScaleY(posiTop), ScaleX({{ui.checkboxSize}}), ScaleY({{ui.checkboxSize}}), ExpandConstant('{tmp}\CheckBox.png'),1,true);
	
	mylabel := TLabel.Create(WizardForm);
	with mylabel do begin
		AutoSize:=true;
		Transparent:=True;
		Font.Size := 10;
		Font.Name := fontName;
		Caption := labelText;
		Parent := btnParent;
		Tag := btnId;
		OnClick := @_checkboxLabelClick; 
	end;
	//调整一下上下对齐
	offsetY := Round(({{ui.checkboxSize}}-mylabel.height) div 2);

	mylabel.SetBounds(ScaleX(posiLeft+{{ui.checkboxSize}}+4), ScaleY(posiTop+offsetY), ScaleX(labelWdith), ScaleY(14));
	BtnSetChecked(btnId, isChecked);
	
	result := mylabel;
end;

//安装按钮点击
procedure installBtnClick(hBtn:HWND);
begin
	WizardForm.NextButton.Click;
end;

//自定义最小化按钮
procedure MinimizeOnClick(hBtn:HWND);
begin
	SendMessage(WizardForm.Handle, WM_SYSCOMMAND, 61472, 0);
end;

//自定义关闭按钮点击事件
procedure CloseBtnOnClick(hBtn:HWND);
begin
	//安装完毕（直接跳过安装）
	if installStep = wpFinished then begin
		WizardForm.NextButton.Click;
	end else if installStep = wpWelcome then begin
		WizardForm.Close;
	end;
end;

//单击“取消”直接退出 inno回调函数。inno
procedure CancelButtonClick(CurPageID: Integer; var Cancel, Confirm: Boolean);
begin
	//Cancel := false;
	//case installStep of
		//wpInstalling : begin end;
		//wpFinished : begin end;
	//else if MsgBox('是否退出安装', mbConfirmation, MB_YESNO) = IDYES then begin
			//Confirm:= false;
			//Cancel := true;
		//end;
	//end;
	Confirm:= false;
	Cancel := true;
end;







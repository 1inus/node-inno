procedure _checkboxLabelClick(Sender: TObject);
var btnId : HWND;

begin
	btnId := TLabel(Sender).Tag;
	BtnSetChecked(btnId, not BtnGetChecked(btnId));
end;

function createCheckBoxBtn(posiLeft:Longint; posiTop:Longint; btnParent:TWinControl; labelText:string; labelWdith:Longint; isChecked:Boolean):TLabel;
var btnId:HWND;
	mylabel:TLabel;
begin
	btnId :=BtnCreate(btnParent.Handle, posiLeft, posiTop, 16, 16, ExpandConstant('{tmp}\CheckBox.png'),1,true);
	
	mylabel := TLabel.Create(WizardForm);
	with mylabel do begin
		AutoSize:=true;
		SetBounds(posiLeft+20, posiTop-2, labelWdith, 14);
		Transparent:=True;
		Font.Size := 10;
		Font.Name := fontName;
		Caption := labelText;
		Parent := btnParent;
		Tag := btnId;
		OnClick := @_checkboxLabelClick; 
	end;
	
	BtnSetChecked(btnId, isChecked);
	
	result := mylabel;
end;

function ColorToRGB(Color: TColor): Longint;
begin
	if Color < 0 then
		Result := GetSysColor(Color and $000000FF)
	else
		Result := Color;
end;


//安装界面准备初始化，释放文件到临时目录
procedure ExtractTmpFiles;
begin
	ExtractTemporaryFile('bg.png');
	ExtractTemporaryFile('bg.bmp');
	ExtractTemporaryFile('minimizeBtn.png');
	ExtractTemporaryFile('closeBtn.png');
	ExtractTemporaryFile('installBtn.png');
	ExtractTemporaryFile('startAppBtn.png');
	ExtractTemporaryFile('browserBtn.png');
	ExtractTemporaryFile('checkBox.png');
	ExtractTemporaryFile('license.txt');
	ExtractTemporaryFile('progress.png');
	ExtractTemporaryFile('progressBg.png');
end;

//拖动窗口
procedure WizardFormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	ReleaseCapture
	SendMessage(WizardForm.Handle, WM_SYSCOMMAND, $F012, 0)
end;

//安装按钮点击
procedure installBtnClick(hBtn:HWND);
begin
	WizardForm.NextButton.Click;
end;

//自定义最小化按钮
procedure MinimizeOnClick(hBtn:HWND);
begin
	SendMessage(WizardForm.Handle, WM_SYSCOMMAND,61472,0);
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







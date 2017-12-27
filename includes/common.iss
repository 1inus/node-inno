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

//��װ��ť���
procedure installBtnClick(hBtn:HWND);
begin
	WizardForm.NextButton.Click;
end;

//�Զ�����С����ť
procedure MinimizeOnClick(hBtn:HWND);
begin
	SendMessage(WizardForm.Handle, WM_SYSCOMMAND,61472,0);
end;

//�Զ���رհ�ť����¼�
procedure CloseBtnOnClick(hBtn:HWND);
begin
	//��װ��ϣ�ֱ��������װ��
	if installStep = wpFinished then begin
		WizardForm.NextButton.Click;
	end else if installStep = wpWelcome then begin
		FreeAllWebWnd;
		WizardForm.Close;
	end;
end;

//������ȡ����ֱ���˳� inno�ص�������inno
procedure CancelButtonClick(CurPageID: Integer; var Cancel, Confirm: Boolean);
begin
	//Cancel := false;
	//case installStep of
		//wpInstalling : begin end;
		//wpFinished : begin end;
	//else if MsgBox('�Ƿ��˳���װ', mbConfirmation, MB_YESNO) = IDYES then begin
			//Confirm:= false;
			//Cancel := true;
		//end;
	//end;
	Confirm:= false;
	Cancel := true;
end;







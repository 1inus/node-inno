var Minimize, CloseBtn: HWND; //���Ͻǰ�ť+ȡ������
	mainBg : Longint; //����ͼ

procedure resetMainWindow(winWidth:Longint; winHeight:Longint);
begin
	//ȡ��Ĭ�ϵ�ui
	with WizardForm do begin
		AutoScroll := False;
		BorderStyle:=bsNone;
		ClientWidth:=win_Width;
		ClientHeight:=win_Height;
		InnerNotebook.Hide;
		OuterNotebook.Hide;
		Color:=TransparentColor;
		Bevel.Hide;
		Center;
		NextButton.Width:=0;
		BackButton.Width:=0;
		CancelButton.Width:=0;
	end;
	
	//����͸��
	//SetWindowLong(WizardForm.Handle, GWL_EXSTYLE, GetWindowLong(WizardForm.Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
	//SetLayeredWindowAttributes(WizardForm.Handle, TransparentColor, 250, LWA_COLORKEY or LWA_ALPHA);

	//�����϶�
	WizardForm.OnMouseDown := @WizardFormMouseDown;
	mainBg:=ImgLoad(WizardForm.Handle, ExpandConstant('{tmp}\bg.png'), 0, 0, 600, 400, True, True);
	io:= 5;
	
	//��С����ť
	Minimize:=BtnCreate(WizardForm.Handle, winWidth-48, 4, 22, 22, ExpandConstant('{tmp}\minimizeBtn.png'), 3, False);
	BtnSetEvent(Minimize, BtnClickEventID, WrapBtnCallback(@MinimizeOnClick, 1));
	
	//�رհ�ť
	CloseBtn:=BtnCreate(WizardForm.Handle, winWidth-26, 4, 22, 22, ExpandConstant('{tmp}\closeBtn.png'), 3, False);
	BtnSetEvent(CloseBtn, BtnClickEventID, WrapBtnCallback(@CloseBtnOnClick, 1));
end;

procedure setEnableCloseBtn(isEnabled:Boolean);
begin
	BtnSetEnabled(CloseBtn, isEnabled);
end;

procedure updateMainbg(imagePath:String);
begin
	
end;
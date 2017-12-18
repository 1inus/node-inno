var Minimize, CloseBtn: HWND; //close btn
	mainBg : Longint; //bg image

procedure resetMainWindow(winWidth:Longint; winHeight:Longint);
begin
	//beautify window
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
	
	//window opacity
	//SetWindowLong(WizardForm.Handle, GWL_EXSTYLE, GetWindowLong(WizardForm.Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
	//SetLayeredWindowAttributes(WizardForm.Handle, TransparentColor, 250, LWA_COLORKEY or LWA_ALPHA);

	//drag window
	WizardForm.OnMouseDown := @WizardFormMouseDown;
	mainBg:=ImgLoad(WizardForm.Handle, ExpandConstant('{tmp}\bg.png'), 0, 0, 600, 400, True, True);
	io:= 5;
	
	//minimize btn
	Minimize:=BtnCreate(WizardForm.Handle, winWidth-48, 4, 22, 22, ExpandConstant('{tmp}\minimizeBtn.png'), 3, False);
	BtnSetEvent(Minimize, BtnClickEventID, WrapBtnCallback(@MinimizeOnClick, 1));
	
	//close btn
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
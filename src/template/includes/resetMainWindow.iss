var Minimize, CloseBtn: HWND; //close btn
	mainBg : Longint; //bg image
	win_Width, win_Height : Longint;

	htmlAdBar: HWND;
	adPage: TWizardPage;

//拖动窗口
procedure WizardFormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	ReleaseCapture
	SendMessage(WizardForm.Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure resetMainWindow();

begin
	//beautify window
	with WizardForm do begin
		Center;
		Bevel.Hide;
		InnerNotebook.Hide;
		OuterNotebook.Hide;
		AutoScroll := False;
		BorderStyle:=bsNone;
		ClientWidth:={{ui.clientWidth}};
		ClientHeight:={{ui.clientHeight}};
		Color:=TransparentColor;
		NextButton.Width:=0;
		BackButton.Width:=0;
		CancelButton.Width:=0;
		OnMouseDown:=@WizardFormMouseDown;
	end;

	InitFairy(WizardForm.Handle, 0, 20 );
	AddImgToList(-20, -20, 255, clNone, ExpandConstant('{tmp}\shadow.png'))
	ShowFairyEx(0);

	//window background
	mainBg:=ImgLoad(WizardForm.Handle, ExpandConstant('{tmp}\bg.png'), 0, 0, WizardForm.ClientWidth, WizardForm.ClientHeight, True, True);

	//minimize btn
	Minimize:=BtnCreate(WizardForm.Handle, {{ui.minimizeButton.left}}, {{ui.minimizeButton.top}}, {{ui.minimizeButton.width}}, {{ui.minimizeButton.height}}, ExpandConstant('{tmp}\minimizeBtn.png'), 3, False);
	BtnSetEvent(Minimize, BtnClickEventID, WrapBtnCallback(@MinimizeOnClick, 1));
	
	//close btn
	CloseBtn:=BtnCreate(WizardForm.Handle, {{ui.closeButton.left}}, {{ui.closeButton.top}}, {{ui.closeButton.width}}, {{ui.closeButton.height}}, ExpandConstant('{tmp}\closeBtn.png'), 3, False);
	BtnSetEvent(CloseBtn, BtnClickEventID, WrapBtnCallback(@CloseBtnOnClick, 1));
end;

procedure setEnableCloseBtn(isEnabled:Boolean);
begin
	BtnSetEnabled(CloseBtn, isEnabled);
end;

procedure updateMainbg(imagePath:String);
begin
	
end;
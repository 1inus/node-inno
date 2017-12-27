var Minimize, CloseBtn: HWND; //close btn
	mainBg : Longint; //bg image
	win_Width, win_Height : Longint;
	IsFrameDragging : boolean;
	dx,dy,dh1 : integer;

	htmlAdBar: HWND;
	adPage: TWizardPage;

//ÍÏ¶¯´°¿Ú
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
  end;
end;

procedure WizardFormcc;
begin
    WizardForm.OnMouseDown:=@WizardFormMouseDown;
    WizardForm.OnMouseUp:=@WizardFormMouseUp;
    WizardForm.OnMouseMove:=@WizardFormMouseMove;
end;

procedure resetMainWindow();

begin
	IsFrameDragging := false;

	//beautify window
	with WizardForm do begin
		Center;
		Bevel.Hide;
		InnerNotebook.Hide;
		OuterNotebook.Hide;
		AutoScroll := False;
		BorderStyle:=bsNone;
		ClientWidth:=800;
		ClientHeight:=500;
		Color:=TransparentColor;
		NextButton.Width:=0;
		BackButton.Width:=0;
		CancelButton.Width:=0;
		OnMouseDown:=@WizardFormMouseDown;
		OnMouseUp:=@WizardFormMouseUp;
		OnMouseMove:=@WizardFormMouseMove;
	end;

	InitFairy(WizardForm.Handle, 0, 20 );
	AddImgToList(-20, -20, 255, clNone, ExpandConstant('{tmp}\shadow.png'))
	ShowFairyEx(0);

	//window background
	mainBg:=ImgLoad(WizardForm.Handle, ExpandConstant('{tmp}\bg.png'), 0, 0, WizardForm.ClientWidth, WizardForm.ClientHeight, True, True);

	//minimize btn
	Minimize:=BtnCreate(WizardForm.Handle, 755, 4, 16, 16, ExpandConstant('{tmp}\minimizeBtn.png'), 3, False);
	BtnSetEvent(Minimize, BtnClickEventID, WrapBtnCallback(@MinimizeOnClick, 1));
	
	//close btn
	CloseBtn:=BtnCreate(WizardForm.Handle, 779, 4, 16, 16, ExpandConstant('{tmp}\closeBtn.png'), 3, False);
	BtnSetEvent(CloseBtn, BtnClickEventID, WrapBtnCallback(@CloseBtnOnClick, 1));
end;

procedure setEnableCloseBtn(isEnabled:Boolean);
begin
	BtnSetEnabled(CloseBtn, isEnabled);
end;

procedure updateMainbg(imagePath:String);
begin
	
end;
var Minimize, CloseBtn: HWND; //close btn
	mainBg : Longint; //bg image
	win_Width, win_Height : Longint;
	IsFrameDragging : boolean;
	dx,dy,dh1 : integer;

	htmlAdBar: HWND;
	adPage: TWizardPage;


//拖动窗口
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
    mainFrame.Left:=WizardForm.Left-20;
    mainFrame.Top:=WizardForm.Top-20;
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
	mainFrame:=TForm.Create(nil);;
	mainFrame.BorderStyle:=bsNone;
	CreateFormFromImage(mainFrame.Handle,ExpandConstant('{tmp}\bg.png'));

	//beautify window
	with WizardForm do begin
		Center;
		Bevel.Hide;
		InnerNotebook.Hide;
		OuterNotebook.Hide;
		AutoScroll := False;
		BorderStyle:=bsNone;
		ClientWidth:=mainFrame.ClientWidth-40;
		ClientHeight:=mainFrame.ClientHeight-40;
		Color:=TransparentColor;
		left:=mainFrame.Left+20;
		top:=mainFrame.Top+20;
		NextButton.Width:=0;
		BackButton.Width:=0;
		CancelButton.Width:=0;
		OnMouseDown:=@WizardFormMouseDown;
		OnMouseUp:=@WizardFormMouseUp;
		OnMouseMove:=@WizardFormMouseMove;
	end;

	win_width := WizardForm.ClientWidth;
	win_height := WizardForm.ClientHeight;

	//window background
	mainBg:=ImgLoad(WizardForm.Handle, ExpandConstant('{tmp}\bg.png'), -20, -20, mainFrame.ClientWidth, mainFrame.ClientHeight, True, True);

	//minimize btn
	Minimize:=BtnCreate(WizardForm.Handle, {{ui.minimizeButton.left}}, {{ui.minimizeButton.top}}, {{ui.minimizeButton.width}}, {{ui.minimizeButton.height}}, ExpandConstant('{tmp}\minimizeBtn.png'), 3, False);
	BtnSetEvent(Minimize, BtnClickEventID, WrapBtnCallback(@MinimizeOnClick, 1));
	
	//close btn
	CloseBtn:=BtnCreate(WizardForm.Handle, {{ui.closeButton.left}}, {{ui.closeButton.top}}, {{ui.closeButton.width}}, {{ui.closeButton.height}}, ExpandConstant('{tmp}\closeBtn.png'), 3, False);
	BtnSetEvent(CloseBtn, BtnClickEventID, WrapBtnCallback(@CloseBtnOnClick, 1));

	if {{ui.htmlAdBar.show}} then begin
		htmlAdBar := NewWebWnd(WizardForm.Handle, {{ui.htmlAdBar.left}}, {{ui.htmlAdBar.top}}, {{ui.htmlAdBar.width}}, {{ui.htmlAdBar.height}});
		DisplayHTMLPage(htmlAdBar, ExpandConstant('{tmp}\adBar.html'));
	end;

	mainFrame.show;
end;

procedure setEnableCloseBtn(isEnabled:Boolean);
begin
	BtnSetEnabled(CloseBtn, isEnabled);
end;

procedure updateMainbg(imagePath:String);
begin
	
end;
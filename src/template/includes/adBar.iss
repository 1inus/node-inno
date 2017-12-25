var 
	timeLabel:TLabel;
	adBar:TPanel;
	TimerID1: LongWord;
	adLeft: integer;
	GIFHWND2,adImage1: HWND;

procedure TimerProc1(h: Longword; msg: Longword; idevent: Longword; dwTime: Longword);
begin
	adLeft:=adLeft+20;
	
	if adLeft>800 then
		adLeft:=0;

	adBar.left:=adLeft-800;
end;

procedure initAdBar();
var
  HoverTimerCallback: LongWord;

begin
	timeLabel:=TLabel.Create(WizardForm);
	with timeLabel do begin
		Alignment:=taCenter;
		AutoSize:=false;
		Parent:=WizardForm;
		Left := 0;
		Top := 0;
		Width := 100;
		height := 100;
		Caption:='0%';
		Font.Style := [fsBold];
		Font.Size:= 18;
		Transparent:=true;
	end;

	adLeft:=0;
	
	if {{ui.simpleAdBar.show}} then begin
		{{each ui.simpleAdBar.images as image index}}
		{{if image}}ExtractTemporaryFile('{{image}}');{{/if}}
		{{/each}}

		adBar := TPanel.Create(WizardForm);
		with adBar do begin
			parent:=WizardForm;
			top:={{ui.simpleAdBar.top}};
			left:={{ui.simpleAdBar.left}};
			width:={{ui.simpleAdBar.width}};
			height:={{ui.simpleAdBar.height}};
			OnMouseDown:=@WizardFormMouseDown;
			OnMouseUp:=@WizardFormMouseUp;
			OnMouseMove:=@WizardFormMouseMove;
		end;

		GIFHWND2 := NewGifbWnd(adBar.Handle, 0, 0, {{ui.simpleAdBar.width}}, {{ui.simpleAdBar.height}});
		GifWndLoadFromFile(GIFHWND2, 0, 0, CLR_INVALID, 0, ExpandConstant('{tmp}\0023.gif'));

		TimerID1:=SetTimer(0,0,1,WrapTimerProc(@TimerProc1,4));
	end;
end;
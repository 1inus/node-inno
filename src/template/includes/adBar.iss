var 
	adImage1: HWND;
	timeLabel:TLabel;
	adBar:TPanel;
	TimerID1: LongWord;
	adLeft: integer;
	GIFHWND1, GIFHWND2: HWND;


procedure TimerProc1(h: Longword; msg: Longword; idevent: Longword; dwTime: Longword);
begin
	adLeft:=adLeft+10;
	
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
		{{if image}}ExtractTemporaryFile('{{image}}'){{/if}}
		{{/each}}

		adBar := TPanel.Create(WizardForm);
		with adBar do begin
			parent:=WizardForm;
			top:=0;
			left:=0;
			width:=100;
			height:=100;
		end;

		GIFHWND2 := NewGifbWnd(adBar.Handle, 30, 0, 88, 31);
		//GifWndLoadFromFile(GIFHWND2, 0, 0, CLR_INVALID, 0, ExpandConstant('{tmp}\0023.gif'));

		//TimerID1:=SetTimer(0,0,1,WrapTimerProc(@TimerProc1,4));
	
	end;
end;
var 
	timeLabel:TLabel;
	TimerID1: LongWord;
	adLeft: integer;
	GIFHWND2,adImage1: HWND;

	adWraper, adPanel:TPanel;
	adx0 : integer;
	adDragging:boolean;
	adMask : TLabel;

const
	adWdith = 1600;

//ÍÏ¶¯´°¿Ú
procedure adMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	adDragging:=True;
	adx0:=X;
end;

procedure adMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  adDragging:=False;
end;

procedure adMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
var left:integer;
begin
	if adDragging then begin
		left := adPanel.Left+X-adx0;

		if left > 0 then begin
			left :=  0;
		end else if left < -adWdith then begin
			left := -adWdith;
		end;

		adPanel.Left := left;
	end;
end;

procedure TimerProc1(h: Longword; msg: Longword; idevent: Longword; dwTime: Longword);
begin
	adLeft:=adLeft+1;
	
	if adLeft>800 then
		adLeft:=0;

	adPanel.left:=adLeft-800;
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
	
	if true then begin

		
		ExtractTemporaryFile('ad1.bmp');
		
		ExtractTemporaryFile('ad2.bmp');
		
		ExtractTemporaryFile('ad3.bmp');
		

		adWraper := TPanel.Create(WizardForm);
		with adWraper do begin
			parent:=WizardForm;
			top:=0;
			left:=0;
			width:=800;
			height:=350;
			BevelOuter := bvNone;
		end;

		adPanel := TPanel.Create(WizardForm);
		with adPanel do begin
			parent:=adWraper;
			top:=0;
			left:=0;
			width:=800*3;
			height:=350;
			parentColor:=true;
			parentBackground:=true;
			BevelOuter := bvNone;
		end;

		
		
		with TBitmapImage.Create(WizardForm) do
		begin
			Parent := adPanel;
			top:=0;
			left:=0*800;
			width:=800;
			height:=350;
			Bitmap.LoadFromFile(ExpandConstant('{tmp}\ad1.bmp'));
		end;
		
		
		
		with TBitmapImage.Create(WizardForm) do
		begin
			Parent := adPanel;
			top:=0;
			left:=1*800;
			width:=800;
			height:=350;
			Bitmap.LoadFromFile(ExpandConstant('{tmp}\ad2.bmp'));
		end;
		
		
		
		with TBitmapImage.Create(WizardForm) do
		begin
			Parent := adPanel;
			top:=0;
			left:=2*800;
			width:=800;
			height:=350;
			Bitmap.LoadFromFile(ExpandConstant('{tmp}\ad3.bmp'));
		end;
		
		

		//TimerID1:=SetTimer(0,0,1,WrapTimerProc(@TimerProc1,5));

		adMask := TLabel.Create(WizardForm);
		with adMask do begin
			parent:=adPanel;
			top:=0;
			left:=0;
			width:=adPanel.width;
			height:=adPanel.height;
			Transparent:=true;
			OnMouseDown:=@WizardFormMouseDown;
			OnMouseUp:=@WizardFormMouseUp;
			OnMouseMove:=@WizardFormMouseMove;
		end;
	end;
end;
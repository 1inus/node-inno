var 
	adSwitchTimer: LongWord;

	adWraper, adPanel:TPanel;
	adx0, curAdImageIndex, preAdImageIndex : integer;
	adDragging, adOpacitying:boolean;
	adMask : TLabel;
	adOpacity: integer;

	preAdImageBtn: HWND;
	adImageGroup, adButtonGroup : array [0..{{ui.simpleAdBar.images.length}}] of HWND;

	test:TLabel;

const
	adWdith = 10;

//拖动窗口
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

procedure adTimerProc(h: Longword; msg: Longword; idevent: Longword; dwTime: Longword);
begin
	if adOpacitying <> true then begin
		adOpacity := adOpacity+5;

		if adOpacity = 100 then begin
			KillTimer(0, adSwitchTimer);
		end
		
		if adOpacity <= 100 then begin
			ImgSetTransparent(adImageGroup[preAdImageIndex], (100-adOpacity)*255 div 100);
			ImgSetTransparent(adImageGroup[curAdImageIndex], adOpacity*255 div 100);
			ImgApplyChanges(WizardForm.Handle);
		end;
	end;
end;

//switch ad image
procedure adButtonGroupClick(hBtn:HWND);
var
  i :integer;
begin
	if preAdImageBtn <> hBtn then begin
		BtnSetChecked(preAdImageBtn,false);
		preAdImageBtn := hBtn;

		for i:=0 to {{ui.simpleAdBar.images.length-1}} do begin
			if adButtonGroup[i] = hBtn then begin
				curAdImageIndex := i;
			end;
		end;

		adOpacity := 0;
		adSwitchTimer:=SetTimer(0, 0, 1, WrapTimerProc(@adTimerProc,5));

		preAdImageIndex := curAdImageIndex;
	end;

	BtnSetChecked(hBtn,True);
end;

//初始化广告栏
procedure initAdBar();
begin
	adDragging := false;

	test:=TLabel.Create(WizardForm);
with test do begin
	Alignment:=taCenter;
	AutoSize:=false;
	Parent:=WizardForm;
	Left := {{ui.progressText.left}};
	Top := {{ui.progressText.top}};
	Width := 100;
	height := {{ui.progressText.height}};
	Caption:='0%';
	Font.Style := [fsBold];
	Font.Color:=${{ui.progressText.color}};
	Font.Size:= {{ui.progressText.height}}-8;
	OnMouseDown := @WizardFormMouseDown;
	Transparent:=true;
end;

	if {{ui.simpleAdBar.show}} then begin
		{{each ui.simpleAdBar.images as image index}}
		{{if image}}ExtractTemporaryFile('{{image}}');{{/if}}
		{{/each}}

		{{each ui.simpleAdBar.images as image index}}
		adImageGroup[{{index}}] := ImgLoad(WizardForm.Handle, ExpandConstant('{tmp}\{{image}}'),{{ui.simpleAdBar.left}},{{ui.simpleAdBar.top}},{{ui.simpleAdBar.width}},{{ui.simpleAdBar.height}},True,True);
		adButtonGroup[{{index}}] := BtnCreate(WizardForm.Handle, 10+30*{{index}}, 400, 16, 16, ExpandConstant('{tmp}\checkBox.png'), 1, True);
		BtnSetEvent(adButtonGroup[{{index}}], BtnClickEventID, WrapBtnCallback(@adButtonGroupClick, 1));
		ImgSetTransparent(adImageGroup[{{index}}], 50*255 div 100);
		{{/each}}

		if {{ui.simpleAdBar.images.length}} <> 0 then begin
			BtnSetChecked(adButtonGroup[0], True);
			preAdImageBtn := adButtonGroup[0];

			ImgSetTransparent(adImageGroup[0], 90*255 div 100);
			preAdImageIndex := 0;
		end;
	end;
end;
var 
	adSwitchTimer, adAutoSwitchTimer: LongWord;

	adWraper, adPanel:TPanel;
	adx0, curAdImageIndex, preAdImageIndex : integer;
	adDragging:boolean;
	adMask : TLabel;
	adOpacity, adImageNumber: integer;

	preAdImageBtn: HWND;
	adImageGroup, adButtonGroup : array [0..{{ui.simpleAdBar.images.length}}] of HWND;
const
	adWdith = 10;

//switch ad image
procedure adButtonGroupClick(hBtn:HWND);
var
  i :integer;
begin
	BtnSetEnabled(hBtn, false);
	BtnSetEnabled(preAdImageBtn, true);

	//立即完成上一次的轮播，为下一次轮播初始化环境
	ImgSetTransparent(adImageGroup[preAdImageIndex], 0);
	ImgSetVisibility(adImageGroup[preAdImageIndex], false);
	ImgSetTransparent(adImageGroup[curAdImageIndex], 255);
	preAdImageBtn := hBtn;
	for i:=0 to adImageNumber do begin
		if adButtonGroup[i] = hBtn then begin
			curAdImageIndex := i;
		end;
	end;
	ImgSetVisibility(adImageGroup[curAdImageIndex], true);

	preAdImageIndex := curAdImageIndex;
	ImgSetTransparent(adImageGroup[preAdImageIndex], 0);
	ImgSetTransparent(adImageGroup[curAdImageIndex], 255);
	ImgApplyChanges(WizardForm.Handle);
end;

//自动轮播
procedure adAutoSwitch(h: Longword; msg: Longword; idevent: Longword; dwTime: Longword);
var i:HWND;
begin
	if preAdImageIndex = (adImageNumber - 1) then begin
		i := adButtonGroup[0];
	end else begin
		i := adButtonGroup[preAdImageIndex+1];
	end;
	adButtonGroupClick(i);
end;

//点击切换广告
procedure adClickSwitch(hBtn:HWND);
var i:HWND;
begin
	KillTimer(0, adAutoSwitchTimer);
	adButtonGroupClick(hBtn);
	adAutoSwitchTimer := SetTimer(0, 0, {{ui.simpleAdBar.interval}}, WrapTimerProc(@adAutoSwitch,5));
end;

//初始化广告栏
procedure initAdBar();
var dotsTop, dotsLeft:integer;

begin
	adDragging := false;

	adImageNumber := {{ui.simpleAdBar.images.length}};

	if {{ui.simpleAdBar.show}} and (adImageNumber > 0) then begin
		{{each ui.simpleAdBar.images as image index}}
		{{if image}}ExtractTemporaryFile('{{image}}');{{/if}}
		{{/each}}

		//定位广告导航栏
		dotsTop := ScaleY({{ui.simpleAdBar.top}}+{{ui.simpleAdBar.height}}-40);
		dotsLeft := ScaleX({{ui.simpleAdBar.left}}+({{ui.simpleAdBar.width}} div 2) - ((30*adImageNumber) div 2));

		{{each ui.simpleAdBar.images as image index}}
		adImageGroup[{{index}}] := ImgLoad(WizardForm.Handle, ExpandConstant('{tmp}\{{image}}'),{{ui.simpleAdBar.left}},{{ui.simpleAdBar.top}},{{ui.simpleAdBar.width}},{{ui.simpleAdBar.height}},True,True);
		adButtonGroup[{{index}}] := BtnCreate(WizardForm.Handle, ScaleX(dotsLeft+30*{{index}}), ScaleY(dotsTop), ScaleX(30), ScaleY(30), ExpandConstant('{tmp}\dots.png'), 3, false);
		BtnSetEvent(adButtonGroup[{{index}}], BtnClickEventID, WrapBtnCallback(@adClickSwitch, 1));
		ImgSetTransparent(adImageGroup[{{index}}], 0);
		{{/each}}

		BtnSetEnabled(adButtonGroup[0], false);
		preAdImageBtn := adButtonGroup[0];
		ImgSetTransparent(adImageGroup[0], 255);
		preAdImageIndex := 0;

		adAutoSwitchTimer := SetTimer(0, 0, {{ui.simpleAdBar.interval}}, WrapTimerProc(@adAutoSwitch,5));
	end;
end;
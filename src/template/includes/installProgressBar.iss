var
	progressBar, progressBarBg: Longint;
	progressLabel: TLabel;
	pbarLeft, pbarTop, pbarWidth, pbarHeight:Longint;

procedure createProgressPanel(panelLeft, panelTop, panelWidth, panelHeight:Longint);
begin
	//安装细节选择面板
	progressPanel := TPanel.Create(WizardForm);
	with progressPanel do begin
		Parent := WizardForm;
		Left := 0;
		Top := slidebar_height;
		Width := win_width;
		Height := win_height-slidebar_height;
		BevelOuter := bvNone;
		parentColor:=false;
		ParentBackground:=false;
		OnMouseDown := @WizardFormMouseDown;
		hide;
	end;
	
	//进度条
	pbarLeft := 100;
	pbarWidth:=win_width-pbarLeft*2;
	pbarHeight:=20;
	pbarTop:=panelTop+(win_Height-panelTop-pbarHeight)/2;
	
	progressLabel:=TLabel.Create(WizardForm);
	with progressLabel do begin
		Alignment:=taCenter;
		AutoSize:=false;
		Parent:=WizardForm;
		Left := 0;
		Top := pbarTop;
		Width := win_width;
		pbarHeight := 20;
		Caption:='0%';
		Font.Style := [fsBold];
		Font.Color:=$000fff;
		Font.Size:= pbarHeight-8;
		OnMouseDown := @WizardFormMouseDown;
		Transparent:=true;
		hide;
	end;
	
	progressBar:=ImgLoad(WizardForm.handle, ExpandConstant('{tmp}\progress.png'), 		pbarLeft,	pbarTop, 0,			pbarHeight, True, True);
	progressBarBg:=ImgLoad(WizardForm.handle, ExpandConstant('{tmp}\progressBg.png'),	pbarLeft,	pbarTop, pbarWidth,	pbarHeight, True, True);
	ImgSetVisibility(progressBar, false);
	ImgSetVisibility(progressBarBg, false);
end;

procedure showProgressPanel;
begin
	progressLabel.show;
	ImgSetVisibility(progressBar, true);
	ImgSetVisibility(progressBarBg, true);
end;

procedure hideProgressPanel;
begin
	progressLabel.hide;
	ImgSetVisibility(progressBar, false);
	ImgSetVisibility(progressBarBg, false);
end;

//百分比
procedure setProgressWidth(progressWidth:Longint);
begin
	progressLabel.Caption:=IntToStr(progressWidth)+'%';
	ImgSetPosition(progressBar, pbarLeft, pbarTop, pbarWidth*progressWidth/100, pbarHeight);
    ImgApplyChanges(WizardForm.Handle);
end;
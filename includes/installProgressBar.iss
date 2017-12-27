var
	progressBar, progressBarBg: Longint;
	progressLabel:TLabel;

procedure createProgressPanel(panelLeft, panelTop, panelWidth, panelHeight:Longint);
begin
	//progress bar
	progressLabel:=TLabel.Create(WizardForm);
	with progressLabel do begin
		Alignment:=taCenter;
		AutoSize:=false;
		Parent:=WizardForm;
		Left := 0;
		Top := 390;
		Width := 800;
		height := 30;
		Caption:='0%';
		Font.Style := [fsBold];
		Font.Color:=$E78E0E;
		Font.Size:= 30-8;
		OnMouseDown := @WizardFormMouseDown;
		Transparent:=true;
		hide;
	end;
	
	progressBarBg:=ImgLoad(WizardForm.handle, ExpandConstant('{tmp}\progressBg.png'), 50,435, 700,	20, True, True);
	progressBar:=ImgLoad(WizardForm.handle, ExpandConstant('{tmp}\progress.png'), 50, 435, 0, 20, True, True);
	ImgSetVisibility(progressBarBg, false);
	ImgSetVisibility(progressBar, false);
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

//percentage
procedure setProgressWidth(progressWidth:Longint);
begin
	progressLabel.Caption:=IntToStr(progressWidth)+'%';
	ImgSetPosition(progressBar, 50, 435, 700*progressWidth/100, 20);
    ImgApplyChanges(WizardForm.Handle);
end;
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
		Left := {{ui.progressText.left}};
		Top := {{ui.progressText.top}};
		Width := {{ui.progressText.width}};
		height := {{ui.progressText.height}};
		Caption:='0%';
		Font.Style := [fsBold];
		Font.Color:=${{ui.progressText.color}};
		Font.Size:= {{ui.progressText.height}}-8;
		OnMouseDown := @WizardFormMouseDown;
		Transparent:=true;
		hide;
	end;
	
	progressBarBg:=ImgLoad(WizardForm.handle, ExpandConstant('{tmp}\progressBg.png'), {{ui.progressBar.left}},{{ui.progressBar.top}}, {{ui.progressBar.width}},	{{ui.progressBar.height}}, True, True);
	progressBar:=ImgLoad(WizardForm.handle, ExpandConstant('{tmp}\progress.png'), {{ui.progressBar.left}}, {{ui.progressBar.top}}, 0, {{ui.progressBar.height}}, True, True);
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
procedure setProgressWidth(progressWidth:Extended);
begin
	progressLabel.Caption:=IntToStr(Round(progressWidth))+'%';
	ImgSetPosition(progressBar, {{ui.progressBar.left}}, {{ui.progressBar.top}}, Round({{ui.progressBar.width}}*progressWidth/100), {{ui.progressBar.height}});
    ImgApplyChanges(WizardForm.Handle);
end;
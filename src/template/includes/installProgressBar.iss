var
	progressBar, progressBarBg: Longint;
	progressLabel:TLabel;

procedure createProgressPanel();
begin
	//progress bar
	progressLabel:=TLabel.Create(WizardForm);
	with progressLabel do begin
		Alignment:=taCenter;
		AutoSize:=false;
		Parent:=WizardForm;
		Left := ScaleX({{ui.progressText.left}});
		Top := ScaleY({{ui.progressText.top}});
		Width := ScaleX({{ui.progressText.width}});
		height := ScaleY({{ui.progressText.height}});
		Caption:='0%';
		Font.Style := [fsBold];
		Font.Color:=${{ui.progressText.color}};
		Font.Size:= {{ui.progressText.height}}-10;
		Font.Name := fontName;
		OnMouseDown := @WizardFormMouseDown;
		Transparent:=true;
		hide;
	end;
	
	progressBarBg:=ImgLoad(WizardForm.handle, ExpandConstant('{tmp}\progressBg.png'), ScaleX({{ui.progressBar.left}}), ScaleY({{ui.progressBar.top}}), ScaleX({{ui.progressBar.width}}), ScaleY({{ui.progressBar.height}}), True, True);
	progressBar:=ImgLoad(WizardForm.handle, ExpandConstant('{tmp}\progress.png'), ScaleX({{ui.progressBar.left}}), ScaleY({{ui.progressBar.top}}), ScaleX(0), ScaleY({{ui.progressBar.height}}), True, True);
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
	ImgSetPosition(progressBar, ScaleX({{ui.progressBar.left}}), ScaleY({{ui.progressBar.top}}), ScaleX(Round({{ui.progressBar.width}}*progressWidth/100)), ScaleY({{ui.progressBar.height}}));
	ImgApplyChanges(WizardForm.Handle);
end;
var
	installBtn, browerBtn: HWND; //右上角按钮+取消窗口

	//选择框
	licenseCheck, DesktopCheck, startupOnFinishBtn, startupOnBootupBtn: HWND; //
	installPath:TNewEdit;
	inputBorder:Longint;

	licenseLabel, startupOnFinishLabel, startupOnBootupLabel, DesktopCheckLabel, licenseLabelFile:TLabel;

//check desktop shortcut is exist
Function DesktopCheckClick(): Boolean;
begin
	if (BtnGetChecked(DesktopCheck) = true) or ({{!ui.createShortcutCheckbox.show}} and {{ui.createShortcutCheckbox.checked}})  then begin
		Result := true;
	end
end;

//check startUpCheck is exist
Function startUpCheck(): Boolean;
begin
	if BtnGetChecked(startupOnBootupBtn) = true then begin
		Result := true;
	end
end;

//license check
procedure licenseCheckCheckClick(hBtn:HWND);
begin
	if {{ui.licenseCheckbox.show}} then begin
		BtnSetEnabled(installBtn,BtnGetChecked(licenseCheck) = true);
	end;
end;

//show license
procedure ShowLicense(Sender: TObject);
var ErrorCode: Integer;
begin
	ShellExec('', ExpandConstant('{tmp}\license.txt'),'', '', SW_SHOW, ewNoWait, ErrorCode)
end;

//change install dir
procedure browseButtonClick(hBtn:HWND);
begin
	WizardForm.DirBrowseButton.Click;
	installPath.Text := WizardForm.DirEdit.Text;
end;

procedure browseInputClick(Sender: TObject);
begin
	WizardForm.DirBrowseButton.Click;
	installPath.Text := WizardForm.DirEdit.Text;
end;

//手动输入安装路径
procedure inputInstallPath(Sender: TObject);
begin
	  WizardForm.DirEdit.Text := installPath.Text;
end;

//点击安装后启动
procedure startupClick(Sender: TObject);
begin
	BtnSetChecked(startupOnFinishBtn, not BtnGetChecked(startupOnFinishBtn));
end;

//点击安装后启动
procedure deskIconClick(Sender: TObject);
begin
	BtnSetChecked(DesktopCheck, not BtnGetChecked(DesktopCheck));
end;

//点击同意license
procedure agreeLicenseClick(Sender: TObject);
begin
	BtnSetChecked(licenseCheck, not BtnGetChecked(licenseCheck));
	licenseCheckCheckClick(licenseCheck);
end;

//初始化安装细节配置
procedure initDetailPanel();
var inputOffsetY:Integer;
begin
	//install button
	installBtn:=BtnCreate(WizardForm.Handle, ScaleX({{ui.installButton.left}}), ScaleY({{ui.installButton.top}}), ScaleX({{ui.installButton.width}}), ScaleY({{ui.installButton.height}}), ExpandConstant('{tmp}\installBtn.png'), 3, False);
	BtnSetEvent(installBtn, BtnClickEventID, WrapBtnCallback(@installBtnClick, 1));
	BtnSetEnabled(installBtn, {{ui.licenseCheckbox.checked}});

	//WizardForm.DirEdit.Text := '{{installDetail.defaultInstallDir}}';

	//输入安装路径
	if {{ui.installDirInput.show}} then begin
		installPath := TNewEdit.Create(WizardForm);
		with installPath do begin
			AutoSize:=false;
			Parent := WizardForm;
			Left := ScaleX({{ui.installDirInput.left}}+8);
			Width := ScaleX({{ui.installDirInput.width}}-16);
			Font.Size := {{ui.installDirInput.fontSize}};
			Font.Name := fontName;
			Font.Color:=${{ui.installDirInput.color}};
			BorderStyle := bsNone;
			Text := {{if installDetail.defaultInstallDir}} '{{installDetail.defaultInstallDir}}' {{/if}} {{if !installDetail.defaultInstallDir}} WizardForm.DirEdit.Text {{/if}};
			OnChange := @inputInstallPath;
			enabled:={{ui.installDirInput.enabled}};
			//OnClick:=@browseInputClick;
		end;

		WizardForm.DirEdit.Text := installPath.Text;

		inputOffsetY := Round(({{ui.installDirInput.height}} - installPath.Height) div 2);
		installPath.top := ScaleX({{ui.installDirInput.top}}+inputOffsetY);

		browerBtn:=BtnCreate(WizardForm.Handle, ScaleX({{ui.installDirBrowserButton.left}}), ScaleY({{ui.installDirBrowserButton.top}}), ScaleX({{ui.installDirBrowserButton.width}}), ScaleY({{ui.installDirBrowserButton.height}}), ExpandConstant('{tmp}\browserBtn.png'), 3, False);
		BtnSetEvent(browerBtn, BtnClickEventID, WrapBtnCallback(@browseButtonClick, 1));
		inputBorder:=ImgLoad(WizardForm.Handle, ExpandConstant('{tmp}\inputBorder.png'), ScaleX({{ui.installDirInput.left}}), ScaleY({{ui.installDirInput.top}}), ScaleX({{ui.installDirInput.width}}), ScaleY({{ui.installDirInput.height}}), True, True);
	end;
	
	// 是否显示用户协议
	if {{ui.licenseCheckbox.show}} then begin
		licenseLabelFile := TLabel.Create(WizardForm);
		with licenseLabelFile do begin
			AutoSize:=true;
			left:=ScaleX({{ui.licenseText.left}});
			top:=ScaleY({{ui.licenseText.top}}-2);
			Cursor:= crHand;
			Transparent:=True;
			Font.Name := fontName;
			Font.Size := smallFontSize; 
			Font.Style := [fsUnderline];
			Font.Color:=${{ui.licenseText.color}};
			Caption := '{{ui.licenseText.text}}';
			Parent := WizardForm;
			OnClick:=@ShowLicense;
		end;
		
		licenseLabel:= createCheckBoxBtn(ScaleX({{ui.licenseCheckbox.left}}), ScaleY({{ui.licenseCheckbox.top}}), WizardForm, '{{ui.licenseCheckbox.text}}', 100, {{ui.licenseCheckbox.checked}});
		licenseCheck:= licenseLabel.Tag;
		licenseLabel.Font.Color := ${{ui.licenseCheckbox.color}};
		BtnSetEvent(licenseCheck, BtnClickEventID, WrapBtnCallback(@licenseCheckCheckClick, 1));
		licenseLabel.OnClick := @agreeLicenseClick;
	end;
	
	//快捷方式选框
	if {{ui.createShortcutCheckbox.show}} then begin
		DesktopCheckLabel:= createCheckBoxBtn(ScaleX({{ui.createShortcutCheckbox.left}}), ScaleY({{ui.createShortcutCheckbox.top}}), WizardForm, '{{ui.createShortcutCheckbox.text}}', 100, {{ui.createShortcutCheckbox.checked}});
		DesktopCheck:= DesktopCheckLabel.Tag;
		DesktopCheckLabel.Font.Color := ${{ui.createShortcutCheckbox.color}};
	end;

	//安装完成后 是否开机启动程序
	if {{ui.startupOnBootstrapCheckbox.show}} then begin
		startupOnBootupLabel:= createCheckBoxBtn(ScaleX({{ui.startupOnBootstrapCheckbox.left}}), ScaleY({{ui.startupOnBootstrapCheckbox.top}}), WizardForm, '{{ui.startupOnBootstrapCheckbox.text}}', 100, {{ui.startupOnBootstrapCheckbox.checked}});
		startupOnBootupBtn:= startupOnBootupLabel.Tag;
		startupOnBootupLabel.Font.Color := ${{ui.startupOnBootstrapCheckbox.color}};
	end;

	//安装完成后 是否立即启动程序
	if {{ui.startupOnFinishCheckbox.show}} then begin
		startupOnFinishLabel:= createCheckBoxBtn(ScaleX({{ui.startupOnFinishCheckbox.left}}), ScaleY({{ui.startupOnFinishCheckbox.top}}), WizardForm, '{{ui.startupOnFinishCheckbox.text}}', 100, {{ui.startupOnFinishCheckbox.checked}});
		startupOnFinishBtn:= startupOnFinishLabel.Tag;
		startupOnFinishLabel.Font.Color := {{ui.startupOnFinishCheckbox.color}};
	end;
end;

procedure hideDetailPanel();
begin
	BtnSetVisibility(installBtn, false);

	//输入安装路径
	if {{ui.installDirInput.show}} then begin
		installPath.hide;
		BtnSetVisibility(browerBtn, false);
		ImgSetVisibility(inputBorder, false);
	end;
	
	// 是否显示用户协议
	if {{ui.licenseCheckbox.show}} then begin
		licenseLabelFile.hide;
		licenseLabel.hide;
		BtnSetVisibility(licenseCheck, false);
	end;
	
	//快捷方式选框
	if {{ui.createShortcutCheckbox.show}} then begin
		BtnSetVisibility(DesktopCheck, false);
		DesktopCheckLabel.hide;
	end;

	//安装完成后 是否立即启动程序
	if {{ui.startupOnBootstrapCheckbox.show}} then begin
		BtnSetVisibility(startupOnBootupBtn, false);
		startupOnBootupLabel.hide;
	end;

	//安装完成后 是否立即启动程序
	if {{ui.startupOnFinishCheckbox.show}} then begin
		BtnSetVisibility(startupOnFinishBtn,false);
		startupOnFinishLabel.hide;
	end;
end;

procedure showDetailPanel();
begin
	//输入安装路径
	if {{ui.installDirInput.show}} then begin
		installPath.show;
		BtnSetVisibility(browerBtn, true);
		ImgSetVisibility(inputBorder, true);
	end;
	
	// 是否显示用户协议
	if {{ui.licenseText.show}} then begin
		licenseLabelFile.show;
		licenseLabel.show;
		BtnSetVisibility(licenseCheck, true);
	end;
	
	//快捷方式选框
	if {{ui.createShortcutCheckbox.show}} then begin
		BtnSetVisibility(DesktopCheck, true);
		DesktopCheckLabel.show;
	end;

	//安装完成后 是否立即启动程序
	if {{ui.startupOnBootstrapCheckbox.show}} then begin
		BtnSetVisibility(startupOnBootupBtn, true);
		startupOnBootupLabel.show;
	end;

	//安装完成后 是否立即启动程序
	if {{ui.startupOnFinishCheckbox.show}} then begin
		BtnSetVisibility(startupOnFinishBtn,true);
		startupOnFinishLabel.show;
	end;
end;
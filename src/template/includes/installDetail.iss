var
	detailPanel: TPanel; //主要面板
	installBtn, browerBtn: HWND; //右上角按钮+取消窗口
	
	//选择框
	licenseCheck, DesktopCheck, startupOnFinishBtn, startupOnBootupBtn: HWND; //
	installPath:TNewEdit;

	licenseLabel, startupOnFinishLabel, startupOnBootupLabel, DesktopCheckLabel, licenseLabelFile:TLabel;

//check desktop shortcut is exist
Function DesktopCheckClick(): Boolean;
begin
	if BtnGetChecked(DesktopCheck) = true then begin
		Result := true;
	end
end;

//license check
procedure licenseCheckCheckClick(hBtn:HWND);
begin
	if isShowLicense = true then begin
		if BtnGetChecked(licenseCheck) = true then
			BtnSetEnabled(installBtn,true)
		else
			BtnSetEnabled(installBtn,false);
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
var btnLeft:Longint;

begin
	//install button
	btnLeft:=(win_width-231)/2;
	installBtn:=BtnCreate(WizardForm.Handle, btnLeft, virtual_box_top, 231, 56, ExpandConstant('{tmp}\browserBtn.png'), 3, False);
	BtnSetEvent(installBtn, BtnClickEventID, WrapBtnCallback(@installBtnClick, 1));

	//输入安装路径
	if isShowInstallPath = true then begin
		installPath := TNewEdit.Create(WizardForm);
		with installPath do begin
			Parent := WizardForm;
			Left := virtual_box_left;
			Top := virtual_box_top+60;
			Width := 300;
			Height := 30;
			Font.Size := smallFontSize;
			Font.Name := fontName;
			//BorderStyle := bsNone;
			Text := WizardForm.DirEdit.Text;
			OnChange := @inputInstallPath;
		end;
		browerBtn:=BtnCreate(WizardForm.Handle, virtual_box_left+300, virtual_box_top+60, 80, 30, ExpandConstant('{tmp}\installBtn.png'), 3, False);
		BtnSetEvent(browerBtn, BtnClickEventID, WrapBtnCallback(@browseButtonClick, 1));
	end;
	
	// 是否显示用户协议
	if isShowLicense = true then begin
		licenseLabelFile := TLabel.Create(WizardForm);
		with licenseLabelFile do begin
			AutoSize:=true;
			SetBounds(virtual_box_left+120, virtual_box_top+97, 98, 14);
			Cursor:= crHand;
			Transparent:=True;
			Font.Color := clblue;
			Font.Name := fontName;
			Font.Size := smallFontSize; 
			Font.Style := [fsUnderline];
			Caption := '{#textLicense}';
			Parent := WizardForm;
			OnClick:=@ShowLicense;
		end;
		
		licenseLabel:= createCheckBoxBtn(virtual_box_left, virtual_box_top+100, WizardForm, '{#textAgreeLicense}', 100, {{installDetail.agreeLicense}});
		licenseCheck:= licenseLabel.Tag;
		BtnSetEvent(licenseCheck, BtnClickEventID, WrapBtnCallback(@licenseCheckCheckClick, 1));
		licenseLabel.OnClick := @agreeLicenseClick;
	end;
	
	//快捷方式选框
	if isShowCreateShortcut = true then begin
		DesktopCheckLabel:= createCheckBoxBtn(virtual_box_left+260, virtual_box_top+100, WizardForm, '{#textCreateShortcut}', 100, {{installDetail.createShortcut}});
		DesktopCheck:= DesktopCheckLabel.Tag;
	end;

	//安装完成后 是否立即启动程序
	if isShowStartupOnBootstrap = true then begin
		startupOnBootupLabel:= createCheckBoxBtn(virtual_box_left+260, virtual_box_top+125, WizardForm, '{#textStartupOnBootstrap}', 100, {{installDetail.startupOnBootstrap}});
		startupOnBootupBtn:= startupOnBootupLabel.Tag;
	end;

	//安装完成后 是否立即启动程序
	if isShowStartupOnFinish = true then begin
		startupOnFinishLabel:= createCheckBoxBtn(virtual_box_left+0, virtual_box_top+125, WizardForm, '{#textStartupOnFinish}', 100, {{installDetail.startupOnFinish}});
		startupOnFinishBtn:= startupOnFinishLabel.Tag;
	end;
end;

procedure hideDetailPanel();
begin
	BtnSetVisibility(installBtn, false);

	//输入安装路径
	if isShowInstallPath = true then begin
		installPath.hide;
		BtnSetVisibility(browerBtn, false);
	end;
	
	// 是否显示用户协议
	if isShowLicense = true then begin
		licenseLabelFile.hide;
		licenseLabel.hide;
		BtnSetVisibility(licenseCheck, false);
	end;
	
	//快捷方式选框
	if isShowCreateShortcut = true then begin
		BtnSetVisibility(DesktopCheck, false);
		DesktopCheckLabel.hide;
	end;

	//安装完成后 是否立即启动程序
	if isShowStartupOnBootstrap = true then begin
		BtnSetVisibility(startupOnBootupBtn, false);
		startupOnBootupLabel.hide;
	end;

	//安装完成后 是否立即启动程序
	if isShowStartupOnFinish = true then begin
		BtnSetVisibility(startupOnFinishBtn,false);
		startupOnFinishLabel.hide;
	end;
end;

procedure showDetailPanel();
begin
	BtnSetVisibility(installBtn, true);

	//输入安装路径
	if isShowInstallPath = true then begin
		installPath.show;
		BtnSetVisibility(browerBtn, true);
	end;
	
	// 是否显示用户协议
	if isShowLicense = true then begin
		licenseLabelFile.show;
		licenseLabel.show;
		BtnSetVisibility(licenseCheck, true);
	end;
	
	//快捷方式选框
	if isShowCreateShortcut = true then begin
		BtnSetVisibility(DesktopCheck, true);
		DesktopCheckLabel.show;
	end;

	//安装完成后 是否立即启动程序
	if isShowStartupOnBootstrap = true then begin
		BtnSetVisibility(startupOnBootupBtn, true);
		startupOnBootupLabel.show;
	end;

	//安装完成后 是否立即启动程序
	if isShowStartupOnFinish = true then begin
		BtnSetVisibility(startupOnFinishBtn,true);
		startupOnFinishLabel.show;
	end;
end;
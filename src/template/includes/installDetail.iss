var
	detailPanel: TPanel; //主要面板
	installBtn, browerBtn: HWND; //右上角按钮+取消窗口
	
	//选择框
	licenseCheck, DesktopCheck, startupOnFinishBtn, startupOnBootupBtn: HWND; //
	licenseLabel,licenseLabelFile: TLabel;//
	installPath:TNewEdit;

//快捷方式添加前，检查是否勾选添加快捷方式
Function DesktopCheckClick(): Boolean;
begin
	if BtnGetChecked(DesktopCheck) = true then begin
		Result := true;
	end
end;

//同意协议
procedure licenseCheckCheckClick(hBtn:HWND);
begin
	if BtnGetChecked(licenseCheck) = true then
		BtnSetEnabled(installBtn,true)
	else
		BtnSetEnabled(installBtn,false);
end;

//显示license
procedure ShowLicense(Sender: TObject);
var ErrorCode: Integer;
begin
	ShellExec('', ExpandConstant('{tmp}\license.txt'),'', '', SW_SHOW, ewNoWait, ErrorCode)
end;

//安装路径
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
	//安装细节选择面板
	detailPanel := TPanel.Create(WizardForm);
	with detailPanel do begin
		Parent := WizardForm;
		Left := 100;
		Top := 250;
		Width := 400;
		Height := 150;
		BevelOuter := bvNone;
		color:=$ff0000;
		parentColor:=false;
		ParentBackground:=false;
		OnMouseDown := @WizardFormMouseDown;
	end;
	
	SetWindowLong(detailPanel.Handle, GWL_EXSTYLE, GetWindowLong(detailPanel.Handle, GWL_EXSTYLE) or WS_EX_LAYERED)
	SetLayeredWindowAttributes(detailPanel.Handle, TransparentColor, 250, LWA_COLORKEY or LWA_ALPHA)
	
	//安装大按钮
	btnLeft:=(detailPanel.width-231)/2;
	installBtn:=BtnCreate(detailPanel.Handle, btnLeft, 0, 231, 56, ExpandConstant('{tmp}\browserBtn.png'), 3, False);
	BtnSetEvent(installBtn, BtnClickEventID, WrapBtnCallback(@installBtnClick, 1));

	//输入安装路径
	{{if ui.showInstallPath}}
	installPath := TNewEdit.Create(WizardForm);
	with installPath do begin
		Parent := detailPanel;
		Left := 0;
		Top := 60;
		Width := 300;
		Height := 30;
		Font.Size := smallFontSize;
		Font.Name := fontName;
		//BorderStyle := bsNone;
		Text := WizardForm.DirEdit.Text;
		OnChange := @inputInstallPath;
	end;
	browerBtn:=BtnCreate(detailPanel.Handle, 300, 60, 80, 30, ExpandConstant('{tmp}\installBtn.png'), 3, False);
	BtnSetEvent(browerBtn, BtnClickEventID, WrapBtnCallback(@browseButtonClick, 1));
	{{/if}}
	
	
	{{if ui.showLicense}}
	licenseLabelFile := TLabel.Create(WizardForm);
	with licenseLabelFile do begin
		AutoSize:=true;
		SetBounds(120, 97, 98, 14);
		Cursor:= crHand;
		Transparent:=True;
		Font.Color := clblue;
		Font.Name := fontName;
		Font.Size := smallFontSize; 
		Font.Style := [fsUnderline];
		Caption := '{{ui.textLicense}}';
		Parent := detailPanel;
		OnClick:=@ShowLicense;
	end;
	licenseCheck:= createCheckBoxBtn(0, 100, detailPanel, '{{ui.textAgreeLicense}}', 100, {{installDetail.agreeLicense}});
	BtnSetEvent(licenseCheck, BtnClickEventID, WrapBtnCallback(@licenseCheckCheckClick, 1));
	{{/if}}
	
	//快捷方式选框
	{{if ui.showLicense}}
	DesktopCheck:= createCheckBoxBtn(260, 100, detailPanel, '{{ui.textCreateShortcut}}', 100, {{installDetail.createShortcut}});
	{{/if}}
	

	//安装完成后 是否立即启动程序
	{{if ui.showLicense}}
	startupOnBootupBtn:= createCheckBoxBtn(260, 125, detailPanel, '{{ui.textStartupOnBootstrap}}', 100, {{installDetail.startupOnBootstrap}});
	{{/if}}
	

	//安装完成后 是否立即启动程序
	{{if ui.showLicense}}
	startupOnFinishBtn:= createCheckBoxBtn(0, 125, detailPanel, '{{ui.textStartupOnFinish}}', 100, {{installDetail.startupOnFinish}});
	{{/if}}
	
end;


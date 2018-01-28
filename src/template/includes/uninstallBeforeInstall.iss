var	
	resultStr: string;
	uninstallBeforeInstallPabel:TPanel;
	confirmUninstallBtn, cancelBtn, msgboxBgBtn: HWND;


procedure goToInstallWindow();
begin
	ClearImgList();
	WizardForm.hide;
	uninstallBeforeInstallPabel.hide;
	initInstallWindow;
	WizardForm.show;
	ImgApplyChanges(WizardForm.Handle);
end;

//执行安装前卸载
procedure uninstallBeforeInstall(hBtn:HWND);
var resultCode: Integer;
begin
	BtnSetEnabled(confirmUninstallBtn, false);
	BtnSetEnabled(cancelBtn, false);
	Exec(resultStr, '/VERYSILENT', '', SW_SHOWNORMAL, ewWaitUntilTerminated, resultCode);
	//卸载完毕初始化主窗体
	goToInstallWindow;
end;

//安装前取消卸载
procedure cancelUninstallBeforeInstall(hBtn:HWND);
var resultCode: Integer;
begin
	if {{installDetail.requireUninstallBeforeInstall}} then begin
		WizardForm.Close;
	end else begin
		//卸载完毕初始化主窗体
		goToInstallWindow;
	end;
	
end;

//启动安装程序前，卸载旧版程序
function checkPreVersion():Boolean;
var resultCode: Integer;
begin
    if {{installDetail.checkUninstallBeforeInstall}} and RegQueryStringValue(HKLM, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#appName}_is1', 'UninstallString', resultStr) then begin
		result := false;
		resultStr := RemoveQuotes(resultStr);
		with WizardForm do begin
			ClientWidth:=400;
			ClientHeight:=250;
			Center;
			show;
		end;

		//弹窗面板
		uninstallBeforeInstallPabel := TPanel.Create(WizardForm);
		with uninstallBeforeInstallPabel do begin
			Parent := WizardForm;
			Left := 0;
			Top := 0;
			Width := 400;
			Height := 250;
			color:=clWindow;
			BorderStyle := bsNone;
			ParentColor := false;
			ParentBackground:=false;
			OnMouseDown:=@WizardFormMouseDown;
		end;

		with TBitmapImage.Create(uninstallBeforeInstallPabel) do
		begin
			Parent := uninstallBeforeInstallPabel;
			Left := ScaleX(0);
			Top := ScaleY(0);
			Width := ScaleX(400);
			Height := ScaleY(250);
    		Bitmap.LoadFromFile(ExpandConstant('{tmp}\msgboxbg.bmp'));
			OnMouseDown:=@WizardFormMouseDown;
		end;

		with TLabel.Create(uninstallBeforeInstallPabel) do begin
			//color:=clMenuText;
			Parent := uninstallBeforeInstallPabel;
			AutoSize:=false;
			Left := 30;
			Top := 70;
			Width := 350;
			Height := 100;
			wordWrap:=true;
			Transparent:=True;
			Caption := '{{ui.uninstallMsgbox.text}}';
			Font.Size := {{ui.uninstallMsgbox.fontSize}};
			Font.Color := ${{ui.uninstallMsgbox.color}};
			OnMouseDown:=@WizardFormMouseDown;
		end;

		InitFairy(WizardForm.Handle, 0, 20);
		AddImgToList(-20, -20, 255, clNone, ExpandConstant('{tmp}\msgbox.png'))
		ShowFairyEx(0);

		confirmUninstallBtn := BtnCreate(uninstallBeforeInstallPabel.Handle, 295, 190, 80, 35, ExpandConstant('{tmp}\confirmUninstallBtn.png'), 3, False);
		BtnSetEvent(confirmUninstallBtn, BtnClickEventID, WrapBtnCallback(@uninstallBeforeInstall, 1));

		cancelBtn := BtnCreate(uninstallBeforeInstallPabel.Handle, 185, 190, 80, 35, ExpandConstant('{tmp}\cancelBtn.png'), 3, False);
		BtnSetEvent(cancelBtn, BtnClickEventID, WrapBtnCallback(@cancelUninstallBeforeInstall, 1));

    end else begin
		result := true;
	end;
end;
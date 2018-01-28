var
	killTaskPabel:TPanel;
	taskConfirmUninstallBtn, taskCancelBtn: HWND;

//执行安装前卸载
procedure killTaskBeforeInstall(hBtn:HWND);
begin
	KillTask('{#exeName}');
	checkPreVersion();
	killTaskPabel.hide;
end;

//安装前取消卸载
procedure cancelKillRunningTask(hBtn:HWND);
begin
	WizardForm.Close;
end;

//启动安装程序前，卸载旧版程序
function checkRuningTask():Boolean;
begin
	Result := IsModuleLoaded('{#exeName}');
    if Result then begin
		resultStr := RemoveQuotes(resultStr);
		with WizardForm do begin
			ClientWidth:=400;
			ClientHeight:=250;
			Center;
			show;
		end;

		//弹窗面板
		killTaskPabel := TPanel.Create(WizardForm);
		with killTaskPabel do begin
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

		with TBitmapImage.Create(killTaskPabel) do
		begin
			Parent := killTaskPabel;
			Left := ScaleX(0);
			Top := ScaleY(0);
			Width := ScaleX(400);
			Height := ScaleY(250);
    		Bitmap.LoadFromFile(ExpandConstant('{tmp}\msgboxbg.bmp'));
			OnMouseDown:=@WizardFormMouseDown;
		end;

		with TLabel.Create(killTaskPabel) do begin
			//color:=clMenuText;
			Parent := killTaskPabel;
			AutoSize:=false;
			Left := 30;
			Top := 70;
			Width := 350;
			Height := 100;
			wordWrap:=true;
			Transparent:=True;
			Caption := '{{ui.checkTaskMsgbox.text}}';
			Font.Size := {{ui.checkTaskMsgbox.fontSize}};
			Font.Color := ${{ui.checkTaskMsgbox.color}};
			OnMouseDown:=@WizardFormMouseDown;
		end;

		InitFairy(WizardForm.Handle, 0, 20);
		AddImgToList(-20, -20, 255, clNone, ExpandConstant('{tmp}\msgbox.png'))
		ShowFairyEx(0);

		taskConfirmUninstallBtn := BtnCreate(killTaskPabel.Handle, 295, 190, 80, 35, ExpandConstant('{tmp}\continueBtn.png'), 3, False);
		BtnSetEvent(taskConfirmUninstallBtn, BtnClickEventID, WrapBtnCallback(@killTaskBeforeInstall, 1));

		taskCancelBtn := BtnCreate(killTaskPabel.Handle, 185, 190, 80, 35, ExpandConstant('{tmp}\cancelBtn.png'), 3, False);
		BtnSetEvent(taskCancelBtn, BtnClickEventID, WrapBtnCallback(@cancelKillRunningTask, 1));
    end;
end;
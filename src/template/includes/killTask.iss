var
	killTaskPabel:TPanel;
	taskConfirmUninstallBtn, taskCancelBtn: HWND;

//执行安装前卸载
procedure killTaskBeforeInstall(hBtn:HWND);
begin
	KillTask('{#exeName}');
	if checkPreVersion() then begin
		ClearImgList();
		WizardForm.hide;
		initInstallWindow;
		WizardForm.show;
		ImgApplyChanges(WizardForm.Handle);
	end;
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
			ClientWidth:=ScaleX({{ui.checkTaskMsgbox.width}});
			ClientHeight:=ScaleY({{ui.checkTaskMsgbox.height}});
			Center;
			show;
		end;

		//弹窗面板
		killTaskPabel := TPanel.Create(WizardForm);
		with killTaskPabel do begin
			Parent := WizardForm;
			Left := ScaleX(0);
			Top := ScaleY(0);
			Width := ScaleX({{ui.checkTaskMsgbox.width}});
			Height := ScaleY({{ui.checkTaskMsgbox.height}});
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
			Width := ScaleX({{ui.checkTaskMsgbox.width}});
			Height := ScaleY({{ui.checkTaskMsgbox.height}});
    		Bitmap.LoadFromFile(ExpandConstant('{tmp}\msgboxbg.bmp'));
			OnMouseDown:=@WizardFormMouseDown;
		end;

		with TLabel.Create(killTaskPabel) do begin
			//color:=clMenuText;
			Parent := killTaskPabel;
			AutoSize:=false;
			Top := ScaleY({{ui.checkTaskMsgbox.textTop}});
			Left := ScaleX({{ui.checkTaskMsgbox.textLeft}});
			Width := ScaleX({{ui.checkTaskMsgbox.textWidth}});
			Height := ScaleY({{ui.checkTaskMsgbox.textHeight}});
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

		taskConfirmUninstallBtn := BtnCreate(killTaskPabel.Handle, ScaleX({{ui.checkTaskMsgbox.btnOkLeft}}), ScaleY({{ui.checkTaskMsgbox.btnOkTop}}), ScaleX({{ui.checkTaskMsgbox.btnOkWidth}}), ScaleY({{ui.checkTaskMsgbox.btnOkHeight}}), ExpandConstant('{tmp}\continueBtn.png'), 3, False);
		BtnSetEvent(taskConfirmUninstallBtn, BtnClickEventID, WrapBtnCallback(@killTaskBeforeInstall, 1));

		taskCancelBtn := BtnCreate(killTaskPabel.Handle, ScaleX({{ui.checkTaskMsgbox.btnCancelLeft}}), ScaleY({{ui.checkTaskMsgbox.btnCancelTop}}), ScaleX({{ui.checkTaskMsgbox.btnCancelWidth}}), ScaleY({{ui.checkTaskMsgbox.btnCancelHeight}}), ExpandConstant('{tmp}\cancelBtn.png'), 3, False);
		BtnSetEvent(taskCancelBtn, BtnClickEventID, WrapBtnCallback(@cancelKillRunningTask, 1));
	end;
end;
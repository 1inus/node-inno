var
	installBtn, browerBtn: HWND; //���Ͻǰ�ť+ȡ������

	//ѡ���
	licenseCheck, DesktopCheck, startupOnFinishBtn, startupOnBootupBtn: HWND; //
	installPath:TNewEdit;
	inputBorder:Longint;

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
	if true then begin
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

//�ֶ����밲װ·��
procedure inputInstallPath(Sender: TObject);
begin
	  WizardForm.DirEdit.Text := installPath.Text;
end;

//�����װ������
procedure startupClick(Sender: TObject);
begin
	BtnSetChecked(startupOnFinishBtn, not BtnGetChecked(startupOnFinishBtn));
end;

//�����װ������
procedure deskIconClick(Sender: TObject);
begin
	BtnSetChecked(DesktopCheck, not BtnGetChecked(DesktopCheck));
end;

//���ͬ��license
procedure agreeLicenseClick(Sender: TObject);
begin
	BtnSetChecked(licenseCheck, not BtnGetChecked(licenseCheck));
	licenseCheckCheckClick(licenseCheck);
end;

//��ʼ����װϸ������
procedure initDetailPanel();
begin
	//install button
	installBtn:=BtnCreate(WizardForm.Handle, 274, 365, 230, 50, ExpandConstant('{tmp}\installBtn.png'), 3, False);
	BtnSetEvent(installBtn, BtnClickEventID, WrapBtnCallback(@installBtnClick, 1));
	BtnSetEnabled(installBtn, true);

	//���밲װ·��
	if true then begin
		installPath := TNewEdit.Create(WizardForm);
		with installPath do begin
			AutoSize:=false;
			Parent := WizardForm;
			Left := 154+8;
			Top := 429+6;
			Width := 400-16;
			Height := 35-12;
			Font.Size := 35-22;
			Font.Name := fontName;
			Font.Color:=$000000;
			BorderStyle := bsNone;
			Text := WizardForm.DirEdit.Text;
			OnChange := @inputInstallPath;
		end;
		browerBtn:=BtnCreate(WizardForm.Handle, 553, 429, 80, 35, ExpandConstant('{tmp}\browserBtn.png'), 3, False);
		BtnSetEvent(browerBtn, BtnClickEventID, WrapBtnCallback(@browseButtonClick, 1));
		inputBorder:=ImgLoad(WizardForm.Handle, ExpandConstant('{tmp}\inputBorder.png'), 154, 429, 400, 35, True, True);
	end;
	
	// �Ƿ���ʾ�û�Э��
	if true then begin
		licenseLabelFile := TLabel.Create(WizardForm);
		with licenseLabelFile do begin
			AutoSize:=true;
			left:=172;
			top:=478-2;
			Cursor:= crHand;
			Transparent:=True;
			Font.Name := fontName;
			Font.Size := smallFontSize; 
			Font.Style := [fsUnderline];
			Font.Color:=$FF8833;
			Caption := '���Э��';
			Parent := WizardForm;
			OnClick:=@ShowLicense;
		end;
		
		licenseLabel:= createCheckBoxBtn(91, 478, WizardForm, '�Ѿ��Ķ�', 100, true);
		licenseCheck:= licenseLabel.Tag;
		licenseLabel.Font.Color := $000000;
		BtnSetEvent(licenseCheck, BtnClickEventID, WrapBtnCallback(@licenseCheckCheckClick, 1));
		licenseLabel.OnClick := @agreeLicenseClick;
	end;
	
	//��ݷ�ʽѡ��
	if true then begin
		DesktopCheckLabel:= createCheckBoxBtn(465, 478, WizardForm, '���������ݷ�ʽ', 100, true);
		DesktopCheck:= DesktopCheckLabel.Tag;
		DesktopCheckLabel.Font.Color := $000000;
	end;

	//��װ��ɺ� �Ƿ�������������
	if true then begin
		startupOnBootupLabel:= createCheckBoxBtn(253, 478, WizardForm, '��������', 100, true);
		startupOnBootupBtn:= startupOnBootupLabel.Tag;
		startupOnBootupLabel.Font.Color := $000000;
	end;

	//��װ��ɺ� �Ƿ�������������
	if true then begin
		startupOnFinishLabel:= createCheckBoxBtn(352, 478, WizardForm, '�������г���', 100, true);
		startupOnFinishBtn:= startupOnFinishLabel.Tag;
		startupOnFinishLabel.Font.Color := 000000;
	end;
end;

procedure hideDetailPanel();
begin
	BtnSetVisibility(installBtn, false);

	//���밲װ·��
	if true then begin
		installPath.hide;
		BtnSetVisibility(browerBtn, false);
		ImgSetVisibility(inputBorder, false);
	end;
	
	// �Ƿ���ʾ�û�Э��
	if true then begin
		licenseLabelFile.hide;
		licenseLabel.hide;
		BtnSetVisibility(licenseCheck, false);
	end;
	
	//��ݷ�ʽѡ��
	if true then begin
		BtnSetVisibility(DesktopCheck, false);
		DesktopCheckLabel.hide;
	end;

	//��װ��ɺ� �Ƿ�������������
	if true then begin
		BtnSetVisibility(startupOnBootupBtn, false);
		startupOnBootupLabel.hide;
	end;

	//��װ��ɺ� �Ƿ�������������
	if true then begin
		BtnSetVisibility(startupOnFinishBtn,false);
		startupOnFinishLabel.hide;
	end;
end;

procedure showDetailPanel();
begin
	//���밲װ·��
	if true then begin
		installPath.show;
		BtnSetVisibility(browerBtn, true);
		ImgSetVisibility(inputBorder, true);
	end;
	
	// �Ƿ���ʾ�û�Э��
	if true then begin
		licenseLabelFile.show;
		licenseLabel.show;
		BtnSetVisibility(licenseCheck, true);
	end;
	
	//��ݷ�ʽѡ��
	if true then begin
		BtnSetVisibility(DesktopCheck, true);
		DesktopCheckLabel.show;
	end;

	//��װ��ɺ� �Ƿ�������������
	if true then begin
		BtnSetVisibility(startupOnBootupBtn, true);
		startupOnBootupLabel.show;
	end;

	//��װ��ɺ� �Ƿ�������������
	if true then begin
		BtnSetVisibility(startupOnFinishBtn,true);
		startupOnFinishLabel.show;
	end;
end;
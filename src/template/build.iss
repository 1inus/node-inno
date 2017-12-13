#include "includes\config.iss";

[Code]
#include "includes\const.iss";
var
	installStep : Longint;
	progressPanel: TPanel; //��Ҫ���
	
	io : integer;

	//�ٷֱ�
	PBOldProc : Longint;
	
#include "includes\common.iss";
#include "includes\resetMainWindow.iss";
#include "includes\installDetail.iss";
#include "includes\installProgressBar.iss";
#include "includes\installFinish.iss";

//�ٷֱ�
function PBProc(h:hWnd; Msg, wParam, lParam:Longint):Longint;
var
	pr,i1,i2 : Extended;
begin
	Result:=CallWindowProc(PBOldProc, h, Msg, wParam, lParam);
	if (Msg=$402) and (WizardForm.ProgressGauge.Position>WizardForm.ProgressGauge.Min) then begin
		i1:=WizardForm.ProgressGauge.Position-WizardForm.ProgressGauge.Min;
		i2:=WizardForm.ProgressGauge.Max-WizardForm.ProgressGauge.Min;
		pr:=i1*100/i2;
		setProgressWidth(Round(pr));
	end;
end;


//�򵼵�������¼�����ȷ���Ƿ�������ҳ����һ������ҳ (�� PageID ָ��) ��ʾ��������� True����������ҳ������㷵�� False����ҳ����ʾ��inno
//ע��: ����¼��������� wpPreparing �� wpInstalling ҳ���ã����а�װ�����Ѿ�ȷ��Ҫ������ҳҲ������� (���磬û�а��������װ����� wpSelectComponents)��inno
function ShouldSkipPage(PageID: Integer): Boolean;
begin
	if PageID=wpSelectComponents then    //���������װ����
		result := true;

	if PageID=wpWelcome then
		result := true;

	if PageID=wpSelectDir then
		result := true;
end;

//�ڰ�װ�����ʼ��ʱ���ã����� False �жϰ�װ������ True ��֮��inno
function InitializeSetup: Boolean;
begin
	//if RegQueryStringValue(HKLM, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#appName}_is1', 'UninstallString', ResultStr) then begin
		//if msgbox('��⵽�ɰ汾�����"ȷ��"���Զ�ж�ؾɰ汾�����"ȡ��"�˳���װ', mbInformation, MB_OKCANCEL) = idok then begin
			//ResultStr := RemoveQuotes(ResultStr);
			//Exec(ResultStr, '/VERYSILENT', '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
			//Result := true;
		//end else begin
			//Result := False;
		//end
	//end else begin
		Result := true;
	//end
end;

//ʹ������¼���������ʱ�ı��򵼻���ҳ���㲻����������֮��ʹ�� InitializeSetup �¼��������򵼴��岻�˳�
procedure InitializeWizard();
begin
	ExtractTmpFiles;
	resetMainWindow(win_width, win_height);
	initDetailPanel;
	createProgressPanel(0, 250, win_width, 150);
	createFinishPanel(0, 250, 240, 60);
	installStep := wpWelcome;
	PBOldProc:=SetWindowLong(WizardForm.ProgressGauge.Handle,-4,PBCallBack(@PBProc,4));
	detailPanel.show;
	hideProgressPanel;
end;

//�����������ڰ�װҳ��
//������ҳ (�� CurPageID ָ��) ��ʾ����á�inno
procedure CurPageChanged(CurPageID: Integer);
var RCode: Integer;
begin
	//ImgRelease(mainBg);
	//mainBg:=ImgLoad(WizardForm.Handle, ExpandConstant('{tmp}\bg.png'), 0, 0, 434, 384, True, True);

	//���ڰ�װ
	if CurPageID = wpInstalling then begin
		installStep := wpInstalling;
		detailPanel.hide;
		setEnableCloseBtn(true);
		//��ʾ��װ��ҳ��
		showProgressPanel;
	end else if CurPageID = wpFinished then begin //��װ��ϣ�ֱ��������װ��
		installStep := wpFinished;
		setEnableCloseBtn(true);
		hideProgressPanel;
		showFinishedPanel;
		if BtnGetChecked(startupOnFinishBtn) = true then begin
			Exec(ExpandConstant('{app}\{#appName}' + '.exe'), '', '', SW_SHOW, ewNoWait, RCode);
			WizardForm.NextButton.Click;
		end else begin
			showFinishedPanel;
		end;
	end;

	//���û��������ʾ����ͼ��
	ImgApplyChanges(WizardForm.Handle);
end;

//���ڰ�װ������ֹǰ���á�ע����������ڼ�ʹ�û����κ����ݰ�װ֮ǰ�˳���װ����ʱҲ����á�inno
procedure DeinitializeSetup();
begin
	gdipShutdown;  //����ͼ
	if PBOldProc<>0 then SetWindowLong(WizardForm.ProgressGauge.Handle,-4,PBOldProc);
end;


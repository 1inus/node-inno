#include "GifCtrl.ish";
#include "includes\config.iss";

[Code]
#include "includes\const.iss";

var
	installStep : Longint;
	progressPanel: TPanel; //主要面板

	//百分比
	PBOldProc : Longint;
	
#include "includes\common.iss";
#include "includes\resetMainWindow.iss";
#include "includes\adBar.iss";
#include "includes\installDetail.iss";
#include "includes\installProgressBar.iss";
#include "includes\installFinish.iss";

//百分比
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

//向导调用这个事件函数确定是否在所有页或不在一个特殊页 (用 PageID 指定) 显示。如果返回 True，将跳过该页；如果你返回 False，该页被显示。inno
//注意: 这个事件函数不被 wpPreparing 和 wpInstalling 页调用，还有安装程序已经确定要跳过的页也不会调用 (例如，没有包含组件安装程序的 wpSelectComponents)。inno
function ShouldSkipPage(PageID: Integer): Boolean;
begin
	if PageID=wpSelectComponents then    //跳过组件安装界面
		result := true;

	if PageID=wpWelcome then
		result := true;

	if PageID=wpSelectDir then
		result := true;
end;


//使用这个事件函数启动时改变向导或向导页。你不能在它触发之后使用 InitializeSetup 事件函数，向导窗体不退出
procedure InitializeWizard();
begin
PDir('GifCtrl.dll');

	ExtractTemporaryFile('bg.png');
	ExtractTemporaryFile('shadow.png');
	ExtractTemporaryFile('inputBorder.png');
	ExtractTemporaryFile('minimizeBtn.png');
	ExtractTemporaryFile('closeBtn.png');
	ExtractTemporaryFile('installBtn.png');
	ExtractTemporaryFile('startAppBtn.png');
	ExtractTemporaryFile('browserBtn.png');
	ExtractTemporaryFile('checkBox.png');
	ExtractTemporaryFile('license.html');
	ExtractTemporaryFile('progress.png');
	ExtractTemporaryFile('progressBg.png');

	resetMainWindow;
	initAdBar;
	initDetailPanel;
	createProgressPanel(0, 250, win_width, 150);
	createFinishPanel(0, 250, 240, 60);
	installStep := wpWelcome;
	PBOldProc:=SetWindowLong(WizardForm.ProgressGauge.Handle,-4,PBCallBack(@PBProc,4));
	showDetailPanel;
	hideProgressPanel;
end;

//在这里是正在安装页面
//在新向导页 (用 CurPageID 指定) 显示后调用。inno
procedure CurPageChanged(CurPageID: Integer);
var RCode: Integer;
begin
	//ImgRelease(mainBg);
	//mainBg:=ImgLoad(WizardForm.Handle, ExpandConstant('{tmp}\bg.png'), 0, 0, win_width, win_height, True, True);

	//WelcomePage=1  SelectDirPage=6 ReadyPage=10 InstallingPage=12 FinishedPage=14 
	//wpWelcome = 1;
	//wpLicense = 2;
	//wpPassword = 3;
	//wpInfoBefore = 4;
	//wpUserInfo = 5;
	//wpSelectDir = 6;
	//wpSelectComponents = 7;
	//wpSelectProgramGroup = 8;
	//wpSelectTasks = 9;
	//wpReady = 10;
	//wpPreparing = 11;
	//wpInstalling = 12;
	//wpInfoAfter = 13;
	//wpFinished = 14;

	//正在安装
	if CurPageID = wpInstalling then begin
		installStep := wpInstalling;
		hideDetailPanel;
		setEnableCloseBtn(true);

		//显示安装中页面
		showProgressPanel;
	end else if CurPageID = wpFinished then begin //安装完毕（直接跳过安装）
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

	//如果没有它就显示不了图像
	ImgApplyChanges(WizardForm.Handle);
end;

//仅在安装程序终止前调用。注意这个函数在即使用户在任何内容安装之前退出安装程序时也会调用。inno
procedure DeinitializeSetup();
begin
	FreeAllGifWnd();
	gdipShutdown;  //背景图
	if PBOldProc<>0 then SetWindowLong(WizardForm.ProgressGauge.Handle,-4,PBOldProc);
end;
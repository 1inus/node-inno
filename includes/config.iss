#include '..\plugin\dll.iss'

#define appURL 					""
#define MyAppId 				"TakeColor 1.0.0"
#define appName 				"TakeColor"
#define appVersion 				"1.0.0"
#define MyComments 				"myapp_installer"
#define appPublisher 			"htgk"

#define fontName 				"Microsoft YaHei"
#define textLicense 			"undefined"
#define textAgreeLicense 		"undefined"
#define textCancleInstall 		"undefined"
#define textCreateShortcut 		"undefined"
#define textStartupOnFinish 	"undefined"
#define textStartupOnBootstrap 	"undefined"
#define textCancleInstallMsgbox "undefined"

[Setup]
AppName					= {#appName}
AppVersion				= {#appVersion}
VersionInfoCompany		= {#appPublisher}
VersionInfoCopyright	= {#appPublisher}
AppComments				= {#MyComments}
VersionInfoVersion		= {#appVersion}

AppPublisher			= {#appPublisher}
AppPublisherURL			= {#appURL}
AppSupportURL			= {#appURL}
AppUpdatesURL			= {#appURL}

//install dir
DefaultDirName			= {pf}\{#appName}
DefaultGroupName		= {#appName}

//output dir
OutPutDir				= "C:\Users\cnlia\Desktop"
OutputBaseFilename		= "{#appName}-{#appVersion}"

// compress
Compression				= lzma2/ultra64
SolidCompression		= yes

AllowNoIcons			= yes
DisableReadyPage		= yes
DisableProgramGroupPage	= yes

SetupIconFile			= "inno-resource\install.ico"
UninstallDisplayIcon	= "inno-resource\uninstall.ico"

//use preview
UsePreviousAppDir		= yes
UsePreviousGroup		= yes
UsePreviousLanguage		= yes
UsePreviousSetupType	= yes
UsePreviousTasks		= yes
UsePreviousUserInfo		= yes

[Tasks]
Name: "startupicon"; Description: "{#appName} startupOnBootstrap"; GroupDescription: "{cm:AdditionalIcons}";

[Icons]
Name: "{group}\{#appName}"; Filename: "{app}\{#appName}.exe"; WorkingDir: "{app}";
Name: "{group}\{cm:UninstallProgram,{#appName}}"; Filename: "{uninstallexe}"; WorkingDir: "{app}";
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#appName}"; Filename: "{app}\{#appName}.exe"; WorkingDir: "{app}";

Name: "{userdesktop}\{#appName}"; Filename: "{app}\{#appName}.exe"; Check: DesktopCheckClick;

[Registry] 
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"; ValueType:string; ValueName:"{#appName}"; ValueData: "{app}\{#appName}"


 Root: HKCR;  Subkey: workplusProtocol\DefaultIcon;  ValueType: string; ValueName: URL Qiaoker Protocol;  ValueData: "{app}\WorkPlus.exe";  Flags: CreateValueIfDoesntExist; 

 Root: HKCR;  Subkey: workplusProtocol\shell\open\command;  ValueType: string; ValueName: URL Qiaoker Protocol;  ValueData: "{app}\WorkPlus.exe ""%1""";  Flags: CreateValueIfDoesntExist; 


[Files]
Source: "inno-resource\*"; 	DestDir: {tmp}; Flags: dontcopy solidbreak;
Source: "plugin\*.dll";  	DestDir: {app}; Flags: dontcopy solidbreak;

Source: "D:\product\node-inno-demo\build\app\*";  DestDir: {app}; Flags: recursesubdirs;
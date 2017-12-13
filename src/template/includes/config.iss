#include 'WebCtrl.Ish'
#include '..\plugin\dll.iss'

#define MyAppId "{{app.id}}"
#define appName "{{app.name}}"
#define appVersion "{{app.version}}"
#define appPublisher "{{app.publisher}}"
#define appURL "{{app.url}}"
#define MyComments "{{app.comments}}"

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

//安装路劲
DefaultDirName			= {pf}\{#appName}
DefaultGroupName		= {#appName}

//编译输出路径
OutPutDir				= "{{installDetail.installerOutputDir}}"
OutputBaseFilename		= "{#appName}-{#appVersion}"

//压缩
Compression				= lzma2/ultra64
SolidCompression		= yes

AllowNoIcons			= yes
DisableReadyPage		= yes
DisableProgramGroupPage	= yes

SetupIconFile			= "inno-resource\installer.ico"

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
Name: "{userstartup}\{#appName}"; 						Filename: "{app}\{#appName}"; 		IconFilename: "{app}\icon.ico"; Tasks: startupicon
Name: "{group}\{#appName}"; 							Filename: "{app}\{#appName}.exe";	WorkingDir: "{app}";
Name: "{userdesktop}\{#appName}";						Filename: "{app}\{#appName}.exe"; 	IconFilename: "{app}\icon.ico"; Check: DesktopCheckClick;
Name: "{group}\{cm:UninstallProgram,{#appName}}"; 		Filename: "{uninstallexe}";			WorkingDir: {app};
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#appName}"; Filename: "{app}\{#appName}.exe"; WorkingDir: {app};

[Registry] 
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "testrun"; ValueData: "{app}\{#appName}"

[Files]
Source: "inno-resource\*"; 		DestDir: {tmp}; Flags: dontcopy solidbreak; 
Source: "plugin\*.dll";  	DestDir: {app}; Flags: dontcopy solidbreak;

//打包文件
Source: "{{app.package}}";  DestDir: {app}; Flags: recursesubdirs;
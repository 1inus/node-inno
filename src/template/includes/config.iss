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

//install dir
DefaultDirName			= {pf}\{#appName}
DefaultGroupName		= {#appName}

//output dir
OutPutDir				= "{{installDetail.installerOutputDir}}"
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

[Files]
Source: "inno-resource\*"; 	DestDir: {tmp}; Flags: dontcopy solidbreak; 
Source: "plugin\*.dll";  	DestDir: {app}; Flags: dontcopy solidbreak;

Source: "{{app.package}}";  DestDir: {app}; Flags: recursesubdirs;
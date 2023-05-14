[Setup]
AppName=AlistHelper
AppVersion={#AppVersion}
AppPublisher=Xmarmalade
AppCopyright=Copyright (C) 2023 Xmarmalade
WizardStyle=modern
Compression=lzma2
SolidCompression=yes
DefaultDirName={autopf}\AlistHelper\
DefaultGroupName=AlistHelper
SetupIconFile=alisthelper.ico
UninstallDisplayIcon={app}\alisthelper.exe
UninstallDisplayName=AlistHelper
UsePreviousAppDir=no
PrivilegesRequiredOverridesAllowed=dialog
CloseApplications=yes

[Files]
Source: "Release\alisthelper.exe";DestDir: "{app}";DestName: "alisthelper.exe"
Source: "Release\*";DestDir: "{app}"
Source: "Release\data\*";DestDir: "{app}\data\"; Flags: recursesubdirs

[Icons]
Name: "{userdesktop}\AlistHelper"; Filename: "{app}\AlistHelper.exe"
Name: "{group}\AlistHelper"; Filename: "{app}\AlistHelper.exe"
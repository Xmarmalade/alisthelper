[Setup]
AppName=AlistHelper
AppVersion=v0.0.3
AppPublisher=Xmarmalade
WizardStyle=modern
Compression=lzma2
SolidCompression=yes
DefaultDirName={autopf}\AlistHelper\
DefaultGroupName=AlistHelper
SetupIconFile=alisthelper_logo.ico
UninstallDisplayIcon={app}\alisthelper.exe
UninstallDisplayName=AlistHelper
VersionInfoVersion=0.0.3
UsePreviousAppDir=no

[Files]
Source: "AlistHelper\alisthelper.exe";DestDir: "{app}";DestName: "alisthelper.exe"
Source: "AlistHelper\*";DestDir: "{app}"
Source: "AlistHelper\data\*";DestDir: "{app}\data\"; Flags: recursesubdirs

[Icons]
Name: "{userdesktop}\AlistHelper"; Filename: "{app}\AlistHelper.exe"
Name: "{group}\AlistHelper"; Filename: "{app}\AlistHelper.exe"
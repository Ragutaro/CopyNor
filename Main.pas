unit Main;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.StrUtils, IniFilesDX, System.IOUtils, System.Types,
  Vcl.Filectrl, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmMain = class(TForm)
    lstInfo: TListBox;
    Timer: TTimer;
    btnRetry: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TimerTimer(Sender: TObject);
    procedure btnRetryClick(Sender: TObject);
  private
    { Private 宣言 }
    procedure _LoadSettings;
    procedure _SaveSettings;
    procedure _CopyFiles;
    procedure _CopyFilesFinePix;
  public
    { Public 宣言 }
  end;

type
  TApplicationValues = record
    sDriveCanon, sDriveFuji : String;
  end;

var
  frmMain: TfrmMain;
  av : TApplicationValues;

implementation

{$R *.dfm}

uses
  HideUtils,
  dp;


procedure TfrmMain.btnRetryClick(Sender: TObject);
begin
  _CopyFiles;
  _CopyFilesFinePix;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  _SaveSettings;
  Release;
  frmMain := nil;   //フォーム名に変更する
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  if IsDebugMode then
     Self.Caption := 'Debug Mode - ' + Self.Caption;
  DisableVclStyles(Self, '');
  _LoadSettings;
end;

procedure TfrmMain._CopyFiles;
var
  sl : TStringList;
  i, iCnt : Integer;
  sSrcDir, sDstDir, sFilename : String;
  d : TDateTime;
begin
  Timer.Enabled := False;
  iCnt := 0;
  sSrcDir := av.sDriveCanon + ':\DCIM';
  sDstDir := 'C:\!MyData\猫写真\Nor\';

  lstInfo.Items.Add('Canon PowerShot A2600 の写真をコピーします');
  Application.ProcessMessages;

  if Not DriveExists(av.sDriveCanon[1]) then
  begin
    lstInfo.Items.Add(av.sDriveCanon + 'ドライブにSDカードが入っていません。');
  	Exit;
  end;

  sl := TStringList.Create;
  try
    GetFiles(sSrcDir, '*.*', sl, True);
    for i := 0 to sl.Count-1 do
    begin
      if ContainsText(sl[i], '.JPG') then
      begin
        d := TFile.GetLastWriteTime(sl[i]);
        sFilename := sDstDir + 'Pictures\' + FormatDateTime('YYMMDD_HHNNSS', d) + '.jpg';
//        sFilename := sDstDir + 'Pictures\' + ExtractFileName(sl[i]);
        if Not FileExists(sFilename) then
        begin
        	CopyFile(sl[i], sFilename);
          lstInfo.Items.Add('Copy:' + sl[i]);
          Inc(iCnt);
        end;
      end else if ContainsText(sl[i], '.MOV') then
      begin
        sFilename := sDstDir + 'Movies\Sources\' + ExtractFileName(sl[i]);
        if Not FileExists(sFilename) then
        begin
        	CopyFile(sl[i], sFilename);
          lstInfo.Items.Add('Copy:' + sl[i]);
          Inc(iCnt);
        end;
      end;
      lstInfo.ItemIndex := lstInfo.Items.Count-1;
      Application.ProcessMessages;
    end;
  finally
    sl.Free;
  end;
  lstInfo.Items.Add(IntToStr(iCnt) + '個のファイルをコピーしました。');
  ShellExecuteSimple(sDstDir);
end;

procedure TfrmMain._CopyFilesFinePix;
var
  sl : TStringList;
  i, iCnt : Integer;
  sSrcDir, sDstDir, sFilename : String;
  d : TDateTime;
begin
  Timer.Enabled := False;
  iCnt := 0;
  sSrcDir := av.sDriveFuji + ':\DCIM\100_FUJI\';
  sDstDir := 'C:\!MyData\猫写真\Nor\';

  lstInfo.Items.Add('FUJIFILM FinePix F11 の写真をコピーします');
  Application.ProcessMessages;

  if Not DriveExists(av.sDriveFuji[1]) then
  begin
    lstInfo.Items.Add(av.sDriveFuji + 'ドライブにxDカードが入っていません。');
  	Exit;
  end;

  sl := TStringList.Create;
  try
    GetFiles(sSrcDir, '*.*', sl, True);
    for i := 0 to sl.Count-1 do
    begin
      if ContainsText(sl[i], '.JPG') then
      begin
        d := TFile.GetLastWriteTime(sl[i]);
        sFilename := sDstDir + 'Pictures\' + FormatDateTime('YYMMDD_HHNNSS', d) + '.jpg';
//        sFilename := sDstDir + 'Pictures\' + ExtractFileName(sl[i]);
        if Not FileExists(sFilename) then
        begin
        	CopyFile(sl[i], sFilename);
          lstInfo.Items.Add('Copy:' + sl[i]);
          Inc(iCnt);
        end;
      end else if ContainsText(sl[i], '.AVI') then
      begin
        sFilename := sDstDir + 'Movies\Sources\' + ExtractFileName(sl[i]);
        if Not FileExists(sFilename) then
        begin
        	CopyFile(sl[i], sFilename);
          lstInfo.Items.Add('Copy:' + sl[i]);
          Inc(iCnt);
        end;
      end;
      lstInfo.ItemIndex := lstInfo.Items.Count-1;
      Application.ProcessMessages;
    end;
  finally
    sl.Free;
  end;
  lstInfo.Items.Add(IntToStr(iCnt) + '個のファイルをコピーしました。');
  ShellExecuteSimple(sDstDir);
end;

procedure TfrmMain._LoadSettings;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.ReadWindowPosition(Self.Name, Self);
    Self.Font.Name := ini.ReadString('General', 'FontName', 'メイリオ');
    Self.Font.Size := ini.ReadInteger('General', 'FontSize', 10);
    av.sDriveCanon := ini.ReadString('General', 'Canon', 'I');
    av.sDriveFuji  := ini.ReadString('General', 'Fuji', 'K');
  finally
    ini.Free;
  end;
end;

procedure TfrmMain._SaveSettings;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.WriteWindowPosition(Self.Name, Self);
    ini.WriteString('General', 'FontName', Self.Font.Name);
    ini.WriteInteger('General', 'FontSize', Self.Font.Size);
    ini.WriteString('General', 'Canon', av.sDriveCanon);
    ini.WriteString('General', 'Fuji', av.sDriveFuji);
  finally
    ini.UpdateFile;
    ini.Free;
  end;
end;

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case key of
    char(VK_ESCAPE) :
      begin
        Key := char(0);
        Close;
      end;
  end;
end;

procedure TfrmMain.TimerTimer(Sender: TObject);
begin
  _CopyFiles;
  _CopyFilesFinePix;
end;

end.

object frmMain: TfrmMain
  Left = 356
  Top = 143
  BorderIcons = [biSystemMenu]
  Caption = 'Copy Nor Pictures'
  ClientHeight = 198
  ClientWidth = 429
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #12513#12452#12522#12458
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  DesignSize = (
    429
    198)
  PixelsPerInch = 96
  TextHeight = 18
  object lstInfo: TListBox
    Left = 0
    Top = 0
    Width = 429
    Height = 158
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 18
    TabOrder = 0
  end
  object btnRetry: TButton
    Left = 346
    Top = 165
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #20877#35430#34892
    TabOrder = 1
    OnClick = btnRetryClick
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 22
    Top = 14
  end
end

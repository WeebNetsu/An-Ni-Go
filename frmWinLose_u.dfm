object frmWinLose: TfrmWinLose
  Left = 0
  Top = 0
  Caption = 'Undefined'
  ClientHeight = 545
  ClientWidth = 848
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object lblWin: TLabel
    Left = 136
    Top = 288
    Width = 1030
    Height = 97
    Caption = 'Congratulations, you win!'
    Color = clLime
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -80
    Font.Name = 'Tahoma'
    Font.Style = [fsBold, fsUnderline]
    ParentColor = False
    ParentFont = False
  end
  object lblLose: TLabel
    Left = 256
    Top = 288
    Width = 898
    Height = 97
    Caption = 'Unfortunately you lost'
    Color = clRed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -80
    Font.Name = 'Tahoma'
    Font.Style = [fsBold, fsUnderline]
    ParentColor = False
    ParentFont = False
  end
  object btnAgain: TButton
    Left = 584
    Top = 472
    Width = 121
    Height = 65
    Cursor = crHandPoint
    Caption = 'Play again'
    TabOrder = 0
    OnClick = btnAgainClick
  end
  object btnExitForm: TButton
    Left = 696
    Top = 472
    Width = 121
    Height = 65
    Caption = 'Exit'
    TabOrder = 1
    OnClick = btnExitFormClick
  end
end

object App: TApp
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'App'
  ClientHeight = 139
  ClientWidth = 318
  Color = clAqua
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 19
  object LNmax: TLabel
    Left = 24
    Top = 8
    Width = 156
    Height = 19
    Caption = 'maximum iteration'
  end
  object LNit: TLabel
    Left = 24
    Top = 40
    Width = 135
    Height = 19
    Caption = 'current iteration'
  end
  object LNmaxN: TLabel
    Left = 216
    Top = 8
    Width = 68
    Height = 19
    Caption = 'LNmaxN'
  end
  object LNitN: TLabel
    Left = 216
    Top = 40
    Width = 45
    Height = 19
    Caption = 'LNitN'
  end
  object ButCan: TButton
    Left = 200
    Top = 75
    Width = 89
    Height = 32
    Caption = 'Stop'
    ModalResult = 1
    TabOrder = 0
    OnClick = ButCanClick
  end
end

object App: TApp
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'App'
  ClientHeight = 176
  ClientWidth = 402
  Color = clAqua
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 120
  TextHeight = 24
  object LNmax: TLabel
    Left = 30
    Top = 10
    Width = 192
    Height = 24
    Caption = 'maximum iteration'
  end
  object LNit: TLabel
    Left = 30
    Top = 51
    Width = 167
    Height = 24
    Caption = 'current iteration'
  end
  object LNmaxN: TLabel
    Left = 273
    Top = 10
    Width = 84
    Height = 24
    Caption = 'LNmaxN'
  end
  object LNitN: TLabel
    Left = 273
    Top = 51
    Width = 55
    Height = 24
    Caption = 'LNitN'
  end
  object ButCan: TButton
    Left = 253
    Top = 95
    Width = 112
    Height = 40
    Caption = 'Stop'
    ModalResult = 1
    TabOrder = 0
    OnClick = ButCanClick
  end
end

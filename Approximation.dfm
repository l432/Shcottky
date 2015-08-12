object Approx: TApprox
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Approx'
  ClientHeight = 209
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
  object Ln: TLabel
    Left = 24
    Top = 71
    Width = 40
    Height = 19
    Caption = 'I0 = '
  end
  object Label1: TLabel
    Left = 24
    Top = 99
    Width = 33
    Height = 19
    Caption = 'n = '
  end
  object Label2: TLabel
    Left = 24
    Top = 127
    Width = 43
    Height = 19
    Caption = 'Rs = '
  end
  object Label3: TLabel
    Left = 24
    Top = 155
    Width = 53
    Height = 19
    Caption = 'Rsh = '
  end
  object Label4: TLabel
    Left = 216
    Top = 8
    Width = 54
    Height = 19
    Caption = 'Label4'
  end
  object Label5: TLabel
    Left = 216
    Top = 40
    Width = 54
    Height = 19
    Caption = 'Label5'
  end
  object Label6: TLabel
    Left = 80
    Top = 71
    Width = 54
    Height = 19
    Caption = 'Label6'
  end
  object Label7: TLabel
    Left = 80
    Top = 98
    Width = 54
    Height = 19
    Caption = 'Label7'
  end
  object Label8: TLabel
    Left = 80
    Top = 126
    Width = 54
    Height = 19
    Caption = 'Label8'
  end
  object Label9: TLabel
    Left = 80
    Top = 154
    Width = 54
    Height = 19
    Caption = 'Label9'
  end
  object Label12: TLabel
    Left = 24
    Top = 183
    Width = 50
    Height = 19
    Caption = 'Iph = '
  end
  object Label13: TLabel
    Left = 80
    Top = 182
    Width = 54
    Height = 19
    Caption = 'Label9'
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

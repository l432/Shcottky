object GrIIForm: TGrIIForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Gromov function II parameters '
  ClientHeight = 465
  ClientWidth = 365
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label12: TLabel
    Left = 13
    Top = 308
    Width = 142
    Height = 16
    Caption = 'Range for calculation:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 128
    Height = 16
    Caption = 'Gromovi function II:'
  end
  object Label7: TLabel
    Left = 106
    Top = 30
    Width = 144
    Height = 16
    Caption = 'Y = F (V) ,  gamma=2 '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label18: TLabel
    Left = 8
    Top = 92
    Width = 238
    Height = 16
    Caption = 'Gromovi function II approximation is:'
  end
  object Label2: TLabel
    Left = 90
    Top = 114
    Width = 137
    Height = 16
    Caption = 'Y = A + B X+ C ln(X)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 136
    Width = 249
    Height = 16
    Caption = 'where A, B, C  - parameters. And then'
  end
  object Label6: TLabel
    Left = 131
    Top = 158
    Width = 55
    Height = 16
    Caption = 'Rs = 2 B'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 115
    Top = 180
    Width = 112
    Height = 16
    Caption = 'n = 2 e C / kT +2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 20
    Top = 202
    Width = 335
    Height = 16
    Caption = #1060'b = 2 A / n - [ kT ( 2 - n ) / n e ] ln (S * Ar * T^2)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 8
    Top = 232
    Width = 141
    Height = 16
    Caption = 'Rs - series resistance'
  end
  object Label9: TLabel
    Left = 8
    Top = 254
    Width = 113
    Height = 16
    Caption = 'n - ideality factor'
  end
  object Label11: TLabel
    Left = 8
    Top = 276
    Width = 123
    Height = 16
    Caption = #1060'b - barrier height'
  end
  object Label10: TLabel
    Left = 178
    Top = 232
    Width = 106
    Height = 16
    Caption = 'S - contact area'
  end
  object Label13: TLabel
    Left = 178
    Top = 254
    Width = 164
    Height = 32
    Caption = 'Ar - effective Richardson constant'
    WordWrap = True
  end
  object Label14: TLabel
    Left = 106
    Top = 52
    Width = 33
    Height = 16
    Caption = 'X = I'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label15: TLabel
    Left = 20
    Top = 66
    Width = 151
    Height = 16
    Caption = 'F (V) - Norde'#39's function'
  end
  object LEXmin: TLabeledEdit
    Left = 20
    Top = 350
    Width = 121
    Height = 24
    EditLabel.Width = 70
    EditLabel.Height = 16
    EditLabel.Caption = 'X min (>0)'
    TabOrder = 0
  end
  object LEYmin: TLabeledEdit
    Left = 20
    Top = 393
    Width = 121
    Height = 24
    EditLabel.Width = 81
    EditLabel.Height = 16
    EditLabel.Caption = 'Y min (>=0)'
    TabOrder = 1
  end
  object LEYmax: TLabeledEdit
    Left = 204
    Top = 393
    Width = 121
    Height = 24
    EditLabel.Width = 39
    EditLabel.Height = 16
    EditLabel.Caption = 'Y max'
    TabOrder = 3
  end
  object LEXmax: TLabeledEdit
    Left = 204
    Top = 350
    Width = 121
    Height = 24
    EditLabel.Width = 39
    EditLabel.Height = 16
    EditLabel.Caption = 'X max'
    TabOrder = 2
  end
  object Button1: TButton
    Left = 104
    Top = 434
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 4
  end
  object Button2: TButton
    Left = 250
    Top = 434
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ModalResult = 2
    ParentFont = False
    TabOrder = 5
  end
end

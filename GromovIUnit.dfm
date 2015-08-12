object GrIForm: TGrIForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Gromov function I parameters '
  ClientHeight = 443
  ClientWidth = 345
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
    Left = 8
    Top = 284
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
    Width = 123
    Height = 16
    Caption = 'Gromovi function I:'
  end
  object Label7: TLabel
    Left = 106
    Top = 30
    Width = 98
    Height = 16
    Caption = 'Y = V ,     X = I'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label18: TLabel
    Left = 8
    Top = 52
    Width = 233
    Height = 16
    Caption = 'Gromovi function I approximation is:'
  end
  object Label2: TLabel
    Left = 90
    Top = 74
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
    Top = 96
    Width = 249
    Height = 16
    Caption = 'where A, B, C  - parameters. And then'
  end
  object Label6: TLabel
    Left = 131
    Top = 118
    Width = 43
    Height = 16
    Caption = 'Rs = B'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 114
    Top = 140
    Width = 77
    Height = 16
    Caption = 'n = e C / kT'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 28
    Top = 162
    Width = 292
    Height = 16
    Caption = #1060'b = kT A / e C + ( kT / e ) ln (S * Ar * T^2)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 8
    Top = 192
    Width = 141
    Height = 16
    Caption = 'Rs - series resistance'
  end
  object Label9: TLabel
    Left = 8
    Top = 214
    Width = 113
    Height = 16
    Caption = 'n - ideality factor'
  end
  object Label11: TLabel
    Left = 8
    Top = 236
    Width = 123
    Height = 16
    Caption = #1060'b - barrier height'
  end
  object Label10: TLabel
    Left = 170
    Top = 192
    Width = 106
    Height = 16
    Caption = 'S - contact area'
  end
  object Label13: TLabel
    Left = 170
    Top = 214
    Width = 164
    Height = 32
    Caption = 'Ar - effective Richardson constant'
    WordWrap = True
  end
  object LEXmin: TLabeledEdit
    Left = 15
    Top = 326
    Width = 121
    Height = 24
    EditLabel.Width = 70
    EditLabel.Height = 16
    EditLabel.Caption = 'X min (>0)'
    TabOrder = 0
  end
  object LEYmin: TLabeledEdit
    Left = 15
    Top = 369
    Width = 121
    Height = 24
    EditLabel.Width = 81
    EditLabel.Height = 16
    EditLabel.Caption = 'Y min (>=0)'
    TabOrder = 1
  end
  object LEYmax: TLabeledEdit
    Left = 199
    Top = 369
    Width = 121
    Height = 24
    EditLabel.Width = 39
    EditLabel.Height = 16
    EditLabel.Caption = 'Y max'
    TabOrder = 3
  end
  object LEXmax: TLabeledEdit
    Left = 199
    Top = 326
    Width = 121
    Height = 24
    EditLabel.Width = 39
    EditLabel.Height = 16
    EditLabel.Caption = 'X max'
    TabOrder = 2
  end
  object Button1: TButton
    Left = 99
    Top = 410
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 4
  end
  object Button2: TButton
    Left = 245
    Top = 410
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

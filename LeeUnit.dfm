object LeeForm: TLeeForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Lee method parameters'
  ClientHeight = 477
  ClientWidth = 432
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
  object Label8: TLabel
    Left = 16
    Top = 323
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
    Width = 81
    Height = 16
    Caption = 'Lee method:'
  end
  object Label2: TLabel
    Left = 24
    Top = 32
    Width = 216
    Height = 16
    Caption = 'the array of function F(I) is build:'
  end
  object Label3: TLabel
    Left = 127
    Top = 54
    Width = 130
    Height = 16
    Caption = 'F(I) = V - Va*ln ( I )'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 8
    Top = 76
    Width = 416
    Height = 16
    Caption = 'where Va ia arbitrary voltage. Each of them is approximated by '
  end
  object Label12: TLabel
    Left = 8
    Top = 186
    Width = 141
    Height = 16
    Caption = 'Rs - series resistance'
  end
  object Label7: TLabel
    Left = 8
    Top = 202
    Width = 113
    Height = 16
    Caption = 'n - ideality factor'
  end
  object Label6: TLabel
    Left = 8
    Top = 120
    Width = 259
    Height = 16
    Caption = 'and parameter Ia=(-C/B) is calculated. '
  end
  object Label9: TLabel
    Left = 116
    Top = 164
    Width = 169
    Height = 16
    Caption = 'Ia = Va / Rs - n k T / e Rs'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label10: TLabel
    Left = 8
    Top = 142
    Width = 304
    Height = 16
    Caption = 'The function (Ia vs Va) linear approximation is:'
  end
  object Label11: TLabel
    Left = 127
    Top = 98
    Width = 141
    Height = 16
    Caption = 'Y = A + B X+ C ln(X),'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label13: TLabel
    Left = 8
    Top = 220
    Width = 237
    Height = 16
    Caption = 'The parameter A is connected to '#1060'b'
  end
  object Label14: TLabel
    Left = 69
    Top = 242
    Width = 260
    Height = 16
    Caption = #1060'b = C / n + ( kT / e ) ln (S * Ar * T^2)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label15: TLabel
    Left = 16
    Top = 286
    Width = 106
    Height = 16
    Caption = 'S - contact area'
  end
  object Label16: TLabel
    Left = 187
    Top = 264
    Width = 164
    Height = 32
    Caption = 'Ar - effective Richardson constant'
    WordWrap = True
  end
  object Label17: TLabel
    Left = 16
    Top = 264
    Width = 123
    Height = 16
    Caption = #1060'b - barrier height'
  end
  object LEXmin: TLabeledEdit
    Left = 58
    Top = 363
    Width = 100
    Height = 24
    EditLabel.Width = 70
    EditLabel.Height = 16
    EditLabel.Caption = 'X min (>0)'
    TabOrder = 0
  end
  object LEYmax: TLabeledEdit
    Left = 251
    Top = 415
    Width = 100
    Height = 24
    EditLabel.Width = 39
    EditLabel.Height = 16
    EditLabel.Caption = 'Y max'
    TabOrder = 3
  end
  object LEYmin: TLabeledEdit
    Left = 58
    Top = 415
    Width = 100
    Height = 24
    EditLabel.Width = 81
    EditLabel.Height = 16
    EditLabel.Caption = 'Y min (>=0)'
    TabOrder = 1
  end
  object LEXmax: TLabeledEdit
    Left = 251
    Top = 363
    Width = 100
    Height = 24
    EditLabel.Width = 39
    EditLabel.Height = 16
    EditLabel.Caption = 'X max'
    TabOrder = 2
  end
  object Button2: TButton
    Left = 335
    Top = 445
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object Button1: TButton
    Left = 152
    Top = 445
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 4
  end
end

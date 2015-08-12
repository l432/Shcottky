object HfuncForm: THfuncForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'H function parameters'
  ClientHeight = 416
  ClientWidth = 331
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
  object Label1: TLabel
    Left = 48
    Top = 16
    Width = 77
    Height = 16
    Caption = 'H-function :'
  end
  object Label2: TLabel
    Left = 24
    Top = 38
    Width = 292
    Height = 16
    Caption = 'H(I) = V - n * (kT/e) * ln [ I /(S * Ar * T^2)]'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 83
    Top = 164
    Width = 120
    Height = 16
    Caption = 'H(I) = I Rs + n '#1060'b'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 40
    Top = 244
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
  object Label9: TLabel
    Left = 16
    Top = 85
    Width = 106
    Height = 16
    Caption = 'S - contact area'
  end
  object Label10: TLabel
    Left = 16
    Top = 107
    Width = 226
    Height = 16
    Caption = 'Ar - effective Richardson constant'
  end
  object Label5: TLabel
    Left = 16
    Top = 64
    Width = 113
    Height = 16
    Caption = 'n - ideality factor'
  end
  object Label6: TLabel
    Left = 40
    Top = 142
    Width = 223
    Height = 16
    Caption = 'H-function linear approximation is:'
  end
  object Label12: TLabel
    Left = 16
    Top = 186
    Width = 141
    Height = 16
    Caption = 'Rs - series resistance'
  end
  object Label11: TLabel
    Left = 16
    Top = 208
    Width = 123
    Height = 16
    Caption = #1060'b - barrier height'
  end
  object Button1: TButton
    Left = 128
    Top = 383
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 241
    Top = 383
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object LEYmin: TLabeledEdit
    Left = 23
    Top = 343
    Width = 121
    Height = 24
    EditLabel.Width = 81
    EditLabel.Height = 16
    EditLabel.Caption = 'Y min (>=0)'
    TabOrder = 3
  end
  object LEXmin: TLabeledEdit
    Left = 23
    Top = 286
    Width = 121
    Height = 24
    EditLabel.Width = 70
    EditLabel.Height = 16
    EditLabel.Caption = 'X min (>0)'
    TabOrder = 2
  end
  object LEXmax: TLabeledEdit
    Left = 179
    Top = 286
    Width = 121
    Height = 24
    EditLabel.Width = 39
    EditLabel.Height = 16
    EditLabel.Caption = 'X max'
    TabOrder = 4
  end
  object LEYmax: TLabeledEdit
    Left = 179
    Top = 343
    Width = 121
    Height = 24
    EditLabel.Width = 39
    EditLabel.Height = 16
    EditLabel.Caption = 'Y max'
    TabOrder = 5
  end
end

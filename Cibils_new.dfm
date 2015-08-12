object CibilsForm: TCibilsForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Cibils method parameters'
  ClientHeight = 415
  ClientWidth = 410
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
    Left = 8
    Top = 259
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
    Width = 90
    Height = 16
    Caption = 'Cibils method:'
  end
  object Label2: TLabel
    Left = 24
    Top = 32
    Width = 220
    Height = 16
    Caption = 'the array of function F(V) is build:'
  end
  object Label3: TLabel
    Left = 127
    Top = 54
    Width = 134
    Height = 16
    Caption = 'F(V) = V - Va*ln ( I )'
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
    Width = 375
    Height = 16
    Caption = 'where Va ia arbitrary voltage, Va > 99.5 I0 Rs + k T n / e'
  end
  object Label5: TLabel
    Left = 8
    Top = 98
    Width = 148
    Height = 16
    Caption = 'I0 - saturation current'
  end
  object Label12: TLabel
    Left = 8
    Top = 120
    Width = 141
    Height = 16
    Caption = 'Rs - series resistance'
  end
  object Label7: TLabel
    Left = 8
    Top = 142
    Width = 113
    Height = 16
    Caption = 'n - ideality factor'
  end
  object Label6: TLabel
    Left = 24
    Top = 164
    Width = 334
    Height = 16
    Caption = 'Ia at the minimum point of each F(V) is defined and '
  end
  object Label9: TLabel
    Left = 116
    Top = 214
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
    Top = 186
    Width = 281
    Height = 16
    Caption = 'function (Ia vs Va)  linear approximation is:'
  end
  object LEXmin: TLabeledEdit
    Left = 29
    Top = 299
    Width = 100
    Height = 24
    EditLabel.Width = 70
    EditLabel.Height = 16
    EditLabel.Caption = 'X min (>0)'
    TabOrder = 0
  end
  object LEYmax: TLabeledEdit
    Left = 221
    Top = 351
    Width = 100
    Height = 24
    EditLabel.Width = 39
    EditLabel.Height = 16
    EditLabel.Caption = 'Y max'
    TabOrder = 3
  end
  object LEYmin: TLabeledEdit
    Left = 29
    Top = 351
    Width = 100
    Height = 24
    EditLabel.Width = 81
    EditLabel.Height = 16
    EditLabel.Caption = 'Y min (>=0)'
    TabOrder = 1
  end
  object LEXmax: TLabeledEdit
    Left = 221
    Top = 299
    Width = 100
    Height = 24
    EditLabel.Width = 39
    EditLabel.Height = 16
    EditLabel.Caption = 'X max'
    TabOrder = 2
  end
  object Button2: TButton
    Left = 327
    Top = 381
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object Button1: TButton
    Left = 144
    Top = 381
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 4
  end
end

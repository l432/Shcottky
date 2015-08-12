object CibilsForm: TCibilsForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Cibils method parameters'
  ClientHeight = 493
  ClientWidth = 487
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 19
  object Label8: TLabel
    Left = 10
    Top = 308
    Width = 188
    Height = 21
    Caption = 'Range for calculation:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 10
    Top = 10
    Width = 117
    Height = 19
    Caption = 'Cibils method:'
  end
  object Label2: TLabel
    Left = 29
    Top = 38
    Width = 275
    Height = 19
    Caption = 'the array of function F(V) is build:'
  end
  object Label3: TLabel
    Left = 151
    Top = 64
    Width = 176
    Height = 21
    Caption = 'F(V) = V - Va*ln ( I )'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 10
    Top = 91
    Width = 469
    Height = 19
    Caption = 'where Va ia arbitrary voltage, Va > 99.5 I0 Rs + k T n / e'
  end
  object Label5: TLabel
    Left = 10
    Top = 116
    Width = 182
    Height = 19
    Caption = 'I0 - saturation current'
  end
  object Label12: TLabel
    Left = 10
    Top = 143
    Width = 173
    Height = 19
    Caption = 'Rs - series resistance'
  end
  object Label7: TLabel
    Left = 10
    Top = 169
    Width = 141
    Height = 19
    Caption = 'n - ideality factor'
  end
  object Label6: TLabel
    Left = 29
    Top = 195
    Width = 425
    Height = 19
    Caption = 'Ia at the minimum point of each F(V) is defined and '
  end
  object Label9: TLabel
    Left = 138
    Top = 254
    Width = 218
    Height = 21
    Caption = 'Ia = Va / Rs - n k T / e Rs'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label10: TLabel
    Left = 10
    Top = 221
    Width = 355
    Height = 19
    Caption = 'function (Ia vs Va)  linear approximation is:'
  end
  object LEXmin: TLabeledEdit
    Left = 34
    Top = 355
    Width = 119
    Height = 27
    EditLabel.Width = 88
    EditLabel.Height = 19
    EditLabel.Caption = 'X min (>0)'
    TabOrder = 0
  end
  object LEYmax: TLabeledEdit
    Left = 262
    Top = 417
    Width = 119
    Height = 27
    EditLabel.Width = 51
    EditLabel.Height = 19
    EditLabel.Caption = 'Y max'
    TabOrder = 3
  end
  object LEYmin: TLabeledEdit
    Left = 34
    Top = 417
    Width = 119
    Height = 27
    EditLabel.Width = 101
    EditLabel.Height = 19
    EditLabel.Caption = 'Y min (>=0)'
    TabOrder = 1
  end
  object LEXmax: TLabeledEdit
    Left = 262
    Top = 355
    Width = 119
    Height = 27
    EditLabel.Width = 51
    EditLabel.Height = 19
    EditLabel.Caption = 'X max'
    TabOrder = 2
  end
  object Button2: TButton
    Left = 388
    Top = 452
    Width = 89
    Height = 30
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object Button1: TButton
    Left = 171
    Top = 452
    Width = 89
    Height = 30
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 4
  end
end

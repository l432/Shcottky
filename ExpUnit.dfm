object ExpForm: TExpForm
  Left = 0
  Top = 0
  BiDiMode = bdLeftToRight
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'I=I0[exp(e(V-IRs)/nkT)-1]+(V-IRs)/Rsh - Iph parameters'
  ClientHeight = 457
  ClientWidth = 378
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  KeyPreview = True
  OldCreateOrder = False
  ParentBiDiMode = False
  Position = poMainFormCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label4: TLabel
    Left = 9
    Top = 294
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
  object Label5: TLabel
    Left = 36
    Top = 8
    Width = 114
    Height = 16
    Caption = 'Approximation by'
  end
  object Label6: TLabel
    Left = 36
    Top = 30
    Width = 306
    Height = 16
    Caption = 'I=I0[exp(e(V-IRs)/nkT)-1]+(V-IRs)/Rsh - Iph '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 10
    Top = 54
    Width = 113
    Height = 16
    Caption = 'n - ideality factor'
  end
  object Label8: TLabel
    Left = 10
    Top = 76
    Width = 148
    Height = 16
    Caption = 'I0 - saturation current'
  end
  object Label9: TLabel
    Left = 97
    Top = 98
    Width = 184
    Height = 16
    Caption = 'I0 =S Ar (T^2) exp(-'#1060'b/kT)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label10: TLabel
    Left = 10
    Top = 120
    Width = 106
    Height = 16
    Caption = 'S - contact area'
  end
  object Label11: TLabel
    Left = 8
    Top = 142
    Width = 226
    Height = 16
    Caption = 'Ar - effective Richardson constant'
  end
  object Label12: TLabel
    Left = 8
    Top = 164
    Width = 123
    Height = 16
    Caption = #1060'b - barrier height'
  end
  object Label13: TLabel
    Left = 8
    Top = 186
    Width = 141
    Height = 16
    Caption = 'Rs - series resistance'
  end
  object Label14: TLabel
    Left = 8
    Top = 208
    Width = 147
    Height = 16
    Caption = 'Rsh - shunt resistance'
  end
  object Label15: TLabel
    Left = 8
    Top = 230
    Width = 122
    Height = 16
    Caption = 'Iph - photocurrent'
  end
  object Label1: TLabel
    Left = 8
    Top = 264
    Width = 279
    Height = 16
    Caption = 'The direct least squared technique is used '
  end
  object Button1: TButton
    Left = 137
    Top = 419
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 294
    Top = 419
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object LEXmin: TLabeledEdit
    Left = 9
    Top = 336
    Width = 121
    Height = 24
    EditLabel.Width = 70
    EditLabel.Height = 16
    EditLabel.Caption = 'X min (>0)'
    TabOrder = 2
  end
  object LEYmin: TLabeledEdit
    Left = 9
    Top = 386
    Width = 121
    Height = 24
    EditLabel.Width = 81
    EditLabel.Height = 16
    EditLabel.Caption = 'Y min (>=0)'
    TabOrder = 3
  end
  object LEXmax: TLabeledEdit
    Left = 221
    Top = 336
    Width = 121
    Height = 24
    EditLabel.Width = 39
    EditLabel.Height = 16
    EditLabel.Caption = 'X max'
    TabOrder = 4
  end
  object LEYmax: TLabeledEdit
    Left = 221
    Top = 386
    Width = 121
    Height = 24
    EditLabel.Width = 39
    EditLabel.Height = 16
    EditLabel.Caption = 'Y max'
    TabOrder = 5
  end
  object CB_Rs: TCheckBox
    Left = 208
    Top = 186
    Width = 97
    Height = 17
    Caption = 'Vary'
    TabOrder = 6
  end
  object CB_Rsh: TCheckBox
    Left = 208
    Top = 208
    Width = 97
    Height = 17
    Caption = 'Vary'
    TabOrder = 7
  end
  object CB_Iph: TCheckBox
    Left = 208
    Top = 231
    Width = 97
    Height = 17
    Caption = 'Vary'
    TabOrder = 8
  end
end

object DEForm: TDEForm
  Left = 0
  Top = 0
  BiDiMode = bdLeftToRight
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Optimization algorithm  parameters'
  ClientHeight = 424
  ClientWidth = 620
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  KeyPreview = True
  OldCreateOrder = False
  ParentBiDiMode = False
  Position = poMainFormCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 19
  object Label4: TLabel
    Left = 11
    Top = 264
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
  object Label5: TLabel
    Left = 20
    Top = 10
    Width = 145
    Height = 19
    Caption = 'Approximation by'
  end
  object Label6: TLabel
    Left = 100
    Top = 36
    Width = 407
    Height = 21
    Caption = 'I=I0[exp(e(V-IRs)/nkT)-1]+(V-IRs)/Rsh - Iph '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 10
    Top = 116
    Width = 141
    Height = 19
    Caption = 'n - ideality factor'
  end
  object Label8: TLabel
    Left = 10
    Top = 143
    Width = 182
    Height = 19
    Caption = 'I0 - saturation current'
  end
  object Label9: TLabel
    Left = 10
    Top = 88
    Width = 674
    Height = 21
    Caption = 
      'I=I01[exp(e(V-IRs)/n1kT)-1]+I02[exp(e(V-IRs)/n2kT)-1]+(V-IRs)/Rs' +
      'h - Iph'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label10: TLabel
    Left = 262
    Top = 62
    Width = 17
    Height = 19
    Caption = 'or'
  end
  object Label13: TLabel
    Left = 296
    Top = 119
    Width = 173
    Height = 19
    Caption = 'Rs - series resistance'
  end
  object Label14: TLabel
    Left = 296
    Top = 145
    Width = 180
    Height = 19
    Caption = 'Rsh - shunt resistance'
  end
  object Label15: TLabel
    Left = 296
    Top = 171
    Width = 150
    Height = 19
    Caption = 'Iph - photocurrent'
  end
  object Button1: TButton
    Left = 494
    Top = 373
    Width = 89
    Height = 30
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 494
    Top = 314
    Width = 89
    Height = 29
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object LEXmin: TLabeledEdit
    Left = 11
    Top = 314
    Width = 143
    Height = 24
    EditLabel.Width = 88
    EditLabel.Height = 19
    EditLabel.Caption = 'X min (>0)'
    TabOrder = 2
  end
  object LEYmin: TLabeledEdit
    Left = 11
    Top = 373
    Width = 143
    Height = 24
    EditLabel.Width = 101
    EditLabel.Height = 19
    EditLabel.Caption = 'Y min (>=0)'
    TabOrder = 3
  end
  object LEXmax: TLabeledEdit
    Left = 262
    Top = 314
    Width = 144
    Height = 24
    EditLabel.Width = 51
    EditLabel.Height = 19
    EditLabel.Caption = 'X max'
    TabOrder = 4
  end
  object LEYmax: TLabeledEdit
    Left = 262
    Top = 373
    Width = 144
    Height = 24
    EditLabel.Width = 51
    EditLabel.Height = 19
    EditLabel.Caption = 'Y max'
    TabOrder = 5
  end
  object CB_Rs: TCheckBox
    Left = 494
    Top = 118
    Width = 115
    Height = 20
    Caption = 'Vary'
    TabOrder = 6
  end
  object CB_Rsh: TCheckBox
    Left = 494
    Top = 144
    Width = 115
    Height = 20
    Caption = 'Vary'
    TabOrder = 7
  end
  object CB_Iph: TCheckBox
    Left = 494
    Top = 171
    Width = 115
    Height = 20
    Caption = 'Vary'
    TabOrder = 8
  end
  object RG: TRadioGroup
    Left = 48
    Top = 196
    Width = 523
    Height = 49
    Caption = 'Method'
    Columns = 4
    ItemIndex = 0
    Items.Strings = (
      'DE'
      'MABC'
      'TLBO'
      'PSO')
    TabOrder = 9
  end
end

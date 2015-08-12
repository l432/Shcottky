object LambForm: TLambForm
  Left = 0
  Top = 0
  BiDiMode = bdLeftToRight
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Lambert approximation parameters'
  ClientHeight = 500
  ClientWidth = 388
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
    Left = 8
    Top = 342
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
    Left = 4
    Top = 254
    Width = 383
    Height = 16
    Caption = 'The I-V characterictic is approximated by Lambert function'
  end
  object Label2: TLabel
    Left = 8
    Top = 276
    Width = 255
    Height = 16
    Caption = 'See Mat.Sci.Eng. B, 165, p57 (dark) and'
  end
  object Label3: TLabel
    Left = 30
    Top = 292
    Width = 251
    Height = 16
    Caption = ' J.Appl.Phys, 110, 064504 (illuminated)'
  end
  object Label16: TLabel
    Left = 8
    Top = 310
    Width = 275
    Height = 16
    Caption = 'Then the  least squared technique is used '
  end
  object Button1: TButton
    Left = 136
    Top = 467
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 293
    Top = 467
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object LEXmin: TLabeledEdit
    Left = 8
    Top = 384
    Width = 121
    Height = 24
    EditLabel.Width = 70
    EditLabel.Height = 16
    EditLabel.Caption = 'X min (>0)'
    TabOrder = 2
  end
  object LEYmin: TLabeledEdit
    Left = 8
    Top = 434
    Width = 121
    Height = 24
    EditLabel.Width = 81
    EditLabel.Height = 16
    EditLabel.Caption = 'Y min (>=0)'
    TabOrder = 3
  end
  object LEXmax: TLabeledEdit
    Left = 220
    Top = 384
    Width = 121
    Height = 24
    EditLabel.Width = 39
    EditLabel.Height = 16
    EditLabel.Caption = 'X max'
    TabOrder = 4
  end
  object LEYmax: TLabeledEdit
    Left = 220
    Top = 434
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

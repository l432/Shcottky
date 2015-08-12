object BohlinForm: TBohlinForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Bohlin'#39's method parameters'
  ClientHeight = 612
  ClientWidth = 633
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
  object Label16: TLabel
    Left = 135
    Top = 200
    Width = 286
    Height = 21
    Caption = '__________________________'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 10
    Top = 10
    Width = 136
    Height = 19
    Caption = 'Bohlin'#39's method:'
  end
  object Label2: TLabel
    Left = 56
    Top = 33
    Width = 470
    Height = 21
    Caption = 'F1(V) =( V/gamma1) -  (kT/e) * ln [ I /(S * Ar * T^2)]'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 25
    Top = 173
    Width = 543
    Height = 19
    Caption = 
      'if minimum of functions F(V) is observed at V1min and V2min, the' +
      'n'
  end
  object Label4: TLabel
    Left = 25
    Top = 138
    Width = 325
    Height = 19
    Caption = 'parameter gamma must be more then n'
  end
  object Label5: TLabel
    Left = 6
    Top = 387
    Width = 597
    Height = 21
    Caption = #1060'b = F1(Vmin1) +(1/n - 1/gamma1)*Vmin1 -  (gamma1- n)* k T/n e'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 140
    Top = 321
    Width = 280
    Height = 21
    Caption = 'Rs = k T (gamma1 - n)/(e*Imin)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 25
    Top = 495
    Width = 110
    Height = 21
    Caption = 'Input  value:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label9: TLabel
    Left = 25
    Top = 91
    Width = 129
    Height = 19
    Caption = 'S - contact area'
  end
  object Label10: TLabel
    Left = 25
    Top = 116
    Width = 277
    Height = 19
    Caption = 'Ar - effective Richardson constant'
  end
  object Label11: TLabel
    Left = 385
    Top = 456
    Width = 153
    Height = 19
    Caption = #1060'b - barrier height'
  end
  object Label12: TLabel
    Left = 190
    Top = 456
    Width = 173
    Height = 19
    Caption = 'Rs - series resistance'
  end
  object Label8: TLabel
    Left = 152
    Top = 10
    Width = 229
    Height = 19
    Caption = 'two Norde'#39's function builde:'
  end
  object Label13: TLabel
    Left = 56
    Top = 59
    Width = 470
    Height = 21
    Caption = 'F2(V) =( V/gamma2) -  (kT/e) * ln [ I /(S * Ar * T^2)]'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label14: TLabel
    Left = 96
    Top = 208
    Width = 35
    Height = 21
    Caption = 'n = '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label15: TLabel
    Left = 134
    Top = 196
    Width = 289
    Height = 21
    Caption = 'gamma1*Imin2 - gamma1*Imin2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label17: TLabel
    Left = 211
    Top = 222
    Width = 119
    Height = 21
    Caption = 'Imin2 - Imin1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label18: TLabel
    Left = 15
    Top = 264
    Width = 35
    Height = 21
    Caption = 'n = '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label19: TLabel
    Left = 50
    Top = 278
    Width = 531
    Height = 21
    Caption = 'F2(Vmin2) - F1(Vmin1) - Vmin2 / gamma2 + Vmin1 /gamma1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label20: TLabel
    Left = 50
    Top = 255
    Width = 539
    Height = 21
    Caption = '_________________________________________________'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label21: TLabel
    Left = 89
    Top = 252
    Width = 390
    Height = 21
    Caption = 'Vmin1 - Vmin2 + (gamma2 - gamma1) k T / e'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label22: TLabel
    Left = 140
    Top = 347
    Width = 280
    Height = 21
    Caption = 'Rs = k T (gamma2 - n)/(e*Imin)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label23: TLabel
    Left = 6
    Top = 413
    Width = 597
    Height = 21
    Caption = #1060'b = F2(Vmin2) +(1/n - 1/gamma2)*Vmin2 -  (gamma2- n)* k T/n e'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label24: TLabel
    Left = 25
    Top = 456
    Width = 141
    Height = 19
    Caption = 'n - ideality factor'
  end
  object Label25: TLabel
    Left = 56
    Top = 525
    Width = 88
    Height = 19
    Caption = 'gamma1 ='
  end
  object Label26: TLabel
    Left = 312
    Top = 525
    Width = 88
    Height = 19
    Caption = 'gamma2 ='
  end
  object Button2: TButton
    Left = 412
    Top = 570
    Width = 89
    Height = 30
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object Button1: TButton
    Left = 190
    Top = 570
    Width = 89
    Height = 30
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 2
  end
  object EditGamma1: TEdit
    Left = 140
    Top = 521
    Width = 69
    Height = 27
    TabOrder = 0
    Text = 'EditGamma1'
  end
  object EditGamma2: TEdit
    Left = 397
    Top = 521
    Width = 69
    Height = 27
    TabOrder = 1
    Text = 'EditGamma1'
  end
end

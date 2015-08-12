object NordForm: TNordForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Norde'#39's function parameters'
  ClientHeight = 588
  ClientWidth = 494
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
  object Label1: TLabel
    Left = 10
    Top = 19
    Width = 138
    Height = 19
    Caption = 'Norde'#39's function:'
  end
  object Label2: TLabel
    Left = 46
    Top = 46
    Width = 448
    Height = 21
    Caption = 'F(V) =( V/gamma) -  (kT/e) * ln [ I /(S * Ar * T^2)]'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 18
    Top = 216
    Width = 434
    Height = 19
    Caption = 'if minimum of function F(V) is observed at Vmin, then'
  end
  object Label4: TLabel
    Left = 15
    Top = 124
    Width = 488
    Height = 19
    Caption = 'parameter gamma must be more then n,   gamma = 2, 3, ... '
  end
  object Label5: TLabel
    Left = 99
    Top = 252
    Width = 343
    Height = 21
    Caption = #1060'b = F(Vmin) + (Vmin/gamma) -(kT/e)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 99
    Top = 278
    Width = 269
    Height = 21
    Caption = 'Rs = k T (gamma - n)/(e*Imin)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 72
    Top = 158
    Width = 187
    Height = 21
    Caption = 'Input gamma'#39's value:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 10
    Top = 393
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
  object Label9: TLabel
    Left = 15
    Top = 72
    Width = 129
    Height = 19
    Caption = 'S - contact area'
  end
  object Label10: TLabel
    Left = 15
    Top = 97
    Width = 277
    Height = 19
    Caption = 'Ar - effective Richardson constant'
  end
  object Label11: TLabel
    Left = 34
    Top = 314
    Width = 153
    Height = 19
    Caption = #1060'b - barrier height'
  end
  object Label12: TLabel
    Left = 34
    Top = 340
    Width = 173
    Height = 19
    Caption = 'Rs - series resistance'
  end
  object Button1: TButton
    Left = 171
    Top = 546
    Width = 89
    Height = 30
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 5
  end
  object Button2: TButton
    Left = 393
    Top = 546
    Width = 89
    Height = 30
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object EditGamma: TEdit
    Left = 255
    Top = 158
    Width = 69
    Height = 27
    TabOrder = 0
    Text = 'EditGamma'
  end
  object LEXmax: TLabeledEdit
    Left = 262
    Top = 441
    Width = 119
    Height = 27
    EditLabel.Width = 51
    EditLabel.Height = 19
    EditLabel.Caption = 'X max'
    TabOrder = 3
  end
  object LEYmin: TLabeledEdit
    Left = 34
    Top = 502
    Width = 119
    Height = 27
    EditLabel.Width = 101
    EditLabel.Height = 19
    EditLabel.Caption = 'Y min (>=0)'
    TabOrder = 2
  end
  object LEXmin: TLabeledEdit
    Left = 34
    Top = 441
    Width = 119
    Height = 27
    EditLabel.Width = 88
    EditLabel.Height = 19
    EditLabel.Caption = 'X min (>0)'
    TabOrder = 1
  end
  object LEYmax: TLabeledEdit
    Left = 262
    Top = 502
    Width = 119
    Height = 27
    EditLabel.Width = 51
    EditLabel.Height = 19
    EditLabel.Caption = 'Y max'
    TabOrder = 4
  end
end

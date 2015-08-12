object MikhelashviliForm: TMikhelashviliForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Mikhelashvili'#39's method parameters'
  ClientHeight = 566
  ClientWidth = 580
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
  object Label4: TLabel
    Left = 40
    Top = 371
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
  object Label7: TLabel
    Left = 83
    Top = 204
    Width = 428
    Height = 21
    Caption = 'n=e Vmin [Alpha (Vmin) - 1] / k T Alpha(Vmin)^2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 151
    Top = 36
    Width = 266
    Height = 21
    Caption = 'Alpha (V) = d( ln I) / d( ln V)  ;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 30
    Top = 10
    Width = 208
    Height = 19
    Caption = 'Mikhelashvili'#39's functions :'
  end
  object Label3: TLabel
    Left = 132
    Top = 62
    Width = 304
    Height = 21
    Caption = 'Betta (V) = d( ln Alpha) / d( ln V)  ;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 31
    Top = 88
    Width = 541
    Height = 21
    Caption = 
      'n (V) = e V (Alpha - 1) [1 + Betta / (Alpha - 1)] / k T Alpha^2 ' +
      ';'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 125
    Top = 114
    Width = 285
    Height = 21
    Caption = 'Rs (V) = V (1- Betta) / I Alpha^2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 23
    Top = 140
    Width = 141
    Height = 19
    Caption = 'n - ideality factor'
  end
  object Label12: TLabel
    Left = 219
    Top = 140
    Width = 173
    Height = 19
    Caption = 'Rs - series resistance'
  end
  object Label9: TLabel
    Left = 10
    Top = 178
    Width = 472
    Height = 19
    Caption = 'if minimum of function Alpha(V) is observed at Vmin, then'
  end
  object Label10: TLabel
    Left = 151
    Top = 230
    Width = 286
    Height = 21
    Caption = 'Rs = Vmin / Imin Alpha(Vmin)^2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label11: TLabel
    Left = 160
    Top = 257
    Width = 273
    Height = 21
    Caption = 'I0 = Imin exp [-Alpha(Vmin)-1]'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label13: TLabel
    Left = 83
    Top = 283
    Width = 477
    Height = 21
    Caption = #1060'b = k T { Alpha(Vmin)+1- ln [ Imin /(S * Ar * T^2)] }'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label14: TLabel
    Left = 10
    Top = 304
    Width = 153
    Height = 19
    Caption = #1060'b - barrier height'
  end
  object Label15: TLabel
    Left = 190
    Top = 304
    Width = 182
    Height = 19
    Caption = 'I0 - saturation current'
  end
  object Label16: TLabel
    Left = 190
    Top = 330
    Width = 277
    Height = 19
    Caption = 'Ar - effective Richardson constant'
  end
  object Label17: TLabel
    Left = 10
    Top = 331
    Width = 129
    Height = 19
    Caption = 'S - contact area'
  end
  object Button2: TButton
    Left = 444
    Top = 527
    Width = 89
    Height = 30
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object Button1: TButton
    Left = 235
    Top = 527
    Width = 89
    Height = 30
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 4
  end
  object LEXmin: TLabeledEdit
    Left = 53
    Top = 418
    Width = 144
    Height = 27
    EditLabel.Width = 88
    EditLabel.Height = 19
    EditLabel.Caption = 'X min (>0)'
    TabOrder = 0
  end
  object LEYmax: TLabeledEdit
    Left = 321
    Top = 483
    Width = 143
    Height = 27
    EditLabel.Width = 51
    EditLabel.Height = 19
    EditLabel.Caption = 'Y max'
    TabOrder = 3
  end
  object LEYmin: TLabeledEdit
    Left = 53
    Top = 483
    Width = 144
    Height = 27
    EditLabel.Width = 101
    EditLabel.Height = 19
    EditLabel.Caption = 'Y min (>=0)'
    TabOrder = 1
  end
  object LEXmax: TLabeledEdit
    Left = 321
    Top = 418
    Width = 143
    Height = 27
    EditLabel.Width = 51
    EditLabel.Height = 19
    EditLabel.Caption = 'X max'
    TabOrder = 2
  end
end

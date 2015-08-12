object Kam1Form: TKam1Form
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Kaminski function I parameters'
  ClientHeight = 437
  ClientWidth = 386
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
    Left = 77
    Top = 34
    Width = 64
    Height = 16
    Caption = '________'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label12: TLabel
    Left = 8
    Top = 268
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
    Width = 126
    Height = 16
    Caption = 'Kaminski function I:'
  end
  object Label2: TLabel
    Left = 134
    Top = 182
    Width = 110
    Height = 16
    Caption = 'Y = n k T + Rs X '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 9
    Top = 226
    Width = 113
    Height = 16
    Caption = 'n - ideality factor'
  end
  object Label3: TLabel
    Left = 9
    Top = 204
    Width = 141
    Height = 16
    Caption = 'Rs - series resistance'
  end
  object Label4: TLabel
    Left = 100
    Top = 30
    Width = 12
    Height = 16
    Caption = '1 '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 50
    Top = 40
    Width = 24
    Height = 16
    Caption = 'Y= '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label9: TLabel
    Left = 77
    Top = 52
    Width = 60
    Height = 16
    Caption = '( Ia - Ib )'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label11: TLabel
    Left = 239
    Top = 40
    Width = 24
    Height = 16
    Caption = 'X= '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label13: TLabel
    Left = 266
    Top = 34
    Width = 64
    Height = 16
    Caption = '________'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label14: TLabel
    Left = 297
    Top = 51
    Width = 8
    Height = 16
    Caption = '2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 8
    Top = 80
    Width = 169
    Height = 16
    Caption = 'for set  { Vi ,  Ii }   i=1..N :'
  end
  object Label15: TLabel
    Left = 90
    Top = 102
    Width = 85
    Height = 16
    Caption = 'Ia= Ij,   j=N ;'
  end
  object Label16: TLabel
    Left = 210
    Top = 102
    Width = 142
    Height = 16
    Caption = 'Ib={ Ik },   k=1..(N-1)'
  end
  object Label17: TLabel
    Left = 8
    Top = 124
    Width = 236
    Height = 16
    Caption = 'The total number of points is  (N-1) .'
  end
  object Label18: TLabel
    Left = 8
    Top = 160
    Width = 281
    Height = 16
    Caption = 'Kaminski function II linear approximation is:'
  end
  object Label19: TLabel
    Left = 149
    Top = 40
    Width = 38
    Height = 16
    Caption = '/ I dV'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label20: TLabel
    Left = 147
    Top = 31
    Width = 14
    Height = 13
    Caption = 'Va'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label21: TLabel
    Left = 147
    Top = 56
    Width = 14
    Height = 13
    Caption = 'Vb'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label10: TLabel
    Left = 266
    Top = 29
    Width = 73
    Height = 16
    Caption = ' ( Ia + Ib ) '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LEYmax: TLabeledEdit
    Left = 218
    Top = 366
    Width = 121
    Height = 24
    EditLabel.Width = 39
    EditLabel.Height = 16
    EditLabel.Caption = 'Y max'
    TabOrder = 5
  end
  object LEXmax: TLabeledEdit
    Left = 218
    Top = 310
    Width = 121
    Height = 24
    EditLabel.Width = 39
    EditLabel.Height = 16
    EditLabel.Caption = 'X max'
    TabOrder = 4
  end
  object LEYmin: TLabeledEdit
    Left = 15
    Top = 366
    Width = 121
    Height = 24
    EditLabel.Width = 81
    EditLabel.Height = 16
    EditLabel.Caption = 'Y min (>=0)'
    TabOrder = 3
  end
  object LEXmin: TLabeledEdit
    Left = 15
    Top = 310
    Width = 121
    Height = 24
    EditLabel.Width = 70
    EditLabel.Height = 16
    EditLabel.Caption = 'X min (>0)'
    TabOrder = 2
  end
  object Button2: TButton
    Left = 297
    Top = 402
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ModalResult = 2
    ParentFont = False
    TabOrder = 1
  end
  object Button1: TButton
    Left = 134
    Top = 402
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 0
  end
end

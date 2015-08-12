object Kam2Form: TKam2Form
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Kaminski function II parameters'
  ClientHeight = 439
  ClientWidth = 410
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label8: TLabel
    Left = 101
    Top = 40
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
    Width = 131
    Height = 16
    Caption = 'Kaminski function II:'
  end
  object Label2: TLabel
    Left = 144
    Top = 182
    Width = 136
    Height = 16
    Caption = 'Y = ( -Rs + X ) / nkT'
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
    Left = 101
    Top = 35
    Width = 85
    Height = 16
    Caption = 'ln  ( Ia / Ib ) '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 74
    Top = 46
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
    Left = 108
    Top = 58
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
    Left = 247
    Top = 46
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
    Left = 274
    Top = 40
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
    Left = 281
    Top = 58
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
  object Label6: TLabel
    Left = 8
    Top = 80
    Width = 169
    Height = 16
    Caption = 'for set  { Vi ,  Ii }   i=1..N :'
  end
  object Label15: TLabel
    Left = 74
    Top = 102
    Width = 145
    Height = 16
    Caption = 'Ib={ Ij },   j=1..(N-1) ;'
  end
  object Label16: TLabel
    Left = 247
    Top = 102
    Width = 143
    Height = 16
    Caption = 'Ia={ Ik },   k=(j+1)..N'
  end
  object Label17: TLabel
    Left = 8
    Top = 124
    Width = 280
    Height = 16
    Caption = 'The total number of points is    N (N-1) / 2 .'
  end
  object Label18: TLabel
    Left = 8
    Top = 160
    Width = 281
    Height = 16
    Caption = 'Kaminski function II linear approximation is:'
  end
  object Label10: TLabel
    Left = 274
    Top = 35
    Width = 76
    Height = 16
    Caption = ' ( Va - Vb ) '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LEYmax: TLabeledEdit
    Left = 255
    Top = 366
    Width = 121
    Height = 24
    EditLabel.Width = 39
    EditLabel.Height = 16
    EditLabel.Caption = 'Y max'
    TabOrder = 3
  end
  object LEXmax: TLabeledEdit
    Left = 255
    Top = 310
    Width = 121
    Height = 24
    EditLabel.Width = 39
    EditLabel.Height = 16
    EditLabel.Caption = 'X max'
    TabOrder = 2
  end
  object LEYmin: TLabeledEdit
    Left = 15
    Top = 366
    Width = 121
    Height = 24
    EditLabel.Width = 81
    EditLabel.Height = 16
    EditLabel.Caption = 'Y min (>=0)'
    TabOrder = 1
  end
  object LEXmin: TLabeledEdit
    Left = 15
    Top = 310
    Width = 121
    Height = 24
    EditLabel.Width = 70
    EditLabel.Height = 16
    EditLabel.Caption = 'X min (>0)'
    TabOrder = 0
  end
  object Button2: TButton
    Left = 317
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
    TabOrder = 5
  end
  object Button1: TButton
    Left = 171
    Top = 402
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 4
  end
end

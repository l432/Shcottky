object ChungForm: TChungForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Cheung'#39's function parameters'
  ClientHeight = 328
  ClientWidth = 318
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
  object Label1: TLabel
    Left = 25
    Top = 8
    Width = 125
    Height = 16
    Caption = 'Cheung'#39's function :'
  end
  object Label2: TLabel
    Left = 87
    Top = 30
    Width = 109
    Height = 16
    Caption = 'C(I) = dV/d(lnI) '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 73
    Top = 84
    Width = 142
    Height = 16
    Caption = 'C(I) = I Rs + n (kT/e)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 8
    Top = 168
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
  object Label6: TLabel
    Left = 25
    Top = 62
    Width = 271
    Height = 16
    Caption = 'Cheung'#39's function linear approximation is:'
  end
  object Label12: TLabel
    Left = 8
    Top = 114
    Width = 141
    Height = 16
    Caption = 'Rs - series resistance'
  end
  object Label5: TLabel
    Left = 8
    Top = 136
    Width = 113
    Height = 16
    Caption = 'n - ideality factor'
  end
  object Button1: TButton
    Left = 121
    Top = 293
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 233
    Top = 293
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object LEXmin: TLabeledEdit
    Left = 19
    Top = 208
    Width = 121
    Height = 24
    EditLabel.Width = 70
    EditLabel.Height = 16
    EditLabel.Caption = 'X min (>0)'
    TabOrder = 2
  end
  object LEXmax: TLabeledEdit
    Left = 178
    Top = 208
    Width = 121
    Height = 24
    EditLabel.Width = 39
    EditLabel.Height = 16
    EditLabel.Caption = 'X max'
    TabOrder = 4
  end
  object LEYmax: TLabeledEdit
    Left = 178
    Top = 263
    Width = 121
    Height = 24
    EditLabel.Width = 39
    EditLabel.Height = 16
    EditLabel.Caption = 'Y max'
    TabOrder = 5
  end
  object LEYmin: TLabeledEdit
    Left = 19
    Top = 263
    Width = 121
    Height = 24
    EditLabel.Width = 81
    EditLabel.Height = 16
    EditLabel.Caption = 'Y min (>=0)'
    TabOrder = 3
  end
end

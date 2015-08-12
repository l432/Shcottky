object ExForm: TExForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'I = I0 exp(eV/nkT)  parameters'
  ClientHeight = 422
  ClientWidth = 338
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
    Left = 64
    Top = 36
    Width = 165
    Height = 21
    Caption = 'I = I0 exp(eV/nkT)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 10
    Top = 232
    Width = 225
    Height = 21
    Caption = 'Range for approximation :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 10
    Top = 64
    Width = 141
    Height = 19
    Caption = 'n - ideality factor'
  end
  object Label3: TLabel
    Left = 51
    Top = 10
    Width = 145
    Height = 19
    Caption = 'Approximation by'
  end
  object Label4: TLabel
    Left = 10
    Top = 90
    Width = 182
    Height = 19
    Caption = 'I0 - saturation current'
  end
  object Label7: TLabel
    Left = 57
    Top = 116
    Width = 244
    Height = 21
    Caption = 'I0 =S Ar (T^2) exp(-'#1060'b/kT)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label9: TLabel
    Left = 10
    Top = 143
    Width = 129
    Height = 19
    Caption = 'S - contact area'
  end
  object Label10: TLabel
    Left = 7
    Top = 169
    Width = 277
    Height = 19
    Caption = 'Ar - effective Richardson constant'
  end
  object Label11: TLabel
    Left = 10
    Top = 195
    Width = 153
    Height = 19
    Caption = #1060'b - barrier height'
  end
  object Button1: TButton
    Left = 114
    Top = 380
    Width = 89
    Height = 30
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 239
    Top = 380
    Width = 89
    Height = 30
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object LEXmin: TLabeledEdit
    Left = 10
    Top = 279
    Width = 127
    Height = 27
    EditLabel.Width = 140
    EditLabel.Height = 19
    EditLabel.Caption = 'X min (X>0.06 V)'
    TabOrder = 2
  end
  object LEYmax: TLabeledEdit
    Left = 185
    Top = 336
    Width = 127
    Height = 27
    EditLabel.Width = 51
    EditLabel.Height = 19
    EditLabel.Caption = 'Y max'
    TabOrder = 5
  end
  object LEYmin: TLabeledEdit
    Left = 10
    Top = 336
    Width = 127
    Height = 27
    EditLabel.Width = 101
    EditLabel.Height = 19
    EditLabel.Caption = 'Y min (>=0)'
    TabOrder = 3
  end
  object LEXmax: TLabeledEdit
    Left = 185
    Top = 281
    Width = 127
    Height = 27
    EditLabel.Width = 51
    EditLabel.Height = 19
    EditLabel.Caption = 'X max'
    TabOrder = 4
  end
end

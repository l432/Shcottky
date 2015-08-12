object NssForm: TNssForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'The density of interface states parameters'
  ClientHeight = 415
  ClientWidth = 500
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
  object Label1: TLabel
    Left = 143
    Top = 8
    Width = 201
    Height = 16
    Caption = 'Density of interface states Nss'
  end
  object Label2: TLabel
    Left = 129
    Top = 105
    Width = 215
    Height = 16
    Caption = 'Nss = ep* ep0* ( n - 1 ) / (d * e)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 160
    Top = 130
    Width = 158
    Height = 16
    Caption = '(Ec-Ess) = ( '#1060'b - V / n )'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 8
    Top = 52
    Width = 280
    Height = 16
    Caption = 'energy of interface states with respect to '
  end
  object Label5: TLabel
    Left = 235
    Top = 30
    Width = 19
    Height = 16
    Caption = 'vs '
  end
  object Label6: TLabel
    Left = 190
    Top = 70
    Width = 284
    Height = 16
    Caption = 'the bottom of the conduction band (Ec-Ess)'
  end
  object Label7: TLabel
    Left = 345
    Top = 155
    Width = 113
    Height = 16
    Caption = 'n - ideality factor'
  end
  object Label11: TLabel
    Left = 345
    Top = 177
    Width = 123
    Height = 16
    Caption = #1060'b - barrier height'
  end
  object Label8: TLabel
    Left = 16
    Top = 155
    Width = 247
    Height = 16
    Caption = 'ep - permittivity of the insulator layer'
  end
  object Label9: TLabel
    Left = 16
    Top = 175
    Width = 204
    Height = 16
    Caption = 'ep0 - permittivity of free space'
  end
  object Label10: TLabel
    Left = 16
    Top = 195
    Width = 293
    Height = 16
    Caption = 'd - thickness of the interfacial insulator layer'
  end
  object Label12: TLabel
    Left = 48
    Top = 252
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
  object Label13: TLabel
    Left = 104
    Top = 224
    Width = 166
    Height = 16
    Caption = '[Nss] = (eV)^-1 (cm)^-2'
  end
  object Label14: TLabel
    Left = 307
    Top = 224
    Width = 89
    Height = 16
    Caption = '[Ec-Ess] = eV'
  end
  object Button1: TButton
    Left = 179
    Top = 380
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 4
  end
  object Button2: TButton
    Left = 399
    Top = 383
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
  object LEXmin: TLabeledEdit
    Left = 23
    Top = 294
    Width = 121
    Height = 24
    EditLabel.Width = 70
    EditLabel.Height = 16
    EditLabel.Caption = 'X min (>0)'
    TabOrder = 0
  end
  object LEXmax: TLabeledEdit
    Left = 291
    Top = 294
    Width = 121
    Height = 24
    EditLabel.Width = 39
    EditLabel.Height = 16
    EditLabel.Caption = 'X max'
    TabOrder = 2
  end
  object LEYmax: TLabeledEdit
    Left = 291
    Top = 343
    Width = 121
    Height = 24
    EditLabel.Width = 39
    EditLabel.Height = 16
    EditLabel.Caption = 'Y max'
    TabOrder = 3
  end
  object LEYmin: TLabeledEdit
    Left = 23
    Top = 343
    Width = 121
    Height = 24
    EditLabel.Width = 81
    EditLabel.Height = 16
    EditLabel.Caption = 'Y min (>=0)'
    TabOrder = 1
  end
end

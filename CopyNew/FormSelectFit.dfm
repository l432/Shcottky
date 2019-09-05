object FormSF: TFormSF
  Left = 0
  Top = 0
  Caption = 'Form'
  ClientHeight = 294
  ClientWidth = 453
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Img: TImage
    Left = 32
    Top = 48
    Width = 169
    Height = 201
  end
  object Lab: TLabel
    Left = 80
    Top = 264
    Width = 17
    Height = 13
    Caption = 'Lab'
  end
  object CB: TListBox
    Left = 288
    Top = 72
    Width = 121
    Height = 129
    ItemHeight = 17
    TabOrder = 0
    OnClick = CBClick
  end
end

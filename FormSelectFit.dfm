object FormSF: TFormSF
  Left = 0
  Top = 0
  Caption = 'Form'
  ClientHeight = 384
  ClientWidth = 592
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 17
  object Img: TImage
    Left = 42
    Top = 63
    Width = 221
    Height = 263
  end
  object Lab: TLabel
    Left = 105
    Top = 345
    Width = 22
    Height = 17
    Caption = 'Lab'
  end
  object CB: TListBox
    Left = 377
    Top = 94
    Width = 158
    Height = 169
    ItemHeight = 17
    TabOrder = 0
    OnClick = CBClick
  end
end

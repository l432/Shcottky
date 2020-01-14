object FormSFNew: TFormSFNew
  Left = 0
  Top = 0
  Caption = 'FormSFNew'
  ClientHeight = 518
  ClientWidth = 684
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object LFormSF: TLabel
    Left = 128
    Top = 416
    Width = 51
    Height = 16
    Caption = 'LFormSF'
  end
  object ImgFSF: TImage
    Left = 56
    Top = 72
    Width = 281
    Height = 297
  end
  object TVFormSF: TTreeView
    Left = 384
    Top = 32
    Width = 273
    Height = 169
    Indent = 19
    TabOrder = 0
  end
end

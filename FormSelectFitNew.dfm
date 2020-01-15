object FormSFNew: TFormSFNew
  Left = 0
  Top = 0
  Caption = 'FormSFNew'
  ClientHeight = 389
  ClientWidth = 513
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object LFormSF: TLabel
    Left = 96
    Top = 312
    Width = 41
    Height = 12
    Caption = 'LFormSF'
  end
  object ImgFSF: TImage
    Left = 42
    Top = 54
    Width = 211
    Height = 223
  end
  object TVFormSF: TTreeView
    Left = 288
    Top = 24
    Width = 205
    Height = 127
    Indent = 19
    ReadOnly = True
    TabOrder = 0
    OnClick = TVFormSFClick
  end
end

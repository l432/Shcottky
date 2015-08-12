object FrBut: TFrBut
  Left = 0
  Top = 0
  Width = 333
  Height = 24
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  ParentFont = False
  TabOrder = 0
  object ButOk: TButton
    Left = 0
    Top = 0
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 0
  end
  object ButCancel: TButton
    Left = 184
    Top = 0
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
end

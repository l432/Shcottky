object FrParamP: TFrParamP
  Left = 0
  Top = 0
  Width = 138
  Height = 79
  TabOrder = 0
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 121
    Height = 65
    BevelWidth = 3
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object LName: TLabel
      Left = 16
      Top = 8
      Width = 35
      Height = 16
      Caption = 'Name'
    end
    object CBIntr: TCheckBox
      Left = 64
      Top = 9
      Width = 50
      Height = 17
      Caption = 'def'
      TabOrder = 0
      OnClick = CBIntrClick
    end
    object EParam: TEdit
      Left = 16
      Top = 30
      Width = 81
      Height = 24
      TabOrder = 1
    end
  end
end

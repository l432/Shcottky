object FrDp: TFrDp
  Left = 0
  Top = 0
  Width = 388
  Height = 140
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  ParentFont = False
  TabOrder = 0
  object LRange: TLabel
    Left = 10
    Top = 0
    Width = 188
    Height = 21
    Caption = 'Range for calculation:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LEXmin: TLabeledEdit
    Left = 34
    Top = 47
    Width = 119
    Height = 27
    EditLabel.Width = 88
    EditLabel.Height = 19
    EditLabel.Caption = 'X min (>0)'
    TabOrder = 0
  end
  object LEYmax: TLabeledEdit
    Left = 262
    Top = 107
    Width = 119
    Height = 27
    EditLabel.Width = 51
    EditLabel.Height = 19
    EditLabel.Caption = 'Y max'
    TabOrder = 3
  end
  object LEYmin: TLabeledEdit
    Left = 34
    Top = 107
    Width = 119
    Height = 27
    EditLabel.Width = 101
    EditLabel.Height = 19
    EditLabel.Caption = 'Y min (>=0)'
    TabOrder = 1
  end
  object LEXmax: TLabeledEdit
    Left = 262
    Top = 47
    Width = 119
    Height = 27
    EditLabel.Width = 51
    EditLabel.Height = 19
    EditLabel.Caption = 'X max'
    TabOrder = 2
  end
end

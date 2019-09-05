object FrApprP: TFrApprP
  Left = 0
  Top = 0
  Width = 460
  Height = 84
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  ParentFont = False
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 450
    Height = 79
    BevelWidth = 3
    TabOrder = 0
    object LName: TLabel
      Left = 16
      Top = 16
      Width = 35
      Height = 16
      Caption = 'Name'
    end
    object GBoxInit: TGroupBox
      Left = 65
      Top = 3
      Width = 110
      Height = 70
      Caption = 'Initial value'
      TabOrder = 0
      object minIn: TLabeledEdit
        Left = 40
        Top = 20
        Width = 54
        Height = 24
        EditLabel.Width = 26
        EditLabel.Height = 16
        EditLabel.Caption = 'min '
        LabelPosition = lpLeft
        TabOrder = 1
        OnKeyPress = minInKeyPress
      end
      object maxIn: TLabeledEdit
        Left = 40
        Top = 46
        Width = 54
        Height = 24
        EditLabel.Width = 30
        EditLabel.Height = 16
        EditLabel.Caption = 'max '
        LabelPosition = lpLeft
        TabOrder = 0
      end
    end
    object GBoxLim: TGroupBox
      Left = 178
      Top = 3
      Width = 110
      Height = 70
      Caption = 'Limit value'
      TabOrder = 1
      object minLim: TLabeledEdit
        Left = 40
        Top = 20
        Width = 54
        Height = 24
        EditLabel.Width = 26
        EditLabel.Height = 16
        EditLabel.Caption = 'min '
        LabelPosition = lpLeft
        TabOrder = 0
      end
      object maxLim: TLabeledEdit
        Left = 40
        Top = 46
        Width = 54
        Height = 24
        EditLabel.Width = 30
        EditLabel.Height = 16
        EditLabel.Caption = 'max '
        LabelPosition = lpLeft
        TabOrder = 1
      end
    end
    object GBoxMode: TGroupBox
      Left = 294
      Top = 3
      Width = 121
      Height = 70
      Caption = 'Mode'
      TabOrder = 2
      object RBNorm: TRadioButton
        Left = 10
        Top = 51
        Width = 100
        Height = 17
        Caption = 'Normal'
        TabOrder = 3
        OnClick = RBConsClick
      end
      object RBLogar: TRadioButton
        Left = 10
        Top = 33
        Width = 100
        Height = 17
        Caption = 'Logarithmic'
        TabOrder = 1
        TabStop = True
        OnClick = RBConsClick
      end
      object RBCons: TRadioButton
        Left = 10
        Top = 14
        Width = 85
        Height = 17
        Caption = 'Constant'
        TabOrder = 2
        OnClick = RBConsClick
      end
      object Bt: TButton
        Left = 96
        Top = 10
        Width = 20
        Height = 20
        Caption = '?'
        TabOrder = 0
        OnClick = BtClick
      end
    end
  end
end

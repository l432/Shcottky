object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Shottky I-V-characteristics'
  ClientHeight = 626
  ClientWidth = 765
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 765
    Height = 626
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = 'Directory operation'
      object GroupBox13: TGroupBox
        Left = 3
        Top = 413
        Width = 673
        Height = 180
        Caption = 'SELECT DATES FOR CALCULATION'
        Color = clMenuBar
        ParentBackground = False
        ParentColor = False
        TabOrder = 2
        object LabelData: TLabel
          Left = 238
          Top = 83
          Width = 279
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Data.dat'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clPurple
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object LDateFun: TLabel
          Left = 554
          Top = 10
          Width = 116
          Height = 29
          AutoSize = False
          Caption = 'Photo D-Diod'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object StrGridData: TStringGrid
          Left = 245
          Top = 101
          Width = 424
          Height = 76
          DefaultColWidth = 50
          DefaultRowHeight = 20
          FixedCols = 0
          RowCount = 2
          TabOrder = 0
        end
        object ButtonCreateDate: TButton
          Left = 460
          Top = 24
          Width = 60
          Height = 50
          Cursor = crHandPoint
          Caption = 'Create &dates.dat'
          TabOrder = 1
          WordWrap = True
          OnClick = ButtonCreateDateClick
        end
        object ScrollBox4: TScrollBox
          Left = 3
          Top = 15
          Width = 238
          Height = 160
          VertScrollBar.Position = 312
          TabOrder = 2
          object GroupBox15: TGroupBox
            Left = 12
            Top = 149
            Width = 197
            Height = 77
            Caption = ' I=I0[exp(eV/nkT)-1]'
            TabOrder = 0
            object CBDaten_Exp: TCheckBox
              Tag = 200
              Left = 160
              Top = 15
              Width = 25
              Height = 17
              Caption = 'n'
              TabOrder = 0
              OnClick = CBDateRs_ChClick
            end
            object CBDateIs_Exp: TCheckBox
              Tag = 200
              Left = 160
              Top = 36
              Width = 25
              Height = 17
              Caption = 'I0'
              TabOrder = 1
              OnClick = CBDateRs_ChClick
            end
            object CBDateFb_Exp: TCheckBox
              Tag = 200
              Left = 160
              Top = 57
              Width = 33
              Height = 17
              Caption = #1060'b'
              TabOrder = 2
              OnClick = CBDateRs_ChClick
            end
            object GroupBoxDateExpRs: TGroupBox
              Left = 3
              Top = 18
              Width = 152
              Height = 47
              Caption = 'Rs source'
              TabOrder = 3
              object GroupBoxDateExpRs_N: TGroupBox
                Left = 75
                Top = 5
                Width = 73
                Height = 40
                Caption = 'n source'
                TabOrder = 0
                object ComBDateExpRs_n: TComboBox
                  Tag = 402
                  Left = 5
                  Top = 15
                  Width = 66
                  Height = 22
                  Style = csDropDownList
                  DropDownCount = 15
                  ItemHeight = 14
                  TabOrder = 0
                end
              end
              object ComBDateExpRs: TComboBox
                Tag = 402
                Left = 3
                Top = 15
                Width = 66
                Height = 22
                Style = csDropDownList
                DropDownCount = 15
                ItemHeight = 14
                TabOrder = 1
                OnChange = ComBForwRsChange
              end
            end
          end
          object GroupBox19: TGroupBox
            Left = 12
            Top = 309
            Width = 197
            Height = 75
            Caption = 'Norde'#39's function'
            TabOrder = 1
            object CBDateRs_N: TCheckBox
              Tag = 200
              Left = 90
              Top = 10
              Width = 30
              Height = 17
              Caption = 'Rs'
              TabOrder = 0
              OnClick = CBDateRs_ChClick
            end
            object CBDateFb_N: TCheckBox
              Tag = 200
              Left = 141
              Top = 10
              Width = 33
              Height = 17
              Caption = #1060'b'
              TabOrder = 1
              OnClick = CBDateRs_ChClick
            end
            object GroupBoxDateNordN: TGroupBox
              Left = 4
              Top = 25
              Width = 189
              Height = 47
              Caption = 'n source'
              TabOrder = 2
              object GroupBoxDateNordN_Rs: TGroupBox
                Left = 112
                Top = 5
                Width = 73
                Height = 40
                Caption = 'Rs source'
                TabOrder = 0
                object ComBDateNordN_Rs: TComboBox
                  Tag = 404
                  Left = 5
                  Top = 15
                  Width = 66
                  Height = 22
                  Style = csDropDownList
                  DropDownCount = 15
                  ItemHeight = 14
                  TabOrder = 0
                end
              end
              object ComBDateNordN: TComboBox
                Tag = 404
                Left = 5
                Top = 15
                Width = 103
                Height = 22
                Style = csDropDownList
                DropDownCount = 15
                ItemHeight = 14
                TabOrder = 1
                OnChange = ComBForwRsChange
              end
            end
          end
          object GroupBox18: TGroupBox
            Left = 12
            Top = 232
            Width = 197
            Height = 75
            Caption = 'H funcion'
            TabOrder = 2
            object CBDateRs_H: TCheckBox
              Tag = 200
              Left = 90
              Top = 7
              Width = 28
              Height = 17
              Caption = 'Rs'
              TabOrder = 0
              OnClick = CBDateRs_ChClick
            end
            object CBDateFb_H: TCheckBox
              Tag = 200
              Left = 140
              Top = 10
              Width = 33
              Height = 17
              Caption = #1060'b'
              TabOrder = 1
              OnClick = CBDateRs_ChClick
            end
            object GroupBoxDateHfuncN: TGroupBox
              Left = 4
              Top = 25
              Width = 189
              Height = 47
              Caption = 'n source'
              TabOrder = 2
              object GroupBoxDateHfuncN_Rs: TGroupBox
                Left = 112
                Top = 5
                Width = 73
                Height = 40
                Caption = 'Rs source'
                TabOrder = 0
                object ComBDateHfunN_Rs: TComboBox
                  Tag = 403
                  Left = 4
                  Top = 15
                  Width = 66
                  Height = 22
                  Style = csDropDownList
                  DropDownCount = 15
                  ItemHeight = 14
                  TabOrder = 0
                end
              end
              object ComBDateHfunN: TComboBox
                Tag = 403
                Left = 5
                Top = 15
                Width = 103
                Height = 22
                Style = csDropDownList
                DropDownCount = 15
                ItemHeight = 14
                TabOrder = 1
                OnChange = ComBForwRsChange
              end
            end
          end
          object GroupBox14: TGroupBox
            Left = 12
            Top = 66
            Width = 197
            Height = 77
            Caption = 'I=I0exp(eV/nkT)'
            TabOrder = 3
            object CBDaten_El: TCheckBox
              Tag = 200
              Left = 10
              Top = 15
              Width = 25
              Height = 17
              Caption = 'n'
              TabOrder = 0
              OnClick = CBDateRs_ChClick
            end
            object CBDateIs_El: TCheckBox
              Tag = 200
              Left = 10
              Top = 36
              Width = 25
              Height = 17
              Caption = 'I0'
              TabOrder = 1
              OnClick = CBDateRs_ChClick
            end
            object CBDateFb_El: TCheckBox
              Tag = 200
              Left = 10
              Top = 57
              Width = 33
              Height = 17
              Caption = #1060'b'
              TabOrder = 2
              OnClick = CBDateRs_ChClick
            end
            object GroupBoxDateExRs: TGroupBox
              Left = 43
              Top = 18
              Width = 152
              Height = 47
              Caption = 'Rs source'
              TabOrder = 3
              object GroupBoxDateExRs_N: TGroupBox
                Left = 75
                Top = 5
                Width = 73
                Height = 40
                Caption = 'n source'
                TabOrder = 0
                object ComBDateExRs_n: TComboBox
                  Tag = 401
                  Left = 3
                  Top = 16
                  Width = 66
                  Height = 22
                  Style = csDropDownList
                  DropDownCount = 15
                  ItemHeight = 14
                  TabOrder = 0
                end
              end
              object ComBDateExRs: TComboBox
                Tag = 401
                Left = 5
                Top = 15
                Width = 66
                Height = 22
                Style = csDropDownList
                DropDownCount = 15
                ItemHeight = 14
                TabOrder = 1
                OnChange = ComBForwRsChange
              end
            end
          end
          object GroupBox31: TGroupBox
            Left = 12
            Top = 386
            Width = 197
            Height = 76
            Caption = 'I/[1-exp(-qV/kT)], forward'
            TabOrder = 4
            object CBDaten_E2F: TCheckBox
              Tag = 200
              Left = 10
              Top = 15
              Width = 25
              Height = 17
              Caption = 'n'
              TabOrder = 0
              OnClick = CBDateRs_ChClick
            end
            object CBDateIs_E2F: TCheckBox
              Tag = 200
              Left = 10
              Top = 36
              Width = 25
              Height = 17
              Caption = 'I0'
              TabOrder = 1
              OnClick = CBDateRs_ChClick
            end
            object CBDateFb_E2F: TCheckBox
              Tag = 200
              Left = 10
              Top = 57
              Width = 33
              Height = 17
              Caption = #1060'b'
              TabOrder = 2
              OnClick = CBDateRs_ChClick
            end
            object GroupBoxDateEx2F: TGroupBox
              Left = 43
              Top = 18
              Width = 152
              Height = 47
              Caption = 'Rs source'
              TabOrder = 3
              object GroupBoxDateEx2FRs_N: TGroupBox
                Left = 75
                Top = 5
                Width = 73
                Height = 40
                Caption = 'n source'
                TabOrder = 0
                object ComBDateEx2FRs_n: TComboBox
                  Tag = 405
                  Left = 3
                  Top = 16
                  Width = 66
                  Height = 22
                  Style = csDropDownList
                  DropDownCount = 15
                  ItemHeight = 14
                  TabOrder = 0
                end
              end
              object ComBDateEx2FRs: TComboBox
                Tag = 405
                Left = 5
                Top = 15
                Width = 66
                Height = 22
                Style = csDropDownList
                DropDownCount = 15
                ItemHeight = 14
                TabOrder = 1
                OnChange = ComBForwRsChange
              end
            end
          end
          object GroupBox35: TGroupBox
            Left = 12
            Top = 467
            Width = 197
            Height = 77
            Caption = 'I/[1-exp(-qV/kT)], reverse'
            TabOrder = 5
            object CBDaten_E2R: TCheckBox
              Tag = 200
              Left = 160
              Top = 15
              Width = 25
              Height = 17
              Caption = 'n'
              TabOrder = 0
              OnClick = CBDateRs_ChClick
            end
            object CBDateIs_E2R: TCheckBox
              Tag = 200
              Left = 160
              Top = 36
              Width = 25
              Height = 17
              Caption = 'I0'
              TabOrder = 1
              OnClick = CBDateRs_ChClick
            end
            object CBDateFb_E2R: TCheckBox
              Tag = 200
              Left = 160
              Top = 57
              Width = 33
              Height = 17
              Caption = #1060'b'
              TabOrder = 2
              OnClick = CBDateRs_ChClick
            end
            object GroupBoxDateEx2R: TGroupBox
              Left = 3
              Top = 18
              Width = 152
              Height = 47
              Caption = 'Rs source'
              TabOrder = 3
              object GroupBoxDateEx2RRs_N: TGroupBox
                Left = 75
                Top = 5
                Width = 73
                Height = 40
                Caption = 'n source'
                TabOrder = 0
                object ComBDateEx2RRs_n: TComboBox
                  Tag = 406
                  Left = 4
                  Top = 15
                  Width = 66
                  Height = 22
                  Style = csDropDownList
                  DropDownCount = 15
                  ItemHeight = 14
                  TabOrder = 0
                end
              end
              object ComBDateEx2RRs: TComboBox
                Tag = 406
                Left = 5
                Top = 15
                Width = 66
                Height = 22
                Style = csDropDownList
                DropDownCount = 15
                ItemHeight = 14
                TabOrder = 1
                OnChange = ComBForwRsChange
              end
            end
          end
          object GroupBox39: TGroupBox
            Left = 12
            Top = -308
            Width = 197
            Height = 80
            Caption = 'I=I0[exp((V-IRs)/E)-1]+(V-I Rs)/Rsh-Iph'
            TabOrder = 6
            object LExN: TLabel
              Left = 52
              Top = 40
              Width = 100
              Height = 14
              Caption = 'Direct Approximation'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clHotLight
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object CBDateRs_ExN: TCheckBox
              Tag = 200
              Left = 10
              Top = 20
              Width = 30
              Height = 17
              Caption = 'Rs'
              TabOrder = 0
              OnClick = CBDateRs_ChClick
            end
            object CBDaten_ExN: TCheckBox
              Tag = 200
              Left = 60
              Top = 20
              Width = 25
              Height = 17
              Caption = 'n'
              TabOrder = 1
              OnClick = CBDateRs_ChClick
            end
            object CBDateIs_ExN: TCheckBox
              Tag = 200
              Left = 109
              Top = 20
              Width = 30
              Height = 17
              Caption = 'I0'
              TabOrder = 2
              OnClick = CBDateRs_ChClick
            end
            object CBDateFb_ExN: TCheckBox
              Tag = 200
              Left = 158
              Top = 20
              Width = 30
              Height = 17
              Caption = #1060'b'
              TabOrder = 3
              OnClick = CBDateRs_ChClick
            end
            object CBDateIf_ExN: TCheckBox
              Tag = 200
              Left = 158
              Top = 40
              Width = 36
              Height = 17
              Caption = 'Iph'
              TabOrder = 4
              OnClick = CBDateRs_ChClick
            end
            object CBDateIsc_ExN: TCheckBox
              Tag = 200
              Left = 10
              Top = 60
              Width = 30
              Height = 17
              Caption = 'Isc'
              TabOrder = 5
              OnClick = CBDateRs_ChClick
            end
            object CBDateVoc_ExN: TCheckBox
              Tag = 200
              Left = 60
              Top = 60
              Width = 43
              Height = 17
              Caption = 'Voc'
              TabOrder = 6
              OnClick = CBDateRs_ChClick
            end
            object CBDatePm_ExN: TCheckBox
              Tag = 200
              Left = 109
              Top = 60
              Width = 43
              Height = 17
              Caption = 'Pm'
              TabOrder = 7
              OnClick = CBDateRs_ChClick
            end
            object CBDateFF_ExN: TCheckBox
              Tag = 200
              Left = 158
              Top = 60
              Width = 30
              Height = 17
              Caption = 'FF'
              TabOrder = 8
              OnClick = CBDateRs_ChClick
            end
            object CBDateRsh_ExN: TCheckBox
              Tag = 200
              Left = 10
              Top = 40
              Width = 36
              Height = 17
              Caption = 'Rsh'
              TabOrder = 9
              OnClick = CBDateRs_ChClick
            end
          end
          object GroupBox40: TGroupBox
            Left = 12
            Top = -217
            Width = 197
            Height = 80
            Caption = 'I=I0[exp((V-IRs)/E)-1]+(V-I Rs)/Rsh-Iph'
            TabOrder = 7
            object LLam: TLabel
              Left = 60
              Top = 40
              Width = 81
              Height = 14
              Caption = 'Lambert function'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clHotLight
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object CBDateRs_Lam: TCheckBox
              Tag = 200
              Left = 10
              Top = 20
              Width = 30
              Height = 17
              Caption = 'Rs'
              TabOrder = 0
              OnClick = CBDateRs_ChClick
            end
            object CBDaten_Lam: TCheckBox
              Tag = 200
              Left = 60
              Top = 20
              Width = 25
              Height = 17
              Caption = 'n'
              TabOrder = 1
              OnClick = CBDateRs_ChClick
            end
            object CBDateIs_Lam: TCheckBox
              Tag = 200
              Left = 109
              Top = 20
              Width = 30
              Height = 17
              Caption = 'I0'
              TabOrder = 2
              OnClick = CBDateRs_ChClick
            end
            object CBDateFb_Lam: TCheckBox
              Tag = 200
              Left = 158
              Top = 20
              Width = 30
              Height = 17
              Caption = #1060'b'
              TabOrder = 3
              OnClick = CBDateRs_ChClick
            end
            object CBDateIf_Lam: TCheckBox
              Tag = 200
              Left = 158
              Top = 40
              Width = 36
              Height = 17
              Caption = 'Iph'
              TabOrder = 4
              OnClick = CBDateRs_ChClick
            end
            object CBDateIsc_Lam: TCheckBox
              Tag = 200
              Left = 10
              Top = 60
              Width = 30
              Height = 17
              Caption = 'Isc'
              TabOrder = 5
              OnClick = CBDateRs_ChClick
            end
            object CBDateVoc_Lam: TCheckBox
              Tag = 200
              Left = 60
              Top = 60
              Width = 43
              Height = 17
              Caption = 'Voc'
              TabOrder = 6
              OnClick = CBDateRs_ChClick
            end
            object CBDatePm_Lam: TCheckBox
              Tag = 200
              Left = 109
              Top = 60
              Width = 43
              Height = 17
              Caption = 'Pm'
              TabOrder = 7
              OnClick = CBDateRs_ChClick
            end
            object CBDateFF_Lam: TCheckBox
              Tag = 200
              Left = 158
              Top = 60
              Width = 30
              Height = 17
              Caption = 'FF'
              TabOrder = 8
              OnClick = CBDateRs_ChClick
            end
            object CBDateRsh_Lam: TCheckBox
              Tag = 200
              Left = 10
              Top = 40
              Width = 36
              Height = 17
              Caption = 'Rsh'
              TabOrder = 9
              OnClick = CBDateRs_ChClick
            end
          end
          object GroupBox41: TGroupBox
            Left = 12
            Top = -126
            Width = 197
            Height = 80
            Caption = 'I=I0[exp((V-IRs)/E)-1]+(V-I Rs)/Rsh-Iph'
            TabOrder = 8
            object LDE: TLabel
              Left = 52
              Top = 40
              Width = 97
              Height = 14
              Caption = 'Evoluation Algorithm'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clHotLight
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object CBDateRs_DE: TCheckBox
              Tag = 200
              Left = 10
              Top = 20
              Width = 30
              Height = 17
              Caption = 'Rs'
              TabOrder = 0
              OnClick = CBDateRs_ChClick
            end
            object CBDaten_DE: TCheckBox
              Tag = 200
              Left = 60
              Top = 20
              Width = 25
              Height = 17
              Caption = 'n'
              TabOrder = 1
              OnClick = CBDateRs_ChClick
            end
            object CBDateIs_DE: TCheckBox
              Tag = 200
              Left = 109
              Top = 20
              Width = 30
              Height = 17
              Caption = 'I0'
              TabOrder = 2
              OnClick = CBDateRs_ChClick
            end
            object CBDateFb_DE: TCheckBox
              Tag = 200
              Left = 158
              Top = 20
              Width = 30
              Height = 17
              Caption = #1060'b'
              TabOrder = 3
              OnClick = CBDateRs_ChClick
            end
            object CBDateIf_DE: TCheckBox
              Tag = 200
              Left = 158
              Top = 40
              Width = 36
              Height = 17
              Caption = 'Iph'
              TabOrder = 4
              OnClick = CBDateRs_ChClick
            end
            object CBDateIsc_DE: TCheckBox
              Tag = 200
              Left = 10
              Top = 60
              Width = 30
              Height = 17
              Caption = 'Isc'
              TabOrder = 5
              OnClick = CBDateRs_ChClick
            end
            object CBDateVoc_DE: TCheckBox
              Tag = 200
              Left = 60
              Top = 60
              Width = 43
              Height = 17
              Caption = 'Voc'
              TabOrder = 6
              OnClick = CBDateRs_ChClick
            end
            object CBDatePm_DE: TCheckBox
              Tag = 200
              Left = 109
              Top = 60
              Width = 43
              Height = 17
              Caption = 'Pm'
              TabOrder = 7
              OnClick = CBDateRs_ChClick
            end
            object CBDateFF_DE: TCheckBox
              Tag = 200
              Left = 158
              Top = 60
              Width = 30
              Height = 17
              Caption = 'FF'
              TabOrder = 8
              OnClick = CBDateRs_ChClick
            end
            object CBDateRsh_DE: TCheckBox
              Tag = 200
              Left = 10
              Top = 40
              Width = 36
              Height = 17
              Caption = 'Rsh'
              TabOrder = 9
              OnClick = CBDateRs_ChClick
            end
          end
          object GroupBox42: TGroupBox
            Left = 12
            Top = -30
            Width = 197
            Height = 80
            Caption = 'Double Diod'
            TabOrder = 9
            object LEA: TLabel
              Left = 52
              Top = 40
              Width = 97
              Height = 14
              Caption = 'Evoluation Algorithm'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clHotLight
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object CBDateRs_EA: TCheckBox
              Tag = 200
              Left = 10
              Top = 18
              Width = 30
              Height = 17
              Caption = 'Rs'
              TabOrder = 0
              OnClick = CBDateRs_ChClick
            end
            object CBDaten1_EA: TCheckBox
              Tag = 200
              Left = 45
              Top = 20
              Width = 38
              Height = 17
              Caption = 'n1'
              TabOrder = 1
              OnClick = CBDateRs_ChClick
            end
            object CBDateIs1_EA: TCheckBox
              Tag = 200
              Left = 85
              Top = 20
              Width = 30
              Height = 17
              Caption = 'I01'
              TabOrder = 2
              OnClick = CBDateRs_ChClick
            end
            object CBDateIs2_EA: TCheckBox
              Tag = 200
              Left = 158
              Top = 20
              Width = 36
              Height = 17
              Caption = 'I02'
              TabOrder = 3
              OnClick = CBDateRs_ChClick
            end
            object CBDateIf_EA: TCheckBox
              Tag = 200
              Left = 158
              Top = 40
              Width = 36
              Height = 17
              Caption = 'Iph'
              TabOrder = 4
              OnClick = CBDateRs_ChClick
            end
            object CBDateIsc_EA: TCheckBox
              Tag = 200
              Left = 10
              Top = 60
              Width = 30
              Height = 17
              Caption = 'Isc'
              TabOrder = 5
              OnClick = CBDateRs_ChClick
            end
            object CBDateVoc_EA: TCheckBox
              Tag = 200
              Left = 60
              Top = 60
              Width = 43
              Height = 17
              Caption = 'Voc'
              TabOrder = 6
              OnClick = CBDateRs_ChClick
            end
            object CBDatePm_EA: TCheckBox
              Tag = 200
              Left = 109
              Top = 60
              Width = 43
              Height = 17
              Caption = 'Pm'
              TabOrder = 7
              OnClick = CBDateRs_ChClick
            end
            object CBDateFF_EA: TCheckBox
              Tag = 200
              Left = 158
              Top = 60
              Width = 30
              Height = 17
              Caption = 'FF'
              TabOrder = 8
              OnClick = CBDateRs_ChClick
            end
            object CBDateRsh_EA: TCheckBox
              Tag = 200
              Left = 10
              Top = 40
              Width = 36
              Height = 17
              Caption = 'Rsh'
              TabOrder = 9
              OnClick = CBDateRs_ChClick
            end
            object CBDaten2_EA: TCheckBox
              Tag = 200
              Left = 123
              Top = 20
              Width = 29
              Height = 17
              Caption = 'n2'
              TabOrder = 10
              OnClick = CBDateRs_ChClick
            end
          end
        end
        object ScrollBox5: TScrollBox
          Left = 240
          Top = 15
          Width = 216
          Height = 70
          TabOrder = 3
          object GroupBox21: TGroupBox
            Left = 2
            Top = 0
            Width = 95
            Height = 32
            Caption = 'Kaminski I func'
            TabOrder = 0
            object CBDateRs_K1: TCheckBox
              Tag = 200
              Left = 10
              Top = 12
              Width = 30
              Height = 17
              Caption = 'Rs'
              TabOrder = 0
              OnClick = CBDateRs_ChClick
            end
            object CBDaten_K1: TCheckBox
              Tag = 200
              Left = 60
              Top = 12
              Width = 25
              Height = 17
              Caption = 'n'
              TabOrder = 1
              OnClick = CBDateRs_ChClick
            end
          end
          object GroupBox22: TGroupBox
            Left = 2
            Top = 33
            Width = 95
            Height = 32
            Caption = 'Kaminski II func'
            TabOrder = 1
            object CBDateRs_K2: TCheckBox
              Tag = 200
              Left = 10
              Top = 12
              Width = 30
              Height = 17
              Caption = 'Rs'
              TabOrder = 0
              OnClick = CBDateRs_ChClick
            end
            object CBDaten_K2: TCheckBox
              Tag = 200
              Left = 60
              Top = 12
              Width = 25
              Height = 17
              Caption = 'n'
              TabOrder = 1
              OnClick = CBDateRs_ChClick
            end
          end
          object GroupBox17: TGroupBox
            Left = 100
            Top = 33
            Width = 95
            Height = 32
            Caption = 'rectification'
            TabOrder = 2
            object CBDateKrec: TCheckBox
              Tag = 200
              Left = 25
              Top = 12
              Width = 47
              Height = 17
              Caption = 'Krect'
              TabOrder = 0
              OnClick = CBDateRs_ChClick
            end
          end
          object GroupBox16: TGroupBox
            Left = 100
            Top = 0
            Width = 95
            Height = 32
            Caption = 'Cheung function'
            TabOrder = 3
            object CBDateRs_Ch: TCheckBox
              Tag = 200
              Left = 10
              Top = 12
              Width = 30
              Height = 17
              Caption = 'Rs'
              TabOrder = 0
              OnClick = CBDateRs_ChClick
            end
            object CBDaten_Ch: TCheckBox
              Tag = 200
              Left = 60
              Top = 12
              Width = 25
              Height = 17
              Caption = 'n'
              TabOrder = 1
              OnClick = CBDateRs_ChClick
            end
          end
          object GroupBox23: TGroupBox
            Left = 2
            Top = 66
            Width = 95
            Height = 32
            Caption = 'Cibils method'
            TabOrder = 4
            object CheckBoxDateRs_Cb: TCheckBox
              Tag = 200
              Left = 10
              Top = 12
              Width = 30
              Height = 17
              Caption = 'Rs'
              TabOrder = 0
              OnClick = CBDateRs_ChClick
            end
            object CheckBoxDaten_Cb: TCheckBox
              Tag = 200
              Left = 60
              Top = 12
              Width = 25
              Height = 17
              Caption = 'n'
              TabOrder = 1
              OnClick = CBDateRs_ChClick
            end
          end
          object GroupBox24: TGroupBox
            Left = 100
            Top = 66
            Width = 95
            Height = 32
            Caption = 'Werner method'
            TabOrder = 5
            object CheckBoxDateRs_Wer: TCheckBox
              Tag = 200
              Left = 10
              Top = 12
              Width = 30
              Height = 17
              Caption = 'Rs'
              TabOrder = 0
              OnClick = CBDateRs_ChClick
            end
            object CheckBoxDaten_Wer: TCheckBox
              Tag = 200
              Left = 60
              Top = 12
              Width = 25
              Height = 17
              Caption = 'n'
              TabOrder = 1
              OnClick = CBDateRs_ChClick
            end
          end
          object GroupBox25: TGroupBox
            Left = 2
            Top = 99
            Width = 193
            Height = 32
            Caption = 'Gromov I method'
            TabOrder = 6
            object CheckBoxDateRs_Gr1: TCheckBox
              Tag = 200
              Left = 10
              Top = 12
              Width = 30
              Height = 17
              Caption = 'Rs'
              TabOrder = 0
              OnClick = CBDateRs_ChClick
            end
            object CheckBoxn_Gr1: TCheckBox
              Tag = 200
              Left = 60
              Top = 12
              Width = 25
              Height = 17
              Caption = 'n'
              TabOrder = 1
              OnClick = CBDateRs_ChClick
            end
            object CheckBoxIs_Gr1: TCheckBox
              Tag = 200
              Left = 109
              Top = 12
              Width = 30
              Height = 17
              Caption = 'I0'
              TabOrder = 2
              OnClick = CBDateRs_ChClick
            end
            object CheckBoxFb_Gr1: TCheckBox
              Tag = 200
              Left = 158
              Top = 12
              Width = 30
              Height = 17
              Caption = #1060'b'
              TabOrder = 3
              OnClick = CBDateRs_ChClick
            end
          end
          object GroupBox26: TGroupBox
            Left = 2
            Top = 132
            Width = 193
            Height = 32
            Caption = 'Gromov II method'
            TabOrder = 7
            object CheckBoxRs_Gr2: TCheckBox
              Tag = 200
              Left = 10
              Top = 12
              Width = 30
              Height = 17
              Caption = 'Rs'
              TabOrder = 0
              OnClick = CBDateRs_ChClick
            end
            object CheckBoxn_Gr2: TCheckBox
              Tag = 200
              Left = 60
              Top = 12
              Width = 25
              Height = 17
              Caption = 'n'
              TabOrder = 1
              OnClick = CBDateRs_ChClick
            end
            object CheckBoxIs_Gr2: TCheckBox
              Tag = 200
              Left = 109
              Top = 12
              Width = 30
              Height = 17
              Caption = 'I0'
              TabOrder = 2
              OnClick = CBDateRs_ChClick
            end
            object CheckBoxFb_Gr2: TCheckBox
              Tag = 200
              Left = 158
              Top = 12
              Width = 30
              Height = 17
              Caption = #1060'b'
              TabOrder = 3
              OnClick = CBDateRs_ChClick
            end
          end
          object GroupBox27: TGroupBox
            Left = 2
            Top = 165
            Width = 193
            Height = 32
            Caption = 'Bohlin method'
            TabOrder = 8
            object CheckBoxRs_Bh: TCheckBox
              Tag = 200
              Left = 10
              Top = 12
              Width = 30
              Height = 17
              Caption = 'Rs'
              TabOrder = 0
              OnClick = CBDateRs_ChClick
            end
            object CheckBoxn_Bh: TCheckBox
              Tag = 200
              Left = 60
              Top = 12
              Width = 25
              Height = 17
              Caption = 'n'
              TabOrder = 1
              OnClick = CBDateRs_ChClick
            end
            object CheckBoxIs_Bh: TCheckBox
              Tag = 200
              Left = 109
              Top = 12
              Width = 30
              Height = 17
              Caption = 'I0'
              TabOrder = 2
              OnClick = CBDateRs_ChClick
            end
            object CheckBoxFb_Bh: TCheckBox
              Tag = 200
              Left = 158
              Top = 12
              Width = 30
              Height = 17
              Caption = #1060'b'
              TabOrder = 3
              OnClick = CBDateRs_ChClick
            end
          end
          object GroupBox28: TGroupBox
            Left = 2
            Top = 198
            Width = 193
            Height = 32
            Caption = 'Lee method'
            TabOrder = 9
            object CheckBoxRs_Lee: TCheckBox
              Tag = 200
              Left = 10
              Top = 12
              Width = 30
              Height = 17
              Caption = 'Rs'
              TabOrder = 0
              OnClick = CBDateRs_ChClick
            end
            object CheckBoxn_Lee: TCheckBox
              Tag = 200
              Left = 60
              Top = 12
              Width = 25
              Height = 17
              Caption = 'n'
              TabOrder = 1
              OnClick = CBDateRs_ChClick
            end
            object CheckBoxIs_Lee: TCheckBox
              Tag = 200
              Left = 109
              Top = 12
              Width = 30
              Height = 17
              Caption = 'I0'
              TabOrder = 2
              OnClick = CBDateRs_ChClick
            end
            object CheckBoxFb_Lee: TCheckBox
              Tag = 200
              Left = 158
              Top = 12
              Width = 30
              Height = 17
              Caption = #1060'b'
              TabOrder = 3
              OnClick = CBDateRs_ChClick
            end
          end
          object GroupBox29: TGroupBox
            Left = 2
            Top = 234
            Width = 193
            Height = 32
            Caption = 'Mikhelashvili method'
            TabOrder = 10
            object CheckBoxRs_Mk: TCheckBox
              Tag = 200
              Left = 10
              Top = 12
              Width = 30
              Height = 17
              Caption = 'Rs'
              TabOrder = 0
              OnClick = CBDateRs_ChClick
            end
            object CheckBoxn_Mk: TCheckBox
              Tag = 200
              Left = 60
              Top = 12
              Width = 25
              Height = 17
              Caption = 'n'
              TabOrder = 1
              OnClick = CBDateRs_ChClick
            end
            object CheckBoxIs_Mk: TCheckBox
              Tag = 200
              Left = 109
              Top = 12
              Width = 30
              Height = 17
              Caption = 'I0'
              TabOrder = 2
              OnClick = CBDateRs_ChClick
            end
            object CheckBoxFb_Mk: TCheckBox
              Tag = 200
              Left = 158
              Top = 12
              Width = 30
              Height = 17
              Caption = #1060'b'
              TabOrder = 3
              OnClick = CBDateRs_ChClick
            end
          end
        end
        object ButDateSelect: TButton
          Left = 533
          Top = 45
          Width = 44
          Height = 25
          Caption = 'Select'
          TabOrder = 4
          OnClick = ButFitSelectClick
        end
        object ButDateOption: TButton
          Left = 601
          Top = 45
          Width = 44
          Height = 25
          Caption = 'Option'
          Enabled = False
          TabOrder = 5
          OnClick = ButFitOptionClick
        end
        object CBDateFun: TCheckBox
          Left = 530
          Top = 10
          Width = 22
          Height = 17
          TabOrder = 6
          OnClick = CBDateFunClick
        end
      end
      object Close0: TBitBtn
        Left = 682
        Top = 554
        Width = 70
        Height = 25
        Caption = '&Close'
        TabOrder = 0
        OnClick = Close1Click
        Glyph.Data = {
          42020000424D4202000000000000420000002800000010000000100000000100
          1000030000000002000000000000000000000000000000000000007C0000E003
          00001F0000001F7C1F7CF75EFF7FF75EFF7FFF7FFF7FFF7F00000000FF7FF75E
          1F7C1F7C1F7CFF7FFF7FFF7FF75EFF7FFF7FF75EFF7FFF7F0000FF03EF01FF7F
          F75EF75E1F7CF75EFF7FF75EFF7FF75EF75EFF7FF75EFF7F0000FF03EF01F75E
          FF7FFF7FF75E000000000000000000000000FF7FF75EF75E0000FF03EF01EF01
          0000000000001F7C1F7C1F7C1F7C1F7C00000000000000000000FF03EF01EF01
          00001F7C1F7C1F7C1F7C1F7C1F7C1F7C0000EF3DEF3DEF3D0000FF03EF01EF01
          00001F7C1F7C1F7C1F7C1F7C1F7CEF010000EF3DEF3DEF3D0000FF03EF01EF01
          00001F7C1F7C1F7C1F7C1F7C1F7CFF03EF010000EF3DEF3D0000FF030000EF01
          00001F7C1F7C0000EF01EF01EF01FF03FF03FF030000EF3D0000FF03EF01EF01
          00001F7C1F7C0000FF03FF03FF03FF03FF03FF03EF0100000000FF03EF01EF01
          00001F7C1F7C0000FF03FF03FF03FF03FF03FF030000EF3D0000FF03EF01EF01
          00001F7C1F7C0000000000000000FF03FF03EF01EF3DEF3D0000FF03EF01EF01
          00001F7C1F7C1F7C1F7C1F7C0000FF03FF030000EF3DEF3D0000FF03EF01EF01
          00001F7C1F7C1F7C1F7C1F7C1F7C00000000EF3DEF3DEF3DEF3D0000FF03EF01
          00001F7C1F7C1F7C1F7C1F7C1F7C1F7C0000EF3DEF3DEF3DEF3DEF3DEF3DFF03
          00001F7C1F7C1F7C1F7C1F7C1F7C1F7C00000000000000000000000000000000
          00001F7C1F7C}
      end
      object GroupBox11: TGroupBox
        Left = 2
        Top = 11
        Width = 201
        Height = 75
        Color = clInfoBk
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentBackground = False
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        object Label7: TLabel
          Left = 93
          Top = 3
          Width = 92
          Height = 13
          Caption = 'Current Dirtectory:'
        end
        object LabelCurDir: TLabel
          Left = 5
          Top = 22
          Width = 180
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'd:'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object ButtonCurDir: TButton
          Left = 40
          Top = 45
          Width = 129
          Height = 20
          Caption = 'Chose Directory'
          TabOrder = 0
          OnClick = ButtonCurDirClick
        end
      end
      object GroupBox20: TGroupBox
        Left = 3
        Top = 120
        Width = 201
        Height = 245
        Caption = 'CURRENT AT CERTAIN VOLTAGE'
        TabOrder = 3
        object Label8: TLabel
          Left = 16
          Top = 20
          Width = 84
          Height = 14
          Caption = 'Choosen voltage:'
          FocusControl = ListBoxVolt
        end
        object LVolt: TLabel
          Left = 15
          Top = 151
          Width = 170
          Height = 30
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Folder: ooooooooooooooooooooooo'
          WordWrap = True
        end
        object ListBoxVolt: TListBox
          Left = 16
          Top = 38
          Width = 98
          Height = 107
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemHeight = 16
          Items.Strings = (
            '-1'
            '-3'
            '-4')
          ParentFont = False
          Sorted = True
          TabOrder = 0
          OnClick = ListBoxVoltClick
        end
        object ButVoltAdd: TButton
          Left = 120
          Top = 49
          Width = 70
          Height = 25
          Caption = '&Add'
          TabOrder = 1
          OnClick = ButVoltAddClick
        end
        object ButVoltDel: TButton
          Left = 120
          Top = 80
          Width = 70
          Height = 25
          Caption = 'D&el'
          TabOrder = 2
          OnClick = ButVoltDelClick
        end
        object ButVoltClear: TButton
          Left = 120
          Top = 115
          Width = 70
          Height = 25
          Caption = 'C&lear'
          TabOrder = 3
          OnClick = ButVoltClearClick
        end
        object ButtonVolt: TButton
          Left = 24
          Top = 210
          Width = 153
          Height = 25
          Cursor = crHandPoint
          Caption = 'Crea&te Files'
          TabOrder = 4
          OnClick = ButtonVoltClick
        end
        object CheckBoxLnIT2: TCheckBox
          Left = 8
          Top = 187
          Width = 75
          Height = 17
          Caption = 'ln( I /T^2 )'
          TabOrder = 5
        end
        object CheckBoxnLnIT2: TCheckBox
          Left = 76
          Top = 187
          Width = 84
          Height = 17
          Caption = 'n ln( I /T^2 )'
          TabOrder = 6
        end
        object CBVoc: TCheckBox
          Left = 154
          Top = 187
          Width = 40
          Height = 17
          Caption = 'Voc'
          TabOrder = 7
        end
      end
      object ScrollBox2: TScrollBox
        Left = 525
        Top = 6
        Width = 230
        Height = 390
        ParentBackground = True
        TabOrder = 4
        object GroupBoxParam0: TGroupBox
          Left = 0
          Top = 0
          Width = 208
          Height = 1550
          Caption = 'PARAMETERS OF CALCULATION'
          TabOrder = 0
          object GroupBox6: TGroupBox
            Left = 7
            Top = 462
            Width = 95
            Height = 178
            Caption = 'Norde'#39's function'
            Color = clBtnHighlight
            ParentBackground = False
            ParentColor = False
            TabOrder = 3
            object LabelNordRange: TLabel
              Left = 27
              Top = 16
              Width = 34
              Height = 14
              Caption = 'Range:'
            end
            object LabelNordXmin: TLabel
              Left = 3
              Top = 30
              Width = 29
              Height = 14
              Caption = 'Xmin: '
            end
            object LabelNordYmin: TLabel
              Left = 3
              Top = 45
              Width = 30
              Height = 14
              Caption = 'Ymin: '
            end
            object LabelNordXmax: TLabel
              Left = 3
              Top = 60
              Width = 33
              Height = 14
              Caption = 'Xmax: '
            end
            object LabelNordYmax: TLabel
              Left = 3
              Top = 75
              Width = 34
              Height = 14
              Caption = 'Ymax: '
            end
            object LabelNordParam: TLabel
              Left = 16
              Top = 106
              Width = 58
              Height = 14
              Caption = 'Parameters:'
            end
            object LabelNordGamma: TLabel
              Left = 3
              Top = 120
              Width = 37
              Height = 14
              Caption = 'gamma:'
            end
            object ButtonParamNord: TButton
              Left = 17
              Top = 139
              Width = 56
              Height = 25
              Caption = 'Edit'
              TabOrder = 0
              OnClick = ButtonParamCibClick
            end
          end
          object GroupBoxParamExp: TGroupBox
            Left = 5
            Top = 19
            Width = 200
            Height = 95
            BiDiMode = bdRightToLeft
            Caption = 'Direct Aproximation'
            Color = clBtnHighlight
            ParentBackground = False
            ParentBiDiMode = False
            ParentColor = False
            TabOrder = 0
            object LabelExp: TLabel
              Left = 4
              Top = 13
              Width = 192
              Height = 14
              Caption = 'I0[exp(e(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph'
            end
            object LabelExpXmin: TLabel
              Left = 53
              Top = 60
              Width = 29
              Height = 14
              BiDiMode = bdLeftToRight
              Caption = 'Xmin: '
              ParentBiDiMode = False
            end
            object LabelExpYmin: TLabel
              Left = 120
              Top = 60
              Width = 30
              Height = 14
              BiDiMode = bdLeftToRight
              Caption = 'Ymin: '
              ParentBiDiMode = False
            end
            object LabelExpXmax: TLabel
              Left = 49
              Top = 75
              Width = 33
              Height = 14
              BiDiMode = bdLeftToRight
              Caption = 'Xmax: '
              ParentBiDiMode = False
            end
            object LabelExpYmax: TLabel
              Left = 118
              Top = 75
              Width = 34
              Height = 14
              BiDiMode = bdLeftToRight
              Caption = 'Ymax: '
              ParentBiDiMode = False
            end
            object Label2: TLabel
              Left = 13
              Top = 60
              Width = 34
              Height = 14
              BiDiMode = bdLeftToRight
              Caption = 'Range:'
              ParentBiDiMode = False
            end
            object LabelExpIph: TLabel
              Left = 20
              Top = 35
              Width = 58
              Height = 14
              BiDiMode = bdLeftToRight
              Caption = 'Iph is varied'
              ParentBiDiMode = False
            end
            object ButtonParamExp: TButton
              Left = 135
              Top = 30
              Width = 60
              Height = 25
              Caption = 'Edit'
              TabOrder = 0
              OnClick = ButtonParamCibClick
            end
          end
          object GroupBoxParamChung: TGroupBox
            Left = 7
            Top = 335
            Width = 95
            Height = 122
            Caption = 'Cheung'#39's function'
            Color = clCream
            ParentBackground = False
            ParentColor = False
            TabOrder = 1
            object LabeChungRange: TLabel
              Left = 27
              Top = 16
              Width = 34
              Height = 14
              Caption = 'Range:'
            end
            object LabelChungXmin: TLabel
              Left = 3
              Top = 30
              Width = 29
              Height = 14
              Caption = 'Xmin: '
            end
            object LabelChungYmin: TLabel
              Left = 3
              Top = 45
              Width = 30
              Height = 14
              Caption = 'Ymin: '
            end
            object LabelChungXmax: TLabel
              Left = 3
              Top = 60
              Width = 33
              Height = 14
              Caption = 'Xmax: '
            end
            object LabelChungYmax: TLabel
              Left = 3
              Top = 75
              Width = 34
              Height = 14
              Caption = 'Ymax: '
            end
            object ButtonParamChung: TButton
              Left = 17
              Top = 94
              Width = 56
              Height = 25
              Caption = 'Edit'
              TabOrder = 0
              OnClick = ButtonParamCibClick
            end
          end
          object GroupBox5: TGroupBox
            Left = 108
            Top = 335
            Width = 95
            Height = 122
            Caption = 'H funcion'
            Color = clCream
            ParentBackground = False
            ParentColor = False
            TabOrder = 2
            object LabelHRang: TLabel
              Left = 24
              Top = 16
              Width = 34
              Height = 14
              Caption = 'Range:'
            end
            object LabelHXmin: TLabel
              Left = 3
              Top = 30
              Width = 29
              Height = 14
              Caption = 'Xmin: '
            end
            object LabelHYmin: TLabel
              Left = 3
              Top = 45
              Width = 30
              Height = 14
              Caption = 'Ymin: '
            end
            object LabelHXmax: TLabel
              Left = 3
              Top = 60
              Width = 33
              Height = 14
              Caption = 'Xmax: '
            end
            object LabelHYmax: TLabel
              Left = 3
              Top = 75
              Width = 34
              Height = 14
              Caption = 'Ymax: '
            end
            object ButtonParamH: TButton
              Left = 17
              Top = 94
              Width = 56
              Height = 25
              Caption = 'Edit'
              TabOrder = 0
              OnClick = ButtonParamCibClick
            end
          end
          object GroupBoxEx: TGroupBox
            Left = 107
            Top = 462
            Width = 95
            Height = 122
            Caption = 'I=I0exp(eV/nkT)'
            Color = clBtnHighlight
            ParentBackground = False
            ParentColor = False
            TabOrder = 4
            object LabelExRange: TLabel
              Left = 27
              Top = 16
              Width = 34
              Height = 14
              Caption = 'Range:'
            end
            object LabelExXmin: TLabel
              Left = 3
              Top = 30
              Width = 29
              Height = 14
              Caption = 'Xmin: '
            end
            object LabelExYmin: TLabel
              Left = 3
              Top = 45
              Width = 30
              Height = 14
              Caption = 'Ymin: '
            end
            object LabelExXmax: TLabel
              Left = 3
              Top = 60
              Width = 33
              Height = 14
              Caption = 'Xmax: '
            end
            object LabelExYmax: TLabel
              Left = 3
              Top = 75
              Width = 34
              Height = 14
              Caption = 'Ymax: '
            end
            object ButtonParamEx: TButton
              Left = 17
              Top = 94
              Width = 56
              Height = 25
              Caption = 'Edit'
              TabOrder = 0
              OnClick = ButtonParamCibClick
            end
          end
          object GroupBox7: TGroupBox
            Left = 7
            Top = 650
            Width = 95
            Height = 50
            Caption = 'rectification volt.'
            Color = clCream
            ParentBackground = False
            ParentColor = False
            TabOrder = 5
            object LabelRect: TLabel
              Left = 27
              Top = 12
              Width = 32
              Height = 14
              Caption = '0.13 V'
            end
            object ButtonParamRect: TButton
              Left = 17
              Top = 25
              Width = 56
              Height = 23
              Caption = 'Edit'
              TabOrder = 0
              OnClick = ButtonParamRectClick
            end
          end
          object GroupBoxNss: TGroupBox
            Left = 107
            Top = 587
            Width = 95
            Height = 122
            Caption = 'Nss range'
            Color = clCream
            ParentBackground = False
            ParentColor = False
            TabOrder = 6
            object LabelNssRange: TLabel
              Left = 24
              Top = 16
              Width = 34
              Height = 14
              Caption = 'Range:'
            end
            object LabelNssXmin: TLabel
              Left = 3
              Top = 30
              Width = 29
              Height = 14
              Caption = 'Xmin: '
            end
            object LabelNssYmin: TLabel
              Left = 3
              Top = 45
              Width = 30
              Height = 14
              Caption = 'Ymin: '
            end
            object LabelNssXmax: TLabel
              Left = 3
              Top = 60
              Width = 33
              Height = 14
              Caption = 'Xmax: '
            end
            object LabelNssYmax: TLabel
              Left = 3
              Top = 75
              Width = 34
              Height = 14
              Caption = 'Ymax: '
            end
            object ButtonParamNss: TButton
              Left = 17
              Top = 94
              Width = 56
              Height = 25
              Caption = 'Edit'
              TabOrder = 0
              OnClick = ButtonParamCibClick
            end
          end
          object GroupBoxKam2: TGroupBox
            Left = 107
            Top = 715
            Width = 95
            Height = 122
            Caption = 'Kaminski funct II'
            Color = clBtnHighlight
            ParentBackground = False
            ParentColor = False
            TabOrder = 7
            object LabelKam2Range: TLabel
              Left = 27
              Top = 16
              Width = 34
              Height = 14
              Caption = 'Range:'
            end
            object LabelKam2Xmin: TLabel
              Left = 3
              Top = 30
              Width = 29
              Height = 14
              Caption = 'Xmin: '
            end
            object LabelKam2Ymin: TLabel
              Left = 3
              Top = 45
              Width = 30
              Height = 14
              Caption = 'Ymin: '
            end
            object LabelKam2Xmax: TLabel
              Left = 3
              Top = 60
              Width = 33
              Height = 14
              Caption = 'Xmax: '
            end
            object LabelKam2Ymax: TLabel
              Left = 3
              Top = 75
              Width = 34
              Height = 14
              Caption = 'Ymax: '
            end
            object ButtonParamKam2: TButton
              Left = 17
              Top = 94
              Width = 56
              Height = 25
              Caption = 'Edit'
              TabOrder = 0
              OnClick = ButtonParamCibClick
            end
          end
          object GroupBoxKam1: TGroupBox
            Left = 7
            Top = 715
            Width = 95
            Height = 122
            Caption = 'Kaminski funct I'
            Color = clBtnHighlight
            ParentBackground = False
            ParentColor = False
            TabOrder = 8
            object LabelKam1Range: TLabel
              Left = 27
              Top = 16
              Width = 34
              Height = 14
              Caption = 'Range:'
            end
            object LabelKam1Xmin: TLabel
              Left = 3
              Top = 30
              Width = 29
              Height = 14
              Caption = 'Xmin: '
            end
            object LabelKam1Ymin: TLabel
              Left = 3
              Top = 45
              Width = 30
              Height = 14
              Caption = 'Ymin: '
            end
            object LabelKam1Xmax: TLabel
              Left = 3
              Top = 60
              Width = 33
              Height = 14
              Caption = 'Xmax: '
            end
            object LabelKam1Ymax: TLabel
              Left = 3
              Top = 75
              Width = 34
              Height = 14
              Caption = 'Ymax: '
            end
            object ButtonParamKam1: TButton
              Left = 17
              Top = 94
              Width = 56
              Height = 25
              Caption = 'Edit'
              TabOrder = 0
              OnClick = ButtonParamCibClick
            end
          end
          object GroupBoxGr1: TGroupBox
            Left = 7
            Top = 843
            Width = 95
            Height = 122
            Caption = 'Gromov funct I'
            Color = clCream
            ParentBackground = False
            ParentColor = False
            TabOrder = 9
            object LabelGr1Range: TLabel
              Left = 27
              Top = 16
              Width = 34
              Height = 14
              Caption = 'Range:'
            end
            object LabelGr1Xmin: TLabel
              Left = 3
              Top = 30
              Width = 29
              Height = 14
              Caption = 'Xmin: '
            end
            object LabelGr1Ymin: TLabel
              Left = 3
              Top = 45
              Width = 30
              Height = 14
              Caption = 'Ymin: '
            end
            object LabelGr1Xmax: TLabel
              Left = 3
              Top = 60
              Width = 33
              Height = 14
              Caption = 'Xmax: '
            end
            object LabelGr1Ymax: TLabel
              Left = 3
              Top = 75
              Width = 34
              Height = 14
              Caption = 'Ymax: '
            end
            object ButtonParamGr1: TButton
              Left = 17
              Top = 94
              Width = 56
              Height = 25
              Caption = 'Edit'
              TabOrder = 0
              OnClick = ButtonParamCibClick
            end
          end
          object GroupBoxGr2: TGroupBox
            Left = 108
            Top = 843
            Width = 95
            Height = 122
            Caption = 'Gromov funct II'
            Color = clCream
            ParentBackground = False
            ParentColor = False
            TabOrder = 10
            object LabelGr2Range: TLabel
              Left = 27
              Top = 16
              Width = 34
              Height = 14
              Caption = 'Range:'
            end
            object LabelGr2Xmin: TLabel
              Left = 3
              Top = 30
              Width = 29
              Height = 14
              Caption = 'Xmin: '
            end
            object LabelGr2Ymin: TLabel
              Left = 3
              Top = 45
              Width = 30
              Height = 14
              Caption = 'Ymin: '
            end
            object LabelGr2Xmax: TLabel
              Left = 3
              Top = 60
              Width = 33
              Height = 14
              Caption = 'Xmax: '
            end
            object LabelGr2Ymax: TLabel
              Left = 3
              Top = 75
              Width = 34
              Height = 14
              Caption = 'Ymax: '
            end
            object ButtonParamGr2: TButton
              Left = 17
              Top = 94
              Width = 56
              Height = 25
              Caption = 'Edit'
              TabOrder = 0
              OnClick = ButtonParamCibClick
            end
          end
          object GroupBoxBh: TGroupBox
            Left = 7
            Top = 966
            Width = 195
            Height = 52
            Caption = 'Bohlin method, parameters'
            Color = clBtnHighlight
            ParentBackground = False
            ParentColor = False
            TabOrder = 11
            object LabBohGam1: TLabel
              Left = 11
              Top = 15
              Width = 43
              Height = 14
              Caption = 'gamma1:'
            end
            object LabBohGam2: TLabel
              Left = 11
              Top = 35
              Width = 43
              Height = 14
              Caption = 'gamma2:'
            end
            object ButtonParamBh: TButton
              Left = 117
              Top = 20
              Width = 56
              Height = 25
              Caption = 'Edit'
              TabOrder = 0
              OnClick = ButtonParamCibClick
            end
          end
          object GroupBoxCib: TGroupBox
            Left = 7
            Top = 1019
            Width = 95
            Height = 122
            Caption = 'Cibils function'
            Color = clCream
            ParentBackground = False
            ParentColor = False
            TabOrder = 12
            object LabelCibRange: TLabel
              Left = 27
              Top = 16
              Width = 34
              Height = 14
              Caption = 'Range:'
            end
            object LabelCibXmin: TLabel
              Left = 3
              Top = 30
              Width = 29
              Height = 14
              Caption = 'Xmin: '
            end
            object LabelCibYmin: TLabel
              Left = 3
              Top = 45
              Width = 30
              Height = 14
              Caption = 'Ymin: '
            end
            object LabelCibXmax: TLabel
              Left = 3
              Top = 60
              Width = 33
              Height = 14
              Caption = 'Xmax: '
            end
            object LabelCibYmax: TLabel
              Left = 3
              Top = 75
              Width = 34
              Height = 14
              Caption = 'Ymax: '
            end
            object ButtonParamCib: TButton
              Left = 17
              Top = 94
              Width = 56
              Height = 25
              Caption = 'Edit'
              TabOrder = 0
              OnClick = ButtonParamCibClick
            end
          end
          object GroupBoxLee: TGroupBox
            Left = 108
            Top = 1019
            Width = 95
            Height = 122
            Caption = 'Lee function'
            Color = clCream
            ParentBackground = False
            ParentColor = False
            TabOrder = 13
            object LabelLeeRange: TLabel
              Left = 27
              Top = 16
              Width = 34
              Height = 14
              Caption = 'Range:'
            end
            object LabelLeeXmin: TLabel
              Left = 3
              Top = 30
              Width = 29
              Height = 14
              Caption = 'Xmin: '
            end
            object LabelLeeYmin: TLabel
              Left = 3
              Top = 45
              Width = 30
              Height = 14
              Caption = 'Ymin: '
            end
            object LabelLeeXmax: TLabel
              Left = 3
              Top = 60
              Width = 33
              Height = 14
              Caption = 'Xmax: '
            end
            object LabelLeeYmax: TLabel
              Left = 3
              Top = 75
              Width = 34
              Height = 14
              Caption = 'Ymax: '
            end
            object ButtonParamLee: TButton
              Left = 17
              Top = 94
              Width = 56
              Height = 25
              Caption = 'Edit'
              TabOrder = 0
              OnClick = ButtonParamCibClick
            end
          end
          object GroupBoxWer: TGroupBox
            Left = 7
            Top = 1144
            Width = 95
            Height = 122
            Caption = 'Werner function'
            Color = clBtnHighlight
            ParentBackground = False
            ParentColor = False
            TabOrder = 14
            object LabelWerRange: TLabel
              Left = 27
              Top = 16
              Width = 34
              Height = 14
              Caption = 'Range:'
            end
            object LabelWerXmin: TLabel
              Left = 3
              Top = 30
              Width = 29
              Height = 14
              Caption = 'Xmin: '
            end
            object LabelWerYmin: TLabel
              Left = 3
              Top = 45
              Width = 30
              Height = 14
              Caption = 'Ymin: '
            end
            object LabelWerXmax: TLabel
              Left = 3
              Top = 60
              Width = 33
              Height = 14
              Caption = 'Xmax: '
            end
            object LabelWerYmax: TLabel
              Left = 3
              Top = 75
              Width = 34
              Height = 14
              Caption = 'Ymax: '
            end
            object ButtonParamWer: TButton
              Left = 17
              Top = 94
              Width = 56
              Height = 25
              Caption = 'Edit'
              TabOrder = 0
              OnClick = ButtonParamCibClick
            end
          end
          object GroupBoxMikh: TGroupBox
            Left = 108
            Top = 1144
            Width = 95
            Height = 122
            Caption = 'Mikhelashili meth'
            Color = clBtnHighlight
            ParentBackground = False
            ParentColor = False
            TabOrder = 15
            object LabelMikhRange: TLabel
              Left = 27
              Top = 11
              Width = 34
              Height = 14
              Caption = 'Range:'
            end
            object LabelMikhXmin: TLabel
              Left = 3
              Top = 30
              Width = 29
              Height = 14
              Caption = 'Xmin: '
            end
            object LabelMikhYmin: TLabel
              Left = 3
              Top = 45
              Width = 30
              Height = 14
              Caption = 'Ymin: '
            end
            object LabelMikhXmax: TLabel
              Left = 3
              Top = 60
              Width = 33
              Height = 14
              Caption = 'Xmax: '
            end
            object LabelMikhYmax: TLabel
              Left = 3
              Top = 75
              Width = 34
              Height = 14
              Caption = 'Ymax: '
            end
            object ButtonParamMikh: TButton
              Left = 17
              Top = 94
              Width = 56
              Height = 25
              Caption = 'Edit'
              TabOrder = 0
              OnClick = ButtonParamCibClick
            end
          end
          object GroupBoxIvan: TGroupBox
            Left = 7
            Top = 1268
            Width = 95
            Height = 122
            Caption = 'Ivanov method'
            Color = clCream
            ParentBackground = False
            ParentColor = False
            TabOrder = 16
            object LabelIvanRange: TLabel
              Left = 27
              Top = 16
              Width = 34
              Height = 14
              Caption = 'Range:'
            end
            object LabelIvanXmin: TLabel
              Left = 3
              Top = 30
              Width = 29
              Height = 14
              Caption = 'Xmin: '
            end
            object LabelIvanYmin: TLabel
              Left = 3
              Top = 45
              Width = 30
              Height = 14
              Caption = 'Ymin: '
            end
            object LabelIvanXmax: TLabel
              Left = 3
              Top = 60
              Width = 33
              Height = 14
              Caption = 'Xmax: '
            end
            object LabelIvanYmax: TLabel
              Left = 3
              Top = 75
              Width = 34
              Height = 14
              Caption = 'Ymax: '
            end
            object ButtonParamIvan: TButton
              Left = 17
              Top = 94
              Width = 56
              Height = 25
              Caption = 'Edit'
              TabOrder = 0
              OnClick = ButtonParamCibClick
            end
          end
          object GroupBoxE2F: TGroupBox
            Left = 7
            Top = 1392
            Width = 95
            Height = 133
            Caption = 'I/[1-exp(-qV/kT)]'
            Color = clBtnHighlight
            ParentBackground = False
            ParentColor = False
            TabOrder = 17
            object LabelE2FRange: TLabel
              Left = 27
              Top = 28
              Width = 34
              Height = 14
              Caption = 'Range:'
            end
            object LabelE2FXmin: TLabel
              Left = 3
              Top = 41
              Width = 29
              Height = 14
              Caption = 'Xmin: '
            end
            object LabelE2FYmin: TLabel
              Left = 3
              Top = 57
              Width = 30
              Height = 14
              Caption = 'Ymin: '
            end
            object LabelE2FXmax: TLabel
              Left = 3
              Top = 71
              Width = 33
              Height = 14
              Caption = 'Xmax: '
            end
            object LabelE2FYmax: TLabel
              Left = 3
              Top = 86
              Width = 34
              Height = 14
              Caption = 'Ymax: '
            end
            object LabelE2FCaption: TLabel
              Left = 24
              Top = 13
              Width = 38
              Height = 13
              Caption = 'forward'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMenuHighlight
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object ButtonParamE2F: TButton
              Left = 17
              Top = 106
              Width = 56
              Height = 25
              Caption = 'Edit'
              TabOrder = 0
              OnClick = ButtonParamCibClick
            end
          end
          object GroupBoxE2R: TGroupBox
            Left = 108
            Top = 1392
            Width = 95
            Height = 133
            Caption = 'I/[1-exp(-qV/kT)]'
            Color = clBtnHighlight
            ParentBackground = False
            ParentColor = False
            TabOrder = 18
            object LabelE2RRange: TLabel
              Left = 27
              Top = 28
              Width = 34
              Height = 14
              Caption = 'Range:'
            end
            object LabelE2RXmin: TLabel
              Left = 3
              Top = 41
              Width = 29
              Height = 14
              Caption = 'Xmin: '
            end
            object LabelE2RYmin: TLabel
              Left = 3
              Top = 57
              Width = 30
              Height = 14
              Caption = 'Ymin: '
            end
            object LabelE2RXmax: TLabel
              Left = 3
              Top = 71
              Width = 33
              Height = 14
              Caption = 'Xmax: '
            end
            object LabelE2RYmax: TLabel
              Left = 3
              Top = 86
              Width = 34
              Height = 14
              Caption = 'Ymax: '
            end
            object LabelE2RCaption: TLabel
              Left = 24
              Top = 13
              Width = 37
              Height = 13
              Caption = 'reverse'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMenuHighlight
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object ButtonParamE2R: TButton
              Left = 17
              Top = 106
              Width = 56
              Height = 25
              Caption = 'Edit'
              TabOrder = 0
              OnClick = ButtonParamCibClick
            end
          end
          object GroupParamLam: TGroupBox
            Left = 5
            Top = 120
            Width = 200
            Height = 95
            BiDiMode = bdRightToLeft
            Caption = 'Lambert Aproximation'
            Color = clCream
            ParentBackground = False
            ParentBiDiMode = False
            ParentColor = False
            TabOrder = 19
            object LabelLam: TLabel
              Left = 4
              Top = 13
              Width = 192
              Height = 14
              Caption = 'I0[exp(e(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph'
            end
            object LabelLamXmin: TLabel
              Left = 53
              Top = 60
              Width = 29
              Height = 14
              BiDiMode = bdLeftToRight
              Caption = 'Xmin: '
              ParentBiDiMode = False
            end
            object LabelLamYmin: TLabel
              Left = 120
              Top = 60
              Width = 30
              Height = 14
              BiDiMode = bdLeftToRight
              Caption = 'Ymin: '
              ParentBiDiMode = False
            end
            object LabelLamXmax: TLabel
              Left = 49
              Top = 75
              Width = 33
              Height = 14
              BiDiMode = bdLeftToRight
              Caption = 'Xmax: '
              ParentBiDiMode = False
            end
            object LabelLamYmax: TLabel
              Left = 118
              Top = 75
              Width = 34
              Height = 14
              BiDiMode = bdLeftToRight
              Caption = 'Ymax: '
              ParentBiDiMode = False
            end
            object Label16: TLabel
              Left = 13
              Top = 60
              Width = 34
              Height = 14
              BiDiMode = bdLeftToRight
              Caption = 'Range:'
              ParentBiDiMode = False
            end
            object LabelLamIph: TLabel
              Left = 20
              Top = 35
              Width = 58
              Height = 14
              BiDiMode = bdLeftToRight
              Caption = 'Iph is varied'
              ParentBiDiMode = False
            end
            object ButtonParamLam: TButton
              Left = 135
              Top = 30
              Width = 60
              Height = 25
              Caption = 'Edit'
              TabOrder = 0
              OnClick = ButtonParamCibClick
            end
          end
          object GroupBoxParamDE: TGroupBox
            Left = 5
            Top = 221
            Width = 200
            Height = 111
            BiDiMode = bdRightToLeft
            Caption = 'Evolution Algorithm'
            Color = clBtnHighlight
            ParentBackground = False
            ParentBiDiMode = False
            ParentColor = False
            TabOrder = 20
            object LabelDE: TLabel
              Left = 4
              Top = 13
              Width = 192
              Height = 14
              Caption = 'I0[exp(e(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph'
            end
            object LabDEDD: TLabel
              Left = 20
              Top = 30
              Width = 128
              Height = 14
              BiDiMode = bdLeftToRight
              Caption = 'Double diod does not used'
              ParentBiDiMode = False
            end
            object LabelDEXmin: TLabel
              Left = 53
              Top = 77
              Width = 29
              Height = 14
              BiDiMode = bdLeftToRight
              Caption = 'Xmin: '
              ParentBiDiMode = False
            end
            object LabelDEYmin: TLabel
              Left = 120
              Top = 77
              Width = 30
              Height = 14
              BiDiMode = bdLeftToRight
              Caption = 'Ymin: '
              ParentBiDiMode = False
            end
            object LabelDEXmax: TLabel
              Left = 49
              Top = 92
              Width = 33
              Height = 14
              BiDiMode = bdLeftToRight
              Caption = 'Xmax: '
              ParentBiDiMode = False
            end
            object LabelDEYmax: TLabel
              Left = 118
              Top = 92
              Width = 34
              Height = 14
              BiDiMode = bdLeftToRight
              Caption = 'Ymax: '
              ParentBiDiMode = False
            end
            object Label25: TLabel
              Left = 13
              Top = 77
              Width = 34
              Height = 14
              BiDiMode = bdLeftToRight
              Caption = 'Range:'
              ParentBiDiMode = False
            end
            object LabelDEIph: TLabel
              Left = 20
              Top = 50
              Width = 58
              Height = 14
              BiDiMode = bdLeftToRight
              Caption = 'Iph is varied'
              ParentBiDiMode = False
            end
            object ButtonParamDE: TButton
              Left = 135
              Top = 45
              Width = 60
              Height = 25
              Caption = 'Edit'
              TabOrder = 0
              OnClick = ButtonParamCibClick
            end
          end
        end
      end
      object ScrollBox3: TScrollBox
        Left = 206
        Top = 6
        Width = 319
        Height = 390
        VertScrollBar.Position = 1373
        ParentBackground = True
        TabOrder = 5
        object GroupBox12: TGroupBox
          Left = -1
          Top = -1373
          Width = 297
          Height = 1759
          Caption = 'CREATE FILES AND DIRECTORIES'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
          object LForwRs: TLabel
            Tag = 100
            Left = 16
            Top = 103
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object LabForwRs: TLabel
            Tag = 100
            Left = 56
            Top = 103
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            BiDiMode = bdLeftToRight
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentBiDiMode = False
            ParentColor = False
            ParentFont = False
          end
          object LChung: TLabel
            Tag = 101
            Left = 16
            Top = 156
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object LabChung: TLabel
            Tag = 101
            Left = 56
            Top = 156
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object LHfunc: TLabel
            Tag = 102
            Left = 16
            Top = 336
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object LabHfunc: TLabel
            Tag = 102
            Left = 56
            Top = 336
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object LabNord: TLabel
            Tag = 103
            Left = 56
            Top = 406
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object LNord: TLabel
            Tag = 103
            Left = 16
            Top = 406
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object LaN: TLabel
            Tag = 104
            Left = 16
            Top = 476
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object LabN: TLabel
            Tag = 104
            Left = 56
            Top = 476
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            BiDiMode = bdLeftToRight
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentBiDiMode = False
            ParentColor = False
            ParentFont = False
          end
          object LNss: TLabel
            Tag = 105
            Left = 16
            Top = 585
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object LabNss: TLabel
            Tag = 105
            Left = 56
            Top = 585
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            BiDiMode = bdLeftToRight
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentBiDiMode = False
            ParentColor = False
            ParentFont = False
          end
          object LRev: TLabel
            Tag = 106
            Left = 16
            Top = 630
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object LabRev: TLabel
            Tag = 106
            Left = 56
            Top = 630
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object LKam1: TLabel
            Tag = 107
            Left = 16
            Top = 207
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object LabKam1: TLabel
            Tag = 107
            Left = 56
            Top = 207
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object LKam2: TLabel
            Tag = 108
            Left = 16
            Top = 260
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object LabKam2: TLabel
            Tag = 108
            Left = 56
            Top = 260
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object Bevel3: TBevel
            Left = 0
            Top = 47
            Width = 297
            Height = 2
          end
          object Bevel4: TBevel
            Left = 0
            Top = 120
            Width = 297
            Height = 2
            Style = bsRaised
          end
          object Bevel5: TBevel
            Left = 0
            Top = 173
            Width = 297
            Height = 2
            Style = bsRaised
          end
          object Bevel6: TBevel
            Left = 0
            Top = 220
            Width = 297
            Height = 2
            Style = bsRaised
          end
          object Bevel7: TBevel
            Left = 0
            Top = 273
            Width = 297
            Height = 2
            Style = bsRaised
          end
          object Bevel8: TBevel
            Left = 0
            Top = 349
            Width = 297
            Height = 2
            Style = bsRaised
          end
          object Bevel9: TBevel
            Left = 0
            Top = 419
            Width = 297
            Height = 2
            Style = bsRaised
          end
          object Bevel10: TBevel
            Left = 0
            Top = 489
            Width = 297
            Height = 2
            Style = bsRaised
          end
          object Bevel11: TBevel
            Left = 0
            Top = 599
            Width = 297
            Height = 2
            Style = bsRaised
          end
          object Bevel12: TBevel
            Left = -3
            Top = 649
            Width = 297
            Height = 2
            Style = bsRaised
          end
          object LGr1: TLabel
            Tag = 109
            Left = 16
            Top = 688
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object LabGr1: TLabel
            Tag = 109
            Left = 56
            Top = 688
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object Bevel13: TBevel
            Left = -3
            Top = 701
            Width = 297
            Height = 2
            Style = bsRaised
          end
          object LGr2: TLabel
            Tag = 110
            Left = 16
            Top = 740
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object LabGr2: TLabel
            Tag = 110
            Left = 56
            Top = 740
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object LabCib: TLabel
            Tag = 111
            Left = 54
            Top = 793
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object LCib: TLabel
            Tag = 111
            Left = 14
            Top = 793
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object Bevel14: TBevel
            Left = -3
            Top = 754
            Width = 297
            Height = 2
            Style = bsRaised
          end
          object Bevel16: TBevel
            Left = 0
            Top = 807
            Width = 297
            Height = 2
            Style = bsRaised
          end
          object LabLee: TLabel
            Tag = 112
            Left = 55
            Top = 843
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object LLee: TLabel
            Tag = 112
            Left = 15
            Top = 843
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object Bevel17: TBevel
            Left = 0
            Top = 860
            Width = 297
            Height = 2
            Style = bsRaised
          end
          object LabWer: TLabel
            Tag = 113
            Left = 55
            Top = 895
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object LWer: TLabel
            Tag = 113
            Left = 15
            Top = 895
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object Bevel19: TBevel
            Left = 0
            Top = 909
            Width = 297
            Height = 2
            Style = bsRaised
          end
          object LabMAlpha: TLabel
            Tag = 114
            Left = 55
            Top = 955
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object LMAlpha: TLabel
            Tag = 114
            Left = 15
            Top = 955
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object LabelMikhMethod: TLabel
            Left = 104
            Top = 914
            Width = 97
            Height = 14
            Caption = 'Mikhelashvili method'
          end
          object LMBetta: TLabel
            Tag = 115
            Left = 15
            Top = 1003
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object LabMBetta: TLabel
            Tag = 115
            Left = 55
            Top = 1003
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object LabMN: TLabel
            Tag = 116
            Left = 55
            Top = 1055
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object LMN: TLabel
            Tag = 116
            Left = 15
            Top = 1055
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object LabMRs: TLabel
            Tag = 117
            Left = 54
            Top = 1110
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object LMRs: TLabel
            Tag = 117
            Left = 14
            Top = 1110
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object Bevel21: TBevel
            Left = 0
            Top = 1125
            Width = 297
            Height = 2
            Style = bsRaised
          end
          object LDit: TLabel
            Tag = 118
            Left = 15
            Top = 1180
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object LabDit: TLabel
            Tag = 118
            Left = 55
            Top = 1180
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object Bevel22: TBevel
            Left = 0
            Top = 1194
            Width = 297
            Height = 3
            Style = bsRaised
          end
          object LExp2F: TLabel
            Tag = 119
            Left = 15
            Top = 1255
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object LabExp2F: TLabel
            Tag = 119
            Left = 55
            Top = 1255
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object Bevel23: TBevel
            Left = 0
            Top = 1269
            Width = 297
            Height = 3
            Style = bsRaised
          end
          object LabExp2R: TLabel
            Tag = 120
            Left = 55
            Top = 1330
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object LExp2R: TLabel
            Tag = 120
            Left = 15
            Top = 1330
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object Bevel24: TBevel
            Left = 0
            Top = 1345
            Width = 297
            Height = 3
            Style = bsRaised
          end
          object LabM_V: TLabel
            Tag = 121
            Left = 55
            Top = 1385
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object LM_V: TLabel
            Tag = 121
            Left = 15
            Top = 1385
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object Bevel26: TBevel
            Left = 0
            Top = 1399
            Width = 297
            Height = 3
            Style = bsRaised
          end
          object LFow_Nor: TLabel
            Tag = 122
            Left = 15
            Top = 1440
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object LabFow_Nor: TLabel
            Tag = 122
            Left = 55
            Top = 1440
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object Bevel27: TBevel
            Left = 0
            Top = 1453
            Width = 297
            Height = 3
            Style = bsRaised
          end
          object LFow_NorE: TLabel
            Tag = 123
            Left = 15
            Top = 1490
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object LabFow_NorE: TLabel
            Tag = 123
            Left = 55
            Top = 1490
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object Bevel28: TBevel
            Left = 0
            Top = 1506
            Width = 297
            Height = 4
            Style = bsRaised
          end
          object LabAbeles: TLabel
            Tag = 124
            Left = 55
            Top = 1547
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object LAbeles: TLabel
            Tag = 124
            Left = 15
            Top = 1547
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object Bevel29: TBevel
            Left = 0
            Top = 1562
            Width = 297
            Height = 3
            Style = bsRaised
          end
          object LabAbelesE: TLabel
            Tag = 125
            Left = 55
            Top = 1603
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object LAbelesE: TLabel
            Tag = 125
            Left = 15
            Top = 1603
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object Bevel30: TBevel
            Left = 0
            Top = 1617
            Width = 297
            Height = 3
            Style = bsRaised
          end
          object LabFr_Pool: TLabel
            Tag = 126
            Left = 55
            Top = 1658
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object LFr_Pool: TLabel
            Tag = 126
            Left = 15
            Top = 1658
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object Bevel31: TBevel
            Left = 0
            Top = 1671
            Width = 297
            Height = 3
            Style = bsRaised
          end
          object LabFr_PoolE: TLabel
            Tag = 127
            Left = 55
            Top = 1708
            Width = 233
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'd:'
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object LFr_PoolE: TLabel
            Tag = 127
            Left = 15
            Top = 1708
            Width = 33
            Height = 14
            Caption = 'Folder:'
            Enabled = False
          end
          object CBForwRs: TCheckBox
            Tag = 100
            Left = 16
            Top = 55
            Width = 97
            Height = 17
            Caption = 'Forward with Rs'
            TabOrder = 0
            OnClick = CBForwRsClick
          end
          object ButForwRs: TButton
            Left = 56
            Top = 77
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 1
            OnClick = RadioButtonM_VDblClick
          end
          object CBChung: TCheckBox
            Tag = 101
            Left = 16
            Top = 123
            Width = 105
            Height = 17
            Caption = 'Cheung'#39's function'
            TabOrder = 2
            OnClick = CBForwRsClick
          end
          object ButChung: TButton
            Left = 127
            Top = 128
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 3
            OnClick = RadioButtonM_VDblClick
          end
          object CBHfunc: TCheckBox
            Tag = 102
            Left = 16
            Top = 288
            Width = 105
            Height = 17
            Caption = 'H function'
            TabOrder = 4
            OnClick = CBForwRsClick
          end
          object ButHfunc: TButton
            Left = 56
            Top = 310
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 5
            OnClick = RadioButtonM_VDblClick
          end
          object CBNord: TCheckBox
            Tag = 103
            Left = 16
            Top = 358
            Width = 105
            Height = 17
            Caption = 'Norde'#39's func.'
            TabOrder = 6
            OnClick = CBForwRsClick
          end
          object ButNord: TButton
            Left = 56
            Top = 380
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 7
            OnClick = RadioButtonM_VDblClick
          end
          object CBN: TCheckBox
            Tag = 104
            Left = 16
            Top = 428
            Width = 97
            Height = 17
            Caption = 'Ideality factor'
            TabOrder = 8
            OnClick = CBForwRsClick
          end
          object ButtonN: TButton
            Left = 56
            Top = 450
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 9
            OnClick = RadioButtonM_VDblClick
          end
          object CBNss: TCheckBox
            Tag = 105
            Left = 16
            Top = 498
            Width = 97
            Height = 17
            Caption = 'Interface states'
            TabOrder = 10
            OnClick = CBForwRsClick
          end
          object ButNss: TButton
            Left = 20
            Top = 525
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 11
            OnClick = RadioButtonM_VDblClick
          end
          object CBRev: TCheckBox
            Tag = 106
            Left = 16
            Top = 607
            Width = 105
            Height = 17
            Caption = 'Reverse '
            TabOrder = 12
            OnClick = CBForwRsClick
          end
          object ButtonCreateFile: TButton
            Left = 132
            Top = 17
            Width = 153
            Height = 25
            Cursor = crHandPoint
            Caption = 'Create &Files'
            TabOrder = 13
            OnClick = ButtonCreateFileClick
          end
          object ButKam1: TButton
            Left = 127
            Top = 183
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 14
            OnClick = RadioButtonM_VDblClick
          end
          object CBKam1: TCheckBox
            Tag = 107
            Left = 16
            Top = 178
            Width = 105
            Height = 17
            Caption = 'Kaminski I function'
            TabOrder = 15
            OnClick = CBForwRsClick
          end
          object ButKam2: TButton
            Left = 127
            Top = 235
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 16
            OnClick = RadioButtonM_VDblClick
          end
          object CBKam2: TCheckBox
            Tag = 108
            Left = 16
            Top = 229
            Width = 108
            Height = 17
            Caption = 'Kaminski II function'
            TabOrder = 17
            OnClick = CBForwRsClick
          end
          object CBGr1: TCheckBox
            Tag = 109
            Left = 16
            Top = 657
            Width = 105
            Height = 17
            Caption = 'Gromov I function'
            TabOrder = 18
            OnClick = CBForwRsClick
          end
          object ButGr1: TButton
            Left = 127
            Top = 662
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 19
            OnClick = RadioButtonM_VDblClick
          end
          object CBGr2: TCheckBox
            Tag = 110
            Left = 16
            Top = 709
            Width = 105
            Height = 17
            Caption = 'Gromov II function'
            TabOrder = 20
            OnClick = CBForwRsClick
          end
          object ButGr2: TButton
            Left = 127
            Top = 714
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 21
            OnClick = RadioButtonM_VDblClick
          end
          object ButCib: TButton
            Left = 127
            Top = 767
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 22
            OnClick = RadioButtonM_VDblClick
          end
          object CBCib: TCheckBox
            Tag = 111
            Left = 14
            Top = 762
            Width = 105
            Height = 17
            Caption = 'Cibils function'
            TabOrder = 23
            OnClick = CBForwRsClick
          end
          object ButLee: TButton
            Left = 128
            Top = 817
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 24
            OnClick = RadioButtonM_VDblClick
          end
          object CBLee: TCheckBox
            Tag = 112
            Left = 15
            Top = 812
            Width = 105
            Height = 17
            Caption = 'Lee function'
            TabOrder = 25
            OnClick = CBForwRsClick
          end
          object ButWer: TButton
            Left = 128
            Top = 869
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 26
            OnClick = RadioButtonM_VDblClick
          end
          object CBWer: TCheckBox
            Tag = 113
            Left = 15
            Top = 864
            Width = 105
            Height = 17
            Caption = 'Werner function'
            TabOrder = 27
            OnClick = CBForwRsClick
          end
          object ButMAlpha: TButton
            Left = 128
            Top = 929
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 28
            OnClick = RadioButtonM_VDblClick
          end
          object CBMAlpha: TCheckBox
            Tag = 114
            Left = 15
            Top = 924
            Width = 105
            Height = 17
            Caption = 'Alpha function'
            TabOrder = 29
            OnClick = CBForwRsClick
          end
          object CBMBetta: TCheckBox
            Tag = 115
            Left = 15
            Top = 972
            Width = 105
            Height = 17
            Caption = 'Betta function'
            TabOrder = 30
            OnClick = CBForwRsClick
          end
          object ButMBetta: TButton
            Left = 128
            Top = 977
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 31
            OnClick = RadioButtonM_VDblClick
          end
          object ButMN: TButton
            Left = 128
            Top = 1029
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 32
            OnClick = RadioButtonM_VDblClick
          end
          object CBMN: TCheckBox
            Tag = 116
            Left = 15
            Top = 1024
            Width = 105
            Height = 17
            Caption = 'Ideality factor'
            TabOrder = 33
            OnClick = CBForwRsClick
          end
          object ButMRs: TButton
            Left = 124
            Top = 1081
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 34
            OnClick = RadioButtonM_VDblClick
          end
          object CBMRs: TCheckBox
            Tag = 117
            Left = 14
            Top = 1079
            Width = 105
            Height = 17
            Caption = 'Series resistance'
            TabOrder = 35
            OnClick = CBForwRsClick
          end
          object GroupBoxForwRs: TGroupBox
            Left = 142
            Top = 48
            Width = 152
            Height = 47
            Caption = 'Rs source'
            TabOrder = 36
            object GroupBoxForwRs_n: TGroupBox
              Left = 75
              Top = 5
              Width = 73
              Height = 40
              Caption = 'n source'
              TabOrder = 0
              object ComBForwRs_n: TComboBox
                Tag = 301
                Left = 4
                Top = 15
                Width = 66
                Height = 22
                Style = csDropDownList
                DropDownCount = 15
                ItemHeight = 14
                TabOrder = 0
              end
            end
            object ComBForwRs: TComboBox
              Tag = 301
              Left = 5
              Top = 15
              Width = 66
              Height = 22
              Style = csDropDownList
              DropDownCount = 15
              ItemHeight = 14
              TabOrder = 1
              OnChange = ComBForwRsChange
            end
          end
          object GroupBoxHfuncN: TGroupBox
            Left = 105
            Top = 281
            Width = 189
            Height = 47
            Caption = 'n source'
            TabOrder = 37
            object GroupBoxHfuncN_Rs: TGroupBox
              Left = 112
              Top = 5
              Width = 73
              Height = 40
              Caption = 'Rs source'
              TabOrder = 0
              object ComBHfuncN_Rs: TComboBox
                Tag = 302
                Left = 5
                Top = 15
                Width = 66
                Height = 22
                Style = csDropDownList
                DropDownCount = 15
                ItemHeight = 14
                TabOrder = 0
              end
            end
            object ComBHfuncN: TComboBox
              Tag = 302
              Left = 5
              Top = 15
              Width = 102
              Height = 22
              Style = csDropDownList
              DropDownCount = 15
              ItemHeight = 14
              TabOrder = 1
              OnChange = ComBForwRsChange
            end
          end
          object GroupBoxNordN: TGroupBox
            Left = 105
            Top = 351
            Width = 189
            Height = 47
            Caption = 'n source'
            TabOrder = 38
            object GroupBoxNordN_Rs: TGroupBox
              Left = 112
              Top = 5
              Width = 73
              Height = 40
              Caption = 'Rs source'
              TabOrder = 0
              object ComBNordN_Rs: TComboBox
                Tag = 303
                Left = 5
                Top = 15
                Width = 66
                Height = 22
                Style = csDropDownList
                DropDownCount = 15
                ItemHeight = 14
                TabOrder = 0
              end
            end
            object ComBNordN: TComboBox
              Tag = 303
              Left = 5
              Top = 15
              Width = 103
              Height = 22
              Style = csDropDownList
              DropDownCount = 15
              ItemHeight = 14
              TabOrder = 1
              OnChange = ComBForwRsChange
            end
          end
          object GroupBoxNRs: TGroupBox
            Left = 142
            Top = 421
            Width = 152
            Height = 47
            Caption = 'Rs source'
            TabOrder = 39
            object GroupBoxNRs_N: TGroupBox
              Left = 75
              Top = 5
              Width = 73
              Height = 40
              Caption = 'n source'
              TabOrder = 0
              object ComBNRs_n: TComboBox
                Tag = 304
                Left = 5
                Top = 15
                Width = 66
                Height = 22
                Style = csDropDownList
                DropDownCount = 15
                ItemHeight = 14
                TabOrder = 0
              end
            end
            object ComBNRs: TComboBox
              Tag = 304
              Left = 5
              Top = 15
              Width = 66
              Height = 22
              Style = csDropDownList
              DropDownCount = 15
              ItemHeight = 14
              TabOrder = 1
              OnChange = ComBForwRsChange
            end
          end
          object GroupBNssRs: TGroupBox
            Left = 142
            Top = 530
            Width = 152
            Height = 47
            Caption = 'Rs source'
            TabOrder = 40
            object GroupBNssRs_n: TGroupBox
              Left = 75
              Top = 5
              Width = 73
              Height = 40
              Caption = 'n source'
              TabOrder = 0
              object ComBNssRs_n: TComboBox
                Tag = 305
                Left = 4
                Top = 16
                Width = 66
                Height = 22
                Style = csDropDownList
                DropDownCount = 15
                ItemHeight = 14
                TabOrder = 0
              end
            end
            object ComBNssRs: TComboBox
              Tag = 305
              Left = 5
              Top = 15
              Width = 66
              Height = 22
              Style = csDropDownList
              DropDownCount = 15
              ItemHeight = 14
              TabOrder = 1
              OnChange = ComBForwRsChange
            end
          end
          object GroupBNssFb: TGroupBox
            Left = 180
            Top = 491
            Width = 114
            Height = 40
            Caption = 'Fb source'
            TabOrder = 41
            object ComboBNssFb: TComboBox
              Tag = 300
              Left = 5
              Top = 15
              Width = 103
              Height = 22
              Style = csDropDownList
              DropDownCount = 15
              ItemHeight = 14
              TabOrder = 0
            end
          end
          object GroupBNssNv: TGroupBox
            Left = 58
            Top = 515
            Width = 78
            Height = 46
            Caption = 'method n(V)'
            TabOrder = 42
            object RadButNssNvD: TRadioButton
              Left = 2
              Top = 11
              Width = 113
              Height = 17
              Caption = 'derivate'
              Checked = True
              TabOrder = 0
              TabStop = True
            end
            object RadButNssNvM: TRadioButton
              Left = 2
              Top = 27
              Width = 113
              Height = 17
              Caption = 'Mikhelashvili'
              TabOrder = 1
            end
          end
          object CBDit: TCheckBox
            Tag = 118
            Left = 14
            Top = 1128
            Width = 114
            Height = 18
            Caption = 'Dit (Ivanov method)'
            TabOrder = 43
            OnClick = CBForwRsClick
          end
          object ButDit: TButton
            Left = 77
            Top = 1146
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 44
            OnClick = RadioButtonM_VDblClick
          end
          object GroupBDit: TGroupBox
            Left = 142
            Top = 1127
            Width = 152
            Height = 47
            Caption = 'Rs source'
            TabOrder = 45
            object GroupBox32: TGroupBox
              Left = 75
              Top = 5
              Width = 73
              Height = 40
              Caption = 'n source'
              TabOrder = 0
              object ComBDitRs_n: TComboBox
                Tag = 306
                Left = 5
                Top = 15
                Width = 66
                Height = 22
                Style = csDropDownList
                DropDownCount = 15
                ItemHeight = 14
                TabOrder = 0
              end
            end
            object ComBDitRs: TComboBox
              Tag = 306
              Left = 5
              Top = 15
              Width = 66
              Height = 22
              Style = csDropDownList
              DropDownCount = 15
              ItemHeight = 14
              TabOrder = 1
              OnChange = ComBForwRsChange
            end
          end
          object CBExp2F: TCheckBox
            Tag = 119
            Left = 14
            Top = 1202
            Width = 103
            Height = 24
            Caption = 'I/[1-exp(-qV/kT)], forward'
            TabOrder = 46
            WordWrap = True
            OnClick = CBForwRsClick
          end
          object ButExp2F: TButton
            Left = 77
            Top = 1224
            Width = 25
            Height = 24
            Caption = '?'
            TabOrder = 47
            OnClick = RadioButtonM_VDblClick
          end
          object GroupBExp2F: TGroupBox
            Left = 133
            Top = 1202
            Width = 151
            Height = 47
            Caption = 'Rs source'
            TabOrder = 48
            object GroupBox33: TGroupBox
              Left = 75
              Top = 5
              Width = 73
              Height = 40
              Caption = 'n source'
              TabOrder = 0
              object ComBExp2FRs_n: TComboBox
                Tag = 307
                Left = 5
                Top = 15
                Width = 66
                Height = 22
                Style = csDropDownList
                DropDownCount = 15
                ItemHeight = 14
                TabOrder = 0
              end
            end
            object ComBExp2FRs: TComboBox
              Tag = 307
              Left = 5
              Top = 15
              Width = 66
              Height = 22
              Style = csDropDownList
              DropDownCount = 15
              ItemHeight = 14
              TabOrder = 1
              OnChange = ComBForwRsChange
            end
          end
          object GroupBExp2R: TGroupBox
            Left = 133
            Top = 1277
            Width = 151
            Height = 47
            Caption = 'Rs source'
            TabOrder = 50
            object GroupBox34: TGroupBox
              Left = 75
              Top = 5
              Width = 73
              Height = 40
              Caption = 'n source'
              TabOrder = 0
              object ComBExp2RRs_n: TComboBox
                Tag = 308
                Left = 5
                Top = 15
                Width = 66
                Height = 22
                Style = csDropDownList
                DropDownCount = 15
                ItemHeight = 14
                TabOrder = 0
              end
            end
            object ComBExp2RRs: TComboBox
              Tag = 308
              Left = 5
              Top = 15
              Width = 66
              Height = 22
              Style = csDropDownList
              DropDownCount = 15
              ItemHeight = 14
              TabOrder = 1
              OnChange = ComBForwRsChange
            end
          end
          object CBExp2R: TCheckBox
            Tag = 120
            Left = 14
            Top = 1277
            Width = 103
            Height = 24
            Caption = 'I/[1-exp(-qV/kT)], reverse'
            TabOrder = 51
            WordWrap = True
            OnClick = CBForwRsClick
          end
          object ButExp2R: TButton
            Left = 77
            Top = 1298
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 49
            OnClick = RadioButtonM_VDblClick
          end
          object ButM_V: TButton
            Left = 263
            Top = 1357
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 52
            OnClick = RadioButtonM_VDblClick
          end
          object CBM_V: TCheckBox
            Tag = 121
            Left = 14
            Top = 1352
            Width = 105
            Height = 17
            Caption = 'index of power'
            TabOrder = 53
            OnClick = CBForwRsClick
          end
          object CBM_Vdod: TCheckBox
            Left = 130
            Top = 1362
            Width = 60
            Height = 17
            Caption = 'forward'
            TabOrder = 54
          end
          object ButFow_Nor: TButton
            Left = 263
            Top = 1412
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 55
            OnClick = RadioButtonM_VDblClick
          end
          object CBFow_Nordod: TCheckBox
            Left = 130
            Top = 1417
            Width = 60
            Height = 17
            Caption = 'forward'
            TabOrder = 56
          end
          object CBFow_Nor: TCheckBox
            Tag = 122
            Left = 14
            Top = 1407
            Width = 105
            Height = 17
            Caption = 'Fowler-Nordheim'
            TabOrder = 57
            OnClick = CBForwRsClick
          end
          object ButFow_NorE: TButton
            Left = 263
            Top = 1463
            Width = 25
            Height = 24
            Caption = '?'
            TabOrder = 58
            OnClick = RadioButtonM_VDblClick
          end
          object CBFow_NorEdod: TCheckBox
            Left = 130
            Top = 1467
            Width = 60
            Height = 17
            Caption = 'forward'
            TabOrder = 59
          end
          object CBFow_NorE: TCheckBox
            Tag = 123
            Left = 14
            Top = 1458
            Width = 114
            Height = 16
            Caption = 'Fowler-Nordheim, Em'
            TabOrder = 60
            OnClick = CBForwRsClick
          end
          object ButAbeles: TButton
            Left = 263
            Top = 1519
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 61
            OnClick = RadioButtonM_VDblClick
          end
          object CBAbelesdod: TCheckBox
            Left = 130
            Top = 1524
            Width = 60
            Height = 17
            Caption = 'forward'
            TabOrder = 62
          end
          object CBAbeles: TCheckBox
            Tag = 124
            Left = 14
            Top = 1514
            Width = 114
            Height = 17
            Caption = 'Abeles'
            TabOrder = 63
            OnClick = CBForwRsClick
          end
          object ButAbelesE: TButton
            Left = 263
            Top = 1575
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 64
            OnClick = RadioButtonM_VDblClick
          end
          object CBAbelesEdod: TCheckBox
            Left = 130
            Top = 1580
            Width = 60
            Height = 17
            Caption = 'forward'
            TabOrder = 65
          end
          object CBAbelesE: TCheckBox
            Tag = 125
            Left = 14
            Top = 1570
            Width = 114
            Height = 17
            Caption = 'Abeles, Em'
            TabOrder = 66
            OnClick = CBForwRsClick
          end
          object ButFr_Pool: TButton
            Left = 263
            Top = 1630
            Width = 25
            Height = 25
            Caption = '?'
            TabOrder = 67
            OnClick = RadioButtonM_VDblClick
          end
          object CBFr_Pooldod: TCheckBox
            Left = 130
            Top = 1635
            Width = 60
            Height = 17
            Caption = 'forward'
            TabOrder = 68
          end
          object CBFr_Pool: TCheckBox
            Tag = 126
            Left = 14
            Top = 1625
            Width = 114
            Height = 17
            Caption = 'Frenkel-Poole'
            TabOrder = 69
            OnClick = CBForwRsClick
          end
          object CBFr_PoolEdod: TCheckBox
            Left = 130
            Top = 1685
            Width = 60
            Height = 17
            Caption = 'forward'
            TabOrder = 70
          end
          object ButFr_PoolE: TButton
            Left = 263
            Top = 1681
            Width = 25
            Height = 24
            Caption = '?'
            TabOrder = 71
            OnClick = RadioButtonM_VDblClick
          end
          object CBFr_PoolE: TCheckBox
            Tag = 127
            Left = 14
            Top = 1675
            Width = 114
            Height = 17
            Caption = 'Frenkel-Poole, Em'
            TabOrder = 72
            OnClick = CBForwRsClick
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'File operation'
      ImageIndex = 1
      object DirLabel: TLabel
        Left = 664
        Top = 62
        Width = 86
        Height = 14
        Caption = 'Current Directory:'
      end
      object Active: TLabel
        Left = 600
        Top = 96
        Width = 51
        Height = 14
        Caption = 'Active file:'
      end
      object NameFile: TLabel
        Left = 585
        Top = 109
        Width = 16
        Height = 14
        Caption = 'File'
      end
      object Temper: TLabel
        Left = 585
        Top = 123
        Width = 36
        Height = 14
        Caption = 'Temper'
      end
      object LabelYLog: TLabel
        Tag = 55
        Left = 590
        Top = 294
        Width = 85
        Height = 14
        Caption = 'Y-Axis Log Scale'
        OnClick = LabelYLogClick
      end
      object LabelXLog: TLabel
        Tag = 55
        Left = 590
        Top = 275
        Width = 84
        Height = 14
        Caption = 'X-Axis Log Scale'
        Enabled = False
        OnClick = LabelXLogClick
      end
      object DirName: TLabel
        Left = 495
        Top = 81
        Width = 257
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'ooo'
      end
      object GroupBox4: TGroupBox
        Left = 577
        Top = 385
        Width = 169
        Height = 165
        Caption = 'Fitting'
        TabOrder = 9
        object SButFit: TSpeedButton
          Tag = 55
          Left = 3
          Top = 12
          Width = 163
          Height = 22
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'None'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = SButFitClick
        end
        object MemoAppr: TMemo
          Left = 3
          Top = 63
          Width = 162
          Height = 78
          Lines.Strings = (
            'MemoAppr')
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
        object BApprClear: TButton
          Left = 53
          Top = 144
          Width = 60
          Height = 18
          Caption = 'Clear'
          TabOrder = 1
          OnClick = BApprClearClick
        end
        object ButFitSelect: TButton
          Tag = 55
          Left = 10
          Top = 35
          Width = 44
          Height = 25
          Caption = 'Select'
          TabOrder = 2
          OnClick = ButFitSelectClick
        end
        object ButFitOption: TButton
          Left = 115
          Top = 35
          Width = 44
          Height = 25
          Caption = 'Option'
          Enabled = False
          TabOrder = 3
          OnClick = ButFitOptionClick
        end
      end
      object Graph: TChart
        Left = 0
        Top = 100
        Width = 562
        Height = 403
        Legend.Visible = False
        MarginBottom = 2
        MarginLeft = 1
        MarginRight = 1
        MarginTop = 5
        Title.CustomPosition = True
        Title.Left = 228
        Title.Text.Strings = (
          'I-V characteristic')
        Title.TextFormat = ttfHtml
        Title.Top = 2
        DepthAxis.Automatic = False
        DepthAxis.AutomaticMaximum = False
        DepthAxis.AutomaticMinimum = False
        DepthAxis.Maximum = 3.050000000000104000
        DepthAxis.Minimum = 2.050000000000110000
        DepthTopAxis.Automatic = False
        DepthTopAxis.AutomaticMaximum = False
        DepthTopAxis.AutomaticMinimum = False
        DepthTopAxis.Maximum = 3.050000000000104000
        DepthTopAxis.Minimum = 2.050000000000110000
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMaximum = False
        LeftAxis.AutomaticMinimum = False
        LeftAxis.Maximum = 116.849999999993100000
        LeftAxis.Minimum = -160.650000000005200000
        RightAxis.Automatic = False
        RightAxis.AutomaticMaximum = False
        RightAxis.AutomaticMinimum = False
        View3D = False
        View3DWalls = False
        TabOrder = 0
        PrintMargins = (
          15
          12
          15
          12)
        object Series1: TPointSeries
          Marks.Callout.Brush.Color = clBlack
          Marks.Visible = False
          ClickableLine = False
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = True
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object Series2: TLineSeries
          Active = False
          ColorEachPoint = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Visible = False
          SeriesColor = clRed
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object Series3: TLineSeries
          Active = False
          Marks.Callout.Brush.Color = clBlack
          Marks.Visible = False
          SeriesColor = clLime
          LinePen.Width = 4
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object Series4: TLineSeries
          Active = False
          Marks.Callout.Brush.Color = clBlack
          Marks.Visible = False
          SeriesColor = clBlue
          ClickableLine = False
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
      end
      object Close1: TBitBtn
        Left = 690
        Top = 569
        Width = 66
        Height = 25
        Caption = '&Close'
        TabOrder = 1
        OnClick = Close1Click
        Glyph.Data = {
          42020000424D4202000000000000420000002800000010000000100000000100
          1000030000000002000000000000000000000000000000000000007C0000E003
          00001F0000001F7C1F7CF75EFF7FF75EFF7FFF7FFF7FFF7F00000000FF7FF75E
          1F7C1F7C1F7CFF7FFF7FFF7FF75EFF7FFF7FF75EFF7FFF7F0000FF03EF01FF7F
          F75EF75E1F7CF75EFF7FF75EFF7FF75EF75EFF7FF75EFF7F0000FF03EF01F75E
          FF7FFF7FF75E000000000000000000000000FF7FF75EF75E0000FF03EF01EF01
          0000000000001F7C1F7C1F7C1F7C1F7C00000000000000000000FF03EF01EF01
          00001F7C1F7C1F7C1F7C1F7C1F7C1F7C0000EF3DEF3DEF3D0000FF03EF01EF01
          00001F7C1F7C1F7C1F7C1F7C1F7CEF010000EF3DEF3DEF3D0000FF03EF01EF01
          00001F7C1F7C1F7C1F7C1F7C1F7CFF03EF010000EF3DEF3D0000FF030000EF01
          00001F7C1F7C0000EF01EF01EF01FF03FF03FF030000EF3D0000FF03EF01EF01
          00001F7C1F7C0000FF03FF03FF03FF03FF03FF03EF0100000000FF03EF01EF01
          00001F7C1F7C0000FF03FF03FF03FF03FF03FF030000EF3D0000FF03EF01EF01
          00001F7C1F7C0000000000000000FF03FF03EF01EF3DEF3D0000FF03EF01EF01
          00001F7C1F7C1F7C1F7C1F7C0000FF03FF030000EF3DEF3D0000FF03EF01EF01
          00001F7C1F7C1F7C1F7C1F7C1F7C00000000EF3DEF3DEF3DEF3D0000FF03EF01
          00001F7C1F7C1F7C1F7C1F7C1F7C1F7C0000EF3DEF3DEF3DEF3DEF3DEF3DFF03
          00001F7C1F7C1F7C1F7C1F7C1F7C1F7C00000000000000000000000000000000
          00001F7C1F7C}
      end
      object OpenFile: TButton
        Left = 677
        Top = 20
        Width = 75
        Height = 25
        Caption = 'OpenFile'
        TabOrder = 2
        OnClick = OpenFileClick
      end
      object DataSheet: TStringGrid
        Left = 575
        Top = 138
        Width = 144
        Height = 129
        ColCount = 3
        DefaultColWidth = 20
        DefaultRowHeight = 20
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
        ScrollBars = ssVertical
        TabOrder = 3
        OnDrawCell = DataSheetDrawCell
        OnSelectCell = DataSheetSelectCell
        ColWidths = (
          20
          44
          52)
        RowHeights = (
          20
          21)
      end
      object XLogCheck: TCheckBox
        Tag = 55
        Left = 568
        Top = 273
        Width = 17
        Height = 17
        TabOrder = 4
        OnClick = XLogCheckClick
      end
      object YLogCheck: TCheckBox
        Tag = 55
        Left = 568
        Top = 294
        Width = 17
        Height = 17
        TabOrder = 5
        OnClick = YLogCheckClick
      end
      object GrType: TPanel
        Left = 610
        Top = 313
        Width = 77
        Height = 66
        BevelOuter = bvNone
        BorderStyle = bsSingle
        TabOrder = 6
        object RBPoint: TRadioButton
          Tag = 55
          Left = 3
          Top = 3
          Width = 113
          Height = 17
          Caption = 'Point'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = RBPointClick
        end
        object RBLine: TRadioButton
          Tag = 55
          Left = 3
          Top = 23
          Width = 113
          Height = 17
          Caption = 'Line'
          TabOrder = 1
          OnClick = RBLineClick
        end
        object RBPointLine: TRadioButton
          Tag = 55
          Left = 3
          Top = 43
          Width = 113
          Height = 17
          Caption = 'Point+Line'
          TabOrder = 2
          OnClick = RBPointLineClick
        end
      end
      object GroupBox2: TGroupBox
        Left = 3
        Top = 502
        Width = 358
        Height = 92
        TabOrder = 7
        object LabMarN: TLabel
          Tag = 59
          Left = 75
          Top = 37
          Width = 13
          Height = 14
          Caption = 'N='
        end
        object LabMarX: TLabel
          Tag = 59
          Left = 43
          Top = 57
          Width = 13
          Height = 14
          Caption = 'X='
        end
        object LabMarY: TLabel
          Tag = 59
          Left = 105
          Top = 57
          Width = 14
          Height = 14
          Caption = 'Y='
        end
        object LabelMarFile: TLabel
          Tag = 58
          Left = 17
          Top = 57
          Width = 18
          Height = 13
          Caption = 'file:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsItalic]
          ParentFont = False
        end
        object LabelmarGraph: TLabel
          Tag = 58
          Left = 3
          Top = 76
          Width = 32
          Height = 13
          Caption = 'graph:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsItalic]
          ParentFont = False
        end
        object LabelMarXGr: TLabel
          Tag = 58
          Left = 43
          Top = 76
          Width = 13
          Height = 14
          Caption = 'X='
        end
        object LabelMarYGr: TLabel
          Tag = 58
          Left = 105
          Top = 76
          Width = 14
          Height = 14
          Caption = 'Y='
        end
        object CBMarker: TCheckBox
          Tag = 55
          Left = 5
          Top = 34
          Width = 54
          Height = 17
          Caption = 'Marker'
          TabOrder = 0
          OnClick = CBMarkerClick
        end
        object TrackBarMar: TTrackBar
          Tag = 58
          Left = 3
          Top = 2
          Width = 118
          Height = 32
          PageSize = 5
          TabOrder = 1
          OnChange = TrackBarMarChange
        end
        object SGMarker: TStringGrid
          Left = 172
          Top = 3
          Width = 182
          Height = 86
          ColCount = 4
          DefaultColWidth = 20
          DefaultRowHeight = 20
          RowCount = 4
          ScrollBars = ssVertical
          TabOrder = 2
          ColWidths = (
            20
            43
            45
            47)
        end
        object BMarAdd: TButton
          Tag = 58
          Left = 117
          Top = 3
          Width = 51
          Height = 25
          Caption = 'Add'
          TabOrder = 3
          OnClick = BMarAddClick
        end
        object BmarClear: TButton
          Left = 117
          Top = 34
          Width = 49
          Height = 25
          Caption = 'Clear'
          TabOrder = 4
          OnClick = BmarClearClick
        end
      end
      object GroupBox3: TGroupBox
        Left = 367
        Top = 502
        Width = 195
        Height = 92
        TabOrder = 8
        object LabelMin: TLabel
          Left = 42
          Top = 40
          Width = 42
          Height = 14
          Caption = 'LabelMin'
        end
        object LabelMax: TLabel
          Left = 138
          Top = 40
          Width = 46
          Height = 14
          Caption = 'LabelMax'
        end
        object SpButLimit: TSpeedButton
          Tag = 55
          Left = 42
          Top = 4
          Width = 105
          Height = 22
          AllowAllUp = True
          GroupIndex = 1
          Caption = 'Apply Limits'
          OnClick = SpButLimitClick
        end
        object RdGrMin: TRadioGroup
          Left = 5
          Top = 30
          Width = 33
          Height = 57
          Caption = 'Min'
          ItemIndex = 0
          Items.Strings = (
            'X'
            'Y')
          TabOrder = 0
          OnClick = RdGrMinClick
        end
        object ButtonMin: TButton
          Left = 40
          Top = 65
          Width = 53
          Height = 20
          Caption = 'Edit'
          TabOrder = 1
          OnClick = ButtonMinClick
        end
        object RdGrMax: TRadioGroup
          Left = 99
          Top = 30
          Width = 33
          Height = 57
          Caption = 'Max'
          ItemIndex = 0
          Items.Strings = (
            'X'
            'Y')
          TabOrder = 2
          OnClick = RdGrMaxClick
        end
        object ButtonMax: TButton
          Left = 138
          Top = 64
          Width = 53
          Height = 20
          Caption = 'Edit'
          TabOrder = 3
          OnClick = ButtonMaxClick
        end
      end
      object GroupBox8: TGroupBox
        Left = 495
        Top = -2
        Width = 163
        Height = 79
        Caption = 'Calculation'
        TabOrder = 10
        object LabelKalk1: TLabel
          Left = 43
          Top = 36
          Width = 52
          Height = 14
          Caption = 'LabelKalk1'
        end
        object LabelKalk2: TLabel
          Left = 43
          Top = 51
          Width = 52
          Height = 14
          Caption = 'LabelKalk2'
        end
        object LabelKalk3: TLabel
          Left = 43
          Top = 66
          Width = 52
          Height = 14
          Caption = 'LabelKalk3'
        end
        object CBKalk: TComboBox
          Left = 6
          Top = 15
          Width = 149
          Height = 22
          Style = csDropDownList
          DropDownCount = 21
          ItemHeight = 14
          TabOrder = 0
          OnChange = CBKalkChange
        end
        object ButtonKalk: TButton
          Tag = 55
          Left = 4
          Top = 40
          Width = 33
          Height = 27
          Caption = 'Apply'
          TabOrder = 1
          OnClick = ButtonKalkClick
        end
        object ButtonKalkPar: TButton
          Left = 125
          Top = 40
          Width = 33
          Height = 27
          Caption = '< ? >'
          TabOrder = 2
          OnClick = ButtonKalkParClick
        end
      end
      object ScrollBox1: TScrollBox
        Left = 1
        Top = -1
        Width = 486
        Height = 107
        HorzScrollBar.Position = 1237
        Color = clInfoBk
        ParentColor = False
        TabOrder = 11
        object GroupBox1: TGroupBox
          Left = -1239
          Top = -2
          Width = 1700
          Height = 88
          TabOrder = 0
          object Bevel1: TBevel
            Left = 230
            Top = 0
            Width = 5
            Height = 90
            Shape = bsFrame
            Style = bsRaised
          end
          object Bevel2: TBevel
            Left = 490
            Top = 0
            Width = 5
            Height = 90
            Shape = bsFrame
            Style = bsRaised
          end
          object Bevel15: TBevel
            Left = 690
            Top = 0
            Width = 5
            Height = 90
            Shape = bsFrame
            Style = bsRaised
          end
          object LabelVa: TLabel
            Tag = 55
            Left = 718
            Top = 43
            Width = 26
            Height = 14
            Caption = 'Va = '
          end
          object Bevel18: TBevel
            Left = 795
            Top = 0
            Width = 5
            Height = 90
            Shape = bsFrame
            Style = bsRaised
          end
          object LabelMikh: TLabel
            Tag = 55
            Left = 806
            Top = 4
            Width = 104
            Height = 13
            Caption = 'Mikhelashvili'#39's method'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsUnderline]
            ParentFont = False
          end
          object Bevel20: TBevel
            Left = 920
            Top = 0
            Width = 5
            Height = 90
            Shape = bsFrame
            Style = bsRaised
          end
          object Bevel25: TBevel
            Left = 1250
            Top = 0
            Width = 6
            Height = 90
            Shape = bsFrame
            Style = bsRaised
          end
          object Bevel32: TBevel
            Left = 1500
            Top = -5
            Width = 6
            Height = 90
            Shape = bsFrame
            Style = bsRaised
          end
          object FullIV: TRadioButton
            Tag = 55
            Left = 10
            Top = 3
            Width = 73
            Height = 17
            Caption = 'Full IV-char'
            Checked = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            TabStop = True
            OnClick = FullIVClick
          end
          object ForIV: TRadioButton
            Tag = 55
            Left = 10
            Top = 43
            Width = 73
            Height = 17
            Caption = 'Forward IV'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = RadioButtonM_VClick
          end
          object RevIV: TRadioButton
            Tag = 55
            Left = 10
            Top = 23
            Width = 73
            Height = 17
            Caption = 'Reverse IV'
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = RadioButtonM_VClick
          end
          object Chung: TRadioButton
            Tag = 55
            Left = 170
            Top = 8
            Width = 60
            Height = 23
            Caption = 'Cheung '
            TabOrder = 3
            WordWrap = True
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object Hfunc: TRadioButton
            Tag = 56
            Left = 497
            Top = 20
            Width = 72
            Height = 17
            Caption = 'H-function'
            TabOrder = 4
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object Nord: TRadioButton
            Tag = 56
            Left = 497
            Top = 53
            Width = 52
            Height = 17
            Caption = 'Nordes'
            TabOrder = 5
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RadioButtonForwRs: TRadioButton
            Tag = 55
            Left = 236
            Top = 20
            Width = 65
            Height = 24
            Caption = 'Forward with Rs'
            TabOrder = 6
            WordWrap = True
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RadioButtonN: TRadioButton
            Tag = 56
            Left = 236
            Top = 50
            Width = 60
            Height = 17
            Caption = 'n ( V )'
            TabOrder = 7
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RadioButtonNss: TRadioButton
            Tag = 56
            Left = 931
            Top = 3
            Width = 79
            Height = 17
            Caption = 'Nss (Ec-Ess)'
            TabOrder = 8
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object ButtonNss: TButton
            Tag = 56
            Left = 945
            Top = 20
            Width = 50
            Height = 20
            Caption = 'Nss limits'
            TabOrder = 9
            OnClick = ButtonParamCibClick
          end
          object RadioButtonKam2: TRadioButton
            Tag = 55
            Left = 95
            Top = 24
            Width = 73
            Height = 17
            Caption = 'Kaminski II'
            TabOrder = 10
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RadioButtonKam1: TRadioButton
            Tag = 55
            Left = 95
            Top = 3
            Width = 65
            Height = 17
            Caption = 'Kaminski I'
            TabOrder = 11
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RadioButtonGr2: TRadioButton
            Tag = 56
            Left = 95
            Top = 63
            Width = 73
            Height = 17
            Caption = 'Gromov II'
            TabOrder = 12
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RadioButtonGr1: TRadioButton
            Tag = 55
            Left = 95
            Top = 43
            Width = 65
            Height = 17
            Caption = 'Gromov I'
            TabOrder = 13
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RadioButtonCib: TRadioButton
            Tag = 55
            Left = 170
            Top = 30
            Width = 60
            Height = 24
            Caption = 'Cibils'
            TabOrder = 14
            WordWrap = True
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RadioButtonF_V: TRadioButton
            Tag = 55
            Left = 700
            Top = 3
            Width = 96
            Height = 17
            Caption = 'F(V)=V-Va*ln(I)'
            TabOrder = 15
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object ButtonVa: TButton
            Tag = 55
            Left = 718
            Top = 63
            Width = 45
            Height = 20
            Caption = 'Edit'
            TabOrder = 16
            OnClick = ButtonVaClick
          end
          object RadioButtonF_I: TRadioButton
            Tag = 55
            Left = 700
            Top = 23
            Width = 96
            Height = 17
            Caption = 'F(I)=V-Va*ln(I)'
            TabOrder = 17
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RadioButtonLee: TRadioButton
            Tag = 55
            Left = 10
            Top = 63
            Width = 75
            Height = 17
            Caption = 'Lee function'
            TabOrder = 18
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RadioButtonWer: TRadioButton
            Tag = 55
            Left = 170
            Top = 50
            Width = 60
            Height = 24
            Caption = 'Werner'
            TabOrder = 19
            WordWrap = True
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RadioButtonMikhAlpha: TRadioButton
            Tag = 55
            Left = 806
            Top = 23
            Width = 45
            Height = 17
            Caption = 'Alpha'
            TabOrder = 20
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RadioButtonMikhBetta: TRadioButton
            Tag = 55
            Left = 860
            Top = 23
            Width = 45
            Height = 17
            Caption = 'Betta'
            TabOrder = 21
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RadioButtonMikhN: TRadioButton
            Tag = 56
            Left = 806
            Top = 43
            Width = 47
            Height = 17
            Caption = ' n ( V )'
            TabOrder = 22
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RadioButtonMikhRs: TRadioButton
            Tag = 55
            Left = 860
            Top = 43
            Width = 50
            Height = 17
            Caption = 'Rs ( V )'
            TabOrder = 23
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object GroupBoxRs: TGroupBox
            Left = 300
            Top = 4
            Width = 77
            Height = 78
            Caption = 'Rs source'
            TabOrder = 24
            object ComboBoxRS: TComboBox
              Tag = 55
              Left = 5
              Top = 15
              Width = 66
              Height = 22
              Style = csDropDownList
              DropDownCount = 15
              ItemHeight = 14
              TabOrder = 0
              OnChange = ComboBoxRSChange
            end
            object GroupBoxRs_n: TGroupBox
              Left = 2
              Top = 37
              Width = 73
              Height = 39
              Align = alBottom
              Caption = 'n source'
              TabOrder = 1
              object ComboBoxRS_n: TComboBox
                Tag = 55
                Left = 4
                Top = 15
                Width = 66
                Height = 22
                Style = csDropDownList
                DropDownCount = 15
                ItemHeight = 14
                TabOrder = 0
                OnChange = ComboBoxRSChange
              end
            end
          end
          object GroupBoxN: TGroupBox
            Left = 570
            Top = 4
            Width = 114
            Height = 78
            Caption = 'n source'
            TabOrder = 25
            object GroupBoxN_Rs: TGroupBox
              Left = 2
              Top = 37
              Width = 110
              Height = 39
              Align = alBottom
              Caption = 'Rs source'
              TabOrder = 0
              object ComboBoxN_Rs: TComboBox
                Tag = 56
                Left = 2
                Top = 18
                Width = 67
                Height = 22
                Style = csDropDownList
                DropDownCount = 15
                ItemHeight = 14
                TabOrder = 0
                OnChange = ComboBoxNChange
              end
            end
            object ComboBoxN: TComboBox
              Tag = 56
              Left = 5
              Top = 15
              Width = 103
              Height = 22
              Style = csDropDownList
              DropDownCount = 15
              ItemHeight = 14
              TabOrder = 1
              OnChange = ComboBoxNChange
            end
          end
          object GroupBoxNssRs: TGroupBox
            Left = 1015
            Top = 38
            Width = 152
            Height = 47
            Caption = 'Rs source'
            TabOrder = 26
            object ComboBoxNssRs: TComboBox
              Tag = 56
              Left = 5
              Top = 15
              Width = 66
              Height = 22
              Style = csDropDownList
              DropDownCount = 15
              ItemHeight = 14
              TabOrder = 0
              OnChange = ComboBoxNssRsChange
            end
            object GroupBoxNssRs_N: TGroupBox
              Left = 75
              Top = 5
              Width = 73
              Height = 40
              Caption = 'n source'
              TabOrder = 1
              object ComboBoxNssRs_N: TComboBox
                Tag = 56
                Left = 4
                Top = 15
                Width = 66
                Height = 22
                Style = csDropDownList
                DropDownCount = 15
                ItemHeight = 14
                TabOrder = 0
                OnChange = ComboBoxNssFbChange
              end
            end
          end
          object GroupBoxNssNv: TGroupBox
            Left = 931
            Top = 39
            Width = 78
            Height = 46
            Caption = 'method n(V)'
            TabOrder = 27
            object RadioButtonNssNvD: TRadioButton
              Tag = 56
              Left = 2
              Top = 11
              Width = 113
              Height = 17
              Caption = 'derivate'
              Checked = True
              TabOrder = 0
              TabStop = True
              OnClick = ComboBoxNssFbChange
            end
            object RadioButtonNssNvM: TRadioButton
              Tag = 56
              Left = 2
              Top = 27
              Width = 113
              Height = 17
              Caption = 'Mikhelashvili'
              TabOrder = 1
              OnClick = ComboBoxNssFbChange
            end
          end
          object GroupBoxNssFb: TGroupBox
            Tag = 56
            Left = 1030
            Top = 0
            Width = 114
            Height = 40
            Caption = 'Fb source'
            TabOrder = 28
            object ComboBoxNssFb: TComboBox
              Tag = 56
              Left = 8
              Top = 15
              Width = 103
              Height = 22
              Style = csDropDownList
              DropDownCount = 15
              ItemHeight = 14
              TabOrder = 0
              OnChange = ComboBoxNssFbChange
            end
          end
          object RadioButtonDit: TRadioButton
            Tag = 56
            Left = 1170
            Top = 11
            Width = 79
            Height = 33
            Caption = 'Dit (Ivanov method)'
            TabOrder = 29
            WordWrap = True
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RadioButtonEx2F: TRadioButton
            Tag = 56
            Left = 383
            Top = 20
            Width = 103
            Height = 24
            Caption = 'I/[1-exp(-qV/kT)], forward'
            TabOrder = 30
            WordWrap = True
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RadioButtonEx2R: TRadioButton
            Tag = 56
            Left = 382
            Top = 49
            Width = 104
            Height = 24
            Caption = 'I/[1-exp(-qV/kT)], reverse'
            TabOrder = 31
            WordWrap = True
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RadioButtonM_V: TRadioButton
            Tag = 55
            Left = 1258
            Top = 3
            Width = 97
            Height = 25
            Caption = 'index of power'
            TabOrder = 32
            WordWrap = True
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object CheckBoxM_V: TCheckBox
            Tag = 55
            Left = 1384
            Top = 3
            Width = 99
            Height = 23
            Caption = 'forward brench'
            TabOrder = 33
            WordWrap = True
            OnClick = CheckBoxM_VClick
          end
          object RadioButtonFN: TRadioButton
            Tag = 55
            Left = 1258
            Top = 23
            Width = 103
            Height = 24
            Caption = 'Fowler-Nordheim'
            TabOrder = 34
            WordWrap = True
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RadioButtonFNEm: TRadioButton
            Tag = 55
            Left = 1365
            Top = 23
            Width = 133
            Height = 24
            Caption = 'Fowler-Nordheim, Em'
            TabOrder = 35
            WordWrap = True
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RadioButtonAb: TRadioButton
            Tag = 55
            Left = 1258
            Top = 43
            Width = 52
            Height = 24
            Caption = 'Abeles'
            TabOrder = 36
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RadioButtonAbEm: TRadioButton
            Tag = 55
            Left = 1365
            Top = 43
            Width = 122
            Height = 24
            Caption = 'Abeles, Em'
            TabOrder = 37
            WordWrap = True
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RadioButtonFP: TRadioButton
            Tag = 55
            Left = 1258
            Top = 61
            Width = 97
            Height = 25
            Caption = 'Frenkel-Poole'
            TabOrder = 38
            WordWrap = True
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RadioButtonFPEm: TRadioButton
            Tag = 55
            Left = 1365
            Top = 61
            Width = 108
            Height = 25
            Caption = 'Frenkel-Poole, Em'
            TabOrder = 39
            WordWrap = True
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RB_TauR: TRadioButton
            Tag = 55
            Left = 1510
            Top = 3
            Width = 75
            Height = 24
            Caption = 'Igen -> Tau'
            TabOrder = 40
            WordWrap = True
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RB_Igen: TRadioButton
            Tag = 55
            Left = 1602
            Top = 3
            Width = 75
            Height = 24
            Caption = 'Tau -> Igen'
            TabOrder = 41
            WordWrap = True
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RB_TauG: TRadioButton
            Tag = 55
            Left = 1510
            Top = 23
            Width = 75
            Height = 24
            Caption = 'Irec -> Tau'
            TabOrder = 42
            WordWrap = True
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
          object RB_Irec: TRadioButton
            Tag = 55
            Left = 1602
            Top = 23
            Width = 75
            Height = 24
            Caption = 'Tau -> Irec'
            TabOrder = 43
            WordWrap = True
            OnClick = RadioButtonM_VClick
            OnDblClick = RadioButtonM_VDblClick
          end
        end
      end
      object ButDel: TButton
        Left = 730
        Top = 160
        Width = 15
        Height = 97
        Caption = 'DELETE'
        TabOrder = 12
        WordWrap = True
        OnClick = ButDelClick
      end
      object ButInputT: TButton
        Tag = 55
        Left = 703
        Top = 109
        Width = 51
        Height = 24
        Caption = 'Input T'
        TabOrder = 13
        WordWrap = True
        OnClick = ButInputTClick
      end
      object ButSave: TButton
        Left = 694
        Top = 325
        Width = 60
        Height = 25
        Caption = 'Save'
        TabOrder = 14
        OnClick = ButSaveClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Diode'#39's parameters'
      ImageIndex = 2
      object Close2: TBitBtn
        Left = 534
        Top = 562
        Width = 75
        Height = 25
        Caption = '&Close'
        TabOrder = 0
        OnClick = Close1Click
        Glyph.Data = {
          42020000424D4202000000000000420000002800000010000000100000000100
          1000030000000002000000000000000000000000000000000000007C0000E003
          00001F0000001F7C1F7CF75EFF7FF75EFF7FFF7FFF7FFF7F00000000FF7FF75E
          1F7C1F7C1F7CFF7FFF7FFF7FF75EFF7FFF7FF75EFF7FFF7F0000FF03EF01FF7F
          F75EF75E1F7CF75EFF7FF75EFF7FF75EF75EFF7FF75EFF7F0000FF03EF01F75E
          FF7FFF7FF75E000000000000000000000000FF7FF75EF75E0000FF03EF01EF01
          0000000000001F7C1F7C1F7C1F7C1F7C00000000000000000000FF03EF01EF01
          00001F7C1F7C1F7C1F7C1F7C1F7C1F7C0000EF3DEF3DEF3D0000FF03EF01EF01
          00001F7C1F7C1F7C1F7C1F7C1F7CEF010000EF3DEF3DEF3D0000FF03EF01EF01
          00001F7C1F7C1F7C1F7C1F7C1F7CFF03EF010000EF3DEF3D0000FF030000EF01
          00001F7C1F7C0000EF01EF01EF01FF03FF03FF030000EF3D0000FF03EF01EF01
          00001F7C1F7C0000FF03FF03FF03FF03FF03FF03EF0100000000FF03EF01EF01
          00001F7C1F7C0000FF03FF03FF03FF03FF03FF030000EF3D0000FF03EF01EF01
          00001F7C1F7C0000000000000000FF03FF03EF01EF3DEF3D0000FF03EF01EF01
          00001F7C1F7C1F7C1F7C1F7C0000FF03FF030000EF3DEF3D0000FF03EF01EF01
          00001F7C1F7C1F7C1F7C1F7C1F7C00000000EF3DEF3DEF3DEF3D0000FF03EF01
          00001F7C1F7C1F7C1F7C1F7C1F7C1F7C0000EF3DEF3DEF3DEF3DEF3DEF3DFF03
          00001F7C1F7C1F7C1F7C1F7C1F7C1F7C00000000000000000000000000000000
          00001F7C1F7C}
      end
      object GroupBoxRsPar: TGroupBox
        Left = 23
        Top = 408
        Width = 320
        Height = 129
        Caption = 'Rs parameters'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object LabRsPar: TLabel
          Left = 55
          Top = 24
          Width = 175
          Height = 21
          Caption = 'Rs = A + B * T+C*T^2'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object LabRA: TLabel
          Left = 37
          Top = 56
          Width = 25
          Height = 16
          Caption = 'A = '
        end
        object LabRB: TLabel
          Left = 125
          Top = 56
          Width = 24
          Height = 16
          Caption = 'B = '
        end
        object LabRC: TLabel
          Left = 232
          Top = 56
          Width = 25
          Height = 16
          Caption = 'C = '
        end
        object ButRA: TButton
          Left = 24
          Top = 84
          Width = 63
          Height = 25
          Caption = 'Change'
          TabOrder = 0
          OnClick = ButRAClick
        end
        object ButRB: TButton
          Left = 125
          Top = 84
          Width = 62
          Height = 25
          Caption = 'Change'
          TabOrder = 1
          OnClick = ButRBClick
        end
        object ButRC: TButton
          Left = 238
          Top = 84
          Width = 63
          Height = 25
          Caption = 'Change'
          TabOrder = 2
          OnClick = ButRCClick
        end
      end
      object Button1: TButton
        Left = 526
        Top = 20
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 2
        OnClick = Button1Click
      end
      object GBDiodParam: TGroupBox
        Left = 3
        Top = 3
        Width = 366
        Height = 310
        Caption = 'Schottky diod parameters '
        Color = clCream
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentBackground = False
        ParentColor = False
        ParentFont = False
        TabOrder = 3
        object Linsulator: TLabel
          Left = 38
          Top = 239
          Width = 169
          Height = 16
          Caption = 'Interfacial insulator layer '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LArea: TLabel
          Left = 270
          Top = 253
          Width = 75
          Height = 16
          Caption = 'Area, m^2:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LNd: TLabel
          Left = 87
          Top = 21
          Width = 201
          Height = 16
          Caption = 'Carrier concentration, m^(-3):'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object LEps_i: TLabel
          Left = 12
          Top = 262
          Width = 81
          Height = 16
          Caption = 'Permittivity:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LThick_i: TLabel
          Left = 11
          Top = 284
          Width = 86
          Height = 16
          Caption = 'Thickness, m:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object CBtypeFL: TCheckBox
          Left = 8
          Top = 20
          Width = 73
          Height = 17
          Caption = 'n-type'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object STConcFL: TStaticText
          Left = 294
          Top = 19
          Width = 40
          Height = 25
          Caption = '5e20'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object STAreaFL: TStaticText
          Left = 280
          Top = 275
          Width = 60
          Height = 25
          Caption = '3.14e-6'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object STEp: TStaticText
          Left = 176
          Top = 260
          Width = 22
          Height = 25
          Caption = '22'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object STThick: TStaticText
          Left = 176
          Top = 282
          Width = 37
          Height = 25
          Caption = '4e-7'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object GroupBoxMat: TGroupBox
          Left = 3
          Top = 43
          Width = 360
          Height = 190
          Caption = 'Material'
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 5
          object LRich3: TLabel
            Left = 10
            Top = 51
            Width = 161
            Height = 16
            Caption = 'Richardson,  A/(K m)^2:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LPermit: TLabel
            Left = 10
            Top = 73
            Width = 81
            Height = 16
            Caption = 'Permittivity:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LabelRich: TLabel
            Left = 187
            Top = 48
            Width = 50
            Height = 21
            Caption = '1.16e6'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object LabelPerm: TLabel
            Left = 235
            Top = 70
            Width = 32
            Height = 21
            Caption = '8.85'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object LEg: TLabel
            Left = 10
            Top = 95
            Width = 87
            Height = 16
            Caption = 'Zero Gap, eV:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LabelEg: TLabel
            Left = 235
            Top = 92
            Width = 32
            Height = 21
            Caption = '1.17'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object LMeff: TLabel
            Left = 10
            Top = 117
            Width = 100
            Height = 16
            Caption = 'Mass effective:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LabelMeff: TLabel
            Left = 187
            Top = 114
            Width = 32
            Height = 21
            Caption = '1.08'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object LVarA: TLabel
            Left = 10
            Top = 139
            Width = 84
            Height = 16
            Caption = 'Varshni A, K:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LabelVarA: TLabel
            Left = 235
            Top = 136
            Width = 36
            Height = 21
            Caption = '1108'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object LVarB: TLabel
            Left = 10
            Top = 161
            Width = 130
            Height = 16
            Caption = 'Varshni B, eV/ K^2:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LabelVarB: TLabel
            Left = 235
            Top = 158
            Width = 56
            Height = 21
            Caption = '7.02e-4'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object LabelRichp: TLabel
            Left = 273
            Top = 47
            Width = 50
            Height = 21
            Caption = '1.16e6'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object LabelMeffp: TLabel
            Left = 270
            Top = 114
            Width = 23
            Height = 21
            Caption = '0.8'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object L_n: TLabel
            Left = 206
            Top = 18
            Width = 13
            Height = 24
            Caption = 'n'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -20
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object L_p: TLabel
            Left = 291
            Top = 17
            Width = 13
            Height = 24
            Caption = 'p'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -20
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object CBMaterial: TComboBox
            Left = 10
            Top = 21
            Width = 80
            Height = 24
            Style = csDropDownList
            ItemHeight = 16
            TabOrder = 0
          end
        end
      end
      object GBDiodParamPN: TGroupBox
        Left = 388
        Top = 51
        Width = 366
        Height = 489
        Caption = 'pn-diod parameters '
        Color = clCream
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentBackground = False
        ParentColor = False
        ParentFont = False
        TabOrder = 4
        object LAreaPN: TLabel
          Left = 62
          Top = 242
          Width = 75
          Height = 16
          Caption = 'Area, m^2:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LNdN: TLabel
          Left = 75
          Top = 21
          Width = 209
          Height = 16
          Caption = 'Electron concentration, m^(-3):'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object LNdP: TLabel
          Left = 80
          Top = 269
          Width = 201
          Height = 16
          Caption = 'Carrier concentration, m^(-3):'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object CBtypeN: TCheckBox
          Left = 5
          Top = 20
          Width = 73
          Height = 17
          Caption = 'n-type'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object STConcN: TStaticText
          Left = 290
          Top = 19
          Width = 40
          Height = 25
          Caption = '5e20'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object STAreaPN: TStaticText
          Left = 216
          Top = 239
          Width = 60
          Height = 25
          Caption = '3.14e-6'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object GroupBoxMatN: TGroupBox
          Left = 3
          Top = 43
          Width = 360
          Height = 190
          Caption = 'Material'
          Color = clSkyBlue
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 3
          object LRich3N: TLabel
            Left = 10
            Top = 51
            Width = 161
            Height = 16
            Caption = 'Richardson,  A/(K m)^2:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LPermitN: TLabel
            Left = 10
            Top = 73
            Width = 81
            Height = 16
            Caption = 'Permittivity:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LabelRichN: TLabel
            Left = 187
            Top = 48
            Width = 50
            Height = 21
            Caption = '1.16e6'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object LabelPermN: TLabel
            Left = 235
            Top = 70
            Width = 32
            Height = 21
            Caption = '8.85'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object LEgN: TLabel
            Left = 10
            Top = 95
            Width = 87
            Height = 16
            Caption = 'Zero Gap, eV:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LabelEgN: TLabel
            Left = 235
            Top = 92
            Width = 32
            Height = 21
            Caption = '1.17'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object LMeffN: TLabel
            Left = 10
            Top = 117
            Width = 100
            Height = 16
            Caption = 'Mass effective:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LabelMeffN: TLabel
            Left = 187
            Top = 114
            Width = 32
            Height = 21
            Caption = '1.08'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object LVarAN: TLabel
            Left = 10
            Top = 139
            Width = 84
            Height = 16
            Caption = 'Varshni A, K:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LabelVarAN: TLabel
            Left = 235
            Top = 136
            Width = 36
            Height = 21
            Caption = '1108'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object LVarBN: TLabel
            Left = 10
            Top = 161
            Width = 130
            Height = 16
            Caption = 'Varshni B, eV/ K^2:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LabelVarBN: TLabel
            Left = 235
            Top = 158
            Width = 56
            Height = 21
            Caption = '7.02e-4'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object LabelRichpN: TLabel
            Left = 273
            Top = 47
            Width = 50
            Height = 21
            Caption = '1.16e6'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object LabelMeffpN: TLabel
            Left = 270
            Top = 114
            Width = 23
            Height = 21
            Caption = '0.8'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object L_nN: TLabel
            Left = 206
            Top = 18
            Width = 13
            Height = 24
            Caption = 'n'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -20
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object L_pN: TLabel
            Left = 291
            Top = 17
            Width = 13
            Height = 24
            Caption = 'p'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -20
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object CBMaterialN: TComboBox
            Left = 10
            Top = 21
            Width = 80
            Height = 24
            Style = csDropDownList
            ItemHeight = 16
            TabOrder = 0
          end
        end
        object CBtypeP: TCheckBox
          Left = 8
          Top = 268
          Width = 73
          Height = 17
          Caption = 'n-type'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object STConcFLP: TStaticText
          Left = 290
          Top = 267
          Width = 40
          Height = 25
          Caption = '5e20'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object GroupBoxMatP: TGroupBox
          Left = 3
          Top = 291
          Width = 360
          Height = 190
          Caption = 'Material'
          Color = cl3DLight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 6
          object LRich3P: TLabel
            Left = 10
            Top = 51
            Width = 161
            Height = 16
            Caption = 'Richardson,  A/(K m)^2:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LPermitP: TLabel
            Left = 10
            Top = 73
            Width = 81
            Height = 16
            Caption = 'Permittivity:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LabelRichnP: TLabel
            Left = 187
            Top = 48
            Width = 50
            Height = 21
            Caption = '1.16e6'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object LabelPermP: TLabel
            Left = 235
            Top = 70
            Width = 32
            Height = 21
            Caption = '8.85'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object LEgP: TLabel
            Left = 10
            Top = 95
            Width = 87
            Height = 16
            Caption = 'Zero Gap, eV:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LabelEgP: TLabel
            Left = 235
            Top = 92
            Width = 32
            Height = 21
            Caption = '1.17'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object LMeffP: TLabel
            Left = 10
            Top = 117
            Width = 100
            Height = 16
            Caption = 'Mass effective:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LabelMeffnP: TLabel
            Left = 187
            Top = 114
            Width = 32
            Height = 21
            Caption = '1.08'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object LVarAP: TLabel
            Left = 10
            Top = 139
            Width = 84
            Height = 16
            Caption = 'Varshni A, K:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LabelVarAP: TLabel
            Left = 235
            Top = 136
            Width = 36
            Height = 21
            Caption = '1108'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object LVarBP: TLabel
            Left = 10
            Top = 161
            Width = 130
            Height = 16
            Caption = 'Varshni B, eV/ K^2:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LabelVarBP: TLabel
            Left = 235
            Top = 158
            Width = 56
            Height = 21
            Caption = '7.02e-4'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object LabelRichpP: TLabel
            Left = 270
            Top = 47
            Width = 50
            Height = 21
            Caption = '1.16e6'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object LabelMeffpP: TLabel
            Left = 270
            Top = 114
            Width = 23
            Height = 21
            Caption = '0.8'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object L_nP: TLabel
            Left = 206
            Top = 18
            Width = 13
            Height = 24
            Caption = 'n'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -20
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object L_pP: TLabel
            Left = 291
            Top = 17
            Width = 13
            Height = 24
            Caption = 'p'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -20
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object CBMaterialP: TComboBox
            Left = 10
            Top = 21
            Width = 80
            Height = 24
            Style = csDropDownList
            ItemHeight = 16
            TabOrder = 0
          end
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Deep Level'
      ImageIndex = 3
      object GroupBox36: TGroupBox
        Left = 3
        Top = 0
        Width = 185
        Height = 105
        Caption = 'dB/dV'
        TabOrder = 0
        object LDLBuild: TLabel
          Tag = 56
          Left = 34
          Top = 20
          Width = 23
          Height = 14
          Caption = 'Build'
          OnClick = LDLBuildClick
        end
        object LabIsc: TLabel
          Tag = 56
          Left = 5
          Top = 43
          Width = 70
          Height = 14
          Caption = 'Photo D-Diod'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object LSmoothDL: TLabel
          Tag = 56
          Left = 85
          Top = 15
          Width = 50
          Height = 14
          Caption = 'Smoothing'
        end
        object LabRCons: TLabel
          Tag = 56
          Left = 120
          Top = 39
          Width = 58
          Height = 14
          Caption = 'Rs, Rsh, Isc'
          WordWrap = True
          OnClick = LabRConsClick
        end
        object SpinEditDL: TSpinEdit
          Tag = 56
          Left = 141
          Top = 10
          Width = 41
          Height = 23
          TabStop = False
          EditorEnabled = False
          Enabled = False
          MaxValue = 25
          MinValue = 0
          TabOrder = 0
          Value = 5
          OnChange = CBoxDLBuildClick
        end
        object ButSaveDL: TButton
          Tag = 1
          Left = 104
          Top = 77
          Width = 67
          Height = 25
          Caption = 'Save'
          Enabled = False
          TabOrder = 1
          OnClick = ButSaveDLClick
        end
        object CBoxRCons: TCheckBox
          Tag = 56
          Left = 99
          Top = 37
          Width = 13
          Height = 17
          TabOrder = 2
          OnClick = CBoxDLBuildClick
        end
        object ButLDFitSelect: TButton
          Tag = 55
          Left = 5
          Top = 75
          Width = 44
          Height = 21
          Caption = 'Select'
          TabOrder = 3
          OnClick = ButLDFitSelectClick
        end
        object ButLDFitOption: TButton
          Tag = 55
          Left = 54
          Top = 75
          Width = 44
          Height = 21
          Caption = 'Option'
          Enabled = False
          TabOrder = 4
          OnClick = ButFitOptionClick
        end
        object CBBaseAuto: TCheckBox
          Left = 99
          Top = 55
          Width = 97
          Height = 17
          Caption = 'Auto Base'
          TabOrder = 5
          OnClick = CBoxDLBuildClick
        end
      end
      object CBoxDLBuild: TCheckBox
        Tag = 56
        Left = 18
        Top = 20
        Width = 13
        Height = 17
        TabOrder = 1
        OnClick = CBoxDLBuildClick
      end
      object GroupBox37: TGroupBox
        Left = 3
        Top = 508
        Width = 142
        Height = 91
        Caption = 'Base Line'
        TabOrder = 2
        object LBaseLine: TLabel
          Tag = 56
          Left = 35
          Top = 14
          Width = 93
          Height = 14
          Caption = 'y = A + B x + C x^2'
        end
        object LBaseLineA: TLabel
          Tag = 56
          Left = 64
          Top = 33
          Width = 20
          Height = 14
          Caption = 'A = '
          Visible = False
        end
        object LBaseLineB: TLabel
          Tag = 56
          Left = 64
          Top = 52
          Width = 19
          Height = 14
          Caption = 'B = '
          Visible = False
        end
        object LBaseLineC: TLabel
          Tag = 56
          Left = 64
          Top = 71
          Width = 19
          Height = 14
          Caption = 'C = '
          Visible = False
        end
        object CBoxBaseLineVisib: TCheckBox
          Tag = 56
          Left = 3
          Top = 30
          Width = 49
          Height = 17
          Caption = 'Visible'
          TabOrder = 0
          OnClick = CBoxBaseLineVisibClick
        end
        object CBoxBaseLineUse: TCheckBox
          Left = 3
          Top = 50
          Width = 47
          Height = 17
          Caption = 'Use'
          Enabled = False
          TabOrder = 1
          OnClick = CBoxBaseLineUseClick
        end
        object ButBaseLineReset: TButton
          Left = 10
          Top = 71
          Width = 34
          Height = 15
          Caption = 'Reset'
          TabOrder = 2
          OnClick = ButBaseLineResetClick
        end
      end
      object GroupBox38: TGroupBox
        Left = 151
        Top = 508
        Width = 74
        Height = 91
        Caption = 'Parametrs'
        TabOrder = 3
        object RButBaseLine: TRadioButton
          Tag = 56
          Left = 3
          Top = 18
          Width = 54
          Height = 28
          Caption = 'Base Line'
          Checked = True
          TabOrder = 0
          TabStop = True
          WordWrap = True
          OnClick = RButBaseLineClick
        end
        object RButGaussianLines: TRadioButton
          Tag = 56
          Left = 3
          Top = 52
          Width = 68
          Height = 25
          Caption = 'Gaussian Line'
          TabOrder = 1
          WordWrap = True
          OnClick = RButGaussianLinesClick
        end
      end
      object PanelA: TPanel
        Tag = 1
        Left = 227
        Top = 511
        Width = 149
        Height = 87
        BevelInner = bvRaised
        BevelOuter = bvNone
        TabOrder = 4
        VerticalAlignment = taAlignTop
        object LPanA: TLabel
          Left = 56
          Top = 48
          Width = 29
          Height = 16
          Caption = 'A = '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LPanAe: TLabel
          Left = 8
          Top = 72
          Width = 45
          Height = 14
          Caption = 'exponent'
        end
        object LPanAv: TLabel
          Left = 10
          Top = 30
          Width = 26
          Height = 14
          Caption = 'value'
        end
        object LPanAA: TLabel
          Left = 60
          Top = 66
          Width = 28
          Height = 16
          Caption = '0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object TrackPanA: TTrackBar
          Left = 1
          Top = 1
          Width = 147
          Height = 30
          Align = alTop
          Max = 1000
          Position = 100
          TabOrder = 0
          TabStop = False
          ThumbLength = 15
          TickStyle = tsManual
          OnChange = TrackPanAChange
        end
        object SpinEditPanA: TSpinEdit
          Left = 8
          Top = 46
          Width = 42
          Height = 26
          TabStop = False
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          MaxLength = 15
          MaxValue = 20
          MinValue = -20
          ParentFont = False
          TabOrder = 1
          Value = 1
          OnChange = TrackPanAChange
        end
        object CBoxPanA: TCheckBox
          Left = 82
          Top = 27
          Width = 63
          Height = 17
          Caption = 'Negative'
          TabOrder = 2
          OnClick = TrackPanAChange
        end
      end
      object PanelB: TPanel
        Tag = 1
        Left = 380
        Top = 511
        Width = 149
        Height = 87
        BevelInner = bvRaised
        BevelOuter = bvNone
        TabOrder = 5
        VerticalAlignment = taAlignTop
        object LPanB: TLabel
          Left = 55
          Top = 48
          Width = 27
          Height = 16
          Caption = 'B = '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LPanBe: TLabel
          Left = 8
          Top = 72
          Width = 45
          Height = 14
          Caption = 'exponent'
        end
        object LPanBv: TLabel
          Left = 10
          Top = 30
          Width = 26
          Height = 14
          Caption = 'value'
        end
        object LPanBB: TLabel
          Left = 60
          Top = 66
          Width = 28
          Height = 16
          Caption = '0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object TrackPanB: TTrackBar
          Left = 1
          Top = 1
          Width = 147
          Height = 30
          Align = alTop
          Max = 1000
          Position = 100
          TabOrder = 0
          TabStop = False
          ThumbLength = 15
          TickStyle = tsManual
          OnChange = TrackPanAChange
        end
        object SpinEditPanB: TSpinEdit
          Left = 8
          Top = 46
          Width = 42
          Height = 26
          TabStop = False
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          MaxLength = 15
          MaxValue = 20
          MinValue = -20
          ParentFont = False
          TabOrder = 1
          Value = 1
          OnChange = TrackPanAChange
        end
        object CBoxPanB: TCheckBox
          Left = 82
          Top = 27
          Width = 63
          Height = 17
          Caption = 'Negative'
          TabOrder = 2
          OnClick = TrackPanAChange
        end
      end
      object PanelC: TPanel
        Tag = 1
        Left = 533
        Top = 511
        Width = 149
        Height = 87
        BevelInner = bvRaised
        BevelOuter = bvNone
        TabOrder = 6
        VerticalAlignment = taAlignTop
        object LPanC: TLabel
          Left = 55
          Top = 48
          Width = 27
          Height = 16
          Caption = 'C = '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LPanCe: TLabel
          Left = 8
          Top = 72
          Width = 45
          Height = 14
          Caption = 'exponent'
        end
        object LPanCv: TLabel
          Left = 10
          Top = 30
          Width = 26
          Height = 14
          Caption = 'value'
        end
        object LPanCC: TLabel
          Left = 60
          Top = 66
          Width = 28
          Height = 16
          Caption = '0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object TrackPanC: TTrackBar
          Left = 1
          Top = 1
          Width = 147
          Height = 30
          Align = alTop
          Max = 1000
          Position = 100
          TabOrder = 0
          TabStop = False
          ThumbLength = 15
          TickStyle = tsManual
          OnChange = TrackPanAChange
        end
        object SpinEditPanC: TSpinEdit
          Left = 8
          Top = 46
          Width = 42
          Height = 26
          TabStop = False
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          MaxLength = 15
          MaxValue = 20
          MinValue = -20
          ParentFont = False
          TabOrder = 1
          Value = 1
          OnChange = TrackPanAChange
        end
        object CBoxPanC: TCheckBox
          Left = 82
          Top = 27
          Width = 63
          Height = 17
          Caption = 'Negative'
          TabOrder = 2
          OnClick = TrackPanAChange
        end
      end
      object GrBoxGaus: TGroupBox
        Left = 194
        Top = 0
        Width = 351
        Height = 105
        Caption = 'Gaussian Lines'
        TabOrder = 7
        object ButAveRight: TButton
          Left = 315
          Top = 35
          Width = 25
          Height = 25
          Caption = '>'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
          OnClick = ButAveLeftClick
        end
        object ButAveLeft: TButton
          Left = 280
          Top = 35
          Width = 25
          Height = 25
          BiDiMode = bdRightToLeft
          Caption = '<'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentBiDiMode = False
          ParentFont = False
          TabOrder = 7
          OnClick = ButAveLeftClick
        end
        object CBoxGLShow: TCheckBox
          Tag = 56
          Left = 5
          Top = 19
          Width = 57
          Height = 17
          Caption = 'Show'
          TabOrder = 1
          WordWrap = True
        end
        object SGridGaussian: TStringGrid
          Tag = 700
          Left = 93
          Top = 10
          Width = 150
          Height = 90
          TabStop = False
          ColCount = 6
          DefaultColWidth = 20
          DefaultRowHeight = 20
          Enabled = False
          RowCount = 4
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
          ScrollBars = ssVertical
          TabOrder = 2
          OnDrawCell = SGridGaussianDrawCell
          OnSelectCell = SGridGaussianSelectCell
          ColWidths = (
            20
            32
            32
            48
            56
            40)
          RowHeights = (
            20
            20
            20
            20)
        end
        object SEGauss: TSpinEdit
          Tag = 700
          Left = 5
          Top = 42
          Width = 42
          Height = 26
          TabStop = False
          AutoSize = False
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          MaxLength = 15
          MaxValue = 1
          MinValue = 1
          ParentFont = False
          TabOrder = 3
          Value = 0
          OnChange = SEGaussChange
        end
        object ButGLAdd: TButton
          Tag = 700
          Left = 54
          Top = 19
          Width = 35
          Height = 23
          Caption = 'Add'
          Enabled = False
          TabOrder = 0
          OnClick = ButGLAddClick
        end
        object ButGLDel: TButton
          Tag = 700
          Left = 54
          Top = 46
          Width = 35
          Height = 23
          Caption = 'Del'
          Enabled = False
          TabOrder = 4
          OnClick = ButGLDelClick
        end
        object ButGLRes: TButton
          Tag = 700
          Left = 54
          Top = 73
          Width = 35
          Height = 23
          Caption = 'Reset'
          Enabled = False
          TabOrder = 5
          OnClick = ButGLResClick
        end
        object ButGLLoad: TButton
          Tag = 700
          Left = 5
          Top = 73
          Width = 36
          Height = 23
          Caption = 'Load'
          Enabled = False
          TabOrder = 6
          OnClick = ButGLLoadClick
        end
      end
      object ButGausSave: TButton
        Tag = 700
        Left = 551
        Top = 7
        Width = 70
        Height = 32
        Caption = 'Save Gaussian'
        Enabled = False
        TabOrder = 8
        WordWrap = True
        OnClick = ButGausSaveClick
      end
      object RBGausSelect: TRadioButton
        Left = 551
        Top = 45
        Width = 70
        Height = 17
        Caption = 'Gaussian'
        TabOrder = 9
        OnClick = RBAveSelectClick
      end
      object RBAveSelect: TRadioButton
        Left = 551
        Top = 63
        Width = 70
        Height = 17
        Caption = 'Average'
        TabOrder = 10
        OnClick = RBAveSelectClick
      end
      object ButGLAuto: TButton
        Tag = 700
        Left = 627
        Top = 39
        Width = 35
        Height = 23
        Caption = 'Auto'
        Enabled = False
        TabOrder = 11
        OnClick = ButGLAutoClick
      end
      object CBDLFunction: TComboBox
        Left = 588
        Top = 440
        Width = 114
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 12
        OnClick = CBDLFunctionClick
      end
      object STDLFunction: TStaticText
        Left = 588
        Top = 416
        Width = 94
        Height = 18
        Caption = 'Function build type'
        TabOrder = 13
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'data file|*.dat|all file|*.*'
    Left = 952
    Top = 32
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'dat'
    Filter = 'Data (*.dat)|*.dat'
    Left = 720
    Top = 568
  end
end

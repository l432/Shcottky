inherited IvanovForm: TIvanovForm
  Caption = 'Ivanov method parameters'
  ClientHeight = 568
  ClientWidth = 723
  ExplicitWidth = 729
  ExplicitHeight = 606
  PixelsPerInch = 120
  TextHeight = 19
  inherited Label1: TLabel
    Left = 10
    Top = 254
    Width = 356
    Caption = 'Density of interface states Dit is defined  as'
    ExplicitLeft = 10
    ExplicitTop = 254
    ExplicitWidth = 356
  end
  inherited Label2: TLabel
    Left = 163
    Top = 36
    Width = 351
    Caption = 'I = S Ar (T^2) exp(-'#1060'b/kT) exp(qVs/kT)'
    ExplicitLeft = 163
    ExplicitTop = 36
    ExplicitWidth = 351
  end
  inherited Label3: TLabel
    Left = 226
    Top = 357
    Width = 199
    Caption = '(Ec-Ess) = ( '#1060'b - q Vs )'
    ExplicitLeft = 226
    ExplicitTop = 357
    ExplicitWidth = 199
  end
  inherited Label4: TLabel
    Top = 331
    ExplicitTop = 331
  end
  inherited Label5: TLabel
    Left = 10
    Top = 305
    Width = 534
    Caption = 'Vcal and Vexp - calculated and measured voltage at equal I value'
    ExplicitLeft = 10
    ExplicitTop = 305
    ExplicitWidth = 534
  end
  inherited Label6: TLabel
    Left = 342
    Top = 331
    ExplicitLeft = 342
    ExplicitTop = 331
  end
  inherited Label7: TLabel
    Left = 146
    Top = 219
    Width = 362
    Caption = '(d/ep) and '#1060'b are defined by approximation'
    ExplicitLeft = 146
    ExplicitTop = 219
    ExplicitWidth = 362
  end
  inherited Label11: TLabel
    Left = 10
    Top = 114
    ExplicitLeft = 10
    ExplicitTop = 114
  end
  inherited Label8: TLabel
    Left = 327
    Top = 163
    ExplicitLeft = 327
    ExplicitTop = 163
  end
  inherited Label9: TLabel
    Left = 10
    Top = 140
    ExplicitLeft = 10
    ExplicitTop = 140
  end
  inherited Label10: TLabel
    Left = 327
    Top = 114
    Height = 38
    WordWrap = True
    ExplicitLeft = 327
    ExplicitTop = 114
    ExplicitHeight = 38
  end
  inherited Label12: TLabel
    Left = 10
    Top = 428
    ExplicitLeft = 10
    ExplicitTop = 428
  end
  inherited Label13: TLabel
    Left = 99
    Top = 384
    Width = 207
    Caption = '[Nss] = (eV ^-1)( cm^-2)'
    ExplicitLeft = 99
    ExplicitTop = 384
    ExplicitWidth = 207
  end
  inherited Label14: TLabel
    Left = 414
    Top = 384
    ExplicitLeft = 414
    ExplicitTop = 384
  end
  object Label15: TLabel [14]
    Left = 57
    Top = 10
    Width = 303
    Height = 19
    Caption = 'I-V-characteristic is approximated by'
  end
  object Label16: TLabel [15]
    Left = 53
    Top = 62
    Width = 607
    Height = 21
    Caption = 'V=Vs+(d/ep)*(2q Nd eps / ep0)^0.5* [('#1060'b/q)^0.5 - ('#1060'b/q-Vs)^0.5]'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label17: TLabel [16]
    Left = 10
    Top = 88
    Width = 129
    Height = 19
    Caption = 'S - contact area'
  end
  object Label18: TLabel [17]
    Left = 327
    Top = 88
    Width = 277
    Height = 19
    Caption = 'Ar - effective Richardson constant'
  end
  object Label19: TLabel [18]
    Left = 10
    Top = 166
    Width = 285
    Height = 19
    Caption = 'eps - permittivity of semiconductor'
  end
  object Label20: TLabel [19]
    Left = 327
    Top = 140
    Width = 367
    Height = 38
    Caption = 'Nd - carrier concentraqtion in semiconductor'
    WordWrap = True
  end
  object Label21: TLabel [20]
    Left = 8
    Top = 192
    Width = 404
    Height = 19
    Caption = 'Vs - voltage drop on semiconductor charge region'
  end
  object Label22: TLabel [21]
    Left = 203
    Top = 280
    Width = 376
    Height = 21
    Caption = 'Dit=ep ep0 /d * (q^-2) * d(Vcal-Vexp)/dVs'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  inherited Button1: TButton
    Top = 527
    ExplicitTop = 527
  end
  inherited Button2: TButton
    Left = 506
    Top = 528
    ExplicitLeft = 506
    ExplicitTop = 528
  end
  inherited LEXmin: TLabeledEdit
    Left = 10
    Top = 481
    Height = 27
    EditLabel.ExplicitLeft = 10
    EditLabel.ExplicitTop = 459
    ExplicitLeft = 10
    ExplicitTop = 481
    ExplicitHeight = 27
  end
  inherited LEXmax: TLabeledEdit
    Left = 353
    Top = 481
    Height = 27
    EditLabel.ExplicitLeft = 353
    EditLabel.ExplicitTop = 459
    ExplicitLeft = 353
    ExplicitTop = 481
    ExplicitHeight = 27
  end
  inherited LEYmax: TLabeledEdit
    Left = 525
    Top = 481
    Height = 27
    EditLabel.ExplicitLeft = 525
    EditLabel.ExplicitTop = 459
    ExplicitLeft = 525
    ExplicitTop = 481
    ExplicitHeight = 27
  end
  inherited LEYmin: TLabeledEdit
    Left = 181
    Top = 481
    Height = 27
    EditLabel.ExplicitLeft = 181
    EditLabel.ExplicitTop = 459
    ExplicitLeft = 181
    ExplicitTop = 481
    ExplicitHeight = 27
  end
end

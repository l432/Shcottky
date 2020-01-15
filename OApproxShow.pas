unit OApproxShow;

interface

uses
  OlegShowTypes, OlegType, StdCtrls, Forms, FrameButtons, OApproxNew;

const MarginLeft=20;
      MarginRight=30;
      Marginbetween=20;
      MarginTop=20;

//Function SelectFromVariants(Variants:TStringList;
//                            Index:ShortInt;
//                            WindowsCaption:string='Select'):ShortInt;
//{показує модальне вікно, де вибір радіо-кнопок,
//підписаних відповідно до вмісту Variants;
//при натиснутій "Ok" повертає
//індекс вибраного вваріанту, інакше -1}
//
//var Form:TForm;
//    ButOk,ButCancel: TButton;
//    RG:TRadioGroup;
//    i:integer;
//begin
// Result:=-1;
//
// Form:=TForm.Create(Application);
// Form.Position:=poMainFormCenter;
// Form.AutoScroll:=True;
// Form.BorderIcons:=[biSystemMenu];
// Form.ParentFont:=True;
// Form.Font.Style:=[fsBold];
// Form.Font.Height:=-16;
// Form.Caption:=WindowsCaption;
// Form.Color:=clMoneyGreen;
// RG:=TRadioGroup.Create(Form);
// RG.Parent:=Form;
// RG.Items:=Variants;
// if (Index>=0)and(Index<Variants.Count) then
//   RG.ItemIndex:=Index;
//
// if RG.Items.Count>8 then  RG.Columns:=3
//                     else  RG.Columns:=2;
// RG.Width:=RG.Columns*200+20;
// RG.Height:=Ceil(RG.Items.Count/RG.Columns)*50+20;
// Form.Width:=RG.Width;
// Form.Height:=RG.Height+100;
//  RG.Align:=alTop;
//
// ButOk:=TButton.Create(Form);
// ButOk.Parent:=Form;
// ButOk.ParentFont:=True;
// ButOk.Height:=30;
// ButOk.Width:=79;
// ButOk.Caption:='Ok';
// ButOk.ModalResult:=mrOk;
// ButOk.Top:=RG.Height+10;
// ButOk.Left:=round((Form.Width-2*ButOk.Width)/3.0);
//
// ButCancel:=TButton.Create(Form);
// ButCancel.Parent:=Form;
// ButCancel.ParentFont:=True;
// ButCancel.Height:=30;
// ButCancel.Width:=79;
// ButCancel.Caption:='Cancel';
// ButCancel.ModalResult:=mrCancel;
// ButCancel.Top:=RG.Height+10;
// ButCancel.Left:=2*ButOk.Left+ButOk.Width;
//
//  if Form.ShowModal=mrOk then Result:=RG.ItemIndex;
// for I := Form.ComponentCount-1 downto 0 do
//     Form.Components[i].Free;
// Form.Hide;
// Form.Release;
//end;



type
 TDiapazonDoubleParameterShow=class(TDoubleParameterShow)
  protected
   function ValueToString(Value:double):string;override;
   function GetData:double;override;
   function StringToExpectedStringConvertion(str:string):string;override;
 end;

 TDiapazoneGroupBox=class
   private
    fDiapazon:TDiapazon;
    fLabels:array [TDiapazonLimits] of TLabel;
    fSTexts:array [TDiapazonLimits] of TStaticText;
    fDDPShow:array [TDiapazonLimits] of TDiapazonDoubleParameterShow;
   public
    GB:TGroupBox;
    procedure UpDate;
    constructor Create(Diap:TDiapazon);
    destructor Destroy;override;
 end;

 TFitFunctionParameterShow=class(TParameterShow)
  private
   fFF:TFitFunctionNew;
   fForm:TForm;
   fButtons:TFrBut;
   fDiapazoneGB:TDiapazoneGroupBox;
  public
   Procedure Show();override;
   Constructor Create(FF:TFitFunctionNew);
   destructor Destroy;override;
 end;

implementation

uses
  SysUtils, Graphics, Controls, Math;

{ TDiapazonDoubleParameterShow }

function TDiapazonDoubleParameterShow.GetData: double;
begin
  if STData.Caption='No' then Result:=ErResult
                         else
     Result:=StrToFloat(STData.Caption);
end;

function TDiapazonDoubleParameterShow.StringToExpectedStringConvertion(
  str: string): string;
begin
  if (str='') or (str='555') then Result:='No'
                             else
      Result:=ValueToString(StrToFloat(str));
end;

function TDiapazonDoubleParameterShow.ValueToString(Value: double): string;
begin
 if Value=ErResult then Result:='No'
                   else
     Result:=FloatToStrF(Value,ffGeneral,fDigitNumber,fDigitNumber-1)
end;

{ TDiapazoneGroupBox }

constructor TDiapazoneGroupBox.Create(Diap: TDiapazon);
 var i:TDiapazonLimits;
begin
  fDiapazon:=Diap;
  GB:=TGroupBox.Create(nil);
  for I := Low(TDiapazonLimits) to High(TDiapazonLimits) do
   begin
     fLabels[i]:=TLabel.Create(GB);
     fLabels[i].AutoSize:=True;
     fLabels[i].Parent:=GB;
     fSTexts[i]:=TStaticText.Create(GB);
     fSTexts[i].AutoSize:=True;
     fSTexts[i].Parent:=GB;
     fDDPShow[i]:=TDiapazonDoubleParameterShow.Create(fSTexts[i],
                fLabels[i],fDiapazon.LimitCaption(i)+':',fDiapazon.LimitValue(i));
   end;
 fLabels[dlXMin].Top:=MarginTop+5;
 fLabels[dlXMin].Left:=MarginLeft;
 fSTexts[dlXMin].Top:=fLabels[dlXMin].Top;
 fSTexts[dlXMin].Left:=fLabels[dlXMin].Left+fLabels[dlXMin].Width+10;

 fLabels[dlYMin].Top:=fLabels[dlXMin].Top+fLabels[dlXMin].Height+Marginbetween;
 fLabels[dlYMin].Left:=fLabels[dlXMin].Left;
 fSTexts[dlYMin].Top:=fLabels[dlYMin].Top;
 fSTexts[dlYMin].Left:=fSTexts[dlXMin].Left;
// fSTexts[dlXMin].Left:=100;

 fLabels[dlXMax].Top:=fLabels[dlXMin].Top;
 fLabels[dlXMax].Left:=fSTexts[dlXMin].Left+70;
 fSTexts[dlXMax].Top:=fLabels[dlXMax].Top;
 fSTexts[dlXMax].Left:=fLabels[dlXMax].Left+fLabels[dlXMax].Width+10;

 fLabels[dlYMax].Top:= fLabels[dlYMin].Top;
 fLabels[dlYMax].Left:=fLabels[dlXMax].Left;
 fSTexts[dlYMax].Top:=fLabels[dlYMax].Top;
 fSTexts[dlYMax].Left:=fSTexts[dlXMax].Left;

 GB.Height:= fSTexts[dlYMax].Top+ fSTexts[dlYMax].Height+MarginTop;
 GB.Width:=fSTexts[dlYMax].Left+fSTexts[dlYMax].Width+MarginRight;
 GB.Caption:='Fitting range'
//  GB.Height:= 100;
// GB.Width:=100;

end;

destructor TDiapazoneGroupBox.Destroy;
 var i:TDiapazonLimits;
begin
  for I := Low(TDiapazonLimits) to High(TDiapazonLimits) do
   begin
     fDDPShow[i].Free;
     fLabels[i].Free;
     fSTexts[i].Free;
   end;
 GB.Free;
 fDiapazon:=nil;
 inherited;
end;

procedure TDiapazoneGroupBox.UpDate;
begin
  fDiapazon.SetLimits(fDDPShow[dlXmin].Data,
                      fDDPShow[dlXmax].Data,
                      fDDPShow[dlYmin].Data,
                      fDDPShow[dlYmax].Data);
end;

{ TFitFunctionParameterShow }

constructor TFitFunctionParameterShow.Create(FF: TFitFunctionNew);
begin
 fFF:=FF;
end;

destructor TFitFunctionParameterShow.Destroy;
begin
//  fFF:=nil;
  inherited;
end;

procedure TFitFunctionParameterShow.Show;
begin
 fForm:=TForm.Create(Application);
 fForm.Position:=poMainFormCenter;
 fForm.AutoScroll:=True;
 fForm.BorderIcons:=[biSystemMenu];
 fForm.ParentFont:=True;
 fForm.Font.Style:=[fsBold];
// fForm.Font.Height:=-16;
 fForm.Caption:='Parameters of '+fFF.Name+' function';
 fForm.Color:=clMoneyGreen;

 fDiapazoneGB:=TDiapazoneGroupBox.Create(fFF.Diapazon);
 fDiapazoneGB.GB.Parent:=fForm;

// fDiapazoneGB.GB.Align:=alTop;

 fButtons:=TFrBut.Create(fForm);
 fButtons.Parent:=fForm;
 fButtons.Left:=50;
 fButtons.Top:=fDiapazoneGB.GB.Top+fDiapazoneGB.GB.Height+MarginTop;

 fForm.Width:=max(fDiapazoneGB.GB.Width,fButtons.Width)+MarginLeft;
 fForm.Height:=fButtons.Top+fButtons.Height+MarginTop+50;

 if fForm.ShowModal=mrOk then
   begin
   fDiapazoneGB.UpDate;
   end;

 fButtons.Parent:=nil;
 fButtons.Free;
 fDiapazoneGB.GB.Parent:=nil;
 fDiapazoneGB.Free;

 fForm.Hide;
 fForm.Release;

end;

end.

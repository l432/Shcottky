unit OApproxShow;

interface

uses
  OlegShowTypes, OlegType, StdCtrls, Forms, FrameButtons,
  OApproxNew, ExtCtrls, OlegApprox, OlegFunction, Controls, Graphics;

const MarginLeft=20;
      MarginRight=30;
      Marginbetween=20;
      MarginTop=20;
      MarginFrame=2;

      NoLimit='No';


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

 TFFParameterBase=class(TFFParameter)
  private
   fFF:TFitFunctionNew;
   fDiapazoneGB:TDiapazoneGroupBox;
   fImg:TImage;
  public
   property FF:TFitFunctionNew read fFF;
   procedure FormPrepare(Form:TForm);override;
   procedure UpDate;override;
   procedure FormClear;override;
   Constructor Create(FF:TFitFunctionNew);
   Procedure WriteToIniFile;override;
   Procedure ReadFromIniFile;override;
   function IsReadyToFitDetermination:boolean;override;
 end;


 TOrientation=(oCol,oRow);
 {як розташовувати елементи
 oCol - один під одним
 oRow - в один рядок}

procedure RelativeLocation(ControlFirst,ControlSecond:TControl;
                           Orientation:TOrientation=oRow);
{розташовує ControlSecond відносно ControlFirst відповідно
до Orientation}

Procedure AddControlToForm(Control:TControl;
                           Form:TForm);

procedure ResizeLabel(Lab:TLabel;Canvas: TCanvas);

implementation

uses
  SysUtils, Math;

{ TDiapazonDoubleParameterShow }

function TDiapazonDoubleParameterShow.GetData: double;
begin
  if STData.Caption=NoLimit
    then Result:=ErResult
    else Result:=StrToFloat(STData.Caption);
end;

function TDiapazonDoubleParameterShow.StringToExpectedStringConvertion(
  str: string): string;
var  temp:double;
begin
  if str='555' then
    begin
    Result:=NoLimit;
    Exit;
    end;
  try
    try
    temp:=StrToFloat(str);
    except
     temp:=ErResult;
    end;
    Result:=ValueToString(temp);
//    Result:=ValueToString(StrToFloat(str));
  except
    Result:=NoLimit;
  end;
end;

function TDiapazonDoubleParameterShow.ValueToString(Value: double): string;
begin
 if Value=ErResult
   then Result:=NoLimit
   else
    Result:=FloatToStrF(Value,ffGeneral,
                fDigitNumber,fDigitNumber-1)
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

constructor TFFParameterBase.Create(FF: TFitFunctionNew);
begin
 fFF:=FF;
end;

//destructor TFitFunctionParameterShow.Destroy;
//begin
////  fFF:=nil;
//  inherited;
//end;

//procedure TFitFunctionParameterShow.ButtonsToForm(Top,Left: Integer);
//begin
//  fButtons := TFrBut.Create(fForm);
//  fButtons.Parent := fForm;
//  fButtons.Left := Left;
//  fButtons.Top := Top;
//end;

//procedure TFitFunctionParameterShow.DiapazonToForm(Top,Left: Integer);
//begin
//  fDiapazoneGB := TDiapazoneGroupBox.Create(fFF.Diapazon);
//  fDiapazoneGB.GB.Parent := fFF.Form;
//  fDiapazoneGB.GB.Top:=Top;
//  fDiapazoneGB.GB.Left:=Left;
//end;

procedure TFFParameterBase.FormClear;
begin
 fDiapazoneGB.GB.Parent:=nil;
 fDiapazoneGB.Free;
end;

procedure TFFParameterBase.FormPrepare(Form:TForm);
begin
 fDiapazoneGB := TDiapazoneGroupBox.Create(fFF.Diapazon);
 fDiapazoneGB.GB.Parent := Form;
 fDiapazoneGB.GB.Top:=10;
 fDiapazoneGB.GB.Left:=470;

 if fFF.HasPicture then
  begin
   fImg:=TImage.Create(Form);
//   fImg.Name:='Image';
   fImg.Parent:=Form;
   fImg.Top:=10;
   fImg.Left:=10;
   fImg.Height:=fDiapazoneGB.GB.Height;
   fImg.Width:=450;
   fImg.Stretch:=True;
   PictLoadScale(fImg,fFF.PictureName);
  end;


 Form.Width:=fDiapazoneGB.GB.Left+fDiapazoneGB.GB.Width;
 Form.Height:=10+fDiapazoneGB.GB.Height;
end;

function TFFParameterBase.IsReadyToFitDetermination:boolean;
begin
 Result:=True;
end;

procedure TFFParameterBase.ReadFromIniFile;
begin
  fFF.Diapazon.ReadFromIniFile(FFF.ConfigFile,fFF.Name,'DiapazonFit');
end;

//procedure TFitFunctionParameterShow.CreateForm;
//begin
//  fForm := TForm.Create(Application);
//  fForm.Position := poMainFormCenter;
//  fForm.AutoScroll := True;
//  fForm.BorderIcons := [biSystemMenu];
//  fForm.ParentFont := True;
//  fForm.Font.Style := [fsBold];
//  // fForm.Font.Height:=-16;
//  fForm.Caption := 'Parameters of ' + fFF.Name + ' function';
//  fForm.Color := clLtGray;
//end;

//procedure TFitFunctionParameterShow.PictureToForm(
//               maxWidth, maxHeight, Top, Left: integer);
//begin
// if fFF.HasPicture then
//  begin
//   fImg:=TImage.Create(fFF.Form);
////   fImg.Name:='Image';
//   fImg.Parent:=fFF.Form;
//   fImg.Top:=Top;
//   fImg.Left:=Left;
//   fImg.Height:=maxHeight;
//   fImg.Width:=maxWidth;
//   fImg.Stretch:=True;
//   PictLoadScale(fImg,fFF.PictureName);
//  end;
//end;

//procedure TFitFunctionParameterShow.Show;
//begin
// CreateForm;
// DiapazonToForm(10,460);
// PictureToForm(450,fDiapazoneGB.GB.Height,10,10);
//// ButtonsToForm(fDiapazoneGB.GB.Top
////               + fDiapazoneGB.GB.Height
////               + MarginTop,10);
//
// fForm.Width:=max(fDiapazoneGB.GB.Left+fDiapazoneGB.GB.Width,fButtons.Width)+2*MarginLeft;
// fForm.Height:=fButtons.Top+fButtons.Height+MarginTop+50;
//
// if fForm.ShowModal=mrOk then
//   begin
//     fDiapazoneGB.UpDate;
////     GRFieldFormExchange(Form,False);
//     fFF.IsReadyToFitDetermination;
//     if fFF.IsReadyToFit then  fFF.WriteToIniFile;
//   end;
//
// fButtons.Parent:=nil;
// fButtons.Free;
// fDiapazoneGB.GB.Parent:=nil;
// fDiapazoneGB.Free;
// ElementsFromForm(fForm);
//
// fForm.Hide;
// fForm.Release;
//
//end;

procedure TFFParameterBase.UpDate;
begin
 fDiapazoneGB.UpDate;
end;



procedure TFFParameterBase.WriteToIniFile;
begin
  fFF.ConfigFile.EraseSection(fFF.Name);
  fFF.Diapazon.WriteToIniFile(fFF.ConfigFile,fFF.Name,'DiapazonFit');
end;




procedure RelativeLocation(ControlFirst,ControlSecond:TControl;
                           Orientation:TOrientation=oRow);
 var tempInt:integer;
 begin
   if Orientation=oRow then
    begin
     ControlSecond.Left:=ControlFirst.Left+ControlFirst.Width+2*MarginFrame;
     ControlSecond.Top:=ControlFirst.Top
                       +Round((ControlFirst.Height-ControlSecond.Height)/2);
     if ControlSecond.Top<ControlFirst.Top then
      begin
       tempInt:=ControlFirst.Top;
       ControlFirst.Top:=2*ControlFirst.Top-ControlSecond.Top;
       ControlSecond.Top:=tempInt;
      end;

    end                else
    begin
     ControlSecond.Top:=ControlFirst.Top+ControlFirst.Height+2*MarginFrame;
     ControlSecond.Left:=ControlFirst.Left
                         +Round((ControlFirst.Width-ControlSecond.Width)/2);
     if ControlSecond.Left<ControlFirst.Left then
      begin
       tempInt:=ControlFirst.Left;
       ControlFirst.Left:=2*ControlFirst.Left-ControlSecond.Left;
       ControlSecond.Left:=tempInt;
      end;
    end;
 end;



Procedure AddControlToForm(Control:TControl;
                           Form:TForm);
 begin
 Control.Parent := Form;
 Control.Top:=Form.Height+MarginTop;
 Control.Left:=MarginLeft;
 Form.Height:=Control.Top+Control.Height;
 Form.Width:=max(Form.Width,
                Control.Left+Control.Width);

 end;

procedure ResizeLabel(Lab:TLabel;Canvas: TCanvas);
begin
  Lab.Width:=Canvas.TextWidth(Lab.Caption);
  Lab.Height:=Canvas.TextHeight(Lab.Caption);
end; 

end.

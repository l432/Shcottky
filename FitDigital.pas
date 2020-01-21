unit FitDigital;

interface

uses
  OApproxNew, StdCtrls, FitVariable, ExtCtrls, Forms, OlegApprox, 
  OlegDigitalManipulation;

type
 TLP_IIR_Chebyshev=(ch_p2f01,ch_p2f025,ch_p2f45,
             ch_p4f025,ch_p4f075,ch_p6f075,ch_p6f45);

//const

TLP_IIR_ChebyshevType=class
 private
  fFF:TFitFunctionNew;
  fValue:TLP_IIR_Chebyshev;
 public
  property LPType:TLP_IIR_Chebyshev read fValue;
  constructor Create(FF:TFitFunctionNew);
  procedure ReadFromIniFile;
  procedure WriteToIniFile;
end;

 TIIR_ChebyshevGroupBox=class
   private
    fType:TLP_IIR_ChebyshevType;
    RGPole,RGFreq:TRadioGroup;
    procedure  RGFreqFilling(Sender: TObject);
    procedure RGPoleFilling;
   public
    GB:TGroupBox;
    procedure UpDate;
    constructor Create(LPType:TLP_IIR_ChebyshevType);
    destructor Destroy;override;
 end;

 TDecIIR_ChebyshevParameter=class(TFFParameter)
   private
    fIIR_ChebyshevGB:TIIR_ChebyshevGroupBox;
    fType:TLP_IIR_ChebyshevType;
    fFFParameter:TFFParameter;
   public
    constructor Create(LPType:TLP_IIR_ChebyshevType;
                       FFParam:TFFParameter);
    procedure FormPrepare(Form:TForm);override;
    procedure UpDate;override;
    procedure FormClear;override;
    Procedure WriteToIniFile;override;
    Procedure ReadFromIniFile;override;
 end;


TFFDigitalFiltr=class(TFitFunctionNew)
 private
  fToDeleteTrancient:TVarBool;
  VDigMan:TVDigitalManipulation;
  procedure DigitalFiltering;virtual;abstract;
 protected
  procedure DipazonCreate;override;
  procedure DiapazonDestroy;override;
  procedure RealFitting;override;//abstract;
  function ParameterCreate:TFFParameter;override;
  Procedure RealToFile (suf:string;NumberDigit: Byte=4);override;
 public
end;

TFFLP_IIR_Chebyshev=class(TFFDigitalFiltr)
 private
  fType:TLP_IIR_ChebyshevType;
  procedure DigitalFiltering;override;
 protected
  procedure DipazonCreate;override;
  procedure DiapazonDestroy;override;
  function ParameterCreate:TFFParameter;override;
 public
 constructor Create;
end;

TFFMovingAverageFilter=class(TFFDigitalFiltr)
 private
  fIntParameters:TVarIntArray;
  procedure DigitalFiltering;override;
 protected
  procedure DipazonCreate;override;
  procedure DiapazonDestroy;override;
  function ParameterCreate:TFFParameter;override;
 public
  constructor Create;
end;


implementation

uses
  OApproxShow, Math;

{ TIIR_ChebyshevGroupBox }

constructor TIIR_ChebyshevGroupBox.Create(LPType:TLP_IIR_ChebyshevType);
begin
 fType:=LPType;
 GB:=TGroupBox.Create(nil);
 RGPole:=TRadioGroup.Create(GB);
 RGPole.Parent:=GB;
 RGPole.Caption:='Number of poles';


 RGFreq:=TRadioGroup.Create(GB);
 RGFreq.Parent:=GB;
 RGFreq.Caption:='Cutoff frequency';

 RGPole.OnClick:=RGFreqFilling;


 RGPole.Top:=MarginTop+5;
 RGPole.Left:=MarginLeft;

 RGFreq.Top:=RGPole.Top;
 RGFreq.Left:=RGPole.Left+RGPole.Width+Marginbetween;

 GB.Height:= RGPole.Top+ RGPole.Height+MarginTop;
 GB.Width:=RGFreq.Left+RGFreq.Width+MarginRight;
 GB.Caption:='Filter parameters';

end;

destructor TIIR_ChebyshevGroupBox.Destroy;
begin
 RGPole.Free;
 RGFreq.Free;
 GB.Free;
 fType:=nil;
 inherited;
end;

procedure TIIR_ChebyshevGroupBox.RGPoleFilling;
begin
  RGPole.Items.Add('2');
  RGPole.Items.Add('4');
  RGPole.Items.Add('6');
 if fType.LPType in [ch_p2f01,ch_p2f025,ch_p2f45]
    then RGPole.ItemIndex:=0;
 if fType.LPType in [ch_p4f025,ch_p4f075]
    then RGPole.ItemIndex:=1;
 if fType.LPType in [ch_p6f075,ch_p6f45]
    then RGPole.ItemIndex:=2;

end;

procedure TIIR_ChebyshevGroupBox.RGFreqFilling(Sender: TObject);
begin
 RGFreq.Items.Clear;
 if RGPole.ItemIndex=0 then
   begin
    RGFreq.Items.Add('0.01');
    RGFreq.Items.Add('0.025');
    RGFreq.Items.Add('0.45');
    if fType.LPType=ch_p2f45
       then RGFreq.ItemIndex:=2
       else if fType.LPType=ch_p2f025
          then RGFreq.ItemIndex:=1
          else RGFreq.ItemIndex:=0;
   end;
 if RGPole.ItemIndex=1 then
   begin
    RGFreq.Items.Add('0.025');
    RGFreq.Items.Add('0.075');
    if fType.LPType=ch_p4f075
       then RGFreq.ItemIndex:=1
       else RGFreq.ItemIndex:=0;
   end;
 if RGPole.ItemIndex=2 then
   begin
    RGFreq.Items.Add('0.075');
    RGFreq.Items.Add('0.45');
    if fType.LPType=ch_p6f45
       then RGFreq.ItemIndex:=1
       else RGFreq.ItemIndex:=0;
   end;
end;

procedure TIIR_ChebyshevGroupBox.UpDate;
begin
 if RGPole.ItemIndex=0 then
   begin
    if RGFreq.ItemIndex=2
      then fType.fValue:=ch_p2f45
      else if RGFreq.ItemIndex=1
           then fType.fValue:=ch_p2f025
           else fType.fValue:=ch_p2f01;
   end                 else
   if RGPole.ItemIndex=1 then
     begin
      if RGFreq.ItemIndex=1
         then fType.fValue:=ch_p4f075
         else fType.fValue:=ch_p4f025
     end                else
        if RGFreq.ItemIndex=1
          then  fType.fValue:=ch_p6f45
          else  fType.fValue:=ch_p6f075;
end;

{ LP_IIR_ChebyshevType }

constructor TLP_IIR_ChebyshevType.Create(FF: TFitFunctionNew);
begin
 fFF:=FF;
end;

procedure TLP_IIR_ChebyshevType.ReadFromIniFile;
begin
 try
  fValue:=TLP_IIR_Chebyshev(fFF.ConfigFile.ReadInteger(fFF.Name,'LPType',0));
 except
  fValue:=TLP_IIR_Chebyshev(0);
 end;
end;

procedure TLP_IIR_ChebyshevType.WriteToIniFile;
begin
  fFF.ConfigFile.WriteInteger(fFF.Name,'LPType',ord(fValue));
end;

{ TDecIIR_ChebyshevParameter }

constructor TDecIIR_ChebyshevParameter.Create(LPType:TLP_IIR_ChebyshevType;
                       FFParam:TFFParameter);
begin
 fFFParameter:=FFParam;
 fType:=LPType;
end;


procedure TDecIIR_ChebyshevParameter.FormClear;
begin
 fIIR_ChebyshevGB.GB.Parent:=nil;
 fIIR_ChebyshevGB.Free;
 fFFParameter.FormClear;
end;

procedure TDecIIR_ChebyshevParameter.FormPrepare(Form: TForm);
begin
 fFFParameter.FormPrepare(Form);
 fIIR_ChebyshevGB:=TIIR_ChebyshevGroupBox.Create(fType);
// fIIR_ChebyshevGB.GB.Parent := Form;
 AddControlToForm(fIIR_ChebyshevGB.GB,Form);
 fIIR_ChebyshevGB.RGPoleFilling;
// fIIR_ChebyshevGB.GB.Top:=Form.Height+MarginTop;
// fIIR_ChebyshevGB.GB.Left:=MarginLeft;
// Form.Height:=fIIR_ChebyshevGB.GB.Top+fIIR_ChebyshevGB.GB.Height;
// Form.Width:=max(Form.Width,
//                fIIR_ChebyshevGB.GB.Left+fIIR_ChebyshevGB.GB.Width);
end;

procedure TDecIIR_ChebyshevParameter.ReadFromIniFile;
begin
  fFFParameter.ReadFromIniFile;
  fType.ReadFromIniFile;
end;

procedure TDecIIR_ChebyshevParameter.UpDate;
begin
  fFFParameter.UpDate;
  fIIR_ChebyshevGB.UpDate;
end;

procedure TDecIIR_ChebyshevParameter.WriteToIniFile;
begin
 fFFParameter.WriteToIniFile;
 fType.WriteToIniFile;
end;

{ TFFLP_IIR_Chebyshev }

constructor TFFLP_IIR_Chebyshev.Create;
begin
 inherited Create('LP IIR Chebyshev',
   'Low pass first order Chebyshev filter with infinite '+
   'impulse responce, irregularity of amplitude-frequency '
   +'characteristic is 0.5% in the transmission band; '+
   'cutoff  frequency is part of Nyquist frequency.');

end;

procedure TFFLP_IIR_Chebyshev.DiapazonDestroy;
begin
 fType.Free;
 inherited;
end;

procedure TFFLP_IIR_Chebyshev.DigitalFiltering;
begin
 case fType.LPType of
  ch_p2f01:VDigMan.LP_IIR_Chebyshev001p2(fToDeleteTrancient.Value);
  ch_p2f025:VDigMan.LP_IIR_Chebyshev0025p2(fToDeleteTrancient.Value);
  ch_p2f45:VDigMan.LP_IIR_Chebyshev045p2(fToDeleteTrancient.Value);
  ch_p4f025:VDigMan.LP_IIR_Chebyshev0025p4(fToDeleteTrancient.Value);
  ch_p4f075:VDigMan.LP_IIR_Chebyshev0075p4(fToDeleteTrancient.Value);
  ch_p6f075:VDigMan.LP_IIR_Chebyshev0075p6(fToDeleteTrancient.Value);
  ch_p6f45:VDigMan.LP_IIR_Chebyshev045p6(fToDeleteTrancient.Value);
 end;
end;

procedure TFFLP_IIR_Chebyshev.DipazonCreate;
begin
  inherited;
  fType:=TLP_IIR_ChebyshevType.Create(Self);
end;

function TFFLP_IIR_Chebyshev.ParameterCreate: TFFParameter;
begin
 Result:=TDecIIR_ChebyshevParameter.Create(fType,
               inherited ParameterCreate);
// Result:=TDecIIR_ChebyshevParameter.Create(fType,
//           TDecBoolVarParameter.Create(fToDeleteTrancient,
//               inherited ParameterCreate));
end;


{ TMovingAverageFilter }

constructor TFFMovingAverageFilter.Create;
begin
 inherited Create('Moving Average Filter',
   'Moving Average Filter');
end;

procedure TFFMovingAverageFilter.DiapazonDestroy;
begin
 fIntParameters.Free;
 inherited;
end;

procedure TFFMovingAverageFilter.DigitalFiltering;
begin
 VDigMan.MovingAverageFilter(fIntParameters.Parametr[0].Value,
                             fToDeleteTrancient.Value);
end;

procedure TFFMovingAverageFilter.DipazonCreate;
begin
  inherited;
  fIntParameters:=TVarIntArray.Create(Self,'Np',2);
  fIntParameters.ParametrByName['Np'].Limits.SetLimits(2);
  fIntParameters.ParametrByName['Np'].Description:='Points for averaging';
end;

function TFFMovingAverageFilter.ParameterCreate: TFFParameter;
begin
 Result:=TDeVarIntArrayParameter.Create(fIntParameters,
                         inherited ParameterCreate);
end;


{ TFFDigitalFiltr }

procedure TFFDigitalFiltr.DiapazonDestroy;
begin
 fToDeleteTrancient.Free;
 VDigMan.Free;
 inherited;
end;

procedure TFFDigitalFiltr.DipazonCreate;
begin
  inherited;
  fToDeleteTrancient:=TVarBool.Create(Self,'To Delete Trancient');
  VDigMan:=TVDigitalManipulation.Create;
end;

function TFFDigitalFiltr.ParameterCreate: TFFParameter;
begin
 Result:=TDecBoolVarParameter.Create(fToDeleteTrancient,
               inherited ParameterCreate);
end;

procedure TFFDigitalFiltr.RealFitting;
begin
 VDigMan.CopyFrom(fDataToFit);
 DigitalFiltering;
 VDigMan.CopyTo(FittingData);
 if not(FittingData.IsEmpty) then inherited RealFitting;
end;

procedure TFFDigitalFiltr.RealToFile(suf: string; NumberDigit: Byte);
begin
 if fToDeleteTrancient.Value then
     FittingData.WriteToFile(FitName(fDataToFit,suf),NumberDigit)
                             else
     Inherited  RealToFile(suf,NumberDigit);
end;

end.

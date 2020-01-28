unit FitDigital;

interface

uses
  OApproxNew, StdCtrls, FitVariable, ExtCtrls, Forms, OlegApprox, 
  OlegDigitalManipulation;

const
  FD_CutOff='cutoff  frequency is fraction of Nyquist frequency';
  FD_LP='Low pass ';
  FD_HP='High pass ';
  FD_IIR='with infinite impulse responce';
  FD_FIR='with finite impulse responce';

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
    function IsReadyToFitDetermination:boolean;override;
 end;


TFFDigitalFiltr=class(TFitFunctionNew)
 private
  fToDeleteTrancient:TVarBool;
  VDigMan:TVDigitalManipulation;
  procedure DigitalFiltering;virtual;abstract;
 protected
  procedure AccessorialDataCreate;override;
  procedure AccessorialDataDestroy;override;
  procedure RealFitting;override;
  function ParameterCreate:TFFParameter;override;
  Procedure RealToFile;override;
  procedure Tuning;override;
 public
end;

TFFLP_IIR_Chebyshev=class(TFFDigitalFiltr)
 private
  fType:TLP_IIR_ChebyshevType;
  procedure DigitalFiltering;override;
 protected
  procedure AccessorialDataCreate;override;
  procedure AccessorialDataDestroy;override;
  function ParameterCreate:TFFParameter;override;
  procedure NamesDefine;override;
 public
// constructor Create;
end;

TFFMovingAverageFilter=class(TFFDigitalFiltr)
 private
  fIntParameters:TVarIntArray;
  procedure DigitalFiltering;override;
 protected
  procedure AccessorialDataCreate;override;
  procedure AccessorialDataDestroy;override;
  function ParameterCreate:TFFParameter;override;
  procedure NamesDefine;override;
 public
//  constructor Create;
end;

TFFLP_UniformBase=class(TFFDigitalFiltr)
 private
  fFreqFactor:TVarDoubArray;
 protected
  procedure AccessorialDataCreate;override;
  procedure AccessorialDataDestroy;override;
  function ParameterCreate:TFFParameter;override;
 public
end;

TFFLP_UniformIIRFilter=class(TFFLP_UniformBase)
 private
  procedure DigitalFiltering;override;
 protected
  procedure NamesDefine;override;
 public
//  constructor Create;
end;


TFFLP_UniformIIRFilter4k=class(TFFLP_UniformBase)
 private
  procedure DigitalFiltering;override;
 protected
  procedure NamesDefine;override;
 public
//  constructor Create;
end;

TFFFIR_Base=class(TFFLP_UniformBase)
 private
  fOrder:TVarIntArray;
 protected
  procedure AccessorialDataCreate;override;
  procedure AccessorialDataDestroy;override;
  function ParameterCreate:TFFParameter;override;
 public
end;

TFFLP_FIR_Blackman=class(TFFFIR_Base)
 private
  procedure DigitalFiltering;override;
 protected
  procedure NamesDefine;override;
 public
//  constructor Create;
end;

TFFHP_FIR_SimpleWindow=class(TFFFIR_Base)
 private
  procedure DigitalFiltering;override;
 protected
  procedure NamesDefine;override;
 public
//  constructor Create;
end;

TFFLP_FIR_SimpleWindow=class(TFFFIR_Base)
 private
  procedure DigitalFiltering;override;
 protected
  procedure NamesDefine;override;
 public
//  constructor Create;
end;

TFFLP_FIR_HammingWindow=class(TFFFIR_Base)
 private
  procedure DigitalFiltering;override;
 protected
  procedure NamesDefine;override;
 public
//  constructor Create;
end;

TFFLP_FIR_HannWindow=class(TFFFIR_Base)
 private
  procedure DigitalFiltering;override;
 protected
  procedure NamesDefine;override;
 public
//  constructor Create;
end;

TFFLP_FIR_BartlettWindow=class(TFFFIR_Base)
 private
  procedure DigitalFiltering;override;
 protected
  procedure NamesDefine;override;
 public
//  constructor Create;
end;

TFFLP_FIR_ChebyshevWindow=class(TFFFIR_Base)
 private
  procedure DigitalFiltering;override;
 protected
  procedure NamesDefine;override;
  procedure AccessorialDataCreate;override;
 public
//  constructor Create;
end;


implementation

uses
  OApproxShow, Math, Graphics, FitVariableShow, Dialogs;

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
 AddControlToForm(fIIR_ChebyshevGB.GB,Form);
 fIIR_ChebyshevGB.RGPoleFilling;
end;

function TDecIIR_ChebyshevParameter.IsReadyToFitDetermination: boolean;
begin
 Result:=fFFParameter.IsReadyToFitDetermination;
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

//constructor TFFLP_IIR_Chebyshev.Create;
//begin
// inherited Create;
//
//
//end;

procedure TFFLP_IIR_Chebyshev.AccessorialDataDestroy;
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

procedure TFFLP_IIR_Chebyshev.NamesDefine;
begin
 SetNameCaption('LP_IIR_Chebyshev',
   FD_LP+'first order Chebyshev filter '+FD_IIR+
   ', irregularity of amplitude-frequency '
   +'characteristic is 0.5% in the transmission band; '+FD_CutOff);
end;

procedure TFFLP_IIR_Chebyshev.AccessorialDataCreate;
begin
  inherited;
  fType:=TLP_IIR_ChebyshevType.Create(Self);
end;

function TFFLP_IIR_Chebyshev.ParameterCreate: TFFParameter;
begin
 Result:=TDecIIR_ChebyshevParameter.Create(fType,
               inherited ParameterCreate);
end;


{ TMovingAverageFilter }

//constructor TFFMovingAverageFilter.Create;
//begin
// inherited Create;
//
//end;

procedure TFFMovingAverageFilter.AccessorialDataDestroy;
begin
 fIntParameters.Free;
 inherited;
end;

procedure TFFMovingAverageFilter.DigitalFiltering;
begin
 VDigMan.MovingAverageFilter(fIntParameters[0],
                             fToDeleteTrancient.Value);
end;

procedure TFFMovingAverageFilter.NamesDefine;
begin
 SetNameCaption('MovAverFilter',
   'Moving Average Filter');
end;

procedure TFFMovingAverageFilter.AccessorialDataCreate;
begin
  inherited;
  fIntParameters:=TVarIntArray.Create(Self,'Np');
  fIntParameters[0]:=2;
  fIntParameters.ParametrByName['Np'].Limits.SetLimits(2);
  fIntParameters.ParametrByName['Np'].Description:='Points for averaging';
end;

function TFFMovingAverageFilter.ParameterCreate: TFFParameter;
begin
 Result:=TDecVarNumberArrayParameter.Create(fIntParameters,
                         inherited ParameterCreate);
end;


{ TFFDigitalFiltr }

procedure TFFDigitalFiltr.AccessorialDataDestroy;
begin
 fToDeleteTrancient.Free;
 VDigMan.Free;
 inherited;
end;

procedure TFFDigitalFiltr.AccessorialDataCreate;
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
// if not(FittingData.IsEmpty) then fResultsIsReady:=True;
end;

procedure TFFDigitalFiltr.RealToFile;
begin
 if fToDeleteTrancient.Value then
     FittingData.WriteToFile(FitName(fDataToFit,FileSuffix),DigitNumber,'X Yfit')
                             else
     Inherited  RealToFile;
end;



procedure TFFDigitalFiltr.Tuning;
begin
  inherited;
  fHasPicture:=False;
end;

{ TFFLP_UniformIIRFilter }



procedure TFFLP_UniformBase.AccessorialDataDestroy;
begin
 fFreqFactor.Free;
 inherited;
end;

procedure TFFLP_UniformBase.AccessorialDataCreate;
begin
  inherited;
  fFreqFactor:=TVarDoubArray.Create(Self,'Fcut');
  fFreqFactor[0]:=0.5;
  fFreqFactor.ParametrByName['Fcut'].Limits.SetLimits(0,0.5);
  fFreqFactor.ParametrByName['Fcut'].Description:=
           'Cut-off frequency (0..0.5)';
//  (fFreqFactor.ParametrByName['Fcut'] as TVarDouble).ManualDetermOnly :=True;
end;

function TFFLP_UniformBase.ParameterCreate: TFFParameter;
begin
 Result:=TDecVarNumberArrayParameter.Create(fFreqFactor,
                         inherited ParameterCreate);
end;

{ TFFLP_UniformIIRFilter }

//constructor TFFLP_UniformIIRFilter.Create;
//begin
// inherited Create;
// SetNameCaption('LP_Uniform ',
//   FD_LP+'uniform recursive '
//   +'filter (exponential averaging) '+FD_IIR
//   +', 1 cascade; '+FD_CutOff);
//end;

procedure TFFLP_UniformIIRFilter.DigitalFiltering;
begin
 VDigMan.LP_UniformIIRfilter(fFreqFactor[0],
                             fToDeleteTrancient.Value);
end;

procedure TFFLP_UniformIIRFilter.NamesDefine;
begin
 SetNameCaption('LP_Uniform ',
   FD_LP+'uniform recursive '
   +'filter (exponential averaging) '+FD_IIR
   +', 1 cascade; '+FD_CutOff);
end;

{ TFFLP_UniformIIRFilter4k }

//constructor TFFLP_UniformIIRFilter4k.Create;
//begin
// inherited Create;
// SetNameCaption('LP_Uniform4k',
//   FD_LP+'uniform recursive '
//   +'filter (exponential averaging) '+FD_IIR
//   +', 4 cascade; '+FD_CutOff);
//end;

procedure TFFLP_UniformIIRFilter4k.DigitalFiltering;
begin
 VDigMan.LP_UniformIIRfilter4k(fFreqFactor[0],
                             fToDeleteTrancient.Value);
end;

{ TFFFIR_Base }

procedure TFFFIR_Base.AccessorialDataDestroy;
begin
 fOrder.Free;
 inherited;
end;

procedure TFFFIR_Base.AccessorialDataCreate;
begin
  inherited;
  fFreqFactor.ParametrByName['Fcut'].Limits.SetLimits(0,1);
  fFreqFactor.ParametrByName['Fcut'].Description:=
           'Cut-off frequency (0..1)';

  fOrder:=TVarIntArray.Create(Self,'Order');
  fOrder[0]:=2;
  fOrder.ParametrByName['Order'].Limits.SetLimits(0);
  (fOrder.ParametrByName['Order'] as TVarInteger).IsNoOdd:=True;
  fOrder.ParametrByName['Order'].Description:=
           'Filter order (must be even number)';
end;

function TFFFIR_Base.ParameterCreate: TFFParameter;
begin
 Result:=TDecVarNumberArrayParameter.Create(fOrder,
                         inherited ParameterCreate);
end;

{ TFFLP_FIR_Blackman }

//constructor TFFLP_FIR_Blackman.Create;
//begin
// inherited Create;
// SetNameCaption('FIR_Blackman',
//   FD_LP+'filter '+FD_FIR
//   +' and Blackman window; '+FD_CutOff);
//end;

procedure TFFLP_FIR_Blackman.DigitalFiltering;
begin
 VDigMan.LP_FIR_Blackman(fOrder[0],
                         fFreqFactor[0],
                         fToDeleteTrancient.Value);
end;

{ TFFHP_FIR_SimpleWindow }

//constructor TFFHP_FIR_SimpleWindow.Create;
//begin
// inherited Create;
// SetNameCaption('HP_FIR_Window',
//   FD_HP+'filter '+ FD_FIR
//   +' and rectangular window; '+FD_CutOff);
//end;

procedure TFFHP_FIR_SimpleWindow.DigitalFiltering;
begin
 VDigMan.HP_FIR_SimpleWindow(fOrder[0],
                         fFreqFactor[0],
                         fToDeleteTrancient.Value);
end;

{ TFFLP_FIR_SimpleWindow }

//constructor TFFLP_FIR_SimpleWindow.Create;
//begin
// inherited Create;
// SetNameCaption('LP_FIR_Window',
//   FD_LP+'filter '+ FD_FIR
//   +' and rectangular window; '+FD_CutOff);
//end;


procedure TFFLP_FIR_SimpleWindow.DigitalFiltering;
begin
 VDigMan.LP_FIR_SimpleWindow(fOrder[0],
                         fFreqFactor[0],
                         fToDeleteTrancient.Value);
end;

{ TFFLP_FIR_HammingWindow }

//constructor TFFLP_FIR_HammingWindow.Create;
//begin
// inherited Create;
// SetNameCaption('FIR_Hamming',
//   FD_LP+'filter '+ FD_FIR
//   +' and Hamming window; '+FD_CutOff);
//end;


procedure TFFLP_FIR_HammingWindow.DigitalFiltering;
begin
 VDigMan.LP_FIR_Hamming(fOrder[0],
                         fFreqFactor[0],
                         fToDeleteTrancient.Value);
end;

{ TFFLP_FIR_HannWindow }

//constructor TFFLP_FIR_HannWindow.Create;
//begin
// inherited Create;
// SetNameCaption('FIR_Hann',
//   FD_LP+'filter '+ FD_FIR
//   +' and Hann window; '+FD_CutOff);
//end;

procedure TFFLP_FIR_HannWindow.DigitalFiltering;
begin
 VDigMan.LP_FIR_Hann(fOrder[0],
                         fFreqFactor[0],
                         fToDeleteTrancient.Value);
end;

{ TFFLP_FIR_BartlettWindow }

//constructor TFFLP_FIR_BartlettWindow.Create;
//begin
// inherited Create;
// SetNameCaption('FIR_Bartlett',
//   FD_LP+'filter '+ FD_FIR
//   +' and Bartlett (triangular) window; '+FD_CutOff);
//end;

procedure TFFLP_FIR_BartlettWindow.DigitalFiltering;
begin
 VDigMan.LP_FIR_Bartlett(fOrder[0],
                         fFreqFactor[0],
                         fToDeleteTrancient.Value);
end;

{ TFFLP_FIR_ChebyshevWindow }

//constructor TFFLP_FIR_ChebyshevWindow.Create;
//begin
// inherited Create;
// SetNameCaption('FIR_Chebyshev',
//   FD_LP+'filter '+ FD_FIR
//   +' and Chebyshev window, '
//   +'level of minor lobe can be tuned; '+FD_CutOff);
//end;

procedure TFFLP_FIR_ChebyshevWindow.DigitalFiltering;
begin
 VDigMan.LP_FIR_Chebyshev(fOrder[0],
                         fFreqFactor[0],
                         fToDeleteTrancient.Value,
                         fFreqFactor[1]);
end;

procedure TFFLP_FIR_ChebyshevWindow.NamesDefine;
begin
 SetNameCaption('FIR_Chebyshev',
   FD_LP+'filter '+ FD_FIR
   +' and Chebyshev window, '
   +'level of minor lobe can be tuned; '+FD_CutOff);
end;

procedure TFFLP_FIR_ChebyshevWindow.AccessorialDataCreate;
begin
 inherited;
 fFreqFactor.Add(Self,'A');
 fFreqFactor.ParametrByName['A'].Limits.SetLimits(0);
 fFreqFactor.ParametrByName['A'].Description:=
           'Minor lobe level, []=dB';
//(fFreqFactor.ParametrByName['A'] as TVarDouble).ManualDetermOnly :=True;

end;


procedure TFFLP_UniformIIRFilter4k.NamesDefine;
begin
 SetNameCaption('LP_Uniform4k',
   FD_LP+'uniform recursive '
   +'filter (exponential averaging) '+FD_IIR
   +', 4 cascade; '+FD_CutOff);
end;

procedure TFFLP_FIR_Blackman.NamesDefine;
begin
 SetNameCaption('FIR_Blackman',
   FD_LP+'filter '+FD_FIR
   +' and Blackman window; '+FD_CutOff);
end;

procedure TFFHP_FIR_SimpleWindow.NamesDefine;
begin
 SetNameCaption('HP_FIR_Window',
   FD_HP+'filter '+ FD_FIR
   +' and rectangular window; '+FD_CutOff);
end;

procedure TFFLP_FIR_SimpleWindow.NamesDefine;
begin
 SetNameCaption('LP_FIR_Window',
   FD_LP+'filter '+ FD_FIR
   +' and rectangular window; '+FD_CutOff);
end;

procedure TFFLP_FIR_HammingWindow.NamesDefine;
begin
 SetNameCaption('FIR_Hamming',
   FD_LP+'filter '+ FD_FIR
   +' and Hamming window; '+FD_CutOff);
end;

procedure TFFLP_FIR_HannWindow.NamesDefine;
begin
 SetNameCaption('FIR_Hann',
   FD_LP+'filter '+ FD_FIR
   +' and Hann window; '+FD_CutOff);
end;

procedure TFFLP_FIR_BartlettWindow.NamesDefine;
begin
 SetNameCaption('FIR_Bartlett',
   FD_LP+'filter '+ FD_FIR
   +' and Bartlett (triangular) window; '+FD_CutOff);
end;

end.

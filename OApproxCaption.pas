unit OApproxCaption;

interface

uses
  OApproxNew, FitDigital, FitSimple, FitGradient, OApproxFunction;

type
  TFitFuncCategory=(ffc_none,ffc_trans,ffc_digital,
                   ffc_simple,ffc_schottky,ffc_diode,ffc_2diode,
                   ffc_ThinDiode,ffc_Custom,ffc_fb);

  TFitFunctionNew_Class=class of TFitFunctionNew;


//  TFitFunctionNames=array of string;
const
  FitFuncCategoryNames:array[TFitFuncCategory]of string=
           ('None','Transform','Digital filter','Simple',
           'Schottky diode','n-p diode','Double Diode',
           'Thin film diode','Custom','Fe-B');

//  FitFuncCategoryNumbers:array[TFitFuncCategory]of integer=
//           (-1,  //ffc_none
//            5,   //ffc_trans
//            9,   //ffc_digital
//            4,   //ffc_simple
//            1,   //ffc_schottky
//            4,   //ffc_diode
//            0);  //ffc_ThinDiode


  DFNumber=9;
  DFNames:array[0..DFNumber]of string=
   ('LP IIR Chebyshev', 'LP IIR Uniform',
    'LP IIR Uniform, 4k','LP FIR Simple Window',
    'LP FIR Blackman','LP FIR Hamming',
    'LP FIR Hann', 'LP FIR Bartlett',
    'LP FIR Chebyshev','HP FIR Simple Window');
  DFClasses:array[0..DFNumber]of TFitFunctionNew_Class=
  (TFFLP_IIR_Chebyshev,TFFLP_UniformIIRFilter,TFFLP_UniformIIRFilter4k,
  TFFLP_FIR_SimpleWindow,TFFLP_FIR_Blackman,TFFLP_FIR_HammingWindow,
  TFFLP_FIR_HannWindow,TFFLP_FIR_BartlettWindow,
  TFFLP_FIR_ChebyshevWindow,TFFHP_FIR_SimpleWindow);


  SFNumber=5;
  SFNames:array[0..SFNumber] of string=
   ('Linear','Ohm law','Quadratic function','Gromov / Lee',
   'Polynomial fitting','Variate Polynomial');
   SFClasses:array[0..SFNumber]of TFitFunctionNew_Class=
   (TFFLinear,TFFOhmLaw,TFFQuadratic,TFFGromov,
   TFFPolinom,TFFTwoPower);

  SchDNumber=3;
  SchDNames:array[0..SchDNumber] of string=
   ('Exponent','Ivanov method','D-Gaussian','Patch Barrier');
   SchDClasses:array[0..SchDNumber]of TFitFunctionNew_Class=
   (TFFExponent,TFFIvanov,TFFDGaus,TFFLinEg);

  DiodNumber=5;
  DiodNames:array[0..DiodNumber] of string=
   ('Diode','Diode, LSM','Diode, Lambert',
    'PhotoDiode','PhotoDiode, LSM','PhotoDiode, Lambert');
  DiodClasses:array[0..DiodNumber]of TFitFunctionNew_Class=
   (TFFDiod,TFFDiodLSM,TFFDiodLam,
    TFFPhotoDiod,TFFPhotoDiodLSM,TFFPhotoDiodLam);

  TwoDiodNumber=0;
  TwoDiodNames:array[0..TwoDiodNumber] of string=
   ('Two Diode Full');
  TwoDiodClasses:array[0..TwoDiodNumber]of TFitFunctionNew_Class=
   (TFFDiodTwoFull);

  ThinDiodeNumber=4;
  ThinDiodeNames:array[0..ThinDiodeNumber] of string=
   ('IV thin SC','Tunneling diode forward',
   'Illuminated tunneling diod',
   'TAT reverse', 'TAT reverse with Rs');
  ThinDiodeClasses:array[0..ThinDiodeNumber]of TFitFunctionNew_Class=
   (TFFIV_thin,TFFDiodTun,
    TFFPhotoDiodTun,
    TFFTunRevers,TFFTunReversRs);

  CustomNumber=2;
  CustomNames:array[0..CustomNumber] of string=
   ('Lifetime in SCR','Mobility','n vs T (donors and traps)');
  CustomClasses:array[0..CustomNumber]of TFitFunctionNew_Class=
   (TFFTauG,TFFMobility,TFFElectronConcentration);

  FeBNumber=0;
  FeBNames:array[0..FeBNumber] of string=
   ('Ideal. Factor vs T');
  FeBClasses:array[0..FeBNumber]of TFitFunctionNew_Class=
   (TFFnFeBPart);

var
  FitFuncNames:array[TFitFuncCategory]of array of string;


Function FitFunctionFactory(str:string; FileName:string=''):TFitFunctionNew;
{створює F того чи іншого типу залежно
від значення str}


procedure FitFuncNames_trans_Filling;
//procedure FitFuncNames_digital_Filling;
//procedure FitFuncNames_simple_Filling;
//procedure FitFuncNames_schottky_Filling;
//procedure FitFuncNames_diod_Filling;
//procedure FitFuncNames_ThinDiode_Filling;

procedure FitFuncNames_Filling(ffc:TFitFuncCategory;
                               Names:array of string);

implementation

uses
  FitTransform;

procedure FitFuncNames_Filling(ffc:TFitFuncCategory;Names:array of string);
  var i:integer;
begin
   SetLength(FitFuncNames[ffc],Length(Names));
   for I := 0 to High(FitFuncNames[ffc]) do
    FitFuncNames[ffc,i]:=Names[i+Low(Names)];
end;


procedure FitFuncNames_trans_Filling;
  var i:TTransformFunction;
begin
 SetLength(FitFuncNames[ffc_trans],ord(High(TTransformFunction))+4);
  for I := Low(TTransformFunction) to High(TTransformFunction) do
   FitFuncNames[ffc_trans,ord(I)]:=TransformFunctionNames[i];
 FitFuncNames[ffc_trans,High(FitFuncNames[ffc_trans])-2]:='Moving Average Filter';
 FitFuncNames[ffc_trans,High(FitFuncNames[ffc_trans])-1]:='Noise Smoothing';
 FitFuncNames[ffc_trans,High(FitFuncNames[ffc_trans])]:='Cubic splines';
end;

Function FitFunctionFactory(str:string; FileName:string=''):TFitFunctionNew;
{створює F того чи іншого типу залежно
від значення str}
  var i:TTransformFunction;
      j:integer;
begin
   Result:=nil;

   for I := Low(TTransformFunction)
                to High(TTransformFunction) do
      if str=TransformFunctionNames[i] then
        begin
          Result:=TFitTransform.Create(str);
          Exit;
        end;

   for j := 0 to DFNumber do
      if str=DFNames[j] then
       begin
         Result:=DFClasses[j].Create;
         Exit;
       end;

   for j := 0 to SFNumber do
      if str=SFNames[j] then
       begin
         Result:=SFClasses[j].Create;
         Exit;
       end;

   for j := 0 to SchDNumber do
      if str=SchDNames[j] then
       begin
         Result:=SchDClasses[j].Create;
         Exit;
       end;

   for j := 0 to DiodNumber do
      if str=DiodNames[j] then
       begin
         Result:=DiodClasses[j].Create;
         Exit;
       end;

   for j := 0 to TwoDiodNumber do
      if str=TwoDiodNames[j] then
       begin
         Result:=TwoDiodClasses[j].Create;
         Exit;
       end;

   for j := 0 to ThinDiodeNumber do
      if str=ThinDiodeNames[j] then
       begin
         Result:=ThinDiodeClasses[j].Create;
         Exit;
       end;

   for j := 0 to CustomNumber do
     if str=CustomNames[j] then
      begin
       Result:=CustomClasses[j].Create;
       Exit;
      end;

   for j := 0 to FeBNumber do
     if str=FeBNames[j] then
      begin
       Result:=FeBClasses[j].Create;
       Exit;
      end;

   if str='Moving Average Filter' then
     begin
     Result:=TFFMovingAverageFilter.Create;
     Exit;
     end;



 if str='Noise Smoothing' then
     begin
     Result:=TFFNoiseSmoothing.Create;
     Exit;
     end;

 if str='Cubic splines' then
     begin
     Result:=TFFSplain.Create;
     Exit;
     end;

end;


initialization
 FitFuncNames_trans_Filling;
 FitFuncNames_Filling(ffc_digital,DFNames);
 FitFuncNames_Filling(ffc_simple,SFNames);
 FitFuncNames_Filling(ffc_schottky,SchDNames);
 FitFuncNames_Filling(ffc_diode,DiodNames);
 FitFuncNames_Filling(ffc_2diode,TwoDiodNames); 
 FitFuncNames_Filling(ffc_ThinDiode,ThinDiodeNames);
 FitFuncNames_Filling(ffc_Custom,CustomNames); 
 FitFuncNames_Filling(ffc_fb,FeBNames);

// FitFuncNames_digital_Filling;
// FitFuncNames_simple_Filling;
// FitFuncNames_schottky_Filling;
// FitFuncNames_diod_Filling;
// FitFuncNames_ThinDiode_Filling;



end.

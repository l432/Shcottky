unit OApproxCaption;

interface

uses
  OApproxNew, FitDigital, FitSimple, FitGradient, OApproxFunction;

type
  TFitFuncCategory=(ffc_none,ffc_trans,ffc_digital,
                   ffc_simple,ffc_schottky,ffc_diod);

  TFitFunctionNew_Class=class of TFitFunctionNew;

const
  FitFuncCategoryNames:array[TFitFuncCategory]of string=
           ('None','Transform','Digital filter','Simple',
           'Schottky diod','n-p diod');

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

  SFNumber=4;

  SFNames:array[0..SFNumber] of string=
   ('Linear','Ohm law','Quadratic function','Gromov / Lee',
   'Polynomial fitting');
   SFClasses:array[0..SFNumber]of TFitFunctionNew_Class=
   (TFFLinear,TFFOhmLaw,TFFQuadratic,TFFGromov,
   TFFPolinom);

  SchDNumber=1;

  SchDNames:array[0..SchDNumber] of string=
   ('Exponent','Ivanov method');
   SchDClasses:array[0..SchDNumber]of TFitFunctionNew_Class=
   (TFFExponent,TFFIvanov);

  DiodNumber=4;
  DiodNames:array[0..DiodNumber] of string=
   ('Diode','Diode, LSM','Diode, Lambert','PhotoDiode, LSM','PhotoDiode, Lambert');
  DiodClasses:array[0..DiodNumber]of TFitFunctionNew_Class=
   (TFFDiod,TFFDiodLSM,TFFDiodLam,TFFPhotoDiodLSM,TFFPhotoDiodLam);

var
  FitFuncNames:array[TFitFuncCategory]of array of string;


Function FitFunctionFactory(str:string; FileName:string=''):TFitFunctionNew;
{створює F того чи іншого типу залежно
від значення str}


procedure FitFuncNames_trans_Filling;
procedure FitFuncNames_digital_Filling;
procedure FitFuncNames_simple_Filling;
procedure FitFuncNames_schottky_Filling;
procedure FitFuncNames_diod_Filling;

implementation

uses
  FitTransform;

procedure FitFuncNames_diod_Filling;
  var i:integer;
 begin
   SetLength(FitFuncNames[ffc_diod],Length(DiodNames));
   for I := 0 to High(FitFuncNames[ffc_diod]) do
    FitFuncNames[ffc_diod,i]:=
       DiodNames[i+Low(DiodNames)];
 end;


procedure FitFuncNames_schottky_Filling;
  var i:integer;
 begin
   SetLength(FitFuncNames[ffc_schottky],Length(SchDNames));
   for I := 0 to High(FitFuncNames[ffc_schottky]) do
    FitFuncNames[ffc_schottky,i]:=
       SchDNames[i+Low(SchDNames)];
 end;


procedure FitFuncNames_simple_Filling;
  var i:integer;
 begin
   SetLength(FitFuncNames[ffc_simple],Length(SFNames));
   for I := 0 to High(FitFuncNames[ffc_simple]) do
    FitFuncNames[ffc_simple,i]:=
       SFNames[i+Low(SFNames)];
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

procedure FitFuncNames_digital_Filling;
  var i:integer;
 begin
   SetLength(FitFuncNames[ffc_digital],Length(DFNames));
   for I := 0 to High(FitFuncNames[ffc_digital]) do
    FitFuncNames[ffc_digital,i]:=
       DFNames[i+Low(DFNames)];
 end;

Function FitFunctionFactory(str:string; FileName:string=''):TFitFunctionNew;
{створює F того чи іншого типу залежно
від значення str}
  var i:TTransformFunction;
      j:integer;
begin
   Result:=nil;
//   if str='None' then
//     begin
//     Result:=TFFDiodLSM.Create;
//       Exit;
//     end;

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
//         Result:=TFitFunctionNew_Class(DFClasses[j]).Create;
         Result:=DFClasses[j].Create;
         Exit;
       end;

   for j := 0 to SFNumber do
      if str=SFNames[j] then
       begin
//         Result:=TFitFunctionNew_Class(SFClasses[j]).Create;
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

   if str='Moving Average Filter' then
     begin
     Result:=TFFMovingAverageFilter.Create;
     Exit;
     end;

//   if str=DigitalFiltrNames[0] then
//     begin
//     Result:=TFFLP_IIR_Chebyshev.Create;
//     Exit;
//     end;
//
//   if str=DigitalFiltrNames[1] then
//     begin
//     Result:=TFFLP_UniformIIRFilter.Create;
//     Exit;
//     end;
//
//   if str=DigitalFiltrNames[2] then
//     begin
//     Result:=TFFLP_UniformIIRFilter4k.Create;
//     Exit;
//     end;
//
//   if str=DigitalFiltrNames[4] then
//     begin
//     Result:=TFFLP_FIR_Blackman.Create;
//     Exit;
//     end;
//
//   if str=DigitalFiltrNames[9] then
//     begin
//     Result:=TFFHP_FIR_SimpleWindow.Create;
//     Exit;
//     end;
//
//   if str=DigitalFiltrNames[3] then
//     begin
//     Result:=TFFLP_FIR_SimpleWindow.Create;
//     Exit;
//     end;
//
//   if str=DigitalFiltrNames[5] then
//     begin
//     Result:=TFFLP_FIR_HammingWindow.Create;
//     Exit;
//     end;
//
//   if str=DigitalFiltrNames[6] then
//     begin
//     Result:=TFFLP_FIR_HannWindow.Create;
//     Exit;
//     end;
//
//   if str=DigitalFiltrNames[7] then
//     begin
//     Result:=TFFLP_FIR_BartlettWindow.Create;
//     Exit;
//     end;
//
//   if str=DigitalFiltrNames[8] then
//     begin
//     Result:=TFFLP_FIR_ChebyshevWindow.Create;
//     Exit;
//     end;

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

//   if str=SFNames[0] then
//     begin
//     Result:=TFFLinear.Create;
//     Exit;
//     end;
end;


initialization
 FitFuncNames_trans_Filling;
 FitFuncNames_digital_Filling;
 FitFuncNames_simple_Filling;
 FitFuncNames_schottky_Filling;
 FitFuncNames_diod_Filling;

// SetLength(FitFuncNames[ffc_simple],1);
// FitFuncNames[ffc_simple,0]:='Linear';

end.

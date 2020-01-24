unit OApproxCaption;

interface

uses
  OApproxNew;

type
  TFitFuncCategory=(ffc_none,ffc_trans,ffc_digital,
                   ffc_simple);

const
  FitFuncCategoryNames:array[TFitFuncCategory]of string=
           ('None','Transform','Digital filter','Simple');

  DigitalFiltrNames:array[0..9]of string=
   ('LP IIR Chebyshev', 'LP IIR Uniform',
    'LP IIR Uniform, 4k','LP FIR Simple Window',
    'LP FIR Blackman','LP FIR Hamming',
    'LP FIR Hann', 'LP FIR Bartlett',
    'LP FIR Chebyshev','HP FIR Simple Window');


var
  FitFuncNames:array[TFitFuncCategory]of array of string;


Function FitFunctionFactory(str:string; FileName:string=''):TFitFunctionNew;
{створює F того чи іншого типу залежно
від значення str}

procedure FitFuncNames_trans_Filling;
procedure FitFuncNames_digital_Filling;

implementation

uses
  FitTransform, FitDigital;

procedure FitFuncNames_trans_Filling;
  var i:TTransformFunction;
begin
 SetLength(FitFuncNames[ffc_trans],ord(High(TTransformFunction))+2);
  for I := Low(TTransformFunction) to High(TTransformFunction) do
   FitFuncNames[ffc_trans,ord(I)]:=TransformFunctionNames[i];
 FitFuncNames[ffc_trans,High(FitFuncNames[ffc_trans])]:='Moving Average Filter';
end;

procedure FitFuncNames_digital_Filling;
  var i:integer;
 begin
   SetLength(FitFuncNames[ffc_digital],Length(DigitalFiltrNames));
   for I := 0 to High(FitFuncNames[ffc_digital]) do
    FitFuncNames[ffc_digital,i]:=
       DigitalFiltrNames[i+Low(DigitalFiltrNames)];
 end;

Function FitFunctionFactory(str:string; FileName:string=''):TFitFunctionNew;
{створює F того чи іншого типу залежно
від значення str}
  var i:TTransformFunction;
begin
   Result:=nil;
//   if str='Sample' then
//     begin
//     Result:=TFitFunctionNew.Create(str,'Some sample function');
//     Exit;
//     end;
   for I := Low(TTransformFunction)
                to High(TTransformFunction) do
      if str=TransformFunctionNames[i] then
        begin
          Result:=TFitTransform.Create(str);
          Exit;
        end;
   if str=DigitalFiltrNames[0] then
     begin
     Result:=TFFLP_IIR_Chebyshev.Create;
     Exit;
     end;
   if str='Moving Average Filter' then
     begin
     Result:=TFFMovingAverageFilter.Create;
     Exit;
     end;
   if str=DigitalFiltrNames[1] then
     begin
     Result:=TFFLP_UniformIIRFilter.Create;
     Exit;
     end;

   if str=DigitalFiltrNames[2] then
     begin
     Result:=TFFLP_UniformIIRFilter4k.Create;
     Exit;
     end;

   if str=DigitalFiltrNames[4] then
     begin
     Result:=TFFLP_FIR_Blackman.Create;
     Exit;
     end;

   if str=DigitalFiltrNames[9] then
     begin
     Result:=TFFHP_FIR_SimpleWindow.Create;
     Exit;
     end;

   if str=DigitalFiltrNames[3] then
     begin
     Result:=TFFLP_FIR_SimpleWindow.Create;
     Exit;
     end;

   if str=DigitalFiltrNames[5] then
     begin
     Result:=TFFLP_FIR_HammingWindow.Create;
     Exit;
     end;

   if str=DigitalFiltrNames[6] then
     begin
     Result:=TFFLP_FIR_HannWindow.Create;
     Exit;
     end;

   if str=DigitalFiltrNames[7] then
     begin
     Result:=TFFLP_FIR_BartlettWindow.Create;
     Exit;
     end;

   if str=DigitalFiltrNames[8] then
     begin
     Result:=TFFLP_FIR_ChebyshevWindow.Create;
     Exit;
     end;

end;


initialization
 FitFuncNames_trans_Filling;
 FitFuncNames_digital_Filling;

 SetLength(FitFuncNames[ffc_simple],1);
 FitFuncNames[ffc_simple,0]:='Linear';

end.

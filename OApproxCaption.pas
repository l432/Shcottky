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

var
  FitFuncNames:array[TFitFuncCategory]of array of string;


Function FitFunctionFactory(str:string; FileName:string=''):TFitFunctionNew;
{створює F того чи іншого типу залежно
від значення str}


implementation

uses
  FitTransform, FitDigital;


Function FitFunctionFactory(str:string; FileName:string=''):TFitFunctionNew;
{створює F того чи іншого типу залежно
від значення str}
  var i:TTransformFunction;
begin
   Result:=nil;
   if str='Sample' then
     begin
     Result:=TFitFunctionNew.Create(str,'Some sample function');
     Exit;
     end;
   for I := Low(TTransformFunction)
                to High(TTransformFunction) do
      if str=TransformFunctionNames[i] then
        begin
          Result:=TFitTransform.Create(str);
          Exit;
        end;
   if str='LP IIR Chebyshev' then
     begin
     Result:=TFFLP_IIR_Chebyshev.Create;
     Exit;
     end;
   if str='Moving Average Filter' then
     begin
     Result:=TFFMovingAverageFilter.Create;
     Exit;
     end;
end;


initialization
 SetLength(FitFuncNames[ffc_trans],ord(High(TTransformFunction))+2);
 FitFuncNames[ffc_trans,ord(tfSmooth)]:=TransformFunctionNames[tfSmooth];
 FitFuncNames[ffc_trans,ord(tfDeriv)]:=TransformFunctionNames[tfDeriv];
 FitFuncNames[ffc_trans,ord(tfMedian)]:=TransformFunctionNames[tfMedian];
 FitFuncNames[ffc_trans,3]:='Moving Average Filter';

 SetLength(FitFuncNames[ffc_digital],1);
 FitFuncNames[ffc_digital,0]:='LP IIR Chebyshev';
// FitFuncNames[ffc_digital,1]:='Moving Average Filter';

 SetLength(FitFuncNames[ffc_simple],1);
 FitFuncNames[ffc_simple,0]:='Linear';

end.

unit OApproxCaption;

interface

uses
  OApproxNew;

type
  TFitFuncCategory=(ffc_none,ffc_trans,ffc_simple);

const
  FitFuncCategoryNames:array[TFitFuncCategory]of string=
           ('None','Transform','Simple');

var
  FitFuncNames:array[TFitFuncCategory]of array of string;


Function FitFunctionFabrica(str:string; FileName:string=''):TFitFunctionNew;
{створює F того чи іншого типу залежно
від значення str}


implementation

uses
  FitTransform;


Function FitFunctionFabrica(str:string; FileName:string=''):TFitFunctionNew;
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
end;


initialization
 SetLength(FitFuncNames[ffc_trans],ord(High(TTransformFunction))+1);
 FitFuncNames[ffc_trans,ord(tfSmooth)]:=TransformFunctionNames[tfSmooth];
 FitFuncNames[ffc_trans,ord(tfDeriv)]:=TransformFunctionNames[tfDeriv];
 FitFuncNames[ffc_trans,ord(tfMedian)]:=TransformFunctionNames[tfMedian];


 SetLength(FitFuncNames[ffc_simple],1);
 FitFuncNames[ffc_simple,0]:='Linear';

end.

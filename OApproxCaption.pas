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


Function FitFunctionFabrica(str:string; FileName:string=''):TFitFunctionNew;
{створює F того чи іншого типу залежно
від значення str}
begin
   Result:=nil;
   if str='Sample' then Result:=TFitFunctionNew.Create(str,'Some sample function');

end;


initialization
 SetLength(FitFuncNames[ffc_trans],3);
 FitFuncNames[ffc_trans,0]:='Smoothing';
 FitFuncNames[ffc_trans,1]:='Median filtr';
 FitFuncNames[ffc_trans,2]:='Sample';

 SetLength(FitFuncNames[ffc_simple],1);
 FitFuncNames[ffc_simple,0]:='Linear';

end.

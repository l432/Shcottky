unit OApproxCaption;

interface

type
  TFitFuncCategory=(ffc_none,ffc_trans,ffc_simple);

const
  FitFuncCategoryNames:array[TFitFuncCategory]of string=
           ('None','Transform','Simple');

var
  FitFuncNames:array[TFitFuncCategory]of array of string;

implementation

initialization
 SetLength(FitFuncNames[ffc_trans],2);
 FitFuncNames[ffc_trans,0]:='Smoothing';
 FitFuncNames[ffc_trans,1]:='Median filtr';

 SetLength(FitFuncNames[ffc_simple],1);
 FitFuncNames[ffc_simple,0]:='Linear';

end.

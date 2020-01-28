unit FitTransform;

interface

uses
  OApproxNew;

type

 TTransformFunction=(tfDeriv,tfMedian,tfSmooth);

const

 TransformFunctionNames:array[TTransformFunction]of string=
   ('Derivative','Median filter','Smoothing');

 TransformFunctionDescriptions:array[TTransformFunction]of string=
   ('Derivative, which is calculated as derivative of 3-poin Lagrange polynomial',
   '3-point median filtering',
   '3-point averaging, the weighting coefficient are determined by Gaussian distribution with 60% dispersion');

type

TFitTransform=class (TFitFunctionNew)
{базовий для операцій простих перетворень вихідної функції}
private
 fTTF:TTransformFunction;
//  FErrorMessage:string; //виводиться при помилці
protected
 procedure RealFitting;override;
 procedure NamesDefine;override;
public
 Constructor Create(FunctionName:string);
end;  //TFitTransform=class (TFitFunctionNew)



implementation


{ TFitTransform }

constructor TFitTransform.Create(FunctionName: string);
 var i:TTransformFunction;
begin

 for I := Low(TTransformFunction)
    to High(TTransformFunction) do
      if FunctionName=TransformFunctionNames[i] then 
        begin
          fTTF:=i;
          Break;
        end;

 inherited Create;
 if fTTF=tfMedian then
                fPictureName:='MedianFig';


 fHasPicture:=True;
end;

procedure TFitTransform.NamesDefine;
begin
 SetNameCaption(TransformFunctionNames[fTTF],
          TransformFunctionDescriptions[fTTF]);
end;

procedure TFitTransform.RealFitting;
begin
 case fTTF of
  tfSmooth:fDataToFit.Smoothing(FittingData);
  tfDeriv:fDataToFit.Derivate(FittingData);
  tfMedian:fDataToFit.Median(FittingData);
 end;
// if Name=TransformFunctionNames[tfSmooth]
//       then fDataToFit.Smoothing(FittingData);
// if Name=TransformFunctionNames[tfDeriv]
//       then fDataToFit.Derivate(FittingData);
// if Name=TransformFunctionNames[tfMedian]
//       then fDataToFit.Median(FittingData);
end;

end.

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
//  FErrorMessage:string; //виводиться при помилці
protected
 procedure RealFitting;override;
public
 Constructor Create(FunctionName:string);
end;  //TFitTransform=class (TFitFunctionNew)



implementation

uses
  Dialogs;

{ TFitTransform }

constructor TFitTransform.Create(FunctionName: string);
 var i:TTransformFunction;
begin
 for I := Low(TTransformFunction)
    to High(TTransformFunction) do
      if FunctionName=TransformFunctionNames[i] then
        begin
          inherited Create(TransformFunctionNames[i],
                         TransformFunctionDescriptions[i]);
          if i=tfMedian then
                fPictureName:='MedianFig';
          Break;

        end;

 fHasPicture:=True;
end;

procedure TFitTransform.RealFitting;
begin
 if Name=TransformFunctionNames[tfSmooth]
       then fDataToFit.Smoothing(FittingData);
 if Name=TransformFunctionNames[tfDeriv]
       then fDataToFit.Derivate(FittingData);
 if Name=TransformFunctionNames[tfMedian]
       then fDataToFit.Median(FittingData);
 if FittingData.IsEmpty then
  begin
   MessageDlg('The '+Name+' Is Imposible,'+#10+
              'the points" quantity is very low',
               mtError, [mbOK], 0);
   Exit;
  end;

 fResultsIsReady:=True;
end;

end.

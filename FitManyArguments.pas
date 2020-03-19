unit FitManyArguments;

interface

uses
  FitHeuristic, Classes, OlegVector, TeEngine, OlegType;

type

TFFManyArguments=class (TFFHeuristic)
 private
  fFileName:string;
  fSL:TStringList;
//  fCAN:integer;
  {fCurrentArgumentsNumber}
  fAllArguments:array of array of double;
  fArgumentsName:array of string;
  fArgumentNumber:byte;
  procedure DataReading;
 protected
  procedure AditionalRealToFile;virtual;
  procedure DataCorrection();virtual;
  procedure AccessorialDataCreate;override;
  procedure TuningAfterReadFromIni;override;
  procedure DataPreraration(InputFileName:string);override;
  procedure DataContainerCreate;override;
  procedure DataContainerDestroy;override;
  procedure SetArgumentNames(Names:array of string);
  Procedure RealToFile;override;
 public
   Procedure FittingToGraphAndFile(InputData:TVector;
              Series: TChartSeries);override;
end;

TFFn_FeB=class (TFFManyArguments)
 protected
  procedure AditionalRealToFile;override;
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFn_FeB=class (TFFManyArguments)


TFFn_FeBNew=class (TFFManyArguments)
 protected
  procedure AditionalRealToFile;override;
  procedure DataCorrection();override;
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFn_FeBNew=class (TFFManyArguments)



implementation

uses
  FitVariable, Math, Dialogs, SysUtils, OlegFunction, StrUtils, FitIteration,
  OlegMaterialSamples;

{ TFFManyArguments }


{ TFFManyArguments }

procedure TFFManyArguments.AccessorialDataCreate;
begin
  inherited AccessorialDataCreate;
  fIntVars.Add(Self,'FCN');
  fIntVars.ParametrByName['FCN'].Limits.SetLimits(fArgumentNumber+1);
  fIntVars.ParametrByName['FCN'].Description:=
        'Function column number';

end;

procedure TFFManyArguments.AditionalRealToFile;
begin
end;

procedure TFFManyArguments.DataContainerCreate;
begin
 inherited DataContainerCreate;
 fSL:=TStringList.Create;
 SetLength(fAllArguments,fArgumentNumber);
end;

procedure TFFManyArguments.DataContainerDestroy;
begin
 FreeAndNil(fSL);
 inherited DataContainerDestroy;
end;

procedure TFFManyArguments.DataCorrection;
begin
end;

procedure TFFManyArguments.DataPreraration(InputFileName: string);
  var OpenDialog1:TOpenDialog;
begin
 fFileName:=InputFileName;
 if fFileName='' then
  begin
   OpenDialog1:=TOpenDialog.Create(nil);
   OpenDialog1.Filter:='Data file (*.dat)|*.dat';
     if OpenDialog1.Execute() then
        fFileName:=OpenDialog1.FileName;
   OpenDialog1.Free;
  end;

 DataReading();
end;

procedure TFFManyArguments.DataReading;
 var i,j,FCN:integer;
begin
 if fFileName<>'' then
   begin
    fSL.Clear;
    fSL.LoadFromFile(fFileName);
    if FloatDataFromRow(fSL[0],1)=ErResult
      then fSL.Delete(0);
    fDataToFit.Clear;
    fDataToFit.name:=ExtractFileName(fFileName);

    for I := 0 to High(fAllArguments) do
     SetLength(fAllArguments[i],fSL.Count);

    FCN:=(fIntVars.ParametrByName['FCN'] as TVarInteger).Value;

    for j := 0 to fSL.Count-1 do
       begin
         for I := 0 to High(fAllArguments) do
          fAllArguments[i][j]:=FloatDataFromRow(fSL[j],i+1);
         fDataToFit.Add(j, FloatDataFromRow(fSL[j],FCN));
       end;
   end;
 DataCorrection();
end;

procedure TFFManyArguments.FittingToGraphAndFile(InputData: TVector;
  Series: TChartSeries);
begin
  Fitting('');
  if fResultsIsReady then RealToFile;
end;

procedure TFFManyArguments.RealToFile;
var Str1:TStringList;
    i,j,FCN:integer;
    tempStr:string;
begin
  Str1:=TStringList.Create;
  Str1.Add(FileHeader);
  FCN:=(fIntVars.ParametrByName['FCN'] as TVarInteger).Value;
  for I := 0 to fSL.Count-1 do
    begin
     tempStr:='';
     for j := 1 to fArgumentNumber do
       tempStr:=tempStr+StringDataFromRow(fSL[i],j)+' ';

     tempStr:=tempStr+StringDataFromRow(fSL[i],FCN)+' ';

     tempStr:=tempStr+FloatToStrF(FittingData.Y[i],ffExponent,DigitNumber,0);
     str1.Add(tempStr);
    end;
  Str1.SaveToFile(AnsiLeftStr(fFileName,Length(fFileName)-4)
                  +'Fit.dat');
  Str1.Free;

  AditionalRealToFile();

end;

procedure TFFManyArguments.SetArgumentNames(Names: array of string);
 var i:integer;
begin
 fArgumentNumber:=High(Names);
 SetLength(fArgumentsName,fArgumentNumber+1);
 for I := 0 to High(fArgumentsName) do
     fArgumentsName[i]:=Names[i];
end;

procedure TFFManyArguments.TuningAfterReadFromIni;
 var i:integer;
begin
 inherited TuningAfterReadFromIni;
 (fIntVars.ParametrByName['FCN'] as TVarInteger).Value:=max(fArgumentNumber+1,
              (fIntVars.ParametrByName['FCN'] as TVarInteger).Value);
 FileHeader:='';
 for I := 0 to High(fArgumentsName) do
     FileHeader:=FileHeader+fArgumentsName[i]+' ';
 FileHeader:=FileHeader+fArgumentsName[High(fArgumentsName)]+'calk';
end;

{ TFFn_FeB }

procedure TFFn_FeB.AditionalRealToFile;
var Str1:TStringList;
    i,FCN:integer;
begin
  Str1:=TStringList.Create;
  Str1.Add('N_Fe N_B T n_Fe n_Fe_calk n_Fe n_Fe_calk');
  FCN:=(fIntVars.ParametrByName['FCN'] as TVarInteger).Value;
  for I := 0 to fSL.Count-1 do
    begin
     str1.Add(StringDataFromRow(fSL[i],1)+' '
             +StringDataFromRow(fSL[i],2)+' '
             +StringDataFromRow(fSL[i],3)+' '
             +StringDataFromRow(fSL[i],FCN)+' '
             +FloatToStrF(FittingData.Y[i],ffExponent,10,0)+' '
             +StringDataFromRow(fSL[i],FCN)+' '
             +FloatToStrF(FittingData.Y[i],ffExponent,10,0));
     end;
  Str1.SaveToFile('ResultAllFit.dat');
  Str1.Free;
end;


function TFFn_FeB.FuncForFitness(Point: TPointDouble; Data: TArrSingle): double;
 var Eeff:double;
     fCAN:integer;
begin
 fCAN:=round(Point[cX]);
 Eeff:=Data[1]
  -Data[2]*fAllArguments[2][fCAN]
  /Log10(fAllArguments[1][fCAN])
  +Data[4]
  /Log10(fAllArguments[0][fCAN])
  +Data[3]*fAllArguments[2][fCAN];

 Result:=1+Data[0]*fAllArguments[2][fCAN]
    *Power(log10(fAllArguments[1][fCAN]),3)
    *Power(log10(fAllArguments[0][fCAN]),3)
    /(1+Silicon.Nv(fAllArguments[0][fCAN])*1e-6
      /fAllArguments[1][fCAN]
      *exp(-Eeff/Kb/fAllArguments[2][fCAN]));
end;

procedure TFFn_FeB.NamesDefine;
begin
  SetNameCaption('n_FeB',
      'Ideality factor of c-Si SC with Fe versus T, both boron and iron concentration');
  SetArgumentNames(['N_Fe','N_B','T','n']);
end;

procedure TFFn_FeB.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['n0','Eefo','E_B','E_T','E_Fe']);

end;

procedure TFFn_FeB.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
end;

{ TFFn_FeBNew }

procedure TFFn_FeBNew.AditionalRealToFile;
 var dataStr,FNtmp:string;
     data:double;
     Str1:TStringList;
     i,j:integer;
     FCN:byte;

begin
 FCN:=(fIntVars.ParametrByName['FCN'] as TVarInteger).Value;
 data:=1;
 Str1:=TStringList.Create;
 Str1.Add('N_Fe N_B T n_Fe n_Fe_calk n_Fe n_Fe_calk');

 FNtmp:=ExtractFileName(fFileName);
 if AnsiLeftStr(FNtmp,1)='F' then
  begin
    data:=data*Power(10,(StrToInt(AnsiMidStr(FNtmp,5,1))+10));
    dataStr:=AnsiMidStr(FNtmp,3,2);
    if dataStr='14' then data:=data*1.468;
    if dataStr='21' then data:=data*2.154;
    if dataStr='31' then data:=data*3.162;
    if dataStr='46' then data:=data*4.642;
    if dataStr='68' then data:=data*6.813;
    for I := 0 to fSL.Count-1 do
      begin
       dataStr:=FloatToStrF(data,ffExponent,10,0)+' ';
       dataStr:=dataStr+FloatToStrF(Power(10,FloatDataFromRow(fSL[i],1)),ffExponent,10,2)+' ';
       dataStr:=dataStr+StringDataFromRow(fSL[i],2)+' '
             +StringDataFromRow(fSL[i],FCN)+' '
             +FloatToStrF(FittingData.Y[i],ffExponent,10,0)+' '
             +StringDataFromRow(fSL[i],FCN)+' '
             +FloatToStrF(FittingData.Y[i],ffExponent,10,0);
       str1.Add(dataStr);
      end;
  end;

 if AnsiLeftStr(FNtmp,1)='B' then
  begin
    data:=data*Power(10,(StrToInt(AnsiMidStr(FNtmp,4,1))+10));
    dataStr:=AnsiMidStr(FNtmp,2,2);
    if dataStr='17' then data:=data*1.778;
    if dataStr='31' then data:=data*3.162;
    if dataStr='56' then data:=data*5.623;
    for I := 0 to fSL.Count-1 do
      begin
       dataStr:=FloatToStrF(Power(10,FloatDataFromRow(fSL[i],1)),ffExponent,10,2)+' ';
       dataStr:=dataStr+FloatToStrF(data,ffExponent,10,2)+' ';
       dataStr:=dataStr+StringDataFromRow(fSL[i],2)+' '
             +StringDataFromRow(fSL[i],FCN)+' '
             +FloatToStrF(FittingData.Y[i],ffExponent,10,0)+' '
             +StringDataFromRow(fSL[i],FCN)+' '
             +FloatToStrF(FittingData.Y[i],ffExponent,10,0);
       str1.Add(dataStr);
      end;
  end;

 if AnsiLeftStr(FNtmp,1)='T' then
  begin
    dataStr:=AnsiMidStr(FNtmp,2,2);
    if dataStr='00' then data:=300;
    if dataStr='05' then data:=305;
    if dataStr='10' then data:=310;
    if dataStr='15' then data:=315;
    if dataStr='20' then data:=320;
    if dataStr='25' then data:=325;
    if dataStr='30' then data:=330;
    if dataStr='35' then data:=335;
    if dataStr='40' then data:=340;
    if dataStr='90' then data:=290;
    if dataStr='95' then data:=295;


    for I := 0 to fSL.Count-1 do
      begin
       for j := 1 to fArgumentNumber do
         dataStr:=dataStr+FloatToStrF(Power(10,FloatDataFromRow(fSL[i],j)),ffExponent,10,2)+' ';
        dataStr:=dataStr+IntTostr(Round(data))+' '
             +StringDataFromRow(fSL[i],FCN)+' '
             +FloatToStrF(FittingData.Y[i],ffExponent,10,0)+' '
             +StringDataFromRow(fSL[i],FCN)+' '
             +FloatToStrF(FittingData.Y[i],ffExponent,10,0);
       str1.Add(dataStr);
      end;
  end;


 Str1.SaveToFile(AnsiLeftStr(fFileName,Length(fFileName)-4)
                    +'Allfit.dat');
 Str1.Free;



end;

procedure TFFn_FeBNew.DataCorrection;
 var i:integer;
begin
 for I := 0 to High(fAllArguments[0]) do
  fAllArguments[0][i]:=Power(10,fAllArguments[0][i]);
end;

function TFFn_FeBNew.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
 var Eeff:double;
     fCAN:integer;
begin
 fCAN:=round(Point[cX]);

 Eeff:=Data[1]
 -Data[2]*Power(fAllArguments[1][fCAN],1)/Log10(fAllArguments[0][fCAN])
 +Data[3]*fAllArguments[1][fCAN];


 Result:=1+Data[0]*Power(fAllArguments[1][fCAN],Data[5])
//    *Power(log10(fAllArguments[0][fCAN]),2.8)
    *Power(log10(fAllArguments[0][fCAN]),Data[4])
    /(1+Silicon.Nv(fAllArguments[1][fCAN])*1e-6
      /fAllArguments[0][fCAN]
      *exp(-Eeff/Kb/fAllArguments[1][fCAN]));

end;

procedure TFFn_FeBNew.NamesDefine;
begin
  SetNameCaption('n_FeBnew',
      'Ideality factor of c-Si SC with Fe versus T and boron concentration');
  SetArgumentNames(['N_B','T','n']);
end;

procedure TFFn_FeBNew.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['n0','Eefo','E_B','E_T','m_B','m_T']);
end;

procedure TFFn_FeBNew.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;

end;

end.

unit FitIteration;

interface

uses
  OlegTypePart2, OApproxNew, OlegType, Classes, FitVariable, IniFiles, 
  OlegVector, OlegVectorManipulation;

type

TFFDParam=class(TNamedAndDescripObject)
{������� ���� ��� ���������, ��
������������ � ��������� ������������}
 private
  fValue:Double;
  function GetIsConstant: boolean;virtual;
  procedure SetIsConstant(const Value: boolean);virtual;
 public
  property Value:Double read fValue write fValue;
  property IsConstant:boolean read GetIsConstant write SetIsConstant;
end;


TDParamArray=class
  private
   fFF:TFitFunctionNew;
//   fParams:array of TFFDParam;
   fMainParamHighIndex:integer;
   {������ ��������� ���������, ���� ������������� �����������
   � ������������ (MainParam)}
   procedure MainParamCreate(const MainParamNames: array of string);virtual;
   procedure AddParamCreate(const AddParamNames: array of string);
   procedure LastParamCreate;
   function GetParameterByName(str:string):TFFDParam;
   function GetValue(index:integer):double;
   function GetParameter(index:integer):TFFDParam;
  public
   fParams:array of TFFDParam;
   OutputData:TArrSingle;
   property Value[index:integer]:double read GetValue;default;
   property ParametrByName[str:string]:TFFDParam read GetParameterByName;
   property Parametr[index:integer]:TFFDParam read GetParameter;
   property MainParamHighIndex:integer read fMainParamHighIndex;
   constructor Create(FF:TFitFunctionNew;
                      const MainParamNames: array of string);overload;
   constructor Create(FF:TFitFunctionNew;
                      const MainParamNames: array of string;
                     const AddParamNames: array of string);overload;
   destructor Destroy;override;
   procedure OutputDataCoordinate;
   Procedure DataToStrings(OutStrings:TStrings);
end;

TConstParDetermination=class(TNamedObject)
{���� ��� ���������� �������
���������, �� ���������� ���������
��� ����������� ������������}
 private
  function GetValue:Double;
  function GetArgument:Double;
 public
  fVarArray:TVarDoubArray;
  Coefficients:TArrSingle;
  CoefNames:array of string;
  fIndex:integer;
  fIsNotReverse:boolean;
  constructor Create(Nm:string;VarArray:TVarDoubArray);
  property Value:double read GetValue;
  procedure WriteToIniFile(ConfigFile:TIniFile;
                           const Section:string);
  procedure ReadFromIniFile(ConfigFile:TIniFile;
                           const Section:string);
end;


TFFParamIteration=class(TFFDParam)
{���������, �� ������������ � ���������
������������ �������}
 private
//  fValue:Double;
  fIsConstant:boolean;
  function GetIsConstant: boolean;override;
  procedure SetIsConstant(const Value: boolean);override;
 public
  fCPDeter:TConstParDetermination;
  property IsConstant:boolean read GetIsConstant write SetIsConstant;
//  property Value:Double read fValue write fValue;
  procedure UpDate;
  constructor Create(Nm:string;VarArray:TVarDoubArray);
  destructor Destroy;override;
  procedure WriteToIniFile(ConfigFile:TIniFile;
                           const Section:string);
  procedure ReadFromIniFile(ConfigFile:TIniFile;
                           const Section:string);
end;

TDParamsIteration=class(TDParamArray)
  private
   fNit:integer;//������� ��������
   fAccurancy:double;
  {��������, ���'����� � �������
   ���������� ������������ �������}
   procedure MainParamCreate(const MainParamNames: array of string);override;
  public
   property Nit:integer read fNit write fNit;
   property Accurancy:double read fAccurancy write fAccurancy;
   procedure WriteToIniFile;
   procedure ReadFromIniFile;
   function IsReadyToFitDetermination:boolean;
   procedure UpDate;
end;


TFittingAgent=class
{���, �� �쳺 ��������� ����������� ������}
 private
  fDescription:string;
  fCurrentIteration:integer;
  fToStop:boolean;
//  fIsDone:boolean;
 public
  property Description:string read fDescription;
  property CurrentIteration:integer read fCurrentIteration;
//  property IsDone:boolean read fIsDone write fIsDone;
  property ToStop:boolean read fToStop;
  procedure StartAction;virtual;
  procedure IterationAction;virtual;abstract;
//  procedure EndAction;virtual;abstract;
end;

TFittingAgentLSM=class(TFittingAgent)
 private
  fPIteration:TDParamsIteration;
  fDataToFit:TVectorTransform;
  ftempVector: TVectorTransform;
  fT:double;
  X2,derivX:TArrSingle;
  Sum1,Sum2{,al}:double;
  Procedure InitialApproximation;virtual;
  procedure RshInitDetermine(InitVector:TVectorTransform);//Function IA_Determine3(Vector1,Vector2:TVector):double;
  Procedure nRsIoInitDetermine;//IA_Determine012
  procedure SetParameterValue(ParametrName:string;Value:double);
  Function SquareFormIsCalculated:boolean;
  Function Secant(num:word;a,b,F:double):double;
  {������������ ���������� �������� ��������� al
  � ����� ������������� ������;
  ��������������� ����� ������쳿;
  � �� b ������� ���������� ������, �� �������� ����'����}
  Function SquareFormDerivate(num:byte;al,F:double):double;virtual;
  {������������� �������� ������� ����������� �����,
  ������� ��������������� ���  ��������������� ������ � ������������
  ������� �� al, ��� ����� ����  ���� �� ������ ��������� ������������
  Param = Param - al*F, ��  Param �������� �� num
  F - �������� ������� ����������� ����� �� Param ��� al = 0
  (��, �� ������� ������� SquareFormIsCalculated � RezF)}
 Function ParamIsBad:boolean;virtual;
  {�������� �� ��������� ����� ��������������� ���
  ������������ ����� � InputData �������� I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh
  IA[0] - n, IA[1] - Rs, IA[2] - I0, IA[3] - Rsh}
 Function ParamCorectIsDone:boolean;{overload;}virtual;
{������������ �������� � IA, ��� �� ����� ���� ��������������� ���
������������ InputData, ���� ���� �� ������� -
����������� False}

 public
  constructor Create(PIteration:TDParamsIteration;DataToFit,tempVector: TVectorTransform;
                     T:double);
//                     DoubVars:TVarDoubArray);
  procedure StartAction;override;
  procedure IterationAction;override;
//  procedure EndAction;override;
end;


TFittingAgentPhotoDiodLSM=class(TFittingAgentLSM)
 private
  Procedure InitialApproximation;override;

end;


implementation

uses
  SysUtils, OlegFunction, OlegMath, OApprox3, Math;

{ TDParamArray }

constructor TDParamArray.Create(FF:TFitFunctionNew;
                               const MainParamNames: array of string);
begin
  inherited Create;
  fFF:=FF;
  MainParamCreate(MainParamNames);
  LastParamCreate;
end;

procedure TDParamArray.AddParamCreate(const AddParamNames: array of string);
 var i: Integer;
begin
  SetLength(fParams, fMainParamHighIndex + High(AddParamNames)+2);
  for I := 0 to High(AddParamNames) do
    fParams[i+fMainParamHighIndex+1] := TFFDParam.Create(AddParamNames[i]);
end;

constructor TDParamArray.Create(FF:TFitFunctionNew;
                               const MainParamNames: array of string;
                              const AddParamNames: array of string);
begin
  inherited Create;
  fFF:=FF;
  MainParamCreate(MainParamNames);
  AddParamCreate(AddParamNames);
  LastParamCreate;
end;

procedure TDParamArray.DataToStrings(OutStrings: TStrings);
 var i:integer;
begin
 for I := 0 to High(fParams) do
  OutStrings.Add(fParams[i].Name+'='+FloatToStrF(OutputData[i],ffExponent,fFF.DigitNumber,0));
end;

destructor TDParamArray.Destroy;
 var I:integer;
begin
  for I := 0 to High(fParams) do fParams[i].Free;
  inherited;
end;

function TDParamArray.GetParameter(index: integer): TFFDParam;
begin
 Result:=fParams[index];
end;

function TDParamArray.GetParameterByName(str: string): TFFDParam;
 var I:integer;
begin
  for I := 0 to High(fParams) do
    if fParams[i].Name=str then
      begin
        Result:=fParams[i];
        Exit;
      end;
  Result:=nil;
end;

function TDParamArray.GetValue(index: integer): double;
begin
  Result:=fParams[index].Value;
end;

procedure TDParamArray.LastParamCreate;
begin
 SetLength(fParams,High(fParams)+2);
 fParams[High(fParams)]:=TFFDParam.Create('dev');
 SetLength(OutputData,High(fParams)+1);
end;

procedure TDParamArray.MainParamCreate(const MainParamNames: array of string);
var
  i: Integer;
begin
  fMainParamHighIndex := High(MainParamNames);
  SetLength(fParams, fMainParamHighIndex + 1);
  for I := 0 to fMainParamHighIndex do
    fParams[i] := TFFDParam.Create(MainParamNames[i]);
end;

procedure TDParamArray.OutputDataCoordinate;
 var I:integer;
begin
  for I := 0 to High(fParams)
     do OutputData[i]:=fParams[i].Value;
end;

{ TConstParDetermination }

constructor TConstParDetermination.Create(Nm:string;VarArray:TVarDoubArray);
 var ch:char;
     i:integer;
begin
 inherited Create(Nm);
 fVarArray:=VarArray;
 InitArrSingle(Coefficients,3,0);
 SetLength(CoefNames,3);
 ch:='A';
 for I := 0 to High(CoefNames) do
  begin
   CoefNames[i]:=ch;
   Inc(ch);
  end;

 fIndex:=-1;
 fIsNotReverse:=True;
end;

function TConstParDetermination.GetArgument: Double;
begin
 try
  Result:=fVarArray[fIndex];
  if Result=ErResult
    then Raise Exception.Create('Fault!!!!');
  if not(fIsNotReverse) then  Result:=1/Result;
 except
  Result:=0;
 end;
end;

function TConstParDetermination.GetValue: Double;
begin
 Result:= NPolinom(GetArgument,Coefficients);
end;

procedure TConstParDetermination.ReadFromIniFile(ConfigFile: TIniFile;
                               const Section: string);
  var i:integer;
begin
 for I := 0 to High(Coefficients) do
  Coefficients[i]:=
    ConfigFile.ReadFloat(Section,Name+CoefNames[i],0);
// Coefficients[1]:=ConfigFile.ReadFloat(Section,Prefix+'B',0);
// Coefficients[2]:=ConfigFile.ReadFloat(Section,Prefix+'C',0);
 fIndex:=ConfigFile.ReadInteger(Section,Name+'_tt',-1);
 fIsNotReverse:=ConfigFile.ReadBool(Section,Name+'_Reverse',False);
end;

procedure TConstParDetermination.WriteToIniFile(ConfigFile: TIniFile;
                               const Section: string);
 var i:integer;
begin
 for I := 0 to High(Coefficients) do
   WriteIniDef(ConfigFile,Section,Name+CoefNames[i],Coefficients[i],0);
// WriteIniDef(ConfigFile,Section,Prefix+'B',Coefficients[1],0);
// WriteIniDef(ConfigFile,Section,Prefix+'C',Coefficients[2],0);
 WriteIniDef(ConfigFile,Section,Name+'_tt',fIndex,-1);
 WriteIniDef(ConfigFile,Section,Name+'_Reverse',fIsNotReverse);
end;


{ TFFParamIteration }

constructor TFFParamIteration.Create(Nm: string; VarArray: TVarDoubArray);
begin
 inherited Create(Nm);
 IsConstant:=False;
 fCPDeter:=TConstParDetermination.Create(Nm,VarArray);
end;

destructor TFFParamIteration.Destroy;
begin
 fCPDeter.Free;
 inherited;
end;

function TFFParamIteration.GetIsConstant: boolean;
begin
 Result:=fIsConstant;
end;

procedure TFFParamIteration.ReadFromIniFile(ConfigFile: TIniFile;
  const Section: string);
begin
  fCPDeter.ReadFromIniFile(ConfigFile,Section);
  IsConstant:=ConfigFile.ReadBool(Section,Name+'_IsConstant',False);
end;

procedure TFFParamIteration.SetIsConstant(const Value: boolean);
begin
  fIsConstant:=Value;
end;

procedure TFFParamIteration.UpDate;
begin
 if IsConstant then Value:=fCPDeter.Value;
end;

procedure TFFParamIteration.WriteToIniFile(ConfigFile: TIniFile;
  const Section: string);
begin
  fCPDeter.WriteToIniFile(ConfigFile,Section);
  WriteIniDef(ConfigFile,Section,Name+'_IsConstant',IsConstant);
end;

{ TDParamIterationArray }

function TDParamsIteration.IsReadyToFitDetermination: boolean;
  var I:integer;
begin
 Result:=True;
 Result:=Result and (fAccurancy<>ErResult)
         and (fNit<>ErResult) and (fNit>0);
 for I := 0 to fMainParamHighIndex do
  if fParams[i].IsConstant
    then Result:=Result and (fParams[i].Value<>ErResult);
end;

procedure TDParamsIteration.MainParamCreate(
         const MainParamNames: array of string);
 var i: Integer;
begin
  fMainParamHighIndex := High(MainParamNames);
  SetLength(fParams, fMainParamHighIndex + 1);
  for I := 0 to fMainParamHighIndex do
    fParams[i] := TFFParamIteration.Create(MainParamNames[i],
                               (fFF as TFFVariabSet).DoubVars);
end;

procedure TDParamsIteration.ReadFromIniFile;
 var I:integer;
begin
  for I := 0 to fMainParamHighIndex
    do (fParams[i] as TFFParamIteration).ReadFromIniFile(fFF.ConfigFile,fFF.Name);
  fAccurancy:=fFF.ConfigFile.ReadFloat(fFF.Name,'Accurancy',1e-8);
  fNit:=fFF.ConfigFile.ReadInteger(fFF.Name,'Nit',1000);
end;

procedure TDParamsIteration.UpDate;
 var i:integer;
begin
 for I := 0 to MainParamHighIndex do
    (fParams[i] as TFFParamIteration).UpDate;
end;

procedure TDParamsIteration.WriteToIniFile;
 var I:integer;
begin
  for I := 0 to fMainParamHighIndex
    do (fParams[i] as TFFParamIteration).WriteToIniFile(fFF.ConfigFile,fFF.Name);
  WriteIniDef(fFF.ConfigFile,fFF.Name,'Accurancy',fAccurancy);
  WriteIniDef(fFF.ConfigFile,fFF.Name,'Nit',fNit);
end;

{ TFittingAgent }

procedure TFittingAgent.StartAction;
begin
 fToStop:=false;
 fCurrentIteration:=0;
end;

{ TFittingAgentLSM }

constructor TFittingAgentLSM.Create(PIteration: TDParamsIteration;
                                    DataToFit,tempVector: TVectorTransform;
                                    T:double);
//                                    DoubVars:TVarDoubArray);
begin
 inherited Create;
 fPIteration:=PIteration;
 fDataToFit:=DataToFit;
 ftempVector:=tempVector;
// fDoubVars:=DoubVars;
 fT:=T;
 fDescription:='Coordinate gradient descent';
end;

procedure TFittingAgentLSM.InitialApproximation;
 var i:integer;
begin
 SetParameterValue('n',ErResult);

 RshInitDetermine(fDataToFit);
 ftempVector.SetLenVector(fDataToFit.Count);
 for I := 0 to ftempVector.HighNumber do
    ftempVector.Y[i]:=(fDataToFit.Y[i]-fDataToFit.X[i]
                /fPIteration.ParametrByName['Rsh'].Value);
  {� temp - ��� � ����������� Rsh0}
  nRsIoInitDetermine;

end;

procedure TFittingAgentLSM.IterationAction;
 var i:integer;
     al:double;
begin
  fToStop:=True;
  if not(odd(fCurrentIteration)) then
     begin
      for I := 0 to High(X2) do X2[i]:=fPIteration[i];
      Sum2:=Sum1;
     end;

   for I := 0 to fPIteration.MainParamHighIndex do
       begin
         if fPIteration.fParams[i].IsConstant then Continue;
         if derivX[i]=0 then Continue;
         if abs(fPIteration[i]/100/derivX[i])>1e100
                        then Continue;
         al:=Secant(i,0,0.1*abs(fPIteration[i]/derivX[i]),derivX[i]);
         if abs(al*derivX[i]/fPIteration[i])>2 then Continue;
         fPIteration.fParams[i].Value:=fPIteration.fParams[i].Value-al*derivX[i];
         if not(ParamCorectIsDone) then
              Raise Exception.Create('Fault! not ParamCorectIsDone');

         fToStop:=fToStop
                  and (abs((X2[i]-fPIteration[i])/fPIteration[i])<fPIteration.fAccurancy);

         if not(SquareFormIsCalculated) then
            Raise Exception.Create('Fault! not SquareFormIsCalculated');
       end;
    Inc(fCurrentIteration);
end;

procedure TFittingAgentLSM.nRsIoInitDetermine;
 var temp2:TVectorTransform;
      i:integer;
     OutputData:TArrSingle;
begin
  temp2:=TVectorTransform.Create;
  ftempVector.PositiveY(temp2);
  for i:=0 to temp2.HighNumber do
       temp2.Y[i]:=ln(temp2.Y[i]);

  temp2.CopyTo(ftempVector);
  if ftempVector.HighNumber>6
    then ftempVector.DeleteNfirst(3);
  ftempVector.LinAprox(OutputData);

  OutputData[0]:=exp(OutputData[0]);
  OutputData[1]:=1/(Kb*fT*OutputData[1]);

  {I00 �� n0 � ��������� ������ ������������ ���������
  ln(I) �� �������, �������� ��� � ����������� Rsh0}
  SetParameterValue('Io',OutputData[0]);
  SetParameterValue('n',OutputData[1]);

  for i:=0 to temp2.HighNumber do
     begin
      temp2.Y[i]:=exp(temp2.Y[i]);
     end;
 {� temp2 - ������� ��� � ����������� Rsh0, ��� ���
  �������� ������ �������}

   temp2.Derivate(ftempVector);
   for i:=0 to ftempVector.HighNumber do
     begin
     ftempVector.X[i]:=1/temp2.Y[i];
     ftempVector.Y[i]:=1/ftempVector.Y[i];
     end;
  {� ftempVector - ���������� dV/dI �� 1/�}

  if ftempVector.Count>5 then ftempVector.DeleteNfirst(ftempVector.Count-5);
  ftempVector.LinAprox(OutputData);
  SetParameterValue('Rs',OutputData[0]);
  {Rs0 - �� ������ ���� ������ ������������
  ���������� �'��� �������� ����� ��������� dV/dI �� 1/�;
  dV/dI= (nKbT)/(qI)+Rs}
  temp2.Free;
end;

function TFittingAgentLSM.ParamCorectIsDone: boolean;
begin
  Result:=False;
  if fPIteration[1]<0.0001 then fPIteration.fParams[1].Value:=0.0001;
  if (fPIteration[3]<=0) or (fPIteration[3]>1e12)
      then fPIteration.fParams[3].Value:=1e12;
  while (ParamIsBad)and(fPIteration[0]<1000) do
     fPIteration.fParams[0].Value:=fPIteration[0]*2;
  while (ParamIsBad)and(fPIteration[2]>1e-15) do
     fPIteration.fParams[2].Value:=fPIteration[2]/1.5;
  if  ParamIsBad then Exit;
  Result:=true;
end;

function TFittingAgentLSM.ParamIsBad: boolean;
 var bt:double;
     i:integer;
begin
  Result:=True;
  if fPIteration[0]<=0 then Exit;
  bt:=2/Kb/fT/fPIteration[0];
  if fPIteration[1]<0 then Exit;
  if (fPIteration[2]<0) or (fPIteration[2]>1) then Exit;
  if fPIteration[3]<=1e-4 then Exit;
  for I := 0 to fDataToFit.HighNumber do
    if bt*(fDataToFit.X[i]-fPIteration[1]*fDataToFit.Y[i])>700
          then Exit;
  Result:=False;
end;

procedure TFittingAgentLSM.RshInitDetermine(InitVector:TVectorTransform);
 var tVector:TVectorTransform;
begin
 if fPIteration.ParametrByName['Rsh'].IsConstant then Exit;
 tVector:=TVectorTransform.Create;

 fDataToFit.Derivate(tVector);
   {��������, � ftempVector ����������� ���������� ����� �� �������}
 if tVector.Count<3 then
    Raise Exception.Create('Fault in RshInitDetermine');

 fPIteration.ParametrByName['Rsh'].Value:=(tVector.X[1]/tVector.y[2]
                                           -tVector.X[2]/tVector.y[1])
                                           /(tVector.X[1]-tVector.X[2]);
  {Rsh0 - �� ���������� ���� ��������� ����� ����������� ����� � ����������� ���������
        �������� ��� ������� ������}
  tVector.Free;
end;

function TFittingAgentLSM.Secant(num: word; a, b, F: double): double;
  var i:integer;
      c,Fb,Fa:double;
begin
  Result:=0;
    Fa:=SquareFormDerivate(num,a,F);
    if Fa=ErResult then Exit;
    if Fa=0 then
               begin
                  Result:=a;
                  Exit;
                end;
    repeat
      Fb:=SquareFormDerivate(num,b,F);
      if Fb=0 then
                begin
                  Result:=b;
                  Exit;
                end;
      if Fb=ErResult then Break
                     else
                       begin
                       if Fb*Fa<=0 then Break
                                  else b:=2*b
                       end;
    until false;
    i:=0;
    repeat
      inc(i);
      c:=(a+b)/2;
      Fb:=SquareFormDerivate(num,c,F);
      Fa:=SquareFormDerivate(num,a,F);
      if (Fb*Fa<=0) or (Fb=ErResult)
        then b:=c
        else a:=c;
    until (i>1e5)or(abs((b-a)/c)<1e-2);
    if (i>1e5) then Exit;
    Result:=c;

end;

procedure TFittingAgentLSM.SetParameterValue(ParametrName: string;
          Value: double);
begin
   if not(fPIteration.ParametrByName[ParametrName].IsConstant) then
      fPIteration.ParametrByName[ParametrName].Value:=Value;
end;

function TFittingAgentLSM.SquareFormDerivate(num: byte; al, F: double): double;
  var i:integer;
     Zi,Rez,nkT,vi,ei,eiI0,
     n,Rs,I0,Rsh,Iph:double;
begin
 Result:=ErResult;
 if ParamIsBad then  Exit;
 n:=fPIteration[0];
 Rs:=fPIteration[1];
 I0:=fPIteration[2];
 Rsh:=fPIteration[3];
 Iph:=0;
 if fPIteration.MainParamHighIndex>3 then Iph:=fPIteration[4];
 try
  case num of
   0:n:=n-al*F;
   1:Rs:=Rs-al*F;
   2:I0:=I0-al*F;
   3:Rsh:=Rsh-al*F;
   4:Iph:=Iph-al*F;
  end;//case
  nkT:=n*Kb*fT;
  Rez:=0;
  for I := 0 to fDataToFit.HighNumber do
   begin
     vi:=(fDataToFit.X[i]-fDataToFit.Y[i]*Rs);
     ei:=exp(vi/nkT);
     Zi:=I0*(ei-1)+vi/Rsh-fDataToFit.Y[i];
     if fPIteration.MainParamHighIndex>3 then Zi:=Zi-Iph;
     eiI0:=ei*I0/nkT;

     case num of
       0:Rez:=Rez+Zi/abs(fDataToFit.Y[i])*eiI0*vi;
       1:Rez:=Rez+Zi*(eiI0+1/Rsh);
       2:Rez:=Rez+Zi/abs(fDataToFit.Y[i])*(1-ei);
       3:Rez:=Rez+Zi/abs(fDataToFit.Y[i])*vi/Rsh/Rsh;
       4:Rez:=Rez-ZI/abs(fDataToFit.Y[i]);
     end; //case
   end;
   Rez:=2*F*Rez;
   if num=0 then Rez:=Rez/n;
  Result:=Rez;
 except
 end;//try

end;

function TFittingAgentLSM.SquareFormIsCalculated: boolean;
 var   Zi,ZIi,nkT,vi,ei,eiI0:double;
       i:integer;
begin
// ['n','Rs','Io','Rsh']

 nkT:=fPIteration[0]*Kb*fT;
 InitArrSingle(derivX,fPIteration.MainParamHighIndex+1,0);
 Sum1:=0;

 try
  for I := 0 to fDataToFit.HighNumber do
     begin
       vi:=(fDataToFit.X[i]-fDataToFit.Y[i]
                           *fPIteration[1]);
       ei:=exp(vi/nkT);
       Zi:=fPIteration[2]
          *(ei-1)+vi/fPIteration[3]
          -fDataToFit.Y[i];
       if fPIteration.MainParamHighIndex=4
          then Zi:=Zi-fPIteration[4];
       ZIi:=Zi/abs(fDataToFit.Y[i]);
       eiI0:=ei*fPIteration[2]/nkT;
       Sum1:=Sum1+ZIi*Zi;
       derivX[0]:=derivX[0]-ZIi*eiI0*vi;
       derivX[1]:=derivX[1]-Zi*(eiI0+1/fPIteration[3]);
       derivX[2]:=derivX[2]+ZIi*(ei-1);
       derivX[3]:=derivX[3]-ZIi*vi;
       if fPIteration.MainParamHighIndex=4
          then derivX[4]:=derivX[4]-ZIi;
     end;
  for I := 0 to High(derivX) do derivX[i]:=derivX[i]*2;
  derivX[0]:=derivX[0]/fPIteration[0];
  derivX[3]:=derivX[3]/sqr(fPIteration[3]);
  Result:=True;
 except
  Result:=False;
 end;
end;

procedure TFittingAgentLSM.StartAction;
// var i:integer;
begin
  inherited StartAction;
  SetLength(X2,fPIteration.MainParamHighIndex+1);
  InitialApproximation;

  if fPIteration.ParametrByName['Rs'].Value<0
     then SetParameterValue('Rs',1);

  if (fPIteration.ParametrByName['Rsh'].Value>=1e12)
      or(fPIteration.ParametrByName['Rsh'].Value<=0)
      then SetParameterValue('Rsh',1e12);

  if fPIteration.ParametrByName['n'].Value<=0
     then SetParameterValue('n',1);

  if fPIteration.ParametrByName['n'].Value=ErResult
     then Raise Exception.Create('Fault, n=ErResult');

//    for I := 0 to fPIteration.MainParamHighIndex do
//    HelpForMe(inttostr(i)+'0_'+floattostr(fPIteration[i]));

  if not(SquareFormIsCalculated)
    then Raise Exception.Create('Fault in SquareFormIsCalculated');
  Sum2:=Sum1;


//    for I := 0 to fPIteration.MainParamHighIndex do
//    HelpForMe(inttostr(i)+'0_'+floattostr(fPIteration[i]));
end;

{ TFFDParam }

function TFFDParam.GetIsConstant: boolean;
begin
 Result:=False;
end;

procedure TFFDParam.SetIsConstant(const Value: boolean);
begin

end;

{ TFittingAgentPhotoDiodLSM }

procedure TFittingAgentPhotoDiodLSM.InitialApproximation;
 var i:integer;
begin
 SetParameterValue('n',ErResult);
 if (fDataToFit.Voc<=0.002) then Exit;
 SetParameterValue('Iph',fDataToFit.Isc);
 if fPIteration.ParametrByName['Iph'].Value<=1e-8 then Exit;
 fDataToFit.CopyTo(ftempVector);
 ftempVector.AdditionY(fPIteration.ParametrByName['Iph'].Value);
 RshInitDetermine(ftempVector);
 for I := 0 to ftempVector.HighNumber do
    ftempVector.Y[i]:=(ftempVector.Y[i]-ftempVector.X[i]
                /fPIteration[3]);
  {� temp - ��� � ����������� Rsh0}
  nRsIoInitDetermine;
end;

end.

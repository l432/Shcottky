unit FitIteration;

interface

uses
  OlegTypePart2, OApproxNew, OlegType, Classes, FitVariable, IniFiles;

type

TFFDParam=class(TNamedAndDescripObject)
{базовий клас для параметрів, які
визначаються в результаті апроксимації}
 private
  fValue:Double;
 public
  property Value:Double read fValue write fValue;
end;


TDParamArray=class
  private
   fFF:TFitFunctionNew;
   fParams:array of TFFDParam;
   fMainParamHighIndex:integer;
   {індекс останного параметра, який безпосередньо визначається
   з апроксимації (MainParam)}
   procedure MainParamCreate(const MainParamNames: array of string);virtual;
   procedure AddParamCreate(const AddParamNames: array of string);
   procedure LastParamCreate;
   function GetParameterByName(str:string):TFFDParam;
  public
   OutputData:TArrSingle;
   property ParametrByName[str:string]:TFFDParam read GetParameterByName;
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
{клас для обчислення значень
параметрів, які вважаються постійними
при ітераційній апроксимації}
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
{параметри, які
визначаються в результаті
ітераційного процесу}
 private
//  fValue:Double;

 public
  fCPDeter:TConstParDetermination;
  IsConstant:boolean;
//  property Value:Double read fValue write fValue;
  procedure UpDate;
  constructor Create(Nm:string;VarArray:TVarDoubArray);
  destructor Destroy;override;
  procedure WriteToIniFile(ConfigFile:TIniFile;
                           const Section:string);
  procedure ReadFromIniFile(ConfigFile:TIniFile;
                           const Section:string);  
end;

implementation

uses
  SysUtils, OlegFunction, OlegMath;

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
  for I := 0 to High(AddParamNames)+1 do
    fParams[i+fMainParamHighIndex] := TFFDParam.Create(AddParamNames[i]);
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
 fIsNotReverse:=ConfigFile.ReadBool(Section,Name+'_Reverse',True);
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

procedure TFFParamIteration.ReadFromIniFile(ConfigFile: TIniFile;
  const Section: string);
begin
  fCPDeter.ReadFromIniFile(ConfigFile,Section);
  IsConstant:=not(ConfigFile.ReadBool(Section,Name+'_IsConstant',True));
end;

procedure TFFParamIteration.UpDate;
begin
 if IsConstant then Value:=fCPDeter.Value;
end;

procedure TFFParamIteration.WriteToIniFile(ConfigFile: TIniFile;
  const Section: string);
begin
  fCPDeter.WriteToIniFile(ConfigFile,Section);
  WriteIniDef(ConfigFile,Section,Name+'_IsConstant',not(IsConstant));
end;

end.

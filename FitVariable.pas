unit FitVariable;

interface

uses
  OApproxNew, StdCtrls, OApproxShow, Forms, OlegTypePart2, OlegShowTypes, 
  Windows, OlegType, Classes, OlegMath, OlegFunction;

const
 BoolCheckBoxName='BoolCheckBox';

type

TNamedAndDescripObject=class(TNamedObject)
 private
  fDescription:string;
 {опис при виведенні на форму}
 public
  property Description:string read fDescription write fDescription;
  constructor Create(Nm:string);
end;

TFFVar=class(TNamedAndDescripObject)
{базовий класс для змінних}
 private
  fFF:TFitFunctionNew;
 public
  constructor Create(Nm:string;FF:TFitFunctionNew);
  procedure ReadFromIniFile;virtual;abstract;
  procedure WriteToIniFile;virtual;abstract;
end;

TVarBool=class(TFFVar)
{змінна булевського типу, потрібна
для проведення апроксимації}
 protected
  fValue:boolean;
 public
  property Value:boolean read fValue write fValue;
  constructor Create(FF:TFitFunctionNew;Description:string);
  procedure ReadFromIniFile;override;
  procedure WriteToIniFile;override;
end;


TVarNumber=class(TFFVar)
{спільний предок для класів цілої та дійсної змінних}
 private
  fLimits:TLimits;
 public
  property Limits:TLimits read fLimits;
  constructor Create(Nm:string;FF:TFitFunctionNew);
  destructor Destroy;override;
end;

TVarInteger=class(TVarNumber)
{ціла змінна, потрібна
для проведення апроксимації}
 private
  fValue:Integer;
  fIsNoOdd:boolean;
 protected
 public
  property Value:Integer read fValue write fValue;
  property IsNoOdd:boolean read fIsNoOdd write fIsNoOdd;
  constructor Create(Nm:string;FF:TFitFunctionNew);
  procedure ReadFromIniFile;override;
  procedure WriteToIniFile;override;
end;

TVarDouble=class(TVarNumber)
{дійсна змінна, потрібна
для проведення апроксимації}
 private
  fValue:Double;
  fAutoDeterm:boolean;
  {True якщо значення параметру
  визначається автоматично, з параметрів fDataToFit}
  fManualDetermOnly:boolean;
  {True для параметрів які можуть лише задавалися в ручному режимі}
 public
  Value:Double;
  property ManualValue:double read fValue write fValue;
  property AutoDeterm:boolean read fAutoDeterm write fAutoDeterm;
  property ManualDetermOnly:boolean read fManualDetermOnly write fManualDetermOnly;
  constructor Create(Nm:string;FF:TFitFunctionNew);
  procedure ReadFromIniFile;override;
  procedure WriteToIniFile;override;
  procedure UpDataValue;
end;


 TBoolVarCheckBox=class
   private
    fVarBool:TVarBool;
   public
    CB:TCheckBox;
    procedure UpDate;
    constructor Create(AOwner: TComponent;VarBool:TVarBool);
    destructor Destroy;override;
 end;

  TDecBoolVarParameter=class(TFFParameter)
   private
    fBoolVarCB:TBoolVarCheckBox;
    fVB:TVarBool;
    fFFParameter:TFFParameter;
   public
    constructor Create(VB:TVarBool;
                       FFParam:TFFParameter);
    procedure FormPrepare(Form:TForm);override;
    procedure UpDate;override;
    procedure FormClear;override;
    Procedure WriteToIniFile;override;
    Procedure ReadFromIniFile;override;
    function IsReadyToFitDetermination:boolean;override;
 end;

TVarNumberArray=class
  private
   fVars:array of TVarNumber;
   function GetParameterByName(str:string):TVarNumber;
   function GetParametr(index:integer):TVarNumber;
   function GetLimits(index:integer):TLimits;
   function GetValueIsPresent(index:integer):boolean;virtual;abstract;
   function GetAllValuesIsPresent:boolean;virtual;abstract;
   function GetHighIndex:integer;
  public
   property ParametrByName[str:string]:TVarNumber read GetParameterByName;
   property Parametr[index:integer]:TVarNumber read GetParametr;
   property Limits[index:integer]:TLimits read GetLimits;
   property HighIndex:integer read GetHighIndex;
   property ValueIsPresent[index:integer]:boolean read GetValueIsPresent;
   property AllValuesIsPresent:boolean read GetAllValuesIsPresent;
   destructor Destroy;override;
   procedure Add(FF:TFitFunctionNew; const Name:string);overload;virtual;abstract;
   procedure Add(FF:TFitFunctionNew;const Names:array of string);overload;virtual;abstract;
   procedure ReadFromIniFile;
   procedure WriteToIniFile;
end;


TVarIntArray=class(TVarNumberArray)
  private
   function GetValue(index:integer):Integer;
   procedure SetValue(index: integer; Value: integer);
   function GetIsNoOdd(index:integer):boolean;
   function GetValueIsPresent(index:integer):boolean;override;
   function GetAllValuesIsPresent:boolean;override;
  public
   property Value[index:integer]:integer read GetValue write SetValue;default;
   property IsNoOdd[index:integer]:boolean read GetIsNoOdd;
   Constructor Create(FF:TFitFunctionNew;const Names:array of string);overload;
   Constructor Create(FF:TFitFunctionNew;const Name:string);overload;
   procedure Add(FF:TFitFunctionNew; const Name:string);overload;override;
   procedure Add(FF:TFitFunctionNew;const Names:array of string);overload;override;
end;

TVarDoubArray=class(TVarNumberArray)
  private
   function GetValue(index:integer):Double;
   function GetAutoDeterm(index:integer):boolean;
   function GetManualDetermOnly(index:integer):boolean;
   procedure SetValue(index: integer; Value: Double);
   procedure SetAutoDeterm(index: integer; Value: boolean);
   function GetValueIsPresent(index:integer):boolean;override;
   function GetAllValuesIsPresent:boolean;override;
  public
   property Value[index:integer]:double read GetValue write SetValue;default;
   property AutoDeterm[index:integer]:boolean read GetAutoDeterm write SetAutoDeterm;
   property ManualDetermOnly[index:integer]:boolean read GetManualDetermOnly;
   Constructor Create(FF:TFitFunctionNew;const Names:array of string);overload;
   Constructor Create(FF:TFitFunctionNew;const Name:string);overload;
   procedure Add(FF:TFitFunctionNew; const Name:string);overload;override;
   procedure Add(FF:TFitFunctionNew;const Names:array of string);overload;override;
end;


implementation

uses
  Math, Graphics, SysUtils;

{ TVarBool }

constructor TVarBool.Create(FF: TFitFunctionNew;Description:string);
begin
 inherited Create('VarBool',FF);
 fDescription:=Description;
end;

procedure TVarBool.ReadFromIniFile;
begin
 fValue:=fFF.ConfigFile.ReadBool(fFF.Name,Name,False);
end;

procedure TVarBool.WriteToIniFile;
begin
 WriteIniDef(fFF.ConfigFile,fFF.Name, Name,fValue);
end;


{ TBoolVarCheckBox }

constructor TBoolVarCheckBox.Create(AOwner: TComponent;VarBool: TVarBool);
begin
  fVarBool:=VarBool;
  CB:=TCheckBox.Create(AOwner);
  CB.Name:=BoolCheckBoxName;
  CB.Caption:=fVarBool.Description;
  CB.Enabled:=True;
  CB.Checked:=fVarBool.Value;
  CB.Alignment:=taLeftJustify;
end;

destructor TBoolVarCheckBox.Destroy;
begin
 CB.Free;
 fVarBool:=nil;
 inherited;
end;

procedure TBoolVarCheckBox.UpDate;
begin
 fVarBool.Value:=CB.Checked;
end;


{ TDecorBoolVar }

constructor TDecBoolVarParameter.Create(VB:TVarBool;
                       FFParam:TFFParameter);
begin
 fFFParameter:=FFParam;
 fVB:=VB;
end;


procedure TDecBoolVarParameter.FormClear;
begin
 fBoolVarCB.CB.Parent:=nil;
 fBoolVarCB.Free;
 fFFParameter.FormClear;
end;

procedure TDecBoolVarParameter.FormPrepare(Form:TForm);
begin
  fFFParameter.FormPrepare(Form);
  fBoolVarCB := TBoolVarCheckBox.Create(Form,fVB);
  fBoolVarCB.CB.Width:=Form.Canvas.TextWidth(fBoolVarCB.CB.Caption)+20;

  AddControlToForm(fBoolVarCB.CB,Form);
end;

function TDecBoolVarParameter.IsReadyToFitDetermination: boolean;
begin
 Result:=fFFParameter.IsReadyToFitDetermination;
end;

procedure TDecBoolVarParameter.ReadFromIniFile;
begin
  fFFParameter.ReadFromIniFile;
  fVB.ReadFromIniFile;
end;

procedure TDecBoolVarParameter.UpDate;
begin
  fFFParameter.UpDate;
  fBoolVarCB.UpDate;
end;

procedure TDecBoolVarParameter.WriteToIniFile;
begin
 fFFParameter.WriteToIniFile;
 fVB.WriteToIniFile;
end;


{ TFFVar }

constructor TFFVar.Create(Nm:string;FF: TFitFunctionNew);
begin
 inherited Create(Nm);
 fFF:=FF;
end;

{ TVarInteger }

constructor TVarInteger.Create(Nm:string;FF: TFitFunctionNew);
begin
 inherited Create(Nm,FF);
 fIsNoOdd:=False;
end;

procedure TVarInteger.ReadFromIniFile;
begin
 fValue:=fFF.ConfigFile.ReadInteger(fFF.Name,Name,0);
end;

procedure TVarInteger.WriteToIniFile;
begin
  WriteIniDef(fFF.ConfigFile,fFF.Name, Name,fValue,0);
end;

{ TVarIntArray }

constructor TVarIntArray.Create(FF: TFitFunctionNew;
                         const Names: array of string);
 var i:integer;
begin
  inherited Create;
  SetLength(fVars,High(Names)+1);
  for I := 0 to High(Names)
        do fVars[i]:=TVarInteger.Create(Names[i],FF);
end;

procedure TVarIntArray.Add(FF:TFitFunctionNew;const Name: string);
begin
 SetLength(fVars,High(fVars)+2);
 fVars[High(fVars)]:=TVarInteger.Create(Name,FF);
end;

procedure TVarIntArray.Add(FF:TFitFunctionNew;const Names: array of string);
 var i:integer;
begin
  SetLength(fVars,High(fVars)+High(Names)+2);
  for I := 0 to High(Names)
      do fVars[High(fVars)-High(Names)+i]:=TVarInteger.Create(Names[i],FF);
end;

constructor TVarIntArray.Create(FF: TFitFunctionNew; const Name: string);
begin
 inherited Create;
 SetLength(fVars,1);
 fVars[0]:=TVarInteger.Create(Name,FF);
end;

function TVarIntArray.GetAllValuesIsPresent: boolean;
 var i:integer;
begin
 Result:=True;
  for I := 0 to HighIndex do
   Result:=Result and (Self[i]<>ErResult);
end;

function TVarIntArray.GetIsNoOdd(index: integer): boolean;
begin
 if InRange(index,0,High(fVars))
          then Result:=(fVars[index] as TVarInteger).IsNoOdd
          else Result:=False;
end;

function TVarIntArray.GetValue(index: integer): Integer;
begin
 if InRange(index,0,High(fVars))
          then Result:=(fVars[index] as TVarInteger).Value
          else Result:=ErResult;
end;

function TVarIntArray.GetValueIsPresent(index: integer): boolean;
begin
 Result:=Self[index]<>ErResult;
end;

procedure TVarIntArray.SetValue(index: integer; Value: integer);
begin
 if InRange(index,0,High(fVars))
       then (fVars[index] as TVarInteger).Value:=Value;
end;

{ TVarNumber }

constructor TVarNumber.Create(Nm: string; FF: TFitFunctionNew);
begin
 inherited Create(Nm,FF);
 fLimits:=TLimits.Create();
end;

destructor TVarNumber.Destroy;
begin
  fLimits.Free;
  inherited;
end;

{ TVarDouble }

constructor TVarDouble.Create(Nm: string; FF: TFitFunctionNew);
begin
 inherited Create(Nm,FF);
 fAutoDeterm:=False;
 fManualDetermOnly:=True;
 Value:=ErResult;
end;

procedure TVarDouble.ReadFromIniFile;
begin
 fValue:=fFF.ConfigFile.ReadFloat(fFF.Name,'Var'+Name+'Val',ErResult);
 fAutoDeterm:=fFF.ConfigFile.ReadBool(fFF.Name,'Var'+Name+'Auto',False);
 if fManualDetermOnly then fAutoDeterm:=False;
 UpDataValue;
end;

procedure TVarDouble.UpDataValue;
begin
 if not(fAutoDeterm) then Value:=fValue;
end;

procedure TVarDouble.WriteToIniFile;
begin
  WriteIniDef(fFF.ConfigFile,fFF.Name,'Var'+Name+'Val',fValue);
  WriteIniDef(fFF.ConfigFile,fFF.Name,'Var'+Name+'Auto',fAutoDeterm);
end;

{ TVarNumberArray }

destructor TVarNumberArray.Destroy;
 var I:integer;
begin
  for I := 0 to High(fVars) do fVars[i].Free;
  inherited;
end;

function TVarNumberArray.GetHighIndex: integer;
begin
  Result:=High(fVars);
end;

function TVarNumberArray.GetLimits(index: integer): TLimits;
begin
 if InRange(index,0,High(fVars))
          then Result:=fVars[index].Limits
          else Result:=nil;
end;

function TVarNumberArray.GetParameterByName(str: string): TVarNumber;
 var I:integer;
begin
  for I := 0 to High(fVars) do
    if fVars[i].Name=str then
      begin
        Result:=fVars[i];
        Exit;
      end;
  Result:=nil;
end;

function TVarNumberArray.GetParametr(index: integer): TVarNumber;
begin
 if InRange(index,0,High(fVars))
          then Result:=fVars[index]
          else Result:=nil;
end;

procedure TVarNumberArray.ReadFromIniFile;
 var I:integer;
begin
  for I := 0 to High(fVars) do fVars[i].ReadFromIniFile;

end;

procedure TVarNumberArray.WriteToIniFile;
 var I:integer;
begin
  for I := 0 to High(fVars) do fVars[i].WriteToIniFile;
end;

{ TVarDoubArray }

procedure TVarDoubArray.Add(FF: TFitFunctionNew; const Names: array of string);
 var i:integer;
begin
  SetLength(fVars,High(fVars)+High(Names)+2);
  for I := 0 to High(Names)
      do fVars[High(fVars)-High(Names)+i]:=TVarDouble.Create(Names[i],FF);
end;

procedure TVarDoubArray.Add(FF: TFitFunctionNew; const Name: string);
begin
 SetLength(fVars,High(fVars)+2);
 fVars[High(fVars)]:=TVarDouble.Create(Name,FF);
end;

constructor TVarDoubArray.Create(FF: TFitFunctionNew; const Name: string);
begin
 inherited Create;
 SetLength(fVars,1);
 fVars[0]:=TVarDouble.Create(Name,FF);
end;

constructor TVarDoubArray.Create(FF: TFitFunctionNew;
                      const Names: array of string);
 var i:integer;
begin
  inherited Create;
  SetLength(fVars,High(Names)+1);
  for I := 0 to High(Names)
        do fVars[i]:=TVarDouble.Create(Names[i],FF);
end;

function TVarDoubArray.GetAllValuesIsPresent: boolean;
 var i:integer;
begin
 Result:=True;
  for I := 0 to HighIndex do
   Result:=Result
   and ((Parametr[i] as TVarDouble).AutoDeterm or (Self[i]<>ErResult));
end;

function TVarDoubArray.GetAutoDeterm(index: integer): boolean;
begin
  if InRange(index,0,High(fVars))
          then Result:=(fVars[index] as TVarDouble).AutoDeterm
          else Result:=False;
end;

function TVarDoubArray.GetManualDetermOnly(index: integer): boolean;
begin
 if InRange(index,0,High(fVars))
          then Result:=(fVars[index] as TVarDouble).ManualDetermOnly
          else Result:=False;
end;

function TVarDoubArray.GetValue(index: integer): Double;
begin
 if InRange(index,0,High(fVars))
          then Result:=(fVars[index] as TVarDouble).Value
          else Result:=ErResult;
end;

function TVarDoubArray.GetValueIsPresent(index: integer): boolean;
begin
  Result:=Self[index]<>ErResult;
end;

procedure TVarDoubArray.SetAutoDeterm(index: integer; Value: boolean);
begin
 if InRange(index,0,High(fVars))
       then (fVars[index] as TVarDouble).AutoDeterm:=Value;
end;

procedure TVarDoubArray.SetValue(index: integer; Value: Double);
begin
 if InRange(index,0,High(fVars))
       then (fVars[index] as TVarDouble).ManualValue:=Value;
end;


{ TNamedAndDescripObject }

constructor TNamedAndDescripObject.Create(Nm: string);
begin
  inherited Create(Nm);
  fDescription:=Nm;
end;

end.

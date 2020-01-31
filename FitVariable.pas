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
//  fDescription:string;
// {опис при виведенні на форму}
 public
//  property Description:string read fDescription write fDescription;
  constructor Create(Nm:string;FF:TFitFunctionNew);
  procedure ReadFromIniFile;virtual;abstract;
  procedure WriteToIniFile;virtual;abstract;
end;

TVarBool=class(TFFVar)
{змінна булевського типу, потрібна
для проведення апроксимації}
 private
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
// fFF:=FF;
 fDescription:=Description;
end;

procedure TVarBool.ReadFromIniFile;
begin
 fValue:=fFF.ConfigFile.ReadBool(fFF.Name,Name,False);
end;

procedure TVarBool.WriteToIniFile;
begin
 WriteIniDef(fFF.ConfigFile,fFF.Name, Name,fValue);
// fFF.ConfigFile.WriteBool(fFF.Name,Name,fValue);
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
// fBoolVarCB := TBoolVarCheckBox.Create(VB);
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
//  fBoolVarCB.CB.Parent := Form;
  fBoolVarCB.CB.Width:=Form.Canvas.TextWidth(fBoolVarCB.CB.Caption)+20;

  AddControlToForm(fBoolVarCB.CB,Form);

//  fBoolVarCB.CB.Top:=Form.Height+MarginTop;
//  fBoolVarCB.CB.Left:=MarginLeft;
//  Form.Height:=fBoolVarCB.CB.Top+fBoolVarCB.CB.Height;
//  Form.Width:=max(Form.Width,
//                fBoolVarCB.CB.Left+fBoolVarCB.CB.Width);
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
// fDescription:=Nm;
end;

{ TVarInteger }

constructor TVarInteger.Create(Nm:string;FF: TFitFunctionNew);
begin
 inherited Create(Nm,FF);
// fDefaultValue:=DefaultValue;
// fLimits:=TLimits.Create();
 fIsNoOdd:=False;
// fDescription:=Nm;
end;

//destructor TVarInteger.Destroy;
//begin
//  fLimits.Free;
//  inherited;
//end;

procedure TVarInteger.ReadFromIniFile;
begin
 fValue:=fFF.ConfigFile.ReadInteger(fFF.Name,Name,0);
end;

procedure TVarInteger.WriteToIniFile;
begin
  WriteIniDef(fFF.ConfigFile,fFF.Name, Name,fValue,0);
//  fFF.ConfigFile.WriteInteger(fFF.Name,Name,fValue);
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

//destructor TVarIntArray.Destroy;
// var I:integer;
//begin
//  for I := 0 to High(fVarIntegers) do fVarIntegers[i].Free;
//  inherited;
//end;

//function TVarIntArray.GetHighIndex: integer;
//begin
// result:=High(fVarIntegers);
//end;

//function TVarIntArray.GetParameterByName(str: string): TVarInteger;
// var I:integer;
//begin
//  for I := 0 to High(fVarIntegers) do
//    if fVarIntegers[i].Name=str then
//      begin
//        Result:=fVarIntegers[i];
//        Exit;
//      end;
//  Result:=nil;
//end;
//
//function TVarIntArray.GetParametr(index: integer): TVarInteger;
//begin
// if InRange(index,0,High(fVarIntegers))
//          then Result:=fVarIntegers[index]
//          else Result:=nil;
//end;

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

//procedure TVarIntArray.ReadFromIniFile;
// var I:integer;
//begin
//  for I := 0 to High(fVarIntegers) do fVarIntegers[i].ReadFromIniFile;
//end;
//
//procedure TVarIntArray.WriteToIniFile;
// var I:integer;
//begin
//  for I := 0 to High(fVarIntegers) do fVarIntegers[i].WriteToIniFile;
//end;

//{ TVarIntArrayGroupBox }
//
//function TVarIntArrayGroupBox.ColumnNumberDetermination:byte;
//begin
//  if High(fLabels)<2
//    then Result:=1
//    else if High(fLabels)<5
//           then Result:=2
//           else if High(fLabels)<8
//             then Result:=3
//             else Result:=4;
//end;
//
//constructor TVarIntArrayGroupBox.Create(VarIntArray:TVarIntArray);
// var I:integer;
//begin
//  fVarIntArray:=VarIntArray;
//  Frame:=TFrame.Create(nil);
//  Frame.Name:='IntPar';
//  SetLength(fLabels,fVarIntArray.HighIndex+1);
//  SetLength(fSTexts,fVarIntArray.HighIndex+1);
//  SetLength(fIPShow,fVarIntArray.HighIndex+1);
//
//  for I := 0 to fVarIntArray.HighIndex do
//   begin
//     fLabels[i]:=TLabel.Create(Frame);
//     fLabels[i].AutoSize:=True;
//     fLabels[i].Parent:=Frame;
//     fSTexts[i]:=TStaticText.Create(Frame);
//     fSTexts[i].AutoSize:=True;
//     fSTexts[i].Parent:=Frame;
//     fIPShow[i]:=TIntegerParameterShow.Create(fSTexts[i],
//                fLabels[i],fVarIntArray.Parametr[i].Description,fVarIntArray[i]);
//     fIPShow[i].IsNoOdd:=fVarIntArray.IsNoOdd[i];
//     fIPShow[i].Limits:=fVarIntArray.Parametr[i].Limits;
//     fLabels[i].WordWrap:=False;
//     fLabels[i].Font.Color:=clMaroon;
//     fLabels[i].Font.Style:=[fsBold];
//   end;
//end;
//
//destructor TVarIntArrayGroupBox.Destroy;
// var i:integer;
//begin
//  for I := 0 to High(fLabels)do
//   begin
//     fIPShow[i].Limits:=nil;
//     fIPShow[i].Free;
//     fLabels[i].Free;
//     fSTexts[i].Free;
//   end;
//  inherited;
//end;
//
//procedure TVarIntArrayGroupBox.SizeDetermination(MaxLabelWidth: Integer; MaxSTextWidth: Byte);
//var
//  Row: Byte;
//  Col: Byte;
//  I: Integer;
//  ColNumber:byte;
//begin
// ColNumber:=ColumnNumberDetermination;
//
//  for I := 0 to fVarIntArray.HighIndex do
//  begin
//    Row := i div ColNumber;
//    Col := i mod ColNumber;
//    fLabels[i].Top := 5 + Row * (fLabels[0].Height + 10);
//    fLabels[i].Left := MarginLeft + Col * (MaxLabelWidth + MaxSTextWidth+10);
//    fSTexts[i].Top := fLabels[i].Top;
//    fSTexts[i].Left := fLabels[i].Left + MaxLabelWidth + 5;
//  end;
//  Frame.Height := fSTexts[fVarIntArray.HighIndex].Top + fSTexts[fVarIntArray.HighIndex].Height + 5;
//  Frame.Width := 25 + ColNumber * (MaxLabelWidth + MaxSTextWidth+15);
//end;
//
//function TVarIntArrayGroupBox.MaxLabelCaptionDetermination: string;
// var i,MaxWidth:integer;
//begin
// Result:='';
// MaxWidth:=0;
// for I := 0 to High(fLabels) do
//    if fLabels[i].Width>MaxWidth then
//      begin
//       MaxWidth:=fLabels[i].Width;
//       Result:=fLabels[i].Caption;
//      end;
//end;
//
//function TVarIntArrayGroupBox.MaxSTextCaptionDetermination: string;
// var i,MaxWidth:integer;
//begin
// Result:='';
// MaxWidth:=0;
// for I := 0 to High(fSTexts) do
//    if fSTexts[i].Width>MaxWidth then
//      begin
//       MaxWidth:=fSTexts[i].Width;
//       Result:=fSTexts[i].Caption;
//      end;
//end;
//
//procedure TVarIntArrayGroupBox.UpDate;
// var i:integer;
//begin
// for I := 0 to High(fLabels) do
//    fVarIntArray[i]:=fIPShow[i].Data;
//end;
//
//{ TDeVarIntArrayParameter }
//
//constructor TDeVarIntArrayParameter.Create(VarIntArray: TVarIntArray;
//  FFParam: TFFParameter);
//begin
// fFFParameter:=FFParam;
// fVarIntArray:=VarIntArray;
//end;
//
//
//procedure TDeVarIntArrayParameter.FormClear;
//begin
// fVarIntArrayGroupBox.Frame.Parent:=nil;
// fVarIntArrayGroupBox.Free;
// fFFParameter.FormClear;
//end;
//
//procedure TDeVarIntArrayParameter.FormPrepare(Form: TForm);
//begin
//  fFFParameter.FormPrepare(Form);
//  fVarIntArrayGroupBox := TVarIntArrayGroupBox.Create(fVarIntArray);
//  fVarIntArrayGroupBox.SizeDetermination(Form.Canvas.TextWidth(fVarIntArrayGroupBox.MaxLabelCaption),
//                                         Form.Canvas.TextWidth(fVarIntArrayGroupBox.MaxSTextCaption));
//  AddControlToForm(fVarIntArrayGroupBox.Frame,Form);
//end;
//
//function TDeVarIntArrayParameter.IsReadyToFitDetermination: boolean;
// var i:integer;
//begin
// Result:=fFFParameter.IsReadyToFitDetermination;
// for I := 0 to fVarIntArray.HighIndex do
//   Result:=Result and (fVarIntArray[i]<>ErResult);
//end;
//
//procedure TDeVarIntArrayParameter.ReadFromIniFile;
//begin
//  fFFParameter.ReadFromIniFile;
//  fVarIntArray.ReadFromIniFile;
//end;
//
//procedure TDeVarIntArrayParameter.UpDate;
//begin
//  fFFParameter.UpDate;
//  fVarIntArrayGroupBox.UpDate;
//end;
//
//procedure TDeVarIntArrayParameter.WriteToIniFile;
//begin
// fFFParameter.WriteToIniFile;
// fVarIntArray.WriteToIniFile;
//end;

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
  fDescription:=Nm;
end;

end.

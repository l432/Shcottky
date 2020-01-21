unit FitVariable;

interface

uses
  OApproxNew, StdCtrls, OApproxShow, Forms, OlegTypePart2, OlegShowTypes, 
  Windows;

type

TFFVar=class(TNamedObject)
{базовий класс для змінних}
 private
  fFF:TFitFunctionNew;
 public
  constructor Create(Nm:string;FF:TFitFunctionNew);
end;

TVarBool=class(TFFVar)
{змінна булевського типу, потрібна
для проведення апроксимації}
 private
//  fName:string;
//  fFF:TFitFunctionNew;
 protected
  fDescription:string;
 {опис при виведенні на форму}
  fValue:boolean;
 public
  property Value:boolean read fValue write fValue;
//  property Name:string read fName;
  property Description:string read fDescription write fDescription;
  constructor Create(FF:TFitFunctionNew;Description:string);
  procedure ReadFromIniFile;
  procedure WriteToIniFile;
end;

 TBoolVarCheckBox=class
   private
    fVarBool:TVarBool;
   public
    CB:TCheckBox;
    procedure UpDate;
    constructor Create(VarBool:TVarBool);
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
//    destructor Destroy;override;
    Procedure WriteToIniFile;override;
    Procedure ReadFromIniFile;override;
 end;


TVarInteger=class(TFFVar)
{ціла змінна, потрібна
для проведення апроксимації}
 private
  fValue:Integer;
  fDefaultValue:integer;
  fLimits:TLimits;
  fIsNoOdd:boolean;
  fDescription:string;
 protected
 public
  property Value:Integer read fValue write fValue;
  property DefaultValue:Integer read fDefaultValue write fDefaultValue;
  property Limits:TLimits read fLimits write fLimits;
  property IsNoOdd:boolean read fIsNoOdd write fIsNoOdd;
  property Description:string read fDescription write fDescription;
  constructor Create(Nm:string;FF:TFitFunctionNew;DefaultValue:integer=0);
  destructor Destroy;override;
  procedure ReadFromIniFile;
  procedure WriteToIniFile;
end;

TVarIntArray=class
  private
   fVarIntegers:array of TVarInteger;
   function GetParameterByName(str:string):TVarInteger;
   function GetParametr(index:integer):TVarInteger;
   function GetHighIndex:integer;
  public
   property ParametrByName[str:string]:TVarInteger read GetParameterByName;
   property Parametr[index:integer]:TVarInteger read GetParametr;
   property HighIndex:integer read GetHighIndex;
   Constructor Create(FF:TFitFunctionNew;const Names:array of string;
                        const DefaultValues:array of integer);overload;
   Constructor Create(FF:TFitFunctionNew;const Name:string;
                        const DefaultValue:integer=0);overload;
   destructor Destroy;override;
   procedure ReadFromIniFile;
   procedure WriteToIniFile;
end;

 TVarIntArrayGroupBox=class
   private
    fVarIntArray:TVarIntArray;
    fLabels:array of TLabel;
    fSTexts:array of TStaticText;
    fIPShow:array of TIntegerParameterShow;
    function ColumnNumberDetermination:byte;
    function MaxLabelCaptionDetermination:string;
    function MaxSTextCaptionDetermination:string;
   public
    GB:TGroupBox;
    property MaxLabelCaption:string read MaxLabelCaptionDetermination;
    property MaxSTextCaption:string read MaxSTextCaptionDetermination;
    procedure UpDate;
    constructor Create(VarIntArray:TVarIntArray);
    destructor Destroy;override;
    procedure SizeDetermination(MaxLabelWidth: Integer; MaxSTextWidth: Byte);
 end;

  TDeVarIntArrayParameter=class(TFFParameter)
   private
    fVarIntArrayGroupBox:TVarIntArrayGroupBox;
    fVarIntArray:TVarIntArray;
    fFFParameter:TFFParameter;
   public
    constructor Create(VarIntArray:TVarIntArray;
                       FFParam:TFFParameter);
    procedure FormPrepare(Form:TForm);override;
    procedure UpDate;override;
    procedure FormClear;override;
//    destructor Destroy;override;
    Procedure WriteToIniFile;override;
    Procedure ReadFromIniFile;override;
 end;

implementation

uses
  Classes, Math, Graphics;

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
 fFF.ConfigFile.WriteBool(fFF.Name,Name,fValue);
end;


{ TBoolVarCheckBox }

constructor TBoolVarCheckBox.Create(VarBool: TVarBool);
begin
  fVarBool:=VarBool;
  CB:=TCheckBox.Create(nil);
//  CB.WordWrap:=True;
//  CB.Width:=130;
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
  fBoolVarCB := TBoolVarCheckBox.Create(fVB);
//  fBoolVarCB.CB.Parent := Form;
  fBoolVarCB.CB.Width:=Form.Canvas.TextWidth(fBoolVarCB.CB.Caption)+20;

  AddControlToForm(fBoolVarCB.CB,Form);

//  fBoolVarCB.CB.Top:=Form.Height+MarginTop;
//  fBoolVarCB.CB.Left:=MarginLeft;
//  Form.Height:=fBoolVarCB.CB.Top+fBoolVarCB.CB.Height;
//  Form.Width:=max(Form.Width,
//                fBoolVarCB.CB.Left+fBoolVarCB.CB.Width);
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

constructor TVarInteger.Create(Nm:string;FF: TFitFunctionNew;DefaultValue:integer=0);
begin
 inherited Create(Nm,FF);
 fDefaultValue:=DefaultValue;
 fLimits:=TLimits.Create();
 fIsNoOdd:=False;
 fDescription:=Nm;
end;

destructor TVarInteger.Destroy;
begin
  fLimits.Free;
  inherited;
end;

procedure TVarInteger.ReadFromIniFile;
begin
 fValue:=fFF.ConfigFile.ReadInteger(fFF.Name,Name,DefaultValue);
end;

procedure TVarInteger.WriteToIniFile;
begin
  fFF.ConfigFile.WriteInteger(fFF.Name,Name,fValue);
end;

{ TVarIntArray }

constructor TVarIntArray.Create(FF: TFitFunctionNew;
            const Names: array of string; const DefaultValues: array of integer);
 var i:integer;
begin
  inherited Create;

  SetLength(fVarIntegers,High(Names)+1);
  if High(DefaultValues)=High(Names) then
     for I := 0 to High(Names)
        do fVarIntegers[i]:=TVarInteger.Create(Names[i],FF,DefaultValues[i])
                                     else
     for I := 0 to High(Names)
        do fVarIntegers[i]:=TVarInteger.Create(Names[i],FF);

end;

constructor TVarIntArray.Create(FF: TFitFunctionNew; const Name: string;
  const DefaultValue: integer);
begin
 inherited Create;
 SetLength(fVarIntegers,1);
 fVarIntegers[0]:=TVarInteger.Create(Name,FF,DefaultValue);
end;

destructor TVarIntArray.Destroy;
 var I:integer;
begin
  for I := 0 to High(fVarIntegers) do fVarIntegers[i].Free;
  inherited;
end;

function TVarIntArray.GetHighIndex: integer;
begin
 result:=High(fVarIntegers);
end;

function TVarIntArray.GetParameterByName(str: string): TVarInteger;
 var I:integer;
begin
  for I := 0 to High(fVarIntegers) do
    if fVarIntegers[i].Name=str then
      begin
        Result:=fVarIntegers[i];
        Exit;
      end;
  Result:=nil;
end;

function TVarIntArray.GetParametr(index: integer): TVarInteger;
begin
 if InRange(index,0,High(fVarIntegers))
          then Result:=fVarIntegers[index]
          else Result:=nil;
end;

procedure TVarIntArray.ReadFromIniFile;
 var I:integer;
begin
  for I := 0 to High(fVarIntegers) do fVarIntegers[i].ReadFromIniFile;
end;

procedure TVarIntArray.WriteToIniFile;
 var I:integer;
begin
  for I := 0 to High(fVarIntegers) do fVarIntegers[i].WriteToIniFile;
end;

{ TVarIntArrayGroupBox }

function TVarIntArrayGroupBox.ColumnNumberDetermination:byte;
begin
  if High(fLabels)<2
    then Result:=1
    else if High(fLabels)<5
           then Result:=2
           else if High(fLabels)<8
             then Result:=3
             else Result:=4;
end;

constructor TVarIntArrayGroupBox.Create(VarIntArray:TVarIntArray);
 var I:integer;
begin
  fVarIntArray:=VarIntArray;
  GB:=TGroupBox.Create(nil);
  GB.Caption:='';
  SetLength(fLabels,fVarIntArray.HighIndex+1);
  SetLength(fSTexts,fVarIntArray.HighIndex+1);
  SetLength(fIPShow,fVarIntArray.HighIndex+1);

  for I := 0 to fVarIntArray.HighIndex do
   begin
     fLabels[i]:=TLabel.Create(GB);
     fLabels[i].AutoSize:=True;
     fLabels[i].Parent:=GB;
     fSTexts[i]:=TStaticText.Create(GB);
     fSTexts[i].AutoSize:=True;
     fSTexts[i].Parent:=GB;
     fIPShow[i]:=TIntegerParameterShow.Create(fSTexts[i],
                fLabels[i],fVarIntArray.Parametr[i].Description,fVarIntArray.Parametr[i].Value);
     fIPShow[i].IsNoOdd:=fVarIntArray.Parametr[i].fIsNoOdd;
     fIPShow[i].Limits:=fVarIntArray.Parametr[i].Limits;
     fLabels[i].WordWrap:=False;
     fLabels[i].Font.Color:=clMaroon;
     fLabels[i].Font.Style:=[fsBold];
   end;
end;

destructor TVarIntArrayGroupBox.Destroy;
 var i:integer;
begin
  for I := 0 to High(fLabels)do
   begin
     fIPShow[i].Limits:=nil;
     fIPShow[i].Free;
     fLabels[i].Free;
     fSTexts[i].Free;
   end;
  inherited;
end;

procedure TVarIntArrayGroupBox.SizeDetermination(MaxLabelWidth: Integer; MaxSTextWidth: Byte);
var
  Row: Byte;
  Col: Byte;
  I: Integer;
  ColNumber:byte;
begin
 ColNumber:=ColumnNumberDetermination;

  for I := 0 to fVarIntArray.HighIndex do
  begin
    Row := i div ColNumber;
    Col := i mod ColNumber;
    fLabels[i].Top := 5 + Row * (fLabels[0].Height + 10);
    fLabels[i].Left := MarginLeft + Col * (MaxLabelWidth + MaxSTextWidth+10);
    fSTexts[i].Top := fLabels[i].Top;
    fSTexts[i].Left := fLabels[i].Left + MaxLabelWidth + 5;
  end;
  GB.Height := fSTexts[fVarIntArray.HighIndex].Top + fSTexts[fVarIntArray.HighIndex].Height + 5;
  GB.Width := 25 + ColNumber * (MaxLabelWidth + MaxSTextWidth+15);
end;

function TVarIntArrayGroupBox.MaxLabelCaptionDetermination: string;
 var i,MaxWidth:integer;
begin
 Result:='';
 MaxWidth:=0;
 for I := 0 to High(fLabels) do
    if fLabels[i].Width>MaxWidth then
      begin
       MaxWidth:=fLabels[i].Width;
       Result:=fLabels[i].Caption;
      end;
end;

function TVarIntArrayGroupBox.MaxSTextCaptionDetermination: string;
 var i,MaxWidth:integer;
begin
 Result:='';
 MaxWidth:=0;
 for I := 0 to High(fSTexts) do
    if fSTexts[i].Width>MaxWidth then
      begin
       MaxWidth:=fSTexts[i].Width;
       Result:=fSTexts[i].Caption;
      end;
end;

procedure TVarIntArrayGroupBox.UpDate;
 var i:integer;
begin
 for I := 0 to High(fLabels) do
    fVarIntArray.Parametr[i].Value:=fIPShow[i].Data;
end;

{ TDeVarIntArrayParameter }

constructor TDeVarIntArrayParameter.Create(VarIntArray: TVarIntArray;
  FFParam: TFFParameter);
begin
 fFFParameter:=FFParam;
 fVarIntArray:=VarIntArray;
end;


procedure TDeVarIntArrayParameter.FormClear;
begin
 fVarIntArrayGroupBox.GB.Parent:=nil;
 fVarIntArrayGroupBox.Free;
 fFFParameter.FormClear;
end;

procedure TDeVarIntArrayParameter.FormPrepare(Form: TForm);
begin
  fFFParameter.FormPrepare(Form);
  fVarIntArrayGroupBox := TVarIntArrayGroupBox.Create(fVarIntArray);
  fVarIntArrayGroupBox.SizeDetermination(Form.Canvas.TextWidth(fVarIntArrayGroupBox.MaxLabelCaption),
                                         Form.Canvas.TextWidth(fVarIntArrayGroupBox.MaxSTextCaption));
  AddControlToForm(fVarIntArrayGroupBox.GB,Form);
end;

procedure TDeVarIntArrayParameter.ReadFromIniFile;
begin
  fFFParameter.ReadFromIniFile;
  fVarIntArray.ReadFromIniFile;
end;

procedure TDeVarIntArrayParameter.UpDate;
begin
  fFFParameter.UpDate;
  fVarIntArrayGroupBox.UpDate;
end;

procedure TDeVarIntArrayParameter.WriteToIniFile;
begin
 fFFParameter.WriteToIniFile;
 fVarIntArray.WriteToIniFile;
end;

end.

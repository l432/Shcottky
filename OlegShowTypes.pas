unit OlegShowTypes;

interface

uses
  OlegTypePart2, StdCtrls, OlegType, IniFiles, Classes, OlegFunction;

const DoubleConstantSection='DoubleConstant';
      NoFile='no file';
      WindowCaptionFooter=' input';
      WindowTextFooter=' value is expected';

type

  TParameterShowNew=class (TNamedInterfacedObject)
{  дл€ в≥дображенн€ на форм≥
  а) значенн€ параметру
  б) його назви
  кл≥к на значенн≥ викликаЇ по€ву в≥конц€ дл€ його зм≥ни,
  базовий клас, дл€ збереженн€ параметр≥в р≥зних тип≥в
  див. нащадк≥в}
   private
    STData:TStaticText; //величина параметру
    fParametrCaption:string;//назва параметру
//    STCaption:TLabel; //назва параметру
    fWindowCaption:string; //назва в≥конц€ зм≥ни параметра
    fWindowText:string;    //текст у в≥конц≥ зм≥ни параметру
    FColorChangeWithParameter: boolean;
    fIniNameSalt:string;//добавка до ≥мен≥, з €ким збер≥гаютьс€ дан≥ в ini.файл≥
    fHookParameterClick: TSimpleEvent;
    function StringToExpectedStringConvertion(str:string):string;virtual;abstract;
    {перетворенн€ str в р€док, де число
    у потр≥бному формат≥,
    можлив≥ помилки не в≥дловлюютьс€, див. ParameterClick}
    procedure ParameterClick(Sender: TObject);virtual;
    function ReadStringValueFromIniFile(ConfigFile:TIniFile;NameIni:string):string;virtual;abstract;
    //повертаЇ символьне представленн€ значенн€ зм≥нноњ
    procedure WriteNumberToIniFile(ConfigFile:TIniFile;NameIni:string);virtual;abstract;
   public
    property HookParameterClick:TSimpleEvent read fHookParameterClick write fHookParameterClick;
    property ColorChangeWithParameter:boolean read FColorChangeWithParameter write FColorChangeWithParameter;
    property IniNameSalt:string write fIniNameSalt;
    Constructor Create(STD:TStaticText;
                       STC:TLabel;
                       ParametrCaption:string;
                       WT:string);overload;
    Constructor Create(STD:TStaticText;
                       ParametrCaption:string;
                       WT:string);overload;
    procedure ReadFromIniFile(ConfigFile:TIniFile);override;
    procedure WriteToIniFile(ConfigFile:TIniFile);override;
//    procedure Free;overload;
    procedure ColorToActive(Value:boolean);
    procedure SetName(Name:string);
    procedure ForUseInShowObject(NamedObject:IName;
                                 ColorChanging:boolean=true;
                                 ActiveColor:boolean=false);overload;
    procedure ForUseInShowObject(NamedObject:TNamedInterfacedObject;
                                 ColorChanging:boolean=true;
                                 ActiveColor:boolean=false);overload;
  end;  //   TParameterShow=class (TNamedInterfacedObject)

  TParameterShowArray=class
   private
    fParameterShowArray:array of TParameterShowNew;
    function GetCount:integer;
   public
    constructor Create(PSA:array of TParameterShowNew);
    procedure Free;
    procedure ReadFromIniFile(ConfigFile:TIniFile);
    procedure WriteToIniFile(ConfigFile:TIniFile);
    procedure ColorToActive(Value:boolean);
    procedure ForUseInShowObject(NamedObject:TNamedInterfacedObject);
    property Count:integer read GetCount;
  end;

  TDoubleParameterShow=class (TParameterShowNew)
   private
    FDefaulValue:double;
    fDigitNumber:byte;
    function StringToExpectedStringConvertion(str:string):string;override;
    function GetData:double;
    procedure SetData(value:double);
    procedure SetDefaulValue(const Value: double);
    function ValueToString(Value:double):string;
    function ReadStringValueFromIniFile(ConfigFile:TIniFile;NameIni:string):string;override;
    procedure WriteNumberToIniFile(ConfigFile:TIniFile;NameIni:string);override;
    procedure CreateFooter(DN: Byte; InitValue: Double);
   public
    property DefaulValue:double read FDefaulValue write SetDefaulValue;
    Constructor Create(STD:TStaticText;
                       STC:TLabel;
                       ParametrCaption:string;
                       WT:string;
                       InitValue:double;
                       DN:byte=3
    );overload;
    Constructor Create(STD:TStaticText;
                       ParametrCaption:string;
                       WT:string;
                       InitValue:double;
                       DN:byte=3
    );overload;
    Constructor Create(STD:TStaticText;
                       STC:TLabel;
                       ParametrCaption:string;
                       InitValue:double;
                       DN:byte=3
    );overload;
    Constructor Create(STD:TStaticText;
                       ParametrCaption:string;
                       InitValue:double;
                       DN:byte=3
    );overload;
    property Data:double read GetData write SetData;
  end;  //   TDoubleParameterShow=class (TParameterShow)

  TIntegerParameterShow=class (TParameterShowNew)
   private
    fIsPositive:boolean;
    FDefaulValue:integer;
    function StringToExpectedStringConvertion(str:string):string;override;
    function GetData:integer;
    procedure SetData(value:integer);
    procedure SetDefaulValue(const Value: integer);
    function ReadStringValueFromIniFile(ConfigFile:TIniFile;NameIni:string):string;override;
    procedure WriteNumberToIniFile(ConfigFile:TIniFile;NameIni:string);override;
   public
    property IsPositive:boolean read fIsPositive write fIsPositive;
    property DefaulValue:integer read FDefaulValue write SetDefaulValue;
    Constructor Create(STD:TStaticText;
                       STC:TLabel;
                       ParametrCaption:string;
                       WT:string;
                       InitValue:integer
    );overload;
    Constructor Create(STD:TStaticText;
                       STC:TLabel;
                       ParametrCaption:string;
                       InitValue:integer
    );overload;
    property Data:integer read GetData write SetData;
  end;  //   TIntegerParameterShow=class (TParameterShow)


  TStringParameterShow=class (TParameterShowNew)
   private
    fDataVariants:TStringList;
    function StringToExpectedStringConvertion(str:string):string;override;
    function GetData:ShortInt;
    procedure SetData(value:ShortInt);
    procedure ParameterClick(Sender: TObject);override;
    function ReadStringValueFromIniFile(ConfigFile:TIniFile;NameIni:string):string;override;
    procedure WriteNumberToIniFile(ConfigFile:TIniFile;NameIni:string);override;
    procedure CreateFooter(DataVariants: TStringList);
   public
    Constructor Create(STD:TStaticText;
                       STC:TLabel;
                       ParametrCaption:string;
                       DataVariants: TStringList
    );overload;
    Constructor Create(STD:TStaticText;
                       ParametrCaption:string;
                       DataVariants: TStringList
    );overload;
    property Data:ShortInt read GetData write SetData;
  end;    //TStringParameterShow=class (TParameterShow)

implementation

uses
  SysUtils, Controls, Dialogs, Graphics;

Constructor TDoubleParameterShow.Create(STD:TStaticText;
                       STC:TLabel;
                       ParametrCaption:string;
                       WT:string;
                       InitValue:double;
                       DN:byte=3
                       );
begin
  inherited Create(STD,STC,ParametrCaption,WT);
  CreateFooter(DN, InitValue);
//  fDigitNumber:=DN;
//  STData.Caption:=ValueToString(InitValue);
//  DefaulValue:=InitValue;
end;

constructor TDoubleParameterShow.Create(STD: TStaticText;
                                        STC: TLabel;
                                        ParametrCaption: string;
                                        InitValue: double;
                                        DN: byte);
begin
 Create(STD,STC,ParametrCaption,ParametrCaption+WindowTextFooter,InitValue,DN);
end;

constructor TDoubleParameterShow.Create(STD: TStaticText;
  ParametrCaption: string; InitValue: double; DN: byte);
begin
 Create(STD,ParametrCaption,ParametrCaption+WindowTextFooter,InitValue,DN);
end;

procedure TDoubleParameterShow.CreateFooter(DN: Byte; InitValue: Double);
begin
  fDigitNumber := DN;
  STData.Caption := ValueToString(InitValue);
  DefaulValue := InitValue;
end;

constructor TDoubleParameterShow.Create(STD: TStaticText; ParametrCaption,
  WT: string; InitValue: double; DN: byte);
begin
  inherited Create(STD,ParametrCaption,WT);
  CreateFooter(DN, InitValue);
end;

function TDoubleParameterShow.GetData:double;
begin
 Result:=StrToFloat(STData.Caption);
end;

procedure TDoubleParameterShow.SetData(value:double);
begin
  try
    STData.Caption:=ValueToString(value);
  finally

  end;
end;

function TDoubleParameterShow.ReadStringValueFromIniFile(ConfigFile: TIniFile;
  NameIni: string): string;
begin
 Result:=ValueToString(ConfigFile.ReadFloat(fName,NameIni,DefaulValue));
end;

procedure TDoubleParameterShow.WriteNumberToIniFile(ConfigFile: TIniFile;
  NameIni: string);
begin
 WriteIniDef(ConfigFile, fName, NameIni, StrToFloat(STData.Caption),DefaulValue)
end;

procedure TDoubleParameterShow.SetDefaulValue(const Value: double);
begin
  FDefaulValue := Value;
end;

function TDoubleParameterShow.StringToExpectedStringConvertion(
  str: string): string;
begin
 Result:=ValueToString(StrToFloat(str));
end;

function TDoubleParameterShow.ValueToString(Value:double):string;
begin
//  if (Frac(Value)=0)and(Int(Value/Power(10,fDigitNumber+1))=0)
//    then Result:=FloatToStrF(Value,ffGeneral,fDigitNumber,fDigitNumber-1)
//    then
    Result:=FloatToStrF(Value,ffGeneral,fDigitNumber,fDigitNumber-1)
//    else Result:=FloatToStrF(Value,ffExponent,fDigitNumber,fDigitNumber-1);
end;



{ TIntegerParameterShow }

constructor TIntegerParameterShow.Create(STD: TStaticText; STC: TLabel;
  ParametrCaption, WT: string; InitValue: integer);
begin
  inherited Create(STD,STC,ParametrCaption,WT);
  STData.Caption:=IntToStr(InitValue);
  DefaulValue:=InitValue;
  fIsPositive:=false;
end;

constructor TIntegerParameterShow.Create(STD: TStaticText; STC: TLabel;
  ParametrCaption: string; InitValue: integer);
begin
  Create(STD,STC,ParametrCaption,ParametrCaption+WindowTextFooter,InitValue);
end;

function TIntegerParameterShow.GetData: integer;
begin
  if fIsPositive then Result:=abs(StrToInt(STData.Caption))
                 else Result:=StrToInt(STData.Caption);
end;

function TIntegerParameterShow.ReadStringValueFromIniFile(ConfigFile: TIniFile;
  NameIni: string): string;
begin
 if fIsPositive then
   Result:=IntToStr(abs(ConfigFile.ReadInteger(fName,NameIni,DefaulValue)))
                else
   Result:=IntToStr(ConfigFile.ReadInteger(fName,NameIni,DefaulValue));
end;

procedure TIntegerParameterShow.SetData(value: integer);
begin
  try
    if fIsPositive then  STData.Caption:=IntToStr(abs(value))
                   else  STData.Caption:=IntToStr(value);
  finally

  end;
end;

procedure TIntegerParameterShow.SetDefaulValue(const Value: integer);
begin
 if fIsPositive then FDefaulValue := abs(Value)
                else FDefaulValue := Value;
end;

function TIntegerParameterShow.StringToExpectedStringConvertion(str: string): string;
begin
 if fIsPositive then Result:=IntToStr(abs(StrToInt(str)))
                else Result:=IntToStr(StrToInt(str));
end;

procedure TIntegerParameterShow.WriteNumberToIniFile(ConfigFile: TIniFile;
  NameIni: string);
begin
 WriteIniDef(ConfigFile, fName, NameIni, StrToInt(STData.Caption),DefaulValue)
end;

{ TParameterShow }

constructor TParameterShowNew.Create(STD:TStaticText;
                       STC:TLabel;
                       ParametrCaption:string;
                       WT:string);
begin
  Create(STD,ParametrCaption,WT);
  if STC<>nil then
    begin
      STC.Caption:=ParametrCaption;
      STC.WordWrap:=True;
    end;
end;


procedure TParameterShowNew.ForUseInShowObject(NamedObject: IName;
                                         ColorChanging:boolean=true;
                                         ActiveColor:boolean=false);
begin
 SetName(NamedObject.Name);
 ColorChangeWithParameter:=ColorChanging;
 ColorToActive(ActiveColor);
end;

constructor TParameterShowNew.Create(STD: TStaticText; ParametrCaption,
  WT: string);
begin
  inherited Create;
  STData:=STD;
  STData.OnClick:=ParameterClick;
  STData.Cursor:=crHandPoint;
  fParametrCaption:=ParametrCaption;
  fWindowText:=WT;
  fWindowCaption:=ParametrCaption+WindowCaptionFooter;
  fName:=DoubleConstantSection;
//  HookParameterChange:=TSimpleClass.EmptyProcedure;
  fColorChangeWithParameter:=False;
  fIniNameSalt:='';
  HookParameterClick:=TSimpleClass.EmptyProcedure;
end;

procedure TParameterShowNew.ForUseInShowObject(NamedObject: TNamedInterfacedObject;
  ColorChanging, ActiveColor: boolean);
begin
 SetName(NamedObject.Name);
 ColorChangeWithParameter:=ColorChanging;
 ColorToActive(ActiveColor);
end;

//procedure TParameterShowNew.Free;
//begin
//
//end;


procedure TParameterShowNew.ParameterClick(Sender: TObject);
begin
   try
    STData.Caption:=StringToExpectedStringConvertion(InputBox(fWindowCaption,fWindowText,STData.Caption));
    if ColorChangeWithParameter then ColorToActive(false);
    HookParameterClick;
  finally
  end;
end;


procedure TParameterShowNew.ReadFromIniFile(ConfigFile: TIniFile);
begin
 if Name='' then Exit;
// STData.Caption:=ReadStringValueFromIniFile(ConfigFile,STCaption.Caption+fIniNameSalt)
 STData.Caption:=ReadStringValueFromIniFile(ConfigFile,fParametrCaption+fIniNameSalt)
end;


procedure TParameterShowNew.SetName(Name: string);
begin
 fName:=Name;
end;

procedure TParameterShowNew.WriteToIniFile(ConfigFile: TIniFile);
begin
 if Name='' then Exit;
 WriteNumberToIniFile(ConfigFile,fParametrCaption+fIniNameSalt);
end;

procedure TParameterShowNew.ColorToActive(Value: boolean);
begin
 if FColorChangeWithParameter then
  if Value then STData.Font.Color:=clPurple
           else STData.Font.Color:=clBlack;
end;

{ TStringParameterShow }

constructor TStringParameterShow.Create(STD: TStaticText;
                                        STC: TLabel;
                                        ParametrCaption: string;
                                        DataVariants: TStringList);
begin
  inherited Create(STD,STC,ParametrCaption,'');
  CreateFooter(DataVariants);
end;

constructor TStringParameterShow.Create(STD: TStaticText;
  ParametrCaption: string; DataVariants: TStringList);
begin
  inherited Create(STD,ParametrCaption,'');
  CreateFooter(DataVariants);
end;

procedure TStringParameterShow.CreateFooter(DataVariants: TStringList);
begin
  fDataVariants := DataVariants;
  STData.Caption := fDataVariants.Strings[0];
end;

function TStringParameterShow.GetData: ShortInt;
begin
 Result:=fDataVariants.IndexOf(STData.Caption);
end;

procedure TStringParameterShow.ParameterClick(Sender: TObject);
var
    i:ShortInt;
begin

 i:=SelectFromVariants(fDataVariants,Data,fWindowCaption);
 if i>-1 then
   begin
    STData.Caption:=fDataVariants.Strings[i];
    if ColorChangeWithParameter then ColorToActive(false);
    HookParameterClick;
   end;

end;

function TStringParameterShow.ReadStringValueFromIniFile(ConfigFile: TIniFile;
  NameIni: string): string;
 var i:ShortInt;
begin
 i:=ConfigFile.ReadInteger(fName,NameIni,0);
 if (i<0) or (i>=fDataVariants.Count) then i:=0;
 Result:=fDataVariants.Strings[i];
end;

procedure TStringParameterShow.SetData(value: ShortInt);
begin
 if (Value>-1) and (Value<fDataVariants.Count) then
  STData.Caption:=fDataVariants.Strings[Value];
end;

function TStringParameterShow.StringToExpectedStringConvertion(
  str: string): string;
begin
 Result:=str;
end;

procedure TStringParameterShow.WriteNumberToIniFile(ConfigFile: TIniFile;
  NameIni: string);
begin
 WriteIniDef(ConfigFile, fName, NameIni, Data, -1);
end;

{ TParameterShowArray }

procedure TParameterShowArray.ColorToActive(Value: boolean);
 var     I:byte;
begin
 for I := 0 to High(fParameterShowArray) do
   fParameterShowArray[i].ColorToActive(Value);
end;

constructor TParameterShowArray.Create(PSA: array of TParameterShowNew);
 var     i:byte;
begin
 SetLength(fParameterShowArray,High(PSA)+1);
 for I := 0 to High(PSA) do
   fParameterShowArray[i]:=PSA[i];
end;


procedure TParameterShowArray.ForUseInShowObject(
       NamedObject: TNamedInterfacedObject);
 var     I:byte;
begin
 for I := 0 to High(fParameterShowArray) do
   fParameterShowArray[i].ForUseInShowObject(NamedObject);
end;

procedure TParameterShowArray.Free;
 var     I:byte;
begin
 for I := 0 to High(fParameterShowArray) do
   fParameterShowArray[i].Free;
 inherited Free;
end;

function TParameterShowArray.GetCount: integer;
begin
 Result:=High(fParameterShowArray)+1;
end;

procedure TParameterShowArray.ReadFromIniFile(ConfigFile: TIniFile);
 var     I:byte;
begin
 for I := 0 to High(fParameterShowArray) do
   fParameterShowArray[i].ReadFromIniFile(ConfigFile);
end;

procedure TParameterShowArray.WriteToIniFile(ConfigFile: TIniFile);
 var     I:byte;
begin
 for I := 0 to High(fParameterShowArray) do
   fParameterShowArray[i].WriteToIniFile(ConfigFile);
end;


end.

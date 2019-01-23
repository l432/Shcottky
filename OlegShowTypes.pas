unit OlegShowTypes;

interface

uses
  OlegTypePart2, StdCtrls, OlegType, IniFiles, Classes, OlegFunction;
//
//uses
//  StdCtrls, IniFiles, Windows, ComCtrls, ArduinoDevice, OlegType, Series,
//  Measurement, ExtCtrls, Classes, ArduinoDeviceShow, TeCanvas;
//
const DoubleConstantSection='DoubleConstant';
      NoFile='no file';
      RangeSection='Range';
      WindowCaptionFooter=' input';
      WindowTextFooter=' value is expected';

type

  TParameterShowNew=class (TNamedInterfacedObject)
{  для відображення на формі
  а) значення параметру
  б) його назви
  клік на значенні викликає появу віконця для його зміни,
  базовий клас, для збереження параметрів різних типів
  див. нащадків}
   private
    STData:TStaticText; //величина параметру
    fParametrCaption:string;//назва параметру
//    STCaption:TLabel; //назва параметру
    fWindowCaption:string; //назва віконця зміни параметра
    fWindowText:string;    //текст у віконці зміни параметру
    FColorChangeWithParameter: boolean;
    fIniNameSalt:string;//добавка до імені, з яким зберігаються дані в ini.файлі
    fHookParameterClick: TSimpleEvent;
    function StringToExpectedStringConvertion(str:string):string;virtual;abstract;
    {перетворення str в рядок, де число
    у потрібному форматі,
    можливі помилки не відловлюються, див. ParameterClick}
    procedure ParameterClick(Sender: TObject);virtual;
    function ReadStringValueFromIniFile(ConfigFile:TIniFile;NameIni:string):string;virtual;abstract;
    //повертає символьне представлення значення змінної
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
    FDefaulValue:integer;
    function StringToExpectedStringConvertion(str:string):string;override;
    function GetData:integer;
    procedure SetData(value:integer);
    procedure SetDefaulValue(const Value: integer);
    function ReadStringValueFromIniFile(ConfigFile:TIniFile;NameIni:string):string;override;
    procedure WriteNumberToIniFile(ConfigFile:TIniFile;NameIni:string);override;
   public
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
//
//
//TLimitShow=class(TNamedInterfacedObject)
//private
//  UpDownHigh,UpDownLow:TUpDown;
//  fDivisor:byte;
//  fDigitNumber:byte;
//  fHookForGraphElementApdate:TSimpleEvent;
//  procedure UpDownBegin(MaxValue: Double; UpDown: TUpDown);
//  function GetValue(UpDown: TUpDown): double;virtual;
//  function GetValueString(UpDown: TUpDown): string;virtual;
//  function PositionIsEqual():boolean;
//  procedure UpDownHighClick(Sender: TObject; Button: TUDBtnType);
//  procedure UpDownLowClick(Sender: TObject; Button: TUDBtnType);
//  function GetHighValue():double;virtual;
//  function GetLowValue():double;virtual;
//public
//  ValueLabelHigh,ValueLabelLow:TLabel;
//  property HookForGraphElementApdate:TSimpleEvent
//             read fHookForGraphElementApdate write fHookForGraphElementApdate;
//  property HighValue:double read GetHighValue;
//  property LowValue:double read GetLowValue;
//  Constructor Create(Nm: string;
//                     MaxValue: Double;
//                     DigitNumber: Byte;
//                     UDH, UDL: TUpDown;
//                     VLH, VLL: TLabel);overload;
//  Constructor Create(Nm: string;
//                     MaxValue:double;
//                     DigitNumber:byte;
//                     UDH,UDL:TUpDown;
//                     VLH,VLL:TLabel;
//                     HookFunction:TSimpleEvent);overload;
// procedure ReadFromIniFile(ConfigFile: TIniFile);
// procedure WriteToIniFile(ConfigFile: TIniFile);
//end;
//
//TLimitShowRev=class(TLimitShow)
//private
//  function GetHighValue():double;override;
//  function GetLowValue():double;override;
//  function GetValue(UpDown: TUpDown): double;override;
//  function GetValueString(UpDown: TUpDown): string;override;
//public
//end;
//
//TDAC_Show=class
//  private
//   fOutputInterface: IDAC;
//   fValueShow:TDoubleParameterShow;
//   fKodShow:TIntegerParameterShow;
//   ValueSetButton,KodSetButton,ResetButton:TButton;
//   procedure ValueSetButtonAction(Sender:TObject);
//   procedure KodSetButtonAction(Sender:TObject);
//   procedure ResetButtonClick(Sender:TObject);
//  public
//   Constructor Create(OI: IDAC;
//                      VData,KData:TStaticText;
//                      VL, KL: TLabel;
//                      VSB, KSB, RB: TButton);
//    procedure ReadFromIniFile(ConfigFile:TIniFile);virtual;
//    procedure WriteToIniFile(ConfigFile:TIniFile);virtual;
//    procedure Free;
//end;
//
//  TArduinoDACShow=class(TArduinoSetterShow)
//  private
//   fDAC_Show:TDAC_Show;
//  public
//   Constructor Create(ArdDAC:TArduinoDAC;
//                       PinLs: array of TPanel;
//                       PinVariant:TStringList;
//                       VData,KData:TStaticText;
//                       VL, KL: TLabel;
//                       VSB, KSB, RB: TButton);
//   Procedure Free;
//   procedure ReadFromIniFile(ConfigFile:TIniFile);override;
//   Procedure WriteToIniFile(ConfigFile:TIniFile);override;
//  end;
//
//function LastFileName(Mask:string):string;
//{повертає назву (повну, з розширенням) останього файлу в
//поточному каталозі, чия назва задовольняє маску Mask}
//
//function LastDATFileName():string;
//{повертає назву (коротку) останього .dat файлу в
//поточному каталозі}
//
//Procedure MelodyShot();
//
//Procedure MelodyLong();
//
//
//
implementation

uses
  SysUtils, Controls, Dialogs, Graphics;
//
//uses
//  Dialogs, SysUtils, Math, Controls, Graphics, Forms, OlegFunction;
//
//
//function LastFileName(Mask:string):string;
// var SR : TSearchRec;
//     tm:integer;
//begin
// Result:=NoFile;
// if FindFirst(Mask, faAnyFile, SR) <> 0 then Exit;
// Result:=SR.name;
// tm:=SR.time;
// while FindNext(SR) = 0 do
//   if tm<SR.time then
//     begin
//     Result:=SR.name;
//     tm:=SR.time;
//     end;
// FindClose(SR);
//end;
//
//function LastDATFileName():string;
//begin
//  Result:=LastFileName('*.dat');
//  if Result<>NoFile then
//   Result:=Copy(Result,1,Length(Result)-4);
//end;
//
//Procedure MelodyShot();
//begin
//  Windows.Beep(100,50);
//end;
//
//Procedure MelodyLong();
//begin
// Windows.Beep(700,100);
// Windows.Beep(200,100);
// Windows.Beep(500,100);
//end;
//
//
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


//{ LimitShow }
//
//constructor TLimitShow.Create(Nm: string;
//                              MaxValue: Double;
//                              DigitNumber: Byte;
//                              UDH, UDL: TUpDown;
//                              VLH, VLL: TLabel);
//begin
// inherited Create;
// fDigitNumber:=DigitNumber;
// UpDownHigh:=UDH;
// UpDownLow:=UDL;
// ValueLabelHigh:=VLH;
// ValueLabelLow:=VLL;
// fDivisor:=round(Power(10,fDigitNumber));
// UpDownBegin(MaxValue,UpDownHigh);
// UpDownBegin(MaxValue,UpDownLow);
// UpDownHigh.OnClick:=UpDownHighClick;
// UpDownLow.OnClick:=UpDownLowClick;
// fName:=Nm;
//end;
//
//constructor TLimitShow.Create(Nm: string;
//                              MaxValue: double;
//                              DigitNumber: byte;
//                              UDH,UDL: TUpDown;
//                              VLH, VLL: TLabel;
//                              HookFunction: TSimpleEvent);
//begin
// Create(Nm, MaxValue, DigitNumber, UDH, UDL, VLH, VLL);
// HookForGraphElementApdate:=HookFunction;
//end;
//
//function TLimitShow.GetHighValue: double;
//begin
//  Result:=GetValue(UpDownHigh);
//end;
//
//function TLimitShow.GetLowValue: double;
//begin
//  Result:=GetValue(UpDownLow);
//end;
//
//function TLimitShow.GetValue(UpDown: TUpDown): double;
//begin
// Result:=UpDown.Position/fDivisor;
//end;
//
//function TLimitShow.GetValueString(UpDown: TUpDown): string;
//begin
// Result:=FloatToStrF(GetValue(UpDown),ffFixed, 4, fDigitNumber);
//end;
//
//function TLimitShow.PositionIsEqual: boolean;
//begin
// Result:=(UpDownHigh.Position-UpDownLow.Position)<1;
//end;
//
//procedure TLimitShow.ReadFromIniFile(ConfigFile: TIniFile);
//  var temp:Smallint;
//begin
//
//  temp:=ConfigFile.ReadInteger(RangeSection,fName+'Max',UpDownHigh.Max);
//  if (temp>UpDownHigh.Max)or(temp<0) then  temp:=UpDownHigh.Max;
//  UpDownHigh.Position:=temp;
//
//  temp:=ConfigFile.ReadInteger(RangeSection,fName+'Min',0);
//  if (temp>UpDownHigh.Max)or(temp<0) then  temp:=0;
//  UpDownLow.Position:=temp;
//
//  if UpDownHigh.Position<=UpDownLow.Position then
//    begin
//      UpDownHigh.Position:=UpDownHigh.Max;
//      UpDownLow.Position:=0;
//    end;
//  ValueLabelHigh.Caption:=GetValueString(UpDownHigh);
//  ValueLabelLow.Caption:=GetValueString(UpDownLow);
//  HookForGraphElementApdate();
//end;
//
//procedure TLimitShow.UpDownBegin(MaxValue: Double; UpDown: TUpDown);
//begin
// UpDown.Min:=0;
// UpDown.Max:=round(MaxValue*fDivisor);
// UpDown.Increment:=1;
//end;
//
//procedure TLimitShow.UpDownHighClick(Sender: TObject; Button: TUDBtnType);
//begin
//  if PositionIsEqual then
//   begin
//    UpDownHigh.Position:=UpDownHigh.Position+UpDownHigh.Increment;
//    Exit;
//   end;
//  ValueLabelHigh.Caption:=GetValueString(UpDownHigh);
//  HookForGraphElementApdate();
//end;
//
//procedure TLimitShow.UpDownLowClick(Sender: TObject; Button: TUDBtnType);
//begin
//  if PositionIsEqual then
//   begin
//    UpDownLow.Position:=UpDownLow.Position-UpDownLow.Increment;
//    Exit;
//   end;
//  ValueLabelLow.Caption:=GetValueString(UpDownLow);
//  HookForGraphElementApdate();
//end;
//
//procedure TLimitShow.WriteToIniFile(ConfigFile: TIniFile);
//begin
//    WriteIniDef(ConfigFile,RangeSection,fName+'Max',UpDownHigh.Position,UpDownHigh.Max);
//    WriteIniDef(ConfigFile,RangeSection,fName+'Min',UpDownLow.Position,0);
//end;
//
//{ LimitShowRev }
//
//function TLimitShowRev.GetHighValue: double;
//begin
// Result:=GetValue(UpDownLow);
//end;
//
//function TLimitShowRev.GetLowValue: double;
//begin
// Result:=GetValue(UpDownHigh);
//end;
//
//function TLimitShowRev.GetValue(UpDown: TUpDown): double;
//begin
//   Result:=(UpDown.Max-UpDown.Position)/fDivisor;
//end;
//
//function TLimitShowRev.GetValueString(UpDown: TUpDown): string;
//begin
//  Result:=FloatToStrF(-GetValue(UpDown),ffFixed, 4, fDigitNumber);
//end;
//
//
{ TIntegerParameterShow }

constructor TIntegerParameterShow.Create(STD: TStaticText; STC: TLabel;
  ParametrCaption, WT: string; InitValue: integer);
begin
  inherited Create(STD,STC,ParametrCaption,WT);
  STData.Caption:=IntToStr(InitValue);
  DefaulValue:=InitValue;
end;

constructor TIntegerParameterShow.Create(STD: TStaticText; STC: TLabel;
  ParametrCaption: string; InitValue: integer);
begin
  Create(STD,STC,ParametrCaption,ParametrCaption+WindowTextFooter,InitValue);
end;

function TIntegerParameterShow.GetData: integer;
begin
  Result:=StrToInt(STData.Caption);
end;

function TIntegerParameterShow.ReadStringValueFromIniFile(ConfigFile: TIniFile;
  NameIni: string): string;
begin
 Result:=IntToStr(ConfigFile.ReadInteger(fName,NameIni,DefaulValue));
end;

procedure TIntegerParameterShow.SetData(value: integer);
begin
  try
    STData.Caption:=IntToStr(value);
  finally

  end;
end;

procedure TIntegerParameterShow.SetDefaulValue(const Value: integer);
begin
 FDefaulValue := Value;
end;

function TIntegerParameterShow.StringToExpectedStringConvertion(str: string): string;
begin
 Result:=IntToStr(StrToInt(str));
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
//
//{ TDAC_ShowNew }
//
//constructor TDAC_Show.Create(OI: IDAC;
//                                VData, KData: TStaticText;
//                                VL, KL: TLabel;
//                                VSB, KSB, RB: TButton);
//begin
//  fOutputInterface:=OI;
//  fValueShow:=TDoubleParameterShow.Create(VData,VL,'Output value',0,5);
//  fValueShow.ForUseInShowObject(OI);
//
//  ValueSetButton:=VSB;
//  ValueSetButton.OnClick:=ValueSetButtonAction;
//  ValueSetButton.Caption:='Set value';
//  ResetButton:=RB;
//  ResetButton.OnClick:=ResetButtonClick;
//  ResetButton.Caption:='Reset';
//
//  fKodShow:=TIntegerParameterShow.Create(KData,KL,'Output code',0);
//  fKodShow.ForUseInShowObject(OI);
//
//  KodSetButton:=KSB;
//  KodSetButton.OnClick:=KodSetButtonAction;
//  KodSetButton.Caption:='Set code';
//end;
//
//
//procedure TDAC_Show.Free;
//begin
// fKodShow.Free;
// fValueShow.Free;
//end;
//
//procedure TDAC_Show.KodSetButtonAction(Sender: TObject);
//begin
//   fOutputInterface.OutputInt(fKodShow.Data);
//   fKodShow.ColorToActive(true);
//   fValueShow.ColorToActive(false);
//end;
//
//procedure TDAC_Show.ReadFromIniFile(ConfigFile: TIniFile);
//begin
//   fValueShow.ReadFromIniFile(ConfigFile);
//   fKodShow.ReadFromIniFile(ConfigFile);
//end;
//
//procedure TDAC_Show.ResetButtonClick(Sender: TObject);
//begin
// fOutputInterface.Reset();
// fKodShow.ColorToActive(false);
// fValueShow.ColorToActive(false);
//end;
//
//
//procedure TDAC_Show.ValueSetButtonAction(Sender: TObject);
//begin
// fOutputInterface.Output(fValueShow.Data);
// fValueShow.ColorToActive(true);
// fKodShow.ColorToActive(false);
//end;
//
//procedure TDAC_Show.WriteToIniFile(ConfigFile: TIniFile);
//begin
//   fValueShow.WriteToIniFile(ConfigFile);
//   fKodShow.WriteToIniFile(ConfigFile);
//end;
//
//
//{ TArduinoDACShow }
//
//constructor TArduinoDACShow.Create(ArdDAC: TArduinoDAC;
//                                  PinLs: array of TPanel;
//                                  PinVariant:TStringList;
//                                  VData, KData: TStaticText;
//                                  VL, KL: TLabel;
//                                  VSB, KSB, RB: TButton);
//begin
// inherited Create(ArdDAC,PinLs,PinVariant);
// fDAC_Show:=TDAC_Show.Create(ArdDAC,VData, KData,VL, KL, VSB, KSB, RB);
//end;
//
//procedure TArduinoDACShow.Free;
//begin
// fDAC_Show.Free;
// inherited Free;
//end;
//
//procedure TArduinoDACShow.ReadFromIniFile(ConfigFile: TIniFile);
//begin
//  inherited ReadFromIniFile(ConfigFile);
//  fDAC_Show.ReadFromIniFile(ConfigFile);
//end;
//
//procedure TArduinoDACShow.WriteToIniFile(ConfigFile: TIniFile);
//begin
//  inherited WriteToIniFile(ConfigFile);
//  fDAC_Show.WriteToIniFile(ConfigFile);
//end;
//
//
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

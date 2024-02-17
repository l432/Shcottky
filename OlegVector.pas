unit OlegVector;


interface
 uses IniFiles,SysUtils, StdCtrls,OlegType, Series,
    Graphics, TeEngine;


type

    TFunVector=Function(Coord: TCoord_type): Double of object;
    TFunVectorInt=Function(Coord: TCoord_type): Integer of object;
    TFunVectorPointBool=Function(PointNumber:integer;NumberForCondition:double): boolean of object;

    TVector=class
     private
      Points:array of TPointDouble;
      fName:string;
      fT:Extended;
      ftime:string;
      fSegmentBegin: Integer;
      function GetData(const Number: Integer; Index:Integer): double;
      function GetN: Integer;
      procedure SetT(const Value: Extended);
      procedure SetData(const Number: Integer; Index: Integer;
                        const Value: double);
      function PointGet(Number:integer):TPointDouble;
      procedure PointSwap(Number1,Number2:integer);
      procedure PointCoordSwap(var Point:TPointDouble);
      function PoinToString(Point:TPointDouble;NumberDigit:Byte=4):string;overload;
      function IsEmptyGet: boolean;
      procedure ReadTextFile(const F: Text);
      function CoordToString(Coord:TCoord_type):string;
      function Stat(Coord:TCoord_type;FunVector:TFunVector;minPointNumber:Integer=1):double;overload;
      function Stat(Coord:TCoord_type;FunVector:TFunVectorInt;minPointNumber:Integer=1):integer;overload;
      function MaxValue(Coord:TCoord_type):double;
      function MinValue(Coord:TCoord_type):double;
      function NumberNegative(Coord:TCoord_type):integer;
      function NumberPositive(Coord:TCoord_type):integer;
      function NumberZero(Coord:TCoord_type):integer;
      function Sum(Coord:TCoord_type):double;
      function StandartDeviation(Coord:TCoord_type):double;
      function StandartDeviationN(Coord:TCoord_type):double;
      function SqrDeviation(Coord:TCoord_type):double;
      function Value (Coord: TCoord_type; CoordValue: Double):double;
      function ValueXY (Coord: TCoord_type; CoordValue: Double;i,j:integer):double;
      function GetInformation(const Index: Integer): double;
      function GetInformationInt(const Index: Integer): integer;
      function GetQuartile(const Index: Integer):double;
      function GetQLimit(const Index: Integer):double;
      function GetMSE():double;
      function GetMRE():double;
      function GetR():double;
      function GetR2():double;
      function GetInt_Trap: double;
      function GetHigh: Integer;
      function GetSegmentEnd: Integer;
      procedure DeletePointsByCondition(FunVPB:TFunVectorPointBool;NumberForCondition:double=0);
      function  FunVPBDeleteErResult(i:integer;NumberForCondition:double=0):boolean;
      function  FunVPBDeleteZeroY(i:integer;NumberForCondition:double=0):boolean;
      function  FunVPBDeleteXMoreTnanNumber(PointNumber:integer;NumberForCondition:double=0):boolean;
     protected
      procedure PointSet(Number:integer; x,y:double);overload;
       {заповнює координати точки з номером Number,
       але наявність цієї точки в масиві не перевіряється}
      procedure PointSet(Number:integer; Point:TPointDouble);overload;

     public


      property X[const Number: Integer]: double Index ord(cX)
                        read GetData write SetData;
      property Y[const Number: Integer]: double Index ord(cY)
                        read GetData write SetData;
      property Point[Index:Integer]:TPointDouble read PointGet;default;
      property Count:Integer read GetN;
      {кількість точок,
      в масивaх нумерація від 0 до Count-1}
      property HighNumber:Integer read GetHigh;
      property name:string read fName write fName;
      {назва файлу, звідки завантажені дані}
      property T:Extended read fT write SetT;
      {температура, що відповідає цим даним}
      property time:string read ftime write ftime;
      {час створення файлу - година:хвилини
                           - секунди з початку доби}

      property N_begin:Integer read  fSegmentBegin write fSegmentBegin;
     {номер точки з вихідного вектора, яка відповідає
      початковій у цьому}
      property N_end:Integer read  GetSegmentEnd;
      property IsEmpty:boolean read IsEmptyGet;
      property MaxX:double Index 1 read GetInformation;
      {повертається найбільше значення з масиву X}
      property MaxY:double Index 2 read GetInformation;
      property MinX:double Index 3 read GetInformation;
       {повертається найменше значення з масиву Х}
      property MinY:double Index 4 read GetInformation;
      property SumX:double Index 5 read GetInformation;
      property SumY:double Index 6 read GetInformation;
         {повертаються суми елементів масивів X та Y відповідно}
      property NegativeInX:integer Index 5 read GetInformationInt;
         {кількість від'ємних елементів в масиві X}
      property NegativeInY:integer Index 6 read GetInformationInt;
      property PositiveInX:integer Index 7 read GetInformationInt;
      property PositiveInY:integer Index 8 read GetInformationInt;
      property ZeroInX:integer Index 9 read GetInformationInt;
      property ZeroInY:integer Index 10 read GetInformationInt;
      property MeanX:double Index 7 read GetInformation;
         {повертає середнє арифметичне значень в масиві X}
      property MeanY:double Index 8 read GetInformation;
         {повертає середнє арифметичне значень в масиві Y}
      property StandartDeviationX:double Index 9 read GetInformation;
      property StandartDeviationY:double Index 10 read GetInformation;
         {повертає стандартне відхилення значень в масиві Y
         SD=(sum[(yi-<y>)^2]/(n-1))^0.5}
      property StandartDeviationNX:double Index 13 read GetInformation;
      property StandartDeviationNY:double Index 14 read GetInformation;
         {повертає стандартне відхилення значень в масиві Y
         SD=(sum[(yi-<y>)^2]/n)^0.5}
      property StandartErrorX:double Index 11 read GetInformation;
      property StandartErrorY:double Index 12 read GetInformation;
         {повертає стандартну похибку значень в масиві Y
         SЕ=SD/n^0.5}
      property MaxXnumber:integer Index 1 read GetInformationInt;
      {повертається порядковий номер найбільшого значення з масиву X}
      property MaxYnumber:integer Index 2 read GetInformationInt;
      property MinXnumber:integer Index 3 read GetInformationInt;
      property MinYnumber:integer Index 4 read GetInformationInt;
      property Int_Trap:double read GetInt_Trap;
        {повертає результат інтегрування за методом
        трапецій;  вважається, що межі інтегралу простягаються на
        весь діапазон зміни А^.X}
      property Median:double Index 1 read GetQuartile;
      {повертає медіанне значення в масиві Y}
      property Q1:double Index 0 read GetQuartile;
      {повертає квантиль 0,25 в масиві Y}
      property Q3:double Index 2 read GetQuartile;
      {повертає квантиль 0,75 в масиві Y}
      property Q2:double Index 1 read GetQuartile;
      {повертає квантиль 0,5 в масиві Y}
      property IQR:double Index 3 read GetQuartile;
      {міжквартильний розмах в масиві Y}
      property LowQLimit:double Index 1 read GetQLimit;
      {значення, яке відповідає нижнім вусам на коробковому графіку}
      property HighQLimit:double Index 2 read GetQLimit;
      {значення, яке відповідає верхнім  вусам на коробковому графіку}
      property MSE:double read GetMSE;
      {повертає Mean Squared Error між значеннями в масивах Х та Y
      MSE=sum[(xi-yi)^2]/n}
      property MRE:double read GetMRE;
      {повертає Mean Relative Error між значеннями в масивах Х та Y
      MRE=sum[abs(xi-yi)/xi]/n}
      property Rcorrelation:double read GetR;
      {повертає кореляцію між значеннями в масивах Х та Y,
      R=sum[(xi-<x>)(yi-<y>)]/(sum[(xi-<x>)^2]*sum[(yi-<y>)^2])^0.5}
      property R2determination:double read GetR2;
      {повертає коефіцієнт детермінації, за припущення що масив Х
      це точні значення, а масив Y їхня оцінка,
      R2=1-sum[(xi-yi)^2]/sum[(xi-<x>)^2]}

      Constructor Create;overload;
      Constructor Create(ExternalVector:TVector);overload;

      procedure SetLenVector(Number:integer);
      procedure Clear();
         {просто зануляється кількість точок, інших операцій не проводиться}
      procedure ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
      procedure WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
      procedure ReadFromFile (NameFile:string);overload;
      {читає дані з файлу з коротким ім'ям sfile
       з файлу comments в тій самій директорії
       зчитується значення температури в a.T}
      procedure ReadFromFile(NameFile:string;ColumnNumbers:array of byte;XisSequenceNumber:boolean=False);overload;
      {читає з файлу, у якому дані розташовані в колонках;
      зчитуються дані з колонок, номери яких в ColumnNumbers, вважається, що
      колонки нумеруються з одиниці;
      ті рядки файлу, які не містять достатньої кількості колонок просто пропускаються;
      якщо XisSequenceNumber=True, то в Х буде порядковий номер (починаючи з 1);
      залежно від кількості цифр в ColumnNumbers буде
      0 - в Х з першої колонки, в Y з другої (XisSequenceNumber=False)
          в Х - номер, в Y з першої (XisSequenceNumber=True)
      1 - в Х з першої колонки, в Y з колонки, номер якої присутній (XisSequenceNumber=False)
          в Х - номер, в Y з колонки, номер якої присутній (XisSequenceNumber=True)
      2 і більше - в Х з колонки, номер якої першим стоїть в масиві, в Y з колонки,
                   номер якої стоїть другим (XisSequenceNumber=False)
                   в Х - номер, в Y з колонки, номер якої першим стоїть в масиві (XisSequenceNumber=True)
      додаткові поля залишаються порожніми}
      procedure ReadFromFile(NameFile:string;ColumnNames:array of string;XisSequenceNumber:boolean=False);overload;
      {подібне до попереднього, але зчитуються дані з колонок,
      назви яких в ColumnNames;
      якщо колонки з якоюсь назвою немає у файлі, то вважається,
      що така назва просто відсутня в ColumnNames}
      procedure WriteToFile(NameFile:string=''; NumberDigit:Byte=4;
                           Header:string='');
      {записує у файл з іменем sfile дані;
      якщо .Count=0, то запис у файл не відбувається;
      NumberDigit - кількість значущих цифр}
      procedure ReadFromGraph(Series:TCustomSeries);
      procedure WriteToGraph(Series:TChartSeries;Const ALabel: String=''; AColor: TColor=clRed);
      procedure CopyTo (TargetVector:TVector);
       {копіюються поля з даного вектора в
        уже раніше створений TargetVector}
      procedure CopyFrom (const SourceVector:TVector);
      {копіюються поля з SourceVector в даний}
      procedure Add(newX,newY:double);overload;
      procedure Add(newXY:double);overload;
      procedure Add(newPoint:TPointDouble);overload;
      procedure DeletePoint(NumberToDelete:integer);
         {видання з масиву точки з номером NumberToDelete}
      procedure DeleteNfirst(Nfirst:integer);
         {видаляє з масиву Nfirst перших точок}
      procedure Sorting (Increase:boolean=True);
         {процедура сортування (методом бульбашки)
          точок по зростанню (при Increase=True) компоненти Х}
      procedure DeleteDuplicate;
         {видаляються точки, для яких значення абсциси вже зустрічалося}
      procedure DeleteErResult;
         {видаляються точки, для яких абсциса чи ордината рівна ErResult}
      Procedure DeleteZeroY;
         {видаляються точки, для яких ордината рівна 0}
      Procedure DeleteXMoreTnanNumber(Number:double);
        {видаляються точки, для яких абсциса більша ніж Number}
      procedure SwapXY;
         {обмінюються знaчення Х та Y}
      function CopyToArray(const Coord:TCoord_type):TArrSingle;
      function CopyXtoArray():TArrSingle;
         {копіюються дані з Х в массив}
      function CopyYtoArray():TArrSingle;
         {копіюються дані з Y в массив}
      function CopyXtoPArray():PTArrSingle;
         {копіюються дані з Х в вказівник на масив,
         пом'ять виділяється всередині функції}
      function CopyYtoPArray():PTArrSingle;
//         Procedure CopyYtoPArray(var TargetArray:PTArrSingle);
//         {копіюються дані з Y в массив TargetArray}
      procedure CopyFromXYArrays(SourceXArray,SourceYArray:TArrSingle);
         {заповнюються Х та Y значеннями з масивів}
      procedure CopyFromXYPArrays(SourceXArray,SourceYArray:PTArrSingle);
         {заповнюються Х та Y значеннями з масивів}
      function XtoString():string;
      function YtoString():string;
      {повертається рядок, що містить
      всі значення відповідної координати}
      function XYtoString(NumberDigit:Byte=4):string;
      function Xvalue(Yvalue:double):double;
         {повертає визначає приблизну абсцису точки з
          ординатою Yvalue}
      function Yvalue(Xvalue:double):double;
         {повертає визначає приблизну ординату точки з
          абсцисою Xvalue}
      function Krect(Xvalue:double):double;
      {обчислення коефіцієнту випрямлення при напрузі V;
      якщо точок в потрібному діапазоні немає -
      пишиться повідомлення і повертається ErResult}
      function ValueNumber (Coord: TCoord_type; CoordValue: Double):integer;
      {повертає номер точки вектора, координата якої близька до CoordValue:
      CoordValue має знаходитися на інтервалі від
      Point[Result,Coord] до Point[Result+1,Coord]
      якщо не входить в діапазон зміни - повервається -1}
      function ValueNumberPrecise (Coord: TCoord_type; CoordValue: Double):integer;
      {повертає номер першої точки вектора, координата якої
      співпадає з CoordValue з точність IsEqual:
      якщо не входить в діапазон зміни - повертається -1}

      procedure MultiplyY(const A:double);
         {Y всіх точок множиться на A}
      procedure AdditionY(const A:double);
         {до Y всіх точок додається A}
      procedure DeltaY(deltaVector:TVector);
         {від значень Y віднімаються значення deltaVector.Y;
          якщо кількості точок різні - ніяких дій не відбувається}
      Procedure Filling(Fun:TFun;Xmin,Xmax,deltaX:double;Parameters:array of double);overload;
         {Х заповнюється значеннями від Xmin до Xmax з кроком deltaX
         Y[i]=Fun(X[i],Parameters)}
      Procedure Filling(Fun: TFun; Xmin, Xmax: Double; Parameters: array of Double; Nstep: Integer=100);overload;
         {як попередня, тільки використовується не крок, а загальна
         кількість точок Nstep на заданому інтервалі}
      Procedure Filling(Fun: TFunPoint; Xmin, Xmax: Double; Nstep: Integer=100);overload;
         {як попередня, тільки використовується не крок, а загальна
         кількість точок Nstep на заданому інтервалі}
      Procedure Filling(Fun: TFunSingle; Xmin, Xmax: Double; Nstep: Integer=100);overload;
         {як попередня, тільки використовується не крок, а загальна
         кількість точок Nstep на заданому інтервалі}
      Procedure Filling(Fun:TFun;Xmin,Xmax,deltaX:double);overload;
      function MeanValue(Coord:TCoord_type):double;
      function MaxNumber(Coord:TCoord_type):integer;
      function MinNumber(Coord:TCoord_type):integer;
      function PoinToString(PointNumber: Integer;NumberDigit:Byte=4):string;overload;
      function PointInDiapazon(Diapazon:TDiapazon;PointNumber:integer):boolean;overload;
      {визначає, чи знаходиться точка з номером PointNumber в межах,
      що задаються в Diapazon}
      function PointInDiapazon(Lim:Limits;PointNumber:integer):boolean;overload;
      function Quartile(q:double):double;
      {повертає квантиль q в масиві Y;
      якщо точок <1 або q<0 чи >1 - Result:=ErResult}
      function PercentOfPointLessThan(q:double;ItIsLess:boolean=True;Coord:TCoord_type=cY):double;
      {повертає відсоток точок, для яких значення координати Coord менше або рівне
      (при ItIsLess=False більше або рівне) значення q}
        end;

  TArrVec=array of TVector;

  Function Kv(Argument:double;Parameters:array of double):double;

procedure VectorArrayCreate (var VectorArray:TArrVec;Number:integer);

procedure AddVectorToArray (var VectorArray:TArrVec);

procedure VectorArrayFreeAndNil (var VectorArray:TArrVec);

implementation
uses OlegMath, Classes, Dialogs, Controls, Math, OlegFunction;



Procedure TVector.SetLenVector(Number:integer);
{встановлюється кількість точок у векторі А}
begin
 SetLength(Points, Number);
end;

procedure TVector.ReadFromFile(NameFile: string);
var F:TextFile;
//    i:integer;
    ss, ss1:string;
begin
  Clear;
  Self.fName:=NameFile;
  if not(FileExists(NameFile)) then Exit;
  AssignFile(f,NameFile);
  ReadTextFile(F);
  if High(Points)<0 then
    begin
//{XP Win}
      FormatSettings.DecimalSeparator:=',';
//      DecimalSeparator:=',';
      ReadTextFile(F);
//{XP Win}
      FormatSettings.DecimalSeparator:='.';
//      DecimalSeparator:='.';
    end;
  if High(Points)<0 then Exit;

 {-------считывание температуры и времени создания, если файла
 соmments нет или там отсутствует запись
 про соответствующий файл, то значение будет нулевым}
  if FileExists('comments') then Ftime:='comments';
  if FileExists('comments.dat') then Ftime:='comments.dat';

  if Ftime<>'' then
    begin
     AssignFile(f,Ftime);
     Reset(f);
     while not(Eof(f)) do
      begin
       readln(f,ss);
       ss1:=ss;
       Delete(ss,AnsiPos(' ',ss),Length(ss)-AnsiPos(' ',ss)+1);
       if AnsiUpperCase(ss)=AnsiUpperCase(NameFile) then
         begin
          if ss1[AnsiPos(':',ss1)-1]=' '
             then Delete(ss1,1,AnsiPos(':',ss1))
             else Delete(ss1,1,AnsiPos(':',ss1)-3);
           ss1:=Trim(ss1);
           readln(f,ss);
           Delete(ss,1,2);
           Delete(ss,AnsiPos(' ',ss),Length(ss)-AnsiPos(' ',ss)+1);
           break;
         end;
      end;
     {ShowMessage(ss1);}
     Try
     fT:=StrToFloat(ss);
     Ftime:=ss1;
     Except
     fT:=0;
     Ftime:='';
     End;
      CloseFile(f);
   end;
 Sorting;
end;

procedure TVector.ReadFromFile(NameFile: string; ColumnNumbers: array of byte;
  XisSequenceNumber: boolean);
 var   Str:TStringList;
       XNum,Ynum,maxNumber:word;
       i:integer;
       x,y:double;
begin
  XNum:=0;YNum:=0;
  Clear;
  Self.fName:=NameFile;
  Str:=TStringList.Create;
  Str.LoadFromFile(NameFile);
  if High(ColumnNumbers)<0 then
     begin
       if XisSequenceNumber
          then YNum:=1
          else begin
               YNum:=2;
               XNum:=1;
               end;
     end;
  if High(ColumnNumbers)=0 then
     begin
       YNum:=ColumnNumbers[0];
       if not(XisSequenceNumber)
          then XNum:=1;
     end;
  if High(ColumnNumbers)>0 then
     begin
       if XisSequenceNumber
          then YNum:=ColumnNumbers[0]
          else begin
               YNum:=ColumnNumbers[1];
               XNum:=ColumnNumbers[0];
               end;
     end;
   maxNumber:=max(YNum,XNum);
  for I := 0 to Str.Count-1 do
    begin
     if NumberOfSubstringInRow(Str[i])<maxNumber then Continue;
     try
      if XisSequenceNumber
       then x:=Self.Count+1
       else x:=StrToFloat(StringDataFromRow(Str[i],XNum));
      y:=StrToFloat(StringDataFromRow(Str[i],YNum));
      Add(x,y);
     except
     end;
    end;
  Str.Free;
end;

procedure TVector.ReadFromFile(NameFile: string; ColumnNames: array of string;
   XisSequenceNumber: boolean);
 var   Str:TStringList;
       i:word;
       ColumnNumbers:array of byte;
       Numbers:TArrInteger;
begin
  Str:=TStringList.Create;
  Str.LoadFromFile(NameFile);
  NumberDetermine(ColumnNames,Str[0],Numbers);
  for I := 0 to High(Numbers) do
   if Numbers[i]<>0 then
       begin
         SetLength(ColumnNumbers,High(ColumnNumbers)+2);
         ColumnNumbers[High(ColumnNumbers)]:=word(Numbers[i]);
       end;
  ReadFromFile(NameFile,ColumnNumbers,XisSequenceNumber);
  Str.Free;
end;

procedure TVector.ReadFromGraph(Series: TCustomSeries);
 var i:integer;
begin
 Clear;
 SetLenVector(Series.Count);
 for I := 0 to High(Points) do
   PointSet(I,Series.XValue[i],Series.YValue[i]);
end;

procedure TVector.ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
 var i:integer;
begin
  i:=ConfigFile.ReadInteger(Section,Ident+'n',0);
  if i>0 then
    begin
      Self.SetLenVector(i);
      for I := 0 to High(Points) do
        PointSet(i,ConfigFile.ReadFloat(Section,Ident+'X'+IntToStr(i),ErResult),
                   ConfigFile.ReadFloat(Section,Ident+'Y'+IntToStr(i),ErResult));
      name:=ConfigFile.ReadString(Section,Ident+'name','');
      time:=ConfigFile.ReadString(Section,Ident+'time','');
      T:=ConfigFile.ReadFloat(Section,Ident+'T',0);
      N_begin:=ConfigFile.ReadInteger(Section,Ident+'N_begin',0);
    end
         else Clear();
end;

procedure TVector.WriteToFile(NameFile: string; NumberDigit: Byte;
                             Header:string);
 var   Str:TStringList;
       i:integer;
begin
 Str:=TStringList.Create;
 if Header<>'' then Str.Add(Header);
 for I := 0 to High(Points)
   do  Str.Add(PoinToString(Points[i],NumberDigit));
 if NameFile<>'' then Str.SaveToFile(NameFile)
                 else
                 begin
                  if Self.fName=''
                    then Str.SaveToFile('noname.dat')
                    else Str.SaveToFile(Self.fName);
                 end;
 Str.Free;
end;

procedure TVector.WriteToGraph(Series: TChartSeries;Const ALabel: String=''; AColor: TColor=clRed);
 var i:integer;
begin
 Series.Clear;
 for I := 0 to High(Points) do
   Series.AddXY(Points[i,cX],Points[i,cY],ALabel,AColor);
end;

procedure TVector.WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
var
  I: Integer;
begin
 WriteIniDef(ConfigFile,Section,Ident+'n',Count,0);
 WriteIniDef(ConfigFile,Section,Ident+'name',name);
 WriteIniDef(ConfigFile,Section,Ident+'time',time);
 WriteIniDef(ConfigFile,Section,Ident+'T',T);
 WriteIniDef(ConfigFile,Section,Ident+'N_begin',N_begin,0);
 for I := 0 to High(Points) do
  begin
   ConfigFile.WriteFloat(Section,Ident+'X'+IntToStr(i),X[i]);
   ConfigFile.WriteFloat(Section,Ident+'Y'+IntToStr(i),Y[i])
  end;
end;

function TVector.XtoString: string;
begin
 Result:=CoordToString(cX);
end;

function TVector.Xvalue(Yvalue: double): double;
begin
 Result:=Value(cY,Yvalue);
end;

function TVector.XYtoString(NumberDigit:Byte): string;
 var i:integer;
begin
 Result:='';
 for i:=0 to High(Points) do
   Result:=Result+'('+PoinToString(Points[i],NumberDigit)+')'+#10+#13;

end;

function TVector.YtoString: string;
begin
 Result:=CoordToString(cY);
end;

function TVector.Yvalue(Xvalue: double): double;
begin
 Result:=Value(cX,Xvalue);
end;

procedure TVector.Add(newX,newY:double);
begin
 Self.SetLenVector(Count+1);
 PointSet(High(Points),newX,newY);
end;

procedure TVector.DeletePoint(NumberToDelete:integer);
var
  I: Integer;
begin
 if (NumberToDelete<0)or(NumberToDelete>High(Points)) then Exit;
 for I := NumberToDelete to High(Points)-1
   do PointSet(i,PointGet(i+1));
 Self.SetLenVector(High(Points));
end;

procedure TVector.DeletePointsByCondition(FunVPB: TFunVectorPointBool;NumberForCondition:double=0);
 var i,Point:integer;
 label Start;
begin
  Point:=0;
  i:=-1;
 Start:
  if i<>-1 then
     Self.DeletePoint(i);
  for I := Point to High(Points){-1} do
    begin
      if FunVPB(i,NumberForCondition) then
            goto Start;
      Point:=I+1;
    end;
end;

procedure TVector.DeleteXMoreTnanNumber(Number: double);
begin
 DeletePointsByCondition(FunVPBDeleteXMoreTnanNumber,Number);
end;

procedure TVector.DeleteZeroY;
begin
 DeletePointsByCondition(FunVPBDeleteZeroY);
end;

procedure TVector.DeleteNfirst(Nfirst:integer);
var
  I: Integer;
begin
  if Nfirst<=0 then Exit;
  if Nfirst>High(Points) then
    begin
      Self.Clear;
      Exit;
    end;
  for I := 0 to High(Points)-Nfirst
    do PointSet(i,PointGet(i+Nfirst));
  Self.SetLenVector(Count-Nfirst);
end;

Procedure TVector.Sorting (Increase:boolean=True);
var i,j:integer;
    ChangeNeed:boolean;
begin
for I := 0 to High(Points)-1 do
  for j := 0 to High(Points)-1-i do
     begin
      if Increase then ChangeNeed:=X[j]>X[j+1]
                  else ChangeNeed:=X[j]<X[j+1];
      if ChangeNeed then  PointSwap(j,j+1);
     end;
end;

function TVector.SqrDeviation(Coord: TCoord_type): double;
 var mn:double;
     i:integer;
begin
 mn:=MeanValue(Coord);
 Result:=0;
 for I := 0 to High(Points) do
  Result:=Result+sqr(Points[i,Coord]-mn);
end;

function TVector.StandartDeviation(Coord: TCoord_type): double;
// var mn,sm:double;
//     i:integer;
begin
// mn:=MeanValue(Coord);
// sm:=0;
// for I := 0 to High(Points) do
// sm:=sm+sqr(Points[i,Coord]-mn);
// Result:=sqrt(sm/High(Points))
 Result:=sqrt(SqrDeviation(Coord)/High(Points))
end;

function TVector.StandartDeviationN(Coord: TCoord_type): double;
begin
 Result:=sqrt(SqrDeviation(Coord)/Self.Count)
end;

function TVector.Stat(Coord: TCoord_type; FunVector: TFunVectorInt;
  minPointNumber: Integer): integer;
begin
  if Count<minPointNumber
     then Result:=ErResult
     else Result:=FunVector(Coord);
end;

function TVector.Stat(Coord: TCoord_type; FunVector: TFunVector;
                         minPointNumber: Integer): double;
begin
  if Count<minPointNumber
     then Result:=ErResult
     else Result:=FunVector(Coord);
end;

function TVector.Sum(Coord: TCoord_type): double;
 var i:integer;
begin
 Result:=0;
 for I := 0 to High(Points) do
   Result:=Result+Points[i,Coord];
end;

Procedure TVector.DeleteDuplicate;
 var i,j,PointToDelete,Point:integer;
 label Start;
begin
  Point:=0;
  PointToDelete:=-1;
 Start:
  if PointToDelete<>-1 then
     Self.DeletePoint(PointToDelete);
  for I := Point to High(Points)-1 do
    begin
      for j := i+1 to High(Points) do
        if IsEqual(X[i],X[j]) then
          begin
            PointToDelete:=j;
            goto Start;
          end;
      Point:=I+1;
    end;
end;

Procedure TVector.DeleteErResult;
begin
 DeletePointsByCondition(FunVPBDeleteErResult);
end;

Procedure TVector.SwapXY;
 var i:integer;
begin
 for I := 0 to High(Points) do PointCoordSwap(Points[i]);
end;


function TVector.Value(Coord: TCoord_type; CoordValue: Double): double;
 var i,number:integer;
begin
  i:=1;
  Result:=ErResult;
//  if (High(Points)<0)
//     or(CoordValue=ErResult) then Exit;
  if (High(Points)<0) then Exit;
  repeat
   if ((Points[i,Coord]-CoordValue)*(Points[i-1,Coord]-CoordValue))<=0 then
     begin
      Result:=ValueXY(Coord,CoordValue,i,i-1);
      Exit;
     end;
   i:=i+1;
  until (i>High(Points));

  number:=0;
  if CoordValue<MinValue(Coord) then number:=MinNumber(Coord);
  if CoordValue>MaxValue(Coord) then number:=MaxNumber(Coord);
  if number<High(Points)
    then Result:=ValueXY(Coord,CoordValue,number,number+1)
    else Result:=ValueXY(Coord,CoordValue,number,number-1);
end;

function TVector.ValueNumber(Coord: TCoord_type;
  CoordValue: Double): integer;
 var i:integer;
begin
 for i:=0 to High(Points)-1 do
   if (CoordValue-Points[i,Coord])*(CoordValue-Points[i+1,Coord])<=0
    then
     begin
     Result:=i;
     Exit;
     end;
 Result:=-1;
end;

function TVector.ValueNumberPrecise(Coord: TCoord_type;
  CoordValue: Double): integer;
 var i:integer;
begin
 for i:=0 to HighNumber do
   if IsEqual(CoordValue,Points[i,Coord])
    then
     begin
     Result:=i;
     Exit;
     end;
 Result:=-1;
end;

function TVector.ValueXY(Coord: TCoord_type; CoordValue: Double;
                            i,j:integer): double;
begin
  case Coord of
    cY:Result:=X_Y0(Points[i],Points[j],CoordValue);
    cX:Result:=Y_X0(Points[i],Points[j],CoordValue);
    else Result:=ErResult;
  end;
end;


function TVector.CoordToString(Coord: TCoord_type): string;
 var i:integer;
begin
 Result:='';
 for i:=0 to High(Points) do
   Result:=Result+FloaTtoStr(Points[i,Coord])+' ';
end;

Procedure TVector.CopyTo (TargetVector:TVector);
 var i:integer;
begin
  TargetVector.SetLenVector(Self.Count);
  for I := 0 to High(Self.Points)
    do TargetVector.PointSet(I,Self.Points[i]);
  TargetVector.fT:=Self.fT;
  TargetVector.fname:=Self.fname;
  TargetVector.ftime:=Self.ftime;
  TargetVector.fSegmentBegin:=Self.fSegmentBegin;
end;

function TVector.CopyToArray(const Coord: TCoord_type): TArrSingle;
 var i:integer;
begin
 SetLength(Result,Count);
 for I := 0 to High(Points) do Result[i]:=Points[i][Coord];
end;

function TVector.CopyXtoArray():TArrSingle;
begin
 Result:=CopyToArray(cX);
end;

function TVector.CopyYtoArray():TArrSingle;
begin
 Result:=CopyToArray(cY);
end;

function TVector.CopyYtoPArray: PTArrSingle;
begin
 new(Result);
 Result^:=CopyYtoArray();
end;

constructor TVector.Create(ExternalVector: TVector);
begin
  Create();
  CopyFrom(ExternalVector);
end;

function TVector.CopyXtoPArray():PTArrSingle;
begin
 new(Result);
 Result^:=CopyXtoArray();
end;

procedure TVector.CopyFrom(const SourceVector: TVector);
begin
 SourceVector.CopyTo(Self);
end;

Procedure TVector.CopyFromXYArrays(SourceXArray,SourceYArray:TArrSingle);
 var i:integer;
begin
 Clear();
 for I := 0 to min(High(SourceXArray),High(SourceYArray)) do
   Add(SourceXArray[i],SourceYArray[i]);
end;

Procedure TVector.CopyFromXYPArrays(SourceXArray,SourceYArray:PTArrSingle);
begin
 CopyFromXYArrays(SourceXArray^,SourceYArray^);
end;

procedure TVector.ReadTextFile(const F: Text);
var
  x: Double;
  y: Double;
begin
  Reset(f);
  while not (eof(f)) do
  begin
    try
      readln(f, x, y);
      Add(x, y);
    except
    end;
  end;
  CloseFile(f);
end;

Procedure TVector.MultiplyY(const A:double);
 var i:integer;
begin
 if A=1 then Exit;
 for I := 0 to High(Points) do
  Points[i,cY]:=Points[i,cY]*A;
end;

function TVector.NumberNegative(Coord: TCoord_type): integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to High(Points) do
    if Points[i,Coord]<0 then inc(Result)
end;

function TVector.NumberPositive(Coord: TCoord_type): integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to High(Points) do
    if Points[i,Coord]>0 then inc(Result)

end;

function TVector.NumberZero(Coord: TCoord_type): integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to High(Points) do
    if Points[i,Coord]=0 then inc(Result)
end;

Procedure TVector.DeltaY(deltaVector:TVector);
 var i:integer;
begin
 if High(Self.Points)<>High(deltaVector.Points) then Exit;
 for i := 0 to High(Self.Points) do
        Y[i]:=Y[i]-deltaVector.Y[i];
end;

procedure TVector.Add(newXY: double);
begin
 self.Add(newXY,newXY);
end;

procedure TVector.Add(newPoint: TPointDouble);
begin
 Self.SetLenVector(Count+1);
 PointSet(High(Points),newPoint);
end;

procedure TVector.AdditionY(const A: double);
 var i:integer;
begin
 if A=0 then Exit;
 for I := 0 to High(Points) do
  Points[i,cY]:=Points[i,cY]+A;
end;

Procedure TVector.Clear();
begin
  SetLenVector(0);
  Fname:='';
  Ftime:='';
  fT:=0;
  fSegmentBegin:=0;
end;

Procedure TVector.Filling(Fun:TFun;Xmin,Xmax,
           deltaX:double;Parameters:array of double);
 const Nmax=10000;
 var i:integer;
     argument:double;
begin
 i:=0;
 argument:=Xmin;
 repeat
   inc(i);
   argument:=argument+deltaX;
 until (argument>Xmax)or(i>Nmax);
 if (i>Nmax) then
   begin
     Clear();
     Exit;
   end;
 SetLenVector(i);
 for I := 0 to High(Points) do
  begin
    X[i]:=Xmin+i*deltaX;
    Y[i]:=Fun(X[i],Parameters);
  end;
end;

Procedure TVector.Filling(Fun: TFun; Xmin, Xmax: Double;
      Parameters: array of Double; Nstep: Integer);
begin
  if Nstep<1 then Clear()
    else if Nstep=1 then Filling(Fun,Xmin,Xmax,Xmax-Xmin+1,Parameters)
       else Filling(Fun,Xmin,Xmax,(Xmax-Xmin)/(Nstep-1),Parameters)
end;

Procedure TVector.Filling(Fun:TFun;Xmin,Xmax,deltaX:double);
begin
 Filling(Fun,Xmin,Xmax,deltaX,[]);
end;


procedure TVector.Filling(Fun: TFunSingle; Xmin, Xmax: Double; Nstep: Integer);
 const Nmax=10000;
 var i:integer;
     deltaX:double;
begin
 if (Nstep<1)or(Nstep>Nmax) then
    begin
    Clear();
    Exit;
    end;
 if Nstep=1 then
    begin
    SetLenVector(2);
    Add(Xmin,Fun(Xmin));
    Add(Xmax,Fun(Xmax));
    Exit;
    end;
 deltaX:=(Xmax-Xmin)/(Nstep-1);
 SetLenVector(Nstep);
 for I := 0 to High(Points) do
  begin
    X[i]:=Xmin+i*deltaX;
    Y[i]:=Fun(X[i]);
  end;
end;

procedure TVector.Filling(Fun: TFunPoint; Xmin, Xmax: Double;
                           Nstep: Integer);
 const Nmax=10000;
 var i:integer;
     deltaX:double;
begin
 if (Nstep<1)or(Nstep>Nmax) then
    begin
    Clear();
    Exit;
    end;
 if Nstep=1 then
    begin
    SetLenVector(2);
    PointSet(0,Fun(Xmin));
    PointSet(1,Fun(Xmax));
    Exit;
    end;
 deltaX:=(Xmax-Xmin)/(Nstep-1);
 SetLenVector(Nstep);
 for I := 0 to High(Points)
   do PointSet(i,Fun(Xmin+i*deltaX));
end;

function TVector.FunVPBDeleteErResult(i: integer;NumberForCondition:double=0): boolean;
begin
 Result:=(Points[i][cX]=ErResult)or(Points[i][cY]=ErResult);
end;

function TVector.FunVPBDeleteXMoreTnanNumber(PointNumber: integer;
  NumberForCondition: double): boolean;
begin
 Result:=(Points[PointNumber][cX]>NumberForCondition);
// if Result then showmessage(floattostr(Points[PointNumber][cX])+' '+floattostr(NumberForCondition));

end;

function TVector.FunVPBDeleteZeroY(i: integer;NumberForCondition:double=0): boolean;
begin
 Result:=(Points[i][cY]=0);
end;

{ Vector }

constructor TVector.Create;
begin
 inherited;
 Clear();
end;

function TVector.GetData(const Number: Integer; Index:Integer): double;
begin
 if Number>High(Points)
    then Result:=ErResult
    else Result:=Points[Number][TCoord_type(Index)];
end;

function TVector.GetHigh: Integer;
begin
  Result:=High(Points);
end;

function TVector.GetInformation(const Index: Integer): double;
begin
 case Index of
  1:Result:=Stat(cX,Self.MaxValue);
  2:Result:=Stat(cY,Self.MaxValue);
  3:Result:=Stat(cX,Self.MinValue);
  4:Result:=Stat(cY,Self.MinValue);
  5:Result:=Stat(cX,Self.Sum);
  6:Result:=Stat(cY,Self.Sum);
  7:Result:=Stat(cX,Self.MeanValue);
  8:Result:=Stat(cY,Self.MeanValue);
  9:Result:=Stat(cX,Self.StandartDeviation,2);
  10:Result:=Stat(cY,Self.StandartDeviation,2);
  11:Result:=Stat(cX,Self.StandartDeviation,2)/sqrt(Count);
  12:Result:=Stat(cY,Self.StandartDeviation,2)/sqrt(Count);
  13:Result:=Stat(cX,Self.StandartDeviationN);
  14:Result:=Stat(cY,Self.StandartDeviationN);
  else Result:=ErResult;
 end;
end;

function TVector.GetInformationInt(const Index: Integer): Integer;
begin
 case Index of
  1:Result:=Stat(cX,Self.MaxNumber);
  2:Result:=Stat(cY,Self.MaxNumber);
  3:Result:=Stat(cX,Self.MinNumber);
  4:Result:=Stat(cY,Self.MinNumber);
  5:Result:=Stat(cX,Self.NumberNegative);
  6:Result:=Stat(cY,Self.NumberNegative);
  7:Result:=Stat(cX,Self.NumberPositive);
  8:Result:=Stat(cY,Self.NumberPositive);
  9:Result:=Stat(cX,Self.NumberZero);
  10:Result:=Stat(cY,Self.NumberZero);
  else Result:=ErResult;
 end;
end;

function TVector.GetInt_Trap: double;
 var i:integer;
begin
  Result:=0;
  for I := 1 to High(Points) do
     Result:=Result+(X[i]-X[i-1])*(Y[i]+Y[i-1]);
  Result:=Result/2;
end;

function TVector.GetMRE: double;
 var i:integer;
begin
  Result:=0;
  if Self.Count<1 then Exit;
  for I := 0 to High(Points) do
     Result:=Result+RelativeDifference(X[i],Y[i]);
  Result:=Result/Self.Count;
end;

function TVector.GetMSE: double;
 var i:integer;
begin
  Result:=0;
  if Self.Count<1 then Exit;
  for I := 0 to High(Points) do
     Result:=Result+sqr(X[i]-Y[i]);
  Result:=Result/Self.Count;
end;

function TVector.GetQLimit(const Index: Integer): double;
 var tempVector:TVector;
     Q1,Q3,LimitValue:double;
     j:integer;
begin
  if (Self.Count=0) then Exit(ErResult);

  tempVector.Create(Self);
  tempVector.SwapXY;
  tempVector.Sorting();
  Q1:=(tempVector.X[max(0,floor(Count*0.25)-1)]
           +tempVector.X[max(0,ceil(Count*0.25)-1)])/2;
  Q3:=(tempVector.X[max(0,floor(Count*0.75)-1)]
           +tempVector.X[max(0,ceil(Count*0.75)-1)])/2;
  case Index of
   1:begin
      LimitValue:=Q1-1.5*(Q3-Q1);
      for j := 0 to HighNumber do
        if tempVector.X[j]>LimitValue then
          begin
            Result:=tempVector.X[j];
            Break;
          end;
     end;
   2:begin
      LimitValue:=Q3+1.5*(Q3-Q1);
      for j := HighNumber to 0 do
        if tempVector.X[j]<LimitValue then
          begin
            Result:=tempVector.X[j];
            Break;
          end;
     end;
    else Result:=ErResult;
  end;
  FreeAndNil(tempVector);
end;

function TVector.GetN: Integer;
begin
 Result:=High(Points)+1;
end;


function TVector.GetQuartile(const Index: Integer): double;
begin
 case Index of
  0:Result:=Quartile(0.25);
  1:Result:=Quartile(0.5);
  2:Result:=Quartile(0.75);
  3:Result:=Quartile(0.75)-Quartile(0.25);
  else Result:=ErResult;
 end;
end;

function TVector.GetR: double;
 var mnX,mnY,Sx,Sy:double;
     i:integer;
begin
  mnX:=MeanValue(cX);
  mnY:=MeanValue(cY);
  Sx:=SqrDeviation(cX);
  Sy:=SqrDeviation(cY);
  if (Sx=0)or(Sy=0) then Exit(ErResult);

  Result:=0;
  for I := 0 to High(Points) do
   Result:=Result+(X[i]-mnX)*(Y[i]-mnY);
  Result:=Result/sqrt(Sx*Sy);
end;

function TVector.GetR2: double;
 var Sx:double;
begin
 Sx:=SqrDeviation(cX);
 if Sx=0 then Exit(ErResult);
 Result:=1-Self.MSE*Self.Count/Sx;
end;

function TVector.GetSegmentEnd: Integer;
begin
  Result:=fSegmentBegin+HighNumber;
end;

function TVector.IsEmptyGet: boolean;
begin
 Result:=(High(Points)<0);
end;

function TVector.Krect(Xvalue: double): double;
  var temp1, temp2:double;
begin
   Result:=ErResult;
   temp1:=Yvalue(Xvalue);
   temp2:=Yvalue(-Xvalue);
   if (temp1=ErResult)or(temp2=ErResult) then Exit;
   if (temp2<>0) then Result:=abs(temp1/temp2);
end;

function TVector.MaxNumber(Coord: TCoord_type): integer;
var
  I: Integer;
  tempmax:double;
begin
  Result := 0;
  tempmax := Points[0,Coord];
  for I := 1 to High(Points) do
    if tempmax < Points[i,Coord] then
       begin
         Result:=i;
         tempmax := Points[i,Coord];
       end;
end;

function TVector.MaxValue(Coord: TCoord_type): double;
var
  I: Integer;
begin
  Result := Points[0,Coord];
  for I := 1 to High(Points) do
    if Result < Points[i,Coord] then
      Result := Points[i,Coord];
end;

function TVector.MeanValue(Coord: TCoord_type): double;
begin
 Result:=Sum(Coord)/Count;
end;

function TVector.MinNumber(Coord: TCoord_type): integer;
var
  I: Integer;
  tempmin:double;
begin
  Result := 0;
  tempmin := Points[0,Coord];
  for I := 1 to High(Points) do
    if tempmin > Points[i,Coord] then
       begin
         Result:=i;
         tempmin := Points[i,Coord];
       end;
end;

function TVector.MinValue(Coord: TCoord_type): double;
var
  I: Integer;
begin
  Result := Points[0,Coord];
  for I := 1 to High(Points) do
    if Result > Points[i,Coord] then
      Result := Points[i,Coord];
end;

function TVector.PercentOfPointLessThan(q: double; ItIsLess: boolean;
  Coord: TCoord_type): double;
  var i:integer;
      count:integer;
begin
 if (Self.Count=0)
    then Exit(100);
 count:=0;
 for I := 0 to Self.HighNumber do
   if ItIsLess then
     begin
       if Points[i,Coord]<=q then inc(count);
     end       else
       if Points[i,Coord]>=q then inc(count);
  Result:=count*100/Self.Count;

end;

procedure TVector.PointCoordSwap(var Point: TPointDouble);
begin
 Swap(Point[cX],Point[cY]);
end;

function TVector.PointGet(Number: integer): TPointDouble;
begin
 Result[cX]:=Points[Number,cX];
 Result[cY]:=Points[Number,cY];
end;

function TVector.PointInDiapazon(Lim: Limits; PointNumber: integer): boolean;
begin
// if PointNumber>HighNumber then
//   begin
//     Result:=False;
//     Exit;
//   end;
 try
 Result:=Lim.PoinValide(Self[PointNumber]);
 except
 Result:=False;
 end;
end;

function TVector.PointInDiapazon(Diapazon: TDiapazon; PointNumber: integer): boolean;
begin
 Result:=Diapazon.PoinValide(Self[PointNumber]);
end;

function TVector.PoinToString(PointNumber: Integer;
         NumberDigit: Byte): string;
begin
  Result:=PoinToString(Self[PointNumber],NumberDigit);
end;

function TVector.PoinToString(Point: TPointDouble; NumberDigit: Byte): string;
begin
 Result:=FloatToStrF(Point[cX],ffExponent,NumberDigit,0)+' '+
         FloatToStrF(Point[cY],ffExponent,NumberDigit,0);
end;

procedure TVector.PointSet(Number: integer; Point: TPointDouble);
begin
 try
  Points[Number,cX]:=Point[cX];
  Points[Number,cY]:=Point[cY];
 except
 end;
end;

procedure TVector.PointSwap(Number1, Number2: integer);
 var tempPoint:TPointDouble;
begin
 try
  tempPoint:=PointGet(Number1);
  PointSet(Number1,PointGet(Number2));
  PointSet(Number2,tempPoint);
 except
 end;
end;

function TVector.Quartile(q: double): double;
 var tempVector:TVector;
begin
 if (Self.Count=0)
    or(q<0)or(q>1) then Exit(ErResult);
  tempVector:=TVector.Create(Self);
  tempVector.SwapXY;
  tempVector.Sorting();
  Result:=(tempVector.X[max(0,floor(Count*q)-1)]
           +tempVector.X[max(0,ceil(Count*q)-1)])/2;
  FreeAndNil(tempVector);
end;

procedure TVector.PointSet(Number: integer; x, y: double);
begin
 try
  Points[Number,cX]:=x;
  Points[Number,cY]:=y;
 except
 end;
end;

procedure TVector.SetData(const Number: Integer;
                            Index: Integer; const Value: double);
begin
 if Number>High(Points)
    then Exit
    else Points[Number][TCoord_type(Index)]:=Value;
end;


procedure TVector.SetT(const Value: Extended);
begin
  if Value>0 then fT := Value
             else fT:=0;
end;

  Function Kv(Argument:double;Parameters:array of double):double;
  var i:integer;
  begin
    Result:=0;
    if High(Parameters)<0
      then Result:=Argument*Argument
      else
        begin
          for i:=0 to High(Parameters) do
           result:=Result+Parameters[i]*Power(Argument,i)
        end;
  end;


procedure VectorArrayCreate (var VectorArray:TArrVec;Number:integer);
 var i:integer;
begin
  SetLength(VectorArray,Number);
  for I := 0 to High(VectorArray) do
    VectorArray[i]:=TVector.Create;
end;

procedure AddVectorToArray (var VectorArray:TArrVec);
begin
 SetLength(VectorArray,High(VectorArray)+2);
 VectorArray[High(VectorArray)]:=TVector.Create;
end;

procedure VectorArrayFreeAndNil (var VectorArray:TArrVec);
 var i:integer;
begin
  for I := 0 to High(VectorArray) do
    FreeAndNil(VectorArray[i]);
  SetLength(VectorArray,0);
end;

end.

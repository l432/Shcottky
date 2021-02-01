unit OlegVector;


interface
 uses IniFiles,SysUtils, StdCtrls,OlegType, Series,
    Graphics, TeEngine;


type

    TFunVector=Function(Coord: TCoord_type): Double of object;
    TFunVectorInt=Function(Coord: TCoord_type): Integer of object;
    TFunVectorPointBool=Function(i:integer): boolean of object;

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
      function Sum(Coord:TCoord_type):double;
      function StandartDeviation(Coord:TCoord_type):double;
      function Value (Coord: TCoord_type; CoordValue: Double):double;
      function ValueXY (Coord: TCoord_type; CoordValue: Double;i,j:integer):double;
      function GetInformation(const Index: Integer): double;
      function GetInformationInt(const Index: Integer): integer;
      function GetInt_Trap: double;
      function GetHigh: Integer;
      function GetSegmentEnd: Integer;
      procedure DeletePointsByCondition(FunVPB:TFunVectorPointBool);
      function  FunVPBDeleteErResult(i:integer):boolean;
      function  FunVPBDeleteZeroY(i:integer):boolean;
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
      в масивaх нумерація від 0 до n-1}
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
      property MeanX:double Index 7 read GetInformation;
         {повертає середнє арифметичне значень в масиві X}
      property MeanY:double Index 8 read GetInformation;
         {повертає середнє арифметичне значень в масиві Y}
      property StandartDeviationX:double Index 9 read GetInformation;
      property StandartDeviationY:double Index 10 read GetInformation;
         {повертає стандартне відхилення значень в масиві Y
         SD=(sum[(yi-<y>)^2]/(n-1))^0.5}
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

      Constructor Create;overload;
      Constructor Create(ExternalVector:TVector);overload;

      procedure SetLenVector(Number:integer);
      procedure Clear();
         {просто зануляється кількість точок, інших операцій не проводиться}
      procedure ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
      procedure WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
      procedure ReadFromFile (NameFile:string);
      {читає дані з файлу з коротким ім'ям sfile
       з файлу comments в тій самій директорії
       зчитується значення температури в a.T}
      procedure WriteToFile(NameFile:string; NumberDigit:Byte=4;
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
      function XYtoString():string;
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
      якщо не входить в діапазон зміни - повервається -1}

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
        end;

  Function Kv(Argument:double;Parameters:array of double):double;


implementation
uses OlegMath, Classes, Dialogs, Controls, Math;



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
      FormatSettings.DecimalSeparator:=',';
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
 Str.SaveToFile(NameFile);
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

function TVector.XYtoString: string;
 var i:integer;
begin
 Result:='';
 for i:=0 to High(Points) do
   Result:=Result+'('+PoinToString(Points[i])+')'+#10+#13;

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

procedure TVector.DeletePointsByCondition(FunVPB: TFunVectorPointBool);
 var i,Point:integer;
 label Start;
begin
  Point:=0;
  i:=-1;
 Start:
  if i<>-1 then
     Self.DeletePoint(i);
  for I := Point to High(Points)-1 do
    begin
      if FunVPB(i) then
            goto Start;
      Point:=I+1;
    end;
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

function TVector.StandartDeviation(Coord: TCoord_type): double;
 var mn,sm:double;
     i:integer;
begin
 mn:=MeanValue(Coord);
 sm:=0;
 for I := 0 to High(Points) do
 sm:=sm+sqr(Points[i,Coord]-mn);
 Result:=sqrt(sm/High(Points))
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
  if (High(Points)<0)
     or(CoordValue=ErResult) then Exit;
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

function TVector.FunVPBDeleteErResult(i: integer): boolean;
begin
 Result:=(Points[i][cX]=ErResult)or(Points[i][cY]=ErResult);
end;

function TVector.FunVPBDeleteZeroY(i: integer): boolean;
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

function TVector.GetN: Integer;
begin
 Result:=High(Points)+1;
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

end.

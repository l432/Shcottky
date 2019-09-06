unit OlegVectorNew;


interface
 uses IniFiles,SysUtils, StdCtrls,OlegTypeNew, Series;


type

//    Point=record
//         X:double;
//         Y:double;
//    end;

//    TCoord_type=(cX,cY);
//
//    TPoint=array[TCoord_type]of double;

TFunVector=Function(Coord: TCoord_type): Double of object;
TFunVectorInt=Function(Coord: TCoord_type): Integer of object;

    TVectorNew=class
     private
      Points:array of TPointDouble;
      fName:string;
      fT:Extended;
      ftime:string;
      fSegmentBegin: Cardinal;
      function GetData(const Number: Integer; Index:Integer): double;
      function GetN: Integer;
      procedure SetT(const Value: Extended);
      procedure SetData(const Number: Integer; Index: Integer;
                        const Value: double);
      procedure PointSet(Number:integer; x,y:double);overload;
       {заповнює координати точки з номером Number,
       але наявність цієї точки в масиві не перевіряється}
      procedure PointSet(Number:integer; Point:TPointDouble);overload;
      function PointGet(Number:integer):TPointDouble;
      procedure PointSwap(Number1,Number2:integer);
      procedure PointCoordSwap(Point:TPointDouble);
      function PoinToString(Point:TPointDouble;NumberDigit:Byte=4):string;
      function IsEmptyGet: boolean;
      procedure ReadTextFile(const F: Text);
      function CoordToString(Coord:TCoord_type):string;
      function Stat(Coord:TCoord_type;FunVector:TFunVector;minPointNumber:Integer=1):double;overload;
      function Stat(Coord:TCoord_type;FunVector:TFunVectorInt;minPointNumber:Integer=1):integer;overload;
      function MaxValue(Coord:TCoord_type):double;
      function MinValue(Coord:TCoord_type):double;
      function MaxNumber(Coord:TCoord_type):integer;
      function MinNumber(Coord:TCoord_type):integer;
      function Sum(Coord:TCoord_type):double;
      function MeanValue(Coord:TCoord_type):double;
      function StandartDeviation(Coord:TCoord_type):double;
      function Value (Coord: TCoord_type; CoordValue: Double):double;
      function ValueXY (Coord: TCoord_type; CoordValue: Double;i,j:integer):double;
      function GetInformation(const Index: Integer): double;
      function GetInformationInt(const Index: Integer): double;
     public


      property X[const Number: Integer]: double Index ord(cX)
                        read GetData write SetData;
      property Y[const Number: Integer]: double Index ord(cY)
                        read GetData write SetData;
      property Point[Index:Integer]:TPointDouble read PointGet;default;
      property Count:Integer read GetN;
      {кількість точок,
      в масивaх нумерація від 0 до n-1}
      property name:string read fName write fName;
      {назва файлу, звідки завантажені дані}
      property T:Extended read fT write SetT;
      {температура, що відповідає цим даним}
      property time:string read ftime write ftime;
      {час створення файлу - година:хвилини
                           - секунди з початку доби}

      property N_begin:Cardinal read  fSegmentBegin write fSegmentBegin;
     {номер точки з вихідного вектора, яка відповідає
      початковій у цьому}
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
      property MaxXnumber:double Index 1 read GetInformationInt;
      {повертається порядковий номер найбільшого значення з масиву X}
      property MaxYnumber:double Index 2 read GetInformationInt;
      property MinXnumber:double Index 3 read GetInformationInt;
       {повертається найменше значення з масиву Х}
      property MinYnumber:double Index 4 read GetInformationInt;



      Constructor Create;

      procedure SetLenVector(Number:integer);
      procedure Clear();
         {просто зануляється кількість точок, інших операцій не проводиться}
      procedure ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
      procedure WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
      procedure ReadFromFile (NameFile:string);
      {читає дані з файлу з коротким ім'ям sfile
       з файлу comments в тій самій директорії
       зчитується значення температури в a.T}
      procedure WriteToFile(NameFile:string; NumberDigit:Byte=4);
      {записує у файл з іменем sfile дані;
      якщо .Count=0, то запис у файл не відбувається;
      NumberDigit - кількість значущих цифр}
      procedure ReadFromGraph(Series:TCustomSeries);
      procedure WriteToGraph(Series:TCustomSeries);
      procedure Copy (TargetVector:TVectorNew);
       {копіюються поля з даного вектора в
        уже раніше створений TargetVector}

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
         {видаляються точки, для абсциса чи ордината рівна ErResult}
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
          ординатою Xvalue}


//         Procedure CopyLimitedX (var Target:VectorNew;Xmin,Xmax:double);
//         {копіюються з даного вектора в Target
//         - точки, для яких ордината в діапазоні від Xmin до Xmax включно
//         - поля Т та name}

//         Procedure MultiplyY(const A:double);
//         {Y всіх точок множиться на A}
//         Procedure PositiveX(var Target:VectorNew);
//         {заносить в Target ті точки, для яких X більше або рівне нулю;
//         окрім X, Y та n ніякі інші поля Target не змінюються}
//         Procedure PositiveY(var Target:VectorNew);
//         {заносить в Target ті точки, для яких Y більше або рівне нулю;
//         окрім X, Y та n ніякі інші поля Target не змінюються}
//         Procedure AbsX(var Target:VectorNew);
//         {заносить в Target точки, для яких X дорівнює модулю Х даного
//         вектора, а Y таке саме; якщо Х=0, то точка викидається;
//         окрім X, Y та n ніякі інші поля Target не змінюються}
//         Procedure AbsY(var Target:VectorNew);
//         {заносить в Target точки, для яких Y дорівнює модулю Y даного
//         вектора, а X таке саме; якщо Y=0, то точка викидається;
//         окрім X, Y та n ніякі інші поля Target не змінюються}
//         Procedure NegativeX(var Target:VectorNew);
//         {заносить в Target ті точки, для яких X менше нуля;
//         окрім X, Y та n ніякі інші поля Target не змінюються}
//         Procedure NegativeY(var Target:VectorNew);
//         {заносить в Target ті точки, для яких Y менше нуля;
//         окрім X, Y та n ніякі інші поля Target не змінюються}
//         Procedure Write_File(sfile:string; NumberDigit:Byte=4);
//        {записує у файл з іменем sfile дані з масивів X та Y;
//        якщо n=0, то запис не відбувається; NumberDigit - кількість значущих цифр}
//         Procedure Load_File(sfile:string);
//         {завантажуються дані з файлу sfile;
//         якщо у файлі не два стовпчика чисел,
//         то в результаті буде порожній вектор}
//         Procedure DeltaY(deltaVector:VectorNew);
//         {від значень Y віднімаються значення deltaVector.Y;
//          якщо кількості точок різні - ніяких дій не відбувається}
//         Procedure Filling(Fun:TFun;Xmin,Xmax,deltaX:double;Parameters:array of double);overload;
//         {Х заповнюється значеннями від Xmin до Xmax з кроком deltaX
//         Y[i]=Fun(X[i],Parameters)}
//         Procedure Filling(Fun: TFun; Xmin, Xmax: Double; Parameters: array of Double; Nstep: Integer=100);overload;
//         {як попередня, тільки використовується не крок, а загальна
//         кількість точок Nstep на заданому інтервалі}
//         Procedure Filling(Fun:TFun;Xmin,Xmax,deltaX:double);overload;
//         Procedure Decimation(Np:word);
//         {залишається лише 0-й, Νp-й, 2Np-й.... елементи,
//          при Np=0 вектор масив не міняється}
//         Procedure DigitalFiltr(a,b:TArrSingle;NtoDelete:word=0);
//         {змінюються масив Y на Ynew:
//         Ynew[k]=a[0]*Y[k]+a[1]*Y[k-1]+...b[0]*Ynew[k-1]+b[1]*Ynew[k-2]...
//         NtoDelete - кількість точок, які видаляються
//         з початку масиву; ця кількість відповідає
//         тривалості перехідної характеристики фільтра}
        end;


    TVectorManipulation=class
      private
       fVector:TVectorNew;
       function GetVector: TVectorNew;
       procedure SetVector(const Value: TVectorNew);
      public
       property Vector:TVectorNew read GetVector write SetVector;
       Constructor Create(ExternalVector:TVectorNew);
       procedure Free;
    end;

//Procedure SetLenVector(A:Pvector;n:integer);
//{встановлюється кількість точок у векторі А}


implementation
uses OlegMathNew,OlegGraphNew, Classes, Dialogs, Controls, Math;



//Procedure SetLenVector(A:Pvector;n:integer);
//{встановлюється кількість точок у векторі А}
//begin
//  A^.n:=n;
//  SetLength(A^.X, A^.n);
//  SetLength(A^.Y, A^.n);
//end;
//
Procedure TVectorNew.SetLenVector(Number:integer);
{встановлюється кількість точок у векторі А}
begin
 SetLength(Points, Number);
end;

procedure TVectorNew.ReadFromFile(NameFile: string);
var F:TextFile;
//    i:integer;
    ss, ss1:string;
begin
  fName:=NameFile;
  Clear;
  if not(FileExists(NameFile)) then Exit;
  AssignFile(f,NameFile);
  ReadTextFile(F);
  if High(Points)<0 then
    begin
      DecimalSeparator:=',';
      ReadTextFile(F);
      DecimalSeparator:='.';
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

procedure TVectorNew.ReadFromGraph(Series: TCustomSeries);
 var i:integer;
begin
 Clear;
 SetLenVector(Series.Count);
 for I := 0 to High(Points) do
   PointSet(I,Series.XValue[i],Series.YValue[i]);
end;

procedure TVectorNew.ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
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

//  N_end:=ConfigFile.ReadInteger(Section,Ident+'N_end',n-1);
end;

procedure TVectorNew.WriteToFile(NameFile: string; NumberDigit: Byte);
 var   Str:TStringList;
       i:integer;
begin
 Str:=TStringList.Create;
 for I := 0 to High(Points)
   do  Str.Add(PoinToString(Points[i],NumberDigit));
 Str.SaveToFile(NameFile);
 Str.Free;
end;

procedure TVectorNew.WriteToGraph(Series: TCustomSeries);
 var i:integer;
begin
 Series.Clear;
 for I := 0 to High(Points) do
   Series.AddXY(Points[i,cX],Points[i,cY]);
end;

procedure TVectorNew.WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
var
  I: Integer;
begin
 WriteIniDef(ConfigFile,Section,Ident+'n',Count,0);
 WriteIniDef(ConfigFile,Section,Ident+'name',name);
 WriteIniDef(ConfigFile,Section,Ident+'time',time);
 WriteIniDef(ConfigFile,Section,Ident+'T',T);
 WriteIniDef(ConfigFile,Section,Ident+'N_begin',N_begin,0);
// WriteIniDef(ConfigFile,Section,Ident+'N_end',N_end,n-1);
 for I := 0 to High(Points) do
  begin
   ConfigFile.WriteFloat(Section,Ident+'X'+IntToStr(i),X[i]);
   ConfigFile.WriteFloat(Section,Ident+'Y'+IntToStr(i),Y[i])
  end;
end;

function TVectorNew.XtoString: string;
begin
 Result:=CoordToString(cX);
end;

function TVectorNew.Xvalue(Yvalue: double): double;
begin
 Result:=Value(cY,Yvalue);
end;

function TVectorNew.XYtoString: string;
 var i:integer;
begin
 Result:='';
 for i:=0 to High(Points) do
   Result:=Result+'('+PoinToString(Points[i])+')'+#10+#13;

end;

function TVectorNew.YtoString: string;
begin
 Result:=CoordToString(cY);
end;

function TVectorNew.Yvalue(Xvalue: double): double;
begin
 Result:=Value(cX,Xvalue);
end;

procedure TVectorNew.Add(newX,newY:double);
begin
 Self.SetLenVector(Count+1);
 PointSet(High(Points),newX,newY);
end;

procedure TVectorNew.DeletePoint(NumberToDelete:integer);
var
  I: Integer;
begin
 if (NumberToDelete<0)or(NumberToDelete>High(Points)) then Exit;
 for I := NumberToDelete to High(Points)-1
   do PointSet(i,PointGet(i+1));
 Self.SetLenVector(High(Points));
end;

procedure TVectorNew.DeleteNfirst(Nfirst:integer);
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

Procedure TVectorNew.Sorting (Increase:boolean=True);
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

function TVectorNew.StandartDeviation(Coord: TCoord_type): double;
 var mn,sm:double;
     i:integer;
begin
 mn:=MeanValue(Coord);
 sm:=0;
 for I := 0 to High(Points) do
 sm:=sm+sqr(Points[i,Coord]-mn);
 Result:=sqrt(sm/High(Points))
end;

function TVectorNew.Stat(Coord: TCoord_type; FunVector: TFunVectorInt;
  minPointNumber: Integer): integer;
begin
  if Count<minPointNumber
     then Result:=ErResult
     else Result:=FunVector(Coord);
end;

function TVectorNew.Stat(Coord: TCoord_type; FunVector: TFunVector;
                         minPointNumber: Integer): double;
begin
  if Count<minPointNumber
     then Result:=ErResult
     else Result:=FunVector(Coord);
end;

function TVectorNew.Sum(Coord: TCoord_type): double;
 var i:integer;
begin
 Result:=0;
 for I := 0 to High(Points) do
   Result:=Result+Points[i,Coord];
end;

Procedure TVectorNew.DeleteDuplicate;
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

Procedure TVectorNew.DeleteErResult;
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
      if (X[i]=ErResult)or(Y[i]=ErResult) then
            goto Start;
      Point:=I+1;
    end;
end;

Procedure TVectorNew.SwapXY;
 var i:integer;
begin
 for I := 0 to High(Points) do PointCoordSwap(Points[i]);
end;


function TVectorNew.Value(Coord: TCoord_type; CoordValue: Double): double;
 var i,number:integer;
begin
  i:=1;
  Result:=ErResult;
  if High(Points)<0 then Exit;
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

function TVectorNew.ValueXY(Coord: TCoord_type; CoordValue: Double;
                            i,j:integer): double;
begin
  case Coord of
    cY:Result:=X_Y0(Points[i],Points[j],CoordValue);
    cX:Result:=Y_X0(Points[i],Points[j],CoordValue);
    else Result:=ErResult;
  end;
end;


function TVectorNew.CoordToString(Coord: TCoord_type): string;
 var i:integer;
begin
 Result:='';
 for i:=0 to High(Points) do
   Result:=Result+FloaTtoStr(Points[i,Coord])+' ';
end;

Procedure TVectorNew.Copy (TargetVector:TVectorNew);
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

//Procedure VectorNew.CopyXtoArray(var TargetArray:TArrSingle);
function TVectorNew.CopyToArray(const Coord: TCoord_type): TArrSingle;
 var i:integer;
begin
 SetLength(Result,Count);
 for I := 0 to High(Points) do Result[i]:=Points[i][Coord];
end;

function TVectorNew.CopyXtoArray():TArrSingle;
begin
 Result:=CopyToArray(cX);
end;

function TVectorNew.CopyYtoArray():TArrSingle;
begin
 Result:=CopyToArray(cY);
end;

function TVectorNew.CopyYtoPArray: PTArrSingle;
begin
 new(Result);
 Result^:=CopyYtoArray();
end;

function TVectorNew.CopyXtoPArray():PTArrSingle;
begin
 new(Result);
 Result^:=CopyXtoArray();
end;

//Procedure VectorNew.CopyYtoPArray(var TargetArray:PTArrSingle);
// var i:integer;
//begin
// SetLength(TargetArray^,n);
//  for I := 0 to n-1 do
//     TargetArray^[i]:=Y[i];
//end;
//

Procedure TVectorNew.CopyFromXYArrays(SourceXArray,SourceYArray:TArrSingle);
 var i:integer;
begin
 Clear();
 for I := 0 to min(High(SourceXArray),High(SourceYArray)) do
   Add(SourceXArray[i],SourceYArray[i]);
end;

Procedure TVectorNew.CopyFromXYPArrays(SourceXArray,SourceYArray:PTArrSingle);
begin
 CopyFromXYArrays(SourceXArray^,SourceYArray^);
end;

procedure TVectorNew.ReadTextFile(const F: Text);
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


//Procedure VectorNew.CopyLimitedX (var Target:VectorNew;Xmin,Xmax:double);
// var i:integer;
//begin
//  Target.Clear;
//  Target.T:=T;
//  Target.name:=name;
//  for I := 0 to High(X) do
//    if (X[i]>=Xmin)and(X[i]<=Xmax) then
//       Target.Add(X[i],Y[i])
//end;
//
//Procedure VectorNew.MultiplyY(const A:double);
// var i:integer;
//begin
// if A=1 then Exit;
// for I := 0 to n - 1 do
//  Y[i]:=Y[i]*A;
//end;
//
//Procedure VectorNew.PositiveX(var Target:VectorNew);
// var i:integer;
//begin
// Target.SetLenVector(0);
// for I := 0 to n - 1 do
//   if X[i]>=0 then
//     Target.Add(X[i],Y[i]);
//end;
//
//Procedure VectorNew.PositiveY(var Target:VectorNew);
// var i:integer;
//begin
// Target.SetLenVector(0);
// for I := 0 to n - 1 do
//   if Y[i]>=0 then
//     Target.Add(X[i],Y[i]);
//end;
//
//Procedure VectorNew.AbsX(var Target:VectorNew);
// var i:integer;
//begin
// Copy(Target);
// for I := 0 to n - 1 do
//     if Target.X[i]=0 then Target.Delete(i)
//                      else
//     Target.X[i]:=abs(Target.X[i]);
//end;
//
//Procedure VectorNew.AbsY(var Target:VectorNew);
// var i:integer;
//begin
// Copy(Target);
// for I := 0 to n - 1 do
//     if Target.Y[i]=0 then Target.Delete(i)
//                      else
//     Target.Y[i]:=abs(Target.Y[i]);
//end;
//
//Procedure VectorNew.NegativeX(var Target:VectorNew);
// var i:integer;
//begin
// Target.SetLenVector(0);
// for I := 0 to n - 1 do
//   if X[i]<0 then
//     Target.Add(X[i],Y[i]);
//end;
//
//Procedure VectorNew.NegativeY(var Target:VectorNew);
// var i:integer;
//begin
// Target.SetLenVector(0);
// for I := 0 to n - 1 do
//   if Y[i]<0 then
//     Target.Add(X[i],Y[i]);
//end;

//
//Procedure VectorNew.Load_File(sfile:string);
//  var F:TextFile;
//    Xt,Yt:double;
//begin
// Clear();
// if FileExists(sfile) then
//  begin
//   AssignFile(f,sfile);
//   Reset(f);
//   try
//   while not(eof(f)) do
//       begin
//        readln(f,Xt,Yt);
//        Add(Xt,Yt);
//       end;
//   except
//    Clear();
//   end;
//   name:=sfile;
//   CloseFile(f);
//   N_begin:=0;
//   N_end:=n;
//  end;
//end;
//
//Procedure VectorNew.DeltaY(deltaVector:VectorNew);
// var i:integer;
//begin
// if High(X)<>High(deltaVector.X) then Exit;
// for i := 0 to High(X) do
//        Y[i]:=Y[i]-deltaVector.Y[i];
//end;

procedure TVectorNew.Add(newXY: double);
begin
 self.Add(newXY,newXY);
end;

procedure TVectorNew.Add(newPoint: TPointDouble);
begin
 Self.SetLenVector(Count+1);
 PointSet(High(Points),newPoint);
end;

Procedure TVectorNew.Clear();
begin
  SetLenVector(0);
  Fname:='';
  Ftime:='';
  fT:=0;
  fSegmentBegin:=0;
end;

//Procedure VectorNew.Filling(Fun:TFun;Xmin,Xmax,deltaX:double;Parameters:array of double);
// const Nmax=10000;
// var i:integer;
//     argument:double;
//begin
// i:=0;
// argument:=Xmin;
// repeat
//   inc(i);
//   argument:=argument+deltaX;
// until (argument>Xmax)or(i>Nmax);
// if (i>Nmax) then
//   begin
//     Clear();
//     Exit;
//   end;
// SetLenVector(i);
// for I := 0 to n - 1 do
//  begin
//    X[i]:=Xmin+i*deltaX;
//    Y[i]:=Fun(X[i],Parameters);
//  end;
//end;
//
//
//Procedure VectorNew.Filling(Fun: TFun; Xmin, Xmax: Double; Parameters: array of Double; Nstep: Integer);
//begin
//  if Nstep<1 then Clear()
//    else if Nstep=1 then Filling(Fun,Xmin,Xmax,Xmax-Xmin+1,Parameters)
//       else Filling(Fun,Xmin,Xmax,(Xmax-Xmin)/(Nstep-1),Parameters)
//end;
//
//Procedure VectorNew.Filling(Fun:TFun;Xmin,Xmax,deltaX:double);
//begin
// Filling(Fun,Xmin,Xmax,deltaX,[]);
//end;
//
//Procedure VectorNew.Decimation(Np:word);
// {залишається лише 0-й, ?-й, 2N-й.... елементи,
//          при вектор масив не міняється}
// var i:integer;
//begin
//  if (Np<=1)or(n<1) then Exit;
//  i:=1;
//  while(i*Np)<n do
//   begin
//    X[i]:=X[i*Np];
//    Y[i]:=Y[i*Np];
//    inc(i);
//   end;
//  SetLenVector(i);
//end;
//
//Procedure VectorNew.DigitalFiltr(a,b:TArrSingle;NtoDelete:word=0);
//{змінюються масив Y на Ynew:
// Ynew[k]=a[0]*Y[k]+a[1]*Y[k-1]+...b[0]*Ynew[k-1]+b[1]*Ynew[k-2]...}
// var Yold:PTArrSingle;
//     i:integer;
//  j: Integer;
//begin
// if (High(a)<0) then Exit;
// if NtoDelete>=Self.n then
//   begin
//     Self.Clear;
//     Exit;
//   end;
//
// new(Yold);
// CopyYtoPArray(Yold);
// for I := 0 to n - 1 do
//  begin
//   Y[i]:=0;
//   for j := 0 to High(a) do
//      if (i-j>=0) then Y[i]:=Y[i]+a[j]*Yold^[i-j]
//                  else Break;
//   for j := 0 to High(b) do
//      if (i-j>0) then Y[i]:=Y[i]+b[j]*Y[i-j-1]
//                  else Break;
//  end;
// dispose(Yold);
//
// Self.DeleteNfirst(NtoDelete);
//end;
//
//
{ VectorNew }

constructor TVectorNew.Create;
begin
 inherited;
 Clear();
end;

function TVectorNew.GetData(const Number: Integer; Index:Integer): double;
begin
 if Number>High(Points)
    then Result:=ErResult
    else Result:=Points[Number][TCoord_type(Index)];

end;

function TVectorNew.GetInformation(const Index: Integer): double;
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

function TVectorNew.GetInformationInt(const Index: Integer): double;
begin
 case Index of
  1:Result:=Stat(cX,Self.MaxNumber);
  2:Result:=Stat(cY,Self.MaxNumber);
  3:Result:=Stat(cX,Self.MaxNumber);
  4:Result:=Stat(cY,Self.MaxNumber);
  else Result:=ErResult;
 end;
end;

function TVectorNew.GetN: Integer;
begin
// Result:=High(fX)+1;
 Result:=High(Points)+1;
end;

function TVectorNew.IsEmptyGet: boolean;
begin
 Result:=(High(Points)<0);
end;

function TVectorNew.MaxNumber(Coord: TCoord_type): integer;
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

function TVectorNew.MaxValue(Coord: TCoord_type): double;
var
  I: Integer;
begin
  Result := Points[0,Coord];
  for I := 1 to High(Points) do
    if Result < Points[i,Coord] then
      Result := Points[i,Coord];
end;

function TVectorNew.MeanValue(Coord: TCoord_type): double;
begin
 Result:=Sum(Coord)/Count;
end;

function TVectorNew.MinNumber(Coord: TCoord_type): integer;
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

function TVectorNew.MinValue(Coord: TCoord_type): double;
var
  I: Integer;
begin
  Result := Points[0,Coord];
  for I := 1 to High(Points) do
    if Result > Points[i,Coord] then
      Result := Points[i,Coord];
end;

procedure TVectorNew.PointCoordSwap(Point: TPointDouble);
begin
 Swap(Point[cX],Point[cX]);
end;

function TVectorNew.PointGet(Number: integer): TPointDouble;
begin
 Result[cX]:=Points[Number,cX];
 Result[cY]:=Points[Number,cY];
end;

function TVectorNew.PoinToString(Point: TPointDouble; NumberDigit: Byte): string;
begin
 Result:=FloatToStrF(Point[cX],ffExponent,NumberDigit,0)+' '+
         FloatToStrF(Point[cY],ffExponent,NumberDigit,0);
end;

procedure TVectorNew.PointSet(Number: integer; Point: TPointDouble);
begin
 try
  Points[Number,cX]:=Point[cX];
  Points[Number,cY]:=Point[cY];
 except
 end;
end;

procedure TVectorNew.PointSwap(Number1, Number2: integer);
 var tempPoint:TPointDouble;
begin
 try
  tempPoint:=PointGet(Number1);
  PointSet(Number1,PointGet(Number2));
  PointSet(Number2,tempPoint);
 except
 end;
end;

procedure TVectorNew.PointSet(Number: integer; x, y: double);
begin
 try
  Points[Number,cX]:=x;
  Points[Number,cY]:=y;
 except
 end;
end;

//function VectorNew.GetX(Index: Integer): double;
//begin
// if Index>High(Points)
//   then Result:=NAN
//   else Result := Points[Index].X;
//end;
//
//function VectorNew.GetY(Index: Integer): double;
//begin
//// if Index>High(fY) then Result:=NAN
////                   else Result := fY[Index];
// if Index>High(Points)
//   then Result:=NAN
//   else Result := Points[Index].Y;
//end;

procedure TVectorNew.SetData(const Number: Integer;
                            Index: Integer; const Value: double);
begin
 if Number>High(Points)
    then Exit
    else Points[Number][TCoord_type(Index)]:=Value;
end;


procedure TVectorNew.SetT(const Value: Extended);
begin
  if Value>0 then fT := Value
             else fT:=0;
end;

{ TVectorManipulation }

constructor TVectorManipulation.Create(ExternalVector: TVectorNew);
begin
  inherited Create;
  fVector:=TVectorNew.Create;
  SetVector(ExternalVector);
end;

procedure TVectorManipulation.Free;
begin
 fVector.Free;
 inherited Free;
end;

function TVectorManipulation.GetVector: TVectorNew;
begin
 Result:=TVectorNew.Create;
 fVector.Copy(Result);
end;

procedure TVectorManipulation.SetVector(const Value: TVectorNew);
begin
 Value.Copy(fVector);
end;


end.

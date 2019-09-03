unit OlegVector;


interface
 uses IniFiles,SysUtils, StdCtrls,OlegType;


type

//    Point=record
//         X:double;
//         Y:double;
//    end;

    TCoord_type=(cX,cY);

    TPoint=array[TCoord_type]of double;

    VectorNew=class
     private
      Points:array of TPoint;
//      Points:array of Point;
//      fX:array of double;
//      fY:array of double;
      fName:string;
      fT:Extended;
      ftime:string;
      fSegmentBegin: Cardinal;
//      function GetX(Index: Integer): double;
//      function GetY(Index: Integer): double;
      function GetData(const Number: Integer; Index:Integer): double;
      function GetN: Integer;
      procedure SetT(const Value: Extended);
      procedure SetData(const Number: Integer; Index: Integer;
                        const Value: double);
      procedure PointSet(Number:integer; x,y:double);overload;
       {заповнює координати точки з номером Number,
       але наявність цієї точки в масиві не перевіряється}
      procedure PointSet(Number:integer; Point:TPoint);overload;
      function PointGet(Number:integer):TPoint;
      procedure PointSwap(Number1,Number2:integer);
      procedure PointCoordSwap(Point:Tpoint);
      function IsEmptyGet: boolean;
     public


      property X[const Number: Integer]: double Index ord(cX)
                        read GetData write SetData;
      property Y[const Number: Integer]: double Index ord(cY)
                        read GetData write SetData;

//      property X[Index: Integer]: double read GetX;
//      property Y[Index: Integer]: double read GetY;
      property Point[Index:Integer]:TPoint read PointGet;default;
      property n:Integer read GetN;
      {кількість точок,
      в масивaх нумерація від 0 до n-1}
      property name:string read fName write fName;
      {назва файлу, звідки завантажені дані}
      property T:Extended read fT write SetT;
      {температура, що відповідає цим даним}
      property time:string read ftime write ftime;
      {час створення файлу - година:хвилини
                           - секунди з початку доби}
//    writeln(FF,Name,' - ',temp,'  :'+inttostr(SecondFromDayBegining(FileDateToDateTime(SR.Time))));

      property N_begin:Cardinal read  fSegmentBegin write fSegmentBegin;
     {номер точки з вихідного вектора, яка відповідає
      початковій у цьому}
      property IsEmpty:boolean read IsEmptyGet;

      Constructor Create;
//      function PointGet(Number:integer):TPoint;

      procedure SetLenVector(Number:integer);
      procedure Clear();
         {просто зануляється кількість точок, інших операцій не проводиться}
      procedure ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
      procedure WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
      procedure Add(newX,newY:double);overload;
      procedure Add(newXY:double);overload;
      procedure Add(newPoint:TPoint);overload;
      procedure Delete(NumberToDelete:integer);
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
//         Procedure CopyLimitedX (var Target:VectorNew;Xmin,Xmax:double);
//         {копіюються з даного вектора в Target
//         - точки, для яких ордината в діапазоні від Xmin до Xmax включно
//         - поля Т та name}


//      function MaxX:double;
//          {повертається найбільше значення з масиву Х}
//         Function MaxY:double;
//          {повертається найбільше значення з масиву Y}
//         Function MinX:double;
//          {повертається найменше значення з масиву Х}
//         Function MinY:double;
//          {повертається найменше значення з масиву Y}
//         Function MeanY:double;
//         {повертає середнє арифметичне значень в масиві Y}
//         Function MeanX:double;
//         {повертає середнє арифметичне значень в масиві X}
//         Function StandartDeviationY:double;
//         {повертає стандартне відхилення значень в масиві Y
//         SD=(sum[(yi-<y>)^2]/(n-1))^0.5}
//         Function StandartErrorY:double;
//         {повертає стандартну похибку значень в масиві Y
//         SЕ=SD/n^0.5}
//         Function StandartDeviationX:double;
//         Function StandartErrorX:double;
//         Function Xvalue(Yvalue:double):double;
//         {повертає визначає приблизну абсцису точки з
//          ординатою Yvalue;
//          якщо Yvalue не належить діапазону зміни
//         ординат вектора, то повертається ErResult}
//         Function Yvalue(Xvalue:double):double;
//         {повертає визначає приблизну ординату точки з
//          ординатою Xvalue;
//          якщо Xvalue не належить діапазону зміни
//         ординат вектора, то повертається ErResult}
//         Function SumX:double;
//         Function SumY:double;
//         {повертаються суми елементів масивів X та Y відповідно}
//         Procedure Copy (var Target:VectorNew);
//         {копіюються поля з даного вектора в Target}

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



//Procedure SetLenVector(A:Pvector;n:integer);
//{встановлюється кількість точок у векторі А}


implementation
uses OlegMath,OlegGraph, Classes, Dialogs, Controls, Math;



//Procedure SetLenVector(A:Pvector;n:integer);
//{встановлюється кількість точок у векторі А}
//begin
//  A^.n:=n;
//  SetLength(A^.X, A^.n);
//  SetLength(A^.Y, A^.n);
//end;
//
Procedure VectorNew.SetLenVector(Number:integer);
{встановлюється кількість точок у векторі А}
begin
 SetLength(Points, Number);
end;

procedure VectorNew.ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
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

procedure VectorNew.WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
var
  I: Integer;
begin
 WriteIniDef(ConfigFile,Section,Ident+'n',n,0);
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

procedure VectorNew.Add(newX,newY:double);
begin
 Self.SetLenVector(n+1);
 PointSet(High(Points),newX,newY);
end;

procedure VectorNew.Delete(NumberToDelete:integer);
var
  I: Integer;
begin
 if (NumberToDelete<0)or(NumberToDelete>High(Points)) then Exit;
 for I := NumberToDelete to High(Points)-1
   do PointSet(i,PointGet(i+1));
 Self.SetLenVector(High(Points));
end;

procedure VectorNew.DeleteNfirst(Nfirst:integer);
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
  Self.SetLenVector(n-Nfirst);
end;

Procedure VectorNew.Sorting (Increase:boolean=True);
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

Procedure VectorNew.DeleteDuplicate;
 var i,j,PointToDelete,Point:integer;
 label Start;
begin
  Point:=0;
  PointToDelete:=-1;
 Start:
  if PointToDelete<>-1 then
     Self.Delete(PointToDelete);
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

Procedure VectorNew.DeleteErResult;
 var i,Point:integer;
 label Start;
begin
  Point:=0;
  i:=-1;
 Start:
  if i<>-1 then
     Self.Delete(i);
  for I := Point to High(Points)-1 do
    begin
      if (X[i]=ErResult)or(Y[i]=ErResult) then
            goto Start;
      Point:=I+1;
    end;
end;

Procedure VectorNew.SwapXY;
 var i:integer;
begin
 for I := 0 to High(Points) do PointCoordSwap(Points[i]);
end;

//Function VectorNew.MaxX:double;
//begin
//  if n<1 then
//    Result:=ErResult
//         else
////    Result:=X[MaxElemNumber(X)];
//    Result:=MaxValue(X);
//end;

//Function VectorNew.MaxY:double;
//begin
//  if n<1 then
//    Result:=ErResult
//         else
//    Result:=Y[MaxElemNumber(Y)];
//end;
//
//Function VectorNew.MinX:double;
//begin
//  if n<1 then
//    Result:=ErResult
//         else
//    Result:=X[MinElemNumber(X)];
//end;
//
//Function VectorNew.MinY:double;
//begin
//  if n<1 then
//    Result:=ErResult
//         else
//    Result:=Y[MinElemNumber(Y)];
//end;
//
//Function VectorNew.MeanY:double;
//begin
//  if n<1 then
//    Result:=ErResult
//         else
//    Result:=Mean(Y);
//end;
//
//Function VectorNew.MeanX:double;
//begin
//  if n<1 then
//    Result:=ErResult
//         else
//    Result:=Mean(X);
//end;
//
//Function VectorNew.StandartDeviationY:double;
//{повертає стандартне відхилення значень в масиві Y
//SD=(sum[(yi-<y>)^2]/(n-1))^0.5}
// var mean,sum:double;
//     i:integer;
//begin
//  if n<2 then
//    Result:=ErResult
//         else
//    begin
//     mean:=MeanY;
//     sum:=0;
//     for I := 0 to High(Y) do
//       sum:=sum+sqr(Y[i]-mean);
//     Result:=sqrt(sum/(n-1))
//    end;
//end;
//
//Function VectorNew.StandartErrorY:double;
//{повертає стандартну похибку значень в масиві Y
//SЕ=SD/n^0.5}
//begin
//  if n<2 then
//    Result:=ErResult
//         else
//    Result:=StandartDeviationY/sqrt(n);
//end;
//
//Function VectorNew.StandartDeviationX:double;
// var mean,sum:double;
//     i:integer;
//begin
//  if n<2 then
//    Result:=ErResult
//         else
//    begin
//     mean:=MeanX;
//     sum:=0;
//     for I := 0 to High(X) do
//       sum:=sum+sqr(X[i]-mean);
//     Result:=sqrt(sum/(n-1))
//    end;
//end;
//
//Function VectorNew.StandartErrorX:double;
//begin
//  if n<2 then
//    Result:=ErResult
//         else
//    Result:=StandartDeviationX/sqrt(n);
//end;
//
//
//
//
//Function VectorNew.SumX:double;
// var i:integer;
//begin
// Result:=0;
// for I := 0 to High(X) do
//   Result:=Result+X[i]
//end;
//
//Function VectorNew.SumY:double;
// var i:integer;
//begin
// Result:=0;
// for I := 0 to High(Y) do
//   Result:=Result+Y[i]
//end;
//
//Function VectorNew.Xvalue(Yvalue:double):double;
//var i:integer;
//begin
//  i:=1;
//  Result:=ErResult;
//  if High(X)<0 then Exit;
//  repeat
//   if ((Y[i]-Yvalue)*(Y[i-1]-Yvalue))<=0 then
//     begin
//     Result:=X_Y0(X[i],Y[i],X[i-1],Y[i-1],Yvalue);
//     i:=High(X);
//     end;
//   i:=i+1;
//  until (i>High(X));
//end;
//
//Function VectorNew.Yvalue(Xvalue:double):double;
// var i:integer;
//begin
//  i:=1;
//  Result:=ErResult;
//  if High(X)<0 then Exit;
//  repeat
//   if ((X[i]-Xvalue)*(X[i-1]-Xvalue))<=0 then
//     begin
//     Result:=Y_X0(X[i],Y[i],X[i-1],Y[i-1],Xvalue);
//     i:=High(X);
//     end;
//   i:=i+1;
//  until (i>High(X));
//end;
//
//
//Procedure VectorNew.Copy (var Target:VectorNew);
// var i:integer;
//begin
//  Target.SetLenVector(n);
//  for I := 0 to n-1 do
//    begin
//     Target.X[i]:=X[i];
//     Target.Y[i]:=Y[i];
//    end;
//  Target.T:=T;
//  Target.name:=name;
//  Target.time:=time;
//  Target.N_begin:=N_begin;
//  Target.N_end:=N_end;
//end;

//Procedure VectorNew.CopyXtoArray(var TargetArray:TArrSingle);
function VectorNew.CopyToArray(const Coord: TCoord_type): TArrSingle;
 var i:integer;
begin
 SetLength(Result,n);
 for I := 0 to High(Points) do Result[i]:=Points[i][Coord];
end;

function VectorNew.CopyXtoArray():TArrSingle;
begin
 Result:=CopyToArray(cX);
end;

function VectorNew.CopyYtoArray():TArrSingle;
begin
 Result:=CopyToArray(cY);
end;

function VectorNew.CopyYtoPArray: PTArrSingle;
begin
 new(Result);
 Result^:=CopyYtoArray();
end;

function VectorNew.CopyXtoPArray():PTArrSingle;
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

Procedure VectorNew.CopyFromXYArrays(SourceXArray,SourceYArray:TArrSingle);
 var i:integer;
begin
 Clear();
 for I := 0 to min(High(SourceXArray),High(SourceYArray)) do
   Add(SourceXArray[i],SourceYArray[i]);
end;

Procedure VectorNew.CopyFromXYPArrays(SourceXArray,SourceYArray:PTArrSingle);
begin
 CopyFromXYArrays(SourceXArray^,SourceYArray^);
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
//Procedure VectorNew.Write_File(sfile:string; NumberDigit:Byte=4);
//var i:integer;
//    Str:TStringList;
//begin
//  if n=0 then Exit;
//  Str:=TStringList.Create;
//  for I := 0 to High(X) do
//     Str.Add(FloatToStrF(X[i],ffExponent,NumberDigit,0)+' '+
//             FloatToStrF(Y[i],ffExponent,NumberDigit,0));
//  Str.SaveToFile(sfile);
//  Str.Free;
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

procedure VectorNew.Add(newXY: double);
begin
 self.Add(newXY,newXY);
end;

procedure VectorNew.Add(newPoint: TPoint);
begin
 Self.SetLenVector(n+1);
 PointSet(High(Points),newPoint);
end;

Procedure VectorNew.Clear();
begin
  SetLenVector(0);
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

constructor VectorNew.Create;
begin
 inherited;
 Clear();
end;

function VectorNew.GetData(const Number: Integer; Index:Integer): double;
begin
 if Number>High(Points)
    then Result:=ErResult
    else Result:=Points[Number][TCoord_type(Index)];

end;

function VectorNew.GetN: Integer;
begin
// Result:=High(fX)+1;
 Result:=High(Points)+1;
end;

function VectorNew.IsEmptyGet: boolean;
begin
 Result:=(High(Points)<0);
end;

procedure VectorNew.PointCoordSwap(Point: Tpoint);
begin
 Swap(Point[cX],Point[cX]);
end;

function VectorNew.PointGet(Number: integer): TPoint;
begin
 Result[cX]:=Points[Number,cX];
 Result[cY]:=Points[Number,cY];
end;

procedure VectorNew.PointSet(Number: integer; Point: TPoint);
begin
 try
  Points[Number,cX]:=Point[cX];
  Points[Number,cY]:=Point[cY];
 except
 end;
end;

procedure VectorNew.PointSwap(Number1, Number2: integer);
 var tempPoint:TPoint;
begin
 try
  tempPoint:=PointGet(Number1);
  PointSet(Number1,PointGet(Number2));
  PointSet(Number2,tempPoint);
 except
 end;
end;

procedure VectorNew.PointSet(Number: integer; x, y: double);
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

procedure VectorNew.SetData(const Number: Integer;
                            Index: Integer; const Value: double);
begin
 if Number>High(Points)
    then Exit
    else Points[Number][TCoord_type(Index)]:=Value;
end;


procedure VectorNew.SetT(const Value: Extended);
begin
  if Value>0 then fT := Value
             else fT:=0;
end;

end.

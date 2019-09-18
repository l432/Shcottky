unit OlegVector;


interface
 uses OlegTypeNew, IniFiles;


type


    Vector=record
         X:array of double;
         Y:array of double;
         n:integer; //кількість точок, в масиві буде нумерація
                 //від 0 до n-1
         name:string; // назва файлу, звідки завантажені дані
         T:Extended;  // температура, що відповідає цим даним
         time:string; //час створення файлу, година:хвилини
                      //секунди з початку доби
         N_begin:integer; //номери початкової і кінцевої точок
         N_end:integer;  //даних, які відображаються на графіку
         Procedure SetLenVector(Number:integer);
         procedure ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
         procedure WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
         procedure Add(newX,newY:double);
         procedure Delete(Ndel:integer);
         {видання з масиву точки з номером Ndel}
         procedure DeleteNfirst(Nfirst:integer);
         {видаляє з масиву Nfirst перших точок}
         Procedure Sorting (Increase:boolean=True);
         {процедура сортування (методом бульбашки)
          точок по зростанню (при Increase=True) компоненти Х}
         Procedure DeleteDuplicate;
         {видаляються точки, для яких значення абсциси вже зустрічалося}
         Procedure DeleteErResult;
         {видаляються точки, для абсциса чи ордината рівна ErResult}
         Procedure SwapXY;
         {обмінюються знчення Х та Y}
         Function MaxX:double;
          {повертається найбільше значення з масиву Х}
         Function MaxY:double;
          {повертається найбільше значення з масиву Y}
         Function MinX:double;
          {повертається найменше значення з масиву Х}
         Function MinY:double;
          {повертається найменше значення з масиву Y}
         Function MeanY:double;
         {повертає середнє арифметичне значень в масиві Y}
         Function MeanX:double;
         {повертає середнє арифметичне значень в масиві X}
         Function StandartDeviationY:double;
         {повертає стандартне відхилення значень в масиві Y
         SD=(sum[(yi-<y>)^2]/(n-1))^0.5}
         Function StandartErrorY:double;
         {повертає стандартну похибку значень в масиві Y
         SЕ=SD/n^0.5}
         Function StandartDeviationX:double;
         Function StandartErrorX:double;
         Function Xvalue(Yvalue:double):double;
         {повертає визначає приблизну абсцису точки з
          ординатою Yvalue;
          якщо Yvalue не належить діапазону зміни
         ординат вектора, то повертається ErResult}
         Function Yvalue(Xvalue:double):double;
         {повертає визначає приблизну ординату точки з
          ординатою Xvalue;
          якщо Xvalue не належить діапазону зміни
         ординат вектора, то повертається ErResult}
         Function SumX:double;
         Function SumY:double;
         {повертаються суми елементів масивів X та Y відповідно}
         Procedure Copy (var Target:Vector);
         {копіюються поля з даного вектора в Target}
         Procedure CopyXtoArray(var TargetArray:TArrSingle);
         {копіюються дані з Х в массив TargetArray}
         Procedure CopyYtoArray(var TargetArray:TArrSingle);
         {копіюються дані з Y в массив TargetArray}
         Procedure CopyXtoPArray(var TargetArray:PTArrSingle);
         {копіюються дані з Х в массив TargetArray}
         Procedure CopyYtoPArray(var TargetArray:PTArrSingle);
         {копіюються дані з Y в массив TargetArray}
         Procedure CopyFromXYArrays(SourceXArray,SourceYArray:TArrSingle);
         {заповнюються Х та Y значеннями з масивів}
         Procedure CopyFromXYPArrays(SourceXArray,SourceYArray:PTArrSingle);
         {заповнюються Х та Y значеннями з масивів}
         Procedure CopyLimitedX (var Target:Vector;Xmin,Xmax:double);
         {копіюються з даного вектора в Target
         - точки, для яких ордината в діапазоні від Xmin до Xmax включно
         - поля Т та name}
         Procedure MultiplyY(const A:double);
         {Y всіх точок множиться на A}
         Procedure PositiveX(var Target:Vector);
         {заносить в Target ті точки, для яких X більше або рівне нулю;
         окрім X, Y та n ніякі інші поля Target не змінюються}
         Procedure PositiveY(var Target:Vector);
         {заносить в Target ті точки, для яких Y більше або рівне нулю;
         окрім X, Y та n ніякі інші поля Target не змінюються}
         Procedure AbsX(var Target:Vector);
         {заносить в Target точки, для яких X дорівнює модулю Х даного
         вектора, а Y таке саме; якщо Х=0, то точка викидається;
         окрім X, Y та n ніякі інші поля Target не змінюються}
         Procedure AbsY(var Target:Vector);
         {заносить в Target точки, для яких Y дорівнює модулю Y даного
         вектора, а X таке саме; якщо Y=0, то точка викидається;
         окрім X, Y та n ніякі інші поля Target не змінюються}
         Procedure NegativeX(var Target:Vector);
         {заносить в Target ті точки, для яких X менше нуля;
         окрім X, Y та n ніякі інші поля Target не змінюються}
         Procedure NegativeY(var Target:Vector);
         {заносить в Target ті точки, для яких Y менше нуля;
         окрім X, Y та n ніякі інші поля Target не змінюються}
         Procedure Write_File(sfile:string; NumberDigit:Byte=4);
        {записує у файл з іменем sfile дані з масивів X та Y;
        якщо n=0, то запис не відбувається; NumberDigit - кількість значущих цифр}
         Procedure Load_File(sfile:string);
         {завантажуються дані з файлу sfile;
         якщо у файлі не два стовпчика чисел,
         то в результаті буде порожній вектор}
         Procedure DeltaY(deltaVector:Vector);
         {від значень Y віднімаються значення deltaVector.Y;
          якщо кількості точок різні - ніяких дій не відбувається}
         Procedure Clear();
         {просто зануляється кількість точок, інших операцій не проводиться}
         Procedure Filling(Fun:TFun;Xmin,Xmax,deltaX:double;Parameters:array of double);overload;
         {Х заповнюється значеннями від Xmin до Xmax з кроком deltaX
         Y[i]=Fun(X[i],Parameters)}
         Procedure Filling(Fun: TFun; Xmin, Xmax: Double; Parameters: array of Double; Nstep: Integer=100);overload;
         {як попередня, тільки використовується не крок, а загальна
         кількість точок Nstep на заданому інтервалі}
         Procedure Filling(Fun:TFun;Xmin,Xmax,deltaX:double);overload;
         Procedure Decimation(Np:word);
         {залишається лише 0-й, Νp-й, 2Np-й.... елементи,
          при Np=0 вектор масив не міняється}
         Procedure DigitalFiltr(a,b:TArrSingle;NtoDelete:word=0);
         {змінюються масив Y на Ynew:
         Ynew[k]=a[0]*Y[k]+a[1]*Y[k-1]+...b[0]*Ynew[k-1]+b[1]*Ynew[k-2]...
         NtoDelete - кількість точок, які видаляються
         з початку масиву; ця кількість відповідає
         тривалості перехідної характеристики фільтра}
        end;

  PVector=^Vector;


Procedure SetLenVector(A:Pvector;n:integer);
{встановлюється кількість точок у векторі А}


implementation
uses OlegMathNew,OlegGraphNew, Classes, Dialogs, Controls, Math, SysUtils;




Procedure SetLenVector(A:Pvector;n:integer);
{встановлюється кількість точок у векторі А}
begin
  A^.n:=n;
  SetLength(A^.X, A^.n);
  SetLength(A^.Y, A^.n);
end;

Procedure Vector.SetLenVector(Number:integer);
{встановлюється кількість точок у векторі А}
begin
  n:=Number;
  SetLength(X, n);
  SetLength(Y, n);
end;

procedure Vector.ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
 var i:integer;
begin
  i:=ConfigFile.ReadInteger(Section,Ident+'n',0);
  if i>0 then
    begin
      Self.SetLenVector(i);
      for I := 0 to High(X) do
        begin
          X[i]:=ConfigFile.ReadFloat(Section,Ident+'X'+IntToStr(i),ErResult);
          Y[i]:=ConfigFile.ReadFloat(Section,Ident+'Y'+IntToStr(i),ErResult);
        end;
    end
         else
    n:=0;
  name:=ConfigFile.ReadString(Section,Ident+'name','');
  time:=ConfigFile.ReadString(Section,Ident+'time','');
  T:=ConfigFile.ReadFloat(Section,Ident+'T',ErResult);
  N_begin:=ConfigFile.ReadInteger(Section,Ident+'N_begin',0);
  N_end:=ConfigFile.ReadInteger(Section,Ident+'N_end',n-1);
end;

procedure Vector.WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
var
  I: Integer;
begin
 WriteIniDef(ConfigFile,Section,Ident+'n',n,0);
 WriteIniDef(ConfigFile,Section,Ident+'name',name);
 WriteIniDef(ConfigFile,Section,Ident+'time',time);
 WriteIniDef(ConfigFile,Section,Ident+'T',T);
 WriteIniDef(ConfigFile,Section,Ident+'N_begin',N_begin,0);
 WriteIniDef(ConfigFile,Section,Ident+'N_end',N_end,n-1);
 for I := 0 to High(X) do
  begin
   ConfigFile.WriteFloat(Section,Ident+'X'+IntToStr(i),X[i]);
   ConfigFile.WriteFloat(Section,Ident+'Y'+IntToStr(i),Y[i])
  end;
end;

procedure Vector.Add(newX,newY:double);
begin
 Self.SetLenVector(n+1);
 X[n-1]:=newX;
 Y[n-1]:=newY;
end;

procedure Vector.Delete(Ndel:integer);
var
  I: Integer;
begin
 if (Ndel<0)or(Ndel>(n-1)) then Exit;
 if n<1 then Exit;
 for I := Ndel to n-2 do
  begin
    X[i]:=X[i+1];
    Y[i]:=Y[i+1];
  end;
 if N_end=n then N_end:=N_end-1;
 Self.SetLenVector(n-1);
end;

procedure Vector.DeleteNfirst(Nfirst:integer);
var
  I: Integer;
begin
  if Nfirst<=0 then Exit;
  if Nfirst>=n then
    begin
      Self.Clear;
      Exit;
    end;
  for I := 0 to n-Nfirst-1 do
   begin
    X[i]:=X[i+Nfirst];
    Y[i]:=Y[i+Nfirst];
   end;
  Self.SetLenVector(n-Nfirst);
end;

Procedure Vector.Sorting (Increase:boolean=True);
var i,j:integer;
    ChangeNeed:boolean;
    temp:double;
begin
for I := 0 to High(X)-1 do
  for j := 0 to High(X)-1-i do
     begin
      if Increase then ChangeNeed:=X[j]>X[j+1]
                  else ChangeNeed:=X[j]<X[j+1];
      if ChangeNeed then
          begin
          temp:=X[j];
          X[j]:=X[j+1];
          X[j+1]:=temp;
          temp:=Y[j];
          Y[j]:=Y[j+1];
          Y[j+1]:=temp;
          end;
     end;
end;

Procedure Vector.DeleteDuplicate;
 var i,j,PointToDelete,Point:integer;
 label Start;
begin
  Point:=0;
  PointToDelete:=-1;
 Start:
  if PointToDelete<>-1 then
     Self.Delete(PointToDelete);
  for I := Point to High(X)-1 do
    begin
      for j := i+1 to High(X) do
        if X[i]=X[j] then
          begin
            PointToDelete:=j;
            goto Start;
          end;
      Point:=I+1;
    end;
end;

Procedure Vector.DeleteErResult;
 var i,Point:integer;
 label Start;
begin
  Point:=0;
  i:=-1;
 Start:
  if i<>-1 then
     Self.Delete(i);
  for I := Point to High(X)-1 do
    begin
      if (X[i]=ErResult)or(Y[i]=ErResult) then
            goto Start;
      Point:=I+1;
    end;
end;

Procedure Vector.SwapXY;
 var i:integer;
begin
 for I := 0 to High(X) do
   Swap(X[i],Y[i]);
end;

Function Vector.MaxX:double;
begin
  if n<1 then
    Result:=ErResult
         else
//    Result:=X[MaxElemNumber(X)];
    Result:=MaxValue(X);
end;

Function Vector.MaxY:double;
begin
  if n<1 then
    Result:=ErResult
         else
    Result:=Y[MaxElemNumber(Y)];
end;

Function Vector.MinX:double;
begin
  if n<1 then
    Result:=ErResult
         else
    Result:=X[MinElemNumber(X)];
end;

Function Vector.MinY:double;
begin
  if n<1 then
    Result:=ErResult
         else
    Result:=Y[MinElemNumber(Y)];
end;

Function Vector.MeanY:double;
begin
  if n<1 then
    Result:=ErResult
         else
    Result:=Mean(Y);
end;

Function Vector.MeanX:double;
begin
  if n<1 then
    Result:=ErResult
         else
    Result:=Mean(X);
end;

Function Vector.StandartDeviationY:double;
{повертає стандартне відхилення значень в масиві Y
SD=(sum[(yi-<y>)^2]/(n-1))^0.5}
 var mean,sum:double;
     i:integer;
begin
  if n<2 then
    Result:=ErResult
         else
    begin
     mean:=MeanY;
     sum:=0;
     for I := 0 to High(Y) do
       sum:=sum+sqr(Y[i]-mean);
     Result:=sqrt(sum/(n-1))
    end;
end;

Function Vector.StandartErrorY:double;
{повертає стандартну похибку значень в масиві Y
SЕ=SD/n^0.5}
begin
  if n<2 then
    Result:=ErResult
         else
    Result:=StandartDeviationY/sqrt(n);
end;

Function Vector.StandartDeviationX:double;
 var mean,sum:double;
     i:integer;
begin
  if n<2 then
    Result:=ErResult
         else
    begin
     mean:=MeanX;
     sum:=0;
     for I := 0 to High(X) do
       sum:=sum+sqr(X[i]-mean);
     Result:=sqrt(sum/(n-1))
    end;
end;

Function Vector.StandartErrorX:double;
begin
  if n<2 then
    Result:=ErResult
         else
    Result:=StandartDeviationX/sqrt(n);
end;




Function Vector.SumX:double;
 var i:integer;
begin
 Result:=0;
 for I := 0 to High(X) do
   Result:=Result+X[i]
end;

Function Vector.SumY:double;
 var i:integer;
begin
 Result:=0;
 for I := 0 to High(Y) do
   Result:=Result+Y[i]
end;

Function Vector.Xvalue(Yvalue:double):double;
var i:integer;
begin
  i:=1;
  Result:=ErResult;
  if High(X)<0 then Exit;
  repeat
   if ((Y[i]-Yvalue)*(Y[i-1]-Yvalue))<=0 then
     begin
     Result:=X_Y0(X[i],Y[i],X[i-1],Y[i-1],Yvalue);
     i:=High(X);
     end;
   i:=i+1;
  until (i>High(X));
end;

Function Vector.Yvalue(Xvalue:double):double;
 var i:integer;
begin
  i:=1;
  Result:=ErResult;
  if High(X)<0 then Exit;
  repeat
   if ((X[i]-Xvalue)*(X[i-1]-Xvalue))<=0 then
     begin
     Result:=Y_X0(X[i],Y[i],X[i-1],Y[i-1],Xvalue);
     i:=High(X);
     end;
   i:=i+1;
  until (i>High(X));
end;


Procedure Vector.Copy (var Target:Vector);
 var i:integer;
begin
  Target.SetLenVector(n);
  for I := 0 to n-1 do
    begin
     Target.X[i]:=X[i];
     Target.Y[i]:=Y[i];
    end;
  Target.T:=T;
  Target.name:=name;
  Target.time:=time;
  Target.N_begin:=N_begin;
  Target.N_end:=N_end;
end;

Procedure Vector.CopyXtoArray(var TargetArray:TArrSingle);
 var i:integer;
begin
 SetLength(TargetArray,n);
  for I := 0 to n-1 do
     TargetArray[i]:=X[i];
end;

Procedure Vector.CopyYtoArray(var TargetArray:TArrSingle);
 var i:integer;
begin
 SetLength(TargetArray,n);
  for I := 0 to n-1 do
     TargetArray[i]:=Y[i];
end;

Procedure Vector.CopyXtoPArray(var TargetArray:PTArrSingle);
 var i:integer;
begin
 SetLength(TargetArray^,n);
  for I := 0 to n-1 do
     TargetArray^[i]:=X[i];
end;

Procedure Vector.CopyYtoPArray(var TargetArray:PTArrSingle);
 var i:integer;
begin
 SetLength(TargetArray^,n);
  for I := 0 to n-1 do
     TargetArray^[i]:=Y[i];
end;


Procedure Vector.CopyFromXYArrays(SourceXArray,SourceYArray:TArrSingle);
 var i:integer;
begin
 Clear();
 for I := 0 to min(High(SourceXArray),High(SourceYArray)) do
   Add(SourceXArray[i],SourceYArray[i]);
end;

Procedure Vector.CopyFromXYPArrays(SourceXArray,SourceYArray:PTArrSingle);
 var i:integer;
begin
 Clear();
 for I := 0 to min(High(SourceXArray^),High(SourceYArray^)) do
   Add(SourceXArray^[i],SourceYArray^[i]);
end;


Procedure Vector.CopyLimitedX (var Target:Vector;Xmin,Xmax:double);
 var i:integer;
begin
  Target.Clear;
  Target.T:=T;
  Target.name:=name;
  for I := 0 to High(X) do
    if (X[i]>=Xmin)and(X[i]<=Xmax) then
       Target.Add(X[i],Y[i])
end;

Procedure Vector.MultiplyY(const A:double);
 var i:integer;
begin
 if A=1 then Exit;
 for I := 0 to n - 1 do
  Y[i]:=Y[i]*A;
end;

Procedure Vector.PositiveX(var Target:Vector);
 var i:integer;
begin
 Target.SetLenVector(0);
 for I := 0 to n - 1 do
   if X[i]>=0 then
     Target.Add(X[i],Y[i]);
end;

Procedure Vector.PositiveY(var Target:Vector);
 var i:integer;
begin
 Target.SetLenVector(0);
 for I := 0 to n - 1 do
   if Y[i]>=0 then
     Target.Add(X[i],Y[i]);
end;

Procedure Vector.AbsX(var Target:Vector);
 var i:integer;
begin
 Copy(Target);
 for I := 0 to n - 1 do
     if Target.X[i]=0 then Target.Delete(i)
                      else
     Target.X[i]:=abs(Target.X[i]);
end;

Procedure Vector.AbsY(var Target:Vector);
 var i:integer;
begin
 Copy(Target);
 for I := 0 to n - 1 do
     if Target.Y[i]=0 then Target.Delete(i)
                      else
     Target.Y[i]:=abs(Target.Y[i]);
end;

Procedure Vector.NegativeX(var Target:Vector);
 var i:integer;
begin
 Target.SetLenVector(0);
 for I := 0 to n - 1 do
   if X[i]<0 then
     Target.Add(X[i],Y[i]);
end;

Procedure Vector.NegativeY(var Target:Vector);
 var i:integer;
begin
 Target.SetLenVector(0);
 for I := 0 to n - 1 do
   if Y[i]<0 then
     Target.Add(X[i],Y[i]);
end;

Procedure Vector.Write_File(sfile:string; NumberDigit:Byte=4);
var i:integer;
    Str:TStringList;
begin

  if n=0 then Exit;

  Str:=TStringList.Create;
  for I := 0 to High(X) do
     Str.Add(FloatToStrF(X[i],ffExponent,NumberDigit,0)+' '+
             FloatToStrF(Y[i],ffExponent,NumberDigit,0));
  Str.SaveToFile(sfile);
  Str.Free;
end;

Procedure Vector.Load_File(sfile:string);
  var F:TextFile;
    Xt,Yt:double;
begin
 Clear();
 if FileExists(sfile) then
  begin
   AssignFile(f,sfile);
   Reset(f);
   try
   while not(eof(f)) do
       begin
        readln(f,Xt,Yt);
        Add(Xt,Yt);
       end;
   except
    Clear();
   end;
   name:=sfile;
   CloseFile(f);
   N_begin:=0;
   N_end:=n;
  end;
end;

Procedure Vector.DeltaY(deltaVector:Vector);
 var i:integer;
begin
 if High(X)<>High(deltaVector.X) then Exit;
 for i := 0 to High(X) do
        Y[i]:=Y[i]-deltaVector.Y[i];
end;

Procedure Vector.Clear();
begin
  SetLenVector(0);
end;

Procedure Vector.Filling(Fun:TFun;Xmin,Xmax,deltaX:double;Parameters:array of double);
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
 for I := 0 to n - 1 do
  begin
    X[i]:=Xmin+i*deltaX;
    Y[i]:=Fun(X[i],Parameters);
  end;
end;


Procedure Vector.Filling(Fun: TFun; Xmin, Xmax: Double; Parameters: array of Double; Nstep: Integer);
begin
  if Nstep<1 then Clear()
    else if Nstep=1 then Filling(Fun,Xmin,Xmax,Xmax-Xmin+1,Parameters)
       else Filling(Fun,Xmin,Xmax,(Xmax-Xmin)/(Nstep-1),Parameters)
end;

Procedure Vector.Filling(Fun:TFun;Xmin,Xmax,deltaX:double);
begin
 Filling(Fun,Xmin,Xmax,deltaX,[]);
end;

Procedure Vector.Decimation(Np:word);
 {залишається лише 0-й, ?-й, 2N-й.... елементи,
          при вектор масив не міняється}
 var i:integer;
begin
  if (Np<=1)or(n<1) then Exit;
  i:=1;
  while(i*Np)<n do
   begin
    X[i]:=X[i*Np];
    Y[i]:=Y[i*Np];
    inc(i);
   end;
  SetLenVector(i);
end;

Procedure Vector.DigitalFiltr(a,b:TArrSingle;NtoDelete:word=0);
{змінюються масив Y на Ynew:
 Ynew[k]=a[0]*Y[k]+a[1]*Y[k-1]+...b[0]*Ynew[k-1]+b[1]*Ynew[k-2]...}
 var Yold:PTArrSingle;
     i:integer;
  j: Integer;
begin
 if (High(a)<0) then Exit;
 if NtoDelete>=Self.n then
   begin
     Self.Clear;
     Exit;
   end;

 new(Yold);
 CopyYtoPArray(Yold);
 for I := 0 to n - 1 do
  begin
   Y[i]:=0;
   for j := 0 to High(a) do
      if (i-j>=0) then Y[i]:=Y[i]+a[j]*Yold^[i-j]
                  else Break;
   for j := 0 to High(b) do
      if (i-j>0) then Y[i]:=Y[i]+b[j]*Y[i-j-1]
                  else Break;
  end;
 dispose(Yold);

 Self.DeleteNfirst(NtoDelete);
end;



end.

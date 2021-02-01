unit OlegGraph;
interface
uses OlegType, OlegMath, SysUtils, Dialogs, Classes, Series,
     Forms,Controls,WinProcs,OlegMaterialSamples, StdCtrls, IniFiles,
     OlegVector
//     {XP Win}
     ,VCLTee.TeEngine
     ;

Procedure ToFileFromArrays(NameFile:string;
                             Data:array of TArrSingle;
                             NumberDigit:Byte=4);

Procedure ToFileFromXYArrays(NameFile:string;
                             X,Y:array of double;
                             NumberDigit:Byte=4);

Procedure Write_File3Column(sfile:string; A:TVector;
                           Func:TFunDouble;NumberDigit:Byte=4);//overload;
{записує у файл з іменем sfile дані з масиву А,
третя колонка - результат Func(A^.Y[i],A^.X[i])
якщо A^.n=0, то запис у файл не відбувається;
NumberDigit - кількість значущих цифр}


Procedure ToFileFromTwoVector(NameFile:string;
                              Vector,Vector2:TVector;
                              NumberDigit:Byte=4);//overload;
{записує у файл з іменем NameFile дані з двох векторів
у чотири колонки;
якщо в обох масивах даних немає - запис не відбувається;
якщо масиви мають різну розмірність -
кількість рядків відповідатиме більшому файлу,
замість даних, яких недостає, буде записано нуль;
NumberDigit - кількість значущих цифр}



Procedure ToFileFromTwoSeries(NameFile:string;
                              Series,Series2:TCustomSeries;
                              NumberDigit:Byte=4);


Procedure Write_File_Series(sfile:string; Series:TCustomSeries;NumberDigit:Byte=4);
{записує у файл з іменем sfile дані з Series;
якщо кількість точок нульова або Series не створена,то запис у файл не відбувається;
NumberDigit - кількість значущих цифр}

Procedure GraphFill(Series:TCustomSeries;Func:TFunSingle;
                    x1,x2:double;Npoint:word);overload;
{заповнює Series значеннями Func(х) в діапазоні
від х1 до х2 з загальною кількістю точок Npoint+1}

Procedure GraphFill(Series:TCustomSeries;Func:TFunDouble;
                    x1,x2:double;Npoint:word;y0:double);overload;
{заповнює Series значеннями Func(х,y0) в діапазоні
від х1 до х2 з загальною кількістю точок Npoint+1}

Procedure FunctionToFile(sfile:string;Func:TFunDouble;
                    x1,x2:double;Npoint:word;y0:double);
{у файл з назвою sfile заносить значення Func(х,y0) в діапазоні
від х1 до х2 з загальною кількістю точок Npoint+1}


Procedure GraphAverage (Lines: array of TLineSeries; Minus:boolean=False;delX:double=0.002;
                         NumLines:integer=0; shiftX:double=0.002);
{зсувається графік, що знаходиться
в елементі масиву з номером  NumLines,
по абсциссі на величину shiftX;
якщо  NumLines=0, то зсуву не відбувається;
після цього
в нульовий елемент масиву вносить
середнє арифметичне графіків,
що знаходяться в інших;
вибирається найменший діапазон абсцис серед всіх
графіків;
крок між абсцисами сусідніх точок - delX}



Function Voc_Isc_Pm_Vm_Im(mode:byte;F:TFun_IV;Data:array of double;
                          Rsh:double=1e12;Iph:double=0):double;
{обчислюється Voc (mode=1),
Isc(mode=2)
Pm (mode=3)
Vm (mode=4)
Im (mode=5)
по відомим значенням параметрів в Data, Rsh, Iph,
вважаючи, що  ВАХ описується функцією F.
Використовується метод дихотомії.
}

implementation

uses
  Math;


Procedure ToFileFromArrays(NameFile:string;
                           Data:array of TArrSingle;
                           NumberDigit:Byte=4);
var i,j,maxCount:integer;
    Str:TStringList;
    tempString:string;
begin
if High(Data)<0 then Exit;
maxCount:=High(Data[0]);
for I := 1 to High(Data) do
 maxCount:=max(maxCount,High(Data[i]));
if maxCount<0 then Exit;

Str:=TStringList.Create;
for I := 0 to maxCount do
  begin
   tempString:='';
     for j := 0 to High(Data) do
      if High(Data[j])>=i
        then tempString:=tempString+FloatToStrF(Data[j][i],ffExponent,NumberDigit,0)+' '
        else tempString:=tempString+'0 ';
   Str.Add(Trim(tempString));
  end;

Str.SaveToFile(NameFile);
Str.Free;
end;

Procedure ToFileFromXYArrays(NameFile:string;
                             X,Y:array of double;
                             NumberDigit:Byte=4);
var i,maxCount:integer;
    Str:TStringList;
    tempString:string;
begin
  maxCount:=max(High(X),High(Y));
  if maxCount<0 then Exit;

  Str:=TStringList.Create;
  for I := 0 to maxCount do
    begin
     tempString:='';
       if High(X)>=i
          then tempString:=tempString+FloatToStrF(X[i],ffExponent,NumberDigit,0)+' '
          else tempString:=tempString+'0 ';
       if High(Y)>=i
          then tempString:=tempString+FloatToStrF(Y[i],ffExponent,NumberDigit,0)
          else tempString:=tempString+'0';
     Str.Add(tempString);
    end;

  Str.SaveToFile(NameFile);
  Str.Free;
end;

Procedure Write_File3Column(sfile:string; A:TVector;
                           Func:TFunDouble;NumberDigit:Byte=4);overload;
var i:integer;
    Str:TStringList;
begin
  if A.Count=0 then Exit;
  Str:=TStringList.Create;
  for I := 0 to A.HighNumber do
     Str.Add(A.PoinToString(i,NumberDigit)+' '+
             FloatToStrF(Func(A.Y[i],A.X[i]),ffExponent,NumberDigit,0));
  Str.SaveToFile(sfile);
  Str.Free;
end;

Procedure ToFileFromTwoVector(NameFile:string;
                              Vector,Vector2:TVector;
                              NumberDigit:Byte=4);overload;
var i,maxCount,minCount:integer;
    Str:TStringList;
    tempString:string;
begin
maxCount:=max(Vector.Count,Vector2.Count);
if maxCount=0 then Exit;
Str:=TStringList.Create;
minCount:=min(Vector.Count,Vector2.Count);
for I := 0 to minCount-1 do
   Str.Add(Vector.PoinToString(i,NumberDigit)+' '+
           Vector2.PoinToString(i,NumberDigit));
for I := minCount to maxCount-1 do
   begin
    tempString:='';
    if i>(Vector.Count-1) then
      tempString:=tempString+'0 0 '
                       else
      tempString:=tempString+Vector.PoinToString(i,NumberDigit);
    if i>(Vector2.Count-1) then
      tempString:=tempString+'0 0'
                       else
      tempString:=tempString+Vector2.PoinToString(i,NumberDigit);
    Str.Add(tempString);
   end;
Str.SaveToFile(NameFile);
Str.Free;
end;


Procedure ToFileFromTwoSeries(NameFile:string;
                              Series,Series2:TCustomSeries;
                              NumberDigit:Byte=4);
var i,maxCount,minCount:integer;
    Str:TStringList;
    tempString:string;
begin
maxCount:=max(Series.Count,Series2.Count);
if maxCount=0 then Exit;
Str:=TStringList.Create;
minCount:=min(Series.Count,Series2.Count);
for I := 0 to minCount-1 do
   Str.Add(FloatToStrF(Series.XValue[i],ffExponent,NumberDigit,0)+' '+
           FloatToStrF(Series.YValue[i],ffExponent,NumberDigit,0)+' '+
           FloatToStrF(Series2.XValue[i],ffExponent,NumberDigit,0)+' '+
           FloatToStrF(Series2.YValue[i],ffExponent,NumberDigit,0));

for I := minCount to maxCount-1 do
   begin
    tempString:='';
    if i>(Series.Count-1) then
      tempString:=tempString+'0 0 '
                       else
      tempString:=tempString+FloatToStrF(Series.XValue[i],ffExponent,NumberDigit,0)+' '+
                             FloatToStrF(Series.YValue[i],ffExponent,NumberDigit,0)+' ';
    if i>(Series2.Count-1) then
      tempString:=tempString+'0 0'
                       else
      tempString:=tempString+FloatToStrF(Series2.XValue[i],ffExponent,NumberDigit,0)+' '+
                             FloatToStrF(Series2.YValue[i],ffExponent,NumberDigit,0);
    Str.Add(tempString);
   end;
Str.SaveToFile(NameFile);
Str.Free;
end;

Procedure Write_File_Series(sfile:string; Series:TCustomSeries;NumberDigit:Byte=4);
var i:integer;
    Str:TStringList;
begin
if (not Assigned(Series)) or (Series.Count<1) then Exit;

Str:=TStringList.Create;
for I := 0 to Series.Count-1 do
   Str.Add(FloatToStrF(Series.XValue[i],ffExponent,NumberDigit,0)+' '+
           FloatToStrF(Series.YValue[i],ffExponent,NumberDigit,0));
Str.SaveToFile(sfile);
Str.Free;
end;

Procedure GraphFill(Series:TCustomSeries;Func:TFunSingle;
                    x1,x2:double;Npoint:word);
{заповнює Series значеннями Func(х) в діапазоні
від х1 до х2 з загальною кількістю точок Npoint+1}
var x,dx:double;
    i:word;
begin
Series.Clear;
if Npoint=0 then Exit;
if Npoint>65534 then Npoint:=65534;
dx:=(x2-x1)/Npoint;
for I := 0 to Npoint do
  begin
    x:=x1+dx*i;
    Series.AddXY(x,Func(x));
  end;

end;

Procedure GraphFill(Series:TCustomSeries;Func:TFunDouble;
                    x1,x2:double;Npoint:word;y0:double);overload;
{заповнює Series значеннями Func(х,y0) в діапазоні
від х1 до х2 з загальною кількістю точок Npoint+1}
var x,dx:double;
    i:word;
begin
Series.Clear;
if Npoint>65534 then Npoint:=65534;
dx:=(x2-x1)/Npoint;
for I := 0 to Npoint do
  begin
    x:=x1+dx*i;
    Series.AddXY(x,Func(x,y0));
  end;

end;


Procedure FunctionToFile(sfile:string;Func:TFunDouble;
                    x1,x2:double;Npoint:word;y0:double);
{у файл з назвою sfile заносить значення Func(х,y0) в діапазоні
від х1 до х2 з загальною кількістю точок Npoint+1}
 var Series:TCustomSeries;
begin
 Series:=TCustomSeries.Create(nil);
 GraphFill(Series,Func,x1,x2,Npoint,y0);
 Write_File_Series(sfile,Series);
 Series.Free;
end;


Procedure GraphAverage (Lines: array of TLineSeries;Minus:boolean=False;
                         delX:double=0.002;
                         NumLines:integer=0; shiftX:double=0.002);
{зсувається графік, що знаходиться
в елементі масиву з номером  NumLines,
по абсциссі на величину shiftX;
якщо  NumLines=0, то зсуву не відбувається;
після цього
в нульовий елемент масиву вносить
середнє арифметичне графіків,
що знаходяться в інших;
вибирається найменший діапазон абсцис серед всіх
графіків;
крок між абсцисами сусідніх точок - delX}
var VectorArr: array of TVector;
    i:word;
    Xmin,Xmax,x,y:double;
begin

if (High(Lines)<1)or(NumLines>High(Lines))
    or(NumLines<0)  then Exit;

try
 Lines[0].Clear;
 SetLength(VectorArr,High(Lines));
 for i:= 0 to High(VectorArr) do
   begin
   VectorArr[i]:=TVector.Create;
   VectorArr[i].ReadFromGraph(Lines[i+1]);
   VectorArr[i].Sorting;
   end;
 if (NumLines>0) then
   begin
    for i:= 0 to VectorArr[NumLines-1].HighNumber do
     VectorArr[NumLines-1].X[i]:=VectorArr[NumLines-1].X[i]+shiftX;
     VectorArr[NumLines-1].WriteToGraph(Lines[NumLines]);
   end;

 Xmin:=VectorArr[0].X[0];
 Xmax:=VectorArr[0].X[VectorArr[0].HighNumber];
  for i:= 1 to High(VectorArr) do
    begin
     if Xmin<VectorArr[i].X[0] then Xmin:=VectorArr[i].X[0];
     if Xmax>VectorArr[i].X[VectorArr[i].HighNumber]
                   then Xmax:=VectorArr[i].X[VectorArr[i].HighNumber];
    end;
  x:=Xmin;
  repeat
    y:=0;
    for i:= 0 to High(VectorArr) do
      if Minus then y:=y+Power(-1,i)*VectorArr[i].Yvalue(x)
               else y:=y+VectorArr[i].Yvalue(x);

    Lines[0].AddXY(x,y/(High(VectorArr)+1));
    x:=x+delX;
  until x>Xmax;

 for I := 0 to High(VectorArr) do VectorArr[i].Free;
finally
end;//try
end;



Function Voc_Isc_Pm_Vm_Im(mode:byte;F:TFun_IV;Data:array of double;
                          Rsh:double=1e12;Iph:double=0):double;
{обчислюється Voc (mode=1),
Isc(mode=2)
Pm (mode=3)
Vm (mode=4)
Im (mode=5)
по відомим значенням параметрів в Data, Rsh, Iph,
вважаючи, що  ВАХ описується функцією F.
Використовується метод дихотомії.
}
 function F_Voc(v:double):double;
   begin
     Result:=F(v,Data,0)+v/Rsh-Iph;
   end;
 const delVm=0.0001;
 var i:integer;
     a,b,c,Fa,Fb,Im:double;
begin
 Result:=ErResult;
 if mode<1 then Exit;
 if mode>5 then Exit;
 if (Rsh<=0) or (Rsh=ErResult) then Exit;
 if (Iph<0) or (Iph=ErResult) then Exit;
 for I := 0 to High(Data) do
   if (Data[i]<0) or (Data[i]=ErResult) then Exit;

 if mode=2 then
  begin
    Result:=abs(Full_IV(F,0,Data,Rsh,Iph));
    Exit;
  end;

 if mode=1 then
  begin
    a:=0;
    Fa:=F_Voc(a);
    b:=a;
    repeat
     b:=b+0.01;
     Fb:=F_Voc(b);
    until Fb*Fa<=0;

    i:=0;
    repeat
      inc(i);
      c:=(a+b)/2;
      Fb:=F_Voc(c);
      Fa:=F_Voc(a);
      if (Fb*Fa<=0)
       then b:=c
       else a:=c;
    until (i>1e5)or IsEqual(a,b,1e-4);
    if (i>1e5) then Exit;
    Result:=c;
 end; //if mode=1 then

 if mode in [3,4,5] then
  begin
    a:=0;
    Fa:=0;
    repeat
      b:=a+delVm;
      Im:=Full_IV(F,b,Data,Rsh,Iph);
      Fb:=b*Im;
      if Fb<Fa then
       begin
         a:=b;
         Fa:=Fb;
       end
               else
       Break;
    until (False);
   case mode of
     4:Result:=a;
     5:Result:=abs(Im);
     else  Result:=abs(Fa);
   end;
 end; //if mode=3 then

end;

end.

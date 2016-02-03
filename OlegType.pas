unit OlegType;


interface
//uses Windows,Messages,SysUtils,Forms;
 uses IniFiles,SysUtils;

const Kb=8.625e-5; {стала Больцмана, []=eV/K}
      Eps0=8.85e-12; {діелектрична стала, []=Ф/м}
      Qelem=1.6e-19; {елементарний заряд, []=Кл}
      Hpl=1.05457e-34; {постійна Планка перекреслена, []=Дж c}
      m0=9.11e-31; {маса електрону []=кг}
      ErResult=555;
var   StartValue,EndValue,Freq:Int64;

//QueryPerformanceCounter(StartValue);
//
//QueryPerformanceCounter(EndValue);
//QueryPerformanceFrequency(Freq);
//showmessage('tics='+inttostr(EndValue-StartValue)+#10+#13+
//             'time='+floattostr((EndValue-StartValue)/Freq)
//             +' s'+#10+#13+
//                'freq+'+inttostr(Freq));

type

    Vector=record
         X:array of double;
         Y:array of double;
         n:integer; //кількість точок, в масиві буде нумерація
                 //від 0 до n-1
         name:string; // назва файлу, звідки завантажені дані
         T:Extended;  // температура, що відповідає цим даним
         time:string; //час створення файлу, година:хвилини
         N_begin:integer; //номери початкової і кінцевої точок
         N_end:integer;  //даних, які відображаються на графіку
         Procedure SetLenVector(Number:integer);
         procedure ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
         procedure WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
         procedure Add(newX,newY:double);
         procedure Delete(Ndel:integer);
         {видання з масиву точки з номером Ndel}
         Procedure Sorting (Increase:boolean=True);
         {процедура сортування (методом бульбашки)
          точок по зростанню (при Increase=True) компоненти Х}
         Procedure DeleteDuplicate;
         {видаляються точки, для яких значення абсциси вже зустрічалося}
         Procedure DeleteErResult;
         {видаляються точки, для абсциса чи ордината рівна ErResult}
         end;

    PVector=^Vector;

  T2DArray=array of array of double;

  SysEquation=record
      A:T2DArray;//array of array of double;
      f:array of double;
      x:array of double;
      N:integer;
     end;
    {тип використовується при розв'язку
    системи лінійних рівнянь
    А - масив коефіцієнтів
    f - вектор вільних членів
    x - вектор невідомих
    N - кількість рівнянь}

  PSysEquation=^SysEquation;

  TFun1D=Function(A:Pvector; Variab:array of double;
                  Param:array of double;
                  var Rez:array of double):word;
  {тип для функції, яка використовується в методі
  Ньютона, її задача повернути масив чисел Rez, що
  є значеннями системи рівнянь при змінних,
  рівних значенням в Variab;
  Param - масив параметрів, які входять до наших рівнянь;
  A - вектор, по даним якого розраховуються функції,
  введено для можливості використання
  функцій більш загального типу;
  при вдалій операцій функція повертає 0,
  при невдалій - додатне число, а в Rez всі значення ErResult}

  TFun2D=Function(A:Pvector; Variab:array of double;
                  Param:array of double;
                  var Rez:T2DArray):word;
  {тип для функції, яка використовується в методі
  Ньютона, її задача повернути двомірний масив чисел Rez, що
  є значеннями якобіана (набору функцій)
  від системи рівнянь при змінних,
  рівних значенням в Variab;
  Param - масив параметрів, які використовуються у
  наборі функцій;
  A - вектор, по даним якого розраховуються функції,
  введено для можливості використання
  функцій більш загального типу;
  при вдалій операцій функція повертає 0,
  при невдалій - додатне число, а в Rez всі значення ErResult}

  TFunSingle=Function(x:double):double of object;
  PTFunSingle=^TFunSingle;

  TFunDouble=Function(x,y:double):double of object;
  PTFunDouble=^TFunDouble;

  TFunEvolution=Function(AP:Pvector; Variab:array of double):double;
  PFunEvolution=^TFunEvolution;

  TArrSingle=array of double;
  PTArrSingle=^TArrSingle;

  TArrArrSingle=array of TArrSingle;
  PClassroom=^TArrArrSingle;

  TArrStr=array of string;

  IRE=array[1..3] of double;
  {масив використовується при апроксимації
   експонентою y=I0(exp(x/E)-1)+x/R;
   [1] - I0
   [2] - R
   [3] - E}

   IRE2=array [1..3,1..3] of double;
   //тип використовується при апроксимації,
   //матриця 3х3

  Limits=record     //тип для відображення частини графіку
         MinXY:0..1; //0 - встановлене мінімальне значення абсциси
         MaxXY:0..1; //1 - встановлене максимальне значення ординати
         MinValue:array [0..1] of double;
         MaxValue:array [0..1] of double;
             //граничні величини для координат графіку
         end;

{}  TDiapazon=class //(TObject)// тип для збереження тих меж, в яких
                           // відбуваються апроксимації різних функцій
         private
           fXMin:double;
           fYMin:double;
           fXMax:double;
           fYMax:double;
           fBr:Char; //'F' коли діапазон для прямої гілки
                     //'R' коли діапазон для зворотньої гілки
           function GetData(Index:integer):double;
           procedure SetData(Index:integer; value:double);
           procedure SetDataBr(value:Char);

         public
           property XMin:double Index 1 read GetData write SetData;
           property YMin:double Index 2 read GetData write SetData;
           property XMax:double Index 3 read GetData write SetData;
           property YMax:double Index 4 read GetData write SetData;
           property Br:Char read fBr write SetDataBr;
           procedure Copy (Souсe:TDiapazon);
           procedure ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
           procedure WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
         end;

   Curve3=class //(TObject)// тип для збереження трьох параметрів,
                           // по яким можна побудувати різні криві тощо
         private
           fA:double;
           fB:double;
           fC:double;
           function GetData(Index:integer):double;
           procedure SetData(Index:integer; value:double);

         public
           property A:double Index 1 read GetData write SetData;
           property B:double Index 2 read GetData write SetData;
           property C:double Index 3 read GetData write SetData;
           Constructor Create; OVERLOAD;
           Constructor Create(x:double;y:double=1;z:double=1); overload;
           function GS(x:double;y0:double=0):double;
           {повертає значення функції Гауса
           F(x)=y0+A*exp(-(x-B)^2/(2*C^2));
           якщо С=0, то заміняється на С=1}
           function GS_Sq:double;
           {повертає площу під кривою Гауса,
           якщо її побудувати по параметрам даного
           класу: А - висота максимуму,
           В - середнє значення,
           С - ширина розподілу}
           function is_Gaus:boolean;
           {повертає, чи можна побудувати криву Гауса
           по даним параметрам; фактично, перевіряється лише те, щоб
           С не було рівним нулеві}
           function Parab(x:double):double;
           {повертає значення поліному другого
           ступеня F(x)=A+B*x+C*x^2}
           procedure Copy (Souсe:Curve3);
           {копіює значення полів з Souсe в даний}
         end;


Procedure SetLenVector(A:Pvector;n:integer);
{встановлюється кількість точок у векторі А}

 Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                     Value:double; Default:double=ErResult);overload;
{записує в .ini-файл значення тільки якщо воно не дорівнює Default}

Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:integer; Default:integer=ErResult);overload;
{записує в .ini-файл значення тільки якщо воно не дорівнює Default}

Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:string; Default:string='');overload;
{записує в .ini-файл значення тільки якщо воно не дорівнює Default}

Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:Boolean);overload;
{записує в .ini-файл значення тільки якщо воно дорівнює True}

implementation

function TDiapazon.GetData(Index:integer):double;
begin
case Index of
 1:Result:=fXMin;
 2:Result:=fYMin;
 3:Result:=fXMax;
 4:Result:=fYMax;
 else Result:=0;
 end;
end;

procedure TDiapazon.SetData(Index:integer; value:double);
begin
case Index of
 1: if (value<-0.005)or(value=ErResult) then fXMin:=-0.005//0.001
                else fXMin:=value;
 2: if (value<0)or(value=ErResult)  then fYMin:=0
                else fYMin:=value;
 3: if (value<=fXmin)and(fXMin<>ErResult) then fXMax:=ErResult
                      else fXMax:=value;
 4: if (value<=fYmin)and(fYMin<>ErResult) then fYMax:=ErResult
                      else fYMax:=value;
 end;
end;

procedure TDiapazon.SetDataBr(value:char);
begin
if value='R' then fBr:=value
             else fBr:='F';
end;

Procedure TDiapazon.Copy (Souсe:TDiapazon);
           {копіює значення полів з Souсe в даний}
begin
XMin:=Souсe.Xmin;
YMin:=Souсe.Ymin;
XMax:=Souсe.Xmax;
YMax:=Souсe.Ymax;
Br:=Souсe.Br;
end;

procedure TDiapazon.ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
begin
  XMin:=ConfigFile.ReadFloat(Section,Ident+'XMin',0.001);
  YMin:=ConfigFile.ReadFloat(Section,Ident+'YMin',0);
  XMax:=ConfigFile.ReadFloat(Section,Ident+'XMax',ErResult);
  YMax:=ConfigFile.ReadFloat(Section,Ident+'Ymax',ErResult);
  Br:=ConfigFile.ReadString(Section,Ident+'Br','F')[1];
end;

procedure TDiapazon.WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
begin
 WriteIniDef(ConfigFile,Section,Ident+'XMin',Xmin,0.001);
 WriteIniDef(ConfigFile,Section,Ident+'YMin',Ymin,0);
 WriteIniDef(ConfigFile,Section,Ident+'XMax',Xmax);
 WriteIniDef(ConfigFile,Section,Ident+'Ymax',Ymax);
 ConfigFile.WriteString(Section,Ident+'Br',Br);
// WriteIniDef(ConfigFile,Section,Ident+'Br',Br,'F');
end;


function Curve3.GetData(Index:integer):double;
begin
case Index of
 1:Result:=fA;
 2:Result:=fB;
 3:Result:=fC;
 else Result:=0;
 end;
end;

procedure Curve3.SetData(Index:integer; value:double);
begin
case Index of
 1: fA:=value;
 2: fB:=value;
 3: fC:=value;
 end;
end;

Constructor Curve3.Create;
 begin
  Inherited {Create};
  self.A:=1;
  self.B:=1;
  self.C:=1;
 end;


Constructor Curve3.Create(x:double;y:double=1;z:double=1);
 begin
  self.A:=x;
  self.B:=y;
  self.C:=z;
 end;

Function Curve3.GS(x:double;y0:double=0):double;
           {повертає значення функції Гауса
           F(x)=y0+A*exp(-(x-B)^2/(2*C^2));
           якщо С=0, то заміняється на С=1}
 begin
  if C=0 then C:=1;
  Result:=y0+A*exp(-sqr((x-B))/2/sqr(C));
 end;


Function Curve3.GS_Sq:double;
           {повертає площу під кривою Гауса,
           якщо її побудувати по параметрам даного
           класу: А - висота максимуму,
           В - середнє значення,
           С - ширина розподілу}
 begin
   Result:=A*C*sqrt(2*3.14);
 end;

Function Curve3.is_Gaus:boolean;
           {повертає, чи можна побудувати криву Гауса
           по даним параметрам; фактично, перевіряється лише те, щоб
           С не було рівним нулеві}
 begin
   Result:=not(C=0);
 end;

Function Curve3.Parab(x:double):double;
           {повертає значення поліному другого
           ступеня F(x)=A+B*x+C*x^2}
 begin
   Result:=A+B*x+C*sqr(x);
 end;

Procedure Curve3.Copy (Souсe:Curve3);
           {копіює значення полів з Souсe в даний}
begin
  A:=Souсe.A;
  B:=Souсe.B;
  C:=Souсe.C;
end;

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
//    begin
     Self.Delete(PointToDelete);
//     PointToDelete:=-1;
//    end;
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


Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:double; Default:double=ErResult);
{записує в .ini-файл значення тільки якщо воно не дорівнює Default}
begin
 if (Value<>Default) then ConfigFile.WriteFloat(Section,Ident,Value);
end;

Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:integer; Default:integer=ErResult);
{записує в .ini-файл значення тільки якщо воно не дорівнює Default}
begin
 if (Value<>Default) then ConfigFile.WriteInteger(Section,Ident,Value);
end;

Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:string; Default:string='');overload;
{записує в .ini-файл значення тільки якщо воно не дорівнює Default}
begin
 if (Value<>Default) then ConfigFile.WriteString(Section,Ident,Value);
end;

Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:Boolean);
{записує в .ini-файл значення тільки якщо воно дорівнює True}
begin
 if Value then ConfigFile.WriteBool(Section,Ident,Value);
end;

end.

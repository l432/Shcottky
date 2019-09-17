unit OlegVectorManipulation;

interface
 uses OlegVectorNew,OlegTypeNew, OlegMaterialSamplesNew;


type

  TSplainCoef=record
         B:double;
         C:double;
         D:Double
         end;
  TSplainCoefArray=array of TSplainCoef;


    TVectorManipulation=class
      private
       fVector:TVectorNew;
//       function GetVector: TVectorNew;
       procedure SetVector(const Value: TVectorNew);
      public
       property Vector:TVectorNew read fVector write SetVector;
       Constructor Create(ExternalVector:TVectorNew);overload;
       Constructor Create();overload;
       procedure Free;
    end;

   TProcTarget=Procedure(var Target:TVectorNew) of object;

   TVectorTransform=class(TVectorManipulation)
    private
     Procedure InitTarget(var Target:TVectorNew);
     Procedure InitTargetToFun(var Target:TVectorNew);
      {підготовча процедура до побудови багатьох функцій;
      визначає  Target.N_begin, починаючи з якого
      у Vector значення Х>0.001 та Y>0,
      встановлює необхідний розмір Target;
      саме заповнення Target не відбувається}

     Procedure CopyLimited (Coord:TCoord_type;var Target:TVectorNew;Clim1, Clim2:double);
     procedure Branch(Coord:TCoord_type;var Target:TVectorNew;
                      const IsPositive:boolean=True;
                      const IsRigorous:boolean=True);
     procedure Module(Coord:TCoord_type;var Target:TVectorNew);
    public
     Procedure CopyLimitedX (var Target:TVectorNew;Xmin,Xmax:double);
       {копіюються з даного вектора в Target
        - точки, для яких абсциса в діапазоні від Xmin до Xmax включно
         - поля Т та name}
     Procedure CopyLimitedY (var Target:TVectorNew;Ymin,Ymax:double);
     procedure AbsX(var Target:TVectorNew);
         {заносить в Target точки, для яких X дорівнює модулю Х даного
         вектора, а Y таке саме; якщо Х=0, то точка викидається}
     procedure AbsY(var Target:TVectorNew);
         {заносить в Target точки, для яких Y дорівнює модулю Y даного
         вектора, а X таке саме; якщо Y=0, то точка викидається}
     Procedure PositiveX(var Target:TVectorNew);//overload;
         {заносить в Target ті точки, для яких X більше нуля}
     procedure PositiveY(var Target:TVectorNew);
         {заносить в Target ті точки, для яких Y більше нуля}
     Procedure ForwardX(var Target:TVectorNew);
         {заносить в Target ті точки, для яких X більше або рівне нулю}
     Procedure ForwardY(var Target:TVectorNew);
     procedure NegativeX(var Target:TVectorNew);
         {заносить в Target ті точки, для яких X менше нуля}
     procedure NegativeY(var Target:TVectorNew);
         {заносить в Target ті точки, для яких Y менше нуля}
     Procedure ReverseX(var Target:TVectorNew);
         {заносить в Target ті точки, для яких X менше або рівне нулю}
     Procedure ReverseY(var Target:TVectorNew);
     Procedure ReverseIV(var Target:TVectorNew);
     {записує у Target тільки ті точки, які відповідають
     зворотній ділянці ВАХ (для яких координата X менше нуля),
     причому записує модуль координат}

     Procedure Splain3(beg:double; step:double; var Target:TVectorNew);
      {в Target результат апроксимації даних
      з використанням кубічних сплайнів,
      починаючи з точки з координатою
      beg і з кроком step;
      якщо початок вибрано неправильно
      (не потрапляє в діапазон зміни абсциси вектора),
      то в результуючому векторі довжина нульова}
     Function YvalueSplain3(Xvalue:double):double;
    {функція розрахунку значення функції в точці Xvalue використовуючи
     кубічні сплайни, побудовані на основі набору даних в масиві V
     Result=Ai+Bi(X-Xi)+Ci(X-Xi)^2+Di(X-Xi)^3 при Xi-1<=X<=Xi}
     Function YvalueLagrang(Xvalue:double):double;
     {функція розрахунку значення функції в точці Xvalue
      використовуючи поліном Лагранжа}
     Function  ImpulseNoiseSmoothing(const Coord:TCoord_type): Double;

     Function ImpulseNoiseSmoothingByNpoint(const Coord:TCoord_type;
                                       Npoint:Word=0): Double;

      {розраховується середнє значення на масиві даних з врахуванням
      можливих імпульсних шумів,
      на відміну від ImpulseNoiseSmoothing дані розбиваються на порції
      по Npoint штук на наборі яких розраховується середнє,
      потім середні розбиваються на порції ....}
     Procedure ImNoiseSmoothedArray(Target:TVectorNew;Npoint:Word=0);
      {в Target записується результата
      зглажування (див ImpulseNoiseSmoothingByNpoint) Source
      по Npoint точкам}
     Procedure Itself(ProcTarget:TProcTarget);
     {дозволяє змінювати власний Vector}
     Procedure Smoothing (var Target:TVectorNew);
      {в Target розміщується сглажена функція даних
      у Vector;
      а саме проводиться усереднення по трьом точкам,
      причому усереднення з ваговими коефіцієнтами,
      які визначаються розподілом Гауса з дисперсією 0.6;
      якщо у вихідному масиві кількість точок менша трьох,
      то у результуючому буде нульова кількість}
     Function DerivateAtPoint(PointNumber:integer):double;
     {знаходження похідної від функції, яка записана
     у Vector в точці з індексом PointNumber}
     Procedure Derivate (var Target:TVectorNew);
      {в Target розміщується похідна від значень, розташованих
      у Vector;
      якщо у вихідному масиві кількість точок менша трьох,
      то у результуючому буде нульова кількість}
     Procedure ChungFun(var Target:TVectorNew);
      {записує в Target Chung-функцію, побудовану по даним з Vector}
     Procedure WernerFun(var Target:TVectorNew);
      {записує в Target функцію Вернера}
     Procedure MikhAlpha_Fun(var Target:TVectorNew);
      {записує в Target Альфа-функцію (метод Міхелешвілі),
      Alpha=d(ln I)/d(ln V)}
     Procedure MikhBetta_Fun(var Target:TVectorNew);
      {записує в Target Бетта-функцію (метод Міхелешвілі),
      Betta = d(ln Alpha)/d(ln V)
      P.S. в статті ця функція називається Гамма}
     Procedure MikhN_Fun(var Target:TVectorNew);
      {записує в Target залежність фактору неідеальності від
      прикладеної напруги, пораховану за методом
      метод Міхелешвілі;
      n = q V (Alpha - 1) [1 + Betta/(Alpha-1)] / k T Alpha^2}
     Procedure MikhRs_Fun(var Target:TVectorNew);
      {записує в Target залежність послідовного опору від
      прикладеної напруги, пораховану за методом  Міхелешвілі;
      Rs = V (1- Betta) / I Alpha^2}
     Procedure HFun(var Target:TVectorNew; DD: TDiod_Schottky; N: Double);
      {записує в Target H-функцію
      DD - діод, N - фактор неідеальності}
     Procedure NordeFun(var Target:TVectorNew; DD: TDiod_Schottky; Gam: Double);
      {записує в Target функцію Норда;
      Gam - показник гамма (див формулу)}

   end;


Function Kub (x:double;coef:array of double):double;overload;
{повертає coef[0]+coef[1]*(x-coef[4])+
                  coef[2]*(x-coef[4])^2+
                  coef[3]*(x-coef[4])^3;
потрібно, зокрема, при розрахуванні сплайнів}

Function Kub(x:double;
             Point:TPointDouble;
             SplainCoef:TSplainCoef):double;overload;

Procedure SplainCoefCalculate(V:TVectorNew;var SplainCoef:TSplainCoefArray);
{розраховуються кокфіцієнтів сплайцнів для апроксимації даних в Vector}

//Function DerivateLagr(x,x1,x2,x3,y1,y2,y3:double):double;
Function DerivateLagr(x:double;Point1,Point2,Point3:TPointDouble):double;overload;
  {допоміжна функція для знаходження похідної -
  похідна від поліному Лагранжа, проведеного через
  три точки}
Function DerivateLagr(Point1,Point2,Point3:TPointDouble):double;overload;
{в центральній точці}

Function DerivateTwoPoint(Point1,Point2:TPointDouble):double;


implementation

uses
  Math, Dialogs, SysUtils;




{ TVectorManipulation }

constructor TVectorManipulation.Create(ExternalVector: TVectorNew);
begin
//  inherited Create;
//  fVector:=TVectorNew.Create;
  Create();
  SetVector(ExternalVector);
end;

constructor TVectorManipulation.Create;
begin
  inherited Create;
  fVector:=TVectorNew.Create;
end;

procedure TVectorManipulation.Free;
begin
 fVector.Free;
 inherited Free;
end;

//function TVectorManipulation.GetVector: TVectorNew;
//begin
//// Result:=TVectorNew.Create;
//// Result.Clear;
// fVector.Copy(Result);
//end;

procedure TVectorManipulation.SetVector(const Value: TVectorNew);
begin
 Value.Copy(fVector);
end;


{ TVectorTransform }

procedure TVectorTransform.MikhAlpha_Fun(var Target: TVectorNew);
 var i:word;
     temp:TVectorTransform;
     verytemp:TVectorNew;
begin
 InitTargetToFun(Target);
 if Target.Count=0 then Exit;
 verytemp:=TVectorNew.Create;
 InitTargetToFun(verytemp);

 temp:=TVectorTransform.Create(verytemp);
 verytemp.Free;
 for I := 0 to Target.HighNumber do
   begin
     temp.Vector.X[i]:=ln(Vector.X[i+Target.N_begin]);
     temp.Vector.Y[i]:=ln(Vector.Y[i+Target.N_begin]);
   end;
{в temp функція ln I = f(ln V)}

 for I := 0 to Target.HighNumber do
   begin
     Target.Y[i]:=temp.DerivateAtPoint(i);;
     Target.X[i]:=Vector.X[i+Target.N_begin];
   end;
 temp.Free;
 if Target.Count<3 then
         begin
           Target.Clear;
           Exit;
         end;

  repeat
  if Target.Y[0]>Target.Y[1] then
    begin
      Target.DeletePoint(0);
      Target.N_begin:=Target.N_begin+1;
      if Target.Count<3 then
               begin
                 Target.Clear;
                 Exit;
               end;
    end
                  else Break;
  until false;

  i:=0;
  repeat
  if Target.Y[i]<=0 then
    begin
      Target.DeletePoint(i);
      Target.N_begin:=Target.N_begin+1;
      if Target.Count<3 then
               begin
                 Target.Clear;
                 Exit;
               end;
    end;
  Inc(i);
  until (i>=Target.Count);
end;

procedure TVectorTransform.MikhBetta_Fun(var Target: TVectorNew);
var temp:TVectorTransform;
    i:word;
begin
  MikhAlpha_Fun(Target);
  if Target.Count=0 then Exit;
  temp:=TVectorTransform.Create(Target);
  temp.Itself(temp.Smoothing);
  for I := 0 to Target.HighNumber do
     begin
       temp.Vector.X[i]:=ln(temp.Vector.X[i]);
       temp.Vector.Y[i]:=ln(temp.Vector.Y[i]);
     end;
  {в temp функція ln Aipha = f(ln V)}
  for I := 0 to Target.HighNumber do Target.Y[i]:=temp.DerivateAtPoint(i);
  temp.Vector:=Target;
  temp.Itself(temp.Smoothing);
  temp.Itself(temp.Smoothing);
  temp.Vector.Copy(Target);
  temp.Free;

end;

procedure TVectorTransform.MikhN_Fun(var Target: TVectorNew);
var bet:TVectorNew;
    i:word;
begin
//  InitTarget(Target);
//  if Target.T=0 then Exit;

  MikhAlpha_Fun(Target);
  if Target.T=0 then Exit;
  if Target.Count=0 then Exit;

  MikhBetta_Fun(bet);
  for I := 0 to Target.HighNumber do
    Target.Y[i]:=Target.X[i]*(Target.Y[i]-1)*(1+bet.Y[i]/(Target.Y[i]-1))/Kb/Target.T/sqr(Target.Y[i]);

  bet.Free;

end;

procedure TVectorTransform.MikhRs_Fun(var Target: TVectorNew);
var bet:TVectorNew;
    i:word;
begin
  MikhAlpha_Fun(Target);
  if Target.Count=0 then Exit;
  MikhBetta_Fun(bet);
  for I := 0 to Target.HighNumber do
    Target.Y[i]:=Target.X[i]*(1-bet.Y[i])/Vector.Y[i+Target.N_begin]/sqr(Target.Y[i]);
  bet.Free;
end;

procedure TVectorTransform.Module(Coord: TCoord_type; var Target: TVectorNew);
 var i:integer;
begin
 InitTarget(Target);
 for I := 0 to Vector.Count-1 do
     if Vector.Point[i][Coord]=0
       then
       else
         begin
         Target.Add(Vector[i]);
         if Coord=cX then Target.X[Target.Count-1]:=Abs(Target.X[Target.Count-1]);
         if Coord=cY then Target.Y[Target.Count-1]:=Abs(Target.Y[Target.Count-1]);
//
//         Target.Point[Target.Count-1][Coord]:=
//              Abs(Target.Point[Target.Count-1][Coord]);
         end;

// Vector.Copy(Target);
//  for I := 0 to Target.Count-1 do
//     if Target.Points[i,Coord]=0
//       then
//         Target.DeletePoint(i)
//       else
//         Target.Points[i][Coord]:=Abs(Target.Points[i][Coord]);
end;

procedure TVectorTransform.AbsX(var Target: TVectorNew);
begin
  Module(cX,Target);
end;

procedure TVectorTransform.AbsY(var Target: TVectorNew);
begin
 Module(cY,Target);
end;

procedure TVectorTransform.Branch(Coord: TCoord_type; var Target: TVectorNew;
                const IsPositive:boolean=True;
                const IsRigorous:boolean=True);
//  var i:integer;
//begin
// InitTarget(Target);
// for I := 0 to Vector.Count-1 do
//   if (IsPositive) then
//      begin
//       if(Vector[i][Coord]>=0) then Target.Add(Vector[i])
//      end          else
//      if(Vector[i][Coord]<0) then Target.Add(Vector[i]);
//end;
 function SuitablePoint(Value:double):boolean;
  begin
   if IsPositive then
      begin
        if IsRigorous then Result:=(Value>0)
                      else Result:=(Value>=0)
      end        else
      begin
        if IsRigorous then Result:=(Value<0)
                      else Result:=(Value<=0)
      end;

  end;
 var i,N_begin:integer;

begin
 InitTarget(Target);
 N_begin:=-1;
 for I := 0 to Vector.Count-1 do
  if SuitablePoint(Vector[i][Coord]) then
    begin
      Target.Add(Vector[i]);
      if N_begin<0 then N_begin:=i
    end;
 if N_begin>=0 then Target.N_begin:=Cardinal(N_begin);
end;

procedure TVectorTransform.ChungFun(var Target: TVectorNew);
 var i:word;
     temp:TVectorTransform;
begin
 InitTargetToFun(Target);
 temp:=TVectorTransform.Create();
 temp.Vector.SetLenVector(Target.Count);
 for I := 0 to Target.HighNumber do
   begin
     temp.Vector.X[i]:=ln(Vector.Y[i+Target.N_begin]);
     temp.Vector.Y[i]:=Vector.X[i+Target.N_begin];
   end;
  for I := 0 to Target.HighNumber do
   begin
//     Target.X[i]:=exp(temp.Vector.x[i]);
     Target.X[i]:=Vector.Y[i+Target.N_begin];
     Target.Y[i]:=temp.DerivateAtPoint(i);
   end;
 temp.Free;

 Target.N_begin:=Target.N_begin+Vector.N_begin;
end;

procedure TVectorTransform.CopyLimited(Coord: TCoord_type;
           var Target: TVectorNew; Clim1, Clim2: double);
 var i:integer;
     Cmin,Cmax:double;
begin
  if Clim1>Clim2 then
      begin
        Cmax:=Clim1;
        Cmin:=Clim2;
      end        else
      begin
        Cmax:=Clim2;
        Cmin:=Clim1;
      end;
  InitTarget(Target);
  for I := 0 to Vector.Count-1 do
    if (Vector[i][Coord]>=Cmin)and(Vector[i][Coord]<=Cmax) then
       Target.Add(Vector[i]);
end;

procedure TVectorTransform.CopyLimitedX(var Target: TVectorNew; Xmin, Xmax: double);
begin
 CopyLimited(cX,Target,Xmin, Xmax);
end;

procedure TVectorTransform.CopyLimitedY(var Target: TVectorNew; Ymin,
  Ymax: double);
begin
 CopyLimited(cY,Target,Ymin, Ymax);
end;

function TVectorTransform.DerivateAtPoint(PointNumber: integer): double;
begin
 Result:=ErResult;
 try
  if PointNumber=0
    then Result:=DerivateTwoPoint(Vector[1],Vector[0]);
  if PointNumber=Vector.HighNumber
    then Result:=DerivateTwoPoint(Vector[Vector.HighNumber],Vector[Vector.HighNumber-1]);
  if (PointNumber>0)and(PointNumber<Vector.HighNumber)
     then Result:=DerivateLagr(Vector[PointNumber-1],Vector[PointNumber],Vector[PointNumber+1]);
 except

 end;
end;

procedure TVectorTransform.Derivate(var Target: TVectorNew);
var i:integer;
begin
 InitTarget(Target);
 if Vector.Count<3 then Exit;
 Vector.Copy(Target);
 for i:=0 to Vector.HighNumber do
   Target.Y[i]:=DerivateAtPoint(i);
end;

procedure TVectorTransform.ForwardX(var Target: TVectorNew);
begin
  Branch(cX,Target,true,false);
end;

procedure TVectorTransform.ForwardY(var Target: TVectorNew);
begin
  Branch(cy,Target,true,false);
end;

procedure TVectorTransform.HFun(var Target: TVectorNew; DD: TDiod_Schottky;
                                N: Double);
 var i:word;
begin
  InitTargetToFun(Target);
  if (n=ErResult)or
     (Vector.T<=0)or
      (Target.Count=0) then Exit;

  for I := 0 to Target.HighNumber do
     begin
       Target.X[i]:=Vector.Y[i+Target.N_begin];
       Target.Y[i]:=Vector.X[i+Target.N_begin]+N*DD.Fb(Target.T,Vector.Y[i+Target.N_begin]);
     end;

    Target.N_begin:=Target.N_begin+Vector.N_begin;
end;

procedure TVectorTransform.ImNoiseSmoothedArray(Target: TVectorNew;
                            Npoint: Word);
 var TG:TVectorTransform;
     CountTargetElement,i:integer;
     j:Word;
begin
 InitTarget(Target);
 if Vector.Count<1 then Exit;

 if Npoint=0 then Npoint:=Trunc(sqrt(Vector.Count+1));
 if Npoint=0 then Exit;

 CountTargetElement:=Vector.Count div Npoint;
 if CountTargetElement=0
  then
   begin
   Target.Add(Self.ImpulseNoiseSmoothing(cX),Self.ImpulseNoiseSmoothing(cY));
   Exit;
   end;

 Target.SetLenVector(CountTargetElement);

  TG:=TVectorTransform.Create();
  TG.Vector.SetLenVector(Npoint);
  for I := 0 to CountTargetElement - 2 do
   begin
     for j := 0 to Npoint - 1 do
       begin
        TG.Vector.X[j]:=Self.Vector.X[I*Npoint+j];
        TG.Vector.Y[j]:=Self.Vector.Y[I*Npoint+j];
       end;
     Target.X[I]:=TG.ImpulseNoiseSmoothing(cX);
     Target.Y[I]:=TG.ImpulseNoiseSmoothing(cY);
   end;

  I:=Vector.Count mod Npoint;
  TG.Vector.SetLenVector(I+Npoint);
  for j := 0 to Npoint+I-1 do
   begin
    TG.Vector.X[j]:=Self.Vector.X[(CountTargetElement - 1)*Npoint+j];
    TG.Vector.Y[j]:=Self.Vector.Y[(CountTargetElement - 1)*Npoint+j];
   end;

  Target.X[CountTargetElement - 1]:=TG.ImpulseNoiseSmoothing(cX);
  Target.Y[CountTargetElement - 1]:=TG.ImpulseNoiseSmoothing(cY);

  TG.Free;

end;

function TVectorTransform.ImpulseNoiseSmoothing(
                   const Coord: TCoord_type): Double;
 var i_min,i_max,j,PositivDeviationCount,NegativeDeviationCount:integer;
     PositivDeviation,Value_Mean:double;
     tempVector:TVectorNew;
begin

  if Vector.Count<1 then
    begin
      Result:=ErResult;
      Exit;
    end;
  if Vector.Count<5 then
    begin
      Result:=Vector.MeanValue(Coord);
      Exit;
    end;

  i_min:=Vector.MinNumber(Coord);
  i_max:=Vector.MaxNumber(Coord);

 tempVector:=TVectorNew.Create;
 Vector.Copy(tempVector);
 if i_min=i_max then TempVector.DeletePoint(i_min)
                else
                 begin
                  TempVector.DeletePoint(max(i_min,i_max));
                  TempVector.DeletePoint(min(i_min,i_max));
                 end;

 Value_Mean:=tempVector.MeanValue(Coord);
 PositivDeviationCount:=0;
 NegativeDeviationCount:=0;
 PositivDeviation:=0;
 for j := 0 to tempVector.HighNumber do
  begin
   if tempVector[j][Coord]>Value_Mean then
    begin
      inc(PositivDeviationCount);
      PositivDeviation:=PositivDeviation+(tempVector[j][Coord]-Value_Mean);
    end;
   if tempVector[j][Coord]<Value_Mean then
      inc(NegativeDeviationCount);
  end;

 Result:=Value_Mean+
        (PositivDeviationCount-NegativeDeviationCount)
        *PositivDeviation/sqr(tempVector.HighNumber+1);
  tempVector.Free;
end;

function TVectorTransform.ImpulseNoiseSmoothingByNpoint(
           const Coord: TCoord_type; Npoint: Word): Double;
 var temp:TVectorTransform;
begin
 Result:=ErResult;
 if Vector.Count<1 then Exit;

 if Npoint=0 then Npoint:=Trunc(sqrt(Vector.Count+1));
 if Npoint=0 then Exit;


 temp:=TVectorTransform.Create;


 Self.ImNoiseSmoothedArray(temp.Vector, Npoint);
 if temp.Vector.Count=1
  then Result:=temp.Vector.Point[0][Coord]
  else Result:=temp.ImpulseNoiseSmoothingByNpoint(Coord,Npoint);
 temp.Free;

end;

procedure TVectorTransform.InitTarget(var Target: TVectorNew);
begin
  try
   Target.Clear
  except
   Target:=TVectorNew.Create;
  end;
  Target.T:=fVector.T;
  Target.name:=fVector.name;
  Target.N_begin:=fVector.N_begin;
end;

procedure TVectorTransform.InitTargetToFun(var Target: TVectorNew);
 var i,j,Nbegin:integer;
begin
 InitTarget(Target);
 j:=0;
 Nbegin:=-1;
 for I := 0 to Vector.HighNumber do
  if (Vector.X[i]>0.001) and (Vector.Y[i]>0) then
   begin
     inc(j);
     if Nbegin<0 then Nbegin:=i;
   end;
 if j>0 then
  begin
   Target.SetLenVector(j);
   Target.N_begin:=Nbegin;
  end;
end;

procedure TVectorTransform.Itself(ProcTarget: TProcTarget);
 var Target:TVectorNew;
begin
 Target:=TVectorNew.Create;
 ProcTarget(Target);
 Target.Copy(Self.Vector);
 Target.Free;
end;

procedure TVectorTransform.NegativeX(var Target: TVectorNew);
begin
  Branch(cX,Target,false);
end;

procedure TVectorTransform.NegativeY(var Target: TVectorNew);
begin
 Branch(cY,Target,false);
end;

procedure TVectorTransform.NordeFun(var Target: TVectorNew; DD: TDiod_Schottky;
  Gam: Double);
 var i:word;
begin
  InitTargetToFun(Target);
  if  (Vector.T<=0)or
      (Target.Count=0) then Exit;
  for I := 0 to Target.HighNumber do
   begin
     Target.X[i]:=Vector.X[i+Target.N_begin];
     Target.Y[i]:=Vector.X[i+Target.N_begin]/Gam+DD.Fb(Target.T,Vector.Y[i+Target.N_begin]);
   end;
  Target.N_begin:=Target.N_begin+Vector.N_begin;
end;

procedure TVectorTransform.PositiveX(var Target: TVectorNew);
begin
 Branch(cX,Target);
end;


procedure TVectorTransform.PositiveY(var Target: TVectorNew);
begin
 Branch(cY,Target);
end;


procedure TVectorTransform.ReverseIV(var Target: TVectorNew);
 var temp:TVectorTransform;
begin
 temp:=TVectorTransform.Create(Self.Vector);
 temp.Itself(temp.NegativeX);
 temp.Itself(temp.AbsX);
 temp.AbsY(Target);
 temp.Free;
end;

procedure TVectorTransform.ReverseX(var Target: TVectorNew);
begin
   Branch(cX,Target,false,false);
end;

procedure TVectorTransform.ReverseY(var Target: TVectorNew);
begin
   Branch(cY,Target,false,false);
end;

procedure TVectorTransform.Smoothing(var Target: TVectorNew);
const W0=17;W1=66;W2=17;
{вагові коефіцієнти для нульової, першої та другої точок}
var i:integer;
begin
  InitTarget(Target);
  if Vector.Count<3 then Exit;
  Vector.Copy(Target);
  for i:=1 to Target.HighNumber-1 do
      Target.y[i]:=(W0*Vector.y[i-1]+W1*Vector.y[i]+W2*Vector.y[i+1])/(W0+W1+W2);
  Target.y[0]:=(W1*Vector.y[0]+W2*Vector.y[1])/(W1+W2);
  Target.y[Vector.HighNumber]:=(W1*Vector.y[Vector.HighNumber]
                     +W0*Vector.y[Vector.HighNumber-1])/(W1+W0);
end;

procedure TVectorTransform.Splain3(beg, step: double; var Target: TVectorNew);
 var i,j:integer;
     temp:double;
     SplainCoef:TSplainCoefArray;
begin
  InitTarget(Target);
   j:=Vector.ValueNumber(cX,beg);
   if j<0 then Exit;
//  if (beg>Vector.MaxX)or(beg<Vector.MinX) then Exit;

  SplainCoefCalculate(Vector,SplainCoef);
  i:=0;
  temp:=beg;
  repeat
   inc(i);
   temp:=temp+step;
  until (temp>Vector.X[Vector.HighNumber]);

  Target.SetLenVector(i);
  for i:=0 to Target.HighNumber do
   begin
    temp:=beg+i*step;
    Target.X[i]:=temp;
    j:=Vector.ValueNumber(cX,temp);
//    for j:=0 to Vector.HighNumber-1 do
//       if (temp-Vector.X[j])*(temp-Vector.X[j+1])<=0 then Break;

    Target.Y[i]:=Kub(temp,Vector.Point[j],SplainCoef[j]);
   end;

end;

procedure TVectorTransform.WernerFun(var Target: TVectorNew);
 var i:word;
     temp:TVectorTransform;
begin
 InitTargetToFun(Target);
 temp:=TVectorTransform.Create();
 temp.Vector.SetLenVector(Target.Count);

 if Target.Count=0 then Exit;

  for I := 0 to Target.HighNumber do
   begin
     Target.X[i]:=Self.DerivateAtPoint(i+Target.N_begin);
     Target.Y[i]:=Target.X[i]/Vector.Y[i+Target.N_begin];
   end;

  Target.N_begin:=Target.N_begin+Vector.N_begin;

end;

function TVectorTransform.YvalueLagrang(Xvalue: double): double;
 var i,j:word;
     t1,t2:double;
begin
   Result:=ErResult;
   if (Xvalue-Vector.X[Vector.HighNumber])*(Xvalue-Vector.X[0])>0 then Exit;
   t1:=0;
   for i:=0 to Vector.HighNumber do
     begin
       t2:=1;
       for j:=0 to Vector.HighNumber do
         if (j<>i) then
          t2:=t2*(Xvalue-Vector.X[j])/(Vector.X[i]-Vector.X[j]);
       t1:=t1+Vector.Y[i]*t2;
     end;
  Result:=t1;

end;

function TVectorTransform.YvalueSplain3(Xvalue: double): double;
 var i:integer;
     SplainCoef:TSplainCoefArray;
begin
   Result:=ErResult;
   i:=Vector.ValueNumber(cX,Xvalue);
   if i<0 then Exit;

   if (Xvalue>Vector.MaxX)or(Xvalue<Vector.MinX) then Exit;
   SplainCoefCalculate(Vector,SplainCoef);

//  for i:=0 to Vector.HighNumber-1 do
//    if (Xvalue-Vector.X[i])*(Xvalue-Vector.X[i+1])<=0 then Break;

  Result:=Kub(Xvalue,Vector.Point[i],SplainCoef[i]);

end;

Function Kub (x:double;coef:array of double):double;overload;
{повертає coef[0]+coef[1]*(x-coef[4])+
                  coef[2]*(x-coef[4])^2+
                  coef[3]*(x-coef[4])^3;
потрібно, зокрема, при розрахуванні сплайнів}
 var x0,temp:double;
     i:integer;
begin
  Result:=0;
  if High(coef)>3 then x0:=coef[4]
                  else x0:=0;
  temp:=1;
  for I := 0 to High(coef) do
   begin
     Result:=Result+coef[i]*temp;
     temp:=temp*(x-x0);
     if i=3 then Break;
   end;
end;

Function Kub(x:double;Point:TPointDouble;SplainCoef:TSplainCoef):double;overload;
begin
  Result:=Kub(x,[Point[cY],SplainCoef.B,SplainCoef.C,SplainCoef.D,Point[cX]])
end;


Procedure SplainCoefCalculate(V:TVectorNew;var SplainCoef:TSplainCoefArray);
 var Bt,Dl,AA,BB,H:TArrSingle;
     i:integer;
  begin
   if V.HighNumber<1 then
    begin
    SetLength(SplainCoef,0);
    Exit;
    end;

   SetLength(SplainCoef,V.HighNumber);
   SetLength(Bt,V.HighNumber);
   SetLength(Dl,V.HighNumber);
   SetLength(AA,V.HighNumber);
   SetLength(BB,V.HighNumber);
   SetLength(H,V.HighNumber);
   for I := 0 to V.HighNumber - 1 do
       H[i]:=V.X[i+1]-V.X[i];

   Bt[0]:=1;
   Dl[0]:=1;
   for I := 1 to V.HighNumber - 1 do
     begin
       Bt[i]:=2*(H[i-1]+H[i]);
       Dl[i]:=3*((V.Y[i+1]-V.Y[i])/H[i]-(V.Y[i]-V.Y[i-1])/H[i-1]);
     end;

  AA[0]:=0;
  BB[0]:=1;

    AA[1]:=-H[1]/Bt[1];
    BB[1]:=(Dl[1]-H[0])/Bt[1];
    for I := 2 to V.HighNumber - 2 do
     begin
       AA[i]:=-H[i]/(Bt[i]+H[i-1]*AA[i-1]);
       BB[i]:=(Dl[i]-H[i-1]*BB[i-1])/(Bt[i]+H[i-1]*AA[i-1]);
     end;
   AA[V.HighNumber-1]:=0;
   BB[V.HighNumber-1]:=(Dl[V.HighNumber-1]-
                             H[V.HighNumber-2]*BB[V.HighNumber-2])
                             /(Bt[V.HighNumber-1]+H[V.HighNumber-2]
                               *AA[V.HighNumber-2]);

  SplainCoef[V.HighNumber-1].C:=BB[V.HighNumber-1];
  for I := V.HighNumber-2 downto 0 do
    SplainCoef[i].C:=AA[i]*SplainCoef[i+1].C+BB[i];

 SplainCoef[V.HighNumber-1].D:=-SplainCoef[V.HighNumber-1].C/3/H[V.HighNumber-1];
 SplainCoef[V.HighNumber-1].B:=(V.Y[V.HighNumber]-V.Y[V.HighNumber-1])
          /H[V.HighNumber-1]-2/3*SplainCoef[V.HighNumber-1].C*H[V.HighNumber-1];

 for I := 0 to V.HighNumber-2 do
   begin
     SplainCoef[i].D:=(SplainCoef[i+1].C-SplainCoef[i].C)/3/H[i];
     SplainCoef[i].B:=(V.Y[i+1]-V.Y[i])/H[i]-H[i]
                     /3*(SplainCoef[i+1].C+2*SplainCoef[i].C);
   end;

end;

Function DerivateLagr(x:double;Point1,Point2,Point3:TPointDouble):double;
  {допоміжна функція для знаходження похідної -
  похідна від поліному Лагранжа, проведеного через
  три точки}
begin
  Result:=Point1[cY]*(2*x-Point2[cX]-Point3[cX])
            /(Point1[cX]-Point2[cX])/(Point1[cX]-Point3[cX])
        +Point2[cY]*(2*x-Point1[cX]-Point3[cX])/
           (Point2[cX]-Point1[cX])/(Point2[cX]-Point3[cX])
        +Point3[cY]*(2*x-Point1[cX]-Point2[cX])
         /(Point3[cX]-Point1[cX])/(Point3[cX]-Point2[cX]);
end;

Function DerivateLagr(Point1,Point2,Point3:TPointDouble):double;
begin
  Result:=DerivateLagr(Point2[cX],Point1,Point2,Point3);
end;

Function DerivateTwoPoint(Point1,Point2:TPointDouble):double;
begin
  Result:=(Point2[cY]-Point1[cY])/(Point2[cX]-Point1[cX])
end;

end.

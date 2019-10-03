unit OlegVectorManipulation;

interface
 uses OlegVector,OlegType, OlegMaterialSamples, OlegFunction;


type

  TSplainCoef=record
         B:double;
         C:double;
         D:Double
         end;
  TSplainCoefArray=array of TSplainCoef;


    TVectorManipulation=class
      private
       procedure SetVector(const Value: TVector);
      protected
       fVector:TVector;
      public
       property Vector:TVector read fVector write SetVector;
       Constructor Create(ExternalVector:TVector);overload;
       Constructor Create();overload;
       procedure Free;
    end;

   TProcTarget=Procedure(Target:TVector) of object;

//   TVectorTransform=class(TVectorManipulation)
   TVectorTransform=class(TVector)
    private
//     procedure SetVector(const Value: TVectorNew);
     procedure InitArrSingle(var OutputData: TArrSingle;NumberOfData:word);
     Procedure CopyLimited (Coord:TCoord_type;Target:TVector;Clim1, Clim2:double);
     procedure Branch(Coord:TCoord_type;Target:TVector;
                      const IsPositive:boolean=True;
                      const IsRigorous:boolean=True);
     procedure Module(Coord:TCoord_type;Target:TVector);
    protected
     Procedure InitTarget(Target:TVector);
    public
//     Constructor Create(ExternalVector:TVectorNew);overload;
//     Constructor Create();overload;
     Procedure CopyLimitedX (Target:TVector;Xmin,Xmax:double);
       {копіюються з даного вектора в Target
        - точки, для яких абсциса в діапазоні від Xmin до Xmax включно
         - поля Т та name}
     Procedure CopyLimitedY (Target:TVector;Ymin,Ymax:double);
     procedure AbsX(Target:TVector);
         {заносить в Target точки, для яких X дорівнює модулю Х даного
         вектора, а Y таке саме; якщо Х=0, то точка викидається}
     procedure AbsY(Target:TVector);
         {заносить в Target точки, для яких Y дорівнює модулю Y даного
         вектора, а X таке саме; якщо Y=0, то точка викидається}
     Procedure PositiveX(Target:TVector);//overload;
         {заносить в Target ті точки, для яких X більше нуля}
     procedure PositiveY(Target:TVector);
         {заносить в Target ті точки, для яких Y більше нуля}
     Procedure ForwardX(Target:TVector);
         {заносить в Target ті точки, для яких X більше або рівне нулю}
     Procedure ForwardY(Target:TVector);
     procedure NegativeX(Target:TVector);
         {заносить в Target ті точки, для яких X менше нуля}
     procedure NegativeY(Target:TVector);
         {заносить в Target ті точки, для яких Y менше нуля}
     Procedure ReverseX(Target:TVector);
         {заносить в Target ті точки, для яких X менше або рівне нулю}
     Procedure ReverseY(Target:TVector);
     Procedure ReverseIV(Target:TVector);
     {записує у Target тільки ті точки, які відповідають
     зворотній ділянці ВАХ (для яких координата X менше нуля),
     причому записує модуль координат}
     Procedure Median (Target:TVector);
      {в Target розміщується результат дії на дані в Vector
      медіанного трьохточкового фільтра;
      якщо у вихідному масиві кількість точок менша трьох,
      то у результуючому буде нульова кількість}
     Procedure Splain3(Target:TVector;beg:double; step:double);
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
     Function YvalueLinear(Xvalue:double):double;
     {повертає ординату точки, яка має абсцису XValue
      для лінійної залежності, побудованої по Vector}
     Function XvalueLinear(YValue:double):double;
      {повертає  абсцису точки, яка має  ординату YValue
      для лінійної залежності, побудованої по даним Vector}
     Function GromovAprox (var  OutputData:TArrSingle):boolean;
      {апроксимуються дані залежністю
      y=OutputData[0]+OutputData[1]*x+OutputData[2]*ln(x);
      якщо апроксимація невдала - повертається False}
     Function LinAprox (var  OutputData:TArrSingle):boolean;
     {апроксимуються дані у векторі V лінійною
      залежністю y=OutputData[0]+OutputData[1]*x}
     function LinAproxBconst (b:double):double;
      {визначається коефіцієнт а лінійної
      апроксимації даних залежністю y=a+b*x;
      параметр b вважається відомим}
     function LinAproxAconst (a:double):double;
      {визначається коефіцієнт b лінійної
      апроксимації даних залежністю y=a+b*x;
      параметр a вважається відомим}
     Function ParabAprox (var  OutputData:TArrSingle):boolean;
      {апроксимуються дані  параболічною
      залежністю y=OutputData[0]+OutputData[1]*x+OutputData[2]*x^2}
     Function PVParareters (var  OutputData:TArrSingle):boolean;
      {обчислюються фотоелектричні параметри
      по формі ВАХ
      Voc - OutputData[0],
      Isc - OutputData[1],
      Pm - OutputData[2],
      Vm - OutputData[3],
      Im - OutputData[4]}
     Function NPolinomAprox (N:word;var  OutputData:TArrSingle):boolean;
      {апроксимуються дані  поліномом N-го ступеня
      y=OutputData[0]+OutputData[1]*x+OutputData[2]*x^2+...+OutputData[N]*x^N}
     Function NPolinomZero(N:word):double;
     {знаходиться нуль поліному N-го ступеня,
     яким апроксимуються дані;
     нуль шукається на інтервалі зміни Х,
     якщо функція немонотонна - можливі проблеми}
     Function NPolinomA0(N:word):double;
     {повертається нульовий коефіцієнт
     поліному N-го ступеня,
     яким апроксимуються дані - фактично
     значення функції при х=0}
     Function NPolinomExtremum(N:word):double;
     {знаходиться координата екстремуму
     поліному N-го ступеня,
     яким апроксимуються дані;
     шукається на інтервалі зміни Х,
     якщо функція немонотонна - можливі проблеми}
     Function IvanovAprox (var  OutputData:TArrSingle;
                           DD: TDiod_Schottky; OutsideTemperature: Double = 555):boolean;
      {апроксимація даних у векторі V параметричною залежністю
      I=Szr AA T^2 exp(-Fb/kT) exp(qVs/kT)
      V=Vs+del*[Sqrt(2q Nd ep / eps0) (Sqrt(Fb/q)-Sqrt(Fb/q-Vs))]
      де
      AA - стала Річардсона
      Szr - площа контакту
      Fb - висота бар'єру Шотки
      Vs - падіння напруги на ОПЗ напівпровідника
           (параметр залежності)
      del - товщина діелектричного шару
      (якщо точніше - товщина шару, поділена на
      величину відносної діелектричної проникності шару)
      Nd - концентрація донорів у напівпровіднику;
      eр - діелектрична проникність напівпровідника
      ер0 - діелектрична стала
      OutputData[0]=del;
      OutputData[1]=Fb;
      }

     Function  ImpulseNoiseSmoothing(const Coord:TCoord_type): Double;

     Function ImpulseNoiseSmoothingByNpoint(const Coord:TCoord_type;
                                       Npoint:Word=0): Double;

      {розраховується середнє значення на масиві даних з врахуванням
      можливих імпульсних шумів,
      на відміну від ImpulseNoiseSmoothing дані розбиваються на порції
      по Npoint штук на наборі яких розраховується середнє,
      потім середні розбиваються на порції ....}
     Procedure ImNoiseSmoothedArray(Target:TVector;Npoint:Word=0);
      {в Target записується результата
      зглажування (див ImpulseNoiseSmoothingByNpoint) Source
      по Npoint точкам}
     Procedure Itself(ProcTarget:TProcTarget);
     {дозволяє змінювати власний Vector}
     Procedure Smoothing (Target:TVector);
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
     Procedure Derivate (Target:TVector);
      {в Target розміщується похідна від значень, розташованих
      у Vector;
      якщо у вихідному масиві кількість точок менша трьох,
      то у результуючому буде нульова кількість}
     Function ExtremumXvalue():double;
      {знаходить абсцису екстремума функції,
      що знаходиться в Vector;
      вважаеться, що екстремум один;
      якщо екстремума немає - повертається ErResult;
      якщо екстремум не чіткий - значить будуть
      проблеми :-)}
     Function MaximumCount():integer;
      {обчислюється кількість локальних
      максимумів у Vector;
      дані мають бути упорядковані по координаті X}
     Procedure CopyDiapazonPoint(Target:TVector;
                          D:TDiapazon;InitVector:TVector;
                          RewriteTarget:boolean=True);overload;
      {записує в Target ті точки з Vector, відповідні
      до яких точки у InitVector (вихідному) задовольняють
      умовам D; зрозуміло, що для Vector
      мають бути відомими N_begin;
      в Target.N_begin номер першої точки, яка підійшла;
      якщо RewriteTarget=False, то Target
      попередньо не очищаеться,
      точки додаються до існуючих,
      Target.N_begin не розраховується}
     Procedure CopyDiapazonPoint(Target:TVector;Lim:Limits;InitVector:TVector);overload;
     Procedure CopyDiapazonPoint(Target:TVector;D:TDiapazon;
                        RewriteTarget:boolean=True);overload;
      {записує в Target ті точки з Vector, які
      задовольняють умовам D;
      Vector.N_begin має бути 0;
      в Target.N_begin номер першої точки, яка підійшла}
     Procedure Power (Target:TVector);
       {Target.X[i]=Self.X[i]
       Target.Y[i]=Self.X[i]*Self.Y[i]
       для всіх Self.X[i]>=0}
     Procedure PointSupplement (Target:TVector;
                                const PointCount:word;
                                FromVectorBegin:boolean=True);
      {доповнюється Target точками з Self,
       щоб Target.Count=PointCount;
       вибираються почергово точки
       Self[Target.N_begin-1] та
       Self[Target.N_begin+Target.Count],
       при FromVectorBegin=True починаємо
       з початку вектору;
       якщо в Self замало точок, то просто повертається
       менший  Target}
     function Isc():double;
      {обчислюється струм короткого замикання}
     function Voc():double;
      {обчислюється напруга холостого ходу}
     function Pm():double;
      {обчислюється максимальна вихідна потужність,
      використовується підхід з роботи
      ProgPhotov_25_p623-625.pdf
      для випадку SNR=80 dB}
   end;


Function Kub (x:double;coef:array of double):double;overload;
{повертає coef[0]+coef[1]*(x-coef[4])+
                  coef[2]*(x-coef[4])^2+
                  coef[3]*(x-coef[4])^3;
потрібно, зокрема, при розрахуванні сплайнів}

Function Kub(x:double;
             Point:TPointDouble;
             SplainCoef:TSplainCoef):double;overload;

Procedure SplainCoefCalculate(V:TVector;var SplainCoef:TSplainCoefArray);
{розраховуються кокфіцієнтів сплайцнів для апроксимації даних в Vector}

Function DerivateLagr(x:double;Point1,Point2,Point3:TPointDouble):double;overload;
  {допоміжна функція для знаходження похідної -
  похідна від поліному Лагранжа, проведеного через
  три точки}
Function DerivateLagr(Point1,Point2,Point3:TPointDouble):double;overload;
{в центральній точці}

Function DerivateTwoPoint(Point1,Point2:TPointDouble):double;


implementation

uses
  Math, Dialogs, SysUtils, OlegMath;




{ TVectorManipulation }

constructor TVectorManipulation.Create(ExternalVector: TVector);
begin
  Create();
  SetVector(ExternalVector);
end;

constructor TVectorManipulation.Create;
begin
  inherited Create;
  fVector:=TVector.Create;
end;

procedure TVectorManipulation.Free;
begin
 fVector.Free;
 inherited Free;
end;


procedure TVectorManipulation.SetVector(const Value: TVector);
begin
 Value.CopyTo(fVector);
end;


{ TVectorTransform }

function TVectorTransform.MaximumCount: integer;
 var i:integer;
begin
  if Count<3 then
     begin
       Result:=ErResult;
       Exit;
     end;
  Result:=0;
  for i:=1 to HighNumber-1 do
   if (Y[i]>Y[i-1])
       and(Y[i]>Y[i+1])
          then inc(Result);
end;

procedure TVectorTransform.Median(Target: TVector);
  var i:integer;
begin
  InitTarget(Target);
  if Self.Count<3 then Exit;
  Self.CopyTo(Target);
  for i:=1 to Target.HighNumber-1 do
    Target.y[i]:=MedianFiltr(Self.y[i-1],Self.y[i],Self.y[i+1]);;
end;

procedure TVectorTransform.Module(Coord: TCoord_type; Target: TVector);
 var i:integer;
begin
 InitTarget(Target);
 for I := 0 to Self.HighNumber do
     if Self.Point[i][Coord]=0
       then
       else
         begin
         Target.Add(Self[i]);
         if Coord=cX then Target.X[Target.Count-1]:=Abs(Target.X[Target.Count-1]);
         if Coord=cY then Target.Y[Target.Count-1]:=Abs(Target.Y[Target.Count-1]);
         end;
end;

procedure TVectorTransform.AbsX(Target: TVector);
begin
  Module(cX,Target);
end;

procedure TVectorTransform.AbsY(Target: TVector);
begin
 Module(cY,Target);
end;


procedure TVectorTransform.Branch(Coord: TCoord_type; Target: TVector;
                const IsPositive:boolean=True;
                const IsRigorous:boolean=True);
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
 for I := 0 to Self.HighNumber do
  if SuitablePoint(Self[i][Coord]) then
    begin
      Target.Add(Self[i]);
      if N_begin<0 then N_begin:=i
    end;
 if N_begin>=0 then Target.N_begin:=Cardinal(N_begin);
end;

procedure TVectorTransform.CopyDiapazonPoint(Target: TVector;
                      D: TDiapazon; InitVector: TVector;
                     RewriteTarget:boolean=True);
 var i:integer;
begin
 if RewriteTarget then InitTarget(Target);
 Target.T:=InitVector.T;
 for I := 0 to Self.HighNumber do
   if InitVector.PointInDiapazon(D,i+Self.N_begin)
     then
      begin
      if Target.Count<1
         then Target.N_begin:=Target.N_begin+i;
      Target.Add(Self[i]);
      end;
end;

procedure TVectorTransform.CopyDiapazonPoint(Target: TVector;
  D: TDiapazon;RewriteTarget:boolean);
begin
 CopyDiapazonPoint(Target,D,Self,RewriteTarget);
end;

procedure TVectorTransform.CopyDiapazonPoint(Target: TVector;
        Lim: Limits; InitVector: TVector);
 var i:integer;
begin
 InitTarget(Target);
 Target.T:=InitVector.T;
 for I := 0 to Self.HighNumber do
   if InitVector.PointInDiapazon(Lim,i+Self.N_begin)
     then
      begin
      if Target.Count<1
         then Target.N_begin:=Target.N_begin+i;
      Target.Add(Self[i]);
      end;
end;

procedure TVectorTransform.CopyLimited(Coord: TCoord_type;
           Target: TVector; Clim1, Clim2: double);
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
  for I := 0 to Self.HighNumber do
    if (Self[i][Coord]>=Cmin)and(Self[i][Coord]<=Cmax) then
       Target.Add(Self[i]);
end;

procedure TVectorTransform.CopyLimitedX(Target: TVector; Xmin, Xmax: double);
begin
 CopyLimited(cX,Target,Xmin, Xmax);
end;

procedure TVectorTransform.CopyLimitedY(Target: TVector; Ymin,
  Ymax: double);
begin
 CopyLimited(cY,Target,Ymin, Ymax);
end;

//constructor TVectorTransform.Create;
//begin
// inherited Create;
//end;

//constructor TVectorTransform.Create(ExternalVector: TVectorNew);
//begin
//  Create();
//  SetVector(ExternalVector);
//end;

function TVectorTransform.DerivateAtPoint(PointNumber: integer): double;
begin
 Result:=ErResult;
 try
  if PointNumber=0
    then Result:=DerivateTwoPoint(Self[1],Self[0]);
  if PointNumber=Self.HighNumber
    then Result:=DerivateTwoPoint(Self[Self.HighNumber],Self[Self.HighNumber-1]);
  if (PointNumber>0)and(PointNumber<Self.HighNumber)
     then Result:=DerivateLagr(Self[PointNumber-1],Self[PointNumber],Self[PointNumber+1]);
 except

 end;
end;

function TVectorTransform.ExtremumXvalue: double;
 var temp:TVector;
begin
  temp:=TVector.Create;
  Self.Derivate(temp);
  Result:=temp.Xvalue(0);
  if (Result>Self.MaxX)or(Result<Self.MinX)
     then result:=ErResult;
  temp.Free;
end;

procedure TVectorTransform.Derivate(Target: TVector);
var i:integer;
begin
 InitTarget(Target);
 if Self.Count<3 then Exit;
 Self.CopyTo(Target);
 for i:=0 to Self.HighNumber do
   Target.Y[i]:=DerivateAtPoint(i);
end;

procedure TVectorTransform.ForwardX(Target: TVector);
begin
  Branch(cX,Target,true,false);
end;

procedure TVectorTransform.ForwardY(Target: TVector);
begin
  Branch(cy,Target,true,false);
end;

function TVectorTransform.GromovAprox(var OutputData: TArrSingle):boolean;
var R:PSysEquation;
    i:integer;
begin
  Result:=False;
  InitArrSingle(OutputData,3);

  for I:=0 to Self.HighNumber do
    if Self.X[i]<0 then Exit;

  new(R);
  R^.SetLengthSys(3);
  R^.Clear;

  R^.A[0,0]:=Self.Count;
  for i:=0 to Self.HighNumber do
   begin
     R^.A[0,1]:=R^.A[0,1]+Self.X[i];
     R^.A[0,2]:=R^.A[0,2]+ln(Self.X[i]);
     R^.A[1,1]:=R^.A[1,1]+Self.X[i]*Self.X[i];
     R^.A[1,2]:=R^.A[1,2]+Self.X[i]*ln(Self.X[i]);
     R^.A[2,2]:=R^.A[2,2]+ln(Self.X[i])*ln(Self.X[i]);
     R^.f[0]:=R^.f[0]+Self.Y[i];
     R^.f[1]:=R^.f[1]+Self.Y[i]*Self.X[i];
     R^.f[2]:=R^.f[2]+Self.Y[i]*ln(Self.X[i]);
   end;
  R^.A[1,0]:=R^.A[0,1];
  R^.A[2,0]:=R^.A[0,2];
  R^.A[2,1]:=R^.A[1,2];

  GausGol(R);
  if R^.N=ErResult then Exit;

  OutputData[0]:=R^.x[0];
  OutputData[1]:=R^.x[1];
  OutputData[2]:=R^.x[2];
  dispose(R);
  Result:=True;
end;

procedure TVectorTransform.ImNoiseSmoothedArray(Target: TVector;
                            Npoint: Word);
 var TG:TVectorTransform;
     CountTargetElement,i:integer;
     j:Word;
begin
 InitTarget(Target);
 if Self.Count<1 then Exit;

 if Npoint=0 then Npoint:=Trunc(sqrt(Self.Count+1));
 if Npoint=0 then Exit;

 CountTargetElement:=Self.Count div Npoint;
 if CountTargetElement=0
  then
   begin
   Target.Add(Self.ImpulseNoiseSmoothing(cX),
              Self.ImpulseNoiseSmoothing(cY));
   Exit;
   end;

 Target.SetLenVector(CountTargetElement);

  TG:=TVectorTransform.Create();
  TG.SetLenVector(Npoint);
  for I := 0 to CountTargetElement - 2 do
   begin
     for j := 0 to Npoint - 1 do
       begin
        TG.X[j]:=Self.X[I*Npoint+j];
        TG.Y[j]:=Self.Y[I*Npoint+j];
       end;
     Target.X[I]:=TG.ImpulseNoiseSmoothing(cX);
     Target.Y[I]:=TG.ImpulseNoiseSmoothing(cY);
   end;

  I:=Self.Count mod Npoint;
  TG.SetLenVector(I+Npoint);
  for j := 0 to Npoint+I-1 do
   begin
    TG.X[j]:=Self.X[(CountTargetElement - 1)*Npoint+j];
    TG.Y[j]:=Self.Y[(CountTargetElement - 1)*Npoint+j];
   end;

  Target.X[CountTargetElement - 1]:=TG.ImpulseNoiseSmoothing(cX);
  Target.Y[CountTargetElement - 1]:=TG.ImpulseNoiseSmoothing(cY);
  TG.Free;
end;

function TVectorTransform.ImpulseNoiseSmoothing(
                   const Coord: TCoord_type): Double;
 var i_min,i_max,j,PositivDeviationCount,NegativeDeviationCount:integer;
     PositivDeviation,Value_Mean:double;
     tempVector:TVector;
begin

  if Self.Count<1 then
    begin
      Result:=ErResult;
      Exit;
    end;
  if Self.Count<5 then
    begin
      Result:=Self.MeanValue(Coord);
      Exit;
    end;

  i_min:=Self.MinNumber(Coord);
  i_max:=Self.MaxNumber(Coord);

 tempVector:=TVector.Create;
 Self.CopyTo(tempVector);
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
 if Self.Count<1 then Exit;

 if Npoint=0 then Npoint:=Trunc(sqrt(Self.Count+1));
 if Npoint=0 then Exit;


 temp:=TVectorTransform.Create;


 Self.ImNoiseSmoothedArray(temp, Npoint);
 if temp.Count=1
  then Result:=temp[0][Coord]
  else Result:=temp.ImpulseNoiseSmoothingByNpoint(Coord,Npoint);
 temp.Free;

end;

procedure TVectorTransform.InitArrSingle(var OutputData: TArrSingle;
  NumberOfData: word);
  var i:word;
begin
 if High(OutputData)<(NumberOfData-1) then SetLength(OutputData,NumberOfData);
 for i := 0 to High(OutputData)
    do OutputData[i]:=ErResult;
end;

procedure TVectorTransform.InitTarget(Target: TVector);
begin
//  try
//   Target.Clear
//  except
//   Target:=TVectorNew.Create;
//  end;
  Target.Clear;
  Target.T:=Self.T;
  Target.name:=Self.name;
  Target.N_begin:=Self.N_begin;
end;

function TVectorTransform.Isc: double;
 var temp, temp2:double;
begin
 Result:=0;
 if Self.Count<2 then Exit;
 temp:=Self.Yvalue(0);
 temp2:=Self.Yvalue(0.01);
 if (abs(temp2/temp)>2) then Exit
             else Result:=-temp;
 if temp=ErResult then
      Result:=(-Self.Y[1]*Self.X[0]+Self.Y[0]*Self.X[1])
              /(Self.X[0]-Self.X[1]);
end;

procedure TVectorTransform.Itself(ProcTarget: TProcTarget);
 var Target:TVector;
begin
 Target:=TVector.Create;
 ProcTarget(Target);
 Target.CopyTo(Self);
 Target.Free;
end;

function TVectorTransform.IvanovAprox(var OutputData: TArrSingle;
  DD: TDiod_Schottky; OutsideTemperature: Double): boolean;
var temp:TVector;
    a,b,Temperature:double;
    i:integer;
    Param:array of double;
begin
 Result:=False;
 InitArrSingle(OutputData,2);
  if OutsideTemperature=ErResult then Temperature:=Self.T
                                 else Temperature:=OutsideTemperature;
  if (Temperature<=0)or(Self.Count=0) then Exit;
  SetLength(Param,6);

  temp:=TVector.Create;
  temp.SetLenVector(Self.Count);
  try
  for I := 0 to temp.HighNumber do
    begin
     temp.X[i]:=1/Self.X[i];
     temp.Y[i]:=sqrt(DD.Fb(Temperature,Self.Y[i]));
    end;
  except
   temp.Free;
   Exit;
  end;//try

  Param[0]:=temp.Count;
  for i := 1 to 5 do Param[i]:=0;
  try
    for I := 0 to temp.HighNumber do
    begin
    Param[1]:=Param[1]+temp.X[i];
    Param[2]:=Param[2]+temp.X[i]*temp.Y[i];
    Param[3]:=Param[3]+temp.X[i]*sqr(temp.Y[i]);
    Param[4]:=Param[4]+temp.X[i]*temp.Y[i]*sqr(temp.Y[i]);
    Param[5]:=Param[5]+temp.Y[i];
    end;
    temp.Free;
  except
    temp.Free;
    Exit;
  end;//try

  try
  a:=(Param[2]*(Param[0]+Param[3])-Param[1]*(Param[5]+Param[4]))/(Param[3]*Param[1]-sqr(Param[2]));
  b:=(Param[3]*(Param[0]+Param[3])-Param[2]*(Param[5]+Param[4]))/(Param[3]*Param[1]-sqr(Param[2]));
  b:=(sqrt(sqr(a)+4*b)-a)/2;
  except
    Exit;
  end;
  OutputData[0]:=a/sqrt(2*Qelem*DD.Semiconductor.Nd*DD.Semiconductor.Material.Eps/Eps0);
  OutputData[1]:=sqr(b);
  Result:=True;
end;

function TVectorTransform.LinAprox(var OutputData: TArrSingle): boolean;
  var Sx,Sy,Sxy,Sx2:double;
      i:integer;
begin
  Result:=False;
  InitArrSingle(OutputData,2);
  Sx:=0;Sy:=0;Sxy:=0;Sx2:=0;
  for i:=0 to Self.HighNumber do
     begin
     Sx:=Sx+Self.x[i];
     Sy:=Sy+Self.y[i];
     Sxy:=Sxy+Self.x[i]*Self.y[i];
     Sx2:=Sx2+Self.x[i]*Self.x[i];
     end;
  try
  OutputData[0]:=(Sx2*Sy-Sxy*Sx)/(Self.Count*Sx2-Sx*Sx);
  OutputData[1]:=(Self.Count*Sxy-Sy*Sx)/(Self.Count*Sx2-Sx*Sx);
  except
   InitArrSingle(OutputData,2);
   Exit;
  end;
  Result:=True;
end;

function TVectorTransform.LinAproxAconst(a: double): double;
var Sx,Sxy,Sx2:double;
    i:integer;
begin
 Sx:=0;Sxy:=0;Sx2:=0;
 for i:=0 to Self.HighNumber do
   begin
   Sx:=Sx+Self.x[i];
   Sxy:=Sxy+Self.x[i]*Self.y[i];
   Sx2:=Sx2+Self.x[i]*Self.x[i];
   end;
 try
 Result:=(Sxy-a*Sx)/Sx2;
 except
  Result:=ErResult;
 end;
end;

function TVectorTransform.LinAproxBconst(b: double): double;
begin
 if Self.IsEmpty then Result:=ErResult
                   else
      Result:=(Self.SumY-b*Self.SumX)/Self.Count;
end;

procedure TVectorTransform.NegativeX(Target: TVector);
begin
  Branch(cX,Target,false);
end;

procedure TVectorTransform.NegativeY(Target: TVector);
begin
 Branch(cY,Target,false);
end;

function TVectorTransform.NPolinomA0(N: word): double;
 var outputData:TArrSingle;
begin
 if Self.NPolinomAprox(N,outputData)
   then Result:=outputData[0]
   else Result:=ErResult;
end;

function TVectorTransform.NPolinomAprox(N:word;
           var OutputData: TArrSingle): boolean;
var R:PSysEquation;
    i,j:integer;
    SumX,SumXY:TArrSingle;
    temp:double;
begin
  Result:=False;
  InitArrSingle(OutputData,N+1);
  if Self.Count<(N+1) then Exit;
  new(R);
  R^.SetLengthSys(N+1);
  R^.Clear;
  SetLength(SumXY,N+1);
  for I := 0 to High(SumXY) do SumXY[i]:=0;
  SetLength(SumX,2*N+1);
  for I := 0 to High(SumX) do SumX[i]:=0;

  SumX[0]:=Self.Count;
  SumXY[0]:=Self.SumY;
  for I := 0 to Self.HighNumber do
   begin
    temp:=1;
    for j := 1 to High(SumX) do
     begin
       temp:=temp*X[i];
       SumX[j]:=SumX[j]+temp;
       if j<(n+1) then
        SumXY[j]:=SumXY[j]+Y[i]*temp;
     end;
   end;

  R^.InPutF(SumXY);
  for I := 0 to N do
    for j := 0 to N do
       R^.A[i,j]:=SumX[i+j];
  GausGol(R);

  if R^.N=ErResult then Exit;
  R^.OutPutX(OutputData);
  dispose(R);
  Result:=True;
end;

function TVectorTransform.NPolinomExtremum(N: word): double;
 var outputData:TArrSingle;
     i:integer;
begin
 if Self.NPolinomAprox(N,outputData)
   then
    begin
      for i := 1 to High(outputData) do
       outputData[i-1]:=i*outputData[i];
      SetLength(outputData,High(outputData));
      Result:=Bisection(NPolinom,outputData,
                 Self.X[0],Self.X[Self.HighNumber])
    end
   else Result:=ErResult;
end;

function TVectorTransform.NPolinomZero(N: word): double;
 var outputData:TArrSingle;
begin
 if Self.NPolinomAprox(N,outputData)
   then Result:=Bisection(NPolinom,outputData,
                 Self.X[0],Self.X[Self.HighNumber])
   else Result:=ErResult;
end;

function TVectorTransform.ParabAprox(var OutputData: TArrSingle): boolean;
var Sx,Sy,Sxy,Sx2,Sx3,Sx4,Syx2,pr:double;
    i:integer;
begin
  Result:=False;
  InitArrSingle(OutputData,3);
 Sx:=0;Sy:=0;Sxy:=0;Sx2:=0;Sx3:=0;Sx4:=0;Syx2:=0;
 with Self do begin
  for i:=0 to HighNumber do
   begin
   Sx:=Sx+x[i];
   Sy:=Sy+y[i];
   Sxy:=Sxy+x[i]*y[i];
   Sx2:=Sx2+sqr(x[i]);
   Sx3:=Sx3+sqr(x[i])*x[i];
   Sx4:=Sx4+sqr(sqr(x[i]));
   Syx2:=Syx2+sqr(x[i])*y[i];
   end;

  pr:=Sx4*(Count*Sx2-Sx*Sx)-Sx3*(Count*Sx3-Sx*Sx2)+Sx2*(Sx3*Sx-Sx2*Sx2);
  try
  OutputData[2]:=(Syx2*(Count*Sx2-Sx*Sx)-Sx3*(Count*Sxy-Sx*Sy)+Sx2*(Sxy*Sx-Sx2*Sy))/pr;
  OutputData[1]:=(Sx4*(Count*Sxy-Sx*Sy)-Syx2*(Count*Sx3-Sx*Sx2)+Sx2*(Sx3*Sy-Sx2*Sxy))/pr;
  OutputData[0]:=(Sx4*(Sy*Sx2-Sx*Sxy)-Sx3*(Sy*Sx3-Sxy*Sx2)+Syx2*(Sx3*Sx-Sx2*Sx2))/pr;
  Result:=True;
  except
  end;
 end;

end;

function TVectorTransform.Pm: double;
 var P_V,temp:TVectorTransform;
     D:TDiapazon;
     Pmax,Vmax,Imax,Voc:double;
     Number_Vmax:integer;
begin
 Result:=ErResult;
 P_V:=TVectorTransform.Create();
 Self.Power(P_V);
 Pmax:=P_V.MinY;

 if (P_V.Count<5)or(Pmax>=0) then Exit;

 Number_Vmax:=P_V.ValueNumberPrecise(cY,Pmax);
 Vmax:=P_V.X[Number_Vmax];
 Imax:=-Pmax/Vmax;

 D:=TDiapazon.Create;
 D.StrictEquality:=False;
 D.SetLimits(-0.5*Vmax,0.42*Vmax,Self.MinY,ErResult);

 temp:=TVectorTransform.Create();
 Self.CopyDiapazonPoint(temp,D);

 Self.PointSupplement(temp,2);

 showmessage('Isc='+floattostr(-temp.NPolinomA0(1)));
//----------------------------------------------

 D.SetLimits(Self.MinX,ErResult,-0.11*Imax,0.33*Imax);

 Self.CopyDiapazonPoint(temp,D);
 Self.PointSupplement(temp,3,False);
 Voc:=temp.NPolinomZero(2);
 showmessage('Voc='+floattostr(Voc));

//---------------------------------------

 D.SetLimits(P_V.MinX,P_V.X[Number_Vmax - 1],P_V.MinY,Pmax*0.82);
 P_V.CopyDiapazonPoint(temp,D);
 D.SetLimits(P_V.X[Number_Vmax],ErResult,P_V.MinY,Pmax*0.94);
 P_V.CopyDiapazonPoint(temp,D,False);

 p_V.PointSupplement(temp,5);

 Vmax:=temp.NPolinomExtremum(4);
 Result:=-P_V.YvalueSplain3(Vmax);
 Imax:=-Self.YvalueSplain3(Vmax);
 showmessage('Vmax='+floattostr(Vmax)
             +' Imax='+floattostr(Imax)
             +' Pmax='+floattostr(Result));
 D.Free;
 P_V.Free;
 temp.Free;
end;

procedure TVectorTransform.PointSupplement(Target: TVector;
   const PointCount: word; FromVectorBegin: boolean);
begin
 if Self.Count<PointCount then Exit;
 while Target.Count<PointCount do
  begin
   if FromVectorBegin then
      begin
        if Target.N_begin>0 then
           begin
            Target.N_begin:=Target.N_begin-1;
            Target.Add(Self[Target.N_begin]);
           end;
      end                 else
      begin
        if (Target.N_begin+Target.Count)<Self.HighNumber then
            Target.Add(Self[Target.N_begin+Target.Count]);
      end;
   FromVectorBegin:=not(FromVectorBegin);
  end;
 Target.Sorting();
end;

procedure TVectorTransform.PositiveX(Target: TVector);
begin
 Branch(cX,Target);
end;


procedure TVectorTransform.PositiveY(Target: TVector);
begin
 Branch(cY,Target);
end;

procedure TVectorTransform.Power(Target: TVector);
 var i:integer;
begin
 InitTarget(Target);
 Self.ForwardX(Target);
 Target.Sorting();
 for I := 0 to Target.HighNumber do
      Target.Y[i]:=Target.Y[i]*Target.X[i];
end;

function TVectorTransform.PVParareters(var OutputData: TArrSingle): boolean;
 var P_V,temp:TVectorTransform;
     D:TDiapazon;
     Pmax,Imax:double;
     Number_Vmax:integer;
begin
 Result:=False;
 InitArrSingle(OutputData,5);

 P_V:=TVectorTransform.Create();
 Self.Power(P_V);
 Pmax:=P_V.MinY;

 if (P_V.Count<5)or(Pmax>=0) then Exit;

 Number_Vmax:=P_V.ValueNumberPrecise(cY,Pmax);
 Imax:=-Pmax/P_V.X[Number_Vmax];

 D:=TDiapazon.Create;
 D.StrictEquality:=False;
 D.SetLimits(-0.5*P_V.X[Number_Vmax],0.42*P_V.X[Number_Vmax],
             Self.MinY,ErResult);

 temp:=TVectorTransform.Create();
 Self.CopyDiapazonPoint(temp,D);
 Self.PointSupplement(temp,2);
 OutputData[1]:=-temp.NPolinomA0(1);

 D.SetLimits(Self.MinX,ErResult,
            -0.11*Imax,0.33*Imax);
 Self.CopyDiapazonPoint(temp,D);
 Self.PointSupplement(temp,3,False);
 OutputData[0]:=temp.NPolinomZero(2);

 D.SetLimits(P_V.MinX,P_V.X[Number_Vmax - 1],P_V.MinY,Pmax*0.82);
 P_V.CopyDiapazonPoint(temp,D);
 D.SetLimits(P_V.X[Number_Vmax],ErResult,P_V.MinY,Pmax*0.94);
 P_V.CopyDiapazonPoint(temp,D,False);
 p_V.PointSupplement(temp,5);
 OutputData[3]:=temp.NPolinomExtremum(4);
 OutputData[2]:=-P_V.YvalueSplain3(OutputData[3]);
 OutputData[4]:=-Self.YvalueSplain3(OutputData[3]);

 D.Free;
 P_V.Free;
 temp.Free;
 Result:=True;
end;

procedure TVectorTransform.ReverseIV(Target: TVector);
 var temp:TVectorTransform;
begin
 temp:=TVectorTransform.Create(Self);
 temp.Itself(temp.NegativeX);
 temp.Itself(temp.AbsX);
 temp.AbsY(Target);
 temp.Free;
end;

procedure TVectorTransform.ReverseX(Target: TVector);
begin
   Branch(cX,Target,false,false);
end;

procedure TVectorTransform.ReverseY(Target: TVector);
begin
   Branch(cY,Target,false,false);
end;

//procedure TVectorTransform.SetVector(const Value: TVectorNew);
//begin
// Value.CopyTo(Self);
//end;

procedure TVectorTransform.Smoothing(Target: TVector);
const W0=17;W1=66;W2=17;
{вагові коефіцієнти для нульової, першої та другої точок}
var i:integer;
begin
  InitTarget(Target);
  if Self.Count<3 then Exit;
  Self.CopyTo(Target);
  for i:=1 to Target.HighNumber-1 do
      Target.y[i]:=(W0*Self.y[i-1]+W1*Self.y[i]+W2*Self.y[i+1])
                   /(W0+W1+W2);
  Target.y[0]:=(W1*Self.y[0]+W2*Self.y[1])/(W1+W2);
  Target.y[Self.HighNumber]:=(W1*Self.y[Self.HighNumber]
                     +W0*Self.y[Self.HighNumber-1])/(W1+W0);
end;

procedure TVectorTransform.Splain3(Target:TVector;beg:double; step:double);
 var i,j:integer;
     temp:double;
     SplainCoef:TSplainCoefArray;
begin
  InitTarget(Target);
   j:=Self.ValueNumber(cX,beg);
   if j<0 then Exit;

  SplainCoefCalculate(Self,SplainCoef);
  i:=0;
  temp:=beg;
  repeat
   inc(i);
   temp:=temp+step;
  until (temp>Self.X[Self.HighNumber]);

  Target.SetLenVector(i);
  for i:=0 to Target.HighNumber do
   begin
    temp:=beg+i*step;
    Target.X[i]:=temp;
    j:=Self.ValueNumber(cX,temp);
    Target.Y[i]:=Kub(temp,Self.Point[j],SplainCoef[j]);
   end;

end;

function TVectorTransform.Voc: double;
 var temp:double;
begin
 Result:=0;
 temp:=Self.Xvalue(0);
 if (temp=ErResult)or
    (temp<=0) then Exit
              else Result:=temp;
end;

function TVectorTransform.XvalueLinear(YValue: double): double;
 var OutputData: TArrSingle;
begin
  Result:=ErResult;
  if YValue=ErResult then Exit;
  if LinAprox(OutputData) then
    try
     Result:=(YValue-OutputData[0])/OutputData[1];
    except
    end;
end;

function TVectorTransform.YvalueLagrang(Xvalue: double): double;
 var i,j:word;
     t1,t2:double;
begin
   Result:=ErResult;
   if (Xvalue-Self.X[Self.HighNumber])*(Xvalue-Self.X[0])>0 then Exit;
   t1:=0;
   for i:=0 to Self.HighNumber do
     begin
       t2:=1;
       for j:=0 to Self.HighNumber do
         if (j<>i) then
          t2:=t2*(Xvalue-Self.X[j])/(Self.X[i]-Self.X[j]);
       t1:=t1+Self.Y[i]*t2;
     end;
  Result:=t1;
end;

function TVectorTransform.YvalueLinear(Xvalue: double): double;
 var OutputData: TArrSingle;
begin
  Result:=ErResult;
  if XValue=ErResult then Exit;
  if LinAprox(OutputData)
    then Result:=Linear(Xvalue,OutputData);
end;

function TVectorTransform.YvalueSplain3(Xvalue: double): double;
 var i:integer;
     SplainCoef:TSplainCoefArray;
begin
   Result:=ErResult;
   i:=Self.ValueNumber(cX,Xvalue);
   if i<0 then Exit;

   if (Xvalue>Self.MaxX)or(Xvalue<Self.MinX) then Exit;
   SplainCoefCalculate(Self,SplainCoef);

  Result:=Kub(Xvalue,Self[i],SplainCoef[i]);
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


Procedure SplainCoefCalculate(V:TVector;var SplainCoef:TSplainCoefArray);
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

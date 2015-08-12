unit ApprThread;

interface

uses
  Classes,OlegGraph,Approximation,SysUtils,OlegMath,Messages,
  WinProcs,OlegType,Dialogs;

type
  Apr = class(TThread)
  public
    event: THandle;
    constructor Create(bool:boolean);
  private
    { Private declarations }
  protected
    procedure Execute; override;
    procedure SendInform;
    procedure SendInformA;
  end;

implementation
 var Nit,Nmax:integer;
     X:array of single;
{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure Apr.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ Apr }
constructor Apr.Create(bool:boolean);
begin
inherited;
event := CreateEvent(nil , true, false, '') ;
ResetEvent(event);
end;

procedure Apr.Execute;
//const eps=5e-8;
var F,X2:array of single;
    i,Npar:integer;
    bool:boolean;
    Sum,al,sum2,eps:single;
   Function Secant(num:word;a,b,F:single):single;
  {обчислюється оптимальне значення параметра al
  в методі поординатного спуску;
  використовується метод дихотомії;
  а та b задають початковий відрізок, де шукається
  розв'язок}
  var i:integer;
      c,Fb,Fa:single;
  begin
    Result:=0;
     case OlegGraph.Func of
      1:  Fa:=aSdal_LamShot(Vec,num,a,F,X[0],X[1],X[2],X[3]);
      3:  Fa:=aSdal_ExpLightShot(Vec,num,a,F,X[0],X[1],X[2],X[3],X[4]);
      4:  Fa:=aSdal_LamLightShot(Vec,num,a,F,X[0],X[1],X[2],X[3],X[4]);
      else Fa:=aSdal_ExpShot(Vec,num,a,F,X[0],X[1],X[2],X[3]);
     end;
    if Fa=555 then Exit;

    if Fa=0 then
               begin
                  Result:=a;
                  Exit;
                end;
  //   X[5]:=Fa;
    repeat
     case OlegGraph.Func of
       1:  Fb:=aSdal_LamShot(Vec,num,b,F,X[0],X[1],X[2],X[3]);
       3:  Fb:=aSdal_ExpLightShot(Vec,num,b,F,X[0],X[1],X[2],X[3],X[4]);
       4:  Fb:=aSdal_LamLightShot(Vec,num,b,F,X[0],X[1],X[2],X[3],X[4]);
      else Fb:=aSdal_ExpShot(Vec,num,b,F,X[0],X[1],X[2],X[3]);
     end;
     if Fb=0 then
                begin
                  Result:=b;
                  Exit;
                end;
     if Fb=555 then break
               else
                 begin
                 if Fb*Fa<=0 then break
                            else b:=2*b
                 end;
    until false;

     i:=0;
    repeat
      inc(i);
      c:=(a+b)/2;
     case OlegGraph.Func of
       1:begin
         Fb:=aSdal_LamShot(Vec,num,c,F,X[0],X[1],X[2],X[3]);
         Fa:=aSdal_LamShot(Vec,num,a,F,X[0],X[1],X[2],X[3]);
         end;
       3:begin
         Fb:=aSdal_ExpLightShot(Vec,num,c,F,X[0],X[1],X[2],X[3],X[4]);
         Fa:=aSdal_ExpLightShot(Vec,num,a,F,X[0],X[1],X[2],X[3],X[4]);
         end;
       4:begin
         Fb:=aSdal_LamLightShot(Vec,num,c,F,X[0],X[1],X[2],X[3],X[4]);
         Fa:=aSdal_LamLightShot(Vec,num,a,F,X[0],X[1],X[2],X[3],X[4]);
         end;
      else
         begin
         Fb:=aSdal_ExpShot(Vec,num,c,F,X[0],X[1],X[2],X[3]);
         Fa:=aSdal_ExpShot(Vec,num,a,F,X[0],X[1],X[2],X[3]);
         end;
     end;
     if (Fb*Fa<=0) or (Fb=555)
       then b:=c
       else a:=c;
     until (i>1e5)or(abs((b-a)/c)<1e-2);
    if (i>1e5) then Exit;
    Result:=c;
  end;

 Procedure VuhDatExpLightmAprox (var n0,Rs0,I00,Rsh0,Iph0:single);overload;
  {по значенням в V визначає початкове наближення
  для n,Rs,I0,Rsh,Iph}
  var temp,temp2:Pvector;
      i,k:integer;
   begin
    n0:=555;
    Rs0:=555;
    I00:=555;
    Rsh0:=555;
    if (VocCalc(Vec)<=0.002) then Exit;
    Iph0:=IscCalc(Vec);

    new(temp2);
    IVchar(Vec,temp2);
     for I := 0 to High(temp2^.X) do
      temp2^.Y[i]:=temp2^.Y[i]+Iph0;

    new(temp);
    Diferen (temp2,temp);
  {фактично, в temp залеженість оберненого опору від напруги}
    Rsh0:=(temp^.X[1]/temp^.y[2]-temp^.X[2]/temp^.y[1])/(temp^.X[1]-temp^.X[2]);
  {Rsh0 - по початковим двом значенням опору проводиться пряма і визначається очікуване
      значення при нульовій напрузі}
   if (mode=1)or(mode=3) then Rsh0:=1e12;

    for I := 0 to High(temp^.X) do
      temp^.Y[i]:=(temp2^.Y[i]-temp2^.X[i]/Rsh0);
    {в temp - ВАХ з врахуванням Rsh0}

    k:=-1;
    for i:=0 to High(temp^.X) do
           if Temp^.Y[i]<0 then k:=i;
//    new(temp2);

   if k<0 then IVchar(temp,temp2)
          else
           begin
             SetLenVector(temp2,temp^.n-k-1);
             for i:=0 to High(temp2^.X) do
               begin
                temp2^.Y[i]:=temp^.Y[i+k+1];
                temp2^.X[i]:=temp^.X[i+k+1];
               end;
           end;
     for i:=0 to High(temp2^.X) do
       temp2^.Y[i]:=ln(temp2^.Y[i]);

{}    if High(temp2^.X)>6 then
         begin
         SetLenVector(temp,High(temp2^.X)-3);
         for i:=3 to High(temp2^.X) do
          begin
           temp^.X[i-3]:=temp2^.X[i];
           temp^.Y[i-3]:=temp2^.Y[i];
          end;
         end;
    LinAprox(temp,I00,n0);{}
{    LinAprox(temp2,I00,n0);{}
    I00:=exp(I00);
    n0:=1/(Kb*Vec^.T*n0);
    {I00 та n0 в результаті лінійної апроксимації залежності
    ln(I) від напруги, береться ВАХ з врахуванням Rsh0}
     for i:=0 to High(temp2^.X) do
       begin
       temp2^.Y[i]:=exp(temp2^.Y[i]);;
       end;
   {в temp2 - частина ВАХ з врахуванням Rsh0, для якої
   значення струму додатні}

    Diferen (temp2,temp);
     for i:=0 to High(temp.X) do
       begin
       temp^.X[i]:=1/temp2^.Y[i];
       temp^.Y[i]:=1/temp^.Y[i];
       end;
    {в temp - залежність dV/dI від 1/І}

    if temp^.n>5 then
       begin
       SetLenVector(temp2,5);
       for i:=0 to 4 do
         begin
             temp2^.X[i]:=temp^.X[High(temp.X)-i];
             temp2^.Y[i]:=temp^.Y[High(temp.X)-i];
         end;
       end
               else
           IVchar(temp2,temp);

    LinAprox(temp2,Rs0,temp^.X[0]);
    {Rs0 - як вільних член лінійної апроксимації
    щонайбільше п'яти останніх точок залежності dV/dI від 1/І;
   dV/dI= (nKbT)/(qI)+Rs;
    temp^.X[0] використане лише для того, щоб
    не вводити допоміжну змінну}
    if (mode=2)or(mode=3) then Rs:=1e-4;

    dispose(temp2);
    dispose(temp);
   end;


    Procedure VuhDatAprox (var n0,Rs0,I00,Rsh0:single);overload;
  {по значенням в V визначає початкове наближення
  для n,Rs,I0,Rsh}
  var temp,temp2:Pvector;
      i,k:integer;
   begin
    n0:=555;
    Rs0:=555;
    I00:=555;
    Rsh0:=555;
    new(temp);
    Diferen (Vec,temp);
  {фактично, в temp залеженість оберненого опору від напруги}
    Rsh0:=(temp^.X[1]/temp^.y[2]-temp^.X[2]/temp^.y[1])/(temp^.X[1]-temp^.X[2]);
  {Rsh0 - по початковим двом значенням опору проводиться пряма і визначається очікуване
      значення при нульовій напрузі}
   if (mode=1)or(mode=3) then Rsh0:=1e12;

    for I := 0 to High(temp^.X) do
      temp^.Y[i]:=(Vec^.Y[i]-Vec^.X[i]/Rsh0);
    {в temp - ВАХ з врахуванням Rsh0}
    k:=-1;
    for i:=0 to High(temp^.X) do
           if Temp^.Y[i]<0 then k:=i;
    new(temp2);

   if k<0 then IVchar(temp,temp2)
          else
           begin
             SetLenVector(temp2,temp^.n-k-1);
             for i:=0 to High(temp2^.X) do
               begin
                temp2^.Y[i]:=temp^.Y[i+k+1];
                temp2^.X[i]:=temp^.X[i+k+1];
               end;
           end;
     for i:=0 to High(temp2^.X) do
       temp2^.Y[i]:=ln(temp2^.Y[i]);

{}    if High(temp2^.X)>6 then
         begin
         SetLenVector(temp,High(temp2^.X)-3);
         for i:=3 to High(temp2^.X) do
          begin
           temp^.X[i-3]:=temp2^.X[i];
           temp^.Y[i-3]:=temp2^.Y[i];
          end;
         end;
    LinAprox(temp,I00,n0);{}
{    LinAprox(temp2,I00,n0);{}
    I00:=exp(I00);
    n0:=1/(Kb*Vec^.T*n0);
    {I00 та n0 в результаті лінійної апроксимації залежності
    ln(I) від напруги, береться ВАХ з врахуванням Rsh0}
     for i:=0 to High(temp2^.X) do
       begin
       temp2^.Y[i]:=exp(temp2^.Y[i]);;
       end;
   {в temp2 - частина ВАХ з врахуванням Rsh0, для якої
   значення струму додатні}

    Diferen (temp2,temp);
     for i:=0 to High(temp.X) do
       begin
       temp^.X[i]:=1/temp2^.Y[i];
       temp^.Y[i]:=1/temp^.Y[i];
       end;
    {в temp - залежність dV/dI від 1/І}

    if temp^.n>5 then
       begin
       SetLenVector(temp2,5);
       for i:=0 to 4 do
         begin
             temp2^.X[i]:=temp^.X[High(temp.X)-i];
             temp2^.Y[i]:=temp^.Y[High(temp.X)-i];
         end;
       end
               else
           IVchar(temp2,temp);

    LinAprox(temp2,Rs0,temp^.X[0]);
    {Rs0 - як вільних член лінійної апроксимації
    щонайбільше п'яти останніх точок залежності dV/dI від 1/І;
   dV/dI= (nKbT)/(qI)+Rs;
    temp^.X[0] використане лише для того, щоб
    не вводити допоміжну змінну}
    if (mode=2)or(mode=3) then Rs0:=1e-4;

    dispose(temp2);
    dispose(temp);
   end; //  VuhDatAprox

    Procedure VuhDatAprox (var n0,Rs0,Rsh0,Isc0,Voc0:single);overload;
  {по значенням в V визначає початкове наближення
  для n,Rs,I0,Rsh}
  var temp,temp2:Pvector;
      i:integer;
   begin
    n0:=555;
    Rsh0:=555;
    Rs:=555;
    Isc0:=IscCalc(Vec);
    Voc0:=VocCalc(Vec);
    if (Voc0<=0.002) then Exit;
    new(temp);
    Diferen (Vec,temp);
  {фактично, в temp залеженість оберненого опору від напруги}
    Rsh0:=(temp^.X[1]/temp^.y[2]-temp^.X[2]/temp^.y[1])/(temp^.X[1]-temp^.X[2]);
  {Rsh0 - по початковим двом значенням опору проводиться пряма і визначається очікуване
      значення при нульовій напрузі}
   if (mode=1)or(mode=3) then Rsh0:=1e12;

    for I := 0 to High(temp^.X) do
      begin
      temp^.Y[i]:=1/temp^.Y[i];
      temp^.X[i]:=Kb*Vec^.T/(Isc0+Vec^.Y[i]-Vec^.X[i]/Rsh0);
      end;
    new(temp2);
    if temp^.n>7 then
       begin
       SetLenVector(temp2,7);
       for i:=0 to 6 do
         begin
             temp2^.X[i]:=temp^.X[High(temp.X)-i];
             temp2^.Y[i]:=temp^.Y[High(temp.X)-i];
         end;
       end
               else
          IVchar(temp2,temp);
    LinAprox(temp2,Rs0,n0);
    {n та Rs0 - як нахил та вільних член лінійної апроксимації
    щонайбільше семи останніх точок залежності
    dV/dI від kT/q(Isc+I-V/Rsh);}
    if (mode=2)or(mode=3) then Rs0:=1e-4;
    dispose(temp2);
    dispose(temp);
   end; //  VuhDatAprox

 Procedure ExitThread;
  begin
//  Beep(300,500);
   SendMessage(Approx.Handle,WM_Close,0,0);
   SetEvent(event);
   Exit;
  end;


begin
OlegGraph.I0:=555;
OlegGraph.n:=555;
OlegGraph.Rs:=555;
OlegGraph.Rsh:=555;
OlegGraph.Isc:=555;
OlegGraph.Voc:=555;
OlegGraph.Iph:=555;

case OlegGraph.Func of
 1:begin  //функція Ламберта
    eps:=5e-7;
    Nmax:=10000;
   end;
 3:begin  //ВАХ освітленої структури
    eps:=8e-8;
    Nmax:=20000;
   end;
 4:begin  //ВАХ освітленої структури Ламбертом
    eps:=1e-7;
    Nmax:=10000;
   end;
 else begin   //за умовчанням - безпосередньо експонентою
       eps:=1e-8;
       Nmax:=20000;
       end;
 end;   //case OlegGraph.Func of

Synchronize(SendInformA);
if Vec^.n<7 then
            begin
              SendMessage(Approx.Handle,WM_Close,0,0);
              SetEvent(event);
              Exit;
            end;

 case OlegGraph.Func of
     3:i:=5; {змінні - n,Rs,Rsh,I0,Iph}
     4:i:=7; {змінні - n,Rs,Rsh,I0,Isc,Voc,Iph}
  else i:=4; {змінні - n,Rs,I0,Rsh}
 end;

SetLength(X,i);
SetLength(X2,i);
SetLength(F,i);

 case OlegGraph.Func of
     3:Npar:=5; {варьються n,Rs,I0,Rsh,Iph}
     4:Npar:=3; {варьються n,Rs,Rsh}
  else Npar:=4; {варьються n,Rs,I0,Rsh}
 end;


 case OlegGraph.Func of
    3:  VuhDatExpLightmAprox (X[0],X[1],X[2],X[3],X[4]);
    4:  VuhDatAprox (X[0],X[1],X[2],X[3],X[4]);
   else VuhDatAprox (X[0],X[1],X[2],X[3]);
 end;

 if X[0]=555 then ExitThread;


if (OlegGraph.mode=1)or(OlegGraph.mode=3) then X[3]:=1e12;
if (OlegGraph.mode=2)or(OlegGraph.mode=3) then X[1]:=1e-4;
 case OlegGraph.Func of
    1:  if not(ParamCorect(Vec,LamParamIsBad,X[0],X[1],X[2],X[3])) then ExitThread;
    4:  if not(ParamCorect(Vec,X[0],X[1],X[2],X[3],X[4])) then ExitThread;
   else if not(ParamCorect(Vec,ExpParamIsBad,X[0],X[1],X[2],X[3])) then ExitThread;
 end;


 Nit:=0;
 sum2:=1;

repeat
 if Nit<1 then
     case OlegGraph.Func of
        1:  if (FG_LamShot(Vec,X,F,Sum)<>0)  then ExitThread;
        3:  if (FG_ExpLightShot(Vec,X,F,Sum)<>0)  then ExitThread;
        4:  if (FG_LamLightShot(Vec,X[0],X[1],X[2],X[3],X[4],F,Sum)<>0) then ExitThread;
       else if (FG_ExpShot(Vec,X,F,Sum)<>0)  then ExitThread;
     end;

  bool:=true;
  if not(odd(Nit)) then for I := 0 to Npar-1 do X2[i]:=X[i];
  if not(odd(Nit))or (Nit=0) then sum2:=sum;

  for I := 0 to Npar-1 do
     begin
       if Terminated then Continue;
       if ((OlegGraph.mode=1)or(OlegGraph.mode=3))and(i=3) then Continue;
       if ((OlegGraph.mode=2)or(OlegGraph.mode=3))and(i=1) then Continue;
       if F[i]=0 then Continue;
       if abs(X[i]/100/F[i])>1e30 then Continue;
       al:=Secant(i,0,0.1*abs(X[i]/F[i]),F[i]);
       X[i]:=X[i]-al*F[i];
       case OlegGraph.Func of
          1:  if not(ParamCorect(Vec,LamParamIsBad,X[0],X[1],X[2],X[3])) then ExitThread;
          4:  if not(ParamCorect(Vec,X[0],X[1],X[2],X[3],X[4])) then ExitThread;
         else if not(ParamCorect(Vec,ExpParamIsBad,X[0],X[1],X[2],X[3])) then ExitThread;
       end;
       bool:=(bool)and(abs((X2[i]-X[i])/X[i])<eps);
       case OlegGraph.Func of
          1:  if (FG_LamShot(Vec,X,F,Sum)<>0) then ExitThread;
          3:  if (FG_ExpLightShot(Vec,X,F,Sum)<>0)  then ExitThread;
          4:  if (FG_LamLightShot(Vec,X[0],X[1],X[2],X[3],X[4],F,Sum)<>0)  then ExitThread;
         else if (FG_ExpShot(Vec,X,F,Sum)<>0) then ExitThread;
       end;
     end;

  if (Nit mod 25)=0 then  Synchronize(SendInform);
  Inc(Nit);
until (abs((sum2-sum)/sum)<eps) or bool or (Nit>Nmax) or Terminated;


if not(Terminated) then
    case OlegGraph.Func of
      4:
        begin
        OlegGraph.n:=X[0];
        OlegGraph.Rs:=X[1];
        OlegGraph.I0:=(X[3]+(X[1]*X[3]-X[4])/X[2])*exp(-X[4]/X[0]/Kb/Vec^.T)/
                       (1-exp((X[1]*X[3]-X[4])/X[0]/Kb/Vec^.T));
        OlegGraph.Rsh:=X[2];
        OlegGraph.Iph:=OlegGraph.I0*(exp(X[4]/X[0]/Kb/Vec^.T)-1)+X[4]/X[2];
        OlegGraph.Voc:=Voc_Isc_Pm(1,Vec,OlegGraph.n,OlegGraph.Rs,OlegGraph.I0,
                               OlegGraph.Rsh,OlegGraph.Iph);
        OlegGraph.Isc:=Voc_Isc_Pm(2,Vec,OlegGraph.n,OlegGraph.Rs,OlegGraph.I0,
                               OlegGraph.Rsh,OlegGraph.Iph);
        {OlegGraph.Voc:=X[4];
        OlegGraph.Isc:=X[3];}
        SendMessage(Approx.Handle,WM_Close,0,0);
        end;
      3:
        begin
        OlegGraph.n:=X[0];
        OlegGraph.Rs:=X[1];
        OlegGraph.I0:=X[2];
        OlegGraph.Rsh:=X[3];
        OlegGraph.Iph:=X[4];
        OlegGraph.Voc:=Voc_Isc_Pm(1,Vec,OlegGraph.n,OlegGraph.Rs,OlegGraph.I0,
                               OlegGraph.Rsh,OlegGraph.Iph);
        OlegGraph.Isc:=Voc_Isc_Pm(2,Vec,OlegGraph.n,OlegGraph.Rs,OlegGraph.I0,
                               OlegGraph.Rsh,OlegGraph.Iph);
        SendMessage(Approx.Handle,WM_Close,0,0);
        end;
      else
        begin
        OlegGraph.n:=X[0];
        OlegGraph.Rs:=X[1];
        OlegGraph.I0:=X[2];
        OlegGraph.Rsh:=X[3];
        SendMessage(Approx.Handle,WM_Close,0,0);
        end;
    end;
SetEvent(event);
end;

procedure Apr.SendInform;
begin
Approx.Label5.Caption:=Inttostr(Nit);
Approx.Label7.Caption:=floattostrf(X[0],ffExponent,4,3);
Approx.Label8.Caption:=floattostrf(X[1],ffExponent,4,3);
case OlegGraph.Func of
   0,1:
      begin
      Approx.Label6.Caption:=floattostrf(X[2],ffExponent,4,3);
      Approx.Label9.Caption:=floattostrf(X[3],ffExponent,4,3);
      end;
    3:
      begin
      Approx.Label6.Caption:=floattostrf(X[2],ffExponent,4,3);
      Approx.Label9.Caption:=floattostrf(X[3],ffExponent,4,3);
      Approx.Label13.Caption:=floattostrf(X[4],ffExponent,4,3);
      end;
    4:Approx.Label9.Caption:=floattostrf(X[2],ffExponent,4,3);
   end;
end;

procedure Apr.SendInformA;
begin
Approx.Label4.Caption:=inttostr(Nmax);
end;


end.

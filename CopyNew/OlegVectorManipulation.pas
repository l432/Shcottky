unit OlegVectorManipulation;

interface
 uses OlegVectorNew,OlegTypeNew;


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



   TVectorTransform=class(TVectorManipulation)
    private
     Procedure InitTarget(var Target:TVectorNew);
     Procedure CopyLimited (Coord:TCoord_type;var Target:TVectorNew;Clim1, Clim2:double);
     procedure Branch(Coord:TCoord_type;var Target:TVectorNew;const IsPositive:boolean=True);
     procedure Module(Coord:TCoord_type;var Target:TVectorNew);
    public
     Procedure CopyLimitedX (var Target:TVectorNew;Xmin,Xmax:double);
       {��������� � ������ ������� � Target
        - �����, ��� ���� ������� � ������� �� Xmin �� Xmax �������
         - ���� � �� name}
     Procedure CopyLimitedY (var Target:TVectorNew;Ymin,Ymax:double);
     Procedure PositiveX(var Target:TVectorNew);
         {�������� � Target � �����, ��� ���� X ����� ��� ���� ����}
     procedure PositiveY(var Target:TVectorNew);
         {�������� � Target � �����, ��� ���� Y ����� ��� ���� ����}
     procedure AbsX(var Target:TVectorNew);
         {�������� � Target �����, ��� ���� X ������� ������ � ������
         �������, � Y ���� ����; ���� �=0, �� ����� ����������}
     procedure AbsY(var Target:TVectorNew);
         {�������� � Target �����, ��� ���� Y ������� ������ Y ������
         �������, � X ���� ����; ���� Y=0, �� ����� ����������}
     procedure NegativeX(var Target:TVectorNew);
         {�������� � Target � �����, ��� ���� X ����� ����}
     procedure NegativeY(var Target:TVectorNew);
         {�������� � Target � �����, ��� ���� Y ����� ����}
     Procedure Splain3(beg:double; step:double; var Target:TVectorNew);
      {� Target ��������� ������������ �����
      � ������������� ������� �������,
      ��������� � ����� � �����������
      beg � � ������ step;
      ���� ������� ������� �����������
      (�� ��������� � ������� ���� ������� �������),
      �� � ������������� ������ ������� �������}
     Function YvalueSplain3(Xvalue:double):double;
    {������� ���������� �������� ������� � ����� Xvalue ��������������
     ����� �������, ��������� �� ����� ������ ����� � ����� V
     Result=Ai+Bi(X-Xi)+Ci(X-Xi)^2+Di(X-Xi)^3 ��� Xi-1<=X<=Xi}


   end;


Function Kub (x:double;coef:array of double):double;overload;
{������� coef[0]+coef[1]*(x-coef[4])+
                  coef[2]*(x-coef[4])^2+
                  coef[3]*(x-coef[4])^3;
�������, �������, ��� ����������� �������}

Function Kub(x:double;
             Point:TPointDouble;
             SplainCoef:TSplainCoef):double;overload;

Procedure SplainCoefCalculate(V:TVectorNew;var SplainCoef:TSplainCoefArray);
{�������������� ����������� �������� ��� ������������ ����� � Vector}

implementation




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
                const IsPositive: boolean);
  var i:integer;
begin
 InitTarget(Target);
 for I := 0 to Vector.Count-1 do
   if (IsPositive) then
      begin
       if(Vector[i][Coord]>=0) then Target.Add(Vector[i])
      end          else
      if(Vector[i][Coord]<0) then Target.Add(Vector[i]);
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

procedure TVectorTransform.InitTarget(var Target: TVectorNew);
begin
  try
   Target.Clear
  except
   Target:=TVectorNew.Create;
  end;
  Target.T:=fVector.T;
end;

procedure TVectorTransform.NegativeX(var Target: TVectorNew);
begin
  Branch(cX,Target,false);
end;

procedure TVectorTransform.NegativeY(var Target: TVectorNew);
begin
 Branch(cY,Target,false);
end;

procedure TVectorTransform.PositiveX(var Target: TVectorNew);
begin
 Branch(cX,Target);
end;

procedure TVectorTransform.PositiveY(var Target: TVectorNew);
begin
 Branch(cY,Target);
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
{������� coef[0]+coef[1]*(x-coef[4])+
                  coef[2]*(x-coef[4])^2+
                  coef[3]*(x-coef[4])^3;
�������, �������, ��� ����������� �������}
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

end.

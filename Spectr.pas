unit Spectr;
{����, ���'����� � �������� ������� -
����������������� ��� ������ � ��������� ����������� ����}

interface

uses
  OlegVector,OlegMaterialSamples,OlegType;

type
// TProcedFile=Procedure(FileName:string);

 TLampType=(ltGE,ltOrion,ltOsram);

const

  PhotodiodDatFileName='Photodiod.dat';

  FileNameBegin:array[TLampType]of string=
   ('GE','Orion','Osram');
  FileNameBeginShot:array[TLampType]of string=
   ('Ge','Or','Os');

  {������� �������� �������}
  MSCount:array[TLampType]of byte=
//   (2,2,3);
   (2,3,4);

  {������� �������, �� ������� ��������}
  CSCount:array[TLampType]of byte=
   (3,7,6);

  Intensities :array[0..6] of integer=
  (200,300,400,500,600,700,750);

//  {����������� ����� ��������� ������� ������������ �� ��������� �������}
//  KoefB:array[TLampType]of double =
//   (558.95,557.14,586.99);
//  KoefA:array[TLampType]of double =
//   (-84.93,-139.39,-88.56);

  {�����f ������������ ��� ������� �� ������� 464-hc/Eg � ������ �������,
  �������� ��������� ��������� ���������, ������� �� �����������
  ������� ��������� �� ����������� ������������}
  DiapazonPart:array[TLampType]of double =
   (0.75,0.8,0.8);


procedure DatFileNoiseSmoothing(Npoint: Word=5;Syffix:string='fit');
{�������� ������� *.dat ����, ������ ��� � ����� �� Npoint ������
� ������ ��������� � ����, � ���� ����� ����� �������� Syffix}

procedure SpectrApproxmation(BeginLambda:double=464;
                             EndLambda:double=1192;
                             StepLambda:double=1;
                             Syffix:string='A');
{�������� ������� *.dat ����, � ���� ������� �����������
��������� ��  BeginLambda  ��  EndLambda � ������  StepLambda,
��� ����� ��������������� ������������ ������� ��������� ���������;
� ������ ��������� � ����, � ���� ����� ����� �������� Syffix}



procedure NormSpectr(FileName:string);
{���������� ��� � ����� FileName � ��������
�� ��������� �������� ����������� � ����, � ���� ����� ����� �������� 'N'}

procedure NormNphSpectr(FileName:string);
{���������� ��� � ����� FileName,
��������, �� ����� ������� - ������� ����,
� ����� ���������,  � ����, � ���� ����� ����� �������� 'Nph',
����������  ��������� ��������� ������� ������ �� ������� ����}

procedure ToLampSpectr(FileName:string);
{�������� ����� ������� �  FileName �������
�� ��������, �� ����������� � PhotodiodDatFileName (��� �� ����
��������� ��������), �������� ����������� � ����,
� ���� ����� ����� �������� 'L'}

//procedure VectorArrayCreate (var VectorArray:TArrVec;Number:integer);
//procedure VectorArrayFreeAndNil (var VectorArray:TArrVec);

procedure VectorArrayAddFile (var VectorArray:TArrVec;FileName:string);overload;
{��������� ���� � ������ FileName � �� ���� Vector, ���� �������� �� ������}
procedure VectorArrayAddFile (FileName:string);overload;
{������ � ������� Spectrums}

procedure AllDatFileToOne(ResultFileName:string='AllFiles');
{�� ����� .dat ������� � ������� �������� ���������� � ����
� ������ ResultFileName+'.dat'}

procedure SpectrCreateFull();

procedure AbbSpectr(BeginLambda:double=464;
                   EndLambda:double=1192;
                   StepLambda:double=1);
{������� ����������� ��������� ��  BeginLambda  ��  EndLambda � ������  StepLambda
fraction of the band-to-band transitions,
��������� ������ �������� �������}


var Spectrums:TArrVec;

implementation

uses
  OlegVectorManipulation, Vcl.Dialogs, System.SysUtils, OlegFunction,
  OlegMath, Vcl.FileCtrl, System.Classes, System.Math, OApproxFunction2;


procedure DatFileNoiseSmoothing(Npoint: Word=5;Syffix:string='fit');
{�������� ������� *.dat ����, ������ ��� � ����� �� Npoint ������
� ������ ��������� � ����, � ���� ����� ����� �������� Syffix}
 var  EndFile:TVector;
      InitFile:TVectorTransform;
      OD: TOpenDialog;
begin
OD:=TOpenDialog.Create(nil);
OD.Filter:='data file|*.dat|all file|*.*';
if OD.Execute()
  then
   begin
    EndFile:=TVector.Create;
    InitFile:=TVectorTransform.Create;
    InitFile.ReadFromFile(OD.FileName);

    InitFile.ImNoiseSmoothedArray(EndFile,Npoint);
    EndFile.WriteToFile(FitName(OD.FileName,Syffix),6);

    FreeAndNil(InitFile);
    FreeAndNil(EndFile);
   end;
FreeAndNil(OD);

end;

procedure SpectrApproxmation(BeginLambda:double=464;
                             EndLambda:double=1192;
                             StepLambda:double=1;
                             Syffix:string='A');
 var  EndFile:TVector;
      InitFile:TVectorTransform;
      OD: TOpenDialog;
      currentLambda:double;
      FirstEndLambda:double;
begin
OD:=TOpenDialog.Create(nil);
OD.Filter:='data file|*.dat|all file|*.*';
if OD.Execute()
  then
   begin
    EndFile:=TVector.Create;
    InitFile:=TVectorTransform.Create;
    InitFile.ReadFromFile(OD.FileName);

    if EndLambda<BeginLambda then Swap(EndLambda,BeginLambda);

    FirstEndLambda:=(EndLambda-BeginLambda)*0.2+BeginLambda;
//    showmessage(floattostr(FirstEndLambda));
    InitFile.Sorting(False);
    currentLambda:=BeginLambda;
    repeat
     EndFile.Add(currentLambda,InitFile.YvalueSplain3(currentLambda));
     currentLambda:=currentLambda+StepLambda;
    until currentLambda>FirstEndLambda;

    InitFile.Sorting(True);
    repeat
     EndFile.Add(currentLambda,InitFile.YvalueSplain3(currentLambda));
     currentLambda:=currentLambda+StepLambda;
    until currentLambda>EndLambda;
    EndFile.WriteToFile(FitName(OD.FileName,Syffix),6,'Lambda ArbUnit');

    FreeAndNil(InitFile);
    FreeAndNil(EndFile);
   end;
FreeAndNil(OD);
end;


procedure AbbSpectr(BeginLambda:double=464;
                   EndLambda:double=1192;
                   StepLambda:double=1);
{������� ����������� ��������� ��  BeginLambda  ��  EndLambda � ������  StepLambda
fraction of the band-to-band transitions,
��������� ������ �������� �������}
 var  AbbFile:TVector;
      AbbAproxFile:TVectorTransform;
      currentLambda,temp:double;
begin
 AbbFile:=TVector.Create;
 AbbAproxFile:=TVectorTransform.Create;
 if EndLambda<BeginLambda then Swap(EndLambda,BeginLambda);
 currentLambda:=BeginLambda;
 repeat
//   AbbFile.Add(currentLambda,Silicon.Abb(currentLambda,3e26,0.39e-6,True,340));
//   AbbAproxFile.Add(currentLambda,Silicon.AbbAppox(currentLambda,3e26,0.39e-6,True,340));
//   AbbAproxFile.Add(currentLambda,Silicon.AbbAppox(currentLambda,1.36e21,380e-6,False,340));

  //��������� ������� ��������� ����
  temp:=sqr(IntegralRomberg(Bowden,[70,340,1.36e21,1,currentLambda],0,380e-6,1e-7))
        /IntegralRomberg(Bowden2,[70,340,1.36e21,1,currentLambda],0,380e-6,1e-7);


//  temp:=Silicon.Absorption(currentLambda,340);
  AbbFile.Add(currentLambda,temp);



   currentLambda:=currentLambda+StepLambda;

//     CreatedSpectr[j].Y[i]:=IntegralRomberg(Bowden2,[60.2,340,1.36e21,CreatedSpectr[j].Y[i],CreatedSpectr[j].X[i]],0,380e-6)
//                               /IntegralRomberg(Bowden,[60.2,340,1.36e21,CreatedSpectr[j].Y[i],CreatedSpectr[j].X[i]],0,380e-6);


 until currentLambda>EndLambda;
// AbbFile.WriteToFile('Abb.dat',6,'Lambda Fraction');
// AbbAproxFile.WriteToFile('AbbAprox.dat',6,'Lambda Fraction');
 AbbFile.WriteToFile('WeffL70.dat',6,'Lambda Weff');

 FreeAndNil(AbbFile);
 FreeAndNil(AbbAproxFile);
end;

procedure NormSpectr(FileName:string);
 var Vec:TVectorTransform;
begin
 Vec:=TVectorTransform.Create;
 Vec.ReadFromFile(FileName);
 Vec.MultiplyY(1/Vec.MaxY);
 Vec.WriteToFile(FitName(Vec,'N'),6,'Lambda Wil');
 FreeAndNil(Vec);
end;

procedure NormNphSpectr(FileName:string);
{���������� ��� � ����� FileName,
��������, �� ����� ������� - ������� ����,
� ����� ���������,  � ����, � ���� ����� ����� �������� 'Nph',
����������  ��������� ��������� ������� ������ �� ������� ����}
 var Vec:TVectorTransform;
     i:integer;
begin
 Vec:=TVectorTransform.Create;
 Vec.ReadFromFile(FileName);
 for I := 0 to Vec.HighNumber do
    Vec.Y[i]:=Vec.X[i]*Vec.Y[i];
 Vec.MultiplyY(1/Vec.MaxY);
 Vec.WriteToFile(FitName(Vec,'Nph'),6,'Lambda Nph');
 FreeAndNil(Vec);
end;

procedure ToLampSpectr(FileName:string);
{�������� ����� ������� �  FileName �������
�� ��������, �� ����������� � PhotodiodDatFileName (��� �� ����
��������� ��������), �������� ����������� � ����,
� ���� ����� ����� �������� 'L'}
 var Vec,Vec2:TVectorTransform;
     i:integer;
begin
 if FileName=PhotodiodDatFileName then Exit;

 Vec:=TVectorTransform.Create;
 Vec.ReadFromFile(FileName);
 Vec2:=TVectorTransform.Create;
 Vec2.ReadFromFile(PhotodiodDatFileName);
 for I := 0 to Vec.HighNumber do
    Vec.Y[i]:=Vec.Y[i]/Vec2.Y[i];
 Vec.WriteToFile(FitName(Vec,'L'),6,'Lambda Wil');
 FreeAndNil(Vec2);
 FreeAndNil(Vec);
end;


//procedure VectorArrayCreate (var VectorArray:TArrVec;Number:integer);
// var i:integer;
//begin
//  SetLength(VectorArray,Number);
//  for I := 0 to High(VectorArray) do
//    VectorArray[i]:=TVector.Create;
//end;
//
//procedure VectorArrayFreeAndNil (var VectorArray:TArrVec);
// var i:integer;
//begin
//  for I := 0 to High(VectorArray) do
//    FreeAndNil(VectorArray[i]);
//  SetLength(VectorArray,0);
//end;

procedure VectorArrayAddFile (var VectorArray:TArrVec;FileName:string);
{��������� ���� � ������ FileName � �� ���� Vector, ���� �������� �� ������}
begin
 SetLength(VectorArray,High(VectorArray)+2);
 VectorArray[High(VectorArray)]:=TVector.Create;
 VectorArray[High(VectorArray)].ReadFromFile(FileName);
end;

procedure VectorArrayAddFile (FileName:string);overload;
 begin
  VectorArrayAddFile(Spectrums,FileName);
 end;

procedure AllDatFileToOne(ResultFileName:string='AllFiles');
{�� ����� .dat ������� � ������� �������� ���������� � ����
� ������ ResultFileName+'.dat'}
 var   Str:TStringList;
       tempstr:string;
       i,j:integer;
begin
 ForAllDatFilesAction(VectorArrayAddFile);
// showmessage(inttostr(High(Spectrums)));
 if High(Spectrums)>-1 then
  begin
   Str:=TStringList.Create;
   tempstr:='X';
   for i:=0 to High(Spectrums) do
     tempstr:=tempstr+' '+copy(Spectrums[i].name,1,length(Spectrums[i].name)-4);
   Str.Add(tempstr);
   for j:=0 to Spectrums[0].HighNumber do
    begin
     tempstr:=FloatToStrF(Spectrums[0].X[j],ffExponent,6,0);
     for i:=0 to High(Spectrums) do
      if j<=Spectrums[i].HighNumber then
         tempstr:=tempstr+' '+FloatToStrF(Spectrums[i].Y[j],ffExponent,6,0);
     Str.Add(tempstr);
    end;
   Str.SaveToFile(ResultFileName+'.dat');
   FreeAndNil(Str);
  end;
  VectorArrayFreeAndNil(Spectrums);
end;

procedure SpectrCreateFull();
 var Slide:TVectorTransform;
     LampType:TLampType;
     CreatedSpectr:TArrVec;
     i,j,PointCount:integer;
     Wph:integer;
     Lmax,Abb,Weff,R:double;
     SL:TStringList;
     OutputData:TArrSingle;
     Reflection:TVector;

begin
//  ChDir('D:\Samples\DeepL\2022\Lamps\SpectrNew');
  ChDir('D:\DeepL\2022\Lamps\SpectrNew');

  Slide:=TVectorTransform.Create;

//  Wph:=2630;
//  for i := 190 to 2000 do
//    Slide.Add(i,TFFPlanc.Planck(i,Wph));
//  Slide.WriteToFile('Plank'+inttostr(Wph)+'.dat',8,'Lambda ArbUnit');

  Lmax:=Hpl*2*Pi*Clight*1e9/(Qelem*Silicon.Eg(340));
  SL:=TStringList.Create;
  Reflection:=TVector.Create;
  Reflection.ReadFromFile('ReflecA.dat');
  Reflection.DeleteXMoreTnanNumber(Lmax);
//  showmessage(Reflection.XYtoString());
//  Exit;

  for LampType := Low(TLampType) to High(TLampType) do
   begin
//    ForAllDatFilesAction(VectorArrayAddFile,'D:\Samples\DeepL\2022\Lamps',
    ForAllDatFilesAction(VectorArrayAddFile,'D:\DeepL\2022\Lamps',
                         FileNameBegin[LampType]);



    Slide.Clear;
    for I := 0 to High(Spectrums) do
     begin
      Spectrums[i].name:=ChangeFileExt(Spectrums[i].name,'');
//      SL.Add(Spectrums[i].name+' '+floattostr(Spectrums[i].Int_Trap));
      Spectrums[i].DeleteXMoreTnanNumber(Lmax);
//      SL.Add(Spectrums[i].name+' '+floattostr(Spectrums[i].Int_Trap));
      Wph:=StrToInt(Copy(Spectrums[i].name,Length(FileNameBegin[LampType])+1,3));
      Slide.Add(Wph,Wph);

     end;

    PointCount:=Spectrums[0].HighNumber;

    VectorArrayCreate (CreatedSpectr,CSCount[LampType]);
    for j := 0 to High(CreatedSpectr) do
      CreatedSpectr[j].name:=FileNameBegin[LampType]+IntToStr(Intensities[j]);

    for I := 0 to PointCount do
     begin
      for j := 0 to High(Spectrums) do
       Slide.Y[j]:=Spectrums[j].Y[i];

      if High(Spectrums)=1 then
       begin
        Slide.LinAprox(OutputData);
        for j := 0 to High(CreatedSpectr) do
         CreatedSpectr[j].Add(Spectrums[0].X[i],max(NPolinom(Intensities[j],OutputData),0));
       end                 else
       begin
        for j := 0 to High(CreatedSpectr) do
         begin
           if Slide.ValueNumber(cX,Intensities[j])<>-1
            then CreatedSpectr[j].Add(Spectrums[0].X[i],Slide.Yvalue(Intensities[j]))
            else
             begin
              if Intensities[j]<Slide.MinX
               then CreatedSpectr[j].Add(Spectrums[0].X[i],
                                      max(Y_X0(Slide.Point[0],Slide.Point[1],Intensities[j]),0))
               else CreatedSpectr[j].Add(Spectrums[0].X[i],
                                      max(Y_X0(Slide.Point[Slide.HighNumber-1],Slide.Point[Slide.HighNumber],Intensities[j]),0))
             end;
         end;
       end;
     end;
   {���������� ��� ��� �������� ������������ �������������� �������}

    for j := 0 to High(CreatedSpectr) do
     begin
      CreatedSpectr[j].MultiplyY(1/CreatedSpectr[j].Int_Trap);
      {��������� ������������� ���������}
//      CreatedSpectr[j].WriteToFile(FileNameBeginShot[LampType]+'CrN'+Inttostr(Intensities[j])+'.dat',
//                                 6,'Lambda ArbUnit');

      CreatedSpectr[j].MultiplyY(Intensities[j]*DiapazonPart[LampType]);
      {��������� �������������, ���}
//      CreatedSpectr[j].WriteToFile(FileNameBeginShot[LampType]+'Cr'+Inttostr(Intensities[j])+'.dat',
//                                 6,'Lambda ArbUnit');


      for I := 0 to PointCount do
       CreatedSpectr[j].Y[i]:=CreatedSpectr[j].X[i]*1e-9*CreatedSpectr[j].Y[i]*1e-3/(Hpl*2*Pi*Clight);
      {������� ������ �� �������}
//      CreatedSpectr[j].WriteToFile(FileNameBeginShot[LampType]+'CrNph'+Inttostr(Intensities[j])+'.dat',
//                                 6,'Lambda ArbUnit');
//      SL.Add(CreatedSpectr[j].name+' '+floattostr(CreatedSpectr[j].Int_Trap));


      for I := 0 to PointCount do
        try
         Abb:=Silicon.Abb(CreatedSpectr[j].X[i],1.36e21,380e-6,False,340);
         Weff:=sqr(IntegralRomberg(Bowden,[70,340,1.36e21,1,CreatedSpectr[j].X[i]],0,380e-6,1e-7))
          /IntegralRomberg(Bowden2,[70,340,1.36e21,1,CreatedSpectr[j].X[i]],0,380e-6,1e-7);
         R:=Reflection.Yvalue(CreatedSpectr[j].X[i]);

        CreatedSpectr[j].Y[i]:=CreatedSpectr[j].Y[i]*Abb*(1-R)/(Weff*100);

//        CreatedSpectr[j].Y[i]:=IntegralRomberg(Bowden2,[60.2,340,1.36e21,CreatedSpectr[j].Y[i],CreatedSpectr[j].X[i]],0,380e-6)
//                               /IntegralRomberg(Bowden,[60.2,340,1.36e21,CreatedSpectr[j].Y[i],CreatedSpectr[j].X[i]],0,380e-6);
        except
         CreatedSpectr[j].Y[i]:=0;
        end;
      {����� ����������� � ����������� ���������� �� ������}
//      CreatedSpectr[j].WriteToFile(FileNameBeginShot[LampType]+'Bow'+Inttostr(Intensities[j])+'.dat',
//                                 6,'Lambda ArbUnit');


      CreatedSpectr[j].WriteToFile(FileNameBeginShot[LampType]+'G'+Inttostr(Intensities[j])+'.dat',
                                 6,'Lambda G');


      SL.Add(CreatedSpectr[j].name+' '+floattostr(CreatedSpectr[j].Int_Trap));


//      Lmax:=CreatedSpectr[j].Int_Trap;
//      for I := 0 to PointCount do
//       CreatedSpectr[j].Y[i]:=CreatedSpectr[j].Y[i]*Hpl*2*Pi*Clight/(CreatedSpectr[j].X[i]*1e-9*Qelem);
//      SL.Add(CreatedSpectr[j].name+' '+floattostr(CreatedSpectr[j].Int_Trap/Lmax));

     end;


//   for j := 0 to High(CreatedSpectr) do
//     CreatedSpectr[j].WriteToFile(FileNameBegin[LampType]+'Cr'+Inttostr(Intensities[j])+'.dat',
//                                 6,'Lambda ArbUnit');



    VectorArrayFreeAndNil (CreatedSpectr);
    VectorArrayFreeAndNil(Spectrums);
   end;

  FreeAndNil(Reflection);
  SL.SaveToFile('noname.dat');
  SL.Free;
  FreeAndNil(Slide);
end;

end.

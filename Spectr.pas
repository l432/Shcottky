unit Spectr;
{щось, пов'язане з обробкою спектрів -
використовувалося для роботи зі спектрами галогенових ламп}

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

  {кількості виміряних спектрів}
  MSCount:array[TLampType]of byte=
//   (2,2,3);
   (2,3,4);

  {кількості спектрів, які потрібно створити}
  CSCount:array[TLampType]of byte=
   (3,7,6);

  Intensities :array[0..6] of integer=
  (200,300,400,500,600,700,750);

//  {коефіцієнти лінійної залежності сумарної інтенсивності від інтегралу спектру}
//  KoefB:array[TLampType]of double =
//   (558.95,557.14,586.99);
//  KoefA:array[TLampType]of double =
//   (-84.93,-139.39,-88.56);

  {часткf інтенсивності яка припадає на діапазон 464-hc/Eg зі всього спектру,
  значення пораховані достатньо наближено, зокрема не враховується
  можлива залежність від інтегральної інтенсивності}
  DiapazonPart:array[TLampType]of double =
   (0.75,0.8,0.8);


procedure DatFileNoiseSmoothing(Npoint: Word=5;Syffix:string='fit');
{дозволяє вибрати *.dat файл, зглажує дані в ньому по Npoint точкам
і записує результат у файл, в кінці назви якого дописано Syffix}

procedure SpectrApproxmation(BeginLambda:double=464;
                             EndLambda:double=1192;
                             StepLambda:double=1;
                             Syffix:string='A');
{дозволяє вибрати *.dat файл, а потім створює спектральну
залежність від  BeginLambda  до  EndLambda з кроком  StepLambda,
при цьому використовується апроксимація зчитаної залежності сплайнами;
і записує результат у файл, в кінці назви якого дописано Syffix}

procedure NormSpectr(FileName:string);
{зчитуються дані з файлу FileName і нормовані
за ординатою значення записуються у файл, в кінці назви якого дописано 'N'}

procedure NormNphSpectr(FileName:string);
{зчитуються дані з файлу FileName,
вважаючи, що перша колонка - довжина хвилі,
а друга потужність,  у файл, в кінці назви якого дописано 'Nph',
записується  нормована залежність кількості фотонів від довжини хвилі}

procedure ToLampSpectr(FileName:string);
{значення другої колонки в  FileName діляться
на величини, що знаходяться в PhotodiodDatFileName (там має бути
чутливість приймача), значення записуються у файл,
в кінці назви якого дописано 'L'}

//procedure VectorArrayCreate (var VectorArray:TArrVec;Number:integer);
//procedure VectorArrayFreeAndNil (var VectorArray:TArrVec);

procedure VectorArrayAddFile (var VectorArray:TArrVec;FileName:string);overload;
{зчитується файл з назвою FileName у ще один Vector, який додається до масиву}
procedure VectorArrayAddFile (FileName:string);overload;
{працює з масивом Spectrums}

procedure AllDatFileToOne(ResultFileName:string='AllFiles');
{всі файли .dat файлами у вибраній директорії поєднуються у один
з назвою ResultFileName+'.dat'}

procedure SpectrCreateFull();


var Spectrums:TArrVec;

implementation

uses
  OlegVectorManipulation, Vcl.Dialogs, System.SysUtils, OlegFunction,
  OlegMath, Vcl.FileCtrl, System.Classes, System.Math, OApproxFunction2;


procedure DatFileNoiseSmoothing(Npoint: Word=5;Syffix:string='fit');
{дозволяє вибрати *.dat файл, зглажує дані в ньому по Npoint точкам
і записує результат у файл, в кінці назви якого дописано Syffix}
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
{зчитуються дані з файлу FileName,
вважаючи, що перша колонка - довжина хвилі,
а друга потужність,  у файл, в кінці назви якого дописано 'Nph',
записується  нормована залежність кількості фотонів від довжини хвилі}
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
{значення другої колонки в  FileName діляться
на величини, що знаходяться в PhotodiodDatFileName (там має бути
чутливість приймача), значення записуються у файл,
в кінці назви якого дописано 'L'}
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
{зчитується файл з назвою FileName у ще один Vector, який додається до масиву}
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
{всі файли .dat файлами у вибраній директорії поєднуються у один
з назвою ResultFileName+'.dat'}
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
     Lmax:double;
     SL:TStringList;
     OutputData:TArrSingle;

begin
  ChDir('D:\Samples\DeepL\2022\Lamps\SpectrNew');
  Slide:=TVectorTransform.Create;

//  Wph:=2630;
//  for i := 190 to 2000 do
//    Slide.Add(i,TFFPlanc.Planck(i,Wph));
//  Slide.WriteToFile('Plank'+inttostr(Wph)+'.dat',8,'Lambda ArbUnit');

  Lmax:=Hpl*2*Pi*Clight*1e9/(Qelem*Silicon.Eg(340));
  SL:=TStringList.Create;
  for LampType := Low(TLampType) to High(TLampType) do
   begin
    ForAllDatFilesAction(VectorArrayAddFile,'D:\Samples\DeepL\2022\Lamps',
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
   {згенеровані для всіх потрібних інтегральних інтенсивностей спектри}

    for j := 0 to High(CreatedSpectr) do
     begin
      CreatedSpectr[j].MultiplyY(1/CreatedSpectr[j].Int_Trap);
      {потужність випромінювання нормована}
      CreatedSpectr[j].WriteToFile(FileNameBeginShot[LampType]+'CrN'+Inttostr(Intensities[j])+'.dat',
                                 6,'Lambda ArbUnit');

      CreatedSpectr[j].MultiplyY(Intensities[j]*DiapazonPart[LampType]);
      {потужність випромінювання, мВт}
      CreatedSpectr[j].WriteToFile(FileNameBeginShot[LampType]+'Cr'+Inttostr(Intensities[j])+'.dat',
                                 6,'Lambda ArbUnit');


      for I := 0 to PointCount do
       CreatedSpectr[j].Y[i]:=CreatedSpectr[j].X[i]*1e-9*CreatedSpectr[j].Y[i]*1e-3/(Hpl*2*Pi*Clight);
      {кількість фотонів за секунду}
      CreatedSpectr[j].WriteToFile(FileNameBeginShot[LampType]+'CrNph'+Inttostr(Intensities[j])+'.dat',
                                 6,'Lambda ArbUnit');
      SL.Add(CreatedSpectr[j].name+' '+floattostr(CreatedSpectr[j].Int_Trap));


      for I := 0 to PointCount do
        try
        CreatedSpectr[j].Y[i]:=IntegralRomberg(Bowden2,[60.2,340,1.36e21,CreatedSpectr[j].Y[i],CreatedSpectr[j].X[i]],0,380e-6)
                               /IntegralRomberg(Bowden,[60.2,340,1.36e21,CreatedSpectr[j].Y[i],CreatedSpectr[j].X[i]],0,380e-6);
        except
         CreatedSpectr[j].Y[i]:=0;
        end;
      {якесь усереднення з врахуванням поглинання по глибині}
      CreatedSpectr[j].WriteToFile(FileNameBeginShot[LampType]+'Bow'+Inttostr(Intensities[j])+'.dat',
                                 6,'Lambda ArbUnit');
//      SL.Add(CreatedSpectr[j].name+' '+floattostr(CreatedSpectr[j].Int_Trap));


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
  SL.SaveToFile('noname.dat');
  SL.Free;
  FreeAndNil(Slide);
end;

end.

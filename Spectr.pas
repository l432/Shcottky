unit Spectr;
{щось, пов'язане з обробкою спектрів -
використовувалося для роботи зі спектрами галогенових ламп}

interface

uses
  OlegVector;

type
// TProcedFile=Procedure(FileName:string);

 TLampType=(ltGE,ltOrion,ltOsram);

const

  PhotodiodDatFileName='Photodiod.dat';

  FileNameBegin:array[TLampType]of string=
   ('GE','Orion','Osram');

  {кількості виміряних спектрів}
  MSCount:array[TLampType]of byte=
//   (2,2,3);
   (2,3,4);

  {кількості спектрів, які потрібно створити}
  CSCount:array[TLampType]of byte=
   (3,7,6);

  Intensities :array[0..6] of integer=
  (200,300,400,500,600,700,750);


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
{зчитується файл з назвою FileName у ще Vector, який додається до масиву}
procedure VectorArrayAddFile (FileName:string);overload;
{працює з масивом Spectrums}

procedure AllDatFileToOne(ResultFileName:string='AllFiles');
{всі файли .dat файлами у вибраній директорії поєднуються у один
з назвою ResultFileName+'.dat'}

var Spectrums:TArrVec;

implementation

uses
  OlegVectorManipulation, Vcl.Dialogs, System.SysUtils, OlegFunction,
  OlegMath, Vcl.FileCtrl, System.Classes;


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
{зчитується файл з назвою FileName у ще Vector, який додається до масиву}
begin
// showmessage(FileName);
 SetLength(VectorArray,High(VectorArray)+2);
// showmessage()
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

end.

unit ActionsOnDatFile;

interface

const
 YZrizName='Y cut';
 CVReverseName='CV reverse';
 IVmanipulateName='IV parceling';
 DatToEisName='Dat for IS';

 ActionsName:array[0..3]of string=
  (YZrizName,CVReverseName,IVmanipulateName,DatToEisName);

procedure  YZriz(XValues:array of double;ToDeleteNegativeY:boolean=False;CurrentDir:string='';ResultFileName:string='Zriz');
{зчитуються всі .dat файли у вибраній директорії, знаходяться значення
у другій колонці, які відповідають всім величинам з масиву XValues,
записується результуючий файл ResultFileName.dat, у якому
перша колонка - назва файлу,
друга - температура,
решта - визначенні значення;
підписи решти колонок - V+округлене значення з XValues, домножене на 100
при ToDeleteNegativeY=True
з вихідного файлу спочатку видаляються всі точки, де Y<0}

procedure CVReverse(CurrentDir:string='');
{з усіх .dat файлів у вибраній директорії зчитуються дві перші колонки,
залишається лише зворотня характеристика, значення другої колонки
(орієнтовно там має бути ємність) діляться на S, потім розраховуються
величини, обернені до квадрату значення другої колонки (1/С^2),
відповідна залежність записується у файл, у назві якого дописується в кінці CV,
на початку FilePrefix
і видаляється, за наявності, "cprp"; розраховується висота бар'єру
і записується разом з вихідною назву у файл 'CVbar.dat'}

procedure IVmanipulate({S:double=1;FilePrefix:string='';}CurrentDir:string='');
{з усіх .dat файлів у вибраній директорії
виділяються пряма та зворотня ділянки, значення струму ділиться та S
і записуються у файли,
в кінці назв яких дописані 'pr' та 'zv' відповідно;
прямі характеристики записуються в папку Forward
зворотні - Reverse
на початку дописується  FilePrefix;
в 'comments.dat' робляться додаткові записи з новими назвами файлів;
}


procedure DatToEis({FilePrefix:string='';}CurrentDir:string='');
{з усіх .dat файлів у вибраній директорії створює
файли, потрібні для EIS SPECTRUM ANALYSER;
вважається, що вихідні файли мають чотири колонки:
частота, активний опір, частота, реактивний опір
вихідний має у першому рядку містити кількість точок,
а далі три колонки:
активний опір, реактивний опір (додатній), частота;
вихідний файл має те ж ім'я з доповненням FilePrefix, але розширення .txt}


implementation

uses
  System.SysUtils, OlegVector, System.Classes, Vcl.FileCtrl, OlegType,
  OlegFunction, OlegVectorManipulation, Vcl.Dialogs;

procedure  YZriz(XValues:array of double;ToDeleteNegativeY:boolean=False;
                 CurrentDir:string='';ResultFileName:string='Zriz');

 var SR : TSearchRec;
     Dat_Folder:string;
     i:integer;
     Vec:TVector;
     SL:TStringList;
     temp:string;
begin
 if SelectDirectory('Choose Directory',CurrentDir, Dat_Folder)
  then SetCurrentDir(Dat_Folder)
  else Exit;
 Vec:=TVector.Create;
 SL:=TStringList.Create;


 if FindFirst(mask, faAnyFile, SR) = 0 then
   repeat
    if FileNameIsBad(SR.name)then Continue;
    Vec.ReadFromFile(SR.name);
    if ToDeleteNegativeY then Vec.DeleteYLessTnanNumber(0);
    temp:=copy(Vec.name,1,length(Vec.name)-4);
    for I := 1 to 4-length(temp)
        do insert('0',temp,1);
    Temp:=temp+' '+FloatToStrF(Vec.T,ffFixed,5,2);
    for i := 0 to High(XValues) do
     Temp:=temp+' '+FloatToStrF(Vec.Yvalue(XValues[i]),ffExponent,6,0);
    SL.Add(temp);
   until (FindNext(SR) <> 0);

 SL.Sort;
 temp:='Name T';
 for i := 0 to High(XValues) do
   Temp:=temp+' V'+Inttostr(round(XValues[i]*100));
 SL.Insert(0,temp);

 SL.SaveToFile(ResultFileName+'.dat');
 FreeAndNil(SL);
 FreeAndNil(Vec);

end;


procedure CVReverse(CurrentDir:string='');
 var SR : TSearchRec;
     Dat_Folder:string;
     i:integer;
     Vec:TVectorTransform;
     SL:TStringList;
     OutputData:TArrSingle;
     temp,FilePrefix:string;
     S:double;
begin
 if SelectDirectory('Choose Directory',CurrentDir, Dat_Folder)
  then SetCurrentDir(Dat_Folder)
  else Exit;

 FilePrefix:=FolderNameFromFullPath(Dat_Folder,1);
 S:=SearchInFile('Areas.dat',FilePrefix);
 if S=ErResult then S:=1
               else S:=S*1e-6;

 Vec:=TVectorTransform.Create;
 SL:=TStringList.Create;
 SL.Add('name Vb');

 if FindFirst(mask, faAnyFile, SR) = 0 then
   repeat
    if FileNameIsBad(SR.name)then Continue;
    Vec.ReadFromFile(SR.name);
    Vec.Itself(Vec.ReverseX);
    if S<>0 then Vec.MultiplyY(1/S);
    for I := 0 to Vec.HighNumber do
      Vec.Y[i]:=1/(sqr(Vec.Y[i]));
    Vec.LinAprox(OutputData);
    temp:=copy(Vec.name,1,length(Vec.name)-4);
    if Pos('cprp',temp)>0 then Delete(temp,Pos('cprp',temp),4);
    SL.Add(temp+' '+FloatToStrF(abs(OutputData[0]/OutputData[1]),ffExponent,6,0));
    Vec.WriteToFile(FilePrefix+temp+'CV.dat',8);
   until (FindNext(SR) <> 0);

 SL.SaveToFile('CVbar.dat');
 FreeAndNil(SL);
 FreeAndNil(Vec);
end;

procedure IVmanipulate({S:double=1;FilePrefix:string='';}CurrentDir:string='');
{з усіх .dat файлів у вибраній директорії
виділяються пряма та зворотня ділянки, значення струму ділиться та S
і записуються у файли,
в кінці назв яких дописані 'pr' та 'zv' відповідно;
прямі характеристики записуються в папку Forward
зворотні - Reverse
на початку дописується  FilePrefix;
в 'comments.dat' робляться додаткові записи з новими назвами файлів;
}
 var SR : TSearchRec;
     Dat_Folder:string;
     i:integer;
     Vec:TVectorTransform;
     OutputVec:TVector;
     SL:TStringList;
//     OutputData:TArrSingle;
     temp,FilePrefix:string;
     S:double;
begin
 if SelectDirectory('Choose Directory',CurrentDir, Dat_Folder)
  then SetCurrentDir(Dat_Folder)
  else Exit;

 S:=GetArea();
 FilePrefix:=InputBox('Input File Prefix','','');

 Vec:=TVectorTransform.Create;
 OutputVec:=TVector.Create;
 SL:=TStringList.Create;
 if FileExists('comments.dat') then
  SL.LoadFromFile('comments.dat');
 CreateDirSafety('Forward');
 CreateDirSafety('Reverse');

 if FindFirst(mask, faAnyFile, SR) = 0 then
   repeat
    if FileNameIsBad(SR.name)then Continue;
    Vec.ReadFromFile(SR.name);
    if S<>0 then Vec.MultiplyY(1/S);
    Vec.ReverseX(OutputVec);
    OutputVec.MultiplyY(-1);
    OutputVec.MultiplyX(-1);
    if OutputVec.Count>0 then
     begin
       SetCurrentDir(Dat_Folder+'\Reverse\');
       temp:=FilePrefix+FitName(Vec,'zv');
       OutputVec.WriteToFile(temp,8);
       SetCurrentDir(Dat_Folder);
       for i := 0 to SL.Count-1 do
        if Pos(Vec.name,SL[i])=1 then
         begin
          SL.Insert(i+2,'');
          temp:=SL[i];
          Delete(temp,1,Length(Vec.name));
          temp:=FilePrefix+FitName(Vec,'zv')+temp;
          SL.Insert(i+3,temp);
          SL.Insert(i+4,SL[i+1]);
          Break;
         end;
     end;

    Vec.ForwardX(OutputVec);
    if OutputVec.Count>0 then
     begin
       SetCurrentDir(Dat_Folder+'\Forward\');
       temp:=FilePrefix+FitName(Vec,'pr');
       OutputVec.WriteToFile(temp,8);
       SetCurrentDir(Dat_Folder);
       for i := 0 to SL.Count-1 do
        if Pos(Vec.name,SL[i])=1 then
         begin
          SL.Insert(i+2,'');
          temp:=SL[i];
          Delete(temp,1,Length(Vec.name));
          temp:=FilePrefix+FitName(Vec,'pr')+temp;
          SL.Insert(i+3,temp);
          SL.Insert(i+4,SL[i+1]);
          Break;
         end;
     end;
   until (FindNext(SR) <> 0);

 SetCurrentDir(Dat_Folder+'\Forward\');
 SL.SaveToFile('comments.dat');
 SetCurrentDir(Dat_Folder+'\Reverse\');
 SL.SaveToFile('comments.dat');
 FreeAndNil(SL);
 FreeAndNil(OutputVec);
 FreeAndNil(Vec);
end;


procedure DatToEis({FilePrefix:string='';}CurrentDir:string='');

 var SR : TSearchRec;
     Dat_Folder:string;
     i:integer;
     SL:TStringList;
     temp,FilePrefix:string;
begin
 if SelectDirectory('Choose Directory',CurrentDir, Dat_Folder)
  then SetCurrentDir(Dat_Folder)
  else Exit;
 FilePrefix:=InputBox('Input File Prefix','','');

 SL:=TStringList.Create;

 if FindFirst(mask, faAnyFile, SR) = 0 then
   repeat
    if FileNameIsBad(SR.name)then Continue;
    SL.LoadFromFile(SR.name);
    for i := 0 to SL.Count-1 do
     begin
       temp:=StringDataFromRow(SL[i],4);
       Delete(temp,1,1);
       temp:=StringDataFromRow(SL[i],2)
             +' '+temp
             +' '+StringDataFromRow(SL[i],1);
       SL[i]:=temp;
     end;
    SL.Insert(0,inttostr(SL.Count));
    SL.SaveToFile(FilePrefix+copy(SR.name,1,length(SR.name)-3)+'txt');
   until (FindNext(SR) <> 0);

 FreeAndNil(SL);
end;


end.

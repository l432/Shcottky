unit ActionsOnDatFile;

interface

const
 YZrizName='Y cut';
 CVReverseName='CV processing';
 IVmanipulateName='IV parceling';
 DatToEisName='Dat for IS';
 ISresultTransformName='IS result transform';
 CFTransformName='CF processing';
 SomeThingName='Something else';

 IVFittingFile='IVfitting.dat';


 ActionsName:array[0..6]of string=
  (CVReverseName,IVmanipulateName,DatToEisName,CFTransformName,ISresultTransformName,YZrizName,
   SomeThingName);

procedure  YZriz(XValues:array of double;Dat_Folder:string;
                 ToDeleteNegativeY:boolean=False;
                 ResultFileName:string='Zriz');
{зчитуються всі .dat файли у вибраній директорії Dat_Folder, знаходяться значення
у другій колонці, які відповідають всім величинам з масиву XValues,
записується результуючий файл ResultFileName.dat, у якому
перша колонка - назва файлу,
друга - температура,
решта - визначенні значення;
підписи решти колонок - V+округлене значення з XValues, домножене на 100
при ToDeleteNegativeY=True
з вихідного файлу спочатку видаляються всі точки, де Y<0}

procedure CVReverse(Dat_Folder:string);
{з усіх .dat файлів у вибраній директорії зчитуються дві перші колонки,
залишається лише зворотня характеристика, значення другої колонки
(орієнтовно там має бути ємність) діляться на S, потім розраховуються
величини, обернені до квадрату значення другої колонки (1/С^2),
відповідна залежність записується у файл, у назві якого дописується в кінці CV,
на початку FilePrefix
і видаляється, за наявності, "cprp"; розраховується висота бар'єру
і записується разом з вихідною назву у файл 'CVbar.dat'}

procedure IVmanipulate(Dat_Folder:string);
{з усіх .dat файлів у вибраній директорії
виділяються пряма та зворотня ділянки, значення струму ділиться та S
і записуються у файли,
в кінці назв яких дописані 'pr' та 'zv' відповідно;
прямі характеристики записуються в папку Forward
зворотні - Reverse
на початку дописується  FilePrefix;
в 'comments.dat' робляться додаткові записи з новими назвами файлів;
}

procedure IVfittingResultCollect(Dat_Folder:string);
{витягує з dates.dat результати апроксимації}

procedure DatToEis(Dat_Folder:string);
{з усіх .dat файлів у вибраній директорії створює
файли, потрібні для EIS SPECTRUM ANALYSER;
вважається, що вихідні файли мають чотири колонки:
частота, активний опір, частота, реактивний опір
вихідний має у першому рядку містити кількість точок,
а далі три колонки:
активний опір, реактивний опір (додатній), частота;
вихідний файл має те ж ім'я з доповненням FilePrefix, але розширення .txt}

procedure ISresultTransform(Dat_Folder:string);

procedure CFTransform(Dat_Folder:string);

Function E_w(f,T:double;f0:double=5e10):double;
{розрахунок demarcation energy для оцінки густини станів
за залежністю ємності від частоти;
[]=eV}

Function Wd(Vbi,N,T:double;V:double=0;Eps:double=11.7):double;
{обчислення ширини області збіднення
Vbi - build-in-voltage,V
N - концентрація носіїв, м-3
V - прикладена напруга (додатнє значення
відповідає прямій), V
[]= м }

procedure ReorganizeFileToKeys(InitFile,KeyFile:string);
{переставляє рядки у файлі InitFile таким чином, щоб вони слідували в порядку,
який задається KeyFile. А саме, спочатку з InitFile вибираються рядки, які починаються
так само як перший рядок KeyFile, потім ті, що починаються
з початку другого рядка KeyFile; елемент з KeyFile не обов'язково
має окремо стояти на початку рядка в InitFile, він може бути початком і більш довгого
підрядка}

implementation

uses
  System.SysUtils, OlegVector, System.Classes, Vcl.FileCtrl, OlegType,
  OlegFunction, OlegVectorManipulation, Vcl.Dialogs, OlegMath, System.StrUtils;

procedure  YZriz(XValues:array of double;Dat_Folder:string;
                 ToDeleteNegativeY:boolean=False;
                 ResultFileName:string='Zriz');

 var SR : TSearchRec;
//     Dat_Folder:string;
     i:integer;
     Vec:TVector;
     SL:TStringList;
     temp:string;
begin
// if SelectDirectory('Choose Directory',CurrentDir, Dat_Folder)
//  then SetCurrentDir(Dat_Folder)
//  else Exit;
 SetCurrentDir(Dat_Folder);
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


procedure CVReverse(Dat_Folder:string);
 var SR : TSearchRec;
//     Dat_Folder:string;
     i:integer;
     Vec,Vec2:TVectorTransform;
     OutputData:TArrSingle;
     temp,FilePrefix,ResultFolder:string;
     S,Vbi:double;
begin
// if SelectDirectory('Choose Directory',CurrentDir, Dat_Folder)
//  then SetCurrentDir(Dat_Folder)
//  else Exit;

 SetCurrentDir(Dat_Folder);

 CreateDirSafety('CVrev');
 CreateDirSafety('N_CV');
 CreateDirSafety('Cforv');

 FilePrefix:=FolderNameFromFullPath(Dat_Folder,1);
 S:=SearchInFile('Areas.dat',FilePrefix);
 if S=ErResult then S:=1
               else S:=S*1e-6;

 ResultFolder:=SearchDirForFile('Areas.dat');
 if ResultFolder='' then Exit;
 SetCurrentDir(ResultFolder);
 CreateDirSafety('Results');
 ResultFolder:=ResultFolder+'\'+'Results';
 SetCurrentDir(ResultFolder);
// CreateDirSafety('Crev');
 CreateDirSafety('N_CV');
 CreateDirSafety('Cforv');

 SetCurrentDir(Dat_Folder);

 Vec:=TVectorTransform.Create;
 Vec2:=TVectorTransform.Create;

 if FindFirst(mask, faAnyFile, SR) = 0 then
   repeat
    if FileNameIsBad(SR.name)then Continue;

    Vec.ReadFromFile(SR.name);
    temp:=copy(Vec.name,1,length(Vec.name)-4);
    if Pos('cprp',temp)>0 then Delete(temp,Pos('cprp',temp),4);
    temp:=FilePrefix+temp;

    Vec.Itself(Vec.ReverseX);
    if S<>0 then Vec.MultiplyY(1/S);
    for I := 0 to Vec.HighNumber do
      Vec.Y[i]:=1/(sqr(Vec.Y[i]));

//          d52b, d54a
//    Vec.CopyLimitedX(Vec2,-10,-0.6);
//    Vec2.CopyTo(Vec);
//          d54a
//    Vec.CopyLimitedX(Vec2,-1.2,-0.2);
//    Vec2.CopyTo(Vec);
//          d54b
//    Vec.CopyLimitedX(Vec2,-1.3,-0.4);
//    Vec2.CopyTo(Vec);
//          d81c
//    Vec.CopyLimitedX(Vec2,-10,-0.3);
//    Vec2.CopyTo(Vec);
//          d44s
//    Vec.CopyLimitedX(Vec2,-10,-0.2);
//    Vec2.CopyTo(Vec);
//    Vec.CopyLimitedX(Vec2,-10,-0.2);
//    Vec2.CopyTo(Vec);

    Vec.LinAprox(OutputData);
    Vbi:=abs(OutputData[0]/OutputData[1]);
    KeyAndValueToFile(ResultFolder+'\'+'CVbar.dat',temp,
                         FloatToStrF(Vbi,ffExponent,6,0));
    KeyAndValueToFile(ResultFolder+'\'+'Ndop.dat',temp,
        FloatToStrF(abs(2/(OutputData[1]*Qelem*Eps0*11.7)),ffExponent,6,0));

//    Vec.WriteToFile(ResultFolder+'\Crev\'+temp+'CV.dat',8);
    Vec.WriteToFile(Dat_Folder+'\CVrev\'+temp+'CV.dat',8);

    KeyAndValueToFile(Dat_Folder+'\CVrev\'+'CVbar.dat',temp,
                         FloatToStrF(Vbi,ffExponent,6,0));
    KeyAndValueToFile(Dat_Folder+'\N_CV\'+'Ndop.dat',temp,
        FloatToStrF(abs(2/(OutputData[1]*Qelem*Eps0*11.7)),ffExponent,6,0));

    Vec2.Clear;
    for I := 0 to Vec.HighNumber do
     begin
       Vec2.Add(1e6*Eps0*11.7*sqrt(Vec.Y[i]),
                -2/(Qelem*Eps0*11.7*Vec.DerivateAtPoint(i)));

     end;
    Vec2.WriteToFile(ResultFolder+'\N_CV\'+temp+'Nx.dat',8,'x N');
    Vec2.WriteToFile(Dat_Folder+'\N_CV\'+temp+'Nx.dat',8,'x N');

    Vec.ReadFromFile(SR.name);
    Vec.Itself(Vec.ForwardX);
    if S<>0 then Vec.MultiplyY(1/S);
    KeyAndValueToFile(ResultFolder+'\'+'Vpeak.dat',temp,
                         FloatToStrF(Vec.XValue(Vec.MaxY),ffExponent,6,0));
//    for I := 0 to Vec.HighNumber do
//     if Vec.X[i]<Vbi then
//          Vec.Y[i]:=Vec.Y[i]-1/sqrt(Linear(Vec.X[i],OutputData));

    Vec.WriteToFile(ResultFolder+'\Cforv\'+temp+'CVf.dat',8);
    Vec.WriteToFile(Dat_Folder+'\Cforv\'+temp+'CVf.dat',8);

   until (FindNext(SR) <> 0);

 FreeAndNil(Vec2);
 FreeAndNil(Vec);
end;

procedure IVmanipulate(Dat_Folder:string);
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
//     Dat_Folder:string;
     i:integer;
     Vec:TVectorTransform;
     OutputVec:TVector;
     SL:TStringList;
     temp,FilePrefix:string;
     S:double;
begin
// if SelectDirectory('Choose Directory',CurrentDir, Dat_Folder)
//  then SetCurrentDir(Dat_Folder)
//  else Exit;

 SetCurrentDir(Dat_Folder);

 FilePrefix:=FolderNameFromFullPath(Dat_Folder,1);
 S:=SearchInFile('Areas.dat',FilePrefix);
 if S=ErResult then S:=1
               else S:=S*1e-2;

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


procedure DatToEis(Dat_Folder:string);

 var SR : TSearchRec;
//     Dat_Folder:string;
     i:integer;
     SL:TStringList;
     temp,FilePrefix:string;
begin
// if SelectDirectory('Choose Directory',CurrentDir, Dat_Folder)
//  then SetCurrentDir(Dat_Folder)
//  else Exit;

 SetCurrentDir(Dat_Folder);
 FilePrefix:=FolderNameFromFullPath(Dat_Folder,1);

 CreateDirSafety('EISdata');

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
    temp:=copy(SR.name,1,length(SR.name)-3);
    if Pos('rr',temp)>0 then Delete(temp,Pos('rr',temp),2);
    if Pos('rz',temp)>0 then Delete(temp,Pos('rz',temp),2);
    if Pos('rx',temp)>0 then Delete(temp,Pos('rx',temp),2);
    temp:=ReplaceStr(temp,'2V22E-16','0V');
    SL.SaveToFile(Dat_Folder+'\EISdata\'+FilePrefix+temp+'txt');
   until (FindNext(SR) <> 0);

 FreeAndNil(SL);
end;


procedure ISresultTransform(Dat_Folder:string);
 var SR : TSearchRec;
//     Dat_Folder:string;
     i,ColumnNumberMax,ColumnNumber:integer;
     Vec:TVectorTransform;
     {SL,}SLFile,SLFileNew:TStringList;
     OutputData:TArrSingle;
     temp,{FilePrefix,}ShortFileName,ResultFolder,Vbi:string;
     S,tempDouble:double;
begin
// if SelectDirectory('Choose Directory',CurrentDir, Dat_Folder)
//  then SetCurrentDir(Dat_Folder)
//  else Exit;

 SetCurrentDir(Dat_Folder);

 CreateDirSafety('CVrev');

 ResultFolder:=SearchDirForFile('Areas.dat');
 if ResultFolder='' then Exit;
 SetCurrentDir(ResultFolder);
 CreateDirSafety('Results');
 ResultFolder:=ResultFolder+'\'+'Results';
 SetCurrentDir(Dat_Folder);

 Vec:=TVectorTransform.Create;
 SLFile:=TStringList.Create;
 SLFileNew:=TStringList.Create;

 if FindFirst('*.txt', faAnyFile, SR) = 0 then
   repeat
    ShortFileName:=copy(SR.name,1,length(SR.name)-4);
    S:=SearchInFile('Areas.dat',ShortFileName);
    if S=ErResult then S:=1
                else S:=S*1e-6;

    if FileNameIsBad(SR.name)then Continue;
    Vec.ReadFromFile(SR.name);
    Vec.Itself(Vec.ReverseX);
    if S<>0 then Vec.MultiplyY(1/S);
    for I := 0 to Vec.HighNumber do
      Vec.Y[i]:=1/(sqr(Vec.Y[i]));
    Vec.LinAprox(OutputData);


    Vbi:=FloatToStrF(abs(OutputData[0]/OutputData[1]),ffExponent,6,0);
    KeyAndValueToFile(ResultFolder+'\'+'CVbar.dat',ShortFileName+'IS',Vbi);
    KeyAndValueToFile(Dat_Folder+'\CVrev\'+'CVbar.dat',ShortFileName,Vbi);

    Vec.WriteToFile(Dat_Folder+'\CVrev\'+ShortFileName+'CVrev.dat',8);

    SLFile.Clear;
    SLFile.LoadFromFile(SR.name);
    ColumnNumberMax:=NumberOfSubstringInRow(SLFile[0]);
    ColumnNumber:=2;
    while ColumnNumber<ColumnNumberMax do
     begin
      SLFileNew.Clear;
      SLFileNew.Add(StringDataFromRow(SLFile[0],1)
                    +' '+StringDataFromRow(SLFile[0],ColumnNumber)
                    +' '+StringDataFromRow(SLFile[0],ColumnNumber+1));
      for I := 1 to SLFile.Count-1 do
       begin
        temp:=StringDataFromRow(SLFile[i],1)+' ';
        tempDouble:=FloatDataFromRow(SLFile[i],ColumnNumber);
        tempDouble:=tempDouble/S;
        temp:=temp+FloatToStrF(tempDouble,ffExponent,6,0)+' ';
        tempDouble:=tempDouble/100*FloatDataFromRow(SLFile[i],ColumnNumber+1);
        temp:=temp+FloatToStrF(tempDouble,ffExponent,6,0);
        SLFileNew.Add(temp);
       end;
      CreateDirSafety(StringDataFromRow(SLFile[0],ColumnNumber));
      SLFileNew.SaveToFile(Dat_Folder+'\'+StringDataFromRow(SLFile[0],ColumnNumber)
               +'\'+ShortFileName
               +StringDataFromRow(SLFile[0],ColumnNumber)+'.dat');

      ColumnNumber:=ColumnNumber+2;
     end;

   until (FindNext(SR) <> 0);


 FreeAndNil(SLFileNew);
 FreeAndNil(SLFile);
 FreeAndNil(Vec);
end;


procedure CFTransform(Dat_Folder:string);
var {Dat_Folder,}ResultFolder,FilePrefix,temp:string;
    SR : TSearchRec;
    i:integer;
    Vec,VecNew:TVectorTransform;
    S,Vbi,N,W:double;
begin
// if SelectDirectory('Choose Directory',CurrentDir, Dat_Folder)
//  then SetCurrentDir(Dat_Folder)
//  else Exit;

 SetCurrentDir(Dat_Folder);
 CreateDirSafety('Nt_Cf');
 CreateDirSafety('G_f');

 FilePrefix:=FolderNameFromFullPath(Dat_Folder,1);
 S:=SearchInFile('Areas.dat',FilePrefix);
 if S=ErResult then S:=1
               else S:=S*1e-6;
 Vbi:=SearchInFile('Vbi.dat',FilePrefix);
 if Vbi=ErResult then Vbi:=1;
 N:=SearchInFile('N.dat',FilePrefix);
 if N=ErResult then N:=1;


 ResultFolder:=SearchDirForFile('Areas.dat');
 if ResultFolder='' then Exit;
 SetCurrentDir(ResultFolder);
 CreateDirSafety('Results');
 ResultFolder:=ResultFolder+'\'+'Results';
 SetCurrentDir(ResultFolder);
 CreateDirSafety('Nt_Cf');
 CreateDirSafety('G_f');

// ResultFolder:=ResultFolder+'\'+'Nt_Cf';
 SetCurrentDir(Dat_Folder);


  Vec:=TVectorTransform.Create;
  VecNew:=TVectorTransform.Create;
 if FindFirst(mask, faAnyFile, SR) = 0 then
   repeat
    if FileNameIsBad(SR.name)then Continue;
    Vec.ReadFromFile(SR.name);
    for i:=1 to 20 do
     Vec.Itself(Vec.Smoothing);
    Vec.Itself(Vec.Derivate);


    Vec.Itself(Vec.Power);
//    showmessage(Vec.XYtoString);

    if Pos('0V4',SR.name)>0 then Vbi:=Vbi-0.4;
    W:=Wd(Vbi,N,Vec.T);
//    showmessage(floattostr(W));
//    showmessage(floattostr(Vbi));
//    showmessage(floattostr(Vec.T));

    Vec.MultiplyY(-Vbi/(Kb*Vec.T*Qelem*S*W*1e6));
    Vec.CopyLimitedX(VecNew,1e3,1e7);
    if Pos('0V4',SR.name)>0 then Vbi:=Vbi+0.4;
//    showmessage(Vec.XYtoString);

    temp:=copy(Vec.name,1,length(SR.name)-4);
    if Pos('cprp',temp)>0 then Delete(temp,Pos('cprp',temp),4);
    if Pos('cpg',temp)>0 then
     begin
      Delete(temp,Pos('cpg',temp),3);
      Vec.ReadFromFile(SR.name,[4]);
      for i:=0 to Vec.HighNumber do
        Vec.Y[i]:= Vec.Y[i]/(2*Pi*Vec.X[i]);
      Vec.MultiplyY(1/S);
      Vec.WriteToFile(ResultFolder+'\G_f\'+FilePrefix+temp+'Gf.dat',8,'f G/w');
      Vec.WriteToFile(Dat_Folder+'\G_f\'+FilePrefix+temp+'Gf.dat',8,'f G/w');
     end;

    for i:=0 to VecNew.HighNumber do
      VecNew.X[i]:=E_w(VecNew.X[i],VecNew.T);

    VecNew.WriteToFile(ResultFolder+'\Nt_Cf\'+FilePrefix+temp+'Nt.dat',8,'Ew Nt');
    VecNew.WriteToFile(Dat_Folder+'\Nt_Cf\'+FilePrefix+temp+'Nt.dat',8,'Ew Nt');
   until (FindNext(SR) <> 0);
  FreeAndNil(Vec);
  FreeAndNil(VecNew);
end;


procedure IVfittingResultCollect(Dat_Folder:string);
{витягує з dates.dat результати апроксимації}
var SLdates,SLResult:TStringList;
    ResultFolder:string;
    i:integer;
begin
 SetCurrentDir(Dat_Folder);
 if not(FileExists('dates.dat')) then Exit;

 SLdates:=TStringList.Create();
 SLResult:=TStringList.Create();

 ResultFolder:=SearchDirForFile('Areas.dat');
 if ResultFolder='' then Exit;
 SetCurrentDir(ResultFolder);
 CreateDirSafety('Results');
 ResultFolder:=ResultFolder+'\'+'Results';
 SetCurrentDir(ResultFolder);
 if not(FileExists(IVFittingFile))
    then SLResult.Add('name T n1 Rs I01 Rsh n2 I02')
    else SLResult.LoadFromFile(IVFittingFile);

 SetCurrentDir(Dat_Folder);
 SetCurrentDir(Dat_Folder);
 SLdates.LoadFromFile('dates.dat');
 for I := 1 to SLdates.Count-1 do
    SLResult.Add(StringDataFromRow(SLdates[i],1)+' '
          +StringDataFromRow(SLdates[i],3)+' '
          +StringDataFromRow(SLdates[i],5)+' '
          +StringDataFromRow(SLdates[i],6)+' '
          +StringDataFromRow(SLdates[i],7)+' '
          +StringDataFromRow(SLdates[i],8)+' '
          +StringDataFromRow(SLdates[i],9)+' '
          +StringDataFromRow(SLdates[i],10));
  SLResult.SaveToFile(ResultFolder+'\'+IVFittingFile);
  FreeAndNil(SLResult);
  FreeAndNil(SLdates);
end;


Function E_w(f,T:double;f0:double=5e10):double;
{розрахунок demarcation energy для оцінки густини станів
за залежністю ємності від частоти}
begin
  if f<=0 then Exit(ErResult);
  Result:=Kb*abs(T)*ln(abs(f0)/f);
end;

Function Wd(Vbi,N,T:double;V:double=0;Eps:double=11.7):double;
{обчислення ширини області збіднення
Vbi - build-in-voltage,V
N - концентрація носіїв, м-3
V - прикладена напруга (додатнє значення
відповідає прямій), V
[]= м }
begin
 Result:=sqrt(2*Eps*Eps0/Qelem*(Vbi-V-2*Kb*T)/N);
end;

procedure ReorganizeFileToKeys(InitFile,KeyFile:string);
{переставляє рядки у файлі InitFile таким чином, щоб вони слідували в порядку,
який задається KeyFile. А саме, спочатку з InitFile вибираються рядки, які починаються
так само як перший рядок KeyFile, потім ті, що починаються
з початку другого рядка KeyFile; елемент з KeyFile не обов'язково
має окремо стояти на початку рядка в InitFile, він може бути початком і більш довгого
підрядка}
 var StartFile,FinishFile,Keys:TStringList;
     FistRowUsed:boolean;
     i,j:integer;
     key:string;
begin
 Keys:=TStringList.Create;
 FinishFile:=TStringList.Create;
 StartFile:=TStringList.Create;
 Keys.LoadFromFile(KeyFile);
 StartFile.LoadFromFile(InitFile);
 FistRowUsed:=False;
 for I := 0 to Keys.Count-1 do
   begin
    key:=StringDataFromRow(Keys[i],1).ToUpper;
    for j := 0 to StartFile.Count-1 do
       if Pos(key,StringDataFromRow(StartFile[j],1).ToUpper)=1
        then
         begin
          FinishFile.Add(StartFile[j]);
          FistRowUsed:=(j=0);
         end;
   end;
 if not(FistRowUsed) then FinishFile.Insert(0,StartFile[0]);
 FinishFile.SaveToFile(InitFile);
 FreeAndNil(StartFile);
 FreeAndNil(FinishFile);
 FreeAndNil(Keys);
end;

end.

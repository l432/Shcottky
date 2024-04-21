unit ActionsOnDatFile;

interface

const
 YZrizName='Y cut';
 CVReverseName='CV reverse';
 IVmanipulateName='IV parceling';
 DatToEisName='Dat for IS';
 ISresultTransformName='IS result transform';

 ActionsName:array[0..3]of string=
  (YZrizName,CVReverseName,IVmanipulateName,DatToEisName);

procedure  YZriz(XValues:array of double;ToDeleteNegativeY:boolean=False;CurrentDir:string='';ResultFileName:string='Zriz');
{���������� �� .dat ����� � ������� ��������, ����������� ��������
� ����� �������, �� ���������� ��� ��������� � ������ XValues,
���������� ������������ ���� ResultFileName.dat, � �����
����� ������� - ����� �����,
����� - �����������,
����� - ��������� ��������;
������ ����� ������� - V+��������� �������� � XValues, ��������� �� 100
��� ToDeleteNegativeY=True
� ��������� ����� �������� ����������� �� �����, �� Y<0}

procedure CVReverse(CurrentDir:string='');
{� ��� .dat ����� � ������� �������� ���������� �� ����� �������,
���������� ���� �������� ��������������, �������� ����� �������
(�������� ��� �� ���� ������) ������� �� S, ���� ��������������
��������, ������� �� �������� �������� ����� ������� (1/�^2),
�������� ��������� ���������� � ����, � ���� ����� ���������� � ���� CV,
�� ������� FilePrefix
� �����������, �� ��������, "cprp"; ������������� ������ ���'���
� ���������� ����� � �������� ����� � ���� 'CVbar.dat'}

procedure IVmanipulate({S:double=1;FilePrefix:string='';}CurrentDir:string='');
{� ��� .dat ����� � ������� ��������
���������� ����� �� �������� ������, �������� ������ ������� �� S
� ����������� � �����,
� ���� ���� ���� ������� 'pr' �� 'zv' ��������;
���� �������������� ����������� � ����� Forward
������� - Reverse
�� ������� ����������  FilePrefix;
� 'comments.dat' ��������� �������� ������ � ������ ������� �����;
}

procedure DatToEis({FilePrefix:string='';}CurrentDir:string='');
{� ��� .dat ����� � ������� �������� �������
�����, ������ ��� EIS SPECTRUM ANALYSER;
���������, �� ������ ����� ����� ������ �������:
�������, �������� ���, �������, ���������� ���
�������� �� � ������� ����� ������ ������� �����,
� ��� ��� �������:
�������� ���, ���������� ��� (�������), �������;
�������� ���� �� �� � ��'� � ����������� FilePrefix, ��� ���������� .txt}

procedure ISresultTransform(CurrentDir:string='');


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
{� ��� .dat ����� � ������� ��������
���������� ����� �� �������� ������, �������� ������ ������� �� S
� ����������� � �����,
� ���� ���� ���� ������� 'pr' �� 'zv' ��������;
���� �������������� ����������� � ����� Forward
������� - Reverse
�� ������� ����������  FilePrefix;
� 'comments.dat' ��������� �������� ������ � ������ ������� �����;
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

// S:=GetArea();
// FilePrefix:=InputBox('Input File Prefix','','');

 FilePrefix:=FolderNameFromFullPath(Dat_Folder,1);
 S:=SearchInFile('Areas.dat',FilePrefix);
 if S=ErResult then S:=1
               else S:=S*1e-6;

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
// FilePrefix:=InputBox('Input File Prefix','','');

 FilePrefix:=FolderNameFromFullPath(Dat_Folder,1);
// S:=SearchInFile('Areas.dat',FilePrefix);
// if S=ErResult then S:=1
//               else S:=S*1e-6;

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


procedure ISresultTransform(CurrentDir:string='');
 var SR : TSearchRec;
     Dat_Folder:string;
     i,ColumnNumberMax,ColumnNumber:integer;
     Vec:TVectorTransform;
     SL,SLFile,SLFileNew:TStringList;
     OutputData:TArrSingle;
     temp,FilePrefix,ShortFileName:string;
     S,tempDouble:double;
begin
 if SelectDirectory('Choose Directory',CurrentDir, Dat_Folder)
  then SetCurrentDir(Dat_Folder)
  else Exit;

// FilePrefix:=FolderNameFromFullPath(Dat_Folder,1);


 Vec:=TVectorTransform.Create;
 SL:=TStringList.Create;
 SLFile:=TStringList.Create;
 SLFileNew:=TStringList.Create;
 SL.Add('name Vb');

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
//    temp:=copy(Vec.name,1,length(Vec.name)-4);
//    if Pos('cprp',temp)>0 then Delete(temp,Pos('cprp',temp),4);
    SL.Add(ShortFileName+' '+FloatToStrF(abs(OutputData[0]/OutputData[1]),ffExponent,6,0));
    Vec.WriteToFile(ShortFileName+'CVrev.dat',8);

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
      SLFileNew.SaveToFile(ShortFileName
           +StringDataFromRow(SLFile[0],ColumnNumber)+'.dat');

      ColumnNumber:=ColumnNumber+2;
     end;



   until (FindNext(SR) <> 0);

 SL.SaveToFile('CVbar.dat');

 FreeAndNil(SLFileNew);
 FreeAndNil(SLFile);
 FreeAndNil(SL);
 FreeAndNil(Vec);
end;

end.

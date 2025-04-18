unit porousSi;

interface
 const
 J0Jtfile='J0Jt.';
 FactorFile='data.';
 J0JtDirName='J0Jt';

 AverDatFile='averdat.dat';
 AverIntFile='averInt.dat';
 Int_aver='Int_aver.dat';

 TimeDepFile='D:\porousSi\BaseOlikh\tdep.dat';

procedure FirsTPorSi(FileName:string);

procedure SecondTPorSi(Dat_Folder:string);


implementation

uses
  System.Classes, System.SysUtils, Vcl.Dialogs, OlegVector,
  OlegVectorManipulation, OlegFunction;

procedure FirsTPorSi(FileName:string);
 var SL:TStringList;
     i,ColumnNumber,{Temperature,}FileCount,j:integer;
     Vec10,Vec100,VecTemp:TVector;
     Vec,VecIntegral,VecAver:TVectorTransform;
     ShotFileName,FileBegin,File_Folder,FactorFileName:string;
     factor,factorTime:double;
begin
 ShotFileName:=ExtractFileName(FileName);
 ShotFileName:=copy(ShotFileName,1,length(ShotFileName)-4);
 if Pos(J0Jtfile,ShotFileName)>0 then Delete (ShotFileName,1,Length(J0Jtfile));
 File_Folder:=FolderFromFullPath(FileName);


 SL:=TStringList.Create;
 FactorFileName:=File_Folder+'\'+FactorFile+ShotFileName+'.dat';

 if FileExists(FactorFileName) then
  begin
   SL.LoadFromFile(FactorFileName);
   factor:=FloatDataFromRow(SL[0],2);
   factorTime:=FloatDataFromRow(SL[0],1);
   SL.Clear;
  end;

 CreateDirSafety(J0JtDirName);


 SL.LoadFromFile(FileName);
 Vec:=TVectorTransform.Create;
 VecIntegral:=TVectorTransform.Create;
 Vec10:=TVector.Create;
 Vec100:=TVector.Create;
 VecTemp:=TVector.Create;
 VecAver:=TVectorTransform.Create;

 SetCurrentDir(File_Folder+'\'+J0JtDirName+'\');

 for ColumnNumber := 4 to 6 do
 begin
   Vec.Clear;
   VecIntegral.Clear;
   for I := 4 to SL.Count-1 do
    begin
      Vec.Add(FloatDataFromRow(SL[i],2)*factorTime,FloatDataFromRow(SL[i],ColumnNumber)*factor);
      if Vec.HighNumber>2 then VecIntegral.Add(Vec.X[Vec.HighNumber],Vec.Int_Trap);

    end;

   FileBegin:='J'+ShotFileName+inttostr(ColumnNumber-3);
//   Vec.WriteToFile(FileBegin+'.dat',6);
//   VecIntegral.WriteToFile(FileBegin+'int.dat',8);


//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
{
�������
1) ����������� �� ��� ������� ����������� <J(0)J(t)>
2) ������������ ���������� ���������
3) ������������ ����������
}

//   if FileExists(AverDatFile) then VecAver.ReadFromFile(AverDatFile,False);
//   if VecAver.HighNumber<0
//    then
//      begin
//       Vec.CopyTo(VecAver);
//       FileCount:=0;
//      end
//    else
//     begin
//      FileCount:=Round(VecAver.X[VecAver.HighNumber]);
//      VecAver.DeletePoint(VecAver.HighNumber);
//      for j := 0 to VecAver.HighNumber do
//        VecAver.Y[j]:=(VecAver.Y[j]*FileCount+Vec.Y[j])/(FileCount+1);
//     end;
//
//
//  VecAver.ImNoiseSmoothedArray(Vec10,10);
//   VecAver.ImNoiseSmoothedArray(Vec100,100);
//   VecTemp.Clear;
//   VecIntegral.Clear;
//
//   VecTemp.Add(VecAver[0]);
//   VecTemp.Add(VecAver[1]);
//   VecIntegral.Add(VecTemp.X[VecTemp.HighNumber],VecTemp.Int_Trap);
//
//   for I := 0 to 2 do
//     begin
//      VecTemp.Add(Vec10[i]);
//      VecIntegral.Add(VecTemp.X[VecTemp.HighNumber],VecTemp.Int_Trap);
//     end;
//
//   for I := 0 to Vec100.HighNumber do
//     begin
//      VecTemp.Add(Vec100[i]);
//      VecIntegral.Add(VecTemp.X[VecTemp.HighNumber],VecTemp.Int_Trap);
//     end;
//
//   Vec10.Clear;
//   Vec100.Clear;
//   VecIntegral.MultiplyY(1/(Vec.X[1]-Vec.X[0]));
//   VecIntegral.WriteToFile(Int_aver,8);
//
//   VecAver.Add(FileCount+1,FileCount+1);
//   VecAver.WriteToFile(AverDatFile,6);
//   HelpForMe(inttostr(FileCount));

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


//*****************************************************
{
1) ������������ ����� ��������� <J(0)J(t)>
2) ����������� ����������� k(t)
3) ������������ ���������� k(t)  �� 10 ������
}
//
//   VecIntegral.MultiplyY(1/(Vec.X[1]-Vec.X[0]));
//
//   VecAver.Clear;
//   if FileExists(AverIntFile) then VecAver.ReadFromFile(AverIntFile,False);
//   if VecAver.HighNumber<0
//    then
//      begin
//       VecIntegral.CopyTo(VecAver);
//       FileCount:=0;
//      end
//    else
//     begin
//      FileCount:=Round(VecAver.X[VecAver.HighNumber]);
//      VecAver.DeletePoint(VecAver.HighNumber);
//      for j := 0 to VecAver.HighNumber do
//        VecAver.Y[j]:=(VecAver.Y[j]*FileCount+VecIntegral.Y[j])/(FileCount+1);
//     end;
//
//   VecAver.Add(FileCount+1,FileCount+1);
//   VecAver.WriteToFile(AverIntFile,8);
//
//   VecAver.DeletePoint(VecAver.HighNumber);
//
//   VecAver.ImNoiseSmoothedArray(Vec10,10);
//   Vec10.WriteToFile(Int_aver,8);
//
//
//   HelpForMe(inttostr(FileCount));
// -----------------
//*******************************************************


//*****************************************************
{
1) ������������ ����� ��������� <J(0)J(t)>
2) ����������� ����������� k(t)
3) ������������ ���������� k(t)  �� 100 ������ ��������� ���� �������
}

   VecIntegral.MultiplyY(1/(Vec.X[1]-Vec.X[0]));

   VecAver.Clear;
   if FileExists(AverIntFile) then VecAver.ReadFromFile(AverIntFile,False);
   if VecAver.HighNumber<0
    then
      begin
       VecIntegral.CopyTo(VecAver);
       FileCount:=0;
      end
    else
     begin
      FileCount:=Round(VecAver.X[VecAver.HighNumber]);
      VecAver.DeletePoint(VecAver.HighNumber);
      for j := 0 to VecAver.HighNumber do
        VecAver.Y[j]:=(VecAver.Y[j]*FileCount+VecIntegral.Y[j])/(FileCount+1);
     end;

   VecAver.Add(FileCount+1,FileCount+1);
   VecAver.WriteToFile(AverIntFile,8);
   VecAver.DeletePoint(VecAver.HighNumber);
   VecAver.ImNoiseSmoothedArray(Vec10,10);
   VecAver.ImNoiseSmoothedArray(Vec100,100);
   VecTemp.Clear;


   for I := 0 to 3 do
      VecTemp.Add(VecAver[i]);
   for I := 0 to 7 do
      VecTemp.Add(Vec10[i]);
   for I := 1 to Vec100.HighNumber do
      VecTemp.Add(Vec100[i]);

//
//   VecAver.WriteToFile('F'+AverIntFile,8);


   VecTemp.WriteToFile(Int_aver,8);

   HelpForMe(inttostr(FileCount));
// -----------------
//******************************************************


//
//   Vec.ImNoiseSmoothedArray(Vec10,10);
//   Vec.ImNoiseSmoothedArray(Vec100,100);
//   VecTemp.Clear;
//   VecIntegral.Clear;
//   VecTemp.Add(Vec[0]);
//   VecTemp.Add(Vec[1]);
//   VecIntegral.Add(VecTemp.X[VecTemp.HighNumber],VecTemp.Int_Trap);
//
//   for I := 0 to 2 do
////   for I := 0 to 9 do
//     begin
//      VecTemp.Add(Vec10[i]);
//      VecIntegral.Add(VecTemp.X[VecTemp.HighNumber],VecTemp.Int_Trap);
//     end;
//
//   for I := 0 to Vec100.HighNumber do
////   for I := 1 to Vec100.HighNumber do
//     begin
//      VecTemp.Add(Vec100[i]);
//      VecIntegral.Add(VecTemp.X[VecTemp.HighNumber],VecTemp.Int_Trap);
//     end;
//
//   VecTemp.WriteToFile(FileBegin+'sm.dat',6);
//   VecIntegral.WriteToFile(FileBegin+'sm_int.dat',8);


//---------------------------------------------------
//   VecAver.Clear;
//   if FileExists(AverIntFile) then VecAver.ReadFromFile(AverIntFile,False);
//   if VecAver.HighNumber<0
//    then
//      begin
//       VecIntegral.CopyTo(VecAver);
//       FileCount:=0;
//      end
//    else
//     begin
//      FileCount:=Round(VecAver.X[VecAver.HighNumber]);
//      VecAver.DeletePoint(VecAver.HighNumber);
//      for j := 0 to VecAver.HighNumber do
//        VecAver.Y[j]:=(VecAver.Y[j]*FileCount+VecIntegral.Y[j])/(FileCount+1);
//     end;
//
//   VecAver.Add(FileCount+1,FileCount+1);
//   VecAver.WriteToFile(AverIntFile,8);
//--------------------------------------------------

 end;

 SetCurrentDir(File_Folder);

 FreeAndNil(VecAver);
 FreeAndNil(VecTemp);
 FreeAndNil(Vec100);
 FreeAndNil(Vec10);
 FreeAndNil(Vec);
 FreeAndNil(VecIntegral);
 FreeAndNil(SL);
end;


procedure SecondTPorSi(Dat_Folder:string);
var SL,SLold:TStringList;
    T,por,i,j :integer;
    tempStr,fileName:string;
 const
  PairCount=11;
  TemValues:array [0..PairCount] of integer =
   (330, 440, 300, 550, 800, 700, 650, 840, 870, 300, 630, 460);
  PorValues:array [0..PairCount] of integer =
   (0,   30,  45,  55,  5,   60,  10,  35,   62,  2,   28,  0);
begin
// showmessage(Dat_Folder);
 SetCurrentDir(Dat_Folder);
 if not(FileExists(Int_aver)) then Exit;
 SL:=TStringList.Create;
 SL.LoadFromFile(Int_aver);
 SLold:=TStringList.Create;

// fileName:=TimeDepFile;
// //TimeDepFile='D:\porousSi\BaseOlikh\tdep.dat';
// T:=300;
//// T:=StrToInt(FolderNameFromFullPath(Dat_Folder,1));
// por:=20;
//// por:=round(100*StrToFloat(FolderNameFromFullPath(Dat_Folder,1)));
// tempStr:=Inttostr(por)+' '+IntToStr(T)+' ';
// if FileExists(fileName)
//   then SLold.LoadFromFile(TimeDepFile)
//   else SLold.Add('por(%) T(K) t(s) Int(W/mK)');
// for i:=0 to SL.Count-1 do
//  SLold.Add(tempStr+SL[i]);
// SLold.SaveToFile(fileName);

 for j := 0 to PairCount do
  begin
   T:=TemValues[j];
   por:=PorValues[j];
   fileName:='D:\porousSi\BaseOlikh\p'
             +IntToStr(por)+'T'+IntToStr(T)+'.dat';
   tempStr:=Inttostr(por)+' '+IntToStr(T)+' ';
   SLold.Clear;
   if FileExists(fileName)
     then SLold.LoadFromFile(TimeDepFile)
     else SLold.Add('por(%) T(K) t(s) Int(W/mK)');
   for i:=0 to SL.Count-1 do
    SLold.Add(tempStr+SL[i]);
   SLold.SaveToFile(fileName);
  end;




 FreeAndNil(SLold);
 FreeAndNil(SL);
end;

end.

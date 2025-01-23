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

   if FileExists(AverDatFile) then VecAver.ReadFromFile(AverDatFile,False);
   if VecAver.HighNumber<0
    then
      begin
       Vec.CopyTo(VecAver);
       FileCount:=0;
      end
    else
     begin
      FileCount:=Round(VecAver.X[VecAver.HighNumber]);
      VecAver.DeletePoint(VecAver.HighNumber);
      for j := 0 to VecAver.HighNumber do
        VecAver.Y[j]:=(VecAver.Y[j]*FileCount+Vec.Y[j])/(FileCount+1);
     end;



   FileBegin:='J'+ShotFileName+inttostr(ColumnNumber-3);
//   Vec.WriteToFile(FileBegin+'.dat',6);
//   VecIntegral.WriteToFile(FileBegin+'int.dat',8);

// ----------------
   VecAver.ImNoiseSmoothedArray(Vec10,10);
   VecAver.ImNoiseSmoothedArray(Vec100,100);
   VecTemp.Clear;
   VecIntegral.Clear;

   VecTemp.Add(VecAver[0]);
   VecTemp.Add(VecAver[1]);
   VecIntegral.Add(VecTemp.X[VecTemp.HighNumber],VecTemp.Int_Trap);

   for I := 0 to 2 do
//   for I := 0 to 9 do
     begin
      VecTemp.Add(Vec10[i]);
      VecIntegral.Add(VecTemp.X[VecTemp.HighNumber],VecTemp.Int_Trap);
     end;

   for I := 0 to Vec100.HighNumber do
//   for I := 1 to Vec100.HighNumber do
     begin
      VecTemp.Add(Vec100[i]);
      VecIntegral.Add(VecTemp.X[VecTemp.HighNumber],VecTemp.Int_Trap);
     end;

//    for I := 0 to VecAver.HighNumber do
//     begin
//      VecTemp.Add(VecAver[i]);
//      if VecTemp.HighNumber>2 then VecIntegral.Add(VecTemp.X[VecTemp.HighNumber],VecTemp.Int_Trap);
//     end;

   Vec10.Clear;
   Vec100.Clear;
   VecIntegral.MultiplyY(1/(Vec.X[1]-Vec.X[0]));
   VecIntegral.WriteToFile(Int_aver,8);

   VecAver.Add(FileCount+1,FileCount+1);
   VecAver.WriteToFile(AverDatFile,6);
   HelpForMe(inttostr(FileCount));
// -----------------


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
    T,por,i :integer;
    tempStr:string;
begin
// showmessage(Dat_Folder);
 SetCurrentDir(Dat_Folder);
 if not(FileExists(Int_aver)) then Exit;
 SL:=TStringList.Create;
 SL.LoadFromFile(Int_aver);
 T:=300;
// T:=StrToInt(FolderNameFromFullPath(Dat_Folder,1));
// por:=20;
 por:=round(100*StrToFloat(FolderNameFromFullPath(Dat_Folder,1)));
 tempStr:=Inttostr(por)+' '+IntToStr(T)+' ';

 SLold:=TStringList.Create;
 if FileExists(TimeDepFile)
   then SLold.LoadFromFile(TimeDepFile)
   else SLold.Add('por(%) T(K) t(s) Int(W/mK)');


 for i:=0 to SL.Count-1 do
  SLold.Add(tempStr+SL[i]);

 SLold.SaveToFile(TimeDepFile);
 FreeAndNil(SLold);
 FreeAndNil(SL);
end;

end.

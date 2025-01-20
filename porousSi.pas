unit porousSi;

interface
 const
 J0Jtfile='J0Jt.';
 AverDatFile='averdat.dat';

//procedure FirsTPorSi(FileName:string='J0Jt.1.dat');
procedure FirsTPorSi(FileName:string);

implementation

uses
  System.Classes, System.SysUtils, Vcl.Dialogs, OlegVector,
  OlegVectorManipulation, OlegFunction;

//procedure FirsTPorSi(FileName:string='J0Jt.1.dat');
procedure FirsTPorSi(FileName:string);
 var SL:TStringList;
     i,ColumnNumber,Temperature,FileCount,j:integer;
     Vec10,Vec100,VecTemp,VecAver:TVector;
     Vec,VecIntegral:TVectorTransform;
     ShotFileName,FileBegin,File_Folder:string;
begin
// showmessage(FileName);
 ShotFileName:=ExtractFileName(FileName);
 ShotFileName:=copy(ShotFileName,1,length(ShotFileName)-4);
 if Pos(J0Jtfile,ShotFileName)>0 then Delete (ShotFileName,1,Length(J0Jtfile));
 File_Folder:=FolderFromFullPath(FileName);

 CreateDirSafety('J0Jt');

 SL:=TStringList.Create;
 SL.LoadFromFile(FileName);
 Vec:=TVectorTransform.Create;
 VecIntegral:=TVectorTransform.Create;
 Vec10:=TVector.Create;
 Vec100:=TVector.Create;
 VecTemp:=TVector.Create;
 VecAver:=TVector.Create;
// showmessage(SL[4]);
// ColumnNumber:=5;
 Temperature:=300;

 SetCurrentDir(File_Folder+'\J0Jt\');

 for ColumnNumber := 4 to 6 do
 begin
   Vec.Clear;
   VecIntegral.Clear;
   for I := 4 to SL.Count-1 do
    begin
      Vec.Add(FloatDataFromRow(SL[i],2),FloatDataFromRow(SL[i],ColumnNumber));
      if Vec.HighNumber>2 then VecIntegral.Add(Vec.X[Vec.HighNumber],Vec.Int_Trap/Temperature);

    end;

   if FileExists(AverDatFile) then VecAver.ReadFromFile(AverDatFile,False);
//    showmessage(inttostr(VecAver.HighNumber));
   if VecAver.HighNumber<0
    then
      begin
       Vec.CopyTo(VecAver);
       VecAver.Add(1,1);
      end
    else
     begin
      FileCount:=Round(VecAver.X[VecAver.HighNumber]);
//      showmessage(inttostr(Round(VecAver.X[VecAver.HighNumber])));
      VecAver.DeletePoint(VecAver.HighNumber);
//      showmessage(inttostr(VecAver.HighNumber));
      for j := 0 to VecAver.HighNumber do
        VecAver.Y[j]:=(VecAver.Y[j]*FileCount+Vec.Y[j])/(FileCount+1);
      VecAver.Add(FileCount+1,FileCount+1);
     end;
   VecAver.WriteToFile(AverDatFile,6);


   FileBegin:='J'+ShotFileName+inttostr(ColumnNumber-3);
   Vec.WriteToFile(FileBegin+'.dat',6);
   VecIntegral.WriteToFile(FileBegin+'int.dat',8);

   Vec.ImNoiseSmoothedArray(Vec10,10);
   Vec.ImNoiseSmoothedArray(Vec100,100);
   VecTemp.Clear;
   VecIntegral.Clear;
   VecTemp.Add(Vec[0]);
   VecTemp.Add(Vec[1]);
   VecIntegral.Add(VecTemp.X[VecTemp.HighNumber],VecTemp.Int_Trap/Temperature);

   for I := 0 to 2 do
     begin
      VecTemp.Add(Vec10[i]);
      VecIntegral.Add(VecTemp.X[VecTemp.HighNumber],VecTemp.Int_Trap/Temperature);
     end;

   for I := 0 to Vec100.HighNumber do
     begin
      VecTemp.Add(Vec100[i]);
      VecIntegral.Add(VecTemp.X[VecTemp.HighNumber],VecTemp.Int_Trap/Temperature);
     end;

   VecTemp.WriteToFile(FileBegin+'sm.dat',6);
   VecIntegral.WriteToFile(FileBegin+'sm_int.dat',8);

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


end.

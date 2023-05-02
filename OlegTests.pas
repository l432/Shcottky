unit OlegTests;

interface

uses
  OlegVector, OlegMath, OlegVectorOld, OlegType;

procedure VectorEquals(const VectorOld:PVector; const VectorNew:TVector);

//function ArrayToString(ArrSingle:TArrSingle):string;overload;
//
//function ArrayToString(ArrSingle:TArrSingle;TitelsArr:array of string):string;overload;

procedure TextFileEquals(const fileName1, fileName2:string);


implementation

uses
  Dialogs, SysUtils, Classes;

procedure VectorEquals(const VectorOld:PVector; const VectorNew:TVector);
 var Rez:boolean;
     i:integer;
begin
 Rez:=True;
 Rez:=Rez and (VectorOld^.n=VectorNew.Count);
 if not(Rez) then
   begin
     showmessage('Fault!!!');
     Exit;
   end;
  for I := 0 to VectorNew.HighNumber do
    Rez:=Rez and IsEqual(VectorOld^.X[i],VectorNew.X[i])
             and IsEqual(VectorOld^.Y[i],VectorNew.Y[i]);

 if Rez then  showmessage('OK')
        else  showmessage('Fault!!!');
end;

procedure TextFileEquals(const fileName1, fileName2:string);
var  Str1,str2:TStringList;
     i:integer;
     Rez:boolean;
begin
 Str1:=TStringList.Create;
 Str2:=TStringList.Create;
 Str1.LoadFromFile(fileName1);
 Str2.LoadFromFile(fileName2);
 Rez:=True;
 try
 for I := 0 to Str1.Count-1 do
  Rez:=(Rez and (Str1[i]=Str2[i]));
 except
  Rez:=False;
 end;

 if Rez then  showmessage('OK')
        else  showmessage('Fault!!!');

 FreeAndNil(Str1);
 FreeAndNil(Str2);
end;


//function ArrayToString(ArrSingle:TArrSingle):string;
// var i:integer;
//begin
//  Result:='';
//  for I := 0 to High(ArrSingle) do
//    Result:=Result+floattostr(ArrSingle[i])+' ';
//end;
//
//function ArrayToString(ArrSingle:TArrSingle;TitelsArr:array of string):string;overload;
// var i:integer;
//begin
//  Result:='';
//  for I := 0 to High(ArrSingle) do
//    begin
//    if i<=High(TitelsArr) then  Result:=Result+TitelsArr[i]+' =';
//    Result:=Result+' '+floattostr(ArrSingle[i])+#10;
//    end;
//end;


end.

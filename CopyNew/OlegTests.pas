unit OlegTests;

interface

uses
  OlegVector, OlegMath, OlegVectorOld, OlegType;

procedure VectorEquals(const VectorOld:PVector; const VectorNew:TVectorNew);

function ArrayToString(ArrSingle:TArrSingle):string;

implementation

uses
  Dialogs, SysUtils;

procedure VectorEquals(const VectorOld:PVector; const VectorNew:TVectorNew);
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


function ArrayToString(ArrSingle:TArrSingle):string;
 var i:integer;
begin
  Result:='';
  for I := 0 to High(ArrSingle) do
    Result:=Result+floattostr(ArrSingle[i])+' ';
end;

end.

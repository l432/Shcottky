unit OlegTests;

interface

uses
  OlegVectorNew, OlegMathNew, OlegVector;

procedure VectorEquals(const VectorOld:PVector; const VectorNew:TVectorNew);

implementation

uses
  Dialogs;

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

end.

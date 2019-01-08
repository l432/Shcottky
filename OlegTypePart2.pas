unit OlegTypePart2;

interface

type

IName = interface
  ['{5B51E68D-11D9-4410-8396-05DB50F07F35}']
  function GetName:string;
  property Name:string read GetName;
end;

TNamedInterfacedObject=class(TInterfacedObject)
  protected
   fName:string;
   function GetName:string;
  public
   property Name:string read GetName;
  end;

implementation

{ TNamedDevice }

function TNamedInterfacedObject.GetName: string;
begin
   Result:=fName;
end;

end.

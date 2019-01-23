unit OlegTypePart2;

interface

uses
  IniFiles;

type

IName = interface
  ['{5B51E68D-11D9-4410-8396-05DB50F07F35}']
  function GetName:string;
  property Name:string read GetName;
end;

TSimpleFreeAndAiniObject=class(TInterfacedObject)
  protected
  public
   procedure Free;virtual;
   procedure ReadFromIniFile(ConfigFile: TIniFile);virtual;
   procedure WriteToIniFile(ConfigFile: TIniFile);virtual;
  end;

//TNamedInterfacedObject=class(TInterfacedObject)
TNamedInterfacedObject=class(TSimpleFreeAndAiniObject)
  protected
   fName:string;
   function GetName:string;
  public
   property Name:string read GetName;
//   procedure Free;virtual;
//   procedure ReadFromIniFile(ConfigFile: TIniFile);virtual;
//   procedure WriteToIniFile(ConfigFile: TIniFile);virtual;
  end;


implementation

{ TNamedDevice }

//procedure TNamedInterfacedObject.Free;
//begin
//
//end;

function TNamedInterfacedObject.GetName: string;
begin
   Result:=fName;
end;

//procedure TNamedInterfacedObject.ReadFromIniFile(ConfigFile: TIniFile);
//begin
//
//end;
//
//procedure TNamedInterfacedObject.WriteToIniFile(ConfigFile: TIniFile);
//begin
//
//end;

{ TSimpleFreeAndAiniObject }

procedure TSimpleFreeAndAiniObject.Free;
begin

end;

procedure TSimpleFreeAndAiniObject.ReadFromIniFile(ConfigFile: TIniFile);
begin

end;

procedure TSimpleFreeAndAiniObject.WriteToIniFile(ConfigFile: TIniFile);
begin

end;

end.

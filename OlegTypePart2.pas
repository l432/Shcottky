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
  end;

//  TObjectArray=class
//    private
//    public
//     ObjectArray:array of TObject;
//     Constructor Create();overload;
//     Constructor Create(InitArray:array of TObject);overload;
//     procedure Add(AddedArray:array of TObject);overload;
//     procedure Add(AddedObject:TObject);overload;
//  end;

  TObjectArray=class
    private
    public
     ObjectArray:array of TSimpleFreeAndAiniObject;
     Constructor Create();overload;
     Constructor Create(InitArray:array of TSimpleFreeAndAiniObject);overload;
     procedure Add(AddedArray:array of TSimpleFreeAndAiniObject);overload;
     procedure Add(AddedObject:TSimpleFreeAndAiniObject);overload;
     procedure ReadFromIniFile(ConfigFile:TIniFile);
     procedure WriteToIniFileAndFree(ConfigFile:TIniFile);
     procedure ObjectFree;
  end;

implementation

{ TNamedDevice }

function TNamedInterfacedObject.GetName: string;
begin
   Result:=fName;
end;


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

Constructor TObjectArray.Create();
begin
 inherited;
 SetLength(ObjectArray,0);
end;

procedure TObjectArray.Add(AddedObject: TSimpleFreeAndAiniObject);
begin
 Add([AddedObject]);
end;

Constructor TObjectArray.Create(InitArray:array of TSimpleFreeAndAiniObject);
begin
  Create();
  Add(InitArray);
end;

procedure TObjectArray.ObjectFree;
 var i:integer;
begin
 for i:=0 to High(ObjectArray) do
   ObjectArray[i].Free
end;

procedure TObjectArray.ReadFromIniFile(ConfigFile:TIniFile);
 var i:integer;
begin
 for i:=0 to High(ObjectArray) do
   ObjectArray[i].ReadFromIniFile(ConfigFile);
end;

procedure TObjectArray.WriteToIniFileAndFree(ConfigFile: TIniFile);
 var i:integer;
begin
 for i:=0 to High(ObjectArray) do
   begin
   ObjectArray[i].WriteToIniFile(ConfigFile);
   ObjectArray[i].Free
   end;
end;

procedure TObjectArray.Add(AddedArray:array of TSimpleFreeAndAiniObject);
 var i:integer;
begin
  SetLength(ObjectArray,High(ObjectArray)+High(AddedArray)+2);
  for I := 0 to High(AddedArray) do
   ObjectArray[High(ObjectArray)-High(AddedArray)+i]:=AddedArray[i];
end;

end.
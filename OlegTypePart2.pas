unit OlegTypePart2;

interface

uses
  IniFiles, OlegType;

type

IName = interface
  ['{5B51E68D-11D9-4410-8396-05DB50F07F35}']
  function GetName:string;
  property Name:string read GetName;
end;

//TSimpleFreeAndAiniObject=class(TInterfacedObject)
//  protected
//  public
//   procedure Free;//virtual;
//   procedure ReadFromIniFile(ConfigFile: TIniFile);virtual;
//   procedure WriteToIniFile(ConfigFile: TIniFile);virtual;
////   destructor Destroy;override;
//  end;


{як варіант позбавлення від проблеми знищення інтерфейсу-змінної
при виході з процедури - див.https://habr.com/ru/post/181107/
є ще інший варіант(??? а може й ні) https://habr.com/ru/post/219685/}
TSimpleFreeAndAiniObject=class(TObject)
  protected
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
  public
   procedure ReadFromIniFile(ConfigFile: TIniFile);virtual;
   procedure WriteToIniFile(ConfigFile: TIniFile);virtual;
  end;


//TNamedInterfacedObject=class(TInterfacedObject)
TNamedInterfacedObject=class(TSimpleFreeAndAiniObject,IName)
  protected
   fName:string;
   function GetName:string;
  public
   property Name:string read GetName;
  end;

TNamedObject=class(TObject)
  private
   fName:string;
   function GetName:string;
  public
   property Name:string read GetName;
   Constructor Create(Nm:string);
end;

  TObjectArray=class
    private
     function GetHighIndex:integer;
     function ObjectGet(Number:integer):TSimpleFreeAndAiniObject;
    public
     ObjectArray:array of TSimpleFreeAndAiniObject;
     property SFIObject[Index:Integer]:TSimpleFreeAndAiniObject read ObjectGet;default;
     property HighIndex:integer read GetHighIndex;
     Constructor Create();overload;
     Constructor Create(InitArray:array of TSimpleFreeAndAiniObject);overload;
     procedure Add(AddedArray:array of TSimpleFreeAndAiniObject);overload;
     procedure Add(AddedObject:TSimpleFreeAndAiniObject);overload;
     procedure ReadFromIniFile(ConfigFile:TIniFile);
     procedure WriteToIniFileAndFree(ConfigFile:TIniFile);
     procedure ObjectFree;
  end;

implementation

uses
  Math, Dialogs, SysUtils, OlegFunction;

{ TNamedDevice }

function TNamedInterfacedObject.GetName: string;
begin
   Result:=fName;
end;


{ TSimpleFreeAndAiniObject }

function TSimpleFreeAndAiniObject.QueryInterface(const IID: TGUID;
  out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TSimpleFreeAndAiniObject._AddRef: Integer;
begin
   Result := -1;
end;

function TSimpleFreeAndAiniObject._Release: Integer;
begin
    Result := -1;
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

function TObjectArray.GetHighIndex: integer;
begin
 Result:=High(ObjectArray);
end;

procedure TObjectArray.ObjectFree;
 var i:integer;
begin
 for i:=0 to High(ObjectArray) do
//   FreeAndNil(ObjectArray[i])
   ObjectArray[i].Free
end;

function TObjectArray.ObjectGet(Number: integer): TSimpleFreeAndAiniObject;
begin
 Result:=ObjectArray[Number];
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

{ TNamedObject }

constructor TNamedObject.Create(Nm: string);
begin
 inherited Create;
 fName:=Nm;
end;

function TNamedObject.GetName: string;
begin
   Result:=fName;
end;

end.

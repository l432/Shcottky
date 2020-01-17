unit FitVariable;

interface

uses
  OApproxNew, StdCtrls, OApproxShow, Forms;

type

TVarBool=class
{змінна булевського типу, потрібна
для проведення апроксимації}
 private
  fName:string;
  fFF:TFitFunctionNew;
 protected
  fDescription:string;
 {опис при виведенні на форму}
  fValue:boolean;
 public
  property Value:boolean read fValue write fValue;
  property Name:string read fName;
  property Description:string read fDescription write fDescription;
  constructor Create(FF:TFitFunctionNew);
  procedure ReadFromIniFile;
  procedure WriteToIniFile;
end;

 TBoolVarCheckBox=class
   private
    fVarBool:TVarBool;
   public
    CB:TCheckBox;
    procedure UpDate;
    constructor Create(VarBool:TVarBool);
    destructor Destroy;override;
 end;

  TDecBoolVarPShow=class(TFFParameterShow)
   private
    fBoolVarCB:TBoolVarCheckBox;
    fFFPShow:TFFParameterShow;
   public
    constructor Create(FFPShow:TFFParameterShow;
                       VB:TVarBool);
    procedure FormPrepare(Form:TForm);override;
    procedure UpDate;override;
    procedure FormClear;override;
    destructor Destroy;override;
 end;

 TDecBoolVarReadWrite=class(TFFReadWrite)
  private
   fReadWrite:TFFReadWrite;
   fVB:TVarBool;
  public
    constructor Create(ReadWrite:TFFReadWrite;
                       VB:TVarBool);
    Procedure WriteToIniFile;override;
    Procedure ReadFromIniFile;override;
 end;

implementation

uses
  Classes, Math;

{ TVarBool }

constructor TVarBool.Create(FF: TFitFunctionNew);
begin
 fFF:=FF;
 fDescription:='';
 fName:='VarBool';
end;

procedure TVarBool.ReadFromIniFile;
begin
 fValue:=fFF.ConfigFile.ReadBool(fFF.Name,Name,False);
end;

procedure TVarBool.WriteToIniFile;
begin
 fFF.ConfigFile.WriteBool(fFF.Name,Name,fValue);
end;


{ TBoolVarCheckBox }

constructor TBoolVarCheckBox.Create(VarBool: TVarBool);
begin
  fVarBool:=VarBool;
  CB:=TCheckBox.Create(nil);
  CB.Caption:=fVarBool.Description;
  CB.Enabled:=True;
  CB.Checked:=fVarBool.Value;
  CB.Alignment:=taLeftJustify;
end;

destructor TBoolVarCheckBox.Destroy;
begin
 CB.Free;
 fVarBool:=nil;
 inherited;
end;

procedure TBoolVarCheckBox.UpDate;
begin
 fVarBool.Value:=CB.Checked;
end;


{ TDecorBoolVar }

constructor TDecBoolVarPShow.Create(FFPShow:TFFParameterShow;
                                VB:TVarBool);
begin
 fFFPShow:=FFPShow;
 fBoolVarCB := TBoolVarCheckBox.Create(VB);
end;

destructor TDecBoolVarPShow.Destroy;
begin
 fBoolVarCB.Free;
  inherited;
end;

procedure TDecBoolVarPShow.FormClear;
begin
 fBoolVarCB.CB.Parent:=nil;
 fFFPShow.FormClear;
end;

procedure TDecBoolVarPShow.FormPrepare(Form:TForm);
begin
  fFFPShow.FormPrepare(Form);
  fBoolVarCB.CB.Parent := Form;
  fBoolVarCB.CB.Top:=Form.Height+MarginTop;
  fBoolVarCB.CB.Left:=MarginLeft;
  Form.Height:=fBoolVarCB.CB.Top+fBoolVarCB.CB.Height;
  Form.Width:=max(Form.Width,
                fBoolVarCB.CB.Left+fBoolVarCB.CB.Width);
end;

procedure TDecBoolVarPShow.UpDate;
begin
  fFFPShow.UpDate;
  fBoolVarCB.UpDate;
end;

{ TDecBoolVarReadWrite }

constructor TDecBoolVarReadWrite.Create(ReadWrite: TFFReadWrite;
                                        VB: TVarBool);
begin
  fReadWrite:=ReadWrite;
  fVB:=VB;
//  fFF:=ReadWrite.FF;
end;

procedure TDecBoolVarReadWrite.ReadFromIniFile;
begin
  fReadWrite.ReadFromIniFile;
  fVB.ReadFromIniFile;
end;

procedure TDecBoolVarReadWrite.WriteToIniFile;
begin
  fReadWrite.WriteToIniFile;
  fVB.WriteToIniFile;
end;

end.

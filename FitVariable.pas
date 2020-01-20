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
  constructor Create(FF:TFitFunctionNew;Description:string);
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

  TDecBoolVarParameter=class(TFFParameter)
   private
    fBoolVarCB:TBoolVarCheckBox;
    fVB:TVarBool;
    fFFParameter:TFFParameter;
   public
    constructor Create(VB:TVarBool;
                       FFParam:TFFParameter);
    procedure FormPrepare(Form:TForm);override;
    procedure UpDate;override;
    procedure FormClear;override;
    destructor Destroy;override;
    Procedure WriteToIniFile;override;
    Procedure ReadFromIniFile;override;
 end;

implementation

uses
  Classes, Math;

{ TVarBool }

constructor TVarBool.Create(FF: TFitFunctionNew;Description:string);
begin
 fFF:=FF;
 fDescription:=Description;
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
//  CB.WordWrap:=True;
  CB.Width:=130;
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

constructor TDecBoolVarParameter.Create(VB:TVarBool;
                       FFParam:TFFParameter);
begin
 fFFParameter:=FFParam;
// fBoolVarCB := TBoolVarCheckBox.Create(VB);
 fVB:=VB;
end;

destructor TDecBoolVarParameter.Destroy;
begin
// fBoolVarCB.Free;
 inherited;
end;

procedure TDecBoolVarParameter.FormClear;
begin
 fBoolVarCB.CB.Parent:=nil;
 fBoolVarCB.Free;
 fFFParameter.FormClear;
end;

procedure TDecBoolVarParameter.FormPrepare(Form:TForm);
begin
  fFFParameter.FormPrepare(Form);
  fBoolVarCB := TBoolVarCheckBox.Create(fVB);
//  fBoolVarCB.CB.Parent := Form;
  AddControlToForm(fBoolVarCB.CB,Form);


//  fBoolVarCB.CB.Top:=Form.Height+MarginTop;
//  fBoolVarCB.CB.Left:=MarginLeft;
//  Form.Height:=fBoolVarCB.CB.Top+fBoolVarCB.CB.Height;
//  Form.Width:=max(Form.Width,
//                fBoolVarCB.CB.Left+fBoolVarCB.CB.Width);
end;

procedure TDecBoolVarParameter.ReadFromIniFile;
begin
  fFFParameter.ReadFromIniFile;
  fVB.ReadFromIniFile;
end;

procedure TDecBoolVarParameter.UpDate;
begin
  fFFParameter.UpDate;
  fBoolVarCB.UpDate;
end;

procedure TDecBoolVarParameter.WriteToIniFile;
begin
 fFFParameter.WriteToIniFile;
 fVB.WriteToIniFile;
end;


end.

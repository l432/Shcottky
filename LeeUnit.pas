unit LeeUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TLeeForm = class(TForm)
    Label8: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label12: TLabel;
    Label7: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    LEXmin: TLabeledEdit;
    LEYmax: TLabeledEdit;
    LEYmin: TLabeledEdit;
    LEXmax: TLabeledEdit;
    Button2: TButton;
    Button1: TButton;
    Label11: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LeeForm: TLeeForm;

implementation

uses Unit1;

{$R *.dfm}

procedure TLeeForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
if Key=#13 then
    begin
    SelectNext((Sender as TForm).ActiveControl,True,True);
    Key:=#0;
    end;
if not(Key in [#8,'0'..'9','+','-','E','e',DecimalSeparator])
 then Key:=#0;
end;

procedure TLeeForm.FormShow(Sender: TObject);
begin
 DiapToForm(D[diLee], LEXmin,LEYmin,LEXmax,LEYmax);
 LEXmin.SetFocus;
end;

end.

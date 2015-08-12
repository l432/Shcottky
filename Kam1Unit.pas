unit Kam1Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TKam1Form = class(TForm)
    Label8: TLabel;
    Label12: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label6: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    LEYmax: TLabeledEdit;
    LEXmax: TLabeledEdit;
    LEYmin: TLabeledEdit;
    LEXmin: TLabeledEdit;
    Button2: TButton;
    Button1: TButton;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Kam1Form: TKam1Form;

implementation

uses Unit1;

{$R *.dfm}

procedure TKam1Form.FormKeyPress(Sender: TObject; var Key: Char);
begin
if Key=#13 then
    begin
    SelectNext((Sender as TForm).ActiveControl,True,True);
    Key:=#0;
    end;
if not(Key in [#8,'0'..'9','+','-','E','e',DecimalSeparator])
 then Key:=#0;
end;

procedure TKam1Form.FormShow(Sender: TObject);
begin
 DiapToForm(D[diKam1], LEXmin,LEYmin,LEXmax,LEYmax);
 LEXmin.SetFocus;
end;

end.

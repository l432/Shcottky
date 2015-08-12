unit NordUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TNordForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    EditGamma: TEdit;
    Label8: TLabel;
    LEXmax: TLabeledEdit;
    LEYmin: TLabeledEdit;
    LEXmin: TLabeledEdit;
    LEYmax: TLabeledEdit;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NordForm: TNordForm;

implementation

uses Unit1;

{$R *.dfm}

procedure TNordForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
if Key=#13 then
    begin
    SelectNext((Sender as TForm).ActiveControl,True,True);
    Key:=#0;
    end;
if not(Key in [#8,'0'..'9','+','-','E','e',DecimalSeparator])
 then Key:=#0;
end;

procedure TNordForm.FormShow(Sender: TObject);
begin
DiapToForm(D[diNord], LEXmin,LEYmin,LEXmax,LEYmax);
EditGamma.Text:=FloatToStrF(Gamma,ffGeneral,2,1);
LEXmin.SetFocus;
end;

end.

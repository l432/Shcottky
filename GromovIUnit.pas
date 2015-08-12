unit GromovIUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TGrIForm = class(TForm)
    Label12: TLabel;
    LEXmin: TLabeledEdit;
    LEYmin: TLabeledEdit;
    LEYmax: TLabeledEdit;
    LEXmax: TLabeledEdit;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label7: TLabel;
    Label18: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GrIForm: TGrIForm;

implementation

uses Unit1;

{$R *.dfm}

procedure TGrIForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
if Key=#13 then
    begin
    SelectNext((Sender as TForm).ActiveControl,True,True);
    Key:=#0;
    end;
if not(Key in [#8,'0'..'9','+','-','E','e',DecimalSeparator])
 then Key:=#0;
end;

procedure TGrIForm.FormShow(Sender: TObject);
begin
 DiapToForm(D[diGr1], LEXmin,LEYmin,LEXmax,LEYmax);
 LEXmin.SetFocus;
end;

end.

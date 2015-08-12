unit Ex2RUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TEx2RForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Button1: TButton;
    Button2: TButton;
    LEXmin: TLabeledEdit;
    LEYmax: TLabeledEdit;
    LEYmin: TLabeledEdit;
    LEXmax: TLabeledEdit;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Ex2RForm: TEx2RForm;

implementation
uses Unit1;

{$R *.dfm}

procedure TEx2RForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
if Key=#13 then
    begin
    SelectNext((Sender as TForm).ActiveControl,True,True);
    Key:=#0;
    end;
if not(Key in [#8,'0'..'9','+','-','E','e',DecimalSeparator])
 then Key:=#0;
end;

procedure TEx2RForm.FormShow(Sender: TObject);
begin
 DiapToForm(D[diE2R], LEXmin,LEYmin,LEXmax,LEYmax);
 LEXmin.SetFocus;
end;

end.

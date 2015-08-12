unit Cibils_new;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TCibilsForm = class(TForm)
    LEXmin: TLabeledEdit;
    LEYmax: TLabeledEdit;
    LEYmin: TLabeledEdit;
    LEXmax: TLabeledEdit;
    Button2: TButton;
    Button1: TButton;
    Label8: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label12: TLabel;
    Label7: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CibilsForm: TCibilsForm;

implementation

uses Unit1;

{$R *.dfm}

procedure TCibilsForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
if Key=#13 then
    begin
    SelectNext((Sender as TForm).ActiveControl,True,True);
    Key:=#0;
    end;
if not(Key in [#8,'0'..'9','+','-','E','e',DecimalSeparator])
 then Key:=#0;
end;

procedure TCibilsForm.FormShow(Sender: TObject);
begin
 DiapToForm(DCib, LEXmin,LEYmin,LEXmax,LEYmax);
 LEXmin.SetFocus;
end;

end.

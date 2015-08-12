unit WernerUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TWernerForm = class(TForm)
    LEXmax: TLabeledEdit;
    LEYmin: TLabeledEdit;
    LEYmax: TLabeledEdit;
    LEXmin: TLabeledEdit;
    Button2: TButton;
    Button1: TButton;
    Label5: TLabel;
    Label12: TLabel;
    Label6: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Label7: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WernerForm: TWernerForm;

implementation

uses Unit1;

{$R *.dfm}

procedure TWernerForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
if Key=#13 then
    begin
    SelectNext((Sender as TForm).ActiveControl,True,True);
    Key:=#0;
    end;
if not(Key in [#8,'0'..'9','+','-','E','e',DecimalSeparator])
 then Key:=#0;
end;

procedure TWernerForm.FormShow(Sender: TObject);
begin
 DiapToForm(D[diWer], LEXmin,LEYmin,LEXmax,LEYmax);
 LEXmin.SetFocus;
end;

end.

unit HfuncUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  THfuncForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LEYmin: TLabeledEdit;
    LEXmin: TLabeledEdit;
    LEXmax: TLabeledEdit;
    LEYmax: TLabeledEdit;
    Label9: TLabel;
    Label10: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label12: TLabel;
    Label11: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HfuncForm: THfuncForm;

implementation

uses Unit1;

{$R *.dfm}


procedure THfuncForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
if Key=#13 then
    begin
    SelectNext((Sender as TForm).ActiveControl,True,True);
    Key:=#0;
    end;
if not(Key in [#8,'0'..'9','+','-','E','e',DecimalSeparator])
 then Key:=#0;
end;

procedure THfuncForm.FormShow(Sender: TObject);
begin
DiapToForm(D[diHfunc], LEXmin,LEYmin,LEXmax,LEYmax);
LEXmin.SetFocus;
end;

end.

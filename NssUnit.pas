unit NssUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TNssForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label11: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    LEXmin: TLabeledEdit;
    LEXmax: TLabeledEdit;
    LEYmax: TLabeledEdit;
    LEYmin: TLabeledEdit;
    Label13: TLabel;
    Label14: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NssForm: TNssForm;

implementation

uses Unit1;

{$R *.dfm}


procedure TNssForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
if Key=#13 then
    begin
    PostMessage( Self.Handle, WM_NEXTDLGCTL, 0, 0);
//    SelectNext((Sender as  TForm).ActiveControl,True,True);
    Key:=#0;
    end;
if not(Key in [#8,'0'..'9','+','-','E','e',DecimalSeparator])
 then Key:=#0;
end;

procedure TNssForm.FormShow(Sender: TObject);
begin
DiapToForm(D[diNss], LEXmin,LEYmin,LEXmax,LEYmax);
LEXmin.SetFocus;
end;

end.

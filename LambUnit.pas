unit LambUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TLambForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    LEXmin: TLabeledEdit;
    Label4: TLabel;
    LEYmin: TLabeledEdit;
    LEXmax: TLabeledEdit;
    LEYmax: TLabeledEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    CB_Rs: TCheckBox;
    CB_Rsh: TCheckBox;
    CB_Iph: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label16: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LambForm: TLambForm;

implementation

uses Unit1, OlegType;

{$R *.dfm}

procedure TLambForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
if Key=#13 then
    begin
    SelectNext((Sender as TForm).ActiveControl,True,True);
    Key:=#0;
    end;
if not(Key in [#8,'0'..'9','+','-','E','e',DecimalSeparator])
 then Key:=#0;
end;

procedure TLambForm.FormShow(Sender: TObject);
begin
ModeToForm(Mode_Lam,Iph_Lam,CB_Rs,CB_Rsh,CB_Iph);
DiapToForm(D[diLam], LEXmin,LEYmin,LEXmax,LEYmax);
LEXmin.SetFocus;
end;



end.

unit DEUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TDEForm = class(TForm)
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
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    CB_Rs: TCheckBox;
    CB_Rsh: TCheckBox;
    CB_Iph: TCheckBox;
    RG: TRadioGroup;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DEForm: TDEForm;

implementation

uses Unit1, OlegApprox;

{$R *.dfm}

procedure TDEForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
if Key=#13 then
    begin
    SelectNext((Sender as TForm).ActiveControl,True,True);
    Key:=#0;
    end;
if not(Key in [#8,'0'..'9','+','-','E','e',DecimalSeparator])
 then Key:=#0;
end;

procedure TDEForm.FormShow(Sender: TObject);
begin
ModeToForm(Mode_DE,Iph_DE,CB_Rs,CB_Rsh,CB_Iph);
DiapToForm(D[diDE], LEXmin,LEYmin,LEXmax,LEYmax);
//case EvolType of
//  TMABC:RG.ItemIndex:=1;
//  TTLBO:RG.ItemIndex:=2;
//  TPSO:RG.ItemIndex:=3;
//  else RG.ItemIndex:=0;
//end;
LEXmin.SetFocus;
end;



end.

unit IvanovUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, NssUnit, StdCtrls, ExtCtrls;

type
  TIvanovForm = class(TNssForm)
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IvanovForm: TIvanovForm;

implementation

uses Unit1;

{$R *.dfm}

procedure TIvanovForm.FormShow(Sender: TObject);
begin
DiapToForm(D[diIvan], LEXmin,LEYmin,LEXmax,LEYmax);
LEXmin.SetFocus;
end;

end.

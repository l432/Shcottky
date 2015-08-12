unit FrParam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls;

type
  TFrParamP = class(TFrame)
    Panel: TPanel;
    LName: TLabel;
    CBIntr: TCheckBox;
    EParam: TEdit;
    procedure CBIntrClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrParamP.CBIntrClick(Sender: TObject);
begin
  Eparam.Enabled:=CBIntr.Checked;
end;

end.

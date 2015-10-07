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
    procedure EParamKeyPress(Sender: TObject; var Key: Char);
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

procedure TFrParamP.EParamKeyPress(Sender: TObject; var Key: Char);
begin
Eparam.Enabled:=CBIntr.Checked;
if Key=#13 then
    begin
    PostMessage( Self.Handle, WM_NEXTDLGCTL, 0, 0);
//    SelectNext((Sender as  TForm).ActiveControl,True,True);
    Key:=#0;
    end;
if not(Key in [#8,'0'..'9','+','-','E','e',DecimalSeparator])
 then Key:=#0;
end;


end.

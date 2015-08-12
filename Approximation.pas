unit Approximation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TApprox = class(TForm)
    ButCan: TButton;
    LNmax: TLabel;
    LNit: TLabel;
    Ln: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    procedure ButCanClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Approx: TApprox;

implementation

{$R *.dfm}


procedure TApprox.ButCanClick(Sender: TObject);
begin
Close;
end;

end.

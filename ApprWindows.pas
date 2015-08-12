unit ApprWindows;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TApp = class(TForm)
    ButCan: TButton;
    LNmax: TLabel;
    LNit: TLabel;
    LNmaxN: TLabel;
    LNitN: TLabel;
    procedure ButCanClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  App: TApp;

implementation

{$R *.dfm}


procedure TApp.ButCanClick(Sender: TObject);
begin
Close;
end;

end.

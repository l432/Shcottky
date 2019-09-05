unit FrApprPar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls,IniFiles,FrameButtons,OlegMathNew,OlegFunctionNew;

const
 FuncName:array[0..0] of string =('Diod');

type
  TFrApprP = class(TFrame)
    Panel1: TPanel;
    LName: TLabel;
    minIn: TLabeledEdit;
    GBoxInit: TGroupBox;
    maxIn: TLabeledEdit;
    GBoxLim: TGroupBox;
    minLim: TLabeledEdit;
    maxLim: TLabeledEdit;
    GBoxMode: TGroupBox;
    RBNorm: TRadioButton;
    RBLogar: TRadioButton;
    RBCons: TRadioButton;
    Bt: TButton;
    procedure minInKeyPress(Sender: TObject; var Key: Char);
    procedure RBConsClick(Sender: TObject);
    procedure BtClick(Sender: TObject);
  private

    { Private declarations }
  public
//-----див.TFitIteration--------
    FA,FB,FC:double;
    FXt:integer;
    FVarName:array of string;
  end;

implementation

{$R *.dfm}


procedure TFrApprP.BtClick(Sender: TObject);
var Form:TForm;
    Buttons:TFrBut;
    Img:TImage;
    Lab,Labt:Tlabel;
    CB:TComBobox;
    Koef:array[0..2] of TLabeledEdit;
    i:integer;
begin
 Form:=Tform.Create(Application);
 Form.Position:=poMainFormCenter;
 Form.AutoScroll:=True;
 Form.BorderIcons:=[biSystemMenu];
 Form.Caption:=Panel1.Parent.Name+' constant value';
 Form.ParentFont:=True;
 Form.Font.Name:='Tahoma';
 Form.Font.Size:=10;
 Form.Font.Style:=[fsBold];
 Form.Color:=RGB(254,226,218);

 Img:=TImage.Create(Form);
 Img.Parent:=Form;
 Img.Top:=10;
 Img.Left:=50;
 Img.Height:=40;
 Img.Stretch:=True;
 Img.Picture.Bitmap.LoadFromResourceName(hInstance, 'ConstFig');
 Img.Width:=round(Img.Height*Img.Picture.Width/Img.Picture.Height);

 Lab:=TLabel.Create(Form);
 Lab.Parent:=Form;
 Lab.Caption:=Panel1.Parent.Name;
 Lab.Font.Size:=10;
 Lab.Top:=22;
 lab.Left:=15;

 Labt:=TLabel.Create(Form);
 Labt.Parent:=Form;
 Labt.Caption:='t =';
 Labt.Top:=Lab.Top+Lab.Height+30;
 Labt.Left:=15;

 CB:=TComboBox.Create(Form);
 CB.Parent:=Form;
 CB.Top:=Labt.Top-3;
 CB.Left:=Labt.Left+30;
 CB.Width:=150;
 CB.Items.Clear;
 CB.Sorted:=False;
 CB.Items.Add('none');

 for I := 0 to High(FVarName) do
  CB.Items.Add(' '+FVarName[i]+' ');
 for I := 0 to High(FVarName) do
  CB.Items.Add(' '+FVarName[i]+', inverse');

 CB.ItemIndex:=FXt;

 for i:=0 to High(Koef) do
  begin
   Koef[i]:=TLabeledEdit.Create(Form);
   Koef[i].Parent:=Form;
   Koef[i].Top:= Labt.Top+ Labt.Height+30;
   Koef[i].LabelPosition:=lpLeft;
   Koef[i].Width:=70;
   Koef[i].Left:=45+i*(Koef[i].Width+35);
   Koef[i].OnKeyPress:=minIn.OnKeyPress;
  end;
 Koef[0].EditLabel.Caption:='A =';
 Koef[1].EditLabel.Caption:='B =';
 Koef[2].EditLabel.Caption:='C =';

 Koef[0].Text:=ValueToStr555(FA);
 Koef[1].Text:=ValueToStr555(FB);
 Koef[2].Text:=ValueToStr555(FC);

 Buttons:=TFrBut.Create(Form);
 Buttons.Parent:=Form;
 Buttons.Left:=10;
 Buttons.Top:=170;


 Form.Width:=Buttons.Left+Buttons.Width+40;
 Form.Height:= Buttons.Top+70;

 if Form.ShowModal=mrOk then
   begin
     FXt:=CB.ItemIndex;
     FA:=StrToFloat555(Koef[0].Text);
     FB:=StrToFloat555(Koef[1].Text);
     FC:=StrToFloat555(Koef[2].Text);
   end;

 ElementsFromForm(Form);
 Form.Hide;
 Form.Release;
end;


procedure TFrApprP.minInKeyPress(Sender: TObject; var Key: Char);
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

procedure TFrApprP.RBConsClick(Sender: TObject);
begin
  minLim.Enabled:=not(RBCons.Checked);
  maxLim.Enabled:=not(RBCons.Checked);
  maxIn.Enabled:=not(RBCons.Checked);
  minIn.Enabled:=not(RBCons.Checked);
  Bt.Enabled:=RBCons.Checked;
end;

end.

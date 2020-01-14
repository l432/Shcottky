unit FormSelectFit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,OlegApprox,Unit1new,FrameButtons;

type
  TFormSF = class(TForm)
    Img: TImage;
    CB: TListBox;
    Lab: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure SizeInit;

var
  FormSF: TFormSF;
  Buttons:TFrBut;


implementation

{$R *.dfm}

Procedure SizeInit;
const ImgHeight=300;
      ImgWidth=500;
begin
FormSF.Img.Height:=ImgHeight;
FormSF.Img.Width:=ImgWidth;
FormSF.Lab.Width:=FormSF.Img.Width-20;
end;

procedure TFormSF.CBClick(Sender: TObject);
var F:TFitFunction;
begin
if CB.Items[FormSF.CB.ItemIndex]='None' then
  begin
    Img.Visible:=False;
    Lab.Caption:='None';
    Exit;
  end;
FunCreate(CB.Items[FormSF.CB.ItemIndex],F);
if  Assigned(F) then
begin
//  Img.Visible:=True;
  SizeInit;
  if F.HasPicture then
   begin
    PictLoadScale(Img,F.PictureName);
    Img.Visible:=True;
   end
                  else
    Img.Visible:=False;
  Lab.Caption:=F.Caption;
  F.Free;
end;
end;

procedure TFormSF.FormCreate(Sender: TObject);
const MarginLeft=20;
      MarginRight=30;
      Marginbetween=20;
      MarginTop=20;
var i:integer;
begin
 FormSF.Name:='FitSelect';
 FormSF.Position:=poMainFormCenter;
 FormSF.AutoScroll:=True;
 FormSF.BorderIcons:=[biSystemMenu];
 FormSF.Caption:='Select fitting operation';
 FormSF.Font.Name:='Tahoma';
 FormSF.Font.Size:=8;
 FormSF.Font.Style:=[fsBold];

 Img.Top:=50;
 Img.Left:=MarginLeft;
 Img.Stretch:=True;

 Lab.Top:=Img.Top+Img.Height+Marginbetween;
 Lab.Left:=MarginLeft+10;
 Lab.Width:=Img.Width-20;
 Lab.WordWrap:=True;
 Lab.Font.Size:=12;
 Lab.Font.Style:=[fsBold];
 Lab.Caption:='None';
 SizeInit;

 CB.Top:=MarginTop;
 CB.Left:=Img.Left+Img.Width+Marginbetween;
 CB.Width:=200;
 CB.Height:=450;
 CB.Items.Clear;
 CB.Sorted:=False;
 CB.MultiSelect:=False;
 for I := 0 to High(FuncName) do
   CB.Items.Add(FuncName[i]);

 Buttons:=TFrBut.Create(FormSF);
 Buttons.Parent:=FormSF;
 Buttons.Left:=50;
 Buttons.Top:=CB.Top+CB.Height+MarginTop;

 FormSF.Width:=CB.Left+CB.Width+MarginRight;
 FormSF.Height:=Buttons.Top+Buttons.Height+MarginTop+30;

end;


procedure TFormSF.FormDestroy(Sender: TObject);
begin
 Buttons.Parent:=nil;
 Buttons.Free;
end;

procedure TFormSF.FormShow(Sender: TObject);
var i:integer;
begin
 for I := 0 to CB.Count-1 do
 if CB.Items[i]=Form1.SButFit.Caption then
     begin
       CB.Selected[i]:=True;
       Form1.ApproxHide;
     end;
end;

end.

unit FormSelectFitNew;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, FrameButtons, OlegApprox;

const //MarginLeft=20;
      //MarginRight=30;
      //Marginbetween=20;
      //MarginTop=20;
      ImgHeightNew=700;
      ImgWidthNew=700;

type
  TFormSFNew = class(TForm)
    TVFormSF: TTreeView;
    LFormSF: TLabel;
    ImgFSF: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TVFormSFClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure TreeFilling;
    { Private declarations }
    procedure SizeInit;
  public
    SelectedString:string;
    { Public declarations }
  end;

var
  FormSFNew: TFormSFNew;
  Buttons:TFrBut;

implementation

uses
  OApproxCaption, OApproxNew, OApproxShow;

{$R *.dfm}

{ TFormSFNew }

procedure TFormSFNew.FormCreate(Sender: TObject);
begin
 Name:='FitSelectNew';
 Position:=poMainFormCenter;
 AutoScroll:=True;
 BorderIcons:=[biSystemMenu];
 Caption:='Select fitting operation';
 Font.Name:='Tahoma';
 Font.Size:=8;
 Font.Style:=[fsBold];

 ImgFSF.Top:=50;
 ImgFSF.Left:=MarginLeft;
 ImgFSF.Stretch:=True;

 LFormSF.Top:=ImgFSF.Top+ImgFSF.Height+Marginbetween;
 LFormSF.Left:=MarginLeft+10;
 LFormSF.Width:=ImgFSF.Width-20;
 LFormSF.WordWrap:=True;
 LFormSF.Font.Size:=12;
 LFormSF.Font.Style:=[fsBold];
 LFormSF.Caption:='None';
 LFormSF.AutoSize:=True;

 SizeInit;

 TVFormSF.Top:=MarginTop;
 TVFormSF.Left:=ImgFSF.Left+ImgFSF.Width+Marginbetween;
 TVFormSF.Width:=300;
 TVFormSF.Height:=450;
 TVFormSF.Items.Clear;
 TVFormSF.SortType:=stNone;
 TVFormSF.MultiSelect:=False;
 TreeFilling;


 Buttons:=TFrBut.Create(Self);
 Buttons.Parent:=Self;
 Buttons.Left:=50;
 Buttons.Top:=TVFormSF.Top+TVFormSF.Height+MarginTop;

 Self.Width:=TVFormSF.Left+TVFormSF.Width+MarginRight;
 Self.Height:=Buttons.Top+Buttons.Height+MarginTop+30;
end;

procedure TFormSFNew.FormDestroy(Sender: TObject);
begin
 Buttons.Parent:=nil;
 Buttons.Free;
end;

procedure TFormSFNew.FormShow(Sender: TObject);
var Node : TTreeNode;
begin
Node := TVFormSF.Items.GetFirstNode;
while (Node <> nil) do begin
         if Node.Text = SelectedString then
           begin
            Node.Selected:=True;
            TVFormSF.SetFocus;
            Exit;
           end;
         Node := Node.GetNext;
         end; // while
end;

procedure TFormSFNew.SizeInit;
begin
 ImgFSF.Height:=ImgHeightNew;
 ImgFSF.Width:=ImgWidthNew;
 LFormSF.Width:=ImgFSF.Width-20;
end;

procedure TFormSFNew.TreeFilling;
 var i:TFitFuncCategory;
     node: TTreeNode;
     j:integer;
begin
 TVFormSF.Items.BeginUpdate;
 i:=Low(TFitFuncCategory);
 node:=nil;
 while  i<=High(TFitFuncCategory) do
  begin
   node:= TVFormSF.Items.Add(node,FitFuncCategoryNames[i]);
   for j:=0 to High(FitFuncNames[i]) do
     TVFormSF.Items.AddChild(node,FitFuncNames[i,j]);
   inc(i);
  end;
 TVFormSF.Items.EndUpdate;
end;

procedure TFormSFNew.TVFormSFClick(Sender: TObject);
var F:TFitFunctionNew;
begin
 SelectedString:=TVFormSF.Selected.Text;
 F:=FitFunctionFactory(SelectedString);
 if  Assigned(F) then
  begin
  SizeInit;
  if F.HasPicture then
   begin
    PictLoadScale(ImgFSF,F.PictureName);
    ImgFSF.Visible:=True;
   end            else //if F.HasPicture then
    ImgFSF.Visible:=False;
  LFormSF.Width:=ImgFSF.Width-20;
  LFormSF.Caption:=F.Caption;
  F.Free;
  end             else  // if  Assigned(F) then
  begin
    ImgFSF.Visible:=False;
    LFormSF.Caption:='None';
    SelectedString:='None';
  end;
end;

end.

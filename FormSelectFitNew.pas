unit FormSelectFitNew;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, FrameButtons;

const MarginLeft=20;
      MarginRight=30;
      Marginbetween=20;
      MarginTop=20;
      ImgHeight=300;
      ImgWidth=500;

type
  TFormSFNew = class(TForm)
    TVFormSF: TTreeView;
    LFormSF: TLabel;
    ImgFSF: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure TreeFilling;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSFNew: TFormSFNew;
  Buttons:TFrBut;

implementation

uses
  OApproxCaption;

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
 ImgFSF.Height:=ImgHeight;
 ImgFSF.Width:=ImgWidth;

 LFormSF.Top:=ImgFSF.Top+ImgFSF.Height+Marginbetween;
 LFormSF.Left:=MarginLeft+10;
 LFormSF.Width:=ImgFSF.Width-20;
 LFormSF.WordWrap:=True;
 LFormSF.Font.Size:=12;
 LFormSF.Font.Style:=[fsBold];
 LFormSF.Caption:='None';
 LFormSF.Width:=ImgFSF.Width-20;

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
//   CB.Items.Add(FuncName[i]);

//var j : integer;
//      Node : TTreeNode;
//begin
//Result:=nil;
//j:=0;
//Node := Tree.Items.GetFirstNode;
//while (Node <> nil) do begin
//         if Node.Text = … then begin
//            Result := Node;
//            Exit;
//            end;
//         Node := Node.GetNext;
//         end; // while
end;

end.

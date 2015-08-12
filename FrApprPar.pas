unit FrApprPar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls,IniFiles,FrameButtons,OlegMath;

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
    { Public declarations }
  end;

implementation

{$R *.dfm}


procedure TFrApprP.BtClick(Sender: TObject);
var Form:TForm;
    ConfigFile:TIniFile;
    Buttons:TFrBut;
    Img:TImage;
    Lab,Labt:Tlabel;
    CB:TComBobox;
    Koef:array[0..2] of TLabeledEdit;
    str,str1:string;
    i,j:byte;
    ParamName:array of string;
begin
 ConfigFile:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'Shottky.ini');
 Form:=Tform.Create(Application);
// Form.Name:=Panel1.Parent.Name+'constant value' ;
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
 str:=ConfigFile.ReadString(Panel1.Parent.Parent.Name,'Pnames','');

 str1:='';
 j:=1;
 for I := 1 to Length(str) do
  begin
   if str[i]='*' then
      begin
       SetLength(ParamName,j);
       ParamName[High(ParamName)]:=str1;
       str1:='';
       inc(j);
      end
                else
      str1:=str1+str[i];
  end;
 for I := 2 to High(ParamName) do
  CB.Items.Add(' '+ParamName[i]+' ');
 for I := 2 to High(ParamName) do
  CB.Items.Add(' '+ParamName[i]+', inverse');

 j:=ConfigFile.ReadInteger(Panel1.Parent.Parent.Name,
                  Panel1.Parent.Name+'tt',0);
 if j=0 then CB.ItemIndex:=0;

 if ((j>0) and (j<=High(ParamName))) then CB.ItemIndex:=j-1;

 if (j>High(ParamName)) then CB.ItemIndex:=j-High(ParamName)-1;

//(FXt[i]<FPNs)and(FXt[i]>0)
  {містить числа, пов'язані з параметрами,
 які використовуються для розрахунку змінної:
 0 - без параметрів, тобто змінна = А
 2..(FPNs-1) - FParam[FXt[i]]
 (FPNs+2)..(2FPNs-1) - FParam[FXt[i]-FPNs]^(-1)}

 for i:=0 to High(Koef) do
  begin
   Koef[i]:=TLabeledEdit.Create(Form);
   Koef[i].Parent:=Form;
   Koef[i].Top:= Labt.Top+ Labt.Height+30;
   Koef[i].LabelPosition:=lpLeft;
   Koef[i].Width:=50;
   Koef[i].Left:=45+i*(Koef[i].Width+35);
   Koef[i].OnKeyPress:=minIn.OnKeyPress;
  end;
 Koef[0].EditLabel.Caption:='A =';
 Koef[1].EditLabel.Caption:='B =';
 Koef[2].EditLabel.Caption:='C =';
 Koef[0].Text:=ValueToStr555(
      ConfigFile.ReadFloat(Panel1.Parent.Parent.Name,
                             Panel1.Parent.Name+'A',555));
// showmessage(floattostr(ConfigFile.ReadFloat('Diod',
//                             'nA',555)));
 Koef[1].Text:=ValueToStr555(
      ConfigFile.ReadFloat(Panel1.Parent.Parent.Name,
                             Panel1.Parent.Name+'B',555));
 Koef[2].Text:=ValueToStr555(
      ConfigFile.ReadFloat(Panel1.Parent.Parent.Name,
                             Panel1.Parent.Name+'C',555));

 Buttons:=TFrBut.Create(Form);
 Buttons.Parent:=Form;
 Buttons.Left:=10;
 Buttons.Top:=170;


// Form.Width:=Img.Width+80;
 Form.Width:=Buttons.Left+Buttons.Width+40;
 Form.Height:= Buttons.Top+70;
 ConfigFile.Free;

 if Form.ShowModal=mrOk then
   begin
     ConfigFile:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'Shottky.ini');
//     showmessage(inttostr(CB.ItemIndex));
     if CB.ItemIndex=0 then j:=0;
     if ((CB.ItemIndex>0)and(CB.ItemIndex<High(ParamName)))
         then j:=CB.ItemIndex+1;
     if (CB.ItemIndex>=High(ParamName))
         then j:=CB.ItemIndex+1+High(ParamName);
     ConfigFile.WriteInteger(Panel1.Parent.Parent.Name,
                  Panel1.Parent.Name+'tt',j);

     ConfigFile.WriteFloat(Panel1.Parent.Parent.Name,
                             Panel1.Parent.Name+'A',
                             StrToFloat555(Koef[0].Text));
     ConfigFile.WriteFloat(Panel1.Parent.Parent.Name,
                             Panel1.Parent.Name+'B',
                             StrToFloat555(Koef[1].Text));
     ConfigFile.WriteFloat(Panel1.Parent.Parent.Name,
                             Panel1.Parent.Name+'C',
                             StrToFloat555(Koef[2].Text));

     ConfigFile.Free;
   end;
//showmessage(Panel1.Parent.Parent.Name);


 Buttons.Parent:=nil;
 Buttons.Free;
 for i:=0 to High(Koef) do
  begin
   Koef[i].Parent:=nil;
   Koef[i].Free;
  end;
 CB.Parent:=nil;
 CB.Free;
 Lab.Parent:=nil;
 Lab.Free;
 Labt.Parent:=nil;
 Labt.Free;
 Img.Parent:=nil;
 Img.Free;
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

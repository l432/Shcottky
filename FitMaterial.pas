unit FitMaterial;

interface

uses
  OlegMaterialSamples, OApproxNew, Forms, Classes, StdCtrls, OlegShowTypes, 
  FitVariableShow, ExtCtrls;

type

//TMaterialFit=class(TMaterial)
// private
//  fFF:TFitFunctionNew;
// public
//  Constructor Create(MaterialName:TMaterialName;FF:TFitFunctionNew);
//
//end;

TDSchottkyFit=class(TDiod_Schottky)
{дещо скорочений варіант, параметри діелектричного шару
не передбачено змінювати, матеріал лише з переліку,
з довільними сонстантами не вибирається}
 private
  fFF:TFitFunctionNew;
 public
  Constructor Create(FF:TFitFunctionNew);
  destructor Destroy;override;
  procedure ReadFromIni;
  procedure WriteToIni;
end;

TD_PNFit=class(TDiod_PN)
{дещо скорочений варіант, параметри діелектричного шару
не передбачено змінювати - функції такі}
 private
  fFF:TFitFunctionNew;
 public
  Constructor Create(FF:TFitFunctionNew);
  destructor Destroy;override;
  procedure ReadFromIni;
  procedure WriteToIni;
end;


 TMaterialFrame=class
   private
    fMaterial:TMaterial;
    fCBSelect:TComboBox;
   public
    Frame:TFrame;
    constructor Create(AOwner: TComponent;Material:TMaterial);//override;
    destructor Destroy;override;
    procedure SizeDetermination (Form: TForm);//virtual;
    procedure DateUpdate;//virtual;
 end;

  TMaterialLayerFrame=class(TNumberFrame)
   private
    fMaterialLayer:TMaterialLayer;
    fDopingShow:TDoubleParameterShow;
    RG:TRadioGroup;
    MaterialFrame:TMaterialFrame;
   public
    constructor Create(AOwner: TComponent;MaterialLayer:TMaterialLayer);
    destructor Destroy;override;
    procedure SizeDetermination (Form: TForm);override;
    procedure DateUpdate;override;
 end;

  TDAreaFrame=class(TSimpleDoubleFrame)
   private
    fDiod:TDiodMaterial;
   protected
   public
    constructor Create(AOwner: TComponent;Schottky:TDiodMaterial);
    procedure DateUpdate;override;
  end;

 TDiodGroupBox=class
  private
   fLayerFrame:TMaterialLayerFrame;
   fAreaFrame:TDAreaFrame;
  public
   GB:TGroupBox;
   constructor Create(AOwner: TComponent);
   destructor Destroy;override;
   procedure SizeDetermination (Form: TForm);virtual;
   procedure DateUpdate;virtual;
 end;

 TDSchottkyGroupBox=class(TDiodGroupBox)
  private
  public
   constructor Create(AOwner: TComponent;Schottky:TDSchottkyFit);
 end;

 TD_PNGroupBox=class(TDiodGroupBox)
  private
   fSecondLayerFrame:TMaterialLayerFrame;
   procedure RGOnClick(Sender: TObject);
  public
   constructor Create(AOwner: TComponent;D_PN:TD_PNFit);
   destructor Destroy;override;
   procedure SizeDetermination (Form: TForm);override;
   procedure DateUpdate;override;
 end;


 TDecDiodParameter=class(TFFParameter)
   private
    fGroupBox:TDiodGroupBox;
    fFFParameter:TFFParameter;
    procedure CreateGroupBox(Form: TForm);virtual;abstract;
   public
    procedure FormPrepare(Form:TForm);override;
    procedure UpDate;override;
    procedure FormClear;override;
    function IsReadyToFitDetermination:boolean;override;
 end;

 TDecDSchottkyParameter=class(TDecDiodParameter)
   private
     fSchottky:TDSchottkyFit;
    procedure CreateGroupBox(Form: TForm);override;
   public
    constructor Create(Schottky:TDSchottkyFit;
                       FFParam:TFFParameter);
    Procedure WriteToIniFile;override;
    Procedure ReadFromIniFile;override;
 end;

 TDecD_PNParameter=class(TDecDiodParameter)
   private
     fD_PN:TD_PNFit;
    procedure CreateGroupBox(Form: TForm);override;
   public
    constructor Create(D_PN:TD_PNFit;
                       FFParam:TFFParameter);
    Procedure WriteToIniFile;override;
    Procedure ReadFromIniFile;override;
 end;





implementation

uses
  Graphics, Math, OApproxShow, Dialogs, SysUtils;

//{ TMaterialFit }
//
//constructor TMaterialFit.Create(MaterialName: TMaterialName;
//  FF: TFitFunctionNew);
//begin
//  inherited Create(MaterialName);
//  fFF:=FF;
//end;

{ TMaterialFrame }

constructor TMaterialFrame.Create(AOwner: TComponent; Material: TMaterial);
 var i :TMaterialName;
     j:integer;
begin
 inherited Create;
 fMaterial:=Material;

 Frame:=TFrame.Create(AOwner);
// Frame.Color:=clInfoBk;
// Frame.Font.Name:='Tahoma';
// Frame.Font.Size:=10;
// Frame.Font.Height:=-13;


 fCBSelect:=TComboBox.Create(Frame);
 fCBSelect.Style:=csDropDownList;
 fCBSelect.Parent:=Frame;
 fCBSelect.Enabled:=True;
 fCBSelect.ParentFont:=True;
 fCBSelect.Sorted:=False;
 fCBSelect.Top:=MarginFrame;
 fCBSelect.Left:=MarginFrame;
 fCBSelect.Width:=80;

 for i :=Low(TMaterialName) to Pred(High(TMaterialName)) do
      fCBSelect.Items.Add(Materials[i].Name);

 for j := 0 to fCBSelect.Items.Count - 1 do
   if fCBSelect.Items[j]=fMaterial.Name then
     begin
      fCBSelect.ItemIndex:=j;
      Break;
     end;

end;

procedure TMaterialFrame.DateUpdate;
begin
 fMaterial.ChangeMaterial(TMaterialName(fCBSelect.ItemIndex));
end;

destructor TMaterialFrame.Destroy;
begin
  fMaterial:=nil;
  fCBSelect.Free;
  inherited;
end;

procedure TMaterialFrame.SizeDetermination(Form: TForm);
 var i:integer;
      tempstr:string;
begin
  tempstr:='';
  for i := 0 to fCBSelect.Items.Count - 1 do
   if Length(fCBSelect.Items[i])>Length(tempstr)
     then tempstr:=fCBSelect.Items[i];

 fCBSelect.Width:=Form.Canvas.TextWidth(tempstr)+35;
 fCBSelect.Height:=Form.Canvas.TextHeight(tempstr);
 Frame.Width:=fCBSelect.Left+fCBSelect.Width+MarginFrame;
 Frame.Height:=fCBSelect.Top+fCBSelect.Height+MarginFrame;
end;

{ TMaterialLayerFrame }

constructor TMaterialLayerFrame.Create(AOwner: TComponent;
                    MaterialLayer: TMaterialLayer);
begin
 inherited Create(AOwner);
 fMaterialLayer:=MaterialLayer;
 fOrientation:=oCol;

 fLabel.Font.Color:=clNavy;
 fDopingShow:=TDoubleParameterShow.Create(fSText,fLabel,
           'Carrier concentration, m^(-3)',fMaterialLayer.Nd);
 fDopingShow.Limits.SetLimits(0);

 RG:=TRadioGroup.Create(Frame);
 RG.Parent:=Frame;
 RG.Font.Color:=clOlive;
 RG.Font.Style:=[fsBold];
 RG.Caption:='Type';
 RG.Top:=MarginFrame;
 RG.Left:=MarginFrame;
 RG.Columns:=2;
 RG.Items.Clear;
 RG.Items.Add('n');
 RG.Items.Add('p');
 if fMaterialLayer.IsNType then RG.ItemIndex:=0
                           else RG.ItemIndex:=1;

 MaterialFrame:=TMaterialFrame.Create(AOwner,fMaterialLayer.Material);
 MaterialFrame.Frame.Parent:=Frame;
end;

procedure TMaterialLayerFrame.DateUpdate;
begin
 fMaterialLayer.IsNType:=(RG.ItemIndex=0);
 fMaterialLayer.Nd:=fDopingShow.Data;
 MaterialFrame.DateUpdate;
end;

destructor TMaterialLayerFrame.Destroy;
begin
  MaterialFrame.Free;
  fMaterialLayer:=nil;
  RG.Parent:=nil;
  RG.Free;
  fDopingShow.Free;
  inherited;
end;

procedure TMaterialLayerFrame.SizeDetermination(Form: TForm);
begin

 inherited SizeDetermination(Form);
 RG.Width:=2*Form.Canvas.TextWidth(RG.Items[0])+70;
 RG.Height:=Form.Canvas.TextHeight(RG.Items[0])+30;

 fLabel.Top:=RG.Top;
 fLabel.Left:=RG.Left+RG.Width+4*MarginFrame;
 RelativeLocation(fLabel,fSText,fOrientation);

 MaterialFrame.SizeDetermination(Form);
 MaterialFrame.Frame.Top:=0;
 MaterialFrame.Frame.Left:=fLabel.Left+fLabel.Width+4*MarginFrame;

 Frame.Width:=MaterialFrame.Frame.Left+MaterialFrame.Frame.Width;
 Frame.Height:=max(MaterialFrame.Frame.Top+MaterialFrame.Frame.Height,
                   RG.Top+RG.Height)+MarginFrame;

end;

{ TDSchottkyFit }

constructor TDSchottkyFit.Create(FF: TFitFunctionNew);
begin
 inherited Create;
 Self.Semiconductor.Material:=TMaterial.Create(TMaterialName(0));
 fFF:=FF;
end;

destructor TDSchottkyFit.Destroy;
begin
  Self.Semiconductor.Material.Free;
  inherited;
end;

procedure TDSchottkyFit.ReadFromIni;
begin
  Area:=fFF.ConfigFile.ReadFloat(fFF.Name,'Square Schottky',3.14e-6);
  Semiconductor.Nd:=fFF.ConfigFile.ReadFloat(fFF.Name,'Concentration Schottky',5e21);
  Semiconductor.IsNType:=fFF.ConfigFile.ReadBool(fFF.Name,'Layer type Schottky',True);
  Eps_i:=fFF.ConfigFile.ReadFloat(fFF.Name,'InsulPerm',4.1);
  Thick_i:=fFF.ConfigFile.ReadFloat(fFF.Name,'InsulDepth',3e-9);
  Semiconductor.Material.ChangeMaterial(TMaterialName(
   fFF.ConfigFile.ReadInteger(fFF.Name,'Material Name Schottky',0)));
end;

procedure TDSchottkyFit.WriteToIni;
begin
//  showmessage(floattostr(Area));
  fFF.ConfigFile.WriteFloat(fFF.Name,'Square Schottky',Area);
//  showmessage(floattostr(Semiconductor.Nd));
  fFF.ConfigFile.WriteFloat(fFF.Name,'Concentration Schottky',Semiconductor.Nd);
  fFF.ConfigFile.WriteFloat(fFF.Name,'InsulPerm',Eps_i);
  fFF.ConfigFile.WriteFloat(fFF.Name,'InsulDepth',Thick_i);
  fFF.ConfigFile.WriteBool(fFF.Name,'Layer type Schottky',Semiconductor.IsNType);
  fFF.ConfigFile.WriteInteger(fFF.Name,'Material Name Schottky',
          ord(Semiconductor.Material.MaterialName));

end;

{ TDSchottkyAreaFrame }

constructor TDAreaFrame.Create(AOwner: TComponent;
                           Schottky: TDiodMaterial);
begin
 inherited Create(AOwner,'Area',Schottky.Area);
 fLabel.Font.Color:=clPurple;

 fDiod:=Schottky;
 fOrientation:=oCol;

// DPShowCreate('Area',fDiod.Area);
end;

procedure TDAreaFrame.DateUpdate;
begin
 fDiod.Area:=fDPShow.Data;
end;


//procedure TDAreaFrame.DPShowCreate;
//begin
// fDPShow:=TDoubleParameterShow.Create(fSText,fLabel,
//           'Area',fDiod.Area);
// fDPShow.Limits.SetLimits(0);
//end;


{ TTDSchottkyGroupBox }

constructor TDiodGroupBox.Create(AOwner: TComponent);
begin
 inherited Create;
 GB:=TGroupBox.Create(AOwner);
end;

procedure TDiodGroupBox.DateUpdate;
begin
  fLayerFrame.DateUpdate;
  fAreaFrame.DateUpdate;
end;

destructor TDiodGroupBox.Destroy;
begin
  fLayerFrame.Free;
  fAreaFrame.Free;
  inherited;
end;

procedure TDiodGroupBox.SizeDetermination(Form: TForm);
begin
  fLayerFrame.SizeDetermination(Form);
  fAreaFrame.SizeDetermination(Form);
  fAreaFrame.Frame.Top:=30;
  fAreaFrame.Frame.Left:=MarginLeft;
  RelativeLocation(fAreaFrame.Frame,fLayerFrame.Frame);
  GB.Width:=fLayerFrame.Frame.Left+fLayerFrame.Frame.Width+MarginLeft;
  GB.Height:=max(fLayerFrame.Frame.Top+fLayerFrame.Frame.Height,
                 fAreaFrame.Frame.Top+fAreaFrame.Frame.Height)
                +MarginTop;
end;

{ TD_PNFit }

constructor TD_PNFit.Create(FF: TFitFunctionNew);
begin
 inherited Create;
 Self.LayerN.Material:=TMaterial.Create(TMaterialName(0));
 Self.LayerP.Material:=TMaterial.Create(TMaterialName(0));
 fFF:=FF;
end;

destructor TD_PNFit.Destroy;
begin
  Self.LayerN.Material.Free;
  Self.LayerP.Material.Free;
  inherited;
end;

procedure TD_PNFit.ReadFromIni;
begin
  Area:=fFF.ConfigFile.ReadFloat(fFF.Name,'Square pn-Diod',3.14e-6);
  LayerP.Nd:=fFF.ConfigFile.ReadFloat(fFF.Name,'p-layer Concentration',5e21);
  LayerN.Nd:=fFF.ConfigFile.ReadFloat(fFF.Name,'n-layer Concentration',5e21);
//  LayerP.IsNType:=fFF.ConfigFile.ReadBool(fFF.Name,'p-layer type',True);
//  LayerN.IsNType:=fFF.ConfigFile.ReadBool(fFF.Name,'n-layer type',True);
  LayerP.Material.ChangeMaterial(TMaterialName(
   fFF.ConfigFile.ReadInteger(fFF.Name,'p-layer Material Name',0)));
  LayerN.Material.ChangeMaterial(TMaterialName(
   fFF.ConfigFile.ReadInteger(fFF.Name,'n-layer Material Name',0)));
end;

procedure TD_PNFit.WriteToIni;
begin
  fFF.ConfigFile.WriteFloat(fFF.Name,'Square pn-Diod',Area);
  fFF.ConfigFile.WriteFloat(fFF.Name,'p-layer Concentration',LayerP.Nd);
  fFF.ConfigFile.WriteFloat(fFF.Name,'n-layer Concentration',LayerN.Nd);
//  fFF.ConfigFile.WriteBool(fFF.Name,'p-layer type',LayerP.IsNType);
//  fFF.ConfigFile.WriteBool(fFF.Name,'n-layer type',LayerN.IsNType);
  fFF.ConfigFile.WriteInteger(fFF.Name,'p-layer Material Name',
          ord(LayerP.Material.MaterialName));
  fFF.ConfigFile.WriteInteger(fFF.Name,'n-layer Material Name',
          ord(LayerN.Material.MaterialName));
end;

{ TDSchottkyGroupBox }

constructor TDSchottkyGroupBox.Create(AOwner: TComponent;
                              Schottky: TDSchottkyFit);
begin
 Inherited Create(AOwner);
 GB.Caption:='Schottky diod';
 fLayerFrame:=TMaterialLayerFrame.Create(GB,Schottky.Semiconductor);
 fAreaFrame:=TDAreaFrame.Create(GB,Schottky);
 fLayerFrame.Frame.Parent:=GB;
 fAreaFrame.Frame.Parent:=GB;
end;

{ TD_PNGroupBox }

constructor TD_PNGroupBox.Create(AOwner: TComponent; D_PN: TD_PNFit);
begin
 Inherited Create(AOwner);
 GB.Caption:='p-n diod';
 fLayerFrame:=TMaterialLayerFrame.Create(GB,D_PN.LayerN);
 fSecondLayerFrame:=TMaterialLayerFrame.Create(GB,D_PN.LayerP);
 fAreaFrame:=TDAreaFrame.Create(GB,D_PN);
 fLayerFrame.Frame.Parent:=GB;
 fSecondLayerFrame.Frame.Parent:=GB;
 fAreaFrame.Frame.Parent:=GB;

 fLayerFrame.RG.Tag:=fLayerFrame.RG.ItemIndex;
 fLayerFrame.RG.OnClick:=RGOnClick;
 fSecondLayerFrame.RG.Tag:=fSecondLayerFrame.RG.ItemIndex;
 fSecondLayerFrame.RG.OnClick:=RGOnClick;

end;

procedure TD_PNGroupBox.DateUpdate;
begin
  inherited;
  fSecondLayerFrame.DateUpdate;
end;

destructor TD_PNGroupBox.Destroy;
begin
  fSecondLayerFrame.Free;
  inherited;
end;

procedure TD_PNGroupBox.RGOnClick(Sender: TObject);
begin
 (Sender as TRadioGroup).ItemIndex:=(Sender as TRadioGroup).Tag;
end;

procedure TD_PNGroupBox.SizeDetermination(Form: TForm);
begin
 inherited SizeDetermination(Form);

  fSecondLayerFrame.SizeDetermination(Form);
  RelativeLocation(fLayerFrame.Frame,fSecondLayerFrame.Frame,oCol);
  fAreaFrame.Frame.Top:=fLayerFrame.Frame.Top+fLayerFrame.Frame.Height
                        +Round((MarginFrame-fAreaFrame.Frame.Height)/2);
  GB.Height:=fSecondLayerFrame.Frame.Top+fLayerFrame.Frame.Height
                +MarginTop;
end;

{ TDecDiodParameter }

procedure TDecDiodParameter.FormClear;
begin
 fGroupBox.GB.Parent:=nil;
 fGroupBox.Free;
 fFFParameter.FormClear;
end;

procedure TDecDiodParameter.FormPrepare(Form: TForm);
begin
  fFFParameter.FormPrepare(Form);
  CreateGroupBox(Form);
  fGroupBox.GB.Parent:=Form;
  fGroupBox.SizeDetermination(Form);
  AddControlToForm(fGroupBox.GB,Form);
end;

function TDecDiodParameter.IsReadyToFitDetermination: boolean;
begin
  Result:=fFFParameter.IsReadyToFitDetermination;
end;

procedure TDecDiodParameter.UpDate;
begin
  fFFParameter.UpDate;
  fGroupBox.DateUpdate;
end;

{ TDecDSchottkyParameter }

constructor TDecDSchottkyParameter.Create(Schottky: TDSchottkyFit;
  FFParam: TFFParameter);
begin
 fFFParameter:=FFParam;
 fSchottky:=Schottky;
end;



procedure TDecDSchottkyParameter.CreateGroupBox(Form: TForm);
begin
  fGroupBox := TDSchottkyGroupBox.Create(Form,fSchottky);
end;


procedure TDecDSchottkyParameter.ReadFromIniFile;
begin
 fFFParameter.ReadFromIniFile;
 fSchottky.ReadFromIni;
end;

procedure TDecDSchottkyParameter.WriteToIniFile;
begin
 fFFParameter.WriteToIniFile;
 fSchottky.WriteToIni;
end;

{ TDecD_PNParameter }

constructor TDecD_PNParameter.Create(D_PN: TD_PNFit; FFParam: TFFParameter);
begin
 fFFParameter:=FFParam;
 fD_PN:=D_PN;
end;

procedure TDecD_PNParameter.CreateGroupBox(Form: TForm);
begin
   fGroupBox := TD_PNGroupBox.Create(Form,fD_PN);
end;

procedure TDecD_PNParameter.ReadFromIniFile;
begin
 fFFParameter.ReadFromIniFile;
 fD_PN.ReadFromIni;
end;

procedure TDecD_PNParameter.WriteToIniFile;
begin
 fFFParameter.WriteToIniFile;
 fD_PN.WriteToIni;
end;

end.

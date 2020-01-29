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
    Frame:TFrame;
    constructor Create(AOwner: TComponent;MaterialLayer:TMaterialLayer);
    destructor Destroy;override;
    procedure SizeDetermination (Form: TForm);override;
    procedure DateUpdate;override;
 end;

  TDSchottkyAreaFrame=class(TNumberFrame)
   private
    fSchottky:TDSchottkyFit;
    fAreaShow:TDoubleParameterShow;
   public
    Frame:TFrame;
//    constructor Create(AOwner: TComponent;Schottky:TDSchottkyFit);//override;
//    destructor Destroy;override;
//    procedure SizeDetermination (Form: TForm);override;
//    procedure DateUpdate;override;
  end;

 TTDSchottkyGroupBox=class
  private
   fSchottky:TDSchottkyFit;
   fMLayerFrame:TMaterialLayerFrame;
   fMaterialFrame:TMaterialFrame;
   fAreaFrame:TDSchottkyAreaFrame;
  public
   GB:TGroupBox;
//   constructor Create(AOwner: TComponent;MaterialLayer:TMaterialLayer);//override;
//   destructor Destroy;override;
//   procedure SizeDetermination (Form: TForm);override;
//   procedure DateUpdate;override;
 end;

implementation

uses
  Graphics, Math;

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

 fCBSelect.Width:=Form.Canvas.TextWidth(tempstr)+15;
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

 fLabel.Font.Color:=clNavy;
 fDopingShow:=TDoubleParameterShow.Create(fSText,fLabel,
           'Carrier concentration, m^(-3):',fMaterialLayer.Nd);
 fDopingShow.Limits.SetLimits(0);

 RG:=TRadioGroup.Create(Frame);
 RG.Parent:=Frame;
 RG.Font.Style:=[fsBold];
 RG.Caption:='type';
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
 inherited;
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
  inherited Destroy;
end;

procedure TMaterialLayerFrame.SizeDetermination(Form: TForm);
begin
 inherited SizeDetermination(Form);
 fLabel.Top:=RG.Top;
 fLabel.Left:=RG.Left+RG.Width+2*MarginFrame;
 fSText.Top:=RG.Top;
 fSText.Left:=fLabel.Left+fLabel.Width+2*MarginFrame;

 MaterialFrame.SizeDetermination(Form);
 MaterialFrame.Frame.Top:=0;
 MaterialFrame.Frame.Left:=fSText.Left+fSText.Width+2*MarginFrame;

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
  fFF.ConfigFile.WriteFloat(fFF.Name,'Square Schottky',Area);
  fFF.ConfigFile.WriteFloat(fFF.Name,'Concentration Schottky',Semiconductor.Nd);
  fFF.ConfigFile.WriteFloat(fFF.Name,'InsulPerm',Eps_i);
  fFF.ConfigFile.WriteFloat(fFF.Name,'InsulDepth',Thick_i);
  fFF.ConfigFile.WriteBool(fFF.Name,'Layer type Schottky',Semiconductor.IsNType);
  fFF.ConfigFile.WriteInteger(fFF.Name,'Material Name Schottky',
          ord(Semiconductor.Material.MaterialName));

end;

end.

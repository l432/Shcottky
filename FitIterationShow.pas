unit FitIterationShow;

interface

uses
  OApproxNew, ExtCtrls, FitVariableShow, StdCtrls, FitIteration, Forms, 
  Classes, OlegFunction, FitSimple, FitGradient, System.UITypes;

type

TConstParDetWindowShow=class(TWindowShow)
  private
   fImg:TImage;
   fFrames:array of TSimpleDoubleFrame;
   CB:TComBobox;
   fConstParDet:TConstParDetermination;
   fLabelName,fLabelIndex:TLabel;
  protected
   procedure UpDate;override;
   procedure AdditionalFormClear;override;
   procedure AdditionalFormPrepare;override;
  public
   constructor Create(ConstParDet:TConstParDetermination);
 end;

 TFFParamIterationFrame=class
  private
    procedure RButtonsInitCheck;virtual;abstract;
    procedure GBoxModeResize(Form: TForm);
    procedure FrameResize;
    procedure ElementsRelativeLocation;virtual;
    procedure ElementsResize(Form: TForm);virtual;
    procedure GBoxModeCreate;
    procedure LabelNameCreate;
    procedure PanelCreate;
    procedure ButtonCreate;
    procedure ElementsCreate;virtual;
   protected
    fLabelName:TLabel;
    fPanel: TPanel;
    fGBoxMode: TGroupBox;
    fRButtons: array of TRadioButton;
    fRBNames:array of string;
    fButton: TButton;
    fPIteration:TFFParamIteration;
    procedure RBNamesDefine;virtual;abstract;
    procedure RButtonsCreate;
    procedure RBClick(Sender: TObject);virtual;
    procedure ButClick(Sender: TObject);
   public
    Frame:TFrame;
    constructor Create(AOwner: TComponent;
                PIteration:TFFParamIteration);
    destructor Destroy;override;
    procedure SizeDetermination (Form: TForm);
    procedure DateUpdate;virtual;abstract;
 end;


 TFFParamGradientFrame=class(TFFParamIterationFrame)
  private
    procedure RButtonsInitCheck;override;
   protected
    procedure RBNamesDefine;override;
   public
    procedure DateUpdate;override;
 end;

TFFParamHeuristicFrame=class(TFFParamIterationFrame)
  private
    fGBoxLimit: TGroupBox;
    fLEmin: TLabeledEdit;
    fLEmax: TLabeledEdit;
    procedure RButtonsInitCheck;override;
    procedure minInKeyPress(Sender: TObject; var Key: Char);
    procedure ElementsRelativeLocation;override;
    procedure ElementsResize(Form: TForm);override;
    procedure ElementsCreate;override;
    procedure GBoxLimitCreate;
    procedure LEsCreate;
  protected
    procedure RBNamesDefine;override;
    procedure RBClick(Sender: TObject);override;
  public
    procedure DateUpdate;override;
 end;

 TParamIterationArrayFrame=class
  private
   fSubFrames:array of TFFParamIterationFrame;
   procedure SubFramesResize(Form: TForm);
   function ColumnNumberDetermination:byte;
   procedure SubFramesLocate;
   procedure FrameLocate(Form: TForm);
  public
   Frame:TFrame;
   procedure DateUpdate;
   constructor Create(AOwner: TComponent;PIteration:TDParamsIteration);
   destructor Destroy;override;
   procedure SizeAndLocationDetermination(Form: TForm);
end;

  TDParamsIterationGroupBox=class
  private
   fPIArrayFrame:TParamIterationArrayFrame;
   fSIFrame:TSimpleIntFrame;
   fSDFrame:TSimpleDoubleFrame;
   fPIteration:TDParamsIteration;
  public
   GB:TGroupBox;
   constructor Create(PIteration:TDParamsIteration);
   destructor Destroy;override;
   procedure SizeDetermination (Form: TForm);virtual;abstract;
   procedure DateUpdate;virtual;
 end;

  TDParamsGradientGroupBox=class(TDParamsIterationGroupBox)
  public
   procedure SizeDetermination (Form: TForm);override;
 end;

  TDParamsHeuristicGroupBox=class(TDParamsIterationGroupBox)
  private
   fEvTypeFrame:TSimpleStringFrame;
   fSLEvType:TStringList;
   fFitTypeFrame:TSimpleStringFrame;
   fSLFitType:TStringList;
   fRegTypeFrame:TSimpleStringFrame;
   fSLRegType:TStringList;
   fCB:TCheckBox;
   fCBFitEvaluationNumberUsed:TCheckBox;
   procedure CBFitEvaluationNumberUsedClick(Sender: TObject);
  public
   constructor Create(PIteration:TDParamsHeuristic);
   destructor Destroy;override;
   procedure SizeDetermination (Form: TForm);override;
   procedure DateUpdate;override;
 end;


  TDecParamsIteration=class(TFFParameter)
   private
    fGB:TDParamsIterationGroupBox;
    fPIteration:TDParamsIteration;
    fFFParameter:TFFParameter;
   public
    constructor Create(PIteration:TDParamsIteration;
                       FFParam:TFFParameter);
    procedure FormPrepare(Form:TForm);override;
    procedure UpDate;override;
    procedure FormClear;override;
    Procedure WriteToIniFile;override;
    Procedure ReadFromIniFile;override;
    function IsReadyToFitDetermination:boolean;override;
 end;

TWindowIterationShow=class(TWindowIterationAbstract)
  private
   fButton: TButton;
   procedure ButClick(Sender: TObject);
   procedure LabelAction(Lab:TLabel;Srt:string);
  protected
   fFF:TFFIteration;
   fLabels:array of TLabel;
  public
   constructor Create(FFSimple:TFFIteration);
   procedure Show;override;
   procedure UpDate;override;
   procedure Hide;override;
 end;

implementation

uses
  Windows, OApproxShow, Math, Graphics, Controls, OlegShowTypes, Dialogs,
  SysUtils, OlegMath, Messages;


{ TConstParDetWindowShow }

procedure TConstParDetWindowShow.AdditionalFormClear;
  var i:integer;
begin
  inherited;
  for I := 0 to High(fFrames) do
    begin
      fFrames[i].Frame.Parent:=nil;
      fFrames[i].Free;
    end;
end;

procedure TConstParDetWindowShow.AdditionalFormPrepare;
 var i:integer;
begin
  inherited;
  fForm.Caption:=fConstParDet.Name+' constant value';
  fForm.Font.Name:='Tahoma';
  fForm.Font.Size:=10;
  fForm.Color:=RGB(254,226,218);

  fLabelName:=TLabel.Create(fForm);
  fLabelName.Parent:=fForm;
  fLabelName.ParentFont:=True;
  fLabelName.Caption:=fConstParDet.Name;
  ResizeElement(fLabelName,fForm.Canvas);
  fLabelName.Top:=MarginTop;
  fLabelName.Left:=MarginLeft;

  fImg:=TImage.Create(fForm);
  fImg.Parent:=fForm;
  fImg.Height:=40;
  fImg.Stretch:=True;
  fImg.Picture.Bitmap.LoadFromResourceName(hInstance, 'ConstFig');
  fImg.Width:=round(fImg.Height*fImg.Picture.Width/fImg.Picture.Height);

  RelativeLocation(fLabelName,fImg,oRow);
  fForm.Height:=fImg.Top+fImg.Height;
  fForm.Width:=fImg.Left+fImg.Width+MarginLeft;

  fLabelIndex:=TLabel.Create(fForm);
  fLabelIndex.Caption:='t =';
  ResizeElement(fLabelIndex,fForm.Canvas);
  AddControlToForm(fLabelIndex,fForm);

  CB:=TComboBox.Create(fForm);
  CB.Parent:=fForm;
  CB.Width:=150;
  CB.Items.Clear;
  CB.Sorted:=False;
  CB.Style:=csDropDownList;
  CB.Items.Add('none');

  for I := 0 to fConstParDet.fVarArray.HighIndex do
   CB.Items.Add(' '+fConstParDet.fVarArray.Parametr[i].Name+' ');
  for I := 0 to fConstParDet.fVarArray.HighIndex do
   CB.Items.Add(' '+fConstParDet.fVarArray.Parametr[i].Name+', inverse');

  if fConstParDet.fIndex=-1
    then CB.ItemIndex:=0
    else  if fConstParDet.fIsNotReverse
             then CB.ItemIndex:=fConstParDet.fIndex+1
             else CB.ItemIndex:=fConstParDet.fIndex
                     +fConstParDet.fVarArray.HighIndex+2;
  RelativeLocation(fLabelIndex,CB,oRow);
  fForm.Height:=CB.Top+CB.Height;
  fForm.Width:=max(fForm.Width,
                   CB.Left+CB.Width+MarginLeft);

 for I := 0 to High(fFrames) do
  begin
  fFrames[i]:=TSimpleDoubleFrame.Create(fForm,
         fConstParDet.CoefNames[i]+'=',fConstParDet.Coefficients[i]);
  fFrames[i].Lab.Font.Size:=10;

  fFrames[i].SizeDetermination(fForm);
  end;

 AddControlToForm(fFrames[0].Frame,fForm);
 for I := 1 to High(fFrames) do
  begin
    fFrames[i].Frame.Parent:=fForm;
    RelativeLocation(fFrames[i-1].Frame,fFrames[i].Frame,oRow,15);
  end;

end;

constructor TConstParDetWindowShow.Create(ConstParDet: TConstParDetermination);
begin
 inherited Create;
 fConstParDet:=ConstParDet;
 SetLength(fFrames,High(fConstParDet.Coefficients)+1);
end;

procedure TConstParDetWindowShow.UpDate;
 var i:integer;
begin
 for I := 0 to High(fFrames) do
   fConstParDet.Coefficients[i]:=(fFrames[i].PShow as TDoubleParameterShow).Data;

 fConstParDet.fIsNotReverse:=CB.ItemIndex<fConstParDet.fVarArray.HighIndex+2;
 fConstParDet.fIndex:=CB.ItemIndex-1;
 if (fConstParDet.fIndex<>-1)
   and(fConstParDet.fIndex>fConstParDet.fVarArray.HighIndex)
      then fConstParDet.fIndex:=fConstParDet.fIndex-fConstParDet.fVarArray.HighIndex-1;

end;

{ TTFFParamIterationFrame }

procedure TFFParamGradientFrame.DateUpdate;
begin
 fPIteration.IsConstant:=fRButtons[High(fRButtons)].Checked;
 fPIteration.UpDate;
end;

procedure TFFParamGradientFrame.RButtonsInitCheck;
begin
  fRButtons[0].Checked := not (fPIteration.IsConstant);
  fRButtons[High(fRButtons)].Checked := fPIteration.IsConstant;
end;

procedure TFFParamGradientFrame.RBNamesDefine;
begin
 SetLength(fRBNames,2);
 fRBNames[0]:='Variable';
 fRBNames[1]:='Constant';
end;

{ TParamIterationArrayFrame }

function TParamIterationArrayFrame.ColumnNumberDetermination: byte;
begin
 case High(fSubFrames) of
  -1..1:Result:=1;
   2..5:Result:=2;
   6..8:Result:=3;
  else  Result:=4;
 end;
end;

constructor TParamIterationArrayFrame.Create(AOwner: TComponent;
                                 PIteration: TDParamsIteration);
 var i:integer;
begin
  inherited Create;
  Frame:=TFrame.Create(AOwner);

  SetLength(fSubFrames,PIteration.MainParamHighIndex+1);
  if (PIteration is TDParamsGradient) then
    for I := 0 to High(fSubFrames) do
       begin
         fSubFrames[i]:=TFFParamGradientFrame.Create(Frame,
                         (PIteration.fParams[i] as TFFParamGradient));
         fSubFrames[i].Frame.Parent:=Frame;
       end;
  if (PIteration is TDParamsHeuristic) then
    for I := 0 to High(fSubFrames) do
       begin
         fSubFrames[i]:=TFFParamHeuristicFrame.Create(Frame,
                         (PIteration.fParams[i] as TFFParamHeuristic));
         fSubFrames[i].Frame.Parent:=Frame;
       end;
end;

procedure TParamIterationArrayFrame.DateUpdate;
  var i:integer;
begin
  for I := 0 to High(fSubFrames) do fSubFrames[i].DateUpdate;
end;

destructor TParamIterationArrayFrame.Destroy;
 var i:integer;
begin
  for I := 0 to High(fSubFrames) do fSubFrames[i].Free;
  Frame.Free;
  inherited;
end;

procedure TParamIterationArrayFrame.FrameLocate(Form: TForm);
begin
  Frame.Top := Form.Height + MarginTop;
  Frame.Left := MarginLeft;
end;

procedure TParamIterationArrayFrame.SizeAndLocationDetermination(Form: TForm);
begin
 SubFramesResize(Form);
 SubFramesLocate;
 FrameLocate(Form);
end;

procedure TParamIterationArrayFrame.SubFramesLocate;
var
  i: Integer;
  ColNumber: Byte;
begin
  ColNumber := ColumnNumberDetermination;
  for I := 0 to High(fSubFrames) do
  begin
    fSubFrames[i].Frame.Top := (i div ColNumber) * fSubFrames[0].Frame.Height;
    fSubFrames[i].Frame.Left := (i mod ColNumber) * fSubFrames[0].Frame.Width;
  end;
  if High(fSubFrames)<0 then
        begin
          Frame.Height :=0;
          Frame.Width := 0;
        end             else
        begin
  Frame.Height := fSubFrames[High(fSubFrames)].Frame.Top + fSubFrames[0].Frame.Height;
  Frame.Width := ColNumber * fSubFrames[0].Frame.Width;
        end;
end;

procedure TParamIterationArrayFrame.SubFramesResize(Form: TForm);
var  i: Integer;
  MaxHeight: Integer;
  MaxWidth: Integer;
begin
  for I := 0 to High(fSubFrames) do fSubFrames[i].SizeDetermination(Form);
  if High(fSubFrames)<1 then Exit;

  MaxWidth := 0;
  MaxHeight := 0;
  for I := 0 to High(fSubFrames) do
  begin
    MaxWidth := max(MaxWidth, fSubFrames[i].Frame.Width);
    MaxHeight := max(MaxHeight, fSubFrames[i].Frame.Height);
  end;
  for I := 0 to High(fSubFrames) do
  begin
    fSubFrames[i].Frame.Width := MaxWidth;
    fSubFrames[i].Frame.Height := MaxHeight;
    fSubFrames[i].fPanel.Width := MaxWidth;
    fSubFrames[i].fPanel.Height := MaxHeight;
  end;
end;

{ TDParamsIterationGroupBox }

procedure TDParamsGradientGroupBox.SizeDetermination(Form: TForm);
begin
 fSIFrame.SizeDetermination(Form);
 fSDFrame.SizeDetermination(Form);
 fPIArrayFrame.SizeAndLocationDetermination(Form);

 fSIFrame.Frame.Top:=MarginTop;
 fSIFrame.Frame.Left:=3*MarginFrame;
 RelativeLocation(fSIFrame.Frame,fSDFrame.Frame,oRow);

 fPIArrayFrame.Frame.Top:=fSIFrame.Frame.Top+fSIFrame.Frame.Height+Marginbetween;
 fPIArrayFrame.Frame.Left:=fSIFrame.Frame.Left;

 GB.Width:=max(fSDFrame.Frame.Left+fSDFrame.Frame.Width,
               fPIArrayFrame.Frame.Left+fPIArrayFrame.Frame.Width)+3*MarginFrame;
 GB.Height:=fPIArrayFrame.Frame.Top+fPIArrayFrame.Frame.Height+2*MarginFrame;
end;

{ TDParamsIterationGroupBox }

constructor TDParamsIterationGroupBox.Create(PIteration: TDParamsIteration);
begin
  inherited Create;
  GB:=TGroupBox.Create(nil);
  if (PIteration is TDParamsGradient)
   then GB.Caption:='Coordinate gradient descent parameters'
   else GB.Caption:='Meta heuristic fitting parameters';

  fPIteration:=PIteration;

  fPIArrayFrame:=TParamIterationArrayFrame.Create(GB,PIteration);
  fPIArrayFrame.Frame.Parent:=GB;
  fSIFrame:=TSimpleIntFrame.Create(GB,'Number of iterations: ',PIteration.Nit);
  fSIFrame.PShow.Limits.SetLimits(0);
  fSIFrame.Frame.Parent:=GB;

  if (fPIteration is TDParamsGradient)
   then fSDFrame:=TSimpleDoubleFrame.Create(GB,'Accuracy:',(fPIteration as TDParamsGradient).Accurancy);
  if (fPIteration is TDParamsHeuristic)
   then fSDFrame:=TSimpleDoubleFrame.Create(GB,'Weight value:',(fPIteration as TDParamsHeuristic).RegWeight);
  fSDFrame.PShow.Limits.SetLimits(0,1);
  fSDFrame.Frame.Parent:=GB;

end;

procedure TDParamsIterationGroupBox.DateUpdate;
begin
 fPIArrayFrame.DateUpdate;
 fPIteration.Nit:=(fSIFrame.PShow as TIntegerParameterShow).Data;
  if (fPIteration is TDParamsGradient)
   then (fPIteration as TDParamsGradient).Accurancy:=(fSDFrame.PShow as TDoubleParameterShow).Data;
  if (fPIteration is TDParamsHeuristic)
   then (fPIteration as TDParamsHeuristic).RegWeight:=(fSDFrame.PShow as TDoubleParameterShow).Data;
end;

destructor TDParamsIterationGroupBox.Destroy;
begin
  fSDFrame.Free;
  fSIFrame.Free;
  fPIArrayFrame.Free;
  GB.Free;
  inherited;
end;

{ TDecParamsIteration }

constructor TDecParamsIteration.Create(PIteration:TDParamsIteration;
   FFParam: TFFParameter);
begin
 fFFParameter:=FFParam;
 fPIteration:=PIteration;
end;

procedure TDecParamsIteration.FormClear;
begin
 fGB.GB.Parent:=nil;
 fGB.Free;
 fFFParameter.FormClear;
end;

procedure TDecParamsIteration.FormPrepare(Form: TForm);
begin
  fFFParameter.FormPrepare(Form);
  if (fPIteration is TDParamsGradient) then
    fGB := TDParamsGradientGroupBox.Create(fPIteration);
  if (fPIteration is TDParamsHeuristic) then
    fGB := TDParamsHeuristicGroupBox.Create(fPIteration as TDParamsHeuristic);

  fGB.GB.Parent:=Form;
  fGB.SizeDetermination(Form);
  AddControlToForm(fGB.GB,Form);
  Form.InsertComponent(fGB.GB);
end;

function TDecParamsIteration.IsReadyToFitDetermination: boolean;
begin
 Result:=fFFParameter.IsReadyToFitDetermination
         and fPIteration.IsReadyToFitDetermination;
end;

procedure TDecParamsIteration.ReadFromIniFile;
begin
 fFFParameter.ReadFromIniFile;
 fPIteration.ReadFromIniFile;
end;

procedure TDecParamsIteration.UpDate;
begin
  fFFParameter.UpDate;
  fGB.DateUpdate;
end;

procedure TDecParamsIteration.WriteToIniFile;
begin
 fFFParameter.WriteToIniFile;
 fPIteration.WriteToIniFile;
end;

{ TWindowIterationShow }

procedure TWindowIterationShow.ButClick(Sender: TObject);
begin
 Form.Hide;
end;

constructor TWindowIterationShow.Create(FFSimple: TFFIteration);
begin
 inherited Create;
 fFF:=FFSimple;
end;

procedure TWindowIterationShow.Hide;
begin
 ElementsFromForm(Form);
 Form.Hide;
 Form.Release;
end;

procedure TWindowIterationShow.LabelAction(Lab: TLabel; Srt: string);
begin
  Lab.Caption:=Srt;
  Lab.Left:=MarginLeft;
  ResizeElement(Lab, Form.Canvas);
end;

procedure TWindowIterationShow.Show;
 var i,maxLabelWidth,SampleHeigth:integer;
begin
  Form := TForm.Create(Application);
  Form.Position := poMainFormCenter;
  Form.BorderIcons := [];

  Form.Font.Name:='Tahoma';
  Form.Font.Height:=-round(Screen.PixelsPerInch/6.0);
  Form.Font.Style := [fsBold];
  Form.Caption:=fFF.FittingAgent.Description;
  if fFF.DataToFit.name<>''
     then Form.Caption:=Form.Caption
                     +', '+fFF.DataToFit.name;
  Form.Color := clAqua;

  fButton:= TButton.Create(Form);
  fButton.Parent:=Form;
  fButton.Caption:='Stop';
  fButton.Height:=32;
  fButton.Width:=89;
  fButton.OnClick:=ButClick;

  SetLength(fLabels,2*(fFF.DParamArray.MainParamHighIndex+1)+4);
  for I := 0 to High(fLabels) do
   begin
     fLabels[i]:=TLabel.Create(Form);
     fLabels[i].Parent:=Form;
     fLabels[i].AutoSize:=True;
   end;

  LabelAction(fLabels[High(fLabels)-3],'Total number of iterations');
  LabelAction(fLabels[High(fLabels)-2],'Number of performed iterations');
  SampleHeigth:=round(0.5*fLabels[High(fLabels)-3].Height);

  fLabels[High(fLabels)-3].Top:=SampleHeigth;
  fLabels[High(fLabels)-2].Top:=fLabels[High(fLabels)-3].Top+3*SampleHeigth;

  fLabels[High(fLabels)-1].Caption:=IntToStr((fFF.DParamArray as TDParamsIteration).Nit);
  fLabels[High(fLabels)-1].Left:=max(fLabels[High(fLabels)-3].Width,
                                     fLabels[High(fLabels)-2].Width)
                                 +fLabels[High(fLabels)-3].Left
                                 +Marginbetween;
  fLabels[High(fLabels)].Left:=fLabels[High(fLabels)-1].Left;
  fLabels[High(fLabels)-1].Top:=fLabels[High(fLabels)-3].Top;
  fLabels[High(fLabels)].Top:=fLabels[High(fLabels)-2].Top;

  maxLabelWidth:=0;
  for I := 0 to fFF.DParamArray.MainParamHighIndex do
   begin
    LabelAction(fLabels[i],
       fFF.DParamArray.fParams[i].Description+' = ');
    maxLabelWidth:=max(maxLabelWidth,fLabels[i].Width);
    fLabels[i].Top:=7*SampleHeigth+i*3*SampleHeigth;
   end;

  for I := 0 to fFF.DParamArray.MainParamHighIndex do
   begin
    fLabels[i+fFF.DParamArray.MainParamHighIndex+1].Left:=maxLabelWidth+fLabels[0].Left;
    fLabels[i+fFF.DParamArray.MainParamHighIndex+1].Top:=fLabels[i].Top;
    if fFF.DParamArray.fParams[i].IsConstant then
       begin
       fLabels[i+fFF.DParamArray.MainParamHighIndex+1].Font.Color:=clGreen;
       fLabels[i+fFF.DParamArray.MainParamHighIndex+1].Caption:=floattostrf(fFF.DParamArray.fParams[i].Value,ffExponent,4,2)
       end;
   end;
  UpDate;

  fButton.Top:=fLabels[0].Top;
  fButton.Left:=fLabels[fFF.DParamArray.MainParamHighIndex+1].Left
              +fLabels[fFF.DParamArray.MainParamHighIndex+1].Width
              +30;
  Form.Width:=max(fLabels[High(fLabels)-1].Left+fLabels[High(fLabels)-1].Width,
                  fButton.Left+fButton.Width)
                  +MarginRight;
  Form.Height:=fLabels[fFF.DParamArray.MainParamHighIndex].Top
              +fLabels[fFF.DParamArray.MainParamHighIndex].Height
              +3*MarginTop;

  Form.Show;
end;

procedure TWindowIterationShow.UpDate;
 var i:byte;
     str:string;
begin
   for I := 0 to fFF.DParamArray.MainParamHighIndex do
    if not(fFF.DParamArray.fParams[i].IsConstant) then
     begin
       str:=floattostrf(fFF.DParamArray.fParams[i].Value,ffExponent,4,2);
       if str=fLabels[i+fFF.DParamArray.MainParamHighIndex+1].Caption
         then fLabels[i+fFF.DParamArray.MainParamHighIndex+1].Font.Color:=clBlack
         else
           begin
           fLabels[i+fFF.DParamArray.MainParamHighIndex+1].Font.Color:=clRed;
           fLabels[i+fFF.DParamArray.MainParamHighIndex+1].Caption:=str;
           end;
     end;
//  fLabels[High(fLabels)].Caption:=IntToStr(fFF.FittingAgent.CurrentIteration);
  fLabels[High(fLabels)].Caption:=IntToStr(fFF.FittingAgent.CurrentIterationOrFitFuncEvaluation);
end;

{ TFFParamIterationFrame }

procedure TFFParamIterationFrame.ButClick(Sender: TObject);
 var WindowShow:TConstParDetWindowShow;
begin
 WindowShow:=TConstParDetWindowShow.Create(fPIteration.fCPDeter);
 WindowShow.Show;
end;

constructor TFFParamIterationFrame.Create(AOwner: TComponent;
  PIteration: TFFParamIteration);
begin
 inherited Create;
 fPIteration:=PIteration;
 RBNamesDefine;

 Frame:=TFrame.Create(AOwner);
 ElementsCreate;
 RButtonsInitCheck;
 RBClick(nil);
end;

destructor TFFParamIterationFrame.Destroy;
begin
 ElementsFromForm(fPanel);
 inherited;
end;

procedure TFFParamIterationFrame.ElementsRelativeLocation;
begin
  RelativeLocation(fLabelName, fGBoxMode, oRow);
end;

procedure TFFParamIterationFrame.FrameResize;
begin
  fPanel.Width := fGBoxMode.Left + fGBoxMode.Width + 2 * MarginFrame;
  fPanel.Height := fGBoxMode.Top + fGBoxMode.Height + 2 * MarginFrame;
  Frame.Width := fPanel.Width;
  Frame.Height := fPanel.Height;
end;

procedure TFFParamIterationFrame.GBoxModeResize(Form: TForm);
var
  i: Integer;
begin
  for I := 0 to High(fRButtons) do
  begin
    fRButtons[i].Width := Form.Canvas.TextWidth(fRButtons[i].Caption) + 20;
    fRButtons[i].Top := Marginbetween + i*(fRButtons[0].Height + 2*MarginFrame);
    fRButtons[i].Left := 2 * MarginFrame;
  end;
  fButton.Top:=fRButtons[High(fRButtons)].Top;
  fButton.Left:=fRButtons[High(fRButtons)].Left
                +fRButtons[High(fRButtons)].Width +2*MarginFrame;
  fGBoxMode.Width:=fButton.Left+fButton.Width+2*MarginFrame;
  fGBoxMode.Height:=fRButtons[High(fRButtons)].Top
                    +fRButtons[High(fRButtons)].Height+2*MarginFrame;
end;

procedure TFFParamIterationFrame.RBClick(Sender: TObject);
begin
 fButton.Enabled:=fRButtons[High(fRButtons)].Checked;
end;

procedure TFFParamIterationFrame.RButtonsCreate;
 var i:integer;
begin
 SetLength(fRButtons,High(fRBNames)+1);
 for I := 0 to High(fRButtons) do
  begin
   fRButtons[i]:= TRadioButton.Create(fGBoxMode);
   fRButtons[i].Parent:=fGBoxMode;
   fRButtons[i].Caption:=fRBNames[i];
   fRButtons[i].Alignment:=taRightJustify;
   fRButtons[i].OnClick:=RBClick;
  end;
end;

procedure TFFParamIterationFrame.SizeDetermination(Form: TForm);
begin
  ElementsResize(Form);
  ElementsRelativeLocation;
  FrameResize;
end;

procedure TFFParamIterationFrame.ElementsCreate;
begin
  PanelCreate;
  LabelNameCreate;
  GBoxModeCreate;
  RButtonsCreate;
  ButtonCreate;
end;

procedure TFFParamIterationFrame.ButtonCreate;
begin
  fButton := TButton.Create(Frame);
  fButton.Parent := fGBoxMode;
  fButton.Caption := '?';
  fButton.Height := 20;
  fButton.Width := 20;
  fButton.OnClick := ButClick;
end;

procedure TFFParamIterationFrame.PanelCreate;
begin
  fPanel := TPanel.Create(Frame);
  fPanel.Parent := Frame;
  fPanel.Top := 0;
  fPanel.Left := 0;
  fPanel.BevelWidth := 3;
end;

procedure TFFParamIterationFrame.LabelNameCreate;
begin
  fLabelName := TLabel.Create(Frame);
  fLabelName.AutoSize := True;
  fLabelName.Parent := fPanel;
  fLabelName.WordWrap := False;
  fLabelName.Font.Color := clRed;
  fLabelName.Font.Style := [fsBold];
  fLabelName.Caption := fPIteration.Description;
  fLabelName.Top := 3 * MarginFrame;
  fLabelName.Left := 4 * MarginFrame;
end;

procedure TFFParamIterationFrame.GBoxModeCreate;
begin
  fGBoxMode := TGroupBox.Create(Frame);
  fGBoxMode.Parent := fPanel;
  fGBoxMode.Caption := 'Mode';
end;

procedure TFFParamIterationFrame.ElementsResize(Form: TForm);
begin
  ResizeElement(fLabelName, Form.Canvas);
  GBoxModeResize(Form);
end;

{ TFFParamHeuristicFrame }

procedure TFFParamHeuristicFrame.DateUpdate;
  var i:TVar_RandNew;
      temp:double;
begin
 for I := Low(TVar_RandNew) to High(TVar_RandNew) do
  if fRButtons[ord(i)].Checked
   then
    begin
     (fPIteration as TFFParamHeuristic).Mode:=i;
     Break;
    end;
 try
  temp:=StrToFloat(fLEmin.Text);
  (fPIteration as TFFParamHeuristic).fMinLim:=temp;
 finally
 end;
 try
  temp:=StrToFloat(fLEmax.Text);
  (fPIteration as TFFParamHeuristic).fMaxLim:=temp;
 finally
 end;
 (fPIteration as TFFParamHeuristic).ToCorrectData;
 fPIteration.UpDate;
end;

procedure TFFParamHeuristicFrame.LEsCreate;
begin
  fLEmin := TLabeledEdit.Create(fGBoxLimit);
  fLEmin.Parent := fGBoxLimit;
  fLEmin.LabelPosition := lpLeft;
  fLEmin.EditLabel.Caption := 'min';
  fLEmin.Text := FloatToStrF((fPIteration as TFFParamHeuristic).fMinLim, ffGeneral, 4, 2);
  fLEmin.OnKeyPress := minInKeyPress;
  fLEmax := TLabeledEdit.Create(fGBoxLimit);
  fLEmax.Parent := fGBoxLimit;
  fLEmax.LabelPosition := lpLeft;
  fLEmax.EditLabel.Caption := 'max';
  fLEmax.Text := FloatToStrF((fPIteration as TFFParamHeuristic).fMaxLim, ffGeneral, 4, 2);
  fLEmax.OnKeyPress := minInKeyPress;
end;

procedure TFFParamHeuristicFrame.GBoxLimitCreate;
begin
  fGBoxLimit := TGroupBox.Create(Frame);
  fGBoxLimit.Parent := fPanel;
  fGBoxLimit.Caption := 'Limit values';
end;

procedure TFFParamHeuristicFrame.ElementsCreate;
begin
 inherited;
 GBoxLimitCreate;
 LEsCreate;
end;

procedure TFFParamHeuristicFrame.ElementsRelativeLocation;
begin
  RelativeLocation(fLabelName, fGBoxLimit, oRow, 3);
  RelativeLocation(fGBoxLimit, fGBoxMode, oRow, 2);
end;

procedure TFFParamHeuristicFrame.ElementsResize(Form: TForm);
begin
 inherited;
 ResizeElement(fLabelName, Form.Canvas);
 GBoxModeResize(Form);

 fLEmin.EditLabel.Width:=Form.Canvas.TextWidth(fLEmax.EditLabel.Caption);
 fLEmin.EditLabel.Height:=Form.Canvas.TextHeight(fLEmax.EditLabel.Caption);
 fLEmax.EditLabel.Width:=fLEmin.EditLabel.Width;
 fLEmax.EditLabel.Height:=fLEmin.EditLabel.Height;

 fLEmin.Width:=Form.Canvas.TextWidth('8.888e-88')+5;
 fLEmax.Width:=fLEmin.Width;

 fLEmin.Height:=Form.Canvas.TextHeight('8.888e-88')+5;
 fLEmax.Height:=fLEmin.Height;
 fLEmin.Top:=Marginbetween;
 fLEmin.Left:=10+fLEmin.EditLabel.Width;
 RelativeLocation(fLEmin, fLEmax, oCol, 5);

 fGBoxLimit.Width:=fLEmax.Left+fLEmax.Width+3*MarginFrame;
 fGBoxLimit.Height:=fLEmax.Top+fLEmax.Height+5*MarginFrame;

end;

procedure TFFParamHeuristicFrame.minInKeyPress(Sender: TObject; var Key: Char);
begin
if Key=#13 then
    begin
    PostMessage( Frame.Handle, WM_NEXTDLGCTL, 0, 0);
    Key:=#0;
    end;

//if not(Key in [#8,'0'..'9','+','-','E','e',DecimalSeparator])
{XP Win}
if not(ANSIChar(Key) in [#8,'0'..'9','+','-','E','e', FormatSettings.DecimalSeparator])
 then Key:=#0;
end;

procedure TFFParamHeuristicFrame.RBClick(Sender: TObject);
begin
  inherited;
  fLEmin.Enabled:=not(fRButtons[High(fRButtons)].Checked);
  fLEmax.Enabled:=not(fRButtons[High(fRButtons)].Checked);
end;

procedure TFFParamHeuristicFrame.RBNamesDefine;
 var i:TVar_RandNew;
begin
 SetLength(fRBNames,Length(Var_RandNames));
 for I := Low(TVar_RandNew) to High(TVar_RandNew)
  do fRBNames[ord(i)]:=Var_RandNames[i];
end;

procedure TFFParamHeuristicFrame.RButtonsInitCheck;
 var i:TVar_RandNew;
begin
  for I := Low(TVar_RandNew) to High(TVar_RandNew)
   do  fRButtons[ord(i)].Checked := ((fPIteration as TFFParamHeuristic).Mode = TVar_RandNew(i));
end;

{ TDParamsHeuristicGroupBox }

procedure TDParamsHeuristicGroupBox.CBFitEvaluationNumberUsedClick(
  Sender: TObject);
begin
 if fCBFitEvaluationNumberUsed.Checked
   then fSIFrame.Lab.Caption:='Number of FitFuncEval:'
   else fSIFrame.Lab.Caption:='Number of iterations: ';
end;

constructor TDParamsHeuristicGroupBox.Create(PIteration: TDParamsHeuristic);
begin
 inherited Create(PIteration);
 fSIFrame.Orientation:=oCol;

 fSLEvType:=TStringList.Create;
 StringArrayToStringList(EvTypeNames,fSLEvType);
 fEvTypeFrame:=TSimpleStringFrame.Create(GB,fSLEvType,'Method name:');
 fEvTypeFrame.Frame.Parent:=GB;
 fEvTypeFrame.SPShow.Data:=ord((fPIteration as TDParamsHeuristic).EvType);

 fSLFitType:=TStringList.Create;
 StringArrayToStringList(FitTypeNames,fSLFitType);
 fFitTypeFrame:=TSimpleStringFrame.Create(GB,fSLFitType,'Fitness way:');
 fFitTypeFrame.Frame.Parent:=GB;
 fFitTypeFrame.SPShow.Data:=ord((fPIteration as TDParamsHeuristic).FitType);
 fFitTypeFrame.Orientation:=oRow;

 fSLRegType:=TStringList.Create;
 StringArrayToStringList(RegTypeNames,fSLRegType);
 fRegTypeFrame:=TSimpleStringFrame.Create(GB,fSLRegType,'Regularization:');
 fRegTypeFrame.Frame.Parent:=GB;
 fRegTypeFrame.SPShow.Data:=ord((fPIteration as TDParamsHeuristic).RegType);
 fRegTypeFrame.Orientation:=oRow;

  fCB:=TCheckBox.Create(GB);
  fCB.Parent:=GB;
  fCB.Caption:='to use log value';
  fCB.Enabled:=True;
  fCB.Checked:=(fPIteration as TDParamsHeuristic).LogFitness;
  fCB.Alignment:=taRightJustify;
  fCB.Font.Style:=fCB.Font.Style+[fsItalic];

  fCBFitEvaluationNumberUsed:=TCheckBox.Create(GB);
  fCBFitEvaluationNumberUsed.Parent:=GB;
  fCBFitEvaluationNumberUsed.Caption:='use FitnessFunc number';
  fCBFitEvaluationNumberUsed.Enabled:=True;
  fCBFitEvaluationNumberUsed.Checked:=(fPIteration as TDParamsHeuristic).FitEvaluationNumberIsUsed;
  CBFitEvaluationNumberUsedClick(nil);
  fCBFitEvaluationNumberUsed.Alignment:=taRightJustify;
  fCBFitEvaluationNumberUsed.Font.Style:=fCB.Font.Style+[fsItalic];
  fCBFitEvaluationNumberUsed.OnClick:=CBFitEvaluationNumberUsedClick;
  fSIFrame.Lab.WordWrap:=False;
end;

procedure TDParamsHeuristicGroupBox.DateUpdate;
begin
  inherited DateUpdate;
  (fPIteration as TDParamsHeuristic).EvType:=TEvolutionTypeNew(fEvTypeFrame.SPShow.Data);
  (fPIteration as TDParamsHeuristic).FitType:=TFitnessType(fFitTypeFrame.SPShow.Data);
  (fPIteration as TDParamsHeuristic).RegType:=TRegulationType(fRegTypeFrame.SPShow.Data);
  (fPIteration as TDParamsHeuristic).LogFitness:=fCB.Checked;
  (fPIteration as TDParamsHeuristic).FitEvaluationNumberIsUsed:=fCBFitEvaluationNumberUsed.Checked;
end;

destructor TDParamsHeuristicGroupBox.Destroy;
begin
  fCBFitEvaluationNumberUsed.Parent:=nil;
  fCBFitEvaluationNumberUsed.Free;
  fCB.Parent:=nil;
  fCB.Free;
  fFitTypeFrame.Free;
  fSLFitType.Free;
  fRegTypeFrame.Free;
  fSLRegType.Free;
  fEvTypeFrame.Free;
  fSLEvType.Free;
  inherited;
end;

procedure TDParamsHeuristicGroupBox.SizeDetermination(Form: TForm);
begin
 fSIFrame.SizeDetermination(Form);
 fSDFrame.SizeDetermination(Form);
 fPIArrayFrame.SizeAndLocationDetermination(Form);
 fFitTypeFrame.SizeDetermination(Form);
 fEvTypeFrame.SizeDetermination(Form);
 fRegTypeFrame.SizeDetermination(Form);
 ResizeElement(fCB,Form.Canvas);
 ResizeElement(fCBFitEvaluationNumberUsed,Form.Canvas);

  if fPIArrayFrame.Frame.Height=0 then fSIFrame.Frame.Visible:=false;

 fSIFrame.Frame.Top:=MarginTop;
 fSIFrame.Frame.Left:=2*MarginFrame;
 RelativeLocation(fSIFrame.Frame,fCBFitEvaluationNumberUsed,oCol,-1);

 RelativeLocation(fSIFrame.Frame,fEvTypeFrame.Frame,oRow,8);
 RelativeLocation(fEvTypeFrame.Frame,fFitTypeFrame.Frame,oRow,8);
 fFitTypeFrame.Frame.Top:=fEvTypeFrame.Frame.Top;
 RelativeLocation(fFitTypeFrame.Frame,fCB,oCol);

 RelativeLocation(fFitTypeFrame.Frame,fRegTypeFrame.Frame,oRow,8);
 RelativeLocation(fRegTypeFrame.Frame,fSDFrame.Frame,oCol);

 fPIArrayFrame.Frame.Top:=fSIFrame.Frame.Top+fSIFrame.Frame.Height+Marginbetween;
 fPIArrayFrame.Frame.Left:=fSIFrame.Frame.Left;

 GB.Width:=max(fSDFrame.Frame.Left+fSDFrame.Frame.Width,
               fPIArrayFrame.Frame.Left+fPIArrayFrame.Frame.Width)+3*MarginFrame;
 GB.Height:=fPIArrayFrame.Frame.Top+fPIArrayFrame.Frame.Height+2*MarginFrame;
end;

end.

unit FitIterationShow;

interface

uses
  OApproxNew, ExtCtrls, FitVariableShow, StdCtrls, FitIteration, Forms, 
  Classes, OlegFunction;

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
   protected
    fLabelName:TLabel;
    fPanel: TPanel;
    fGBoxMode: TGroupBox;
    fRButtons: array of TRadioButton;
    fRBNames:array of string;
    fButton: TButton;
    fPIteration:TFFParamIteration;
    procedure RBNamesDefine;virtual;
    procedure RButtonsCreate;
    procedure RBClick(Sender: TObject);
    procedure ButClick(Sender: TObject);
   public
    Frame:TFrame;
    constructor Create(AOwner: TComponent;
                PIteration:TFFParamIteration);
    destructor Destroy;override;
    procedure SizeDetermination (Form: TForm);
    procedure DateUpdate;
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
   procedure SizeDetermination (Form: TForm);virtual;
   procedure DateUpdate;virtual;
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


implementation

uses
  Windows, OApproxShow, Math, Graphics, Controls, OlegShowTypes;


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
//  fLabelName.Width:=fForm.Canvas.TextWidth(fLabelName.Caption);
//  fLabelName.Height:=fForm.Canvas.TextHeight(fLabelName.Caption);
  ResizeLabel(fLabelName,fForm.Canvas);
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
//  fLabelIndex.Width:=fForm.Canvas.TextWidth(fLabelIndex.Caption);
//  fLabelIndex.Height:=fForm.Canvas.TextHeight(fLabelIndex.Caption);
  ResizeLabel(fLabelIndex,fForm.Canvas);
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
         fConstParDet.CoefNames[i]+':',fConstParDet.Coefficients[i]);
  fFrames[i].SizeDetermination(fForm);
  end;

 AddControlToForm(fFrames[0].Frame,fForm);
 for I := 1 to High(fFrames) do
  begin
    fFrames[i].Frame.Parent:=fForm;
    RelativeLocation(fFrames[i-1].Frame,fFrames[i].Frame);
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

procedure TFFParamIterationFrame.ButClick(Sender: TObject);
 var WindowShow:TConstParDetWindowShow;
begin
 WindowShow:=TConstParDetWindowShow.Create(fPIteration.fCPDeter);
 WindowShow.Show;
 WindowShow.Free;
end;

constructor TFFParamIterationFrame.Create(AOwner: TComponent;
                                 PIteration:TFFParamIteration);
begin
 inherited Create;
 fPIteration:=PIteration;
 RBNamesDefine;

 Frame:=TFrame.Create(AOwner);

 fPanel:=TPanel.Create(Frame);
 fPanel.Parent:=Frame;
 fPanel.Top:=0;
 fPanel.Left:=0;
 fPanel.BevelWidth:=3;

 fLabelName:=TLabel.Create(Frame);
 fLabelName.AutoSize:=True;
 fLabelName.Parent:=fPanel;
 fLabelName.WordWrap:=False;
 fLabelName.Font.Color:=clRed;
 fLabelName.Font.Style:=[fsBold];
 fLabelName.Caption:=fPIteration.Description;
 fLabelName.Top:=MarginTop;
 fLabelName.Left:=MarginLeft;

 fGBoxMode:=TGroupBox.Create(Frame);
 fGBoxMode.Parent:=fPanel;
 fGBoxMode.Caption:='Mode';

 RButtonsCreate;
 fRButtons[High(fRButtons)].Checked:=fPIteration.IsConstant;


 fButton:= TButton.Create(Frame);
 fButton.Parent:=fGBoxMode;
 fButton.Caption:='?';
 fButton.Height:=20;
 fButton.Width:=20;
 fButton.OnClick:=ButClick;
 RBClick(nil);

end;

procedure TFFParamIterationFrame.DateUpdate;
begin
 fPIteration.IsConstant:=fRButtons[High(fRButtons)].Checked;
end;

destructor TFFParamIterationFrame.Destroy;
begin
 ElementsFromForm(fPanel);
 inherited;
end;

procedure TFFParamIterationFrame.RBClick(Sender: TObject);
begin
 fButton.Enabled:=fRButtons[High(fRButtons)].Checked;
end;

procedure TFFParamIterationFrame.RBNamesDefine;
begin
 SetLength(fRBNames,2);
 fRBNames[0]:='Variable';
 fRBNames[1]:='Constant';
end;

procedure TFFParamIterationFrame.RButtonsCreate;
 var i:integer;
begin
 SetLength(fRButtons,High(fRBNames));
 for I := 0 to High(fRButtons) do
  begin
   fRButtons[i]:= TRadioButton.Create(Frame);
   fRButtons[i].Parent:=fGBoxMode;
   fRButtons[i].Caption:=fRBNames[i];
   fRButtons[i].Alignment:=taRightJustify;
   fRButtons[i].OnClick:=RBClick;
  end;

end;

procedure TFFParamIterationFrame.SizeDetermination(Form: TForm);
  var i:integer;
begin

  ResizeLabel(fLabelName,Form.Canvas);
  for I := 0 to High(fRButtons) do
    begin
    fRButtons[i].Width:=Form.Canvas.TextWidth(fRButtons[i].Caption)+35;
    fRButtons[i].Left:=MarginFrame;
    fRButtons[i].Top:=2*MarginFrame+i*(fRButtons[0].Height+2*MarginFrame);
    end;

//  for I := 1 to High(fRButtons)
//    do RelativeLocation(fRButtons[i],fRButtons[i-1],oCol);

  fButton.Top:=fRButtons[High(fRButtons)].Top;
  fButton.Left:=fRButtons[High(fRButtons)].Left+2*MarginFrame;

  fGBoxMode.Width:=fButton.Left+fButton.Width+MarginFrame;
  fGBoxMode.Height:=fRButtons[High(fRButtons)].Top
                    +fRButtons[High(fRButtons)].Width+2*MarginFrame;

  RelativeLocation(fLabelName,fGBoxMode,oRow);
  Frame.Width:=fGBoxMode.Left+fGBoxMode.Width+MarginLeft;
  Frame.Height:=fGBoxMode.Top+fGBoxMode.Height+MarginTop;

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
  for I := 0 to High(fSubFrames) do
     begin
       fSubFrames[i]:=TFFParamIterationFrame.Create(Frame,
                       (PIteration.fParams[i] as TFFParamIteration));
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

 Frame.Parent:=Form;
 Form.Height:=max(Frame.Top+Frame.Height,Form.Height);
 Form.Width:=max(Form.Width,Frame.Left+Frame.Width);
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
  Frame.Height := fSubFrames[High(fSubFrames)].Frame.Top + fSubFrames[0].Frame.Height;
  Frame.Width := ColNumber * fSubFrames[0].Frame.Width;
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
  end;
end;

{ TDParamsIterationGroupBox }

constructor TDParamsIterationGroupBox.Create(PIteration: TDParamsIteration);
begin
  inherited Create;
  GB:=TGroupBox.Create(nil);
  GB.Caption:='Coordinate gradient descent parameters';

  fPIteration:=PIteration;
  fPIArrayFrame:=TParamIterationArrayFrame.Create(GB,PIteration);
  fPIArrayFrame.Frame.Parent:=GB;
  fSIFrame:=TSimpleIntFrame.Create(GB,'Number of iterations',PIteration.Nit);
  fSIFrame.PShow.Limits.SetLimits(0);
  fSIFrame.Frame.Parent:=GB;
  fSDFrame:=TSimpleDoubleFrame.Create(GB,'Accuracy',PIteration.Accurancy);
  fSDFrame.PShow.Limits.SetLimits(0);
  fSDFrame.Frame.Parent:=GB;
end;

procedure TDParamsIterationGroupBox.DateUpdate;
begin
 fPIArrayFrame.DateUpdate;
 fPIteration.Accurancy:=(fSDFrame.PShow as TDoubleParameterShow).Data;
 fPIteration.Nit:=(fSIFrame.PShow as TIntegerParameterShow).Data;
end;

destructor TDParamsIterationGroupBox.Destroy;
begin
  fSDFrame.Free;
  fSIFrame.Free;
  fPIArrayFrame.Free;
  GB.Free;
  inherited;
end;

procedure TDParamsIterationGroupBox.SizeDetermination(Form: TForm);
begin
 fSIFrame.SizeDetermination(Form);
 fSDFrame.SizeDetermination(Form);
 fPIArrayFrame.SizeAndLocationDetermination(Form);

 fSIFrame.Frame.Top:=MarginTop;
 fSIFrame.Frame.Left:=MarginLeft;
 RelativeLocation(fSIFrame.Frame,fSDFrame.Frame,oRow);
 fPIArrayFrame.Frame.Top:=fSIFrame.Frame.Top+fSIFrame.Frame.Height+Marginbetween;
 fPIArrayFrame.Frame.Left:=fSIFrame.Frame.Left;

 GB.Width:=max(fSDFrame.Frame.Left+fSDFrame.Frame.Width,
               fPIArrayFrame.Frame.Left+fPIArrayFrame.Frame.Width)+MarginRight;
 GB.Height:=fPIArrayFrame.Frame.Top+fPIArrayFrame.Frame.Height+MarginTop;
end;

{ TDecParamsIteration }

constructor TDecParamsIteration.Create(PIteration: TDParamsIteration;
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
  fGB := TDParamsIterationGroupBox.Create(fPIteration);
  fGB.SizeDetermination(Form);
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

end.

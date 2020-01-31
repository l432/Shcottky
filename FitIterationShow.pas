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

 TTFFParamIterationFrame=class
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
//    procedure SizeDetermination (Form: TForm);virtual;
    procedure DateUpdate;
 end;

implementation

uses
  Windows, OApproxShow, Math, Graphics;


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
  fLabelName.Width:=fForm.Canvas.TextWidth(fLabelName.Caption);
  fLabelName.Height:=fForm.Canvas.TextHeight(fLabelName.Caption);
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
  fLabelIndex.Width:=fForm.Canvas.TextWidth(fLabelIndex.Caption);
  fLabelIndex.Height:=fForm.Canvas.TextHeight(fLabelIndex.Caption);
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
   fConstParDet.Coefficients[i]:=fFrames[i].DPShow.Data;

 fConstParDet.fIsNotReverse:=CB.ItemIndex<fConstParDet.fVarArray.HighIndex+2;
 fConstParDet.fIndex:=CB.ItemIndex-1;
 if (fConstParDet.fIndex<>-1)
   and(fConstParDet.fIndex>fConstParDet.fVarArray.HighIndex)
      then fConstParDet.fIndex:=fConstParDet.fIndex-fConstParDet.fVarArray.HighIndex-1;

end;

{ TTFFParamIterationFrame }

procedure TTFFParamIterationFrame.ButClick(Sender: TObject);
 var WindowShow:TConstParDetWindowShow;
begin
 WindowShow:=TConstParDetWindowShow.Create(fPIteration.fCPDeter);
 WindowShow.Show;
 WindowShow.Free;
end;

constructor TTFFParamIterationFrame.Create(AOwner: TComponent;
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
 fLabelName.Parent:=Frame;
 fLabelName.WordWrap:=False;
 fLabelName.Font.Color:=clRed;
 fLabelName.Font.Style:=[fsBold];
 fLabelName.Caption:=fPIteration.Description;

 fGBoxMode:=TGroupBox.Create(Frame);
 fGBoxMode.Parent:=Frame;
 fGBoxMode.Caption:='Mode';

 RButtonsCreate;
 fRButtons[High(fRButtons)].Checked:=fPIteration.IsConstant;


 fButton:= TButton.Create(Frame);
 fButton.Parent:=fGBoxMode;
 fButton.Caption:='?';
 fButton.OnClick:=ButClick;
 RBClick(nil);

end;

procedure TTFFParamIterationFrame.DateUpdate;
begin
 fPIteration.IsConstant:=fRButtons[High(fRButtons)].Checked;
end;

destructor TTFFParamIterationFrame.Destroy;
begin
 ElementsFromForm(fPanel);
 inherited;
end;

procedure TTFFParamIterationFrame.RBClick(Sender: TObject);
begin
 fButton.Enabled:=fRButtons[High(fRButtons)].Checked;
end;

procedure TTFFParamIterationFrame.RBNamesDefine;
begin
 SetLength(fRBNames,2);
 fRBNames[0]:='Variable';
 fRBNames[1]:='Constant';
end;

procedure TTFFParamIterationFrame.RButtonsCreate;
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

end.

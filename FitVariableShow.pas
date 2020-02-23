unit FitVariableShow;

interface

uses
  Forms, StdCtrls, Classes, OlegShowTypes, FitVariable, OApproxNew, 
  OApproxShow, ExtCtrls, OlegType;

const
      IntFrameName='IntegerFrame';
      DoubleFrameName='DoubleFrame';

type

 TNumberFrame=class
   protected
    fLabel:TLabel;
    fSText:TStaticText;
    fOrientation:TOrientation;
   public
    Frame:TFrame;
    property Lab:TLabel read fLabel;
    property Orientation:TOrientation read fOrientation write fOrientation;
    constructor Create(AOwner: TComponent);//override;
    destructor Destroy;override;
    procedure SizeDetermination (Form: TForm);virtual;
    procedure DateUpdate;virtual;abstract;
 end;

  TSimpleStringFrame=class(TNumberFrame)
   protected
//    fDataVariants: TStringList;
    fSPShow:TStringParameterShow;
   public
    property SPShow:TStringParameterShow read fSPShow;
    constructor Create(AOwner: TComponent;
                       DataVariants: TStringList;
                       const LabelCaption:string='None');
    destructor Destroy;override;
    procedure DateUpdate;override;
 end;


  TSimpleNumberFrame=class(TNumberFrame)
   protected
    fPShow:TLimitedParameterShow;
   public
    property PShow:TLimitedParameterShow read fPShow;
    destructor Destroy;override;
    procedure DateUpdate;override;
 end;


  TSimpleIntFrame=class(TSimpleNumberFrame)
   protected
//    fIPShow:TIntegerParameterShow;
   public
//    property IPShow:TIntegerParameterShow read fIPShow;
    constructor Create(AOwner: TComponent;
                       const LabelCaption:string='None';
                       InitValue:Integer=0);
//    destructor Destroy;override;
//    procedure DateUpdate;override;
 end;

  TSimpleDoubleFrame=class(TSimpleNumberFrame)
   protected
//    fDPShow:TDoubleParameterShow;
   public
//    property DPShow:TDoubleParameterShow read fDPShow;
    constructor Create(AOwner: TComponent;
                       const LabelCaption:string='None';
                       InitValue:double=ErResult);
//    destructor Destroy;override;
//    procedure DateUpdate;override;
 end;

 TIntFrame=class(TNumberFrame)
   private
    fIPShow:TIntegerParameterShow;
    fVarInteger:TVarInteger;
   public
    constructor Create(AOwner: TComponent;VarInteger:TVarInteger);
    destructor Destroy;override;
//    procedure SizeDetermination (Form: TForm);override;
    procedure DateUpdate;override;
 end;



 TDoubleFrame=class(TNumberFrame)
   private
    fDPShow:TDoubleParameterShow;
    fVarDouble:TVarDouble;
    fCheckBox:TCheckBox;
    procedure CBClick(Sender: TObject);
   public
    constructor Create(AOwner: TComponent;VarDouble:TVarDouble);
    destructor Destroy;override;
    procedure SizeDetermination (Form: TForm);override;
    procedure DateUpdate;override;
 end;

 TVarNumberArrayFrame=class//(TFrame)
   private
    fSubFrames:array of TNumberFrame;
    procedure SubFramesResize(Form: TForm);
    function ColumnNumberDetermination:byte;
    procedure SubFramesLocate;
    procedure FrameLocate(Form: TForm);//virtual;
   public
    Frame:TFrame;
    procedure DateUpdate;
    constructor Create(VarNumberArray:TVarNumberArray);
    destructor Destroy;override;
    procedure SizeAndLocationDetermination(Form: TForm);
 end;

  TDecVarNumberArrayParameter=class(TFFParameter)
   private
    fFrame:TVarNumberArrayFrame;
    fVarArray:TVarNumberArray;
    fFFParameter:TFFParameter;
   public
    constructor Create(VarArray:TVarNumberArray;
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
  Graphics, Math, Unit1new, Dialogs, SysUtils, Controls, Windows;


{ TNumberFrame }

constructor TNumberFrame.Create(AOwner: TComponent);
begin
 inherited Create;
 Frame:=TFrame.Create(AOwner);

 fLabel:=TLabel.Create(Frame);
 fLabel.AutoSize:=True;
 fLabel.Parent:=Frame;
 fSText:=TStaticText.Create(Frame);
 fSText.AutoSize:=True;
 fSText.Parent:=Frame;
 fSText.ParentFont:=True;

 fLabel.WordWrap:=False;
 fLabel.ParentFont:=True;
 fLabel.Font.Color:=clMaroon;
 fLabel.Font.Style:=[fsBold];

 fOrientation:=oRow;
end;

destructor TNumberFrame.Destroy;
begin
  fLabel.Parent:=nil;
  fLabel.Free;
  fSText.Parent:=nil;
  fSText.Free;
  Frame.Free;
  inherited;
end;

procedure TNumberFrame.SizeDetermination(Form: TForm);
begin
 fLabel.Width:=Form.Canvas.TextWidth(fLabel.Caption);
 fLabel.Height:=Form.Canvas.TextHeight(fLabel.Caption);
 fSText.Width:=Form.Canvas.TextWidth(fSText.Caption);
 fSText.Height:=Form.Canvas.TextHeight(fSText.Caption);
 fLabel.Top:=MarginFrame;
 fLabel.Left:=MarginFrame;

 RelativeLocation(fLabel,fSText,fOrientation);

 if fOrientation=oCol then
       Frame.Width:=max(fStext.Left+fStext.Width,
                 fLabel.Left+fLabel.Width)+MarginFrame
                      else
      Frame.Width:=fStext.Left+fStext.Width+MarginFrame;
 Frame.Height:=fStext.Top+fStext.Height+MarginFrame;

// if fOneRow then
//  begin
//     fSText.Top:=fLabel.Top;
//     fStext.Left:=fLabel.Left+fLabel.Width+2*MarginFrame;
//  end;
end;

{ TIntFrame }

constructor TIntFrame.Create(AOwner: TComponent; VarInteger: TVarInteger);
begin
 inherited  Create(AOwner);
 fOrientation:=oCol;

 fVarInteger:=VarInteger;
 fIPShow:=TIntegerParameterShow.Create(fSText,fLabel,
           fVarInteger.Description,fVarInteger.Value);
 fIPShow.IsNoOdd:=fVarInteger.IsNoOdd;
 fIPShow.Limits:=fVarInteger.Limits;
end;

destructor TIntFrame.Destroy;
begin
  fVarInteger:=nil;
  fIPShow.Limits:=nil;
  fIPShow.Free;
  inherited;
end;

//procedure TIntFrame.SizeDetermination(Form: TForm);
//begin
// inherited SizeDetermination(Form);
//
//// fSText.Top:=fLabel.Top+fLabel.Height+MarginFrame;
//// fStext.Left:=fLabel.Left+Round((fLabel.Width-fStext.Width)/2);
//// if fStext.Left<fLabel.Left then
////  begin
////   fLabel.Left:=2*fLabel.Left-fStext.Left;
////   fStext.Left:=fStext.Left+abs(fStext.Left)+MarginFrame;
////  end;
//
// Frame.Width:=max(fLabel.Left+fLabel.Width,
//                 fSText.Left+fSText.Width)+MarginFrame;
// Frame.Height:=fSText.Top+fSText.Height+MarginFrame;
//end;

procedure TIntFrame.DateUpdate;
begin
 fVarInteger.Value:=fIPShow.Data;
end;

{ TVarIntArrayFrame }

//function TVarIntArrayFrame.ColumnNumberDetermination: byte;
//begin
// case High(fIntFrames) of
//  -1..1:Result:=1;
//   2..5:Result:=2;
//   6..8:Result:=3;
//  else  Result:=4;
// end;
//end;

//constructor TVarIntArrayFrame.Create(VarIntArray: TVarIntArray);
// var i:integer;
//begin
// inherited Create;
//// Frame:=TFrame.Create(nil);
// Frame.Name:='IntPar';
//
// SetLength(fSubFrames,VarIntArray.HighIndex+1);
//
// for I := 0 to VarIntArray.HighIndex do
//   begin
//     fSubFrames[i]:=TIntFrame.Create(Frame,(VarIntArray.Parametr[i] as TVarInteger));
//     fSubFrames[i].Frame.Parent:=Frame;
//   end;
//end;

//procedure TVarIntArrayFrame.DateUpdate;
//  var i:integer;
//begin
//  for I := 0 to High(fIntFrames) do fIntFrames[i].DateUpdate;
//end;

//destructor TVarIntArrayFrame.Destroy;
//  var i:integer;
//begin
//  for I := 0 to High(fIntFrames) do fIntFrames[i].Free;
//  Frame.Free;
//  inherited;
//end;

//procedure TVarIntArrayFrame.SizeAndLocationDetermination(Form: TForm);
//begin
//
// SubFramesResize(Form);
// SubFramesLocate;
// FrameLocate(Form);
//
// Frame.Parent:=Form;
// Form.Height:=max(Frame.Top+Frame.Height,Form.Height);
// Form.Width:=max(Form.Width,Frame.Left+Frame.Width);
//end;

//procedure TVarIntArrayFrame.FrameLocate(Form: TForm);
//var
//  i: Integer;
//begin
//  Frame.Top := Form.Height + MarginTop;
//  Frame.Left := MarginLeft;
//  try
//    for i := Form.ComponentCount - 1 downto 0 do
//      if (Form.Components[i].Name = 'Bool')
//         and (Form.Components[i] is TCheckBox)
//         and (((Form.Components[i] as TCheckBox).Left
//               + (Form.Components[i] as TCheckBox).Width) < (Form.Width / 2)) then
//      begin
//        Frame.Left := ((Form.Components[i] as TCheckBox).Left + (Form.Components[i] as TCheckBox).Width) + MarginBetween;
//        Frame.Top := (Form.Components[i] as TCheckBox).Top;
//        Exit;
//      end;
//  except
//  end;
//end;

//procedure TVarIntArrayFrame.SubFramesLocate;
//var
//  i: Integer;
//  ColNumber: Byte;
//begin
//  ColNumber := ColumnNumberDetermination;
//  for I := 0 to High(fIntFrames) do
//  begin
//    fIntFrames[i].Frame.Top := (i div ColNumber) * fIntFrames[0].Frame.Height;
//    fIntFrames[i].Frame.Left := (i mod ColNumber) * fIntFrames[0].Frame.Width;
//  end;
//  Frame.Height := fIntFrames[High(fIntFrames)].Frame.Top + fIntFrames[0].Frame.Height;
//  Frame.Width := ColNumber * fIntFrames[0].Frame.Width;
//end;

//procedure TVarIntArrayFrame.SubFramesResize(Form: TForm);
//var
//  i: Integer;
//  MaxHeight: Integer;
//  MaxWidth: Integer;
//begin
//  for I := 0 to High(fIntFrames) do fIntFrames[i].SizeDetermination(Form);
//  if High(fIntFrames)<1 then Exit;
//
//  MaxWidth := 0;
//  MaxHeight := 0;
//  for I := 0 to High(fIntFrames) do
//  begin
//    MaxWidth := max(MaxWidth, fIntFrames[i].Frame.Width);
//    MaxHeight := max(MaxHeight, fIntFrames[i].Frame.Height);
//
//  end;
//  for I := 0 to High(fIntFrames) do
//  begin
//    fIntFrames[i].Frame.Width := MaxWidth;
//    fIntFrames[i].Frame.Height := MaxHeight;
//  end;
//end;

{ TDecVarIntArrayParameter }

constructor TDecVarNumberArrayParameter.Create(VarArray:TVarNumberArray;
  FFParam: TFFParameter);
begin
 fFFParameter:=FFParam;
 fVarArray:=VarArray;
end;

procedure TDecVarNumberArrayParameter.FormClear;
begin
 if fFrame.Frame<>nil then
  begin
   fFrame.Frame.Parent:=nil;
  // Form.RemoveComponent(fFrame.Frame);
//   FreeAndNil(fFrame);
  // fFrame.Free;
  end;
 FreeAndNil(fFrame); 
 fFFParameter.FormClear;
end;

procedure TDecVarNumberArrayParameter.FormPrepare(Form: TForm);
begin
  fFFParameter.FormPrepare(Form);
  fFrame := TVarNumberArrayFrame.Create(fVarArray);
  if fFrame.Frame=nil then Exit;
  
  fFrame.SizeAndLocationDetermination(Form);
  Form.InsertComponent(fFrame.Frame);

end;

function TDecVarNumberArrayParameter.IsReadyToFitDetermination: boolean;
// var i:integer;
begin
 Result:=fFFParameter.IsReadyToFitDetermination;
 Result:=Result and fVarArray.AllValuesIsPresent;
// for I := 0 to fVarArray.HighIndex do
//   Result:=Result and fVarArray.ValueIsPresent[i];
end;

procedure TDecVarNumberArrayParameter.ReadFromIniFile;
begin
 fFFParameter.ReadFromIniFile;
 fVarArray.ReadFromIniFile;
 if (fVarArray is TVarDoubArray)
     and(fVarArray.ParametrByName['T']<>nil)
     and  ((fVarArray.ParametrByName['T'] as TVarDouble).Value=ErResult)
      then (fVarArray.ParametrByName['T'] as TVarDouble).AutoDeterm:=True;
end;

procedure TDecVarNumberArrayParameter.UpDate;
begin
  fFFParameter.UpDate;
  fFrame.DateUpdate;
end;

procedure TDecVarNumberArrayParameter.WriteToIniFile;
begin
 fFFParameter.WriteToIniFile;
 fVarArray.WriteToIniFile;
end;

{ TDoubleFrame }

procedure TDoubleFrame.CBClick(Sender: TObject);
begin
   fSText.Enabled:=not(fCheckBox.Checked);
   fLabel.Enabled:=not(fCheckBox.Checked);
end;

constructor TDoubleFrame.Create(AOwner: TComponent; VarDouble: TVarDouble);
begin
 inherited  Create(AOwner);
 fLabel.Font.Color:=clNavy;
// fLabel.Font.Style:=[fsBold];

 fCheckBox:=TCheckBox.Create(Frame);
 fCheckBox.Parent:=Frame;
 fCheckBox.WordWrap:=False;
 fCheckBox.Font.Color:=clNavy;
// fCheckBox.Font.Style:=[fsBold];
 fCheckBox.Alignment:=taRightJustify;
 fCheckBox.Caption:='Auto';
 fCheckBox.OnClick:=CBClick;

 fVarDouble:=VarDouble;
 fDPShow:=TDoubleParameterShow.Create(fSText,fLabel,
           fVarDouble.Description,fVarDouble.ManualValue);
 fDPShow.Limits:=fVarDouble.Limits;


 fCheckBox.Checked:=fVarDouble.AutoDeterm;

 if fVarDouble.ManualDetermOnly then
    begin
      fCheckBox.Checked:=False;
      fCheckBox.Enabled:=False;
    end;
end;

procedure TDoubleFrame.DateUpdate;
begin
  fVarDouble.ManualValue:=fDPShow.Data;
  fVarDouble.AutoDeterm:=fCheckBox.Checked;
  fVarDouble.UpDataValue;
end;

destructor TDoubleFrame.Destroy;
begin
 fVarDouble:=nil;
 fCheckBox.Parent:=nil;
 fCheckBox.Free;
 fDPShow.Limits:=nil;
 fDPShow.Free;
 inherited;
end;

procedure TDoubleFrame.SizeDetermination(Form: TForm);
begin
 inherited ;
 fCheckBox.Width:=Form.Canvas.TextWidth(fCheckBox.Caption)+20;
 fCheckBox.Height:=Form.Canvas.TextHeight(fCheckBox.Caption);

// fSText.Top:=fLabel.Top;
// fStext.Left:=fLabel.Left+fLabel.Width+2*MarginFrame;

 fCheckBox.Top:=fLabel.Top+fLabel.Height+MarginFrame;
 fCheckBox.Left:=Round((fStext.Left+fStext.Width-fCheckBox.Width)/2);

 if fCheckBox.Left<1 then
  begin
   fLabel.Left:=fLabel.Left+abs(fCheckBox.Left)+MarginFrame;
   fStext.Left:=fStext.Left+abs(fCheckBox.Left)+MarginFrame;
   fCheckBox.Left:=fCheckBox.Left+abs(fCheckBox.Left)+MarginFrame;
  end;
 Frame.Width:=max(fStext.Left+fStext.Width,
                 fCheckBox.Left+fCheckBox.Width)+MarginFrame;
 Frame.Height:=fCheckBox.Top+fCheckBox.Height+MarginFrame;
end;

{ TVarNumberArrayFrame }

function TVarNumberArrayFrame.ColumnNumberDetermination: byte;
begin
 case High(fSubFrames) of
  -1..1:Result:=1;
   2..5:Result:=2;
   6..8:Result:=3;
  else  Result:=4;
 end;
end;

constructor TVarNumberArrayFrame.Create(VarNumberArray:TVarNumberArray);
 var i:integer;
begin
  inherited Create;
  Frame:=nil;
  if VarNumberArray.HighIndex<0 then Exit;

  Frame:=TFrame.Create(nil);

  SetLength(fSubFrames,VarNumberArray.HighIndex+1);

  if (VarNumberArray is TVarIntArray) then
   begin
    Frame.Name:=IntFrameName;
    for I := 0 to VarNumberArray.HighIndex do
     begin
       fSubFrames[i]:=TIntFrame.Create(Frame,(VarNumberArray.Parametr[i] as TVarInteger));
       fSubFrames[i].Frame.Parent:=Frame;
     end;
   end;

  if (VarNumberArray is TVarDoubArray) then
   begin
    Frame.Name:=DoubleFrameName;
    for I := 0 to VarNumberArray.HighIndex do
     begin
       fSubFrames[i]:=TDoubleFrame.Create(Frame,(VarNumberArray.Parametr[i] as TVarDouble));
       fSubFrames[i].Frame.Parent:=Frame;
     end;
   end;

end;

procedure TVarNumberArrayFrame.DateUpdate;
  var i:integer;
begin
  for I := 0 to High(fSubFrames) do fSubFrames[i].DateUpdate;
end;

destructor TVarNumberArrayFrame.Destroy;
 var i:integer;
begin
  for I := 0 to High(fSubFrames) do FreeAndNil(fSubFrames[i]);
//  fSubFrames[i].Free;
  FreeAndNil(Frame);
//  Frame.Free;
  inherited;
end;

procedure TVarNumberArrayFrame.FrameLocate(Form: TForm);
 var i, MaxLeft, MaxTop  : Integer;
begin
  Frame.Top := Form.Height + MarginTop;
  Frame.Left := MarginLeft;

  MaxLeft:=0;MaxTop:=0;
  if (fSubFrames[0]<>nil)
     and ((fSubFrames[0] is TIntFrame)
          or(fSubFrames[0] is TDoubleFrame))
   then
     try
      for i := Form.ComponentCount - 1 downto 0 do
        if ((Form.Components[i].Name = BoolCheckBoxName)
            or(Form.Components[i].Name = IntFrameName)
            or(Form.Components[i].Name = DoubleFrameName))
           and ((Form.Components[i] as TWinControl).Top>MaxTop) then
             begin
               MaxTop:=(Form.Components[i] as TWinControl).Top;
               MaxLeft:=(Form.Components[i] as TWinControl).Left
                      +(Form.Components[i] as TWinControl).Width;
             end;
      if (MaxLeft<(Form.Width / 2))and(MaxLeft>0) then
       begin
         Frame.Left := max(Frame.Left,
                          (MaxLeft + MarginBetween));
         Frame.Top := MaxTop;
       end;

     except
     end;
end;

procedure TVarNumberArrayFrame.SizeAndLocationDetermination(Form: TForm);
begin
 if High(fSubFrames)<0 then Exit;
 
 SubFramesResize(Form);
 SubFramesLocate;
 FrameLocate(Form);

 Frame.Parent:=Form;
 Form.Height:=max(Frame.Top+Frame.Height,Form.Height);
 Form.Width:=max(Form.Width,Frame.Left+Frame.Width);

end;

procedure TVarNumberArrayFrame.SubFramesLocate;
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

procedure TVarNumberArrayFrame.SubFramesResize(Form: TForm);
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


{ TSimpleDoubleFrame }

constructor TSimpleDoubleFrame.Create(AOwner: TComponent;
                       const LabelCaption:string='None';
                       InitValue:double=ErResult);
begin
  inherited Create(AOwner);
  fLabel.Font.Color:=clNavy;
  fPShow:=TDoubleParameterShow.Create(fSText,fLabel,
           LabelCaption,InitValue);
end;

//procedure TSimpleDoubleFrame.DateUpdate;
//begin
//
//end;
//
//destructor TSimpleDoubleFrame.Destroy;
//begin
//  fDPShow.Free;
//  inherited;
//end;

//procedure TSimpleDoubleFrame.DPShowCreate(const LabelCaption:string='None';
//                                       InitValue:double=ErResult);
//begin
// fDPShow:=TDoubleParameterShow.Create(fSText,fLabel,
//           LabelCaption,InitValue);
//end;

{ TSimpleIntFrame }

constructor TSimpleIntFrame.Create(AOwner: TComponent;
  const LabelCaption: string; InitValue: Integer);
begin
  inherited Create(AOwner);
  fPShow:=TIntegerParameterShow.Create(fSText,fLabel,
           LabelCaption,InitValue);
end;

//procedure TSimpleIntFrame.DateUpdate;
//begin
//
//end;
//
//destructor TSimpleIntFrame.Destroy;
//begin
//  fIPShow.Free;
//  inherited;
//end;

{ TSimpleNumberFrame }

procedure TSimpleNumberFrame.DateUpdate;
begin

end;

destructor TSimpleNumberFrame.Destroy;
begin
  fPShow.Free;
  inherited;
end;

{ TSimpleStringFrame }

constructor TSimpleStringFrame.Create(AOwner: TComponent;
  DataVariants: TStringList; const LabelCaption: string);
begin
  inherited Create(AOwner);
//  fDataVariants:=DataVariants;
  fSPShow:=TStringParameterShow.Create(fSText,fLabel,
           LabelCaption,DataVariants);
 fLabel.Font.Color:=clBlue;
 fOrientation:=oCol;
end;

procedure TSimpleStringFrame.DateUpdate;
begin

end;

destructor TSimpleStringFrame.Destroy;
begin
//  fDataVariants:=nil;
  fSPShow.Free;
  inherited;
end;

end.

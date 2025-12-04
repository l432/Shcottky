unit Unit1new;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, TeeProcs, TeEngine, Chart, Buttons,
  OlegGraph, OlegType, OlegMath, OlegFunction, Math, FileCtrl, Grids, Series, IniFiles,
  TypInfo, Spin, {OlegApprox,}FrameButtons, FrDiap, OlegMaterialSamples,OlegDefectsSi,MMSystem,
  OlegTests, OlegVector, OlegMathShottky, Castro, MLresults, porousSi,
  OlegVectorManipulation,OApproxCaption, FitTransform, ActionsOnDatFile, VclTee.TeeGDIPlus
  {XP Win}
  , System.UITypes
  ;

type
  TDirName=(ForwRs,Cheung,Hfunct,Norde,Ideal,Nss,Reverse,
            Kamin1,Kamin2,Gromov1,Gromov2,Cibil,Lee,Werner,
            MAlpha,MBetta,MIdeal,MRserial,Dit,Exp2F,Exp2R,
            M_V,Fow_Nor,Fow_NorE,Abeles,AbelesE,Fr_Pool,Fr_PoolE);
{назви директорій, які можуть створюватись;
для візуальних елементів, пов'язаних
з вибором створення директорії, де розміщюються
прямі характеристики з врахуванням Rs (а саме, ще 1 CheckBox
та 2 Label) Tag=100;
для тих, що пов'язані з записом функцій
Чюнга - Tag=101
і т.д.}
  Tfile_end=(fr, ch, h, nd, id, ns, rv, k1,
             k2, g1, g2, sb, le, wr, ma,
             mb, mn, mr,iv,ef,er,mv,fwn,fwne,abl,able,frp,frpe);
{тип, що містить закінчення назв файлів,
 які створюються; фактично використовуються
 лише назви елементів цього типу за допомогою
 GetEnumName;  незручність - вони
 мають йти в тому самому порядку, що і
 назви директорій у попередньому типі}
  TDirNames= set of TDirName;
  TColName=(fname, time, Tem, kT_1,
            Rs_Ch, Rs_H, Rs_N, Rs_K1, Rs_K2, Rs_Gr1,
            Rs_Gr2, Rs_Cb, Rs_Wer, Rs_Lee, Rs_Bh, Rs_Mk,
            Is_Exp, Is_El, Is_Gr1, Is_Gr2, Is_Lee,
            Is_Bh, Is_Mk, Is_E2F, Is_E2R,
            n_Exp, n_El, n_Ch, n_K1, n_K2, n_Gr1, n_Gr2,
            n_Cb, n_Wer, n_Lee, n_Bh, n_Mk, n_E2F, n_E2R,
            Fb_Exp, Fb_El, Fb_H, Fb_N, Fb_Gr1, Fb_Gr2,
            Fb_Lee, Fb_Bh, Fb_Mk, Fb_E2F, Fb_E2R, Kr,
            Fb_ExN,Fb_Lam,Fb_DE,
            Rsh_ExN,Rsh_Lam,Rsh_DE,Rsh_EA
            );
{назви колонок у файлі dates.dat;
для візуальних елементів, пов'язаних
з вибором величин для обчислення та внесення в dates.dat,
тобто елементів типу TCheckBox, має бути
Таg=200,
частиною поля Name має бути відповідний
елемент з масиву ColName (тобто в назву має
входити, наприклад, Rs_Ch...}
  TColNames= set of TColName;


  TForm1 = class(TForm)
//  private
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Graph: TChart;
    Close1: TBitBtn;
    Close0: TBitBtn;
    OpenFile: TButton;
    TabSheet3: TTabSheet;
    Close2: TBitBtn;
    DirLabel: TLabel;
    DataSheet: TStringGrid;
    Active: TLabel;
    NameFile: TLabel;
    Temper: TLabel;
    Series1: TPointSeries; //крапки графіку
    Series2: TLineSeries;  //лінії графіку
    XLogCheck: TCheckBox;
    YLogCheck: TCheckBox;
    LabelYLog: TLabel;
    LabelXLog: TLabel;
    GrType: TPanel;
    RBPoint: TRadioButton;
    RBLine: TRadioButton;
    RBPointLine: TRadioButton;
    Series3: TLineSeries;  //маркер
    DirName: TLabel;
    GroupBox1: TGroupBox;
    FullIV: TRadioButton;
    ForIV: TRadioButton;
    RevIV: TRadioButton;
    Chung: TRadioButton;
    Hfunc: TRadioButton;
    Nord: TRadioButton;
    CBMarker: TCheckBox;
    TrackBarMar: TTrackBar;
    GroupBox2: TGroupBox;
    SGMarker: TStringGrid;
    LabMarN: TLabel;
    LabMarX: TLabel;
    LabMarY: TLabel;
    BMarAdd: TButton;
    BmarClear: TButton;
    GroupBox3: TGroupBox;
    RdGrMin: TRadioGroup;
    LabelMin: TLabel;
    ButtonMin: TButton;
    RdGrMax: TRadioGroup;
    LabelMax: TLabel;
    ButtonMax: TButton;
    SpButLimit: TSpeedButton;
    GroupBox4: TGroupBox;
    MemoAppr: TMemo;
    BApprClear: TButton;
    Series4: TLineSeries; // аппроксимація
    GroupBoxParam0: TGroupBox;
    GroupBoxParamExp: TGroupBox;
    LabelExp: TLabel;
    ButtonParamExp: TButton;
    LabelMarFile: TLabel;
    LabelmarGraph: TLabel;
    LabelMarXGr: TLabel;
    LabelMarYGr: TLabel;
    LabelExpXmin: TLabel;
    LabelExpYmin: TLabel;
    LabelExpXmax: TLabel;
    LabelExpYmax: TLabel;
    OpenDialog1: TOpenDialog;
    Label2: TLabel;
    GroupBoxParamChung: TGroupBox;
    LabeChungRange: TLabel;
    LabelChungXmin: TLabel;
    LabelChungYmin: TLabel;
    LabelChungXmax: TLabel;
    LabelChungYmax: TLabel;
    ButtonParamChung: TButton;
    GroupBox5: TGroupBox;
    LabelHRang: TLabel;
    LabelHXmin: TLabel;
    LabelHYmin: TLabel;
    LabelHXmax: TLabel;
    LabelHYmax: TLabel;
    ButtonParamH: TButton;
    GroupBox6: TGroupBox;
    LabelNordRange: TLabel;
    LabelNordXmin: TLabel;
    LabelNordYmin: TLabel;
    LabelNordXmax: TLabel;
    LabelNordYmax: TLabel;
    LabelNordParam: TLabel;
    LabelNordGamma: TLabel;
    ButtonParamNord: TButton;
    GroupBoxEx: TGroupBox;
    LabelExRange: TLabel;
    LabelExXmin: TLabel;
    LabelExYmin: TLabel;
    LabelExXmax: TLabel;
    LabelExYmax: TLabel;
    ButtonParamEx: TButton;
    GroupBox7: TGroupBox;
    LabelRect: TLabel;
    ButtonParamRect: TButton;
    GroupBox8: TGroupBox;
    CBKalk: TComboBox;
    ButtonKalk: TButton;
    LabelKalk1: TLabel;
    LabelKalk2: TLabel;
    RadioButtonForwRs: TRadioButton;
    ButtonKalkPar: TButton;
    RadioButtonN: TRadioButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    RadioButtonNss: TRadioButton;
    GroupBoxNss: TGroupBox;
    LabelNssRange: TLabel;
    LabelNssXmin: TLabel;
    LabelNssYmin: TLabel;
    LabelNssXmax: TLabel;
    LabelNssYmax: TLabel;
    ButtonParamNss: TButton;
    ButtonNss: TButton;
    GroupBoxMat: TGroupBox;
    LRich3: TLabel;
    LPermit: TLabel;
    LabelRich: TLabel;
    LabelPerm: TLabel;
    GroupBox11: TGroupBox;
    Label7: TLabel;
    LabelCurDir: TLabel;
    ButtonCurDir: TButton;
    GroupBox12: TGroupBox;
    CBForwRs: TCheckBox;
    LForwRs: TLabel;
    LabForwRs: TLabel;
    ButForwRs: TButton;
    CBChung: TCheckBox;
    LChung: TLabel;
    LabChung: TLabel;
    ButChung: TButton;
    CBHfunc: TCheckBox;
    LHfunc: TLabel;
    LabHfunc: TLabel;
    ButHfunc: TButton;
    CBNord: TCheckBox;
    ButNord: TButton;
    LabNord: TLabel;
    LNord: TLabel;
    CBN: TCheckBox;
    LaN: TLabel;
    LabN: TLabel;
    ButtonN: TButton;
    CBNss: TCheckBox;
    LNss: TLabel;
    ButNss: TButton;
    LabNss: TLabel;
    CBRev: TCheckBox;
    LRev: TLabel;
    LabRev: TLabel;
    ButtonCreateFile: TButton;
    GroupBox13: TGroupBox;
    StrGridData: TStringGrid;
    LabelData: TLabel;
    GroupBox14: TGroupBox;
    CBDaten_El: TCheckBox;
    CBDateIs_El: TCheckBox;
    CBDateFb_El: TCheckBox;
    GroupBox15: TGroupBox;
    CBDaten_Exp: TCheckBox;
    CBDateIs_Exp: TCheckBox;
    CBDateFb_Exp: TCheckBox;
    GroupBox16: TGroupBox;
    CBDateRs_Ch: TCheckBox;
    CBDaten_Ch: TCheckBox;
    GroupBox17: TGroupBox;
    CBDateKrec: TCheckBox;
    GroupBox18: TGroupBox;
    CBDateRs_H: TCheckBox;
    CBDateFb_H: TCheckBox;
    GroupBox19: TGroupBox;
    CBDateRs_N: TCheckBox;
    CBDateFb_N: TCheckBox;
    ButtonCreateDate: TButton;
    GroupBox20: TGroupBox;
    ListBoxVolt: TListBox;
    Label8: TLabel;
    ButVoltAdd: TButton;
    ButVoltDel: TButton;
    ButVoltClear: TButton;
    LVolt: TLabel;
    ButtonVolt: TButton;
    ScrollBox1: TScrollBox;
    RadioButtonKam2: TRadioButton;
    ScrollBox2: TScrollBox;
    GroupBoxKam2: TGroupBox;
    LabelKam2Range: TLabel;
    LabelKam2Xmin: TLabel;
    LabelKam2Ymin: TLabel;
    LabelKam2Xmax: TLabel;
    LabelKam2Ymax: TLabel;
    ButtonParamKam2: TButton;
    RadioButtonKam1: TRadioButton;
    GroupBoxKam1: TGroupBox;
    LabelKam1Range: TLabel;
    LabelKam1Xmin: TLabel;
    LabelKam1Ymin: TLabel;
    LabelKam1Xmax: TLabel;
    LabelKam1Ymax: TLabel;
    ButtonParamKam1: TButton;
    ComboBoxRS: TComboBox;
    ComboBoxN: TComboBox;
    ComboBoxRS_n: TComboBox;
    ComboBoxN_Rs: TComboBox;
    ScrollBox3: TScrollBox;
    ComBForwRs: TComboBox;
    ComBForwRs_n: TComboBox;
    ButKam1: TButton;
    CBKam1: TCheckBox;
    LKam1: TLabel;
    LabKam1: TLabel;
    ButKam2: TButton;
    CBKam2: TCheckBox;
    LKam2: TLabel;
    LabKam2: TLabel;
    ComBNordN: TComboBox;
    ComBNordN_Rs: TComboBox;
    ComBNRs: TComboBox;
    ComBNRs_n: TComboBox;
    ComBNssRs: TComboBox;
    ComBNssRs_n: TComboBox;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    Bevel7: TBevel;
    Bevel8: TBevel;
    Bevel9: TBevel;
    Bevel10: TBevel;
    Bevel11: TBevel;
    ScrollBox4: TScrollBox;
    ComBDateExRs: TComboBox;
    ComBDateExRs_n: TComboBox;
    ComBDateExpRs: TComboBox;
    ComBDateExpRs_n: TComboBox;
    ComBHfuncN: TComboBox;
    ComBHfuncN_Rs: TComboBox;
    ComBDateHfunN: TComboBox;
    ComBDateHfunN_Rs: TComboBox;
    ComBDateNordN_Rs: TComboBox;
    ComBDateNordN: TComboBox;
    GroupBox21: TGroupBox;
    CBDateRs_K1: TCheckBox;
    CBDaten_K1: TCheckBox;
    GroupBox22: TGroupBox;
    CBDateRs_K2: TCheckBox;
    CBDaten_K2: TCheckBox;
    GroupBoxRsPar: TGroupBox;
    LabRsPar: TLabel;
    LabRA: TLabel;
    LabRB: TLabel;
    ButRA: TButton;
    ButRB: TButton;
    ButDel: TButton;
    ButInputT: TButton;
    RadioButtonGr2: TRadioButton;
    RadioButtonGr1: TRadioButton;
    LabelKalk3: TLabel;
    GroupBoxGr1: TGroupBox;
    LabelGr1Range: TLabel;
    LabelGr1Xmin: TLabel;
    LabelGr1Ymin: TLabel;
    LabelGr1Xmax: TLabel;
    LabelGr1Ymax: TLabel;
    ButtonParamGr1: TButton;
    GroupBoxGr2: TGroupBox;
    LabelGr2Range: TLabel;
    LabelGr2Xmin: TLabel;
    LabelGr2Ymin: TLabel;
    LabelGr2Xmax: TLabel;
    LabelGr2Ymax: TLabel;
    ButtonParamGr2: TButton;
    Bevel12: TBevel;
    CBGr1: TCheckBox;
    ButGr1: TButton;
    LGr1: TLabel;
    LabGr1: TLabel;
    Bevel13: TBevel;
    CBGr2: TCheckBox;
    LGr2: TLabel;
    LabGr2: TLabel;
    ButGr2: TButton;
    GroupBoxBh: TGroupBox;
    LabBohGam1: TLabel;
    LabBohGam2: TLabel;
    ButtonParamBh: TButton;
    RadioButtonCib: TRadioButton;
    GroupBoxCib: TGroupBox;
    LabelCibRange: TLabel;
    LabelCibXmin: TLabel;
    LabelCibYmin: TLabel;
    LabelCibXmax: TLabel;
    LabelCibYmax: TLabel;
    ButtonParamCib: TButton;
    ButCib: TButton;
    LabCib: TLabel;
    LCib: TLabel;
    CBCib: TCheckBox;
    Bevel14: TBevel;
    Bevel15: TBevel;
    RadioButtonF_V: TRadioButton;
    LabelVa: TLabel;
    ButtonVa: TButton;
    RadioButtonF_I: TRadioButton;
    RadioButtonLee: TRadioButton;
    GroupBoxLee: TGroupBox;
    LabelLeeRange: TLabel;
    LabelLeeXmin: TLabel;
    LabelLeeYmin: TLabel;
    LabelLeeXmax: TLabel;
    LabelLeeYmax: TLabel;
    ButtonParamLee: TButton;
    Bevel16: TBevel;
    ButLee: TButton;
    LabLee: TLabel;
    LLee: TLabel;
    CBLee: TCheckBox;
    RadioButtonWer: TRadioButton;
    GroupBoxWer: TGroupBox;
    LabelWerRange: TLabel;
    LabelWerXmin: TLabel;
    LabelWerYmin: TLabel;
    LabelWerXmax: TLabel;
    LabelWerYmax: TLabel;
    ButtonParamWer: TButton;
    Bevel17: TBevel;
    ButWer: TButton;
    LabWer: TLabel;
    LWer: TLabel;
    CBWer: TCheckBox;
    Bevel18: TBevel;
    LabelMikh: TLabel;
    RadioButtonMikhAlpha: TRadioButton;
    RadioButtonMikhBetta: TRadioButton;
    RadioButtonMikhN: TRadioButton;
    RadioButtonMikhRs: TRadioButton;
    GroupBoxMikh: TGroupBox;
    LabelMikhRange: TLabel;
    LabelMikhXmin: TLabel;
    LabelMikhYmin: TLabel;
    LabelMikhXmax: TLabel;
    LabelMikhYmax: TLabel;
    ButtonParamMikh: TButton;
    Bevel19: TBevel;
    LabelMikhMethod: TLabel;
    ButMAlpha: TButton;
    LabMAlpha: TLabel;
    LMAlpha: TLabel;
    CBMAlpha: TCheckBox;
    CBMBetta: TCheckBox;
    LMBetta: TLabel;
    ButMBetta: TButton;
    LabMBetta: TLabel;
    ButMN: TButton;
    LabMN: TLabel;
    CBMN: TCheckBox;
    LMN: TLabel;
    LabMRs: TLabel;
    ButMRs: TButton;
    LMRs: TLabel;
    CBMRs: TCheckBox;
    GroupBoxRs: TGroupBox;
    GroupBoxRs_n: TGroupBox;
    GroupBoxN: TGroupBox;
    GroupBoxN_Rs: TGroupBox;
    Bevel20: TBevel;
    GroupBoxForwRs: TGroupBox;
    GroupBoxForwRs_n: TGroupBox;
    GroupBoxHfuncN: TGroupBox;
    GroupBoxHfuncN_Rs: TGroupBox;
    GroupBoxNordN: TGroupBox;
    GroupBoxNordN_Rs: TGroupBox;
    GroupBoxNRs: TGroupBox;
    GroupBoxNRs_N: TGroupBox;
    GroupBoxDateExRs: TGroupBox;
    GroupBoxDateExRs_N: TGroupBox;
    GroupBoxDateExpRs: TGroupBox;
    GroupBoxDateExpRs_N: TGroupBox;
    GroupBoxDateHfuncN: TGroupBox;
    GroupBoxDateHfuncN_Rs: TGroupBox;
    GroupBoxDateNordN: TGroupBox;
    GroupBoxDateNordN_Rs: TGroupBox;
    GroupBoxNssRs: TGroupBox;
    ComboBoxNssRs: TComboBox;
    GroupBoxNssRs_N: TGroupBox;
    ComboBoxNssRs_N: TComboBox;
    GroupBoxNssNv: TGroupBox;
    RadioButtonNssNvD: TRadioButton;
    RadioButtonNssNvM: TRadioButton;
    GroupBoxNssFb: TGroupBox;
    ComboBoxNssFb: TComboBox;
    GroupBNssRs: TGroupBox;
    GroupBNssRs_n: TGroupBox;
    GroupBNssFb: TGroupBox;
    ComboBNssFb: TComboBox;
    GroupBNssNv: TGroupBox;
    RadButNssNvD: TRadioButton;
    RadButNssNvM: TRadioButton;
    ScrollBox5: TScrollBox;
    GroupBox23: TGroupBox;
    CheckBoxDateRs_Cb: TCheckBox;
    CheckBoxDaten_Cb: TCheckBox;
    GroupBox24: TGroupBox;
    CheckBoxDateRs_Wer: TCheckBox;
    CheckBoxDaten_Wer: TCheckBox;
    GroupBox25: TGroupBox;
    CheckBoxDateRs_Gr1: TCheckBox;
    CheckBoxn_Gr1: TCheckBox;
    CheckBoxIs_Gr1: TCheckBox;
    CheckBoxFb_Gr1: TCheckBox;
    GroupBox26: TGroupBox;
    CheckBoxRs_Gr2: TCheckBox;
    CheckBoxn_Gr2: TCheckBox;
    CheckBoxIs_Gr2: TCheckBox;
    CheckBoxFb_Gr2: TCheckBox;
    GroupBox27: TGroupBox;
    CheckBoxRs_Bh: TCheckBox;
    CheckBoxn_Bh: TCheckBox;
    CheckBoxIs_Bh: TCheckBox;
    CheckBoxFb_Bh: TCheckBox;
    GroupBox28: TGroupBox;
    CheckBoxRs_Lee: TCheckBox;
    CheckBoxn_Lee: TCheckBox;
    CheckBoxIs_Lee: TCheckBox;
    CheckBoxFb_Lee: TCheckBox;
    GroupBox29: TGroupBox;
    CheckBoxRs_Mk: TCheckBox;
    CheckBoxn_Mk: TCheckBox;
    CheckBoxIs_Mk: TCheckBox;
    CheckBoxFb_Mk: TCheckBox;
    GroupBoxIvan: TGroupBox;
    LabelIvanRange: TLabel;
    LabelIvanXmin: TLabel;
    LabelIvanYmin: TLabel;
    LabelIvanXmax: TLabel;
    LabelIvanYmax: TLabel;
    ButtonParamIvan: TButton;
    RadioButtonDit: TRadioButton;
    Bevel21: TBevel;
    CBDit: TCheckBox;
    LDit: TLabel;
    ButDit: TButton;
    LabDit: TLabel;
    GroupBDit: TGroupBox;
    GroupBox32: TGroupBox;
    ComBDitRs_n: TComboBox;
    ComBDitRs: TComboBox;
    ButRC: TButton;
    LabRC: TLabel;
    CheckBoxLnIT2: TCheckBox;
    CheckBoxnLnIT2: TCheckBox;
    RadioButtonEx2F: TRadioButton;
    RadioButtonEx2R: TRadioButton;
    GroupBoxE2F: TGroupBox;
    LabelE2FRange: TLabel;
    LabelE2FXmin: TLabel;
    LabelE2FYmin: TLabel;
    LabelE2FXmax: TLabel;
    LabelE2FYmax: TLabel;
    ButtonParamE2F: TButton;
    LabelE2FCaption: TLabel;
    GroupBoxE2R: TGroupBox;
    LabelE2RRange: TLabel;
    LabelE2RXmin: TLabel;
    LabelE2RYmin: TLabel;
    LabelE2RXmax: TLabel;
    LabelE2RYmax: TLabel;
    LabelE2RCaption: TLabel;
    ButtonParamE2R: TButton;
    Bevel22: TBevel;
    CBExp2F: TCheckBox;
    ButExp2F: TButton;
    GroupBExp2F: TGroupBox;
    GroupBox33: TGroupBox;
    ComBExp2FRs_n: TComboBox;
    ComBExp2FRs: TComboBox;
    LExp2F: TLabel;
    LabExp2F: TLabel;
    Bevel23: TBevel;
    ButExp2R: TButton;
    GroupBExp2R: TGroupBox;
    GroupBox34: TGroupBox;
    ComBExp2RRs_n: TComboBox;
    ComBExp2RRs: TComboBox;
    LabExp2R: TLabel;
    LExp2R: TLabel;
    CBExp2R: TCheckBox;
    GroupBox31: TGroupBox;
    CBDaten_E2F: TCheckBox;
    CBDateIs_E2F: TCheckBox;
    CBDateFb_E2F: TCheckBox;
    GroupBoxDateEx2F: TGroupBox;
    GroupBoxDateEx2FRs_N: TGroupBox;
    ComBDateEx2FRs_n: TComboBox;
    ComBDateEx2FRs: TComboBox;
    GroupBox35: TGroupBox;
    CBDaten_E2R: TCheckBox;
    CBDateIs_E2R: TCheckBox;
    CBDateFb_E2R: TCheckBox;
    GroupBoxDateEx2R: TGroupBox;
    GroupBoxDateEx2RRs_N: TGroupBox;
    ComBDateEx2RRs_n: TComboBox;
    ComBDateEx2RRs: TComboBox;
    RadioButtonM_V: TRadioButton;
    CheckBoxM_V: TCheckBox;
    Bevel24: TBevel;
    LabM_V: TLabel;
    LM_V: TLabel;
    ButM_V: TButton;
    CBM_V: TCheckBox;
    CBM_Vdod: TCheckBox;
    Bevel25: TBevel;
    RadioButtonFN: TRadioButton;
    RadioButtonFNEm: TRadioButton;
    RadioButtonAb: TRadioButton;
    RadioButtonAbEm: TRadioButton;
    RadioButtonFP: TRadioButton;
    RadioButtonFPEm: TRadioButton;
    Bevel26: TBevel;
    LFow_Nor: TLabel;
    LabFow_Nor: TLabel;
    ButFow_Nor: TButton;
    CBFow_Nordod: TCheckBox;
    CBFow_Nor: TCheckBox;
    Bevel27: TBevel;
    LFow_NorE: TLabel;
    LabFow_NorE: TLabel;
    ButFow_NorE: TButton;
    CBFow_NorEdod: TCheckBox;
    CBFow_NorE: TCheckBox;
    Bevel28: TBevel;
    ButAbeles: TButton;
    LabAbeles: TLabel;
    CBAbelesdod: TCheckBox;
    LAbeles: TLabel;
    CBAbeles: TCheckBox;
    Bevel29: TBevel;
    ButAbelesE: TButton;
    LabAbelesE: TLabel;
    CBAbelesEdod: TCheckBox;
    LAbelesE: TLabel;
    CBAbelesE: TCheckBox;
    Bevel30: TBevel;
    LabFr_Pool: TLabel;
    ButFr_Pool: TButton;
    CBFr_Pooldod: TCheckBox;
    LFr_Pool: TLabel;
    CBFr_Pool: TCheckBox;
    Bevel31: TBevel;
    CBFr_PoolEdod: TCheckBox;
    ButFr_PoolE: TButton;
    LabFr_PoolE: TLabel;
    LFr_PoolE: TLabel;
    CBFr_PoolE: TCheckBox;
    TabSheet4: TTabSheet;
    GroupBox36: TGroupBox;
    CBoxDLBuild: TCheckBox;
    LDLBuild: TLabel;
    LabIsc: TLabel;
    SpinEditDL: TSpinEdit;
    LSmoothDL: TLabel;
    ButGLAdd: TButton;
    GroupBox37: TGroupBox;
    CBoxBaseLineVisib: TCheckBox;
    ButSaveDL: TButton;
    SaveDialog1: TSaveDialog;
    CBoxBaseLineUse: TCheckBox;
    LBaseLine: TLabel;
    GroupBox38: TGroupBox;
    LBaseLineA: TLabel;
    LBaseLineB: TLabel;
    LBaseLineC: TLabel;
    PanelA: TPanel;
    LPanA: TLabel;
    LPanAe: TLabel;
    LPanAv: TLabel;
    TrackPanA: TTrackBar;
    SpinEditPanA: TSpinEdit;
    CBoxPanA: TCheckBox;
    RButBaseLine: TRadioButton;
    RButGaussianLines: TRadioButton;
    PanelB: TPanel;
    LPanB: TLabel;
    LPanBe: TLabel;
    LPanBv: TLabel;
    TrackPanB: TTrackBar;
    SpinEditPanB: TSpinEdit;
    CBoxPanB: TCheckBox;
    PanelC: TPanel;
    LPanC: TLabel;
    LPanCe: TLabel;
    LPanCv: TLabel;
    TrackPanC: TTrackBar;
    SpinEditPanC: TSpinEdit;
    CBoxPanC: TCheckBox;
    ButBaseLineReset: TButton;
    GrBoxGaus: TGroupBox;
    CBoxGLShow: TCheckBox;
    SGridGaussian: TStringGrid;
    SEGauss: TSpinEdit;
    LPanAA: TLabel;
    LPanBB: TLabel;
    LPanCC: TLabel;
    ButGLDel: TButton;
    ButGLRes: TButton;
    ButGLLoad: TButton;
    ButGausSave: TButton;
    LabelExpIph: TLabel;
    GroupParamLam: TGroupBox;
    LabelLam: TLabel;
    LabelLamXmin: TLabel;
    LabelLamYmin: TLabel;
    LabelLamXmax: TLabel;
    LabelLamYmax: TLabel;
    Label16: TLabel;
    LabelLamIph: TLabel;
    ButtonParamLam: TButton;
    GroupBoxParamDE: TGroupBox;
    LabelDE: TLabel;
    LabDEDD: TLabel;
    LabelDEXmin: TLabel;
    LabelDEYmin: TLabel;
    LabelDEXmax: TLabel;
    LabelDEYmax: TLabel;
    Label25: TLabel;
    LabelDEIph: TLabel;
    ButtonParamDE: TButton;
    CBoxRCons: TCheckBox;
    LabRCons: TLabel;
    Button1: TButton;
    ButLDFitSelect: TButton;
    ButLDFitOption: TButton;
    RBGausSelect: TRadioButton;
    RBAveSelect: TRadioButton;
    ButAveLeft: TButton;
    ButAveRight: TButton;
    ButGLAuto: TButton;
    LDateFun: TLabel;
    ButDateSelect: TButton;
    ButDateOption: TButton;
    CBDateFun: TCheckBox;
    CBMaterial: TComboBox;
    LEg: TLabel;
    LabelEg: TLabel;
    LMeff: TLabel;
    LabelMeff: TLabel;
    LVarA: TLabel;
    LabelVarA: TLabel;
    LVarB: TLabel;
    LabelVarB: TLabel;
    GBDiodParam: TGroupBox;
    Linsulator: TLabel;
    LArea: TLabel;
    LNd: TLabel;
    LEps_i: TLabel;
    LThick_i: TLabel;
    CBVoc: TCheckBox;
    LabelRichp: TLabel;
    LabelMeffp: TLabel;
    CBtypeFL: TCheckBox;
    STConcFL: TStaticText;
    STAreaFL: TStaticText;
    STEp: TStaticText;
    STThick: TStaticText;
    L_n: TLabel;
    L_p: TLabel;
    GBDiodParamPN: TGroupBox;
    LAreaPN: TLabel;
    LNdN: TLabel;
    CBtypeN: TCheckBox;
    STConcN: TStaticText;
    STAreaPN: TStaticText;
    GroupBoxMatN: TGroupBox;
    LRich3N: TLabel;
    LPermitN: TLabel;
    LabelRichN: TLabel;
    LabelPermN: TLabel;
    LEgN: TLabel;
    LabelEgN: TLabel;
    LMeffN: TLabel;
    LabelMeffN: TLabel;
    LVarAN: TLabel;
    LabelVarAN: TLabel;
    LVarBN: TLabel;
    LabelVarBN: TLabel;
    LabelRichpN: TLabel;
    LabelMeffpN: TLabel;
    L_nN: TLabel;
    L_pN: TLabel;
    CBMaterialN: TComboBox;
    CBtypeP: TCheckBox;
    LNdP: TLabel;
    STConcFLP: TStaticText;
    GroupBoxMatP: TGroupBox;
    LRich3P: TLabel;
    LPermitP: TLabel;
    LabelRichnP: TLabel;
    LabelPermP: TLabel;
    LEgP: TLabel;
    LabelEgP: TLabel;
    LMeffP: TLabel;
    LabelMeffnP: TLabel;
    LVarAP: TLabel;
    LabelVarAP: TLabel;
    LVarBP: TLabel;
    LabelVarBP: TLabel;
    LabelRichpP: TLabel;
    LabelMeffpP: TLabel;
    L_nP: TLabel;
    L_pP: TLabel;
    CBMaterialP: TComboBox;
    CBDLFunction: TComboBox;
    STDLFunction: TStaticText;
    CBBaseAuto: TCheckBox;
    ButSave: TButton;
    Bevel32: TBevel;
    RB_TauR: TRadioButton;
    RB_Igen: TRadioButton;
    RB_TauG: TRadioButton;
    RB_Irec: TRadioButton;
    RB_Ldif: TRadioButton;
    RB_Tau: TRadioButton;
    SButFitNew: TSpeedButton;
    ButFitSelectNew: TButton;
    ButFitOptionNew: TButton;
    CB_SFF: TCheckBox;
    GBActions: TGroupBox;
    BActionDo: TButton;
    ST_StartFolder: TStaticText;
    B_StartFolderSelect: TButton;
    L_StartFolder: TLabel;
    CBActions: TComboBox;
    BSaveMemo: TButton;
    procedure Close1Click(Sender: TObject);
    procedure OpenFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure XLogCheckClick(Sender: TObject);
    procedure YLogCheckClick(Sender: TObject);
    procedure LabelXLogClick(Sender: TObject);
    procedure LabelYLogClick(Sender: TObject);
    procedure RBPointClick(Sender: TObject);
    procedure RBLineClick(Sender: TObject);
    procedure RBPointLineClick(Sender: TObject);
    procedure FullIVClick(Sender: TObject);
    procedure CBMarkerClick(Sender: TObject);
    procedure TrackBarMarChange(Sender: TObject);
    procedure BMarAddClick(Sender: TObject);
    procedure BmarClearClick(Sender: TObject);
    procedure RdGrMinClick(Sender: TObject);
    procedure RdGrMaxClick(Sender: TObject);
    procedure ButtonMinClick(Sender: TObject);
    procedure ButtonMaxClick(Sender: TObject);
    procedure SpButLimitClick(Sender: TObject);
    procedure BApprClearClick(Sender: TObject);
    procedure ButtonParamRectClick(Sender: TObject);
    procedure ButtonKalkClick(Sender: TObject);
    procedure ButtonKalkParClick(Sender: TObject);
    procedure CBKalkChange(Sender: TObject);
    procedure ButtonCurDirClick(Sender: TObject);
    procedure CBForwRsClick(Sender: TObject);
    procedure ButtonCreateFileClick(Sender: TObject);
    procedure CBDateRs_ChClick(Sender: TObject);
    procedure ButtonCreateDateClick(Sender: TObject);
    procedure ButVoltClearClick(Sender: TObject);
    procedure ButVoltDelClick(Sender: TObject);
    procedure ListBoxVoltClick(Sender: TObject);
    procedure ButVoltAddClick(Sender: TObject);
    procedure ButtonVoltClick(Sender: TObject);
    procedure ComboBoxRSChange(Sender: TObject);
    procedure ComboBoxNChange(Sender: TObject);
    procedure ComBForwRsChange(Sender: TObject);
    procedure ButRAClick(Sender: TObject);
    procedure ButRBClick(Sender: TObject);
    procedure DataSheetDrawCell(Sender: TObject; ACol, ARow: Integer;
        Rect: TRect; State: TGridDrawState);
    procedure DataSheetSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure ButDelClick(Sender: TObject);
    procedure ButInputTClick(Sender: TObject);
    procedure ButtonParamCibClick(Sender: TObject);
    procedure ButtonVaClick(Sender: TObject);
    procedure ComboBoxNssRsChange(Sender: TObject);
    procedure ComboBoxNssFbChange(Sender: TObject);
    procedure ButRCClick(Sender: TObject);
    procedure RadioButtonM_VClick(Sender: TObject);
    procedure RadioButtonM_VDblClick(Sender: TObject);
    procedure CheckBoxM_VClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure CBoxDLBuildClick(Sender: TObject);
    procedure LDLBuildClick(Sender: TObject);
    procedure CBoxBaseLineVisibClick(Sender: TObject);
    procedure ButSaveDLClick(Sender: TObject);
    procedure CBoxBaseLineUseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TrackPanAChange(Sender: TObject);
    procedure RButBaseLineClick(Sender: TObject);
    procedure ButBaseLineResetClick(Sender: TObject);
    procedure CBoxGLShowClickGaus(Sender: TObject);
    procedure SGridGaussianDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure RButGaussianLinesClick(Sender: TObject);
    procedure ButGLAddClick(Sender: TObject);
    procedure SEGaussChange(Sender: TObject);
    procedure ButGLDelClick(Sender: TObject);
    procedure SGridGaussianSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure ButGLResClick(Sender: TObject);
    procedure ButGLLoadClick(Sender: TObject);
    procedure ButGausSaveClick(Sender: TObject);
    procedure LabRConsClick(Sender: TObject);
    procedure ButFitOptionClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDpKeyPress(Sender: TObject; var Key: Char);
    {процедура чіпляється до дії KeyPress всіх дочірніх форм,
дозволяє вводити в поля лише числові значення}
    procedure OnClickCheckBox(Sender: TObject);
    {чіпляється до CheckBox деяких дочірніх форм,
    дозволяє міняти картинку на формі}
    procedure OnClickButton(Sender: TObject);
    procedure ButLDFitSelectClick(Sender: TObject);
    procedure RBAveSelectClick(Sender: TObject);
    procedure ButAveLeftClick(Sender: TObject);
    procedure ButGLAutoClick(Sender: TObject);
    procedure CBDateFunClick(Sender: TObject);
    procedure CBDLFunctionClick(Sender: TObject);
    procedure ButSaveClick(Sender: TObject);
    procedure ButFitSelectNewClick(Sender: TObject);
    procedure ButFitOptionNewClick(Sender: TObject);
    procedure SButFitNewClick(Sender: TObject);
    procedure BSaveMemoClick(Sender: TObject);

  private
    { Private declarations }
    function GraphType (Sender: TObject):TGraph;
   {повертає значення, яке зв'язане з типом графіку, який
   будується залежно від назви об'єкта Sender}
    procedure CBoxGLShowClickAve(Sender: TObject);
    procedure SpectrApprox();
    {апроксимація спектрів галогенових ламп -
    результуючі файли містять спектри через 5 ангстрем,
    крім того, створюються файли з відносною кількістю
    фотонів на певній довжині хвилі}
    procedure SpectrCreate();
    {створюються файли випромінювання ламп при різних потужностях
    на основі поміряних}
    procedure AbsorbFileForSCAPS();
    {створення файлів з коефіцієнтами поглинання при різних довжинах
    хвиль та температурах}
//    procedure SomethingForCastro();
    procedure StartFolderSelectClick(Sender: TObject);
    Procedure StartFoldersToForm();
    procedure ActionDoClick(Sender: TObject);
  public
    Start_Folder:string;
    procedure ApproxHide;
    {прибирається апроксимаційна крива,
     відповідна кнопка переводиться в ненатиснутий стан}
  end;


procedure FileToDataSheet(Sheet:TStringGrid; NameFile:TLabel;
          Temperature:TLabel; a:TVector);//overload;
{процедура виведення на форму данних зі структури а:
координати самих точок в Sheet, коротку назву файла
в NameFile, температуру в Temperature}

procedure DataToGraph(SeriesPoint, SeriesLine:TChartSeries;
          Graph: TChart; Caption:string; a:TVector);//overload;
{занесення координат точок в змінні SeriesPoint та SeriesLine,
і присвоєння заголовку графіка Graph назви з Caption}

procedure NoLog(X,Y:TCheckBox; Graph:TChart);
{процедура, призначена для зняття галочок
у виборі логарифмічного масштабу та переведення
осей в лінійний режим}

procedure MarkerDraw (Graph,Vax:TVector; Point:Integer; F:TForm1);//overload;
{процедура малювання вертикального маркера
в точці з номером Рoint масиву Graph;
в мітки виводяться номер та координати точки, через
яку проводиться маркер; координати виводяться
як точок вихідної ВАХ (масив VAX), так і перебудованої
кривої (з масиву Graph)}

procedure MarkerHide(F:TForm1);
{процедура прибирання маркеру,
з графіку, очищення міток та переведення їх та
повзунка з кнопкою в неактивний режим}

procedure LimitSetup(Lim:Limits; Min, Max:TRadioGroup;
                     LMin, LMax:TLabel);
{призначена для заповнення екранного блоку,
пов'язаного з вибором меж графіку, даними з
об'єкту Lim}

procedure ClearGraph(Form1:TForm1);
{відчищує графік від різних доповнень,
(логарифмічності, маркера, зміни меж відображення,
апроксимаційних кривих тощо); виконується
перед кожною зміною кривої відображення}

procedure ClearGraphLog(Form1:TForm1);
{відчищує графік від різних доповнень,
(маркера, зміни меж відображення,
апроксимаційних кривих тощо); виконується
перед кожною зміною логарифмічності}

procedure DiapShow(D:TDiapazon;XMin,Ymin,Xmax,YMax:TLabel);
{відображення компонентів запису D у відповідних мітках}

procedure DiapShowNew(DpType:TDiapazons);
{запис у потрібні мітки, залежно від значення DpType}

procedure DiapToForm(D:TDiapazon; XMin,Ymin,Xmax,YMax:TLabeledEdit);
{відображення компонентів запису D у відповідних
текстових віконечках, виконується при використанні
вікон зміни діапазону}

procedure DiapToFormFr(D:TDiapazon; FrDp:TFrDp);

procedure FormToDiap(XMin,Ymin,Xmax,YMax:TLabeledEdit; var D:TDiapazon);
{відображення компонентів запису D у відповідних
текстових віконечках, виконується при використанні
вікон зміни діапазону}
procedure FormFrToDiap(FrDp:TFrDp; var D:TDiapazon);

Function RsDefineCB(A:TVectorShottky; CB, CBdod:TComboBox):double;//overload;
{в залежності від вибраного значення
в списку ComboBox
визначаеться величина послідовного опору;
якщо у відповідному методі необхідне
значення n, то воно обчислюється залежно від того,
що вибрано в CBdod}

Function RsDefineCB_Shot(A:TVectorShottky; CB:TComboBox):double;//overload;
{в залежності від вибраного значення
в списку ComboBox
визначаеться величина послідовного опору,
використовується для методів,
які дозволяють визначити Rs спираючись
лише на вигляд ВАХ, без додаткових параметрів}

Function nDefineCB(A:TVectorShottky; CB, CBdod:TComboBox):double;//overload;
{в залежності від вибраного значення
в списку ComboBox
визначаеться величина коефіцієнту неідеальності;
якщо у відповідному методі необхідне
значення Rs, то воно обчислюється залежно від того,
що вибрано в CBdod}

Function nDefineCB_Shot(A:TVectorShottky; CB:TComboBox):double;//overload;
{в залежності від вибраного значення
в списку ComboBox
визначаеться величина коефіцієнту неідеальності,
використовується для методів,
які дозволяють визначити n спираючись
лише на вигляд ВАХ, без додаткових параметрів}

Function FbDefineCB(A:TVectorShottky; CB:TComboBox; Rs:double):double;overload;
{в залежності від вибраного значення
в списку ComboBox
визначаеться величина висоти бар'єру,
для деякий методів необхідне значення Rs,
яке використовується як параметр}


Procedure ShowGraph(F:TForm1; st:string);
{намагається вивести на графік дані,
розташовані в VaxGraph;
якщо кількість точок в цьому масиві нульова -
виводиться вихідна ВАХ з файлу;
st - назва графіку}

Procedure DiapToLim(D:TDiapazon; var L:Limits);
{копіювання даних, що описують границі графіку
зі змінної D в змінну L}

Procedure DiapToLimToTForm1(D:TDiapazon; F:TForm1);
{копіювання даних, що описують границі графіку
зі змінної D в блок головної форми, пов'язаний
з обмеженим відображенням графіку (і в змінну GrLim,
і на саму форму, у відповідні написи}


Procedure ChooseDirect(F:TForm1);
{виведення на форму написів, пов'язаних
з робочою директорією}

Procedure ColParam(Dates:TStringGrid);
{змінює параметри Grid (кількість колонок) в залежності
від того що в ColNames, а також заносить в заголовки
колонок дані з ColNameConst}

Procedure SortGrid(SG:TStringGrid;NCol:integer);
{сортування SG по значенням в колонці номер NCol;
необхідно враховувати, що нумерація колонок починається
з нуля і що сортування відбуваеться по змінним
типу string, навіть якщо вони представляють числа
відбуваеться сортування усіх рядків, окрім нульового;
якщо NCol перевищує максимальний номер стовпчика,
то SG повертається без змін}

Procedure CBEnable(Main,Second:TComboBox);
{в залежності від вибраних значень в списку
Main змінюється доступність списку Second}

Procedure GraphShow(F:TForm1);
{початкове відображення графіку по даним
в VaxFile, крім того доступність всяких перемикачів
встановлюється}

Procedure BaseLineParam;
{виконується при переході на редагування
параметрів базової лінії на вкладці глибоких рівнів}

Procedure GaussianLinesParam;
{виконується при переході на редагування
параметрів гаусіанів лінії на вкладці глибоких рівнів}


Procedure DLParamActive;
{дозволяє доступ до регуляторів, які
використовуються при зміні параметрів на вкладці,
пов'язаній з глибокими рівнями}

Procedure DLParamPassive;
{забороняє доступ до регуляторів, які
використовуються при зміні параметрів на вкладці,
пов'язаній з глибокими рівнями}

Procedure GausLinesFree;
{знищення об'єктів, пов'язаних з гаусіанами
в методі визначення глибоких рівнів}

Procedure GausLinesSave;
{запис пареметрів гаусіан у ini-файл}

Procedure GausLinesLoad;
{зчитування пареметрів гаусіан з ini-файла}

Procedure GaussLinesToGrid;
{виведення параметрів гаусіан у таблицю}

Procedure GaussLinesToGraph(Bool:Boolean);
{показ гаусіан на графіку при Bool=true
і схов (не знищення) ліній у протилежному випадку}

Procedure FormDiapazon(DpType:TDiapazons);
{створюється форма для зміни діапазону апроксимації,
вигляд форми та метод, де цей діапазон використовуватиметься,
визначається DpType}

Function DiapFunName(Sender: TObject; var bohlin: Boolean):TDiapazons;
{залежно від елемента, який викликав цю функцію (Sender),
вибирається метод, для якого змінюватиметься діапазон
апроксимації;
використовується разом з FormDiapazon}

Function FuncLimit(A:TVectorTransform; B:TVector):boolean;//overload;
{розміщує в В обмежений набір точок з А відповідно до
очікуваної згідно з Form1.LabIsc.Caption апроксимації;
загалом допоміжна функція, використовується, зокрема,
в dB_dV_Fun}

Procedure dB_dV_Fun(A:TVectorShottky;B:TVector; fun:byte;
                    FitName:string;Rbool:boolean);overload;
{по даним у векторі А будує залежність похідної
диференційного нахилу ВАХ від напруги (метод Булярського)
fun - кількість зглажувань
Rbool=true - потрібно враховувати послідовний
та шунтуючі опори;
FitName - назва функції, якв буде використовуватись
для апроксимації}

Function FuncFitting(A:TVector; B:TVector; FitName:string):boolean;//overload;
{дані в А апроксимуються відповідно до FitName,
в В - результат апроксимації при тих же абсцисах,
при невдачі - результат False}

Procedure ParameterSimplify(Source:TArrSingle;var Target:TArrSingle;FitName:string);overload;
{вважаючи, що Source це набір визначених параметрів
апроксимації функцією FitName,
в Target записується спрощений варіант,
в якому вважаються що Rs=0, Rsh=1e12, Iph=0}

Procedure ParameterSimplify(Source:TArrSingle;var Target:TArrSingle);overload;
{те саме, що попереднє, тільки глобальний об'єкт Fit
має вже існувати}


Function ParamDeterm(Source:TArrSingle;ParamName,FitName:string):double;overload;
{вважаючи, що Source це набір визначених параметрів
апроксимації функцією FitName,
вибирається параметр з назвою ParamNameв}

Function ParamDeterm(Source:TArrSingle;ParamName:string):double;overload;
{те саме, що попереднє, тільки глобальний об'єкт Fit
має вже існувати}


Function FunCorrectionDefineNew():TFunCorrectionNew;
{визначення, яка диференційна операція буде проводитися
відповідно до вмісту CBDLFunction}


//Function FileNameIsBad(FileName:string):boolean;
//{повертає True, якщо FileName містить
//щось з переліку BadName (масив констант)}

Procedure GraphParCalculComBox(InVector:TVectorShottky;ComboBox:TCombobox);//overload;

procedure InputValueToLabel(Name,Hint:string; Format:TFloatFormat;
                   var Lab:Tlabel;var Value:double);


Function dB_dV_Build(A:TVector; B:TVector; fun:byte):boolean;overload;
Function Rnp_Build(A:TVector; B:TVector; fun:byte):boolean;overload;
Function dRnp_dV_Build(A:TVector; B:TVector; fun:byte):boolean;overload;
Function Rnp2_exp_Build(A:TVector; B:TVector; fun:byte):boolean;overload;
Function Gamma_Build(A:TVector; B:TVector; fun:byte):boolean;overload;

const
 DLFunction:array[0..4]of string=
           ('dB/dV','G(V)','dRnp/dV','L(V)','Rnp');
// BadName:array[0..3]of string=
//           ('FIT','DATES','SHOW','COMMENTS');
// mask='*.dat';

var
  Form1: TForm1;
  BohlinMethod: Boolean;
  {використовується при показі віконечок для введення параметрів методів}
  Directory, Directory0, CurDirectory:string;
  VaxFile:TVectorShottky;
  VaxGraph,VaxTemp,VaxTempLim:TVectorTransform;
  GrLim:Limits;
  GausLines:array of TLineSeries; {масив для ліній, які
  виводяться при апроксимації гаусіанами}
  GausLinesCur:array of Curve3;
  {масив для параметрів Гаусіан}
  BaseLine:TLineSeries;
  {для кривої відліку в методі визначення гливоких рівнів}
  BaseLineCur:Curve3;
  {для збереження параметрів параболи, яка описує
  лінію відліку в методі визначення глибоких рівнів}
  ApprExp:IRE;{початкові значення для аппроксимації експонентою}
  D:array[diChung..diHfunc] of TDiapazon;
  DDiod_DE:boolean;
{  DDiod_DE - чи використовується вираз для
  подвійного діода при еволюційних методах}
  DirNames:TDirNames;{множина для зберігання
  вибраних для створення директорій з допоміжними файлами}
  ColNames:TColNames;{множина для зберігання
  вибраних для обчислення та наступного
  внесення в dates.dat величин}
  Volt:array of double;
  {масив напруг, при яких визначаються струми
  (координати зрізів)}
  SelectedRow:Integer;
  {номер рядка у DataSheet, де знаходиться
  виділене значення; використовується при видаленні точок}
  ConfigFile:TIniFile;
  FirstLayer,pLayer,nLayer:TMaterialShow;
  Diod_SchottkyShow:TDiod_SchottkyShow;
  Diod_PNShow:TDiod_PNShow;



implementation

uses FormSelectFitNew, OApproxNew, FitSimple,
  OApproxFunction2, FitGradient, OlegStatistic, Spectr, SymbolicRegression;

{$R *.dfm}
{$R Res\Fig.RES}


procedure TForm1.Close1Click(Sender: TObject);
begin
 Form1.Close;
end;

procedure TForm1.ComBForwRsChange(Sender: TObject);
 var i:integer;
begin
  with Form1 do
    begin
     for I := 0 to ComponentCount-1 do
       if (Components[i].Tag=(Sender as TComponent).Tag)
          and (AnsiPos('_',Components[i].Name)<>0)
           then
             begin
               CBEnable((Sender as TComboBox),
                        (Components[i] as TComboBox));
               Break;
             end;
    end; //with Form1 do
end;

procedure TForm1.ComboBoxNChange(Sender: TObject);
begin
  if Hfunc.Checked then RadioButtonM_VClick(Hfunc);
  CBEnable(ComboBoxN,ComboBoxN_Rs);
end;

procedure TForm1.ComboBoxNssFbChange(Sender: TObject);
begin
  if RadioButtonNss.Checked then
                 RadioButtonM_VClick(RadioButtonNss);
end;

procedure TForm1.ComboBoxNssRsChange(Sender: TObject);
begin
  CBEnable(ComboBoxNssRS,ComboBoxNssRS_n);
  if RadioButtonNss.Checked then
                   RadioButtonM_VClick(RadioButtonNss);
  if RadioButtonDit.Checked then
                   RadioButtonM_VClick(RadioButtonDit);
end;

procedure TForm1.ComboBoxRSChange(Sender: TObject);
begin
 if VaxFile.T<=0 then
  if not (ConvertStringToTGraph(ComboBoxRS) in
         [fnReq0,fnCheung,fnKaminskii1,fnKaminskii2,
         fnRvsTpower2,fnGromov1,fnCibils,fnLee,
         fnMikhelashvili,fnDiodLSM,fnDiodLambert,fnDiodEvolution]) then
   begin
   MessageDlg('Rs can not be calculated by this method,'+#10+#13+
              'because T is undefined',mtError, [mbOK], 0);
   ComboBoxRS.ItemIndex:=6;
   end;
 CBEnable(ComboBoxRS,ComboBoxRS_n);

 if RadioButtonForwRs.Checked then
                 RadioButtonM_VClick(RadioButtonForwRs);
 if RadioButtonN.Checked then
                 RadioButtonM_VClick(RadioButtonN);
 if RadioButtonEx2F.Checked then
                 RadioButtonM_VClick(RadioButtonEx2F);
 if RadioButtonEx2R.Checked then
                 RadioButtonM_VClick(RadioButtonEx2R);
end;

procedure TForm1.DataSheetDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
 if (ACol>0) and (ARow>0) then
  begin
   if StrtoFloat(DataSheet.Cells[Acol,ARow])<0 then
    begin
     DataSheet.Canvas.Brush.Color:=RGB(204,241,248);
     DataSheet.Canvas.FillRect(Rect);
     DataSheet.Canvas.TextOut(Rect.Left+2,Rect.Top+2,DataSheet.Cells[Acol,Arow]);
    end
                                            else
    begin
     DataSheet.Canvas.Brush.Color:=RGB(252,218,208);
     DataSheet.Canvas.FillRect(Rect);
     DataSheet.Canvas.TextOut(Rect.Left+2,Rect.Top+2,DataSheet.Cells[Acol,Arow]);
    end
 end;
end;

procedure TForm1.DataSheetSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
   ButDel.Enabled:=True;
   SelectedRow:=ARow;
end;

procedure TForm1.StartFoldersToForm;
begin
  L_StartFolder.Caption:=Start_Folder;
end;

procedure TForm1.FormCreate(Sender: TObject);
 var
    i,j:integer;
    st:string;
    DP: TDiapazons;
    DR:TDirName;
    CL:TColName;

begin
 Form1.Scaled:=false;
 GroupBox20.ParentBackground:=False;
 GroupBox20.Color:=RGB(254,226,218);
 GroupBox12.ParentBackground:=False;
 GroupBox12.Color:=RGB(222,254,233);
 Directory0:= GetCurrentDir;
 {XP Win}
 FormatSettings.DecimalSeparator:='.';
// DecimalSeparator:='.';

  CBKalk.Sorted:=False;
  CBKalk.Items.Add('Method');
  CBKalk.Items.Add(GraphLabel[fnCheung]);
  CBKalk.Items.Add(GraphLabel[fnH]);
  CBKalk.Items.Add(GraphLabel[fnNorde]);
  CBKalk.Items.Add(GraphLabel[fnDiodLSM]);
  CBKalk.Items.Add(GraphLabel[fnDiodVerySimple]);
  CBKalk.Items.Add(GraphLabel[fnRectification]);
  CBKalk.Items.Add(GraphLabel[fnKaminskii1]);
  CBKalk.Items.Add(GraphLabel[fnKaminskii2]);
  CBKalk.Items.Add(GraphLabel[fnGromov1]);
  CBKalk.Items.Add(GraphLabel[fnGromov2]);
  CBKalk.Items.Add(GraphLabel[fnBohlin]);
  CBKalk.Items.Add(GraphLabel[fnCibils]);
  CBKalk.Items.Add(GraphLabel[fnLee]);
  CBKalk.Items.Add(GraphLabel[fnWerner]);
  CBKalk.Items.Add(GraphLabel[fnMikhelashvili]);
  CBKalk.Items.Add(GraphLabel[fnDLdensityIvanov]);
  CBKalk.Items.Add(GraphLabel[fnExpForwardRs]);
  CBKalk.Items.Add(GraphLabel[fnExpReverseRs]);
  CBKalk.Items.Add(GraphLabel[fnDiodLambert]);
  CBKalk.Items.Add(GraphLabel[fnDiodEvolution]);
  CBKalk.ItemIndex:=0;

  ComboBoxRs.Sorted:=False;
  ComboBoxRs.Items.Add(GraphLabel[fnReq0]);
  ComboBoxRs.Items.Add(GraphLabel[fnCheung]);
  ComboBoxRs.Items.Add(GraphLabel[fnKaminskii1]);
  ComboBoxRs.Items.Add(GraphLabel[fnKaminskii2]);
  ComboBoxRs.Items.Add(GraphLabel[fnH]);
  ComboBoxRs.Items.Add(GraphLabel[fnNorde]);
  ComboBoxRs.Items.Add(GraphLabel[fnRvsTpower2]);
  ComboBoxRs.Items.Add(GraphLabel[fnGromov1]);
  ComboBoxRs.Items.Add(GraphLabel[fnGromov2]);
  ComboBoxRs.Items.Add(GraphLabel[fnBohlin]);
  ComboBoxRs.Items.Add(GraphLabel[fnCibils]);
  ComboBoxRs.Items.Add(GraphLabel[fnLee]);
  ComboBoxRs.Items.Add(GraphLabel[fnWerner]);
  ComboBoxRs.Items.Add(GraphLabel[fnMikhelashvili]);
  ComboBoxRs.Items.Add(GraphLabel[fnDiodLSM]);
  ComboBoxRs.Items.Add(GraphLabel[fnDiodLambert]);
  ComboBoxRs.Items.Add(GraphLabel[fnDiodEvolution]);

  ComboBoxNssRs.Sorted:=False;
  ComboBoxNssRs.Items:=ComboBoxRs.Items;
  ComBForwRs.Sorted:=False;
  ComBForwRs.Items:=ComboBoxRs.Items;
  ComBNRs.Sorted:=False;
  ComBNRs.Items:=ComboBoxRs.Items;
  ComBNssRs.Sorted:=False;
  ComBNssRs.Items:=ComboBoxRs.Items;
  ComBDitRs.Sorted:=False;
  ComBDitRs.Items:=ComboBoxRs.Items;
  ComBExp2FRs.Sorted:=False;
  ComBExp2FRs.Items:=ComboBoxRs.Items;
  ComBExp2RRs.Sorted:=False;
  ComBExp2RRs.Items:=ComboBoxRs.Items;
  ComBDateExRs.Sorted:=False;
  ComBDateExRs.Items:=ComboBoxRs.Items;
  ComBDateExpRs.Sorted:=False;
  ComBDateExpRs.Items:=ComboBoxRs.Items;
  ComBDateEx2FRs.Sorted:=False;
  ComBDateEx2FRs.Items:=ComboBoxRs.Items;
  ComBDateEx2RRs.Sorted:=False;
  ComBDateEx2RRs.Items:=ComboBoxRs.Items;

  ComboBoxRS_n.Sorted:=False;
  ComboBoxRS_n.Items.Add(GraphLabel[fnNeq1]);
  ComboBoxRS_n.Items.Add(GraphLabel[fnCheung]);
  ComboBoxRS_n.Items.Add(GraphLabel[fnKaminskii1]);
  ComboBoxRS_n.Items.Add(GraphLabel[fnKaminskii2]);
  ComboBoxRS_n.Items.Add(GraphLabel[fnGromov1]);
  ComboBoxRS_n.Items.Add(GraphLabel[fnGromov2]);
  ComboBoxRS_n.Items.Add(GraphLabel[fnBohlin]);
  ComboBoxRS_n.Items.Add(GraphLabel[fnCibils]);
  ComboBoxRS_n.Items.Add(GraphLabel[fnLee]);
  ComboBoxRS_n.Items.Add(GraphLabel[fnWerner]);
  ComboBoxRS_n.Items.Add(GraphLabel[fnMikhelashvili]);
  ComboBoxRS_n.Items.Add(GraphLabel[fnDiodLSM]);
  ComboBoxRS_n.Items.Add(GraphLabel[fnDiodLambert]);
  ComboBoxRS_n.Items.Add(GraphLabel[fnDiodEvolution]);

  ComboBoxNssRs_N.Sorted:=False;
  ComboBoxNssRs_N.Items:=ComboBoxRS_n.Items;
  ComBForwRs_n.Sorted:=False;
  ComBForwRs_n.Items:=ComboBoxRS_n.Items;
  ComBNRs_n.Sorted:=False;
  ComBNRs_n.Items:=ComboBoxRS_n.Items;
  ComBNssRs_n.Sorted:=False;
  ComBNssRs_n.Items:=ComboBoxRS_n.Items;
  ComBDitRs_n.Sorted:=False;
  ComBDitRs_n.Items:=ComboBoxRS_n.Items;
  ComBExp2FRs_n.Sorted:=False;
  ComBExp2FRs_n.Items:=ComboBoxRS_n.Items;
  ComBExp2RRs_n.Sorted:=False;
  ComBExp2RRs_n.Items:=ComboBoxRS_n.Items;

  ComBDateEx2RRs_n.Sorted:=False;
  ComBDateEx2RRs_n.Items:=ComboBoxRS_n.Items;
  ComBDateEx2FRs_n.Sorted:=False;
  ComBDateEx2FRs_n.Items:=ComboBoxRS_n.Items;
  ComBDateExpRs_n.Sorted:=False;
  ComBDateExpRs_n.Items:=ComboBoxRS_n.Items;
  ComBDateExRs_n.Sorted:=False;
  ComBDateExRs_n.Items:=ComboBoxRS_n.Items;

  ComboBoxN.Sorted:=False;
  ComboBoxN.Items.Add(GraphLabel[fnNeq1]);
  ComboBoxN.Items.Add(GraphLabel[fnCheung]);
  ComboBoxN.Items.Add(GraphLabel[fnKaminskii1]);
  ComboBoxN.Items.Add(GraphLabel[fnKaminskii2]);
  ComboBoxN.Items.Add(GraphLabel[fnDiodLSM]);
  ComboBoxN.Items.Add(GraphLabel[fnDiodVerySimple]);
  ComboBoxN.Items.Add(GraphLabel[fnGromov1]);
  ComboBoxN.Items.Add(GraphLabel[fnGromov2]);
  ComboBoxN.Items.Add(GraphLabel[fnBohlin]);
  ComboBoxN.Items.Add(GraphLabel[fnCibils]);
  ComboBoxN.Items.Add(GraphLabel[fnLee]);
  ComboBoxN.Items.Add(GraphLabel[fnWerner]);
  ComboBoxN.Items.Add(GraphLabel[fnMikhelashvili]);
  ComboBoxN.Items.Add(GraphLabel[fnExpForwardRs]);
  ComboBoxN.Items.Add(GraphLabel[fnExpReverseRs]);
  ComboBoxN.Items.Add(GraphLabel[fnDiodLSM]);
  ComboBoxN.Items.Add(GraphLabel[fnDiodLambert]);
  ComboBoxN.Items.Add(GraphLabel[fnDiodEvolution]);

  ComBHfuncN.Sorted:=False;
  ComBHfuncN.Items:=ComboBoxN.Items;
  ComBNordN.Sorted:=False;
  ComBNordN.Items:=ComboBoxN.Items;
  ComBDateNordN.Sorted:=False;
  ComBDateNordN.Items:=ComboBoxN.Items;
  ComBDateHfunN.Sorted:=False;
  ComBDateHfunN.Items:=ComboBoxN.Items;

  ComboBoxN_Rs.Sorted:=False;
  ComboBoxN_Rs.Items.Add(GraphLabel[fnReq0]);
  ComboBoxN_Rs.Items.Add(GraphLabel[fnCheung]);
  ComboBoxN_Rs.Items.Add(GraphLabel[fnKaminskii1]);
  ComboBoxN_Rs.Items.Add(GraphLabel[fnKaminskii2]);
  ComboBoxN_Rs.Items.Add(GraphLabel[fnRvsTpower2]);
  ComboBoxN_Rs.Items.Add(GraphLabel[fnGromov1]);
  ComboBoxN_Rs.Items.Add(GraphLabel[fnGromov2]);
  ComboBoxN_Rs.Items.Add(GraphLabel[fnBohlin]);
  ComboBoxN_Rs.Items.Add(GraphLabel[fnCibils]);
  ComboBoxN_Rs.Items.Add(GraphLabel[fnLee]);
  ComboBoxN_Rs.Items.Add(GraphLabel[fnWerner]);
  ComboBoxN_Rs.Items.Add(GraphLabel[fnMikhelashvili]);
  ComboBoxN_Rs.Items.Add(GraphLabel[fnDiodLSM]);
  ComboBoxN_Rs.Items.Add(GraphLabel[fnDiodLambert]);
  ComboBoxN_Rs.Items.Add(GraphLabel[fnDiodEvolution]);

  ComBDateHfunN_Rs.Sorted:=False;
  ComBDateHfunN_Rs.Items:=ComboBoxN_Rs.Items;
  ComBDateNordN_Rs.Sorted:=False;
  ComBDateNordN_Rs.Items:=ComboBoxN_Rs.Items;
  ComBHfuncN_Rs.Sorted:=False;
  ComBHfuncN_Rs.Items:=ComboBoxN_Rs.Items;
  ComBNordN_Rs.Sorted:=False;
  ComBNordN_Rs.Items:=ComboBoxN_Rs.Items;

  ComboBoxNssFb.Sorted:=False;
  ComboBoxNssFb.Items.Add(GraphLabel[fnNorde]);
  ComboBoxNssFb.Items.Add(GraphLabel[fnDiodLSM]);
  ComboBoxNssFb.Items.Add(GraphLabel[fnDiodVerySimple]);
  ComboBoxNssFb.Items.Add(GraphLabel[fnGromov1]);
  ComboBoxNssFb.Items.Add(GraphLabel[fnGromov2]);
  ComboBoxNssFb.Items.Add(GraphLabel[fnBohlin]);
  ComboBoxNssFb.Items.Add(GraphLabel[fnLee]);
  ComboBoxNssFb.Items.Add(GraphLabel[fnMikhelashvili]);
  ComboBoxNssFb.Items.Add(GraphLabel[fnExpForwardRs]);
  ComboBoxNssFb.Items.Add(GraphLabel[fnExpReverseRs]);
  ComboBoxNssFb.Items.Add(GraphLabel[fnDiodLSM]);
  ComboBoxNssFb.Items.Add(GraphLabel[fnDiodLambert]);
  ComboBoxNssFb.Items.Add(GraphLabel[fnDiodEvolution]);

  ComboBNssFb.Sorted:=False;
  ComboBNssFb.Items:=ComboBoxNssFb.Items;

  CBDLFunction.Sorted:=False;
  for I := 0 to High(DLFunction) do CBDLFunction.Items.Add(DLFunction[i]);


 ConfigFile:=TIniFile.Create(Directory0+'\Shottky.ini');
 Directory:=ConfigFile.ReadString('Direct','Dir',GetCurrentDir);
 CurDirectory:=ConfigFile.ReadString('Direct','CDir',Directory);
 ChooseDirect(Form1);

 CBDLFunction.ItemIndex:=ConfigFile.ReadInteger('DLFunction','Name',0);
 CBDLFunctionClick(CBDLFunction);
 SpinEditDL.OnChange:=nil;
 SpinEditDL.Value:=ConfigFile.ReadInteger('DLFunction','SmoothNumber',5);
 SpinEditDL.OnChange:=CBoxDLBuildClick;

 FirstLayer:=TMaterialShow.Create([LabelEg,LabelPerm,LabelRich,LabelRichp,LabelMeff,LabelMeffp,LabelVarA,LabelVarB],
                                  CBMaterial,'FL',ConfigFile);
 pLayer:=TMaterialShow.Create([LabelEgP,LabelPermP,LabelRichP,LabelRichpP,
                               LabelMeffp,LabelMeffpP,LabelVarAP,LabelVarBP],
                                  CBMaterialP,'P',ConfigFile);
 nLayer:=TMaterialShow.Create([LabelEgN,LabelPermN,LabelRichN,LabelRichpN,
                               LabelMeffN,LabelMeffpN,LabelVarAN,LabelVarBN],
                                  CBMaterialN,'N',ConfigFile);

 Diod:=TDiod_Schottky.Create;
 Diod.ReadFromIniFile(ConfigFile);
 Diod.Semiconductor.Material:=FirstLayer.Material;

 Diod_SchottkyShow:=TDiod_SchottkyShow.Create(Diod,CBtypeFL,STConcFL,STAreaFL,STEp,STThick,
                          LNd,LArea,LEps_i,LThick_i);

 DiodPN:=TDiod_PN.Create;
 DiodPN.ReadFromIniFile(ConfigFile);
 DiodPN.LayerN.Material:=nLayer.Material;
 DiodPN.LayerP.Material:=pLayer.Material;

 Diod_PNShow:=TDiod_PNShow.Create(DiodPN,CBtypeN,CBtypeP,STConcN,STConcFLP,
                                 STAreaPN,LNdN,LNdP,LAreaPN);

 GraphParameters:=TGraphParameters.Create;
 GraphParameters.Clear();
 GraphParameters.ReadFromIniFile(ConfigFile);

GrLim.MinXY:=ConfigFile.ReadInteger('Limit','MinXY',0);
GrLim.MaxXY:=ConfigFile.ReadInteger('Limit','MaxXY',0);
GrLim.MinValue[0]:=ConfigFile.ReadFloat('Limit','MinV0',ErResult);
GrLim.MinValue[1]:=ConfigFile.ReadFloat('Limit','MinV1',ErResult);
GrLim.MaxValue[0]:=ConfigFile.ReadFloat('Limit','MaxV0',ErResult);
GrLim.MaxValue[1]:=ConfigFile.ReadFloat('Limit','MaxV1',ErResult);
  LimitSetup(GrLim, RdGrMin, RdGrMax, LabelMin, LabelMax);

 DDiod_DE:=ConfigFile.ReadBool('Approx','DDiod_DE',True);

  for DP := Low(DP) to High(DP) do
   begin
    D[DP]:=TDiapazon.Create;
    D[Dp].ReadFromIniFile(ConfigFile,'Diapaz',GetEnumName(TypeInfo(TDiapazons),ord(DP)));
   end;
  if D[diEx].XMin<0.06 then D[diEx].XMin:=0.07;
  if D[diIvan].XMin<0.06 then D[diIvan].XMin:=0.07;
  if D[diLee].XMin<0.05 then D[diLee].XMin:=0.05;
  D[diE2R].Br:='R';

  LabelVa.Caption:='Va = '+FloatToStrF(GraphParameters.Va,ffGeneral,3,2)+' V';
  LabelRect.Caption:=FloatToStrF(GraphParameters.Vrect,ffGeneral,3,2)+' V';

  LabRA.Caption:='A = '+FloatToStrF(GraphParameters.RA,ffGeneral,3,2);
  LabRB.Caption:='B = '+FloatToStrF(GraphParameters.RB,ffExponent,3,2);
  LabRC.Caption:='C = '+FloatToStrF(GraphParameters.RC,ffExponent,3,2);
  LabIsc.Caption:=ConfigFile.ReadString('Parameters','DLFunctionName',FFFunctionPhotoDDiod);
  LDateFun.Caption:=ConfigFile.ReadString('Parameters','DateFunctionName',FFFunctionPhotoDDiod);
  ButDateOption.Enabled:=not((LDateFun.Caption='None'));
  for DP := Low(DP) to High(DP) do
      DiapShowNew(DP);
  CheckBoxLnIT2.Checked:=ConfigFile.ReadBool('Volts2','LnIT2',False);
  CheckBoxnLnIT2.Checked:=ConfigFile.ReadBool('Volts2','nLnIT2',False);
    try
   ConfigFile.ReadSectionValues('Volts',ListBoxVolt.Items);
   SetLength(Volt, ListBoxVolt.Items.Count);
   for I := 0 to High(Volt) do
     begin
     st:=ListBoxVolt.Items[i];
     delete(st,1,AnsiPos('=',st));
     ListBoxVolt.Items[i]:=st;
     Volt[i]:=StrToFloat(ListBoxVolt.Items[i]);
     end;
    for I := 0 to High(Volt)-1 do
      for j := 0 to High(Volt)-1-i do
       if Volt[j]>Volt[j+1] then Swap(Volt[j],Volt[j+1]);
    ListBoxVolt.Clear;
    for I := 0 to High(Volt) do
      ListBoxVolt.Items.Add(FloatToStrF(Volt[i],ffGeneral,4,2));
  except
   ListBoxVolt.Clear;
   SetLength(Volt, ListBoxVolt.Items.Count);
  end;

{зчитуються стан вибору директорій
для створення при останній роботі}
 DirNames:=[];
 for DR:=Low(DR) to High(DR) do
 if ConfigFile.ReadBool('Dir',
    'Select '+GetEnumName(TypeInfo(TDirName),ord(DR)),
     False)
     then  Include(DirNames, DR);

{зчитуються колонки, які були
вибрані під час останнього сеансу }
for CL:=Low(CL) to High(CL) do
 if ConfigFile.ReadBool('Column',
      'Select '+ GetEnumName(TypeInfo(TColName),ord(CL)),
      False)
     then Include(ColNames, CL);
for CL:=fname to kT_1 do Include(ColNames, CL);

with Form1 do
begin
 for I := 0 to ComponentCount-1 do
    begin
//{відновлення матеріалу з попереднього сеансу}
//     if (Components[i] is TRadioButton)and
//        (Components[i].Tag=Imat) then
//            (Components[i]as TRadioButton).Checked:=True;
{--------------------------------------------}

     case Components[i].Tag of
{-----встановлення виборів директорій, які
      необхідно створювати, в CheckBox-cи;
      про номера Tag див. спочатку, біля
                  визначення типів-------------------}
       100..149: if (Components[i] is TCheckBox) then
             begin
             DR:=Low(DR);
             Inc(Dr,Components[i].Tag-100);
             if (Dr in DirNames) then
               (Components[i] as TCheckBox).Checked:=True;
             end;
{-----встановлення виборів колонок, які
      необхідно створювати, в CheckBox-cи;-----------}
         200: if (Components[i] is TCheckBox) then
                begin
                for CL:=Succ(kT_1) to High(CL) do
                  if (CL in ColNames)and
                   (AnsiPos(GetEnumName(TypeInfo(TColName),ord(CL)),
                            Components[i].Name)<>0)
                      then
                      begin
                     (Components[i] as TCheckBox).Checked:=True;
                      Break;
                      end;
                end;

{------робота з блоками вибору способу визначення
       Rs, n та Fb----------------------------}

{----блоки в області побудови графіків--------}
       55..56: if (Components[i] is TComboBox) then
               (Components[i] as TComboBox).ItemIndex:=
                 ConfigFile.ReadInteger('Graph',
                 Copy(Components[i].Name,Length('ComboBox')+1,
                 Length(Components[i].Name)-Length('ComboBox')),
                 0);

{----блоки в області вибору директорій--------}
{відповідні  ComboBox мають мати Tag від 300 до 399,
 причому "спарені", тобто ті, які знаходяться в одній
GroupBox мають мати однакові Tag (свої
для кожної пари) і більші за 300}
       300..399:begin
{________зчитування виборів у попередньому сеансі_________}
           (Components[i] as TComboBox).ItemIndex:=
           ConfigFile.ReadInteger('Dir',
            Copy(Components[i].Name,Length('ComB')+1,
            Length(Components[i].Name)-Length('ComB')),
            0);
{_____встановлення відповідностей між
      головним вибором та доступності до другорядного
      в блоках вибору способу визначення Rs та n______}
           if (Components[i].Tag>300)and
             (AnsiPos('_',Components[i].Name)=0) then
                    for j:=0 to ComponentCount-1 do
                     if (Components[j].Tag=Components[i].Tag)
                        and (AnsiPos('_',Components[j].Name)<>0)
                        then
                        begin
                        CBEnable((Components[i] as TComboBox),
                                 (Components[j] as TComboBox));
                        Break;
                        end;
                 end; //300..399

{----блоки в області вибору колонок--------}
{відповідні  ComboBox мають мати Tag від 401 до 499,
 причому "спарені", тобто ті, які знаходяться в одній
GroupBox мають мати однакові Tag (свої
для кожної пари) }
       401..499:begin
{________зчитування виборів у попередньому сеансі_________}
           (Components[i] as TComboBox).ItemIndex:=
           ConfigFile.ReadInteger('Column',
            Copy(Components[i].Name,Length('ComBDate')+1,
            Length(Components[i].Name)-Length('ComBDate')),
            0);
{_____встановлення відповідностей між
      головним вибором та доступності до другорядного
      в блоках вибору способу визначення Rs та n______}
           if (AnsiPos('_',Components[i].Name)=0) then
                    for j:=0 to ComponentCount-1 do
                     if (Components[j].Tag=Components[i].Tag)
                        and (AnsiPos('_',Components[j].Name)<>0)
                        then
                        begin
                        CBEnable((Components[i] as TComboBox),
                                 (Components[j] as TComboBox));
                        Break;
                        end;
                 end; //401..499

{--------------------------------------------------------}

     end; //case Components[i].Tag of
    end;// for I := 0 to ComponentCount-1 do
end; //with Form1 do

CBDateFun.Checked:=ConfigFile.ReadBool('Column',
      'SelectFun',False);
CB_SFF.Checked:=ConfigFile.ReadBool('Column',
      'SaveFit',False);


RadioButtonNssNvM.Checked:=ConfigFile.ReadBool('Graph','Nss_N(V)',False);
RadButNssNvM.Checked:=ConfigFile.ReadBool('Dir','NssN(V)',False);
  SButFitNew.Caption:='None';
  MemoAppr.Clear;

  VaxFile:=TVectorShottky.Create;
  VaxGraph:=TVectorTransform.Create;
  VaxTemp:=TVectorTransform.Create;
  VaxTempLim:=TVectorTransform.Create;


  MarkerHide(Form1);
  GraphShow(Form1);

  LabelKalk1.Visible:=False;
  LabelKalk2.Visible:=False;
  LabelKalk3.Visible:=False;

  NameFile.Caption:='';
  Temper.Caption:='';
  DataSheet.Cells[0,0]:='N';
  DataSheet.Cells[1,0]:='Voltage';
  DataSheet.Cells[2,0]:='Current';
  SGMarker.Cells[0,0]:='N';
  SGMarker.Cells[1,0]:='File';
  SGMarker.Cells[2,0]:='Voltage';
  SGMarker.Cells[3,0]:='Current';


  Graph.LeftAxis.Automatic:=true;
  Graph.BottomAxis.Automatic:=true;
  Series1.Active:=True;
  Series1.Clear;
  Series2.Active:=False;
  Series4.Active:=False;
  Series1.AddXY(1,1,'',clBlue);
  Series1.AddXY(-1,-1,'',clBlue);
  RBPoint.Checked:=True;
  DirName.Caption:='';
  ButVoltDel.Enabled:=False;

  {щоб на вкладку DeepLevel, якщо вона відкривається, перекинути елементи}
  if PageControl1.ActivePageIndex=3 then PageControl1Change(Sender);

  RBGausSelect.Checked:=ConfigFile.ReadBool('Approx','SelectGaus',True);
  RBAveSelect.Checked:=not(RBGausSelect.Checked);

  DLParamPassive;

  B_StartFolderSelect.OnClick:=StartFolderSelectClick;
  Start_Folder:=ConfigFile.ReadString('Folders','Start',GetCurrentDir);
  StartFoldersToForm();

  CBActions.Items.Clear;
  for I := 0 to High(ActionsName) do
     CBActions.Items.Add(ActionsName[i]);
  CBActions.ItemIndex:=0;

  BActionDo.OnClick:=ActionDoClick;


end;

procedure TForm1.FormDestroy(Sender: TObject);
var
    i:integer;
    DP:TDiapazons;
    DR:TDirName;
    CL:TColName;
begin
 {XP Win}
 FormatSettings.DecimalSeparator:='.';
// DecimalSeparator:='.';
 ChDir(Directory0);

 ConfigFile.WriteBool('Volts2','LnIT2',CheckBoxLnIT2.Checked);
 ConfigFile.WriteBool('Volts2','nLnIT2',CheckBoxnLnIT2.Checked);

 ConfigFile.EraseSection('Volts');
 for I := 0 to ListBoxVolt.Items.Count-1 do
 ConfigFile.WriteString('Volts',IntToStr(I),ListBoxVolt.Items[i]);

 ConfigFile.WriteString('Direct','Dir',Directory);
 ConfigFile.WriteString('Direct','CDir',CurDirectory);

 ConfigFile.WriteInteger('Limit','MinXY',GrLim.MinXY);
 ConfigFile.WriteInteger('Limit','MaxXY',GrLim.MaxXY);
 ConfigFile.WriteFloat('Limit','MinV0',GrLim.MinValue[0]);
 ConfigFile.WriteFloat('Limit','MinV1',GrLim.MinValue[1]);
 ConfigFile.WriteFloat('Limit','MaxV0',GrLim.MaxValue[0]);
 ConfigFile.WriteFloat('Limit','MaxV1',GrLim.MaxValue[1]);

 ConfigFile.WriteBool('Approx','DDiod_DE',DDiod_DE);
 ConfigFile.WriteBool('Approx','SelectGaus',RBGausSelect.Checked);

 ConfigFile.EraseSection('Diapaz');

  for DP := Low(DP) to High(DP) do
   begin
   D[Dp].WriteToIniFile(ConfigFile,'Diapaz',GetEnumName(TypeInfo(TDiapazons),ord(DP)));
   D[DP].Free;
   end;

  ConfigFile.WriteString('Parameters','DLFunctionName',LabIsc.Caption);
  ConfigFile.WriteString('Parameters','DateFunctionName',LDateFun.Caption);

{запис стану вибору директорій для створення}
 for DR:=Low(DR) to High(DR) do
  ConfigFile.WriteBool('Dir',
           'Select '+GetEnumName(TypeInfo(TDirName),ord(DR)),
           (DR in DirNames));
 {запис стану вибору колонок для створення}
 for CL:=Low(CL) to High(CL) do
  ConfigFile.WriteBool('Column',
      'Select '+GetEnumName(TypeInfo(TColName),ord(CL)),
      (CL in ColNames));

 ConfigFile.WriteBool('Column','SelectFun',CBDateFun.Checked);
 ConfigFile.WriteBool('Column','SaveFit',CB_SFF.Checked);


with Form1 do
begin
  for I := 0 to ComponentCount-1 do
   case Components[i].Tag of
{---запис вибраного матеріалу-----}
     1..49: if (Components[i] is TRadioButton)and
               (Components[i] as TRadioButton).Checked
              then
               ConfigFile.WriteInteger('Parameters',
                  'MaterialNumber',Components[i].Tag);
{------запис стану блоків вибору
       способу визначення  Rs, n та Fb----------------}
{______в області вибору створюваних директорій________}
    300..399: ConfigFile.WriteInteger('Dir',
                Copy(Components[i].Name,Length('ComB')+1,
                  Length(Components[i].Name)-Length('ComB')),
               (Components[i] as TComboBox).ItemIndex);
{______в області побудови графіків________}
     55..56: if (Components[i] is TComboBox) then
                ConfigFile.WriteInteger('Graph',
                  Copy(Components[i].Name,Length('ComboBox')+1,
                    Length(Components[i].Name)-Length('ComboBox')),
                  (Components[i] as TComboBox).ItemIndex);
{______в області вибору створюваних колонок________}
    401..499: ConfigFile.WriteInteger('Column',
                Copy(Components[i].Name,Length('ComBDate')+1,
                  Length(Components[i].Name)-Length('ComBDate')),
               (Components[i] as TComboBox).ItemIndex);
   end; //   case Components[i].Tag of
end; // with Form1 do

  ConfigFile.WriteBool('Graph','Nss_N(V)',RadioButtonNssNvM.Checked);
  ConfigFile.WriteBool('Dir','NssN(V)',RadButNssNvM.Checked);

  GraphParameters.WriteToIniFile(ConfigFile);
  GraphParameters.Free;

  Diod_PNShow.Free;
  DiodPN.WriteToIniFile(ConfigFile);
  DiodPN.Free;

  Diod_SchottkyShow.Free;
  Diod.WriteToIniFile(ConfigFile);
  Diod.Free;
  nLayer.Free;
  pLayer.Free;
  FirstLayer.Free;

  ConfigFile.WriteInteger('DLFunction','Name',CBDLFunction.ItemIndex);
  ConfigFile.WriteInteger('DLFunction','SmoothNumber',SpinEditDL.Value);

  if Assigned(BaseLine) then BaseLine.Free;
  if Assigned(BaseLineCur) then BaseLineCur.Free;
  GausLinesSave;
  GausLinesFree;

 VaxFile.Free;
 VaxGraph.Free;
 VaxTemp.Free;
 VaxTempLim.Free;

 ConfigFile.WriteString('Folders','Start',Start_Folder);

 ConfigFile.Free;
 end;

procedure TForm1.FormShow(Sender: TObject);
 var i,j:integer;
begin
  with Form1 do
    begin
      for I := 0 to ComponentCount-1 do
    {--------------------------------------------}
    {малювання штрихів на шкалах}
         if (Components[i] is TTrackBar)and(Components[i].Name<>'TrackBarMar')
            then
              begin
               j:=0;
               repeat
                (Components[i] as TTrackBar).SetTick(j);
                Inc(j,100);
               until (j>1000);
              end;
    end;
end;

procedure TForm1.FullIVClick(Sender: TObject);
begin
 ClearGraph(Form1);
 VaxFile.CopyTo(VaxGraph);
 DataToGraph(Series1,Series2,Graph,'I-V-characteristic',VaxGraph);
 VaxFile.CopyTo(VaxTemp);
end;

function TForm1.GraphType(Sender: TObject): TGraph;
   {повертає значення, яке зв'язане з типом графіку, який
   будується залежно від назви об'єкта Sender}
begin
  Result:=fnEmpty;
  if (TComponent(Sender).Name='RadioButtonM_V') or
     (TComponent(Sender).Name='ButM_V') then Result:=fnPowerIndex;
  if (TComponent(Sender).Name='RadioButtonFN') or
     (TComponent(Sender).Name='ButFow_Nor') then Result:=fnFowlerNordheim;
  if (TComponent(Sender).Name='RadioButtonFNEm') or
     (TComponent(Sender).Name='ButFow_NorE') then Result:=fnFowlerNordheimEm;
  if (TComponent(Sender).Name='RadioButtonAb') or
     (TComponent(Sender).Name='ButAbeles') then Result:=fnAbeles;
  if (TComponent(Sender).Name='RadioButtonAbEm') or
     (TComponent(Sender).Name='ButAbelesE') then Result:=fnAbelesEm;
  if (TComponent(Sender).Name='RadioButtonFP') or
     (TComponent(Sender).Name='ButFr_Pool') then Result:=fnFrenkelPool;
  if (TComponent(Sender).Name='RadioButtonFPEm') or
     (TComponent(Sender).Name='ButFr_PoolE') then Result:=fnFrenkelPoolEm;
  if (TComponent(Sender).Name='RadioButtonLee') or
     (TComponent(Sender).Name='ButLee')  then Result:=fnLee;
  if (TComponent(Sender).Name='RadioButtonKam1') or
     (TComponent(Sender).Name='ButKam1') then Result:=fnKaminskii1;
  if (TComponent(Sender).Name='RadioButtonKam2') or
     (TComponent(Sender).Name='ButKam2') then Result:=fnKaminskii2;
  if (TComponent(Sender).Name='RadioButtonGr1') or
     (TComponent(Sender).Name='ButGr1')  then Result:=fnGromov1;
  if (TComponent(Sender).Name='RadioButtonGr2') or
     (TComponent(Sender).Name='ButGr2')  then Result:=fnGromov2;
  if (TComponent(Sender).Name='Chung') or
     (TComponent(Sender).Name='ButChung')then Result:=fnCheung;
  if (TComponent(Sender).Name='RadioButtonCib') or
     (TComponent(Sender).Name='ButCib')  then Result:=fnCibils;
  if (TComponent(Sender).Name='RadioButtonWer') or
     (TComponent(Sender).Name='ButWer')  then Result:=fnWerner;
  if (TComponent(Sender).Name='RadioButtonForwRs') or
     (TComponent(Sender).Name='ButForwRs')then Result:=fnForwardRs;
  if (TComponent(Sender).Name='RadioButtonN') or
     (TComponent(Sender).Name='ButtonN')  then Result:=fnIdeality;
  if (TComponent(Sender).Name='RadioButtonEx2F') or
     (TComponent(Sender).Name='ButExp2F') then Result:=fnExpForwardRs;
  if (TComponent(Sender).Name='RadioButtonEx2R') or
     (TComponent(Sender).Name='ButExp2R') then Result:=fnExpReverseRs;
  if (TComponent(Sender).Name='Hfunc') or
     (TComponent(Sender).Name='ButHfunc') then Result:=fnH;
  if (TComponent(Sender).Name='Nord') or
     (TComponent(Sender).Name='ButNord')  then Result:=fnNorde;
  if (TComponent(Sender).Name='RadioButtonF_V') then Result:=fnFvsV;
  if (TComponent(Sender).Name='RadioButtonF_I') then Result:=fnFvsI;
  if (TComponent(Sender).Name='RadioButtonMikhAlpha') or
     (TComponent(Sender).Name='ButMAlpha')then Result:=fnMikhelA;
  if (TComponent(Sender).Name='RadioButtonMikhN') or
     (TComponent(Sender).Name='ButMN')    then Result:=fnMikhelIdeality;
  if (TComponent(Sender).Name='RadioButtonMikhRs') or
     (TComponent(Sender).Name='ButMRs')   then Result:=fnMikhelRs;
  if (TComponent(Sender).Name='RadioButtonMikhBetta') or
     (TComponent(Sender).Name='ButMBetta')then Result:=fnMikhelB;
  if (TComponent(Sender).Name='RadioButtonNss') or
     (TComponent(Sender).Name='ButNss')   then Result:=fnDLdensity;
  if (TComponent(Sender).Name='RadioButtonDit') or
     (TComponent(Sender).Name='ButDit')   then Result:=fnDLdensityIvanov;
  if TComponent(Sender).Name='ForIV' then Result:=fnForward;
  if TComponent(Sender).Name='RevIV' then Result:=fnReverse;
  if TComponent(Sender).Name='RB_TauR' then Result:=fnTauR;
  if TComponent(Sender).Name='RB_Igen' then Result:=fnIgen;
  if TComponent(Sender).Name='RB_TauG' then Result:=fnTauG;
  if TComponent(Sender).Name='RB_Irec' then Result:=fnIrec;
  if TComponent(Sender).Name='RB_Tau' then Result:=fnTau;
  if TComponent(Sender).Name='RB_Ldif' then Result:=fnLdif;
end;


procedure TForm1.LabelXLogClick(Sender: TObject);
begin
 XLogCheck.Checked:= not XLogCheck.Checked;
end;

procedure TForm1.LabelYLogClick(Sender: TObject);
begin
 YLogCheck.Checked:= not YLogCheck.Checked;
end;

procedure TForm1.LabRConsClick(Sender: TObject);
begin
 CBoxRCons.Checked:= not CBoxRCons.Checked;
 CBoxDLBuildClick(LabRCons);
end;

procedure TForm1.LDLBuildClick(Sender: TObject);
begin
 CBoxDLBuild.Checked:= not CBoxDLBuild.Checked;
end;

procedure TForm1.ListBoxVoltClick(Sender: TObject);
begin
 if ListBoxVolt.ItemIndex>=0 then ButVoltDel.Enabled:=True;
end;

procedure TForm1.OpenFileClick(Sender: TObject);
 var
  drive:char;
  path, fileName:string;
begin
   Try    ChDir(Directory);
          OpenDialog1.InitialDir:=Directory;
   Except ChDir(Directory0);
          OpenDialog1.InitialDir:=Directory0;
   End;
   if OpenDialog1.Execute()
     then
       begin
{XP Win}
       FormatSettings.DecimalSeparator:='.';
//       DecimalSeparator:='.';
       ProcessPath(OpenDialog1.FileName, drive, path, fileName);
       Directory:=drive + ':' + path;
       CurDirectory:=Directory;
       ChooseDirect(Form1);
       ChDir(Directory);
       DirName.Caption:=Directory;
       VaxFile.ReadFromFile(fileName);
       if VaxFile.IsEmpty then
           begin
           MessageDlg('File '+VaxGraph.name+' has not correct datas',
             mtError, [mbOK], 0);
           Series1.Clear;
           Series2.Clear;
           end;

       if (PageControl1.ActivePageIndex=3)and(RBAveSelect.Checked) then
         begin
           if High(GausLines)<0 then
             begin
               SetLength(GausLines,1);
               GausLines[0]:=TLineSeries.Create(Form1);
               SEGauss.Enabled:=True;
               SGridGaussian.Enabled:=True;
               ButGlDel.Enabled:=True;
               ButGausSave.Enabled:=True;
             end; // if High(GausLines)<0 then
          SetLength(GausLines,High(GausLines)+2);
          GausLines[High(GausLines)]:=TLineSeries.Create(Form1);
          VaxFile.WriteToGraph(GausLines[High(GausLines)]);
          SGridGaussian.RowCount:=SGridGaussian.RowCount+1;
          SGridGaussian.Cells[0,SGridGaussian.RowCount-4]:=
                       IntToStr(High(GausLines));
          SGridGaussian.Cells[1,SGridGaussian.RowCount-4]:=VaxFile.name;

          if SEGauss.Value<>0 then GausLines[SEGauss.Value].SeriesColor:=clNavy;
          GausLines[High(GausLines)].SeriesColor:=clBlue;
          GraphAverage(GausLines,CBoxGLShow.Checked);
          GausLines[High(GausLines)].ParentChart:=Graph;
          GausLines[High(GausLines)].Active:=True;
          SEGauss.MaxValue:=High(GausLines);
          SEGauss.Value:=SEGauss.MaxValue;
          VaxFile.ReadFromGraph(GausLines[0]);
          VaxFile.name:='average';
         end;
         GraphShow(Form1);
       end;
end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin
 case PageControl1.ActivePageIndex of
 1,3:begin
   Graph.Parent:=PageControl1.Pages[PageControl1.ActivePageIndex];
   Close1.Parent:=PageControl1.Pages[PageControl1.ActivePageIndex];
   OpenFile.Parent:=PageControl1.Pages[PageControl1.ActivePageIndex];
   DirLabel.Parent:=PageControl1.Pages[PageControl1.ActivePageIndex];
   DirName.Parent:=PageControl1.Pages[PageControl1.ActivePageIndex];
   Active.Parent:=PageControl1.Pages[PageControl1.ActivePageIndex];
   NameFile.Parent:=PageControl1.Pages[PageControl1.ActivePageIndex];
   Temper.Parent:=PageControl1.Pages[PageControl1.ActivePageIndex];
   ButInputT.Parent:=PageControl1.Pages[PageControl1.ActivePageIndex];
   ButDel.Parent:=PageControl1.Pages[PageControl1.ActivePageIndex];
   DataSheet.Parent:=PageControl1.Pages[PageControl1.ActivePageIndex];
   LabelXlog.Parent:=PageControl1.Pages[PageControl1.ActivePageIndex];
   LabelYlog.Parent:=PageControl1.Pages[PageControl1.ActivePageIndex];
   XlogCheck.Parent:=PageControl1.Pages[PageControl1.ActivePageIndex];
   YlogCheck.Parent:=PageControl1.Pages[PageControl1.ActivePageIndex];
   XlogCheck.Checked:=false;
   YlogCheck.Checked:=false;
   GrType.Parent:=PageControl1.Pages[PageControl1.ActivePageIndex];
   VaxGraph.Clear;
   GraphShow(Form1);
   if PageControl1.ActivePageIndex=1 then FullIV.Checked:=true
                                     else CBoxDLBuild.Checked:=false;
  end;
end;
end;

procedure TForm1.RButGaussianLinesClick(Sender: TObject);
begin
  if not(CBoxGLShow.Checked) then Exit;
  if RButGaussianLines.Checked then GaussianLinesParam;
end;

procedure TForm1.RadioButtonM_VClick(Sender: TObject);
var str:string;
    tg:TGraph;
begin
tg:=GraphType(Sender);
ClearGraph(Form1);
VaxGraph.Clear;
GraphParameters.Rs:=ErResult;
GraphParameters.n:=ErResult;
 if tg in [fnForwardRs,fnIdeality,fnExpForwardRs,fnExpReverseRs]
 then
   if RsDefineCB(VaxFile,Form1.ComboBoxRs,Form1.ComboBoxRs_n)=ErResult
    then
        begin
         str:='Curve'+cnbb+#10'because Rs'+cnbd;
         tg:=fnEmpty;
        end;

 if tg in [fnDLdensity,fnDLdensityIvanov]
 then
   if RsDefineCB(VaxFile,ComboBoxNssRs,ComboBoxNssRs_n)=ErResult
     then
        begin
         str:='Curve'+cnbb+#10'because Rs'+cnbd;
         tg:=fnEmpty;
        end;

 if tg=fnH then
   if nDefineCB(VaxFile,Form1.ComboBoxN,Form1.ComboBoxN_Rs)=ErResult
     then
        begin
         str:='H-function'+cnbb+#10'because n'+cnbd;
         tg:=fnEmpty;
        end;

 if tg=fnDLdensity then
   if FbDefineCB(VaxFile,ComboBoxNssFb,GraphParameters.Rs)=ErResult
     then
        begin
        str:='Curve'+cnbb+#10'because Fb'+cnbd;
        tg:=fnEmpty;
        end;

 GraphParameters.ForForwardBranch:=CheckBoxM_V.Checked;
 GraphParameters.NssType:=RadioButtonNssNvD.Checked;
 GraphParameters.Diapazon:=D[ConvertTGraphToTDiapazons(tg)];

 if tg<>fnEmpty then str:=GraphName(tg);
 VaxFile.GraphCalculation(VaxGraph,tg);

if VaxGraph.IsEmpty then
    MessageDlg(GraphErrorMessage(tg), mtError, [mbOK], 0)
                 else
    DiapToLimToTForm1(D[ConvertTGraphToTDiapazons(tg)],Form1);

ShowGraph(Form1,str);
end;

procedure TForm1.RadioButtonM_VDblClick(Sender: TObject);
begin
 MessageDlg(GraphHint(GraphType(Sender)), mtInformation,[mbOk],0);
end;

procedure TForm1.RBAveSelectClick(Sender: TObject);
var i:integer;
begin

if RBAveSelect.Checked then
 begin
   ButGLLoad.Visible:=False;
   ButGLRes.Visible:=False;

   CBoxGLShow.Caption:='Minus';

   CBoxGLShow.OnClick:=nil;
   CBoxGLShow.Checked:=False;
   CBoxGLShow.OnClick:=CBoxGLShowClickAve;

   GausLinesSave;
   GausLinesFree;

   SGridGaussian.ColCount:=2;
   SGridGaussian.RowCount:=4;
   for I := 0 to 3 do SGridGaussian.Rows[i].Clear;
   SGridGaussian.Cells[0,0]:='N';
   SGridGaussian.Cells[1,0]:='File Name';
   SGridGaussian.ColWidths[0]:=30;
   SGridGaussian.ColWidths[1]:=100;
   SGridGaussian.Width:=150;
   SGridGaussian.Left:=120;

   ButGausSave.Caption:='Save Average';
   GrBoxGaus.Caption:='Lines for Averaging';

   GraphShow(Form1);
   ButGLAdd.Enabled:=True;
   CBoxGLShow.Enabled:=True;
   CBoxGLShow.Tag:=0;
 end
                       else
 begin
   ButGLLoad.Visible:=True;
   ButGLRes.Visible:=True;
   CBoxGLShow.Caption:='Show';
   CBoxGLShow.OnClick:=nil;
   CBoxGLShow.Checked:=False;
   CBoxGLShow.OnClick:=CBoxGLShowClickGaus;
   CBoxGLShow.Tag:=56;

   SGridGaussian.ColCount:=6;
   SGridGaussian.RowCount:=4;
   for I := 0 to 3 do SGridGaussian.Rows[i].Clear;
   SGridGaussian.Cells[0,0]:='N';
   SGridGaussian.Cells[1,0]:='U0';
   SGridGaussian.Cells[2,0]:='Et';
   SGridGaussian.Cells[3,0]:='Deviation';
   SGridGaussian.Cells[4,0]:='Max Value';
   SGridGaussian.Cells[5,0]:='Quota';
   SGridGaussian.ColWidths[0]:=20;
   SGridGaussian.ColWidths[1]:=32;
   SGridGaussian.ColWidths[2]:=32;
   SGridGaussian.ColWidths[3]:=50;
   SGridGaussian.ColWidths[4]:=50;
   SGridGaussian.ColWidths[5]:=45;
   SGridGaussian.Width:=255;
   SGridGaussian.Left:=93;

   ButGausSave.Caption:='Save Gaussian';
   GrBoxGaus.Caption:='Gaussian Lines';

   GausLinesFree;
   GraphShow(Form1);
   CompEnable(Form1,700,CBoxGLShow.Checked);
   SEGauss.Value:=0;
 end

end;

procedure TForm1.RBLineClick(Sender: TObject);
begin
 Series1.Active:=False;
 Series2.Active:=True;
end;

procedure TForm1.RBPointClick(Sender: TObject);
begin
 Series1.Active:=True;
 Series2.Active:=False;
end;

procedure TForm1.RBPointLineClick(Sender: TObject);
begin
 Series1.Active:=True;
 Series2.Active:=True;
end;

procedure TForm1.RButBaseLineClick(Sender: TObject);
begin
  if not(CBoxBaseLineVisib.Checked) then Exit;
  if RButBaseLine.Checked then BaseLineParam;
end;

procedure TForm1.RdGrMaxClick(Sender: TObject);
begin
 if RdGrMax.ItemIndex=GrLim.MaxXY
    then Exit
    else
     begin
       GrLim.MaxXY:=RdGrMax.ItemIndex;
       LimitSetup(GrLim, RdGrMin, RdGrMax, LabelMin, LabelMax);
     end;
end;

procedure TForm1.RdGrMinClick(Sender: TObject);
begin
 if RdGrMin.ItemIndex=GrLim.MinXY
    then Exit
    else
     begin
       GrLim.MinXY:=RdGrMin.ItemIndex;
       LimitSetup(GrLim, RdGrMin, RdGrMax, LabelMin, LabelMax);
     end;
end;

procedure TForm1.SButFitNewClick(Sender: TObject);
begin
 if SButFitNew.Down then
  begin
    FitFunctionNew:=FitFunctionFactory(SButFitNew.Caption);
    if FitFunctionNew=nil then Exit;
    if (FitFunctionNew is TFFSimpleLogEnable) then
        (FitFunctionNew as TFFSimpleLogEnable).SetAxisScale(XLogCheck.Checked,
                                                            YLogCheck.Checked);
    FitFunctionNew.FittingToGraphAndFile(VaxGraph,Series4,CB_SFF.Checked);

    if not(FitFunctionNew.ResultsIsReady) then Exit;
    Series4.Active:=True;
    MemoAppr.Lines.Add('');
    if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
    MemoAppr.Lines.Add(SButFitNew.Caption);
    FitFunctionNew.DataToStrings(MemoAppr.Lines);

    FitFunctionNew.Free;
//      showmessage('nnnn6');

  end  //if SButFit.Down then
   else Series4.Active:=False;
end;

procedure TForm1.SEGaussChange(Sender: TObject);
 var i:integer;
begin
 if High(GausLines)<0 then Exit;
 if SEGauss.Value=0 then
    begin
    SEGauss.Value:=1;
    Exit;
    end;

 if SEGauss.Value>SEGauss.MaxValue then
    begin
    SEGauss.Value:=SEGauss.MaxValue;
    Exit;
    end;

 if (RButGaussianLines.Checked)and(RBGausSelect.Checked)  then GaussianLinesParam;
 for i:=1 to High(GausLines) do
   GausLines[i].SeriesColor:=clNavy;
 GausLines[SEGauss.Value].SeriesColor:=clBlue;
 Graph.RemoveSeries(GausLines[SEGauss.Value]);
 GausLines[SEGauss.Value].ParentChart:=Graph;
 if RBGausSelect.Checked then
       GaussLinesToGrid
                         else
      begin
       SGridGaussian.Visible:=False;
       SGridGaussian.Visible:=True;
      end;
end;


procedure TForm1.SGridGaussianDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
if (ACol>0) and (ARow=SEGauss.Value)and(SEGauss.Enabled=True) and (ARow>0) then
   begin
   SGridGaussian.Canvas.Brush.Color:=RGB(183,255,183);
   SGridGaussian.Canvas.FillRect(Rect);
   SGridGaussian.Canvas.TextOut(Rect.Left+2,Rect.Top+2,SGridGaussian.Cells[Acol,Arow]);
   end
end;

procedure TForm1.SGridGaussianSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  CanSelect:=false;
  if (ARow>0)and(ARow<SGridGaussian.RowCount-3) then SEGauss.Value:=Arow;
end;

//procedure TForm1.SomethingForCastro;
//// const
//// par:array [0..1] of double=
////   (1.2,2);
// var Par1,Par2,Par3:array of double;
//     Vec:TVector;
//     x:double;
//begin
// {значення параметрів з pssA_219_2100403}
// SetLength(Par1,9);
// Par1[0]:=1.6e-9;
// Par1[1]:=1.92;
// Par1[2]:=190;
// Par1[3]:=1.6e-4;
// Par1[4]:=1.92;
// Par1[5]:=190;
// Par1[6]:=45;
// Par1[7]:=8e-3;
// Par1[8]:=300;
// SetLength(Par2,9);
// Par2[0]:=2e-12;
// Par2[1]:=1;
// Par2[2]:=150;
// Par2[3]:=6e-4;
// Par2[4]:=3;
// Par2[5]:=840;
// Par2[6]:=53;
// Par2[7]:=9e-3;
// Par2[8]:=300;
// SetLength(Par3,9);
// Par3[0]:=5.84e-5;
// Par3[1]:=6.44;
// Par3[2]:=41.2;
// Par3[3]:=1.21e-4;
// Par3[4]:=2.49;
// Par3[5]:=191;
// Par3[6]:=0;
// Par3[7]:=6.49e-3;
// Par3[8]:=300;
//// SetLength(Par3,9);
//// Par3[0]:=1.5e-5;
//// Par3[1]:=2.4;
//// Par3[2]:=1e8;
//// Par3[3]:=2.4e-7;
//// Par3[4]:=9.5;
//// Par3[5]:=4.6e4;
//// Par3[6]:=0;
//// Par3[7]:=4.85e-5;
//// Par3[8]:=300;
//
//// showmessage(floattostr(CastroIV_onV(0,Par3,-0.01,0.001)));
//// x:=-2e-3;
//// showmessage(floattostr(CastroIV(x,Par2))+'  '+
////             floattostr(CastroIV2(x,Par2)));
//// showmessage(floattostr(Lambert(1e6)));
//  Vec:=TVector.Create;
//  CastroIV_Creation(Vec,Par1,0.8);
//////  x:=-5.5e-3;
////    x:=0;
////  repeat
//////   Vec.Add(CastroIV2(x,Par3),x);
////   Vec.Add(x,CastroIV_onV(x,Par1,-0.01,0.01));
////   x:=x+0.01;
//////     x:=x+10;
////  until x>0.8;
//////  until x>1000;
//  Vec.WriteToFile('Gfun100.dat',5);
//  FreeAndNil(Vec);
//end;

procedure TForm1.SpButLimitClick(Sender: TObject);
begin
  MarkerHide(Form1);
  CBMarker.Checked:=False;

 if SpButLimit.Down then
    begin
      VaxGraph.CopyTo(VaxTempLim);
      VaxTempLim.CopyDiapazonPoint(VaxGraph,GrLim,VaxFile);
      if VaxGraph.IsEmpty then
                begin
                  VaxTempLim.CopyTo(VaxGraph);
                  SpButLimit.Down:=False;
                  Exit;
                end;
    end
                    else  VaxTempLim.CopyTo(VaxGraph);

  DataToGraph(Series1,Series2,Graph,Graph.Title.Text.Strings[0],VaxGraph);
end;



procedure TForm1.SpectrApprox;
  var
  drive:char;
  path, fileName, Dir:string;
  Vec:TVectorTransform;
  Vec2:TVector;
  i,j:integer;
begin
   if OpenDialog1.Execute()
     then
       begin
       FormatSettings.DecimalSeparator:='.';
       Vec:=TVectorTransform.Create;
       Vec2:=TVector.Create;
       ProcessPath(OpenDialog1.FileName, drive, path, fileName);
       Dir:=drive + ':' + path;
       ChDir(Dir);
       Vec.ReadFromFile(fileName,[2,3]);
       Vec.Splain3(Vec2,3845,5);
       for I := 0 to Vec2.HighNumber do
        if Vec2.X[i]>8505 then
          for j:= Vec2.HighNumber downto i do
             Vec2.DeletePoint(j);

//       for I := 0 to Vec2.HighNumber do
//        Vec2.Y[i]:=Silicon.Absorption(Vec2.X[i]/10,340);
//       Vec2.WriteToFile('Absorb.dat',6,'Lambda Absorb');
//       for I := 0 to Vec2.HighNumber do
//        Vec2.Y[i]:=1/Vec2.Y[i];
//       Vec2.WriteToFile('Absorb2.dat',6,'Lambda Absorb1');

       Vec2.AdditionY(-Vec2.MinY);
       Vec2.MultiplyY(1/Vec2.MaxY);
       Vec2.WriteToFile(FitName(Vec,'N'),4,'Lambda ArbUnit');
//       Vec2.WriteToFile(ChangeFileExt(fileName, '')+'N.dat',4,'Lambda ArbUnit');
       for I := 0 to Vec2.HighNumber do
        Vec2.Y[i]:=Vec2.X[i]*Vec2.Y[i];
       Vec2.MultiplyY(1/Vec2.MaxY);
       Vec2.WriteToFile(FitName(Vec,'Nph'),6,'Lambda ArbUnit');
       FreeAndNil(Vec2);
       FreeAndNil(Vec);
       end;
end;

procedure TForm1.SpectrCreate;
 type TLampType=(ltGE,ltOrion,ltOsram);

var Slide:TVectorTransform;
    OutputData:TArrSingle;
    Arr:TArrSingle;
    i,j,PointCount:integer;
    MeasuredSpectr,CreatedSpectr:array of TVector;
    LampType:TLampType;
const
  MSCount:array[TLampType]of byte=
   (2,2,3);
  CSCount:array[TLampType]of byte=
   (3,7,6);
  Lambdas :array[0..6] of integer=
  (200,300,400,500,600,700,750);
  FileNameBegin:array[TLampType]of string=
   ('GE_','orion_','osram');

begin
  ChDir('D:\Samples\DeepL\2022\Lamps\Spectrs');
  Slide:=TVectorTransform.Create;
  LampType:=ltGE;
//  LampType:=ltOrion;
//  LampType:=ltOsram;
  SetLength(MeasuredSpectr,MSCount[LampType]);
  for I := 0 to High(MeasuredSpectr) do
    MeasuredSpectr[i]:=TVector.Create;

  SetLength(CreatedSpectr,CSCount[LampType]);
  for I := 0 to High(CreatedSpectr) do
    CreatedSpectr[i]:=TVector.Create;

 case LampType of
   ltGE: begin
          MeasuredSpectr[0].ReadFromFile('GE62N.dat');
          MeasuredSpectr[1].ReadFromFile('GE68N.dat');
      //  MeasuredSpectr1.ReadFromFile('GE62Nph.dat');
      //  MeasuredSpectr2.ReadFromFile('GE68Nph.dat');
          Slide.Add(246,246);
          Slide.Add(398,398);
         end;
   ltOrion: begin
            MeasuredSpectr[0].ReadFromFile('orion6N.dat');
            MeasuredSpectr[1].ReadFromFile('orion69N.dat');
        //  MeasuredSpectr1.ReadFromFile('orion6Nph.dat');
        //  MeasuredSpectr2.ReadFromFile('orion69Nph.dat');
            Slide.Add(338,338);
            Slide.Add(670,670);
            end;
   ltOsram: begin
            MeasuredSpectr[0].ReadFromFile('osram7N.dat');
            MeasuredSpectr[1].ReadFromFile('osram8N.dat');
            MeasuredSpectr[1].ReadFromFile('osram9N.dat');
        //  MeasuredSpectr1.ReadFromFile('osram7Nph.dat');
        //  MeasuredSpectr2.ReadFromFile('osram8Nph.dat');
        //  MeasuredSpectr2.ReadFromFile('osram9Nph.dat');
            Slide.Add(180,180);
            Slide.Add(361,361);
            Slide.Add(649,649);
            end;
 end;

  PointCount:=MeasuredSpectr[0].HighNumber;
  showmessage(inttostr(PointCount));


  for I := 0 to PointCount do
   begin
    for j := 0 to High(MeasuredSpectr) do
     Slide.Y[j]:=MeasuredSpectr[j].Y[i];
    case LampType of
      ltGE,ltOrion: Slide.LinAprox(OutputData);
      ltOsram: Slide.ParabAprox(OutputData);
    end;
    for j := 0 to High(CreatedSpectr) do
     CreatedSpectr[j].Add(MeasuredSpectr[0].X[i],max(NPolinom(Lambdas[j],OutputData),0));
   end;

  SetLength(Arr,PointCount+1);

//  for I := 0 to High(CreatedSpectr) do
//    CreatedSpectr[i].WriteToFile(FileNameBegin[LampType]+'N'+Inttostr(Lambdas[i])+'.dat',
//                                 6,'Lambda ArbUnit');
//  for I := 0 to High(CreatedSpectr) do
//    CreatedSpectr[i].WriteToFile(FileNameBegin[LampType]+'Nph'+Inttostr(Lambdas[i])+'.dat',
//                                 6,'Lambda ArbUnit');

  for j := 0 to High(CreatedSpectr) do
   begin
    for I := 0 to PointCount do
      Arr[i]:=CreatedSpectr[j].Y[i];
    NormalArray(Arr);
    for I := 0 to PointCount do
      CreatedSpectr[j].Y[i]:=Arr[i]*Lambdas[j];
    {потужність випромінювання, мВт}

   for I := 0 to PointCount do
    CreatedSpectr[j].Y[i]:=CreatedSpectr[j].X[i]*CreatedSpectr[j].Y[i]*1e-10/3e8/6.63e-34*1e-3;
   {кількість фотонів за секунду}

   for I := 0 to PointCount do
    try
    CreatedSpectr[j].Y[i]:=IntegralRomberg(Bowden2,[60.2,340,1.36e21,CreatedSpectr[j].Y[i],CreatedSpectr[j].X[i]*10],0,380e-6)
                           /IntegralRomberg(Bowden,[60.2,340,1.36e21,CreatedSpectr[j].Y[i],CreatedSpectr[j].X[i]*10],0,380e-6);
    except
     CreatedSpectr[j].Y[i]:=0;
    end;

   CreatedSpectr[j].WriteToFile(FileNameBegin[LampType]+Inttostr(Lambdas[i])+'s.dat',
                               6,'Lambda ArbUnit');
//   for I := 0 to PointCount do
//        CreatedSpectr[j].Y[i]:=CreatedSpectr[j].X[i]*CreatedSpectr[j].Y[i];
//   CreatedSpectr400.WriteToFile(FileNameBegin[LampType]+Inttostr(Lambdas[i])+'sNph.dat',
//                              6,'Lambda ArbUnit');
   end;




  FreeAndNil(Slide);

  for I := 0 to High(MeasuredSpectr) do
    FreeAndNil(MeasuredSpectr[i]);
  SetLength(CreatedSpectr,CSCount[LampType]);
  for I := 0 to High(CreatedSpectr) do
    FreeAndNil(CreatedSpectr[i]);

end;

procedure TForm1.StartFolderSelectClick(Sender: TObject);
begin
  if SelectDirectory('Choose Start Directory','', Start_Folder)
   then StartFoldersToForm;
end;

procedure TForm1.TrackBarMarChange(Sender: TObject);
begin
  MarkerDraw(VaxGraph,VaxFile,TrackBarMar.Position,Form1);
end;

procedure TForm1.TrackPanAChange(Sender: TObject);
 var bool:boolean;
     i:integer;
begin
 if (RButBaseLine.Checked) and (CBoxBaseLineVisib.Checked) then
   begin
    bool:=CBoxBaseLineUse.Checked;
    if bool then CBoxBaseLineUse.Checked:=False;
    if (Sender as TWinControl).Parent.Name='PanelA' then
      begin
    BaseLineCur.A:=ToNumber(TrackPanA,SpinEditPanA,CBoxPanA);
    LPanAA.Caption:=FloatToStrF(BaseLineCur.A, ffExponent, 3, 1);
    LBaseLineA.Caption:='A = '+LPanAA.Caption;
      end;
    if (Sender as TWinControl).Parent.Name='PanelB' then
      begin
    BaseLineCur.B:=ToNumber(TrackPanB,SpinEditPanB,CBoxPanB);
    LPanBB.Caption:=FloatToStrF(BaseLineCur.B, ffExponent, 3, 1);
    LBaseLineB.Caption:='B = '+LPanBB.Caption;
      end;
    if (Sender as TWinControl).Parent.Name='PanelC' then
      begin
    BaseLineCur.C:=ToNumber(TrackPanC,SpinEditPanC,CBoxPanC);
    LPanCC.Caption:=FloatToStrF(BaseLineCur.C, ffExponent, 3, 1);
    LBaseLineC.Caption:='C = '+LPanCC.Caption;
      end;
    BaseLine.Clear;
    GraphFill(BaseLine,BaseLineCur.Parab,
                Series1.MinXValue,Series1.MaxXValue,150);
    BaseLine.Active:=true;
    if bool then CBoxBaseLineUse.Checked:=True;
   end;

 if (RButGaussianLines.Checked) and (CBoxGLShow.Checked) then
   begin
    if (Sender as TWinControl).Parent.Name='PanelA' then
      begin
    GausLinesCur[SEGauss.Value].A:=ToNumber(TrackPanA,SpinEditPanA,CBoxPanA);
    LPanAA.Caption:=FloatToStrF(GausLinesCur[SEGauss.Value].A,ffExponent,3,2);
      end;
    if (Sender as TWinControl).Parent.Name='PanelB' then
      begin
    GausLinesCur[SEGauss.Value].B:=ToNumber(TrackPanB,SpinEditPanB,CBoxPanB);
    LPanBB.Caption:=FloatToStrF(GausLinesCur[SEGauss.Value].B,ffFixed,3,2);
      end;
    if (Sender as TWinControl).Parent.Name='PanelC' then
      begin
    GausLinesCur[SEGauss.Value].C:=ToNumber(TrackPanC,SpinEditPanC,CBoxPanC);
    LPanCC.Caption:=FloatToStrF(GausLinesCur[SEGauss.Value].C,ffExponent,3,2) ;
      end;

    if not(GausLinesCur[SEGauss.Value].is_Gaus) then Exit;

    for I := 0 to GausLines[SEGauss.Value].Count-1 do
      GausLines[SEGauss.Value].YValue[i]:=
         GausLinesCur[SEGauss.Value].GS(GausLines[SEGauss.Value].XValue[i]);
    GraphSum(GausLines);
    GaussLinesToGrid;
   end;
end;

procedure TForm1.XLogCheckClick(Sender: TObject);
 var temp:TVector;
begin
 ClearGraphLog(Form1);
 if XLogCheck.Checked then
  begin
   temp:=TVector.Create;
   VaxGraph.PositiveX(temp);
   if temp.IsEmpty then
                begin
                 XLogCheck.Checked:=False;
                 MessageDlg('No points on the graph have positive abscissa',
                            mtError, [mbOK], 0);
                 Exit;
                end;
   temp.CopyTo(VaxGraph);
   DataToGraph(Series1,Series2,Graph,Graph.Title.Text.Strings[0],VaxGraph);
   Graph.BottomAxis.Logarithmic:=True;
   temp.Free;
  end;

 if not(XLogCheck.Checked) then
  begin
   if YLogCheck.Checked then VaxTemp.PositiveY(VaxGraph);
   if not(YLogCheck.Checked) then VaxTemp.CopyTo(VaxGraph);
   DataToGraph(Series1,Series2,Graph,Graph.Title.Text.Strings[0],VaxGraph);
   Graph.BottomAxis.Logarithmic:=False;
  end;
end;

procedure TForm1.YLogCheckClick(Sender: TObject);
 var temp:TVector;
begin
 ClearGraphLog(Form1);
 if YLogCheck.Checked then
  begin
   temp:=TVector.Create;
   VaxGraph.AbsY(temp);
   if temp.IsEmpty then
                begin
                 YLogCheck.Checked:=False;
                 MessageDlg('Any points on the graph have non-positive ordinate',
                            mtError, [mbOK], 0);
                 Exit;
                end;
   temp.CopyTo(VaxGraph);
   DataToGraph(Series1,Series2,Graph,Graph.Title.Text.Strings[0],VaxGraph);
   Graph.LeftAxis.Logarithmic:=True;
   temp.Free;
  end;

 if not(YLogCheck.Checked) then
  begin
   if XLogCheck.Checked then VaxTemp.PositiveX(VaxGraph);
   if not(XLogCheck.Checked) then VaxTemp.CopyTo(VaxGraph);
   DataToGraph(Series1,Series2,Graph,Graph.Title.Text.Strings[0],VaxGraph);
   Graph.LeftAxis.Logarithmic:=False;
  end;
end;

procedure TForm1.AbsorbFileForSCAPS;
 var T,lambda:integer;
     SC:TStringList;

begin
 SC:=TStringList.Create;

// T:=287;
 T:=270;
 repeat
  SC.Clear;
  lambda:=250;
  SC.Add('/absorption data for Si');
  SC.Add('/from Martin A. Green / Prog Photovolt Res Appl.30, 164–179 (2022)');
  SC.Add('/lambda[nm]	alfa[m^-1]');
  repeat
   SC.Add(Inttostr(lambda)+'  '
          +FloatToStrF(Silicon.Absorption(lambda,T),ffExponent,4,2));
   lambda:=lambda+10;
  until lambda>1450;
  SC.SaveToFile('S'+Copy(inttostr(round(T)),2,2)+'.abs');
  T:=T+1;
// until T>342;
 until T>271;
 FreeAndNil(SC);
end;

procedure TForm1.ActionDoClick(Sender: TObject);
 var Key,Dat_Folder:string;
begin
 Key:=CBActions.Items[CBActions.ItemIndex];

 if SelectDirectory('Choose Directory',L_StartFolder.Caption, Dat_Folder)
  then
   begin
   if Key=YZrizName
      then YZriz([0.02,0.1,1,3,5,8,10,15,22,30],Dat_Folder,True);
   if Key=CVReverseName
      then CVReverse(Dat_Folder);
   if Key=IVmanipulateName
      then IVmanipulate(Dat_Folder);
   if Key=DatToEisName
      then DatToEis(Dat_Folder);
   if Key=ISresultTransformName
      then ISresultTransform(Dat_Folder);
   if Key=CFTransformName
      then CFTransform(Dat_Folder);
   if Key=SomeThingName
//      then IVfittingResultCollect(Dat_Folder);
      then GausPeretvor(Dat_Folder);
   end
  else Exit;

end;

procedure TForm1.ApproxHide;
begin
  SButFitNew.Down:=False;
  Series4.Active:=False;
end;

procedure TForm1.BApprClearClick(Sender: TObject);
begin
 MemoAppr.Clear;
end;

procedure TForm1.BMarAddClick(Sender: TObject);
var st:string;
begin
  SGMarker.RowCount:=SGMarker.RowCount+1;
  SGMarker.Cells[0,SGMarker.RowCount-4]:=IntToStr(SGMarker.RowCount-4);
  st:=VaxGraph.name;
  delete(st,LastDelimiter('.',VaxGraph.name),4);
  SGMarker.Cells[1,SGMarker.RowCount-4]:=st;
  SGMarker.Cells[2,SGMarker.RowCount-4]:=
   FloatToStrF(VaxFile.X[TrackBarMar.Position+VaxGraph.N_begin],ffGeneral,4,3);
  SGMarker.Cells[3,SGMarker.RowCount-4]:=
   FloatToStrF(VaxFile.Y[TrackBarMar.Position+VaxGraph.N_begin],ffExponent,3,2);
end;

procedure TForm1.BmarClearClick(Sender: TObject);
 var i:integer;
begin
  SGMarker.RowCount:=4;
  for I := 1 to 3 do SGMarker.Rows[i].Clear;
end;

procedure TForm1.ButAveLeftClick(Sender: TObject);
begin
  GaussLinesToGraph(False);
  if(Sender is TButton)and((Sender as TButton).Caption='<')
      then  GraphAverage(GausLines,CBoxGLShow.Checked, 0.002,SEGauss.Value,-0.002);
  if(Sender is TButton)and((Sender as TButton).Caption='>')
      then  GraphAverage(GausLines,CBoxGLShow.Checked, 0.002,SEGauss.Value,0.002);
  GaussLinesToGraph(True);
  VaxFile.ReadFromGraph(GausLines[0]);
  GraphShow(Form1);
end;

procedure TForm1.ButBaseLineResetClick(Sender: TObject);
begin
 if CBoxBaseLineUse.Checked then CBoxBaseLineUse.Checked:=False;
 BaseLineCur.A:=Series1.MinYValue;
 BaseLineCur.B:=0;
 BaseLineCur.C:=0;
 BaseLine.Clear;
 GraphFill(BaseLine,BaseLineCur.Parab,
                   Series1.MinXValue,Series1.MaxXValue,150);
 if RButBaseLine.Checked then BaseLineParam;
end;

procedure TForm1.ButDelClick(Sender: TObject);
var //I:integer;
    filename:string;
    i:TDateTime;
begin
 if MessageDlg('Are you sure?'#10#13'The selected data removing is irreversible!',
                 mtWarning,mbOkCancel,0)=mrOK
  then
   begin
   VaxFile.DeletePoint(SelectedRow-1);
   ChDir(Directory);
   CurDirectory:=Directory;
   ChooseDirect(Form1);
   filename:=VaxFile.name;
//   i:=FileAge(filename);
   FileAge(filename,i);
//   ShowMessage(DateToStr(i));
   VaxFile.WriteToFile(filename);
//   if i>-1 then FileSetDate(filename,i);
   if i>-1 then FileSetDate(filename,DateTimeToFileDate(i));
   VaxFile.ReadFromFile(filename);
   GraphShow(Form1);
   end;
end;

procedure TForm1.ButFitOptionClick(Sender: TObject);
var
    str:string;
begin
str:='None';
if (Sender is TButton)and((Sender as TButton).Name='ButFitOption')
     then  str:=SButFitNew.Caption;
if (Sender is TButton)and((Sender as TButton).Name='ButLDFitOption')
     then  str:=LabIsc.Caption;
if (Sender is TButton)and((Sender as TButton).Name='ButDateOption')
     then  str:=LDateFun.Caption;

FitFunctionNew:= FitFunctionFactory(str);
if  not(Assigned(FitFunctionNew)) then Exit;

FitFunctionNew.SetParametersGR;
FreeAndNil(FitFunctionNew);
end;

procedure TForm1.ButFitOptionNewClick(Sender: TObject);
var
    str:string;
begin
str:='None';
if (Sender is TButton) then
  begin
  if (Sender as TButton).Name='ButFitOptionNew'
         then  str:=SButFitNew.Caption;
  if (Sender as TButton).Name='ButLDFitOption'
         then  str:=LabIsc.Caption;
  if (Sender as TButton).Name='ButDateOption'
        then  str:=LDateFun.Caption;
  end;

FitFunctionNew:=FitFunctionFactory(str);
if  not(Assigned(FitFunctionNew)) then Exit;

FitFunctionNew.SetParametersGR;
FreeAndNil(FitFunctionNew);
end;

procedure TForm1.ButFitSelectNewClick(Sender: TObject);
begin
 if FormSFNew.ShowModal=mrOk then
  begin
   if (Sender is TButton)and((Sender as TButton).Name='ButFitSelectNew')
     then
       begin
       SButFitNew.Caption:=FormSFNew.SelectedString;
       ButFitOptionNew.Enabled:=(SButFitNew.Caption<>'None');
       ApproxHide;
       end;
   if (Sender is TButton)and((Sender as TButton).Name='ButDateSelect')
     then
       begin
       LDateFun.Caption:=FormSFNew.SelectedString;;
       CBDateFun.Checked:=False;
       ButDateOption.Enabled:=(LDateFun.Caption<>'None')
       end;
  end;
end;

procedure TForm1.ButGausSaveClick(Sender: TObject);
var i,j:integer;
    Str:TStringList;
    str2:string;
begin
if RBAveSelect.Checked then
 begin
   SaveDialog1.FileName:='average.dat';
   if SaveDialog1.Execute() then
      VaxFile.WriteToFile(SaveDialog1.FileName);
 end  // if RBAveSelect.Checked then
                       else  // if RBAveSelect.Checked
 begin
 SaveDialog1.FileName:=copy(VaxFile.name,1,length(VaxFile.name)-4)+'gl.dat';
   if SaveDialog1.Execute()
     then
       begin
       Str:=TStringList.Create;

       for i:=0 to  Graph.Series[1].Count-1 do
          Str.Add(FloatToStrF(Graph.Series[1].XValue[i],ffExponent,4,0)+' '+
                  FloatToStrF(Graph.Series[1].YValue[i],ffExponent,4,0));
       Str.SaveToFile(copy(SaveDialog1.FileName,1,length(SaveDialog1.FileName)-4)+'dt.dat');
       str.Clear;
       for I := 0 to GausLines[0].Count-1 do
         begin
          str2:=FloatToStrF(GausLines[0].XValue[i],ffExponent,4,0);
          for j := 0 to High(GausLines) do
            str2:=str2+' '+FloatToStrF(GausLines[j].YValue[i],ffExponent,4,0);
          Str.Add(str2);
         end;
        Str.SaveToFile(SaveDialog1.FileName);
        str.Clear;
        for j := 1 to High(GausLinesCur) do
          Str.Add(SGridGaussian.Cells[1,j]+' '+
                  SGridGaussian.Cells[2,j]+' '+
                  SGridGaussian.Cells[3,j]+' '+
                  SGridGaussian.Cells[4,j]+' '+
                  SGridGaussian.Cells[5,j]);
        str2:=copy(SaveDialog1.FileName,1,length(SaveDialog1.FileName)-3)+'inf';
        Str.SaveToFile(str2);
        Str.Free;
       end;
 end;  // else if RBAveSelect.Checked
end;

procedure TForm1.ButGLAddClick(Sender: TObject);
var i:integer;
begin
if RBAveSelect.Checked then
  begin
    OpenFileClick(Self);
  end  // then RBAveSelect.Checked
                      else
 begin
 SetLength(GausLinesCur,High(GausLinesCur)+2);
 GausLinesCur[High(GausLinesCur)]:= Curve3.Create((Series1.MaxYValue-Series1.MinYValue)/2,
              (Series1.MaxXValue+Series1.MinXValue)/2,
              (Series1.MaxXValue-Series1.MinXValue)/4);
  SetLength(GausLines,High(GausLines)+2);
  GausLines[High(GausLines)]:=TLineSeries.Create(Form1);
  GausLines[High(GausLines)].SeriesColor:=clBlue;
  GausLines[SEGauss.Value].SeriesColor:=clNavy;

  for I := 0 to GausLines[1].Count - 1 do
     GausLines[High(GausLines)].AddXY(GausLines[1].XValue[i],
         GausLinesCur[High(GausLines)].GS(GausLines[1].XValue[i]));
   Graph.RemoveSeries(GausLines[0]);
   GraphSum(GausLines);

   GausLines[0].ParentChart:=Graph;
   GausLines[High(GausLines)].ParentChart:=Graph;
   GausLines[High(GausLines)].Active:=True;
   SEGauss.MaxValue:=High(GausLines);
   SEGauss.Value:=SEGauss.MaxValue;

   GaussLinesToGrid;
 end; // else  RBAveSelect.Checked
end;

procedure TForm1.ButGLAutoClick(Sender: TObject);
var tempVector:TVector;
    i:integer;
begin
 try
  tempVector:=TVector.Create;
 except
  Exit;
 end;

 try
  tempVector.ReadFromGraph((Graph.Series[1] as TLineSeries));
 except
  tempVector.Free;
  Exit;
 end;

 FitFunctionNew:=TFFNGausian.Create;
 (FitFunctionNew as TFFNGausian).NGaus:=SEGauss.MaxValue;

 for I := 1 to SEGauss.MaxValue do
  begin
   GausLinesCur[i].A:=(FitFunctionNew as TFFNGausian).ParamsHeuristic.OutputData[3*i-3];
   GausLinesCur[i].B:=(FitFunctionNew as TFFNGausian).ParamsHeuristic.OutputData[3*i-2];
   GausLinesCur[i].C:=(FitFunctionNew as TFFNGausian).ParamsHeuristic.OutputData[3*i-1];
  end;

 FreeAndNil(FitFunctionNew);
 tempVector.Free;
 ButGLResClick(Sender);
 SEGaussChange(Sender);
end;

procedure TForm1.ButGLDelClick(Sender: TObject);
var i:integer;
begin
if RBAveSelect.Checked then
 begin
  if High(GausLines)=1 then Exit;
 GaussLinesToGraph(False);
 for I := SEGauss.Value to High(GausLines)-1 do
     begin
     GausLines[i].AssignValues(GausLines[i+1]);
     SGridGaussian.Cells[1,i]:=SGridGaussian.Cells[1,i+1];
     end;
  GausLines[High(GausLines)].Free;
  SetLength(GausLines,High(GausLines));

  GaussLinesToGraph(True);
  GraphAverage(GausLines,CBoxGLShow.Checked);
  VaxFile.ReadFromGraph(GausLines[0]);
  GraphShow(Form1);

  SGridGaussian.Rows[SEGauss.MaxValue].Clear;
  SGridGaussian.RowCount:=SGridGaussian.RowCount-1;


  if SEGauss.Value=SEGauss.MaxValue then  SEGauss.Value:=SEGauss.Value-1;
  SEGauss.MaxValue:=SEGauss.MaxValue-1;
 end // if RBAveSelect.Checked then
                       else
 begin
 if High(GausLines)=1 then
       begin
         CBoxGLShow.Checked:=false;
         Exit;
       end;
 GaussLinesToGraph(False);
 for I := SEGauss.Value to High(GausLines)-1 do
   begin
     GausLines[i].AssignValues(GausLines[i+1]);
     GausLinesCur[i].Copy(GausLinesCur[i+1]);
   end;
  GausLines[High(GausLines)].Free;
  GausLinesCur[High(GausLinesCur)].Free;
  SetLength(GausLines,High(GausLines));
  SetLength(GausLinesCur,High(GausLinesCur));
  GaussLinesToGraph(True);
  GraphSum(GausLines);
  if SEGauss.Value=SEGauss.MaxValue then  SEGauss.Value:=SEGauss.Value-1;
  SEGauss.MaxValue:=SEGauss.MaxValue-1;
  GaussLinesToGrid;
 end; //else if RBAveSelect.Checked
end;

procedure TForm1.ButGLLoadClick(Sender: TObject);
begin
GausLinesLoad;
end;

procedure TForm1.ButGLResClick(Sender: TObject);
var i:integer;
begin
  GaussLinesToGraph(False);
  for i:=1 to High(GausLines) do
    GraphFill(GausLines[i],GausLinesCur[i].GS,
                   Series1.MinXValue,Series1.MaxXValue,150,0);
  GraphSum(GausLines);
  GaussLinesToGraph(True);
end;

procedure TForm1.ButInputTClick(Sender: TObject);
var st,stHint:string;
    temp, temp2:double;
begin
temp:=VaxFile.T;
st:=FloatToStrF(temp,ffGeneral,4,1);
stHint:='Input Temperature';
st:=InputBox('Temperature',stHint,st);
StrToNumber(st, temp, temp2);
VaxFile.T:=temp2;
if VaxFile.T<=0 then
   begin
    VaxFile.T:=temp;
    MessageDlg('Thermodynamic temperature must be positive', mtError,[mbOk],0);
   end;
GraphShow(Form1);
end;

procedure TForm1.ButLDFitSelectClick(Sender: TObject);
begin
 if FormSFNew.ShowModal=mrOk then
    if (FormSFNew.SelectedString=FFFunctionPhotoDiod)or
       (FormSFNew.SelectedString=FFFunctionDiodLSM)or
       (FormSFNew.SelectedString=FFFunctionPhotoDiodLSM)or
       (FormSFNew.SelectedString=FFFunctionDiodLambert)or
       (FormSFNew.SelectedString=FFFunctionPhotoDiodLambert)or
       (FormSFNew.SelectedString=FFFunctionDiod)or
       (FormSFNew.SelectedString=FFFunctionDDiod)or
       (FormSFNew.SelectedString=FFFunctionPhotoDDiod)
       then LabIsc.Caption:=FormSFNew.SelectedString;
 CBoxDLBuildClick(Sender);
end;


procedure TForm1.ButRAClick(Sender: TObject);
begin
 InputValueToLabel('Rs parameters',
                   'Input parameter A for Rs=A+B*T+C*T^2',
                   ffGeneral,
                   LabRA,GraphParameters.RA);
end;

procedure TForm1.ButRBClick(Sender: TObject);
begin
 InputValueToLabel('Rs parameters',
                   'Input parameter B for Rs=A+B*T+C*T^2',
                   ffExponent,
                   LabRB,GraphParameters.RB);
end;

procedure TForm1.ButRCClick(Sender: TObject);
begin
 InputValueToLabel('Rs parameters',
                   'Input parameter C for Rs=A+B*T+C*T^2',
                   ffExponent,
                   LabRC,GraphParameters.RC);
end;

procedure TForm1.ButtonVaClick(Sender: TObject);
begin
 InputValueToLabel('Input Va voltage',
                   'Enter voltage Va '+Chr(13)+
                   'for function F(V) and F(I) building' +Chr(13),
                   ffGeneral,
                   LabelVa,GraphParameters.Va);
 if RadioButtonF_V.Checked then
                 RadioButtonM_VClick(RadioButtonF_V);
 if RadioButtonF_I.Checked then
                 RadioButtonM_VClick(RadioButtonF_I);
end;


procedure TForm1.ButSaveClick(Sender: TObject);
begin
 if RB_TauR.Checked
     then Write_File3Column(FitName(VaxFile,'show'),VaxGraph,
                            DiodPN.TauToLdif)
     else  VaxGraph.WriteToFile(FitName(VaxFile,'show'));
end;

procedure TForm1.ButSaveDLClick(Sender: TObject);
Label fin;
var
    aprr:TVector;
    aprr2:TVectorTransform;
    Action:TFunCorrectionNew;
    EP:TArrSingle;
    j:integer;
begin
SaveDialog1.FileName:=copy(VaxFile.name,1,length(VaxFile.name)-4)+'dl.dat';
   if SaveDialog1.Execute()
     then
       Write_File_Series(SaveDialog1.FileName,Series1);

aprr:=TVector.Create;
VaxGraph.Splain3(aprr,0.05,0.002);
if aprr.Count>0 then
         aprr.WriteToFile(copy(SaveDialog1.FileName,1,length(SaveDialog1.FileName)-4)+'ap.dat');

if CBoxRCons.Checked then
  begin
  if EvolParam[0]=ErResult then Goto fin;
  FitFunctionNew:=FitFunctionFactory(LabIsc.Caption);
  (FitFunctionNew as TFFVariabSet).T:=VaxFile.T;
  ParameterSimplify(EvolParam,EP,LabIsc.Caption);
  VaxFile.CopyTo(aprr);

  FitFunctionNew.OutputDataImport(EP);
  for j:=0 to aprr.HighNumber do
     begin
     aprr.X[j]:=VaxFile.X[j]-
         ParamDeterm(EvolParam,'Rs',LabIsc.Caption)*VaxFile.Y[j];
     aprr.Y[j]:=FitFunctionNew.FinalFunc(aprr.X[j]);
     end;
  FreeAndNil(FitFunctionNew);
  Action:= FunCorrectionDefineNew();
  aprr2:=TVectorTransform.Create;
  if not(Action(aprr,aprr2,SpinEditDL.Value)) then
     begin
     aprr2.Free;
     Goto fin;
     end;
  if aprr2.Count>0 then
     aprr2.WriteToFile(copy(SaveDialog1.FileName,1,length(SaveDialog1.FileName)-4)+'ft.dat');
  aprr2.Splain3(aprr,0.05,0.002);
  if aprr.Count>0 then
     aprr.WriteToFile(copy(SaveDialog1.FileName,1,length(SaveDialog1.FileName)-4)+'ftap.dat');
   aprr2.Free;
  end;

fin:
 aprr.Free;
end;


Procedure Patch();
{розрахунок потенціалу на поверхні з патчем.. використовувалося
для побудови рисунка у статті в JAP}
var     z,x,W,L0,z_max,x_Max,Fb0,Vn,Del,x0,Pot,Del2,x02,L02:double;
        dat:TStringList;

    function Potential(x,z,x0,L0,Del:double):double;
       function f(ro,fi:double):Double;
        begin
          Result:=1/(Power(sqr(z)+sqr(ro)+sqr(x-x0)-2*ro*abs(x-x0)*cos(fi),1.5));
        end;
     var
       i,j,Np:integer;
       rr,h_ro,h_fi:double;

     begin

    //------------
    {для циліндричного патчу.. починаємо з z=1 - я не домучився щоб
    з z=0}
       if (z=0)and(x=0) then  Result:=Fb0-Del
                        else
          begin
           Np:=100;
           h_ro:=L0/Np;
           h_fi:=2*Pi/Np;
            rr:=0;
            for I := 1 to Np do
             for j := 1 to Np do
              begin
                 rr:=rr+f(i*h_ro-h_ro/2,j*h_fi-h_fi/2)*(i*h_ro-h_ro/2)*h_ro*h_fi;
              end;
        Result:=(Fb0-Vn)*sqr(1-z/W)+Vn-Del*z/2/Pi*rr;
          end;
    //------------------
    {для патчу у вигляді смужки, z=0 підійде}

    //   if z=0 then
    //        begin
    //          if abs(x-x0)>=L0 then Result:=(Fb0-Vn)*sqr(1-z/W)+Vn
    //                        else Result:=(Fb0-Vn)*sqr(1-z/W)+Vn-Del;
    //        end
    //          else
    //   Result:=(Fb0-Vn)*sqr(1-z/W)+Vn-
    //       Del/Pi*arctan((abs(x-x0)+L0)/z)+
    //       Del/Pi*ARCtan((abs(x-x0)-L0)/z);



    //   if (z=0)and(x=0) then  Result:=Fb0-Del
    //                    else
    //   Result:=(Fb0-Vn)*sqr(1-z/W)+Vn-
    //       Del*sqr(L0)*z/Power(sqr(x)+sqr(z),1.5);

     end;

begin
x_Max:=250;
z_max:=100;
W:=200;
//Fb0:=0.725;
//Vn:=0.15;
//Del:=0.4;
//L0:=15;
//x0:=100;
//Del2:=0.3;
//L02:=25;
//x02:=-100;

Fb0:=0.83;
Vn:=0.15;
Del:=0.2;
L0:=35;
x0:=100;
Del2:=0.15;
L02:=50;
x02:=-100;


x:=-x_Max;
dat:=TStringList.Create;
repeat
z:=1;
 repeat

//   Pot:=Potential(x,z,x0,L0,Del);

   Pot:=(Potential(x,z,x0,L0,Del)+
         Potential(x,z,x02,L02,Del2)
   )/2;

   Form1.Button1.Caption:=floattostr(x);
   dat.Add(FloatToStrF(x,ffExponent,3,0)+' '+
                FloatToStrF(z,ffExponent,3,0)+' '+
                FloatToStrF(Pot,ffExponent,4,0)
                );
   z:=z+1;
 until z>z_max;
x:=x+1;
until x>x_Max;
dat.SaveToFile(CurDirectory+'\'+'Tung.dat');
dat.Free;
end;



Procedure GenerIVSet(sigI,sigV,Ilim:double;f_end:string);
{синтезує набір вольт-амперних характеристик в діапазоні
температур 130-330 К,
струм міняється від 0,1 нА до Ilim;
значення "розмиваются" згідно з
розподілом Гауса,
sigV - дисперсія розподілу значень напруг
sigI - дисперсія розподілу відносних значень струму}
var comment,dat:TStringList;
    name:string;
    T,V,I,n,Rs,Fb,I0:double;
begin
  Randomize;
  comment:=TStringList.Create;
  dat:=TStringList.Create;
  T:=130;
  while T<335 do
   begin
     name:='T'+inttostr(round(T))+f_end;
     Form1.Button1.Caption:=name;
     V:=0;
     dat.Clear;
     n:=n_T(T);
     Rs:=Rs_T(T);
     Fb:=Fb_T(T);
     I0:=3.14e-6*1.12e6*T*T*exp(-Fb/Kb/T);
     repeat
         V:=V+0.01;
         I:=Full_IV(IV_Diod,V,[n*Kb*T,I0,Rs]);

         if (I>=1e-10) then
           begin
             dat.Add(FloatToStrF(RandG(V,sigV),ffExponent,4,0)+' '+
                  FloatToStrF(RandG(I,sigI*I),ffExponent,4,0));
           end;
         if I>Ilim then Break;
     until false;
     dat.SaveToFile(CurDirectory+'\'+name);
     comment.Add(name);
     comment.Add('T='+FloatToStrF(T,ffgeneral,5,2));
     comment.Add('');
    T:=T+10;
   end;
//  comment.SaveToFile(CurDirectory+'\'+'comments');
  comment.SaveToFile(CurDirectory+'\'+CommentsDat);
  comment.Free;
  dat.Free;
end;



Procedure IVcharFileCreate();
 var comment,dat:TStringList;
    name:string;
    T,V,I,tempV:double;
begin
  dat:=TStringList.Create;
  comment:=TStringList.Create;
  T:=300;
     name:='T'+inttostr(round(T))+'I2.dat';
     V:=0;
     dat.Clear;
     repeat
         V:=V+0.01;
         I:=Full_IV(IV_DiodDouble,V,
             [Kb*T,2,3e-11,2.8*Kb*T,5e-6],1e3);
         tempV:=V-2*I;
         I:=Full_IV(IV_DiodDouble,tempV,
             [Kb*T,0,3e-11,2.8*Kb*T,5e-6]);

         if (abs(I)>=1e-10) then
           begin
             dat.Add(FloatToStrF(tempV,ffExponent,4,0)+' '+
                  FloatToStrF(I,ffExponent,4,0));
           end;
         if I>2e-2 then Break;
     until false;
     dat.SaveToFile(CurDirectory+'\'+name);
     comment.Add(name);
     comment.Add('T='+FloatToStrF(T,ffgeneral,5,2));
     comment.Add('');

//  comment.SaveToFile(CurDirectory+'\'+'comments');
  comment.SaveToFile(CurDirectory+'\'+'comments.dat');
  comment.Free;
  dat.Free;
end;

//Function FileNameIsBad(FileName:string):boolean;
//{повертає True, якщо FileName містить
//щось з переліку BadName (масив констант)}
// var i:byte;
//     UpperCaseName:string;
//begin
//  UpperCaseName:=AnsiUpperCase(FileName);
//  for I := 0 to High(BadName) do
//     if Pos(BadName[i],UpperCaseName)<>0 then
//        begin
//          Result:=True;
//          Exit;
//         end;
//  Result:=False;
//end;

Procedure GraphParCalculComBox(InVector:TVectorShottky;ComboBox:TCombobox);
 var tg:TGraph;
begin
 tg:=ConvertStringToTGraph(ComboBox);
 GraphParameters.Diapazon:=D[ConvertTGraphToTDiapazons(tg)];
 InVector.GraphParameterCalculation(tg);
end;

Function FileCount():integer;
{повертає кількість .dat файлів у поточній
директорії (окрім тих, які містять
у назві "fit" та "dates")}
 var
  SR : TSearchRec;
begin
 Result:=0;
 if not(SetCurrentDir(CurDirectory)) then
   begin
   MessageDlg('Current directory is not exist', mtError,[mbOk],0);
   Exit;
   end;

 if FindFirst(mask, faAnyFile, SR) = 0 then
  begin
    repeat
     if FileNameIsBad(SR.name) then Continue;
     inc(Result);
    until FindNext(SR) <> 0;
  end;
 FindClose(SR);
end;

procedure InputValueToLabel(Name,Hint:string; Format:TFloatFormat;
                   var Lab:Tlabel;var Value:double);
begin
 StrToNumber(InputBox(Name,Hint,FloatToStrF(Value,Format,3,2)), Value, Value);
 Lab.Caption:=FloatToStrF(Value,Format,3,2);
end;

Procedure ReadFileToVectorArray(VectorArray:array of TVectorTransform);
{з поточної директорії зчитуються всі .dat файли
в масив VectorArray (окрім тих, які містять
у назві "fit" та "dates")
повертається кількість зчитаних файлів}
 var
  SR : TSearchRec;
  i:integer;
begin
{XP Win}
 FormatSettings.DecimalSeparator:='.';
// DecimalSeparator:='.';
 if not(SetCurrentDir(CurDirectory)) then Exit;
 i:=-1;
 if FindFirst(mask, faAnyFile, SR) = 0 then
  begin
    repeat
     if FileNameIsBad(SR.name) then Continue;
     inc(i);
     if i>High(VectorArray) then Break;
     VectorArray[i].ReadFromFile(SR.name);
    until FindNext(SR) <> 0;
  end;
 FindClose(SR);
end;

Function VectorIsFitting(Vax:TVectorTransform):boolean;
{апроксимує дані Vax відповідно до глобального
об'єкту Fit (який вже має бути створений),
обмеження, які застосовуються у даних в Vax такі самі,
як для розгляду диференційного коефіцієнту
нахилу (тобто найчастіше визначаються вмістом D[diDE]);
Результат в глобальному масиві EvolParam}
 var tempVax:TVector;
begin
 Result:=False;
 tempVax:=TVector.Create;
 try
  if not(FuncLimit(Vax,tempVax)) then Raise Exception.Create('Fault!!!!');
  FitFunctionNew.Fitting(tempVax);
  if not(FitFunctionNew.ResultsIsReady)
     then Raise Exception.Create('Fault!!!!');
  FitFunctionNew.OutputDataExport(EvolParam);
  Result:=True;
 finally
  tempVax.Free;
 end;
end;

Procedure dB_dU_DataCreate(Vax:TVectorTransform);
{на основі Vax створюється файл з
диференційним коефіцієнтом нахилу;
кінцеві дані враховують ідеалізовану залежність;
глобальний об'єкт Fit вже має бути створений відповідно до
апроксимуючої функції;
при розрахунках використовуються різні
значення, встановлені на формі
}
var
    temp:TVectorTransform;
    temp2:TVector;
    Action:TFunCorrectionNew;
    EP:TArrSingle;
    Rs:double;
    j:integer;
begin
  Action:= FunCorrectionDefineNew();

  temp:=TVectorTransform.Create;
  temp2:=TVector.Create;

  try
  if not(VectorIsFitting(Vax)) then Raise Exception.Create('Fault!!!!');

   ParameterSimplify(EvolParam,EP);
   Rs:=ParamDeterm(EvolParam,'Rs');
  if Rs=ErResult then Raise Exception.Create('Fault!!!!');

   Vax.CopyTo(temp);

   FitFunctionNew.OutputDataImport(EP);
   for j:=0 to Vax.HighNumber do
     begin
     temp.X[j]:=Vax.X[j]-Vax.Y[j]*Rs;
     temp.Y[j]:=FitFunctionNew.FinalFunc(temp.X[j]);
     end;

   FitFunctionNew.OutputDataImport(EvolParam);
   for j:=0 to Vax.HighNumber do
     begin
     Vax.Y[j]:=Vax.Y[j]-FitFunctionNew.FinalFunc(Vax.X[j])
                     +temp.Y[j];
     Vax.X[j]:=temp.X[j];
     end;
  if (not(Action(temp,temp2,Form1.SpinEditDL.Value)))or
     (not(Action(Vax,temp,Form1.SpinEditDL.Value))) then
              Raise Exception.Create('Fault!!!!');
  temp.DeltaY(temp2);
  temp.Splain3(Vax,temp.X[0],0.002);
  finally
   temp.Free;
   temp.Free;
  end; //try
end;


Procedure  WriteToDirVectorArray(VectorArray:array of TVectorTransform;
           DirName,FileEnd:string);
{В поточній директорії створюється нова з іменем DirName і
туди записуються .dat файли зі вмістом VectorArray;
FileEnd  - те, що дописується до кінця назви файлу
порівняно з назвами, які містятся в VectorArray[i]^.name}
 var j:integer;
     newFileName:string;
     Comments:TStringList;
begin
  try
   MkDir(DirName);
  except
  ;
  end; //try
  FileEnd:=FileEnd+'.dat';
{XP Win}
 FormatSettings.DecimalSeparator:='.';
// DecimalSeparator:='.';
  Comments:=TStringList.Create;
  for j := 0 to High(VectorArray) do
   begin
    newFileName:=copy(VectorArray[j].name,1,length(VectorArray[j].name)-4)+
     FileEnd;
    VectorArray[j].WriteToFile(CurDirectory+'\'+DirName+'\'+newFileName);
    Comments.Add(newFileName);
    Comments.Add('T='+FloatToStrF(VectorArray[j].T,ffGeneral,5,2));
    Comments.Add('');
   end;
  Comments.SaveToFile(CurDirectory+'\'+DirName+CommentsDat);
end;


Procedure dB_dU_FilesCreate();
{для всіх файлів у поточній директорії
створюються файли з диференційним коефіцієнтом нахилу
і розміщуються в нову директорію dBdU}
// var VectorArray:array of PVector;
 var VectorArray:array of TVectorTransform;
    i:byte;
begin
  if Form1.LabIsc.Caption='None' then
   begin
   MessageDlg('Function must be defined!', mtError,[mbOk],0);
   Exit;
   end;
  SetLength(VectorArray,FileCount());
  if High(VectorArray)<0 then Exit;
  for i := 0 to High(VectorArray) do VectorArray[i]:=TVectorTransform.Create;
  try
   ReadFileToVectorArray(VectorArray);
  finally

  end;

  FitFunctionNew:= FitFunctionFactory(Form1.LabIsc.Caption);
  for i := 0 to High(VectorArray) do
        dB_dU_DataCreate(VectorArray[i]);

  FreeAndNil(FitFunctionNew);

  WriteToDirVectorArray(VectorArray,'dB_dU','sm2');

  for i := 0 to High(VectorArray) do VectorArray[i].Free;
end;


Procedure VocFF_Dependence();
 const Npoint=51;
 var Str:TStringList;
     Tmin,Tmax,Tdel,T,
     tauGmin,tauGmax,tauGdel,tauG,
     tauRmin,tauRmax,tauRdel,tauR,
     nmin,nmax,ndel,n,
     Rsmin,Rsmax,Rsdel,Rs,
     Rshmin,Rshmax,Rshdel,Rsh:double;
     FitIV:TFitFunctionNew;
     Iph:double;
     OutputData:TArrSingle;
     i:integer;
begin
 Tmin:=320;
 Tmax:=Tmin;
// Tmin:=290;
// Tmax:=340;
 Tdel:=StepDeterminationNew(Tmin,Tmax,Npoint,vr_lin);

 tauGmin:=log10(5e-8);
 tauGmax:=tauGmin;
// tauGmin:=log10(1e-9);
// tauGmax:=log10(1.02e-6);
 tauGdel:=StepDeterminationNew(tauGmin,tauGmax,Npoint,vr_lin);

 tauRmin:=log10(3e-6);
 tauRmax:=tauRmin;
// tauRmin:=log10(1e-7);
// tauRmax:=log10(1.01e-5);
 tauRdel:=StepDeterminationNew(tauRmin,tauRmax,Npoint,vr_lin);

// nmin:=2.55;
// nmax:=nmin;
 nmin:=2;
 nmax:=4.05;
 ndel:=StepDeterminationNew(nmin,nmax,Npoint,vr_lin);

 Rsmin:=0.6;
 Rsmax:=Rsmin;
 Rsdel:=StepDeterminationNew(Rsmin,Rsmax,Npoint,vr_lin);

// Rshmin:=log10(1e19);
// Rshmin:=log10(5e3);
// Rshmax:=Rshmin;
 Rshmin:=log10(1e2);
 Rshmax:=log10(1.01e8);
 Rshdel:=StepDeterminationNew(Rshmin,Rshmax,Npoint,vr_lin);


 Str:=TStringList.Create;
// Str.Add('T Rs Rsh logRsh n tauG logTG tauR logTR Voc ff');
 Str.Add('T Rsh logRsh n tauR logTR tauG logTG Voc ff');

 FitIV:=TFFDoubleDiodTauLight.Create;
// FitIV:=TDoubleDiodTauLight.Create;
// FitIph:=TCurrentSC.Create;
 SetLength(OutputData,13);

 OutputData[0]:=1;
 T:=Tmin;
 repeat
// (FitIV as TFitTemperatureIsUsed).T:=T;
 (FitIV as TFFVariabSet).T:=T;

   Rs:=Rsmin;
   repeat
     OutputData[1]:=Rs;

       Rsh:=Rshmin;
       repeat
         OutputData[3]:=Power(10,Rsh);

          n:=nmin;
          repeat
            OutputData[4]:=n;

             tauG:=tauGmin;
             repeat
               OutputData[5]:=Power(10,tauG);

                 tauR:=tauRmin;
                 repeat
                   OutputData[2]:=Power(10,tauR);
//                   Iph:=2*0.72398*200e-6*
//                         Silicon.Absorption(900,T)*100e-6/
//                         (1+Silicon.Absorption(900,T)*100e-6);
                     Iph:=2.33*100e-6*
                         Silicon.Absorption(900,T)*DiodPN.TauToLdif(OutputData[2],T)/
                         (1+Silicon.Absorption(900,T)*DiodPN.TauToLdif(OutputData[2],T));
                    OutputData[6]:=Iph;
//                    Form1.Button1.Caption:='tG='+floattostrf(tauG,ffExponent,4,0)+' tR='+
//                    floattostrf(tauR,ffExponent,4,0);
                    Form1.Button1.Caption:='n='+floattostrf(n,ffExponent,4,0)+' Rsh='+
                    floattostrf(Rsh,ffExponent,4,0);
//!!!!!!!!було так  (FitIV as TDoubleDiodLight).AddParDetermination(nil,OutputData);
//                    (FitIV as TDoubleDiodLight).AddParDetermination(VaxFile,OutputData);

                    FitIV.OutputDataImport(OutputData);
                    VaxFile.Clear;
                    for I := 0 to 100 do
                      VaxFile.Add(i*0.01,FitIV.FinalFunc(i*0.01));
                    OutputData[7]:=VaxFile.Voc;
                    OutputData[10]:=VaxFile.FF;
//                    (FitIV as TFFDoubleDiodTauLight).AddParDetermination(VaxFile,OutputData);


                    Str.Add(FloatToStrF(T,ffFixed,3,0)+' '+
//                            FloatToStrF(Rs,ffExponent,4,0)+' '+
                            FloatToStrF(OutputData[3],ffExponent,4,0)+' '+
                            FloatToStrF(Rsh,ffExponent,4,0)+' '+
                            FloatToStrF(n,ffExponent,4,0)+' '+
                            FloatToStrF(OutputData[2],ffExponent,4,0)+' '+
                            FloatToStrF(tauR,ffExponent,4,0)+' '+
                            FloatToStrF(OutputData[5],ffExponent,4,0)+' '+
                            FloatToStrF(tauG,ffExponent,4,0)+' '+
                            FloatToStrF(OutputData[7],ffExponent,4,0)+' '+
                            FloatToStrF(OutputData[10],ffExponent,4,0));
                    Application.ProcessMessages;
                   tauR:=tauR+tauRdel;
                 until tauR>tauRmax;
               tauG:=tauG+tauGdel;
             until tauG>tauGmax;
           n:=n+ndel;
          until (n>nmax);
         Rsh:=Rsh+Rshdel;
       until Rsh>Rshmax;
     Rs:=Rs+Rsdel;
   until Rs>Rsmax;
  T:=T+Tdel;
//  showmessage(floattostr(T));
 until (T>Tmax);

// FitIph.Free;
// FitIV.Free;
 FreeAndNil(FitIV);
 Str.SaveToFile('VocFF.dat');
 Str.Free;
end;


 function My(T:double;d:array of double):double;
  begin
   Result:=Diod.Semiconductor.Material.n_i(T);
  end;


function Button(fy:double):double;

begin

 Result:=CastroIV(fy,[3.747e-11,1.866,
                      7.399e7,1e-13,
                      1,2.675e3,
                      1e-5,0,
                      295]);

end;


procedure TForm1.Button1Click(Sender: TObject);
var
//  i,j:integer;
  Vec:TVector;
//  Vec2:TVectorTransform;

  delN,T,Voc,delNd,V:double;
  Fe:TDefect;
  drive:char;
  path,fname:string;
  i,j,N:word;
  MethodVector,MethodVector2:array of TVector;
  im:TMetaMethod;
//  MethodVector2:array[TMethods] of TVectorTransform;
  im2:TMethods;
  OneToNTest:TOneToNTest;
  Str:TStringList;
//  TMetaMethod=(mmPSO, mmIPOPES, mmCHC, mmSSGA, mmSSBLX, mmSSArit, mmDEBin, mmDEExp, mmSaDE);
//  number, zero : double;
//var dpn:TDiod_PN;
//    Nd,Ndmin,NdMax,delNd:double;
//    stepNd,{delT,}T,Tmin,Tmax:integer;
//    Str:TStringList;
//    tempstr:string;


begin
//showmessage(VaxFile.AdditionalVector.XYtoString);
AbsorbFileForSCAPS();
//ForAllDatFilesAction(FirsTNanoW,'D:\SiGe_NWs\','J0Jt');
//ForAllDatFilesAction(AverageSiNanoW,'D:\SiGe_NWs\','J0Jt');
//SelectDatFileAndAction(AverageSiNanoThread);
// SecondTPorSi('');
//ForAllDatFilesAction(AddNoiseToTime,'D:\Pyton\Py2024\porSi');

//  ForAllDirAction(SecondTPorSi,J0JtDirName,'D:\Si_Test',False);
//  ForAllDatFilesAction(FirsTPorSi,'D:\Si_Test\','J0Jt');
// PorSiForSRFileCreate();
//showmessage(floattostr(5e10/Silicon.Nv(295)/Silicon.Vth_p(295)));
//showmessage(floattostr(Kb*295*Ln(Silicon.Nc(295)/1.5e21)));

//RI_porSi(293);

//ForAllDatFilesAction(FirsTPorSi,'D:\porousSi\','J0Jt');
//ForAllDirAction(SecondTPorSi,J0JtDirName,'D:\porousSi');
//ForAllDirAction(DeleteDirectory,J0JtDirName,'D:');
//ForAllDirAction(IVmanipulate,'IV','D:\DeepL\2024\ODiod\OdiodNew');
//ForAllDirAction(IVfittingResultCollect2,'Forward','D:\Samples\DeepL\2024\ODiod');
//ReorganizeFileToKeys('D:\Samples\DeepL\2024\ODiod\Results\IVfittingNew.dat',
//                      'D:\Samples\DeepL\2024\ODiod\Results\keys.dat');
//ReorganizeFileToKeys('D:\Samples\DeepL\2024\ODiod\OdiodNew\Results\CVbarIS.dat',
//                      'D:\Samples\DeepL\2024\ODiod\Results\keys.dat');
//ForAllDirAction(ISresultTransform,'ISsum','D:\Samples\DeepL\2024\ODiod');


// Vec:=TVector.Create;
// delN:=550;
// T:=293;
// repeat
//  Vec.Add(delN,Silicon.RefractiveIndex(delN,T));
//  delN:=delN+20;
// until (delN>2000);
// Vec.WriteToFile('LiRef'+inttostr(round(T))+'.dat',8);
// FreeAndNil(Vec);


// Ts(0.045);
//ToDecreaseNumberCount();

// ForAllDatFilesAction(MLresultsEstimate,CurDirectory);
//SelectDatFileAndAction(MLresultsEstimate);
// ForAllDatFilesAction(MLresultsTransform,CurDirectory);
//SelectDatFileAndAction(MLresultsTransform);

//  SomethingForCastro;

//ReorganizeFileToKeys('D:\Samples\DeepL\2024\ODiod\Results\IVfitting.dat',
//                      'D:\Samples\DeepL\2024\ODiod\Results\keys.dat');
//ForAllDirAction(IVfittingResultCollect,'Forward','D:\Samples\DeepL\2024\ODiod');
//ForAllDirAction(CVReverse,'CV','D:\Samples\DeepL\2024\ODiod');
//ForAllDirAction(CVReverse,'CV','D:\DeepL\2024\ODiod\OdiodNew');
//ForAllDirAction(IVmanipulate,'IV','D:\Samples\DeepL\2024\ODiod');
//ForAllDirAction(DatToEis,'RZ','D:\Samples\DeepL\2024\ODiod\OdiodNew');
//ForAllDirAction(DatToEis,'RZ','D:\Samples\DeepL\2024\ODiod');
//ForAllDirAction(ISresultTransform,'IS','D:\Samples\DeepL\2024\ODiod');
//ForAllDirAction(CFTransform,'Cf','D:\Samples\DeepL\2024\ODiod');
//ForAllDirAction(CFTransform,'Cf','D:\Samples\DeepL\2024\ODiod\OdiodNew');

//ShowMessage(floattostr(ElectronConcentration(100, [0,1e20,0.045],1,0)));
//ShowMessage(floattostr(HoleConcentration(100, [0,1e20,0.045],1,0)));
//Ti();
//Ts(0.057);

//ForAllDatFilesAction(FirsTPorSi,'D:\porousSi\','J0Jt');
//ForAllDirAction(SecondTPorSi,J0JtDirName,'D:\porousSi');
//ForAllDirAction(DeleteDirectory,J0JtDirName,'D:');


//showmessage(floattostr(TMaterial.NoorMohammad(1,1e23,300)));
//TC_porT();
//Mu_TNdop(True,True);
//Mu_TNdop(True,False);
//Mu_TNdop(False,True);
//Mu_TNdop(False,False);

//Ln_Isc();
//Eg_T();
//J0_T();
//Ln_IscT();

//YZriz([0.02,0.1,1,3,5,8,10,15,22,30],True);

// AllDatFileToOne();
//SpectrCreateFull();
//SpectrApproxmation();

//AbbSpectr();

//showmessage(floattostr(Silicon.LdifToTauRec(120e-6,340,true,false,1.36e21)));
//showmessage(floattostr(Fe_i_eq(8.7e18,1.36e21,340)));
//showmessage(floattostr(FeB_i_eq(8.7e18,1.36e21,340)));
//showmessage(floattostr(TauFeEqIntrin(1.41e19,1.36e21,340)/1.41e19));

//showmessage(floattostr(Fe_i_eq(1.41e19,1.36e21,300)/1.41e19));
//showmessage(floattostr(Silicon.TauToLdif(TauFeEqIntrin(1.41e19,1.36e21,340),340,true,false,1.36e21)));
//showmessage(floattostr(TauFeEqIntrin(8.7e18,1.36e21,340)));
//showmessage(floattostr(Silicon.TauToLdif(TauFeEqIntrin(8.7e18,1.36e21,340),340,true,false,1.36e21)));
//LnOnT(8.7e18);
//LnOnT(1e19);



// showmessage(FloatToStr(Silicon.Eg(340)));


//showmessage(floattostr(Silicon.Absorption(390,295)));

//DeepOfAbsorbtion(290);
//DeepOfAbsorbtion(350);
//TauIntrinsic();
//TauOnL(290,1e14);
//TauOnL(340,1e14);
//TauOnL(290,1e16);
//TauOnL(340,1e16);




//SpectrCreateFull();


// DatFileNoiseSmoothing(10,'sm10');
// DatFileNoiseSmoothing(5,'sm5');
// DatFileNoiseSmoothing(20,'sm20');
//  SpectrApproxmation();
// AllDatFileToOne();
// ForAllDatFilesAction(ToLampSpectr);
// AllDatFileToOne('Kalibred');
// ForAllDatFilesAction(NormSpectr);
// AllDatFileToOne('NormalAll');
// ForAllDatFilesAction(NormNphSpectr);
// AllDatFileToOne('NormalNphAll');

// if OpenDialog1.Execute()
//       then NormNphSpectr(OpenDialog1.FileName);
//     then  SomethingForCastro2(OpenDialog1.FileName);

//  LambertEvaluation();
// IVCreation();

// AbsorbFileForSCAPS();
//  SpectrApprox();
//  SpectrCreate();

//  Vec:=TVector.Create;
//  Str:=TStringList.Create;
//  Vec.Add(1e21,Silicon.Cp_Auger(1e21,290));
//  Vec.Add(1e22,Silicon.Cp_Auger(1e22,290));
//  Vec.Add(1e23,Silicon.Cp_Auger(1e23,290));
//  Vec.Add(1e24,Silicon.Cp_Auger(1e24,290));
//  showmessage(Vec.XYtoString);
//  FreeAndNil(Vec);
//   Str.Free;

//SetLength(MethodVector,ord(High(TMetaMethod))+1);
//for im := Low(TMetaMethod) to High(TMetaMethod) do
//  MethodVector[ord(im)]:=TVector.Create;
//
//  MethodVector[0].ReadFromFile('Abb1.dat',['PSO'],True);
//  MethodVector[1].ReadFromFile('Abb1.dat',['IPOPES'],True);
//  MethodVector[2].ReadFromFile('Abb1.dat',['CHC'],True);
//  MethodVector[3].ReadFromFile('Abb1.dat',['SSGA'],True);
//  MethodVector[4].ReadFromFile('Abb1.dat',['SSBLX'],True);
//  MethodVector[5].ReadFromFile('Abb1.dat',['SSArit'],True);
//  MethodVector[6].ReadFromFile('Abb1.dat',['DEBin'],True);
//  MethodVector[8].ReadFromFile('Abb1.dat',['DEExp'],True);
//  MethodVector[7].ReadFromFile('Abb1.dat',['SaDE'],True);
//
// Vec:=TVector.Create;
//
//SetLength(MethodVector2,ord(High(TMethods))+1);
//for im2 := Low(TMethods) to High(TMethods) do
//  MethodVector2[ord(im2)]:=TVector.Create;
//
//  MethodVector2[0].ReadFromFile('Abb2.dat',['A'],True);
//  MethodVector2[1].ReadFromFile('Abb2.dat',['B'],True);
//  MethodVector2[2].ReadFromFile('Abb2.dat',['C'],True);
//  MethodVector2[3].ReadFromFile('Abb2.dat',['D'],True);
//
//// OneToNTest:=TQuade.Create(MethodVector2);
// OneToNTest:=TMultipleComparisons.Create(MethodVector);
////  for I := 1 to 9 do
////   for j := 1 to (i-1) do
////    begin
////     Vec.Add((OneToNTest as TMultipleComparisons).MultipleShafferStaticAPV(i,j),i+IntToFrac(j));
////    end;
//
// for I := 1 to 8 do Vec.Add(i,OneToNTest.UnadjustedP(9,i));
// showmessage(Vec.XYtoString);
// Vec.Clear;
// for I := 1 to 8 do Vec.Add(i,OneToNTest.HommelAPV(9,i));
// showmessage(Vec.XYtoString);
//
//
//// showmessage(floattostr(OneToNTest.UnadjustedP(9,1)));
//// showmessage(floattostr(OneToNTest.BonferroniAPV(9,1)));
//
////   T:=0;
////  repeat
////    Vec.Add(T,TFisherD.CDF(T,3,69));
////    T:=T+0.1;
////  until T>30;
////  Vec.WriteToFile('Atemp.dat',8);
//
//// showmessage(floattostr(FriedmanAlignedZvalue([MethodVector[mmIPOPES], MethodVector[mmCHC],
////                                   MethodVector[mmSSBLX], MethodVector[mmSaDE]],4,2)));
//// showmessage(floattostr(FriedmanUnadjustedP([MethodVector[mmIPOPES], MethodVector[mmCHC],
////                                   MethodVector[mmSSBLX], MethodVector[mmSaDE]],4,2)));
//
//  FreeAndNil(OneToNTest);
//for im2 := Low(TMethods) to High(TMethods) do
//  MethodVector2[ord(im2)].Free;
// FreeAndNil(Vec);
//for im := Low(TMetaMethod) to High(TMetaMethod) do
//  MethodVector[ord(im)].Free;
//


//showmessage(floattostr(2*(1-NormalCDF(13,12.5,sqrt(25)/2))));

//  Vec:=TVector.Create;
////  Vec.ReadFromFile('Abb.dat',['Wen']);
//  T:=0;
//  N:=24;
//  i:=0;
//  repeat
////    Vec.Add(T,BettaRegularizedIncomplete(T,4.5,1.5));
//    Vec.Add(i,BinomialCDF(N,i,0.5));
//    i:=i+1;
////    T:=T+0.02;
////  until T>1;
//  until i>N;
//  Vec.WriteToFile('Atemp.dat',8);
//  FreeAndNil(Vec);

// showmessage(DeleteLastDir('D:\'));
// Vec:=TVector.Create;
//    Try    ChDir(Directory);
//          OpenDialog1.InitialDir:=Directory;
//   Except ChDir(Directory0);
//          OpenDialog1.InitialDir:=Directory0;
//   End;
//if OpenDialog1.Execute() then
// begin
// ProcessPath(OpenDialog1.FileName, drive, path, fName);
// T:=340;
// Vec.ReadFromFile(fname);
// for I := 0 to Vec.HighNumber do
//  Vec.Y[i]:=TauFeEq(DiodPN.LayerP,Vec.Y[i],T);
// Vec.WriteToFile(FitName(Vec,'NN'));
// end;
// FreeAndNil(Vec);

//showmessage(floattostr(DiodPN.delN(0.4)));
//


//  ro:=0.5;
//  repeat
//    Vec.Add(ro,Silicon.CarrierConcentration(ro));
//    ro:=ro+0.5;
//  until (ro>15);
//  Vec.WriteToFile('Na_vs_ro.dat',5,'ro Na');


//  ro:=1e-6;
//  repeat
//    Vec.Add(ro,DiodPN.LdifToTauRec(ro,300));
//    ro:=ro+1e-6;
//  until (ro>200e-6);
//  Vec.WriteToFile('tau_vs_Ln_300_45.dat',5,'ro Na');
//
//  Vec.Clear;
//  ro:=1e-6;
//  repeat
//    Vec.Add(ro,DiodPN.LdifToTauRec(ro,295));
//    ro:=ro+1e-6;
//  until (ro>200e-6);
//  Vec.WriteToFile('tau_vs_Ln_295_45.dat',5,'ro Na');
//
//  Vec.Clear;
//  ro:=1e-6;
//  repeat
//    Vec.Add(ro,DiodPN.LdifToTauRec(ro,330));
//    ro:=ro+1e-6;
//  until (ro>200e-6);
//  Vec.WriteToFile('tau_vs_Ln_330_45.dat',5,'ro Na');
//
//
//  Vec.Free;

// dpn:=TDiod_PN.Create;
// dpn.LayerN.Material:=TMaterial.Create(TMaterialName(0));
// dpn.LayerP.Material:=TMaterial.Create(TMaterialName(0));
// dpn.LayerN.Nd:=1e25;
// Ndmin:=1e21;
// NdMax:=1e23;
// stepNd:=33;
// delNd:=(Log10(NdMax)-Log10(NdMin))/(stepNd-1);
// Tmin:=290;
// Tmax:=340;
//// delT:=1;
// Str:=TStringList.Create;
//
// tempstr:='Na';
// for T := Tmin to Tmax do
//   tempstr:=tempstr+' '+'T'+inttostr(T);
// Str.Add(tempstr);
// tempstr:='T';
// for T := Tmin to Tmax do
//   tempstr:=tempstr+' '+inttostr(T);
// Str.Add(tempstr);
//
// Nd:=Log10(Ndmin);
// repeat
//   tempstr:=FloatToStrF((Nd-6),ffExponent,10,0);
//   dpn.LayerP.Nd:=Power(10,Nd);
//   for T := Tmin to Tmax do
//     tempstr:=tempstr+' '+FloatToStrF(dpn.Wp(T),ffExponent,10,0);
//   Str.Add(tempstr);
//  nd:=Nd+delNd;
// until Nd>Log10(Ndmax*1.01);
// str.SaveToFile('Lop.dat');
//
// str.Clear;
// tempstr:='T';
// Nd:=Log10(Ndmin);
// repeat
//   tempstr:=tempstr+' '+'Na'+FloatToStrF((Nd-6),ffExponent,3,0);
//  nd:=Nd+delNd;
// until Nd>Log10(Ndmax*1.01);
// Str.Add(tempstr);
//
// tempstr:='Na';
// Nd:=Log10(Ndmin);
// repeat
//   tempstr:=tempstr+' '+FloatToStrF((Nd-6),ffExponent,10,0);
//  nd:=Nd+delNd;
// until Nd>Log10(Ndmax*1.01);
// Str.Add(tempstr);
//
// for T := Tmin to Tmax do
//  begin
//   tempstr:=inttostr(T);
//   Nd:=Log10(Ndmin);
//   repeat
//    dpn.LayerP.Nd:=Power(10,Nd);
//    tempstr:=tempstr+' '+FloatToStrF(dpn.Wp(T),ffExponent,10,0);
//    nd:=Nd+delNd;
//   until Nd>Log10(Ndmax*1.01);
//   Str.Add(tempstr);
//  end;
// str.SaveToFile('Lop_Na.dat');
//
// str.Free;
// dpn.Free;

// Vec:=TVector.Create;
// for j := 0 to 10 do
// begin
// Randomize;
// for I := 0 to 200 do
//   Vec.Add(i,RandCauchy(2,0.1));
// end;
// Vec.WriteToFile('tt.dat',10);
// Vec.Free;

//showmessage(inttostr(1+Random(26)));
// TextFileEquals('ResultAllold.dat','ResultAll.dat');

// showmessage(floattostr(FileNameToVoltage('13.dat')));
// Silicon.mu_n();
// showmessage(floattostr(Pi));
////
// Vec:=TVectorTransform.Create;
// Nb:=1e18;
// for i := 0 to 8 do
//   begin
//     Vec.Add(Nb*Power(10,i),Silicon.mu_p(300,Nb*Power(10,i),True));
//   end;
// Vec.WriteToFile('mu_Np.dat',8);
// Vec.Clear;
// T:=270;
// for i := 0 to 25 do
//   begin
//     Vec.Add(T,Silicon.mu_p(T,1e21,True));
//     T:=T+5;
//   end;
// Vec.WriteToFile('mu_Tp.dat',8);
//
// Vec.Free;

//showmessage(floattostr(Button(2e-8)));
//showmessage(floattostr(Button(1.07e-4)));


//showmessage(inttostr(GetHDDSerialNumber));


//showmessage(floattostr(ElectronConcentration(150,[1.385e14,1.22e23,5.527e-6,3.622e23,7.134e-2,4.028e23,7.185e-2])));
//showmessage(floattostr(ElectronConcentration(230,[1.385e14,1.22e23,5.527e-6,3.622e23,7.134e-2,4.028e23,7.185e-2])));
//showmessage(floattostr(ElectronConcentration2(230,[1.013e15,4.134e23,1.001e-4,1.012e10,5.907e-2,1.823e23,5.367e-2])));
//showmessage(floattostr(ElectronConcentrationNew(230,[1.385e14,1.22e23,5.527e-6,3.622e23,7.134e-2,4.028e23,7.185e-2,0,1,0,1,0,1],3,3)));
//showmessage(floattostr(ElectronConcentration2(230,[1.013e15,4.134e23,1.001e-4,0,1,0,1,1.012e10,5.907e-2,1.823e23,5.367e-2,0,1])));
//showmessage(floattostr(ElectronConcentrationNew(230,[4.152e18,1.227e23,3.481e-8,2.035e19,8.56e-1,7.638e23,7.187e-2,0,1,0,1,0,1],3,3)));

// new(x);
// SetLength(d,1);
// x.Filling(My,290,350,1,d);
// x.Write_File('n234567.dat',6);
// dispose(x);




//showmessage(FloattostrF(
//           DiodPN.LayerP.Material.EgT(330)
////         DiodPN.LayerP.Material.Nv(295)
////        *exp(-(DiodPN.LayerP.Material.EgT(292.5)-0.26)/Kb/292.5)
//// {      *exp(-0.394/Kb/295)}
//       ,ffExponent,4,0));

//ПОМІНЯТИ TDoubleDiodLight.AddParDetermination!!!
//VocFF_Dependence();

//showmessage(floattostr(DiodPN.LdifToTauRec(67e-6,320)));
//DegreeDependence();
//showmessage(floattostr(OverageValue(PointDistance2,[5e-9,6e-10,3e-10,0,0])));

//IVC(DiodPN.Iscr_rec,300,'IVdata.dat');

//IVC(DiodPN.I_Shockley,300,'IVdata.dat');
//IVC(DiodPN.I_Shockley,300,'IVdata.dat',0.1,0.6,0.7);

//showmessage(floattostr(Silicon.Absorption(900)));
//FunctionToFile('abs320.dat',Silicon.Absorption,250,1450,120,320);
//FunctionToFile('abs320.dat',Silicon.mu_n,290,340,50,1.36e9);
 // dB_dU_FilesCreate();

//------------------------------------------------------------
// Patch();
//------------------------------------------------------------
//GenerIVSet(0,0,0.02,'n.dat');
//GenerIVSet(0.05,0.003,0.02,'G5030n.dat');
//-------------------------------------------------------

//IVcharFileCreate();
end;




procedure TForm1.BSaveMemoClick(Sender: TObject);
 var SLResult:TStringList;
     i,j,StartLineNumber,DataLineNumber:integer;
     Caption,Tstr:string;
     Vector:TVector;
//     tempDouble:double;
     tempInt:integer;
begin
  if MemoAppr.Lines.Count<1 then Exit;

  SLResult:=TStringList.Create();
  if FileExists(AprResDatName) then
   SLResult.LoadFromFile(AprResDatName);
  StartLineNumber:=0;
  for i := MemoAppr.Lines.Count-1 downto 0 do
   if MemoAppr.Lines[i]='' then
     begin
       StartLineNumber:=i+1;
       Break;
     end;

   Caption:='fname';
   Tstr:=StringDataFromRow(Temper.Caption,3);
   if Tstr <>'0' then
    Caption:=Caption+' T';

   if MemoAppr.Lines[StartLineNumber]=CustomNames[6] then
    begin
     tempInt:=(MemoAppr.Lines.Count-StartLineNumber-3) div 5;
     {кількість гаусіан}
     for i := 1 to tempInt do
       Caption:=Caption+' '+ StringDataFromRow(MemoAppr.Lines[StartLineNumber+3*i],1,'=');
     for i := 1 to tempInt do
       Caption:=Caption+' '+ StringDataFromRow(MemoAppr.Lines[StartLineNumber+3*i-1],1,'=');
     for i := 1 to tempInt do
       Caption:=Caption+' '+ StringDataFromRow(MemoAppr.Lines[StartLineNumber+3*i+1],1,'=');
     for i := 1 to tempInt do
       Caption:=Caption+' '+ StringDataFromRow(MemoAppr.Lines[StartLineNumber+1+3*tempInt+i],1,'=');
     for i := 1 to tempInt do
       Caption:=Caption+' '+ StringDataFromRow(MemoAppr.Lines[StartLineNumber+1+4*tempInt+i],1,'=');
     Caption:=Caption+' '+StringDataFromRow(MemoAppr.Lines[MemoAppr.Lines.Count-2],1,'=');
     Caption:=Caption+' '+StringDataFromRow(MemoAppr.Lines[MemoAppr.Lines.Count-1],1,'=');
    end
   else
     for I := StartLineNumber+2 to MemoAppr.Lines.Count-1 do
       Caption:=Caption+' '+StringDataFromRow(MemoAppr.Lines[i],1,'=');



   i:=Min(0,SLResult.Count-1);
   if i=0 then
     begin
     repeat
      if Caption=SLResult[i] then
       begin
        DataLineNumber:=i+1;
        Break;
       end;
      inc(i);
     until (i>SLResult.Count-1);
     i:=i-1;
     end;
   if i=SLResult.Count-1 then
    begin
     SLResult.Add(Caption);
     DataLineNumber:=SLResult.Count;
    end;

   Caption:=ChangeFileExt(MemoAppr.Lines[StartLineNumber+1], '');
   if Tstr<>'0' then
    Caption:=Caption+' '+Tstr;

   if MemoAppr.Lines[StartLineNumber]=CustomNames[6] then
   begin
     Vector:=TVector.Create;
     i:=StartLineNumber+3;
     repeat
      Vector.Add(FloatDataFromRow(MemoAppr.Lines[i],2,'='),i);
      i:=i+3;
     until i>MemoAppr.Lines.Count-3-tempInt*2;
     Vector.Sorting;
//     for i:=0 to Vector.HighNumber do
//      begin
//        j:=round(Vector.Y[i]);
//        Caption:=Caption+' '+
//           StringDataFromRow(MemoAppr.Lines[j-1],2,'=');
//        Caption:=Caption+' '+
//           StringDataFromRow(MemoAppr.Lines[j],2,'=');
//        Caption:=Caption+' '+
//           StringDataFromRow(MemoAppr.Lines[j+1],2,'=');
//      end;
     for i:=0 to Vector.HighNumber do
      begin
        j:=round(Vector.Y[i]);
        Caption:=Caption+' '+
           StringDataFromRow(MemoAppr.Lines[j],2,'=');
      end;
     for i:=0 to Vector.HighNumber do
      begin
        j:=round(Vector.Y[i]);
        Caption:=Caption+' '+
           StringDataFromRow(MemoAppr.Lines[j-1],2,'=');
      end;
     for i:=0 to Vector.HighNumber do
      begin
        j:=round(Vector.Y[i]);
        Caption:=Caption+' '+
           StringDataFromRow(MemoAppr.Lines[j+1],2,'=');
      end;

     for i:=0 to Vector.HighNumber do
      begin
        j:=round(Vector.Y[i]);
        Caption:=Caption+' '+
           StringDataFromRow(MemoAppr.Lines[StartLineNumber+1+3*tempInt+((j-StartLineNumber) div 3)],2,'=');
      end;
     for i:=0 to Vector.HighNumber do
      begin
        j:=round(Vector.Y[i]);
        Caption:=Caption+' '+
           StringDataFromRow(MemoAppr.Lines[StartLineNumber+1+4*tempInt+((j-StartLineNumber) div 3)],2,'=');
      end;
     Caption:=Caption+' '+StringDataFromRow(MemoAppr.Lines[MemoAppr.Lines.Count-2],2,'=');
     Caption:=Caption+' '+StringDataFromRow(MemoAppr.Lines[MemoAppr.Lines.Count-1],2,'=');
     FreeAndNil(Vector);
   end
//   else if cmd = 'stop' then
   else
     begin
       for I := StartLineNumber+2 to MemoAppr.Lines.Count-1 do
        Caption:=Caption+' '+StringDataFromRow(MemoAppr.Lines[i],2,'=');
     end;



   SLResult.Insert(DataLineNumber,Caption);
   SLResult.SaveToFile(AprResDatName);


// showmessage(StringDataFromRow(Temper.Caption,3));
//  showmessage(inttostr(StartLineNumber));

//  showmessage(MemoAppr.Lines[MemoAppr.Lines.Count-1]);
//  showmessage(MemoAppr.Lines[0]);
  FreeAndNil(SLResult);
end;

procedure TForm1.ButtonCreateDateClick(Sender: TObject);
var
  SR : TSearchRec;
  ShotName,DatesFileName:string;
  Vax:TVectorShottky;
  Rs,n:double;
  i,j:integer;
  T_bool,ToStop:boolean;
  dat:TArrStr;
  CL:TColName;
  Nrep:byte;

begin

{XP Win}
 FormatSettings.DecimalSeparator:='.';
// DecimalSeparator:='.';
SetLength(dat,ord(High(TColName))+1);
if (LDateFun.Caption<>'None')and(CBDateFun.Checked) then
 begin
  FitFunctionNew:=FitFunctionFactory(LDateFun.Caption);
  FitFunctionNew.ParameterNamesToArray(dat);
  FreeAndNil(FitFunctionNew);
 end;

ToStop:=False;
T_bool:=False;
if not(SetCurrentDir(CurDirectory)) then
   begin
   MessageDlg('Current directory is not exist', mtError,[mbOk],0);
   Exit;
   end;
DatesFileName:=CurDirectory+'\'+'dates.dat';

if FindFirst(mask, faAnyFile, SR) = 0 then
  begin
    Vax:=TVectorShottky.Create;

    StrGridData.RowCount:=2;
    AddRowToFileFromStringGrid(DatesFileName,StrGridData,0);
    repeat
     ShotName:=AnsiUpperCase(SR.name);
     if FileNameIsBad(ShotName)then Continue;
     try
     Vax.ReadFromFile(SR.name);
     except
     Vax.T:=0;
     end;
     ShotName:=copy(ShotName,1,length(ShotName)-4);
     //в ShotName коротке ім'я файла - те що вводиться при вимірах :)
     if Vax.T=0 then T_bool:=True;
//     {встановлюється змінна, яка показує що є файли з невизначеною температурою}

     dat[ord(fname)]:=ShotName;
     for I := 1 to 4-length(dat[ord(fname)])
        do insert('0',dat[ord(fname)],1);

     if Vax.time='' then dat[ord(time)]:=IntToStr(SR.Time)
                     else dat[ord(time)]:=Vax.time;

     dat[ord(Tem)]:=FloatToStrF(Vax.T,ffGeneral,5,2);
     if Vax.T=0 then dat[ord(kT_1)]:='555'
                 else dat[ord(kT_1)]:=FloatToStrF(1/Kb/Vax.T,ffGeneral,5,3);

      if Vax.T=0 then  Vax.T:=300;

     // обчислення за функцією Чюнга
     if (Rs_Ch in ColNames) or (n_Ch in ColNames) then
      begin
      Vax.ChungKalk(D[diChung],GraphParameters.Rs,GraphParameters.n);
      dat[ord(Rs_Ch)]:=FloatToStrF(GraphParameters.Rs,ffExponent,3,2);
      dat[ord(n_Ch)]:=FloatToStrF(GraphParameters.n,ffGeneral,4,3);
      end;

     // обчислення за Н-функцією
     if (Rs_H in ColNames) or (Fb_H in ColNames) then
      begin
      n:=nDefineCB(Vax,ComBDateHfunN,ComBDateHfunN_Rs);
      Vax.HFunKalk(D[diHfunc],Diod,n,GraphParameters.Rs,GraphParameters.Fb);
      dat[ord(Rs_H)]:=FloatToStrF(GraphParameters.Rs,ffExponent,3,2);
      dat[ord(Fb_H)]:=FloatToStrF(GraphParameters.Fb,ffGeneral,3,2);
      end; // (Rs_H in ColNames) or (Fb_H in ColNames) then

     // обчислення за функцією Норда
     if (Rs_N in ColNames) or (Fb_N in ColNames) then
      begin
      n:=nDefineCB(Vax,ComBDateNordN,ComBDateNordN_Rs);
      Vax.NordKalk(D[diNord],Diod,GraphParameters.Gamma,n,GraphParameters.Rs,GraphParameters.Fb);
      dat[ord(Rs_N)]:=FloatToStrF(GraphParameters.Rs,ffExponent,3,2);
      dat[ord(Fb_N)]:=FloatToStrF(GraphParameters.Fb,ffGeneral,3,2);
      end;//(Rs_N in ColNames) or (Fb_N in ColNames) then

     // обчислення шляхом апроксимації І=I0(exp(V/nkT)-1)
     if (Is_Exp in ColNames) or (n_Exp in ColNames)
         or (Fb_Exp in ColNames) then
      begin
       Rs:=RsDefineCB(Vax,ComBDateExpRs,ComBDateExpRs_n);
       Vax.ExpKalk(D[diExp],Rs,Diod,ApprExp,GraphParameters.n,GraphParameters.I0,GraphParameters.Fb);
       dat[ord(n_Exp)]:=FloatToStrF(GraphParameters.n,ffGeneral,4,3);
       dat[ord(Is_Exp)]:=FloatToStrF(GraphParameters.I0,ffExponent,3,2);
       dat[ord(Fb_Exp)]:=FloatToStrF(GraphParameters.Fb,ffGeneral,3,2);
      end;

      //обчислення шляхом апроксимації І/[1-exp(-qV/kT)]=I0exp(V/nkT), пряма ділянка
      if (Is_E2F in ColNames) or (n_E2F in ColNames)
         or (Fb_E2F in ColNames) then
       begin
        Rs:=RsDefineCB(Vax,ComBDateEx2FRs,ComBDateEx2FRs_n);
        Vax.ExKalk(2,D[diE2F],Rs,Diod,GraphParameters.n,GraphParameters.I0,GraphParameters.Fb);
        dat[ord(n_E2F)]:=FloatToStrF(GraphParameters.n,ffGeneral,4,3);
        dat[ord(Is_E2F)]:=FloatToStrF(GraphParameters.I0,ffExponent,3,2);
        dat[ord(Fb_E2F)]:=FloatToStrF(GraphParameters.Fb,ffGeneral,3,2);
      end;

      //обчислення шляхом апроксимації І/[1-exp(-qV/kT)]=I0exp(V/nkT), зворотня ділянка
      if (Is_E2R in ColNames) or (n_E2R in ColNames)
         or (Fb_E2R in ColNames) then
       begin
        Rs:=RsDefineCB(Vax,ComBDateEx2RRs,ComBDateEx2RRs_n);
        Vax.ExKalk(3,D[diE2R],Rs,Diod,GraphParameters.n,GraphParameters.I0,GraphParameters.Fb);
        dat[ord(n_E2R)]:=FloatToStrF(GraphParameters.n,ffGeneral,4,3);
        dat[ord(Is_E2R)]:=FloatToStrF(GraphParameters.I0,ffExponent,3,2);
        dat[ord(Fb_E2R)]:=FloatToStrF(GraphParameters.Fb,ffGeneral,3,2);
      end;

     //обчислення коефіцієнту випрямлення
    if (Kr in ColNames) then
     begin
     GraphParameters.Krec:=Vax.Krect(GraphParameters.Vrect);
     dat[ord(Kr)]:=FloatToStrF(GraphParameters.Krec,ffGeneral,3,2);
     end;

     // обчислення за функцією Камінські І-роду
     if (Rs_K1 in ColNames) or (n_K1 in ColNames) then
      begin
      Vax.Kam1Kalk(D[diKam1],GraphParameters.Rs,GraphParameters.n);
      dat[ord(Rs_K1)]:=FloatToStrF(GraphParameters.Rs,ffExponent,3,2);
      dat[ord(n_K1)]:=FloatToStrF(GraphParameters.n,ffGeneral,4,3);
      end;  //if (Rs_K1 in ColNames) or (n_K1 in ColNames) then

     // обчислення за функцією Камінські IІ-роду
     if (Rs_K2 in ColNames) or (n_K2 in ColNames) then
      begin
      Vax.Kam2Kalk(D[diKam2],GraphParameters.Rs,GraphParameters.n);
      dat[ord(Rs_K2)]:=FloatToStrF(GraphParameters.Rs,ffExponent,3,2);
      dat[ord(n_K2)]:=FloatToStrF(GraphParameters.n,ffGeneral,4,3);

      end;  //Rs_K2 in ColNames) or (n_K2 in ColNames) then

     // обчислення за функцією Громова І-роду
     if (Rs_Gr1 in ColNames) or (n_Gr1 in ColNames)
         or (Is_Gr1 in ColNames) or (Fb_Gr1 in ColNames) then
      begin
      Vax.Gr1Kalk (D[diGr1],Diod,GraphParameters.Rs,GraphParameters.n,GraphParameters.Fb,GraphParameters.I0);
      dat[ord(Rs_Gr1)]:=FloatToStrF(GraphParameters.Rs,ffExponent,3,2);
      dat[ord(n_Gr1)]:=FloatToStrF(GraphParameters.n,ffGeneral,4,3);
      dat[ord(Is_Gr1)]:=FloatToStrF(GraphParameters.I0,ffExponent,3,2);
      dat[ord(Fb_Gr1)]:=FloatToStrF(GraphParameters.Fb,ffGeneral,3,2);

      end;

     // обчислення за функцією Громова ІI-роду
     if (Rs_Gr2 in ColNames) or (n_Gr2 in ColNames)
         or (Is_Gr2 in ColNames) or (Fb_Gr2 in ColNames) then
      begin
      Vax.Gr2Kalk (D[diGr2],Diod,GraphParameters.Rs,GraphParameters.n,GraphParameters.Fb,GraphParameters.I0);
      dat[ord(Rs_Gr2)]:=FloatToStrF(GraphParameters.Rs,ffExponent,3,2);
      dat[ord(n_Gr2)]:=FloatToStrF(GraphParameters.n,ffGeneral,4,3);
      dat[ord(Is_Gr2)]:=FloatToStrF(GraphParameters.I0,ffExponent,3,2);
      dat[ord(Fb_Gr2)]:=FloatToStrF(GraphParameters.Fb,ffGeneral,3,2);
      end;

     // обчислення за методом Вернера
     if (Rs_Wer in ColNames) or (n_Wer in ColNames) then
      begin
      Vax.WernerKalk(D[diWer],GraphParameters.Rs,GraphParameters.n);
      dat[ord(Rs_Wer)]:=FloatToStrF(GraphParameters.Rs,ffExponent,3,2);
      dat[ord(n_Wer)]:=FloatToStrF(GraphParameters.n,ffGeneral,4,3);
      end;  //if (Rs_Wer in ColNames) or (n_Wer in ColNames) then

     // обчислення за методом Сібілса
     if (Rs_Cb in ColNames) or (n_Cb in ColNames) then
      begin
      Vax.CibilsKalk(D[diCib],GraphParameters.Rs,GraphParameters.n);
      dat[ord(Rs_Cb)]:=FloatToStrF(GraphParameters.Rs,ffExponent,3,2);
      dat[ord(n_Cb)]:=FloatToStrF(GraphParameters.n,ffGeneral,4,3);
      end;  //if (Rs_Cb in ColNames) or (n_Cb in ColNames) then


      //обчислення шляхом апроксимації І=I0exp(V/nkT)
      if (Is_El in ColNames) or (n_El in ColNames)
         or (Fb_El in ColNames) then
       begin
        Rs:=RsDefineCB(Vax,ComBDateExRs,ComBDateExRs_n);
        Vax.ExKalk(1,D[diEx],Rs,Diod,GraphParameters.n,GraphParameters.I0,GraphParameters.Fb);
        dat[ord(n_El)]:=FloatToStrF(GraphParameters.n,ffGeneral,4,3);
        dat[ord(Is_El)]:=FloatToStrF(GraphParameters.I0,ffExponent,3,2);
        dat[ord(Fb_El)]:=FloatToStrF(GraphParameters.Fb,ffGeneral,3,2);
      end;

     // обчислення за методом Бохліна
     if (Rs_Bh in ColNames) or (n_Bh in ColNames)
         or (Is_Bh in ColNames) or (Fb_Bh in ColNames) then
      begin
      Vax.BohlinKalk(D[diNord],Diod,GraphParameters.Gamma1,GraphParameters.Gamma2,
          GraphParameters.Rs,GraphParameters.n,GraphParameters.Fb,GraphParameters.I0);
      dat[ord(Rs_Bh)]:=FloatToStrF(GraphParameters.Rs,ffExponent,3,2);
      dat[ord(n_Bh)]:=FloatToStrF(GraphParameters.n,ffGeneral,4,3);
      dat[ord(Is_Bh)]:=FloatToStrF(GraphParameters.I0,ffExponent,3,2);
      dat[ord(Fb_Bh)]:=FloatToStrF(GraphParameters.Fb,ffGeneral,3,2);
      end;

     // обчислення за методом Лі
     if (Rs_Lee in ColNames) or (n_Lee in ColNames)
         or (Is_Lee in ColNames) or (Fb_Lee in ColNames) then
      begin
      Vax.LeeKalk (D[diLee],Diod,GraphParameters.Rs,GraphParameters.n,GraphParameters.Fb,GraphParameters.I0);
      dat[ord(Rs_Lee)]:=FloatToStrF(GraphParameters.Rs,ffExponent,3,2);
      dat[ord(n_Lee)]:=FloatToStrF(GraphParameters.n,ffGeneral,4,3);
      dat[ord(Is_Lee)]:=FloatToStrF(GraphParameters.I0,ffExponent,3,2);
      dat[ord(Fb_Lee)]:=FloatToStrF(GraphParameters.Fb,ffGeneral,3,2);
      end;

     //Обчислення за методом Міхелашвілі
     if (Rs_Mk in ColNames) or (n_Mk in ColNames)
         or (Is_Mk in ColNames) or (Fb_Mk in ColNames) then
      begin
      Vax.MikhKalk (D[diMikh],Diod,GraphParameters.Rs,GraphParameters.n,GraphParameters.I0,GraphParameters.Fb);
      dat[ord(Rs_Mk)]:=FloatToStrF(GraphParameters.Rs,ffExponent,3,2);
      dat[ord(n_Mk)]:=FloatToStrF(GraphParameters.n,ffGeneral,4,3);
      dat[ord(Is_Mk)]:=FloatToStrF(GraphParameters.I0,ffExponent,3,2);
      dat[ord(Fb_Mk)]:=FloatToStrF(GraphParameters.Fb,ffGeneral,3,2);
      end;


    Nrep:=1;
    //обчислення за допомогою обраної функції
    if (LDateFun.Caption<>'None')and(CBDateFun.Checked) then
     begin
      FitFunctionNew:=FitFunctionFactory(LDateFun.Caption);

      if (FitFunctionNew is TFFIteration)
        then  Nrep:=(FitFunctionNew as TFFIteration).Nrep;


      for j := 1 to Nrep do
      begin
        FitFunctionNew.Fitting(Vax);
        if FitFunctionNew.ResultsIsReady then
         for i:=0 to FitFunctionNew.ParametersNumber-1 do
          StrGridData.Cells[StrGridData.ColCount-1-i,StrGridData.RowCount-1]:=
             FloatToStrF((FitFunctionNew as TFFSimple).DParamArray.OutputData[FitFunctionNew.ParametersNumber-1-i],ffExponent,10,2)
                                         else
         begin
           ToStop:=True;
           Break;
         end;
        StrGridData.RowCount:=StrGridData.RowCount+1;
//        if ToStop then Break;

      end;
      FreeAndNil(FitFunctionNew);
      StrGridData.RowCount:=StrGridData.RowCount-1;
     end;

    if ToStop then Break;


    i:=0;
    for CL:=Low(CL) to High(CL) do
      if (CL in ColNames) then
        begin
        for j := 1 to Nrep do
         StrGridData.Cells[i,StrGridData.RowCount-Nrep-1+j]:=dat[ord(CL)];
        i:=i+1;
        end;
//_________________________
//  if not(ToStop) then

   for I := 1 to Nrep do
   AddRowToFileFromStringGrid(DatesFileName,StrGridData,StrGridData.RowCount-Nrep-1+i);
//___________________________
    StrGridData.RowCount:=StrGridData.RowCount+1;

    until (FindNext(SR) <> 0);

   StrGridData.RowCount:=StrGridData.RowCount-1;
   SortGrid(StrGridData,0);

   StringGridToFile(DatesFileName,StrGridData);
    FreeAndNil(Vax);

    FindClose(SR);
    if T_bool then MessageDlg('Some data can be equal 555 because temperuture is undefined', mtInformation,[mbOk],0);
  end
                                     else
          MessageDlg('No *.dat file in current directory', mtError,[mbOk],0);
end;



procedure TForm1.ButtonCreateFileClick(Sender: TObject);
var
  SR : TSearchRec;
  ShotName:string;
  Vax:TVectorShottky;
  tempVax:TVector;
  j:integer;
  T_bool:boolean;
  Inform:TStringList;
  F:TextFile;
  DR:TDirName;
begin
T_bool:=False;
if not(SetCurrentDir(CurDirectory)) then
   begin
   MessageDlg('Current directory is not exist', mtError,[mbOk],0);
   Exit;
   end;
if FindFirst(mask, faAnyFile, SR) = 0 then
  begin
    Vax:=TVectorShottky.Create;
    tempVax:=TVector.Create;
    Inform:=TStringlist.Create;

{створюються потрібні директорії}
   for DR := Low(DR) to High(DR) do
      begin
      try
      if (DR in DirNames) then
          MkDir(GetEnumName(TypeInfo(TDirName),ord(DR)));
      except
      ;
      end; //try
      end;

    repeat
     ShotName:=AnsiUpperCase(SR.name);
//     Read_File(SR.name,Vax);
     Vax.ReadFromFile(SR.name);
     ShotName:=copy(ShotName,1,length(ShotName)-4);
     //в ShotName коротке ім'z файла - те що вводиться при вимірах :)
     Inform.Add(ShotName);
     Inform.Add('T='+FloatToStrF(Vax.T,ffGeneral,5,2));
     if Vax.T=0 then T_bool:=True;
     {встановлюється змінна, яка показує що є файли з невизначеною температурою}


     for DR := Low(DR) to High(DR) do
        if (DR in DirNames) then
      begin
      case DR of
       ForwRs:
        Vax.ForwardIVwithRs(tempVax,RsDefineCB(Vax,ComBForwRs,ComBForwRs_n));
{---------------------------------------------}
       Cheung:
        Vax.ChungFun(tempVax);
{---------------------------------------------}
       Hfunct:
        Vax.HFun(tempVax,Diod,nDefineCB(Vax,CombHfuncN,CombHfuncN_Rs));
{---------------------------------------------}
       Norde:
         Vax.NordeFun(tempVax,Diod,GraphParameters.Gamma);
{---------------------------------------------}
       Ideal:
         Vax.N_V_Fun(tempVax,RsDefineCB(Vax,ComBNRs,ComBNRs_n));
{---------------------------------------------}
       Nss:
         begin
        Vax.Nss_Fun(tempVax,
               FbDefineCB(Vax,ComboBNssFb,RsDefineCB(Vax,ComBNssRs,ComBNssRs_n)),
               RsDefineCB(Vax,ComBNssRs,ComBNssRs_n),
               Diod,D[diNss],RadButNssNvD.Checked);
          TempVax.Sorting;
         end;
{---------------------------------------------}
       Reverse:
        Vax.ReverseIV(tempVax);
{---------------------------------------------}
       Kamin1:
         Vax.Kam1_Fun(tempVax,D[diKam1]);
{---------------------------------------------}
       Kamin2:
         Vax.Kam2_Fun(tempVax,D[diKam2]);
{---------------------------------------------}
       Gromov1:
         Vax.Gr1_Fun(tempVax);
{---------------------------------------------}
       Gromov2:
         Vax.Gr2_Fun(tempVax,Diod);
{---------------------------------------------}
       Cibil:
         Vax.CibilsFun(tempVax,D[diCib]);
{---------------------------------------------}
       Lee:
         Vax.LeeFun(tempVax,D[diLee]);
{---------------------------------------------}
       Werner:
         Vax.WernerFun(tempVax);
{---------------------------------------------}
       MAlpha:
         Vax.MikhAlpha_Fun(tempVax);
{---------------------------------------------}
       MBetta:
         Vax.MikhBetta_Fun(tempVax);
{---------------------------------------------}
       MIdeal:
         Vax.MikhN_Fun(tempVax);
{---------------------------------------------}
       MRserial:
         Vax.MikhRs_Fun(tempVax);
{---------------------------------------------}
       Dit:
         Vax.Dit_Fun(tempVax,
                 RsDefineCB(Vax,ComBDitRs,ComBDitRs_n),
                 Diod,D[diIvan]);
{---------------------------------------------}
      Exp2F:
        Vax.Forward2Exp(tempVax,RsDefineCB(Vax,ComBExp2FRs,ComBExp2FRs_n));
{---------------------------------------------}
      Exp2R:
        Vax.Reverse2Exp(tempVax,RsDefineCB(Vax,ComBExp2RRs,ComBExp2RRs_n));
{---------------------------------------------}
       M_V:
         Vax.M_V_Fun(tempVax,CBM_Vdod.Checked,fnPowerIndex);
{---------------------------------------------}
       Fow_Nor:
         Vax.M_V_Fun(tempVax,CBFow_Nordod.Checked,fnFowlerNordheim);
{---------------------------------------------}
       Fow_NorE:
         Vax.M_V_Fun(tempVax,CBFow_NorEdod.Checked,fnFowlerNordheimEm);
{---------------------------------------------}
       Abeles:
         Vax.M_V_Fun(tempVax,CBAbelesdod.Checked,fnAbeles);
{---------------------------------------------}
       AbelesE:
         Vax.M_V_Fun(tempVax,CBAbelesEdod.Checked,fnAbelesEm);
{---------------------------------------------}
       Fr_Pool:
         Vax.M_V_Fun(tempVax,CBFr_Pooldod.Checked,fnFrenkelPool);
{---------------------------------------------}
       Fr_PoolE:
         Vax.M_V_Fun(tempVax,CBFr_PoolEdod.Checked,fnFrenkelPoolEm);
     end; //case
       tempVax.WriteToFile(CurDirectory+'\'+
         GetEnumName(TypeInfo(TDirName),ord(DR))+'\'+ShotName+
         GetEnumName(TypeInfo(Tfile_end),ord(DR))+'.dat');
       end;

    until FindNext(SR) <> 0;

    for DR := Low(DR) to High(DR) do
      if (DR in DirNames) then
       begin
        AssignFile(f,CurDirectory+'\'+
        GetEnumName(TypeInfo(TDirName),ord(DR))+'\'+CommentsDat);
        Rewrite(f);
        for j := 0 to Inform.Count-1 do
         if Odd(j) then
             begin
             writeln(f,Inform[j]);
             writeln(f);
             end
                   else
    writeln(f,Inform[j]+
            GetEnumName(TypeInfo(Tfile_end),ord(DR))+'.dat');
        CloseFile(f);
       end;
    Vax.Free;
    tempVax.Free;
    Inform.Free;
    FindClose(SR);
    MessageDlg('Directory with files were created sucsesfully', mtInformation,[mbOk],0);
    if T_bool then MessageDlg('Some file can be absent because temperuture is undefined', mtInformation,[mbOk],0);
  end
                                     else
          MessageDlg('No *.dat file in current directory', mtError,[mbOk],0);
end;

procedure TForm1.ButtonCurDirClick(Sender: TObject);
var st:string;
begin
st:=CurDirectory;
SelectDirectory('Chose Directory','', CurDirectory);
ChooseDirect(Form1);
Directory:=CurDirectory;
end;


procedure TForm1.ButtonKalkClick(Sender: TObject);
 var tg:TGraph;
begin
LabelKalk1.Visible:=False;
LabelKalk2.Visible:=False;
LabelKalk3.Visible:=False;
GraphParameters.Clear;

 tg:=ConvertStringToTGraph(CBKalk);

if VaxFile.T<=0 then
 begin
  if tg in [fnCheung,fnKaminskii1,fnKaminskii2,
            fnGromov1, fnCibils, fnLee, fnMikhelashvili] then
     MessageDlg('Only Rs can be calculated by this method,'+#10+#13+
                'because T is undefined',mtError, [mbOK], 0);
   {вибрано або метод Чюнга, або Камінського І та ІІ роду,
    або Громова І роду, або Сібілса, або Лі, або Міхелашвілі}
   if tg in [fnH, fnNorde,fnDiodVerySimple,
             fnDiodLSM,fnGromov2,fnBohlin,
             fnDLdensityIvanov,fnWerner,
             fnDiodLambert,fnDiodEvolution,
             fnExpForwardRs,fnExpReverseRs] then
      begin
       MessageDlg('Anything can not be calculated by this method,'+#10+#13+
                'because T is undefined',mtError, [mbOK], 0);
       Exit;
      end;
 end;  // if VaxFile^.T<=0 then


 if tg=fnDLdensityIvanov then
   RsDefineCB(VaxFile,ComboBoxNssRs,ComboBoxNssRs_n);
 if tg in [fnH,fnNorde] then
   nDefineCB(VaxFile,Form1.ComboBoxN,Form1.ComboBoxN_Rs);
 if tg in [fnDiodVerySimple,fnExpForwardRs,fnExpReverseRs] then
     RsDefineCB(VaxFile,Form1.ComboBoxRs,Form1.ComboBoxRs_n);

//QueryPerformanceCounter(StartValue);

 GraphParameters.Diapazon:=D[ConvertTGraphToTDiapazons(tg)];
 VaxFile.GraphParameterCalculation(tg);



//QueryPerformanceCounter(EndValue);
//QueryPerformanceFrequency(Freq);
//showmessage('tics='+inttostr(EndValue-StartValue)+#10+#13+
//             'time='+floattostr((EndValue-StartValue)/Freq)
//             +' s'+#10+#13+
//                'freq+'+inttostr(Freq));

 if tg in [fnH,fnNorde] then GraphParameters.n:=ErResult;
 if tg in [fnDiodVerySimple,fnExpForwardRs,fnExpReverseRs] then
      GraphParameters.Rs:=ErResult;
 if tg=fnDLdensityIvanov then
    begin
    GraphParameters.n:=ErResult;
    GraphParameters.Rs:=ErResult;
    end;

LabelKalk1.Visible:=(GraphParameters.Rs<>ErResult);
if LabelKalk1.Visible then
    LabelKalk1.Caption:='Rs='+FloatToStrF(GraphParameters.Rs,ffExponent,3,2);
LabelKalk2.Visible:=(GraphParameters.n<>ErResult);
if LabelKalk2.Visible then
    LabelKalk2.Caption:='n='+FloatToStrF(GraphParameters.n,ffGeneral,4,3);
LabelKalk3.Visible:=(GraphParameters.Fb<>ErResult);
if LabelKalk3.Visible then
    LabelKalk3.Caption:='Фb='+FloatToStrF(GraphParameters.Fb,ffGeneral,3,2);
if not(LabelKalk2.Visible) then
 begin
  LabelKalk2.Visible:=(GraphParameters.Krec<>ErResult);
  if LabelKalk2.Visible then
    case tg of
    fnRectification:LabelKalk2.Caption:='Krect='+FloatToStrF(GraphParameters.Krec,ffGeneral,3,2);
    fnDLdensityIvanov:LabelKalk2.Caption:='del='+ FloatToStrF(GraphParameters.Krec,ffExponent,2,1)+' m';
    end;
 end;
end;

procedure TForm1.ButtonKalkParClick(Sender: TObject);
 var tg:TGraph;
begin

tg:=ConvertStringToTGraph(CBKalk);

case tg of
  fnRectification: //Обчислення коефіцієнту випрямлення
     ButtonParamRectClick(ButtonKalkPar);
  else
   begin
   ButtonParamCibClick(ButtonKalkPar);
   CBKalkChange(ButtonKalkPar);
   end;
 end //case
end;

procedure TForm1.ButtonMaxClick(Sender: TObject);
var st, stHint:string;
begin
if LabelMax.Caption='No' then st:=''
                         else st:=LabelMax.Caption;

stHint:='Enter the maximum value of '+
       RdGrMax.Items[RdGrMax.ItemIndex]+' coordinate';

st:=InputBox('Input Hi Limit',stHint,st);
StrToNumber(st, ErResult, GrLim.MaxValue[GrLim.MaxXY]);
LimitSetup(GrLim, RdGrMin, RdGrMax, LabelMin, LabelMax);
if Form1.SpButLimit.Down then
                begin
                Form1.SpButLimit.Down:=False;
                VaxTempLim.CopyTo(VaxGraph);
                DataToGraph(Series1,Series2,Graph,
                Graph.Title.Text.Strings[0],VaxGraph);
                MarkerHide(Form1);
                Form1.CBMarker.Checked:=False;
                end;
end;

procedure TForm1.ButtonMinClick(Sender: TObject);
var st, stHint:string;
begin
if LabelMin.Caption='No' then st:=''
                         else st:=LabelMin.Caption;

stHint:='Enter the minimum value of '+
       RdGrMin.Items[RdGrMin.ItemIndex]+' coordinate';

st:=InputBox('Input Low Limit',stHint,st);
StrToNumber(st, ErResult, GrLim.MinValue[GrLim.MinXY]);
LimitSetup(GrLim, RdGrMin, RdGrMax, LabelMin, LabelMax);
if Form1.SpButLimit.Down then
                begin
                Form1.SpButLimit.Down:=False;
                VaxTempLim.CopyTo(VaxGraph);
                DataToGraph(Series1,Series2,Graph,
                Graph.Title.Text.Strings[0],VaxGraph);
                MarkerHide(Form1);
                Form1.CBMarker.Checked:=False;
                end;
end;


procedure TForm1.ButtonParamRectClick(Sender: TObject);
begin
 InputValueToLabel('Input rectification voltage',
                   'Enter rectification voltage Vrec;'
                    +Chr(13)+Chr(13)+
                   'The rectification coeficient' +Chr(13)+
                  'Kr = Iforward(Vrec) / Ireverse(Vrec)'+Chr(13),
                   ffGeneral,
                   LabelRect,GraphParameters.Vrect);
end;


procedure TForm1.ButtonParamCibClick(Sender: TObject);
begin
 FormDiapazon(DiapFunName(Sender, BohlinMethod));
end;

procedure TForm1.ButtonVoltClick(Sender: TObject);
var
  SR : TSearchRec;
  mask,ShotName:string;
  Vax:TVectorShottky;
  i,j,k:integer;
  F:TextFile;
  Grid:TStringGrid;
  Cur:double;

begin
if ListBoxVolt.Items.Count=0 then Exit;

if not(SetCurrentDir(CurDirectory)) then
   begin
   MessageDlg('Current directory is not exist', mtError,[mbOk],0);
   Exit;
   end;
mask:='*.dat';
if FindFirst(mask, faAnyFile, SR) = 0 then
  begin
    Vax:=TVectorShottky.Create;
      try
      MkDir('Zriz');
      except
      ;
      end; //try
     {створюються потрібні директорії}
    Grid:=TStringGrid.Create(Sender as TComponent);
    Grid.RowCount:=2;
    k:=1;
    if CheckBoxLnIT2.Checked then k:=k+1;
    if CheckBoxnLnIT2.Checked then k:=k+1;

    Grid.ColCount:=k*ListBoxVolt.Items.Count+5;
    //************
    if CBVoc.Checked then Grid.ColCount:=Grid.ColCount+1;
    //************
    Grid.Cells[0,0]:='name';
    Grid.Cells[2,0]:='T';
    Grid.Cells[3,0]:='kT_1';
    Grid.Cells[1,0]:='time';
    for i := 0 to ListBoxVolt.Items.Count-1 do
       begin
       Grid.Cells[k*i+4,0]:='I';
       if (CheckBoxLnIT2.Checked)then Grid.Cells[k*i+1+4,0]:='LnIT2';
       if (CheckBoxnLnIT2.Checked)and(not(CheckBoxLnIT2.Checked)) then
                                           Grid.Cells[k*i+1+4,0]:='nLnIT2';
       if k=3 then Grid.Cells[k*i+2+4,0]:='nLnIT2';
       //************
       if CBVoc.Checked then Grid.Cells[Grid.ColCount-1,0]:='Voc';
       //************
       end;

    repeat
     ShotName:=AnsiUpperCase(SR.name);
     Vax.ReadFromFile(SR.name);
     ShotName:=copy(ShotName,1,length(ShotName)-4);
     //в ShotName коротке ім'z файла - те що вводиться при вимірах :)
     if length(ShotName)<3 then insert('0',ShotName,1);
     if length(ShotName)<3 then insert('0',ShotName,1);

     Grid.Cells[0,Grid.RowCount-1]:=ShotName;
     Grid.Cells[1,Grid.RowCount-1]:=Vax.time;
     Grid.Cells[2,Grid.RowCount-1]:=FloatToStrF(Vax.T,ffGeneral,4,1);
     if Vax.T=0 then Grid.Cells[3,Grid.RowCount-1]:='555'
                else Grid.Cells[3,Grid.RowCount-1]:=FloatToStrF(1/Kb/Vax.T,ffGeneral,4,2);
     Grid.Cells[Grid.ColCount-1,Grid.RowCount-1]:=IntToStr(SR.Time);

     for I := 0 to High(Volt) do
     begin
       Cur:=abs(Vax.Yvalue(Volt[i]));
       Grid.Cells[k*i+4,Grid.RowCount-1]:=FloatToStrF(Cur,ffExponent,4,3);
       if (CheckBoxLnIT2.Checked)then
           if ((Vax.T)>0)and(Cur<>ErResult)
                         then Grid.Cells[k*i+1+4,Grid.RowCount-1]:=
                                  FloatToStrF(ln(Cur/sqr(Vax.T)),ffExponent,5,4)
                         else Grid.Cells[k*i+1+4,Grid.RowCount-1]:='555';

       RsDefineCB(Vax,ComBDateExRs,ComBDateExRs_n);
       GraphParameters.Diapazon:=D[diEx];
       Vax.ExKalk(1);

       if (CheckBoxnLnIT2.Checked)and(not(CheckBoxLnIT2.Checked)) then
           if ((Vax.T)>0)and(Cur<>ErResult)and(GraphParameters.n<>ErResult)
                         then Grid.Cells[k*i+1+4,Grid.RowCount-1]:=
                                  FloatToStrF(GraphParameters.n*ln(Cur/sqr(Vax.T)),ffExponent,5,4)
                         else Grid.Cells[k*i+1+4,Grid.RowCount-1]:='555';
       if k=3 then
           if ((Vax.T)>0)and(Cur<>ErResult)and(GraphParameters.n<>ErResult)
                         then Grid.Cells[k*i+2+4,Grid.RowCount-1]:=
                                  FloatToStrF(GraphParameters.n*ln(Cur/sqr(Vax.T)),ffExponent,5,4)
                         else Grid.Cells[k*i+2+4,Grid.RowCount-1]:='555';
     end;
    //************
    if CBVoc.Checked then
     begin
     Cur:=abs(Vax.Yvalue(0));
     Grid.Cells[Grid.ColCount-1,Grid.RowCount-1]:=FloatToStrF(Cur,ffExponent,4,3);
     end;
    //************
    Grid.RowCount:=Grid.RowCount+1;
    until FindNext(SR) <> 0;

   Grid.RowCount:=Grid.RowCount-1;
   SortGrid(Grid,0);

   for I := 0 to High(Volt) do
    begin
    mask:=FloatToStrF(Volt[i],ffGeneral,3,2);
    j:=pos('.',mask);
    if j>0 then begin
            delete(mask,j,1);
            insert('_',mask,j);
            end;
    j:=pos('-',mask);
    if j>0 then begin
           delete(mask,j,1);
           insert('m',mask,j);
           end;
    AssignFile(f,CurDirectory+'\Zriz\'+'vol'+mask+'.dat');
    Rewrite(f);
    for j := 0 to Grid.RowCount-1 do
     if Grid.Cells[k*i+4,j]<>'5.55E+02' then
     begin
      Write(f,Grid.Cells[0,j],' ',Grid.Cells[1,j],' ',
                Grid.Cells[2,j],' ',Grid.Cells[3,j],' ',
                Grid.Cells[k*i+4,j]);
      if k>1 then Write(f,' ',Grid.Cells[k*i+1+4,j]);
      if k=3 then Write(f,' ',Grid.Cells[k*i+2+4,j]);
      Writeln(f);
     end;
    CloseFile(f);

    //************
    if CBVoc.Checked then
     begin
      AssignFile(f,CurDirectory+'\Zriz\'+'Voc.dat');
      Rewrite(f);
      for j := 0 to Grid.RowCount-1 do
       if Grid.Cells[k*i+4,j]<>'5.55E+02' then
        begin
        Write(f,Grid.Cells[0,j],' ',Grid.Cells[1,j],' ',
                Grid.Cells[2,j],' ',Grid.Cells[3,j],' ',
                Grid.Cells[Grid.ColCount-1,j]);
        Writeln(f);
        end;
      CloseFile(f);
     end;
    //************

    end;
    Vax.Free;
    FindClose(SR);
    Grid.Free;

    MessageDlg('Files with current value were created sucsesfully', mtInformation,[mbOk],0);
  end
                                     else
          MessageDlg('No *.dat file in current directory', mtError,[mbOk],0);
end;

procedure TForm1.ButVoltAddClick(Sender: TObject);
var st:string;
    v:double;
    i:integer;
begin
st:='Input voltage value for current definition'+#10+#13+'(in range [-5..5])';
st:=InputBox('Input voltage',st,'');
StrToNumber(st, ErResult, v);
if v=ErResult then Exit;
if abs(V)>5 then
           begin
           MessageDlg('Voltage must be in [-5..5]', mtError,[mbOk],0);
           Exit;
           end;

ListBoxVolt.Items.Add(FloatToStrF(v,ffGeneral,4,2));
ListBoxVolt.Sorted:=False;
ListBoxVolt.Sorted:=True;
SetLength(Volt,ListBoxVolt.Items.Count);
for i := 0 to High(Volt) do
        Volt[i]:=StrToFloat(ListBoxVolt.Items[i]);
end;

procedure TForm1.ButVoltClearClick(Sender: TObject);
begin
ListBoxVolt.Clear;
SetLength(Volt,0);
ButVoltDel.Enabled:=False;
end;

procedure TForm1.ButVoltDelClick(Sender: TObject);
var i:integer;
begin
if ListBoxVolt.ItemIndex>=0 then
  begin
    ListBoxVolt.Items.Delete(ListBoxVolt.ItemIndex);
    ButVoltDel.Enabled:=False;
    SetLength(Volt, ListBoxVolt.Items.Count);
    for I := 0 to High(Volt) do
     Volt[i]:=StrToFloat(ListBoxVolt.Items[i]);
  end;
end;


procedure TForm1.CBDateFunClick(Sender: TObject);
var i:integer;
    tempStr:TArrStr;
begin
ColParam(Form1.StrGridData);
if LDateFun.Caption='None' then Exit;
if CBDateFun.Checked then
       begin
       FitFunctionNew:=FitFunctionFactory(LDateFun.Caption);
        if FitFunctionNew=nil then Exit;

       FitFunctionNew.ParameterNamesToArray(tempStr);
       for i:=0 to High(tempStr) do
          begin
          StrGridData.ColCount:=StrGridData.ColCount+1;
          StrGridData.Cells[StrGridData.ColCount-1, 0]:=tempStr[i];
          StrGridData.Cells[StrGridData.ColCount-1, 1]:='';
          end;
        FreeAndNil(FitFunctionNew);
       end
end;

procedure TForm1.CBDateRs_ChClick(Sender: TObject);
var CL:TColName;
begin
for CL:=Succ(kT_1) to High(CL) do
 if (AnsiPos(GetEnumName(TypeInfo(TColName),ord(CL)),
        (Sender as TCheckBox).Name)<>0)
    then
    begin
      if (Sender as TCheckBox).Checked then Include(ColNames,CL)
                                       else Exclude(ColNames,CL);
      Break;
    end;
ColParam(Form1.StrGridData);
CBDateFun.Checked:=not(CBDateFun.Checked);
CBDateFun.Checked:=not(CBDateFun.Checked);
end;

procedure TForm1.CBDLFunctionClick(Sender: TObject);
begin
  GroupBox36.Caption:=CBDLFunction.Items[CBDLFunction.ItemIndex];
end;

procedure TForm1.CBForwRsClick(Sender: TObject);
var i:integer;
    DR:TDirName;
begin
DR:=Low(DR);
Inc(Dr,(Sender as TControl).Tag-100);
if (Sender as TCheckBox).Checked
   then  Include(DirNames, DR)
   else  Exclude(DirNames, DR);

for I := 0 to Form1.ComponentCount-1 do
 begin
  if (Form1.Components[i].Tag=(Sender as TControl).Tag)and
     (Form1.Components[i] is TLabel)
     then
       begin
        if (Sender as TCheckBox).Checked
          then (Form1.Components[i] as TLabel).Enabled:=True
          else (Form1.Components[i] as TLabel).Enabled:=False;
       end;  //then
 end; //for I := 0 to Form1.ComponentCount-1
end;

procedure TForm1.CBKalkChange(Sender: TObject);
begin
case CBKalk.ItemIndex of
  0:;  //не вибрано спосіб апроксамації
  1: // обчислення за функцією Чюнга
     DiapToLimToTForm1(D[diChung],Form1);
  2:  // обчислення за Н-функцією
     DiapToLimToTForm1(D[diHfunc],Form1);
  3:   // обчислення за функцією Норда
     DiapToLimToTForm1(D[diNord],Form1);
//  4: //обчислення шляхом апроксимації І=I0(exp(V/nkT)-1)
  //   DiapToLimToTForm1(D[diExp],Form1);
  4: //обчислення шляхом апроксимації І=I0exp(V/nkT)
     DiapToLimToTForm1(D[diEx],Form1);
  5:; //Обчислення коефіцієнту випрямлення
  6:; //обчислення за функцією Камінськи І-роду
  7:; //обчислення за функцією Камінськи ІІ-роду
  8: //обчислення за методом Громова І-роду
     DiapToLimToTForm1(D[diGr1],Form1);
  9: //обчислення за методом Громова ІI-роду
     DiapToLimToTForm1(D[diGr2],Form1);
  11: //обчислення за методом Сібілса
     DiapToLimToTForm1(D[diCib],Form1);
  12: //обчислення за методом Лі
     DiapToLimToTForm1(D[diLee],Form1);
  13: //обчислення за методом Вернера
     DiapToLimToTForm1(D[diWer],Form1);
  14: //обчислення за методом Міхелешвілі
     DiapToLimToTForm1(D[diMikh],Form1);
  15: //обчислення за методом Іванова
     DiapToLimToTForm1(D[diIvan],Form1);
  16: //обчислення шляхом апроксимації І/[1-exp(-qV/kT)]=I0exp(V/nkT), пряма ділянка
     DiapToLimToTForm1(D[diE2F],Form1);
  17: //обчислення шляхом апроксимації І/[1-exp(-qV/kT)]=I0exp(V/nkT), зворотня ділянка
     DiapToLimToTForm1(D[diE2R],Form1);
  18: //апроксимація І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph функцією Ламберта
     DiapToLimToTForm1(D[diLam],Form1);
  19: //функція І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph, метод differential evolution
     DiapToLimToTForm1(D[diDE],Form1);
  end; //case;
end;

procedure TForm1.CBMarkerClick(Sender: TObject);
var i:integer;
    bool:boolean;
begin
if CBMarker.Checked then
  begin
//   MarkerDraw(VaxGraph,VaxFile,round(VaxGraph.n/2),Form1);
   MarkerDraw(VaxGraph,VaxFile,round(VaxGraph.Count/2),Form1);
   bool:= not((RadioButtonNss.Checked)or(RadioButtonKam1.Checked)
          or(RadioButtonKam2.Checked)or(RadioButtonCib.Checked)
          or(RadioButtonLee.Checked));
   {bool містить інформацію про те чи не вибрано
    відображення одного з графіків, для яких негарантовано
    правильне відображення координат точок у вихідному файлі;
    елементи, які не мають бути відображені в цьому випадку
    мають Tag=59, для решти візуальних компонент, які пов'язані
    з відображенням маркерної інформації Tag=58}
  for I := 0 to Form1.ComponentCount-1 do
   begin
   if (Form1.Components[i].Tag=59)and bool then
      (Form1.Components[i] as TControl).Enabled:=True;
   if (Form1.Components[i].Tag=58) then
      (Form1.Components[i] as TControl).Enabled:=True;
   end;

   TrackBarMar.Min:=0;
   TrackBarMar.Max:=VaxGraph.HighNumber;
   TrackBarMar.Position:=round(VaxGraph.Count/2);
  end
                    else
  begin
   MarkerHide(Form1);
  end;
end;



procedure TForm1.CBoxBaseLineUseClick(Sender: TObject);
var i,j:word;
begin
for i:= 0 to Graph.SeriesCount-1 do
  begin
    with Graph.Series[i] do
        begin
         if (Name='Series3')or(Name='Series4') then Continue;
         for j := 0 to Graph.Series[i].Count-1 do
           if CBoxBaseLineUse.Checked then
             Graph.Series[i].YValue[j]:= YValue[j]-BaseLineCur.Parab(XValue[j])
                                      else
             Graph.Series[i].YValue[j]:= YValue[j]+BaseLineCur.Parab(XValue[j]);
         end;
  end;
end;

procedure TForm1.CBoxBaseLineVisibClick(Sender: TObject);
begin
 CBoxBaseLineUse.Enabled:=CBoxBaseLineVisib.Checked;
 ButBaseLineReset.Enabled:=CBoxBaseLineVisib.Checked;
 if CBoxBaseLineVisib.Checked then
     begin
       if not Assigned(BaseLine) then
         begin
         BaseLine:=TLineSeries.Create(Form1);
         BaseLine.SeriesColor:=clLime;
         BaseLine.ParentChart:=Graph;
         BaseLine.LinePen.Width:=4;
         end;
       if not Assigned(BaseLineCur)
            then BaseLineCur:=Curve3.Create(Series1.MinYValue,0,0);
       BaseLine.Clear;
       GraphFill(BaseLine,BaseLineCur.Parab,
                   Series1.MinXValue,Series1.MaxXValue,150);
        BaseLine.Active:=true;
        LBaseLineA.Caption:='A = '+ FloatToStrF(BaseLineCur.A, ffExponent, 3, 1);
        LBaseLineA.Visible:=True;
        LBaseLineB.Caption:='B = '+ FloatToStrF(BaseLineCur.B, ffExponent, 3, 1);
        LBaseLineB.Visible:=True;
        LBaseLineC.Caption:='C = '+ FloatToStrF(BaseLineCur.C, ffExponent, 3, 1);
        LBaseLineC.Visible:=True;
        if RButBaseLine.Checked then BaseLineParam;
        if not(CBoxGLShow.Checked) then DLParamActive;

     end
     else //if CBoxBaseLineVisib.Checked then
        begin
        BaseLine.Active:=false;
        LBaseLineA.Visible:=False;
        LBaseLineB.Visible:=False;
        LBaseLineC.Visible:=False;
        if not(CBoxGLShow.Checked) then DLParamPassive;
        if CBoxBaseLineUse.Checked then CBoxBaseLineUse.Checked:=False;
        end;
end;

procedure TForm1.CBoxDLBuildClick(Sender: TObject);
var str:string;
begin
VaxGraph.Clear;
ButSaveDL.Enabled:=CBoxDLBuild.Checked;
if CBoxDLBuild.Checked then
    begin
     if CBoxBaseLineVisib.Checked then CBoxBaseLineVisib.Checked:=False;
     if CBoxGLShow.Checked then
        begin
        CBoxGLShow.Checked:=False;
        GausLinesFree;
        GaussLinesToGrid;
        end;
      dB_dV_Fun(VaxFile,VaxGraph,SpinEditDL.Value,LabIsc.Caption,CBoxRCons.Checked);
      str:=CBDLFunction.Items[CBDLFunction.ItemIndex];
    end;
ShowGraph(Form1,str);
end;

procedure TForm1.CBoxGLShowClickAve(Sender: TObject);
begin
 if High(GausLines)<0 then Exit;
 GraphAverage(GausLines,CBoxGLShow.Checked);
 VaxFile.ReadFromGraph(GausLines[0]);
 GraphShow(Form1);
end;

procedure TForm1.CBoxGLShowClickGaus(Sender: TObject);
begin
if CBoxGLShow.Checked then
  begin
   if High(GausLinesCur)<0 then
     begin
       SetLength(GausLinesCur,2);
       SetLength(GausLines,2);
       GausLinesCur[1]:=Curve3.Create((Series1.MaxYValue-Series1.MinYValue)/2,
                  (Series1.MaxXValue+Series1.MinXValue)/2,
                  (Series1.MaxXValue-Series1.MinXValue)/4);
       GausLines[0]:=TLineSeries.Create(Form1);
       GausLines[1]:=TLineSeries.Create(Form1);
       GausLines[0].SeriesColor:=clMaroon;
       GausLines[1].SeriesColor:=clBlue;
                   GraphFill(GausLines[1],GausLinesCur[1].GS,
                   Series1.MinXValue,Series1.MaxXValue,150,0);
       GraphSum(GausLines);
     end;  //  High(GausLinesCur)<0
      GaussLinesToGraph(True);
      SEGauss.MaxValue:=High(GausLinesCur);
      SEGauss.Value:=1;
      GaussLinesToGrid;
      CompEnable(Form1,700,True);
      if RButGaussianLines.Checked then GaussianLinesParam;
      if not(CBoxBaseLineVisib.Checked) then
           begin
           DLParamActive;
           RButGaussianLines.Checked:=True;
           end;

  end //CBoxGSShow.Checked then
                        else
      begin
      GaussLinesToGraph(False);
      SEGauss.MaxValue:=0;
      SEGauss.Value:=0;
      GaussLinesToGrid;
      CompEnable(Form1,700,False);
      if not(CBoxBaseLineVisib.Checked) then DLParamPassive;
      end;
end;

procedure TForm1.CheckBoxM_VClick(Sender: TObject);
begin
if RadioButtonM_V.Checked then
                 RadioButtonM_VClick(RadioButtonM_V);
if RadioButtonFN.Checked then
                 RadioButtonM_VClick(RadioButtonFN);
if RadioButtonFNEm.Checked then
                 RadioButtonM_VClick(RadioButtonFNEm);
if RadioButtonAb.Checked then
                 RadioButtonM_VClick(RadioButtonAb);
if RadioButtonAbEm.Checked then
                 RadioButtonM_VClick(RadioButtonAbEm);
if RadioButtonFP.Checked then
                 RadioButtonM_VClick(RadioButtonFP);
if RadioButtonFPEm.Checked then
                 RadioButtonM_VClick(RadioButtonFPEm);
end;

procedure FileToDataSheet(Sheet:TStringGrid; NameFile:TLabel;
          Temperature:TLabel; a:TVector);
var i:integer;
begin
  Sheet.Visible:=True;
  Sheet.RowCount:=2;
  for i:=0 to a.HighNumber do
    begin
      Sheet.Cells[0,i+1]:=IntToStr(i+1);
      Sheet.Cells[1,i+1]:=FloatToStrF(a.X[i],ffGeneral,4,3);
      Sheet.Cells[2,i+1]:=FloatToStrF(a.Y[i],ffExponent,3,2);
      Sheet.RowCount:=Sheet.RowCount+1;
    end;
  Sheet.RowCount:=Sheet.RowCount-1;
  NameFile.Visible:=True;
  Temperature.Visible:=True;
  NameFile.Caption:='File name: '+ a.name;
  Temperature.Caption:='Temperature = '
      + FloatToStrF(a.T,ffGeneral,5,2)+' K';
end;

procedure DataToGraph(SeriesPoint, SeriesLine:TChartSeries;
          Graph: TChart; Caption:string; a:TVector);
begin
 Graph.LeftAxis.Automatic:=true;
 Graph.BottomAxis.Automatic:=true;

 a.WriteToGraph(SeriesPoint);
 a.WriteToGraph(SeriesLine);

 Graph.Title.Text.Clear;
 Graph.Title.Text.Append(Caption);
end;

procedure NoLog(X,Y:TCheckBox; Graph:TChart);
{процедура, призначена для зняття галочок
у виборі логарифмічного масштабу та переведення
осей в лінійний режим}
begin
 X.Checked:=False;
 Graph.BottomAxis.Logarithmic:=False;
 Y.Checked:=False;
 Graph.LeftAxis.Logarithmic:=False;
end;

procedure MarkerDraw (Graph,Vax:TVector; Point:Integer; F:TForm1);overload;
begin
  F.Series3.Clear;
  F.Series3.AddXY(VaxGraph.X[Point],F.Series2.MinYValue);
  F.Series3.AddXY(Graph.X[Point],F.Series2.MaxYValue);
  F.Series3.Active:=True;
  F.LabMarN.Caption:='N='+IntToStr(Point+1+Graph.N_begin);
  F.LabMarX.Caption:='X='+FloatToStrF(Vax.X[Point+Graph.N_begin],ffGeneral,4,3);
  F.LabMarY.Caption:='Y='+FloatToStrF(Vax.Y[Point+Graph.N_begin],ffExponent,3,2);
  F.LabelMarXGr.Caption:='X='+FloatToStrF(Graph.X[Point],ffExponent,2,1);
  F.LabelMarYGr.Caption:='Y='+FloatToStrF(Graph.Y[Point],ffExponent,3,2);
end;


procedure MarkerHide(F:TForm1);
{процедура прибирання маркеру,
з графіку, очищення міток та переведення їх та
повзунка з кнопкою в неактивний режим}
  var i:integer;
begin
  F.Series3.Active:=False;
  F.LabMarN.Caption:='N=';
  F.LabMarX.Caption:='X=';
  F.LabMarY.Caption:='Y=';
  F.LabelMarXGr.Caption:='X=';
  F.LabelMarYGr.Caption:='Y=';
  for I := 0 to F.ComponentCount-1 do
   if (F.Components[i].Tag=58)or(F.Components[i].Tag=59) then
      (F.Components[i] as TControl).Enabled:=False;
  {про Tag=58 і Tag=59 див. у методі CBMarkerClick}

end;

procedure LimitSetup(Lim:Limits; Min, Max:TRadioGroup;
                     LMin, LMax:TLabel);
{призначена для заповнення екранного блоку,
пов'язаного з вибором меж графіку, даними з
об'єкту Lim}
begin
  Max.ItemIndex:=Lim.MaxXY;
  Min.ItemIndex:=Lim.MinXY;

     if Lim.MinValue[Lim.MinXY]=ErResult
          then LMin.Caption:='No'
          else LMin.Caption:=FloatToStrF(Lim.MinValue[Lim.MinXY],ffExponent,3,2);
     if Lim.MaxValue[Lim.MaxXY]=ErResult
          then LMax.Caption:='No'
          else LMax.Caption:=FloatToStrF(Lim.MaxValue[Lim.MaxXY],ffExponent,3,2);
end;

procedure ClearGraph(Form1:TForm1);
{відчищує графік від різних доповнень,
(логарифмічності, маркера, зміни меж відображення,
апроксимаційних кривих тощо); виконується
перед кожною зміною кривої відображення}
begin
NoLog(Form1.XLogCheck,Form1.YLogCheck, Form1.Graph);
MarkerHide(Form1);
Form1.CBMarker.Checked:=False;
Form1.CBoxDLBuild.Checked:=False;
//Form1.CBoxIscCons.Checked:=False;
Form1.CBoxRCons.Checked:=False;
Form1.CBoxBaseLineVisib.Checked:=False;
Form1.CBoxBaseLineUse.Checked:=False;
if High(GausLinesCur)>0 then GausLinesSave;
if Form1.RBGausSelect.Checked then
       Form1.CBoxGLShow.Checked:=False;
if High(GausLines)<0 then
  begin
    GausLinesFree;
    GaussLinesToGrid;
  end;
if Form1.SpButLimit.Down then Form1.SpButLimit.Down:=False;
Form1.ApproxHide;
end;

procedure ClearGraphLog(Form1:TForm1);
{відчищує графік від різних доповнень,
(маркера, зміни меж відображення,
апроксимаційних кривих тощо); виконується
перед кожною зміною логарифмічності}
begin
MarkerHide(Form1);
Form1.CBMarker.Checked:=False;
if Form1.SpButLimit.Down then
                begin
                Form1.SpButLimit.Down:=False;
                VaxTempLim.CopyTo(VaxGraph);
                end;
Form1.ApproxHide;
end;


procedure DiapShow(D:TDiapazon;Xmin,Ymin,Xmax,Ymax:TLabel);
{відображення компонентів запису D у відповідних мітках}
begin
  if D.XMin=ErResult then Xmin.Caption:='Xmin: No'
    else Xmin.Caption:='Xmin: '+FloatToStrF(D.XMin,ffGeneral,4,3);
  if D.XMax=ErResult then Xmax.Caption:='Xmax: No'
    else Xmax.Caption:='Xmax: '+FloatToStrF(D.XMax,ffGeneral,4,3);
  if D.YMin=ErResult then Ymin.Caption:='Ymin: No'
    else Ymin.Caption:='Ymin: '+FloatToStrF(D.YMin,ffExponent,3,2);
  if D.YMax=ErResult then Ymax.Caption:='Ymax: No'
    else Ymax.Caption:='Ymax: '+FloatToStrF(D.YMax,ffExponent,3,2);
end;

Function IphUsed(bool:boolean):string;
{використовується для виведення напису на форму}
begin
if bool then Result:='Iph is used'
        else Result:='Iph=0'
end;


Function DDUsed(bool:boolean):string;
{використовується для виведення напису на форму}
begin
if bool then Result:='Double diod is used'
        else Result:='Double diod does not used'
end;


procedure DiapShowNew(DpType:TDiapazons);
{запис у потрібні мітки, залежно від значення DpType}
begin
with Form1 do
 case DpType of
   diChung: DiapShow(D[diChung],LabelChungXmin,LabelChungYmin,LabelChungXmax,LabelChungYmax);
   diMikh: DiapShow(D[diMikh],LabelMikhXmin,LabelMikhYmin,LabelMikhXmax,LabelMikhYmax);
   diExp: begin
            DiapShow(D[diExp],LabelExpXmin,LabelExpYmin,LabelExpXmax,LabelExpYmax);
            LabelExpIph.Caption:=IphUsed(GraphParameters.Iph_Exp);
          end;
   diEx: DiapShow(D[diEx],LabelExXmin,LabelExYmin,LabelExXmax,LabelExYmax);
   diNord:begin
            DiapShow(D[diNord],LabelNordXmin,LabelNordYmin,LabelNordXmax,LabelNordYmax);
            LabelNordGamma.Caption:='gamma= '+FloatToStrF(GraphParameters.Gamma,ffGeneral,2,1);
            LabBohGam1.Caption:='gamma1 = '+FloatToStrF(GraphParameters.Gamma1,ffGeneral,2,1);
            LabBohGam2.Caption:='gamma2 = '+FloatToStrF(GraphParameters.Gamma2,ffGeneral,2,1);
          end;
   diNss: DiapShow(D[diNss],LabelNssXmin,LabelNssYmin,LabelNssXmax,LabelNssYmax);
   diKam1: DiapShow(D[diKam1],LabelKam1Xmin,LabelKam1Ymin,LabelKam1Xmax,LabelKam1Ymax);
   diKam2: DiapShow(D[diKam2],LabelKam2Xmin,LabelKam2Ymin,LabelKam2Xmax,LabelKam2Ymax);
   diGr1: DiapShow(D[diGr1],LabelGr1Xmin,LabelGr1Ymin,LabelGr1Xmax,LabelGr1Ymax);
   diGr2: DiapShow(D[diGr2],LabelGr2Xmin,LabelGr2Ymin,LabelGr2Xmax,LabelGr2Ymax);
   diCib: DiapShow(D[diCib],LabelCibXmin,LabelCibYmin,LabelCibXmax,LabelCibYmax);
   diLee: DiapShow(D[diLee],LabelLeeXmin,LabelLeeYmin,LabelLeeXmax,LabelLeeYmax);
   diWer: DiapShow(D[diWer],LabelWerXmin,LabelWerYmin,LabelWerXmax,LabelWerYmax);
   diIvan: DiapShow(D[diIvan],LabelIvanXmin,LabelIvanYmin,LabelIvanXmax,LabelIvanYmax);
   diE2F: DiapShow(D[diE2F],LabelE2FXmin,LabelE2FYmin,LabelE2FXmax,LabelE2FYmax);
   DiE2R: DiapShow(D[diE2R],LabelE2RXmin,LabelE2RYmin,LabelE2RXmax,LabelE2RYmax);
   diLam:begin
           DiapShow(D[diLam],LabelLamXmin,LabelLamYmin,LabelLamXmax,LabelLamYmax);
           LabelLamIph.Caption:=IphUsed(GraphParameters.Iph_Lam);
         end;
   diDE: begin
           DiapShow(D[diDE],LabelDEXmin,LabelDEYmin,LabelDEXmax,LabelDEYmax);
           LabelDEIph.Caption:=IphUsed(GraphParameters.Iph_DE);
           LabDEDD.Caption:=DDUsed(DDiod_DE);
        end;
   diHfunc: DiapShow(D[diHfunc],LabelHXmin,LabelHYmin,LabelHXmax,LabelHYmax);
 end;
end;

procedure DiapToForm(D:TDiapazon; Xmin,Ymin,Xmax,Ymax:TLabeledEdit);
{відображення компонентів запису D у відповідних
текстових віконечках, виконується при використанні
вікон зміни діапазону}
begin
   if D.XMin=ErResult then Xmin.Text:=''
    else Xmin.Text:=FloatToStrF(D.XMin,ffGeneral,4,3);
  if D.XMax=ErResult then Xmax.Text:=''
    else Xmax.Text:=FloatToStrF(D.XMax,ffGeneral,4,3);
  if D.YMin=ErResult then Ymin.Text:=''
    else Ymin.Text:=FloatToStrF(D.YMin,ffExponent,3,2);
  if D.YMax=ErResult then Ymax.Text:=''
    else Ymax.Text:=FloatToStrF(D.YMax,ffExponent,3,2);
end;

procedure DiapToFormFr(D:TDiapazon; FrDp:TFrDp);
{відображення компонентів запису D у відповідних
текстових віконечках, виконується при використанні
вікон зміни діапазону}
begin
 DiapToForm(D,FrDp.LEXmin,FrDp.LEYmin,FrDp.LEXmax,FrDp.LEYmax);
end;

procedure FormToDiap(XMin,Ymin,Xmax,YMax:TLabeledEdit; var D:TDiapazon);
{переведення введених у текстові віконечка
величин у компоненти запису D}
var temp:double;
begin
StrToNumber(XMin.Text, ErResult, temp);
D.XMin:=temp;
StrToNumber(YMin.Text, ErResult, temp);
D.YMin:=temp;
StrToNumber(YMax.Text, ErResult, temp);
D.YMax:=temp;
StrToNumber(XMax.Text, ErResult, temp);
D.XMax:=temp;
end;

procedure FormFrToDiap(FrDp:TFrDp; var D:TDiapazon);
begin
  FormToDiap(FrDp.LEXMin,FrDp.LEYmin,FrDp.LEXmax,FrDp.LEYMax,D)
end;

Function RsDefineCB(A:TVectorShottky; CB, CBdod:TComboBox):double;overload;
var tg:TGraph;
begin
 Result:=ErResult;

 tg:=ConvertStringToTGraph(CB);
 if tg in [fnH,fnNorde] then
     begin
      GraphParCalculComBox(A,CBdod);
      if GraphParameters.n=ErResult then Exit;
     end;

 GraphParameters.Diapazon:=D[ConvertTGraphToTDiapazons(tg)];
 A.GraphParameterCalculation(tg);
 Result:=GraphParameters.Rs;
end;

Function RsDefineCB_Shot(A:TVectorShottky; CB:TComboBox):double;
begin
 GraphParCalculComBox(A,CB);
 Result:=GraphParameters.Rs;
end;

Function nDefineCB(A:TVectorShottky; CB, CBdod:TComboBox):double;
var tg:TGraph;
begin
 Result:=ErResult;
 tg:=ConvertStringToTGraph(CB);
 if tg in [fnDiodVerySimple,fnExpForwardRs,fnExpReverseRs] then
     begin
      GraphParCalculComBox(A,CBdod);
      if GraphParameters.Rs=ErResult then Exit;
     end;

 GraphParameters.Diapazon:=D[ConvertTGraphToTDiapazons(tg)];
 A.GraphParameterCalculation(tg);
 Result:=GraphParameters.n;
end;


Function nDefineCB_Shot(A:TVectorShottky; CB:TComboBox):double;
begin
 GraphParCalculComBox(A,CB);
 Result:=GraphParameters.n;
end;

Function FbDefineCB(A:TVectorShottky; CB:TComboBox; Rs:double):double;overload;
begin
Result:=ErResult;
if (GraphParameters.Rs=ErResult)
  and (CB.Items[CB.ItemIndex]=GraphLabel[fnDiodVerySimple]) then Exit;
 GraphParCalculComBox(A,CB);
 Result:=GraphParameters.Fb;
end;


Procedure ShowGraph(F:TForm1; st:string);
{намагається вивести на графік дані,
розташовані в VaxGraph;
якщо кількість точок в цьому масиві нульова -
виводиться вихідна ВАХ з файлу;
st - назва графіку}
begin
  if VaxGraph.IsEmpty then
   begin
     F.FullIV.Checked:=True;
     VaxFile.CopyTo(VaxGraph);
     DataToGraph(F.Series1,F.Series2,F.Graph,'I-V-characteristic',VaxGraph);
     VaxGraph.CopyTo(VaxTemp);
   end
                 else
   begin
    DataToGraph(F.Series1,F.Series2,F.Graph, st ,VaxGraph);
    VaxGraph.CopyTo(VaxTemp);
   end
end;

Procedure DiapToLim(D:TDiapazon; var L:Limits);
{копіювання даних, що описують границі графіку
зі змінної D в змінну L}
begin
  case D.Br of
  'F':begin
      L.MinValue[0]:=D.XMin;
      L.MinValue[1]:=D.YMin;
      L.MaxValue[0]:=D.XMax;
      L.MaxValue[1]:=D.YMax;
      end;
  'R':begin
      if D.XMax=ErResult then L.MinValue[0]:=D.XMax else L.MinValue[0]:=-D.XMax;
      if D.YMax=ErResult then L.MinValue[1]:=D.YMax else L.MinValue[1]:=-D.YMax;
      if D.XMin=ErResult then L.MaxValue[0]:=D.XMin else L.MaxValue[0]:=-D.XMin;
      if D.YMin=ErResult then L.MaxValue[1]:=D.YMin else L.MaxValue[1]:=-D.YMin;
      end;
  end;
  if (L.MinXY=0)and(D.XMin=ErResult)and(D.YMin<>ErResult) then L.MinXY:=1;
  if (L.MinXY=1)and(D.YMin=ErResult)and(D.XMin<>ErResult) then L.MinXY:=0;
  if (L.MaxXY=0)and(D.XMax=ErResult)and(D.YMax<>ErResult) then L.MaxXY:=1;
  if (L.MaxXY=1)and(D.YMax=ErResult)and(D.XMax<>ErResult) then L.MaxXY:=0;
end;


Procedure DiapToLimToTForm1(D:TDiapazon; F:TForm1);
{копіювання даних, що описують границі графіку
зі змінної D в блок головної форми, пов'язаний
з обмеженим відображенням графіку (і в змінну GrLim,
і на саму форму, у відповідні написи}
begin
with F do
 begin
  DiapToLim(D, GrLim);
  LimitSetup(GrLim, RdGrMin, RdGrMax, LabelMin, LabelMax);
 end;
end;


Procedure ChooseDirect(F:TForm1);
{виведення на форму написів, пов'язаних
з робочою директорією}
var i:integer;
begin
F.LabelCurDir.Caption:=CurDirectory;

{про номера Tag див. спочатку, біля визначення типів}
for I := 0 to F.ComponentCount-1 do
   begin
     if (F.Components[i] is TLabel)and
        (AnsiPos('Lab',F.Components[i].Name)=1)and
        (F.Components[i].Tag>=100)and
        (F.Components[i].Tag<150)
           then
     (F.Components[i] as TLabel).Caption:=CurDirectory+'\'+
     GetEnumName(TypeInfo(TDirName),F.Components[i].Tag-100)+'\';
   end;

F.LabelData.Caption:=CurDirectory+'\'+'dates.dat';
F.LVolt.Caption:='Folder: '+CurDirectory+'\Zriz\';
end;


Procedure ColParam(Dates:TStringGrid);
{змінює параметри Grid (кількість колонок) в залежності
від того що в ColNames, а також заносить в заголовки
колонок дані з ColNameConst}
var i:integer;
    CL:TColName;
begin
Dates.ColCount:=ord(kT_1)+1;
Dates.RowCount:=2;
for CL:=fname to kT_1 do
    begin
    i:=ord(CL);
    Dates.Cells [i,0]:=GetEnumName(TypeInfo(TColName),i);
    Dates.Cells [i,1]:='';
    end;

for CL:=Succ(kT_1) to High(CL) do
  if (CL in ColNames) then
        begin
        Dates.ColCount:=Dates.ColCount+1;
        Dates.Cells[Dates.ColCount-1, 0]:=GetEnumName(TypeInfo(TColName),ord(CL));
        Dates.Cells[Dates.ColCount-1, 1]:='';
        end;
end;


Procedure SortGrid(SG:TStringGrid;NCol:integer);
{сортування SG по значенням в колонці номер NCol;
необхідно враховувати, що нумерація колонок починається
з нуля і що сортування відбуваеться по змінним
типу string, навіть якщо вони представляють числа
відбуваеться сортування усіх рядків, окрім нульового;
якщо NCol перевищує максимальний номер стовпчика,
то SG повертається без змін}
var i,j:integer;
begin
if SG.ColCount<=NCol then Exit;
SG.RowCount:=SG.RowCount+1;
//сортування методом бульбашки
for I := 1 to SG.RowCount-2 do
  for j := 1 to SG.RowCount-1-i do
      if SG.Cells[Ncol,j]>SG.Cells[Ncol,j+1] then
          begin
          SG.Rows[SG.RowCount-1].Assign(SG.Rows[j]);
          SG.Rows[j].Assign(SG.Rows[j+1]);
          SG.Rows[j+1].Assign(SG.Rows[SG.RowCount-1]);
          end;
SG.RowCount:=SG.RowCount-1;
end;

Procedure CBEnable(Main,Second:TComboBox);
{в залежності від вибраних значень в списку
Main змінюється доступність списку Second}
begin
  if ((Main.ItemIndex>3)and(Main.ItemIndex<6))or(Main.ItemIndex>12)
                      then Second.Enabled:=True
                      else Second.Enabled:=False;
  if not(Main.Enabled) then Second.Enabled:=False;
end;

Procedure GraphShow(F:TForm1);
{початкове відображення графіку по даним
в VaxFile, крім того доступність всяких перемикачів
встановлюється}
var i:integer;
begin
// if VaxFile^.n>0 then
 if VaxFile.Count>0 then
  begin
   FileToDataSheet(F.DataSheet,F.NameFile,F.Temper,VaxFile);
   ClearGraph(Form1);
   VaxFile.CopyTo(VaxGraph);
   DataToGraph(F.Series1,F.Series2,F.Graph,'I-V-characteristic',VaxGraph);
   VaxGraph.CopyTo(VaxTemp);
   F.FullIV.Checked:=True;

   for I := 0 to F.ComponentCount-1 do
   begin
     if (F.Components[i].Tag=55) then
      (F.Components[i] as TControl).Enabled:=True;
     if (F.Components[i].Tag=56) then
       if VaxFile.T>0 then (F.Components[i] as TControl).Enabled:=True
                       else (F.Components[i] as TControl).Enabled:=False;
   end; // for I := 0 to F.ComponentCount-1 do
 {візуальні компоненти, для яких Tag=55 мають ставати
  доступними у випадку, коли завантажується нормальний
  графік; для компонент з Tag=56 додатковою необхідною
  умовою доступності є відома величина температури}
   if (VaxFile.T<=0) and (not (F.ComboBoxRS.ItemIndex in [0,1,2,6,7,10,11]))
         then  F.ComboBoxRS.ItemIndex:=6;
   if (VaxFile.T<=0) and (not (F.ComboBoxNssRS.ItemIndex in [0,1,2,6,7,10,11]))
         then  F.ComboBoxNssRS.ItemIndex:=6;
  end //if VaxFile^.n>0 then
             else  //if VaxFile^.n>0
  begin
   F.DataSheet.Visible:=False;
   F.NameFile.Visible:=False;
   F.Temper.Visible:=False;
   F.FullIV.Checked:=False;

   for I := 0 to F.ComponentCount-1 do
     if (F.Components[i].Tag=55)or(F.Components[i].Tag=56) then
      (F.Components[i] as TControl).Enabled:=False;
  end; //if VaxFile^.n>0 else

 CBEnable(F.ComboBoxRS,F.ComboBoxRS_n);
 CBEnable(F.ComboBoxN,F.ComboBoxN_Rs);
 CBEnable(F.ComboBoxNssRs,F.ComboBoxNssRs_n);
 F.ButDel.Enabled:=False;
end;

Procedure BaseLineParam;
{виконується при переході на редагування
параметрів базової лінії на вкладці глибоких рівнів}
begin
  with Form1 do
  begin
    TrackPanA.Min:=0;
    TrackPanB.Min:=0;
    TrackPanC.Min:=0;
    ToTrack (BaseLineCur.A,TrackPanA,SpinEditPanA,CBoxPanA);
    ToTrack (BaseLineCur.B,TrackPanB,SpinEditPanB,CBoxPanB);
    ToTrack (BaseLineCur.C,TrackPanC,SpinEditPanC,CBoxPanC);
    LPanA.Caption:='A';
    LPanB.Caption:='B';
    LPanC.Caption:='C';
    LPanAA.Caption:=FloatToStrF(BaseLineCur.A, ffExponent, 3, 1);
    LPanBB.Caption:=FloatToStrF(BaseLineCur.B, ffExponent, 3, 1);
    LPanCC.Caption:=FloatToStrF(BaseLineCur.C, ffExponent, 3, 1);
  end;  // with Form1 do
end;

Procedure GaussianLinesParam;
{виконується при переході на редагування
параметрів гаусіанів лінії на вкладці глибоких рівнів}
begin
  with Form1 do
  begin
    ToTrack (GausLinesCur[SEGauss.Value].A,TrackPanA,SpinEditPanA,CBoxPanA);
    ToTrack (GausLinesCur[SEGauss.Value].B,TrackPanB,SpinEditPanB,CBoxPanB);
    ToTrack (GausLinesCur[SEGauss.Value].C,TrackPanC,SpinEditPanC,CBoxPanC);
    TrackPanA.Min:=1;
    TrackPanB.Min:=1;
    TrackPanC.Min:=1;
    LPanA.Caption:='Max Value';
    LPanB.Caption:='U0';
    LPanC.Caption:='Deviation';
    LPanAA.Caption:=FloatToStrF(GausLinesCur[SEGauss.Value].A,ffExponent,3,2);
    LPanBB.Caption:=FloatToStrF(GausLinesCur[SEGauss.Value].B,ffFixed,3,2);
    LPanCC.Caption:=FloatToStrF(GausLinesCur[SEGauss.Value].C,ffExponent,3,2);
  end;  // with Form1 do
end;

Procedure DLParamActive;
{дозволяє доступ до регуляторів, які
використовуються при зміні параметрів на вкладці,
пов'язаній з глибокими рівнями}
var i:integer;
begin
  with Form1 do
  begin
    for I := 0 to ComponentCount-1 do
     if (Components[i] is TControl)and
        ((TControl(Components[i]).Parent.Name='PanelA')or
        (TControl(Components[i]).Parent.Name='PanelB')or
        (TControl(Components[i]).Parent.Name='PanelC'))
          then
        TControl(Components[i]).Enabled:=True;
  end; //with Form1 do
end;

Procedure DLParamPassive;
{забороняє доступ до регуляторів, які
використовуються при зміні параметрів на вкладці,
пов'язаній з глибокими рівнями}
var i:integer;
begin
  with Form1 do
  begin
    for I := 0 to ComponentCount-1 do
     if (Components[i] is TControl)and
        ((TControl(Components[i]).Parent.Name='PanelA')or
        (TControl(Components[i]).Parent.Name='PanelB')or
        (TControl(Components[i]).Parent.Name='PanelC'))
          then
        TControl(Components[i]).Enabled:=False;
  end; //with Form1 do
end;

Procedure GausLinesFree;
{знищення об'єктів, пов'язаних з гаусіанами
в методі визначення глибоких рівнів}
var i:word;
begin
  if not(High(GausLines)<0) then
     begin
      for I := 0 to High(GausLines) do GausLines[i].Free;
      SetLength(GausLines,0);
     end;
  if not(High(GausLinesCur)<0) then
     begin
      for I := 1 to High(GausLinesCur) do GausLinesCur[i].Free;
      SetLength(GausLinesCur,0);
     end;
//   Form1.SEGauss.Value:=0;
end;

Procedure GausLinesSave;
{запис пареметрів гаусіан у ini-файл}
var
    i:integer;
    st:string;
begin
 ConfigFile.WriteInteger('Gauss','NLine',High(GausLinesCur));
   for I := 1 to High(GausLinesCur) do
     begin
       st:=inttostr(i);
       ConfigFile.WriteFloat('Gauss','A'+st,GausLinesCur[i].A);
       ConfigFile.WriteFloat('Gauss','B'+st,GausLinesCur[i].B);
       ConfigFile.WriteFloat('Gauss','C'+st,GausLinesCur[i].C);
     end;
end;

Procedure GausLinesLoad;
{зчитування пареметрів гаусіан з ini-файла}
var
    i:integer;
    st:string;
begin
 i:=ConfigFile.ReadInteger('Gauss','NLine',-1);
 if i<1 then
      begin
       ConfigFile.Free;
       Exit;
      end;
 GaussLinesToGraph(False);
 GausLinesFree;
 SetLength(GausLines,i+1);
 SetLength(GausLinesCur,i+1);
 for I := 0 to High(GausLines) do GausLines[i]:=TLineSeries.Create(Form1);
 for I := 1 to High(GausLinesCur) do
   begin
   st:=inttostr(i);
   GausLinesCur[i]:=Curve3.Create;
   GausLinesCur[i].A:=ConfigFile.ReadFloat('Gauss','A'+st,1);
   GausLinesCur[i].B:=ConfigFile.ReadFloat('Gauss','B'+st,1);
   GausLinesCur[i].C:=ConfigFile.ReadFloat('Gauss','C'+st,1);
   end;

 for i:=1 to High(GausLines) do
    GraphFill(GausLines[i],GausLinesCur[i].GS,
                   Form1.Series1.MinXValue,Form1.Series1.MaxXValue,150,0);
 GraphSum(GausLines);
 for i:=1 to High(GausLines) do
   GausLines[i].SeriesColor:=clNavy;
 GausLines[0].Color:=clMaroon;
 GausLines[1].SeriesColor:=clBlue;
 Form1.SEGauss.MaxValue:=High(GausLines);
 Form1.SEGauss.Value:=1;
 GaussLinesToGraph(True);
 GaussLinesToGrid;
end;


Procedure GaussLinesToGrid;
{виведення параметрів гаусіан у таблицю}
var i:integer;
    sq:double;
begin
 for I := 1 to Form1.SGridGaussian.RowCount-1 do Form1.SGridGaussian.Rows[i].Clear;
 Form1.SGridGaussian.RowCount:=4;
 if High(GausLinesCur)<0 then Exit;
 sq:=0;
 for I := 1 to High(GausLinesCur) do
    sq:=sq+GausLinesCur[i].GS_Sq;
 for I := 1 to High(GausLinesCur) do
   begin
    Form1.SGridGaussian.RowCount:=Form1.SGridGaussian.RowCount+1;
    Form1.SGridGaussian.Cells[0,Form1.SGridGaussian.RowCount-4]:=
                       IntToStr(i);
    Form1.SGridGaussian.Cells[1,Form1.SGridGaussian.RowCount-4]:=
                       FloatToStrF(GausLinesCur[i].B,ffFixed,3,2);
    if (Form1.CBDLFunction.Items[Form1.CBDLFunction.ItemIndex]='dRnp/dV')
      or(Form1.CBDLFunction.Items[Form1.CBDLFunction.ItemIndex]='L(V)')
      then
    Form1.SGridGaussian.Cells[2,Form1.SGridGaussian.RowCount-4]:=
      FloatToStrF((DiodPN.LayerP.Material.EgT(VaxFile.T)-GausLinesCur[i].B)/2
            +3*Kb*VaxFile.T/4
            *ln(DiodPN.LayerP.Material.Me/DiodPN.LayerP.Material.Mh)
            -Kb*VaxFile.T*ln(2),   ffFixed,3,2)
      else
    Form1.SGridGaussian.Cells[2,Form1.SGridGaussian.RowCount-4]:=
      FloatToStrF((DiodPN.LayerP.Material.EgT(VaxFile.T)-GausLinesCur[i].B)/2
            +3*Kb*VaxFile.T/4
            *ln(DiodPN.LayerP.Material.Me/DiodPN.LayerP.Material.Mh),
                   ffFixed,3,2);

    Form1.SGridGaussian.Cells[3,Form1.SGridGaussian.RowCount-4]:=
                       FloatToStrF(GausLinesCur[i].C,ffExponent,3,2);
    Form1.SGridGaussian.Cells[4,Form1.SGridGaussian.RowCount-4]:=
                       FloatToStrF(GausLinesCur[i].A,ffExponent,3,2);
   Form1.SGridGaussian.Cells[5,Form1.SGridGaussian.RowCount-4]:=
                       FloatToStrF((GausLinesCur[i].GS_Sq/sq),ffFixed,3,2);
   end;
end;

Procedure GaussLinesToGraph(Bool:Boolean);
{показ гаусіан на графіку при Bool=true
і схов (не знищення) ліній у протилежному випадку}
var i:integer;
begin
 for I := 0 to High(GausLines) do
   begin
    if (i=0)and(Form1.RBAveSelect.Checked) then Continue;
    if Bool then Form1.Graph.AddSeries(GausLines[i])
            else Form1.Graph.RemoveSeries(GausLines[i]);
    GausLines[i].Active:=Bool;
   end;
end;


Function StrToFloatDef(FloatString : string; Default : double ) : double;
{конвертує рядок в дійсне, повертаючи Default, якщо перетворення не вдалося,
якщо при перетворенні результат менше 1, то також повертається Default -
функція використовується при введенні переметра гамма
у функції Норда (Бохліна)}
begin
if FloatString='' then Result:=Default
           else
            begin
             try
              Result:=StrToFloat(FloatString);
             except
              on Exception : EConvertError do
                     begin
                     ShowMessage(Exception.Message);
                     Result:=Default;
                     end;
             end;//try
            end;//else
         if Result<1 then
                    begin
                      Result:=Default;
                      MessageDlg('Gamma must be more then 1', mtError,[mbOk],0);
                    end;
end;




Procedure FormDiapazon(DpType:TDiapazons);
{створюється форма для зміни діапазону апроксимації,
вигляд форми та метод, де цей діапазон використовуватиметься,
визначається DpType}
const MarginLeft=10;
      MarginTop=10;
      MarginRight=20;
      MarginBottom=20;
      MarginBeetween=30;
var Form:TForm;
    Dp:TFrDp;
    Buttons:TFrBut;
    ButShift,ImgHeight,ImgWidth:integer;
    Img: TImage;
    GLab:TLabel;
    GEdit:TEdit;
    GEdit2:TLabeledEdit;
    Iph_CB,DD_CB:TCheckBox;
    Param_But:TButton;
    DpName:string;
    I,VerticalEnd: Integer;

    Procedure EditToFloat(EditName:string; var Number:double);
    {считування з TEdit з назвою EditName значення в Number}
    var i:integer;
    begin
     for I := 0 to Form.ComponentCount-1 do
       if (Form.Components[i] is TEdit)and
          (Form.Components[i].Name=EditName)
       then Number:=StrToFloatDef((Form.Components[i] as TEdit).Text, 2)
    end;

    Procedure LabeledEditToFloat(EditName:string; var Number:double);
    {считування з TLabeledEdit з назвою EditName значення в Number}
    var i:integer;
    begin
     for I := 0 to Form.ComponentCount-1 do
       if (Form.Components[i] is TLabeledEdit)and
          (Form.Components[i].Name=EditName)
       then Number:=StrToFloatDef((Form.Components[i] as TLabeledEdit).Text, 2.5)
    end;

    Procedure CheckBoxToBool(CBName:string; var bool:boolean);
    {считування з TCheckBox з назвою CBName значення в bool}
    var i:integer;
    begin
     for I := 0 to Form.ComponentCount-1 do
       if (Form.Components[i] is TCheckBox)and
          (Form.Components[i].Name=CBName)
       then bool:=(Form.Components[i] as TCheckBox).Checked;
    end;

begin

 Form:=TForm.Create(Application);
 Form.Position:=poMainFormCenter;
 Form.AutoScroll:=True;
 Form.BorderIcons:=[biSystemMenu];
 Form.ParentFont:=True;
 Form.Font.Style:=[fsBold];
 Form.Font.Height:=-16;
 Form.KeyPreview:=True;
 Form.OnKeyPress:=Form1.FormDpKeyPress;

 Dp:=TFrDp.Create(Form);
 Dp.Name:='Dp';
 Dp.Parent:=Form;
 Dp.Left:=0;
 DiapToFormFr(D[DpType], Dp);

 if (BohlinMethod)or(DpType=diIvan) then
   begin
   ImgWidth:=700;
   Dp.LEYmin.Top:=Dp.LEXmin.Top;
   Dp.LEYmax.Top:=Dp.LEXmin.Top;
   Dp.LEYmin.Left:=Dp.LEXmin.Left+Dp.LEXmin.Width+MarginBeetween;
   Dp.LEXmax.Left:=Dp.LEYmin.Left+Dp.LEYmin.Width+MarginBeetween;
   Dp.LEYmax.Left:=Dp.LEXmax.Left+Dp.LEXmax.Width+MarginBeetween;
   Dp.Width:=Dp.LEYmax.Left+Dp.LEYmax.Width+5;
   Dp.Height:=Dp.LEYmax.Top+Dp.LEYmax.Height+5;
   end
                                     else
   ImgWidth:=500;

 ImgHeight:=ImgWidth;
 ButShift:=320;
 VerticalEnd:=0;


 Img:=TImage.Create(Form);
 Img.Parent:=Form;
 Img.Top:=MarginTop;
 Img.Left:=MarginLeft;
 Img.Stretch:=True;
 Img.Height:=ImgHeight;
 Img.Width:=ImgWidth;

//------ Визначення імені форми ------------------
  case DpType of
    diChung: DpName:='Cheung';
    diMikh: DpName:='Mikhelashvili';
    diExp: DpName:='Least-squares curve fitting';
    diEx: DpName:='I = I0 exp(eV/nkT)';
    diNord: DpName:='Norde';
    diNss: DpName:='The density of interface states';
    diKam1: DpName:='Kaminskii function I';
    diKam2: DpName:='Kaminskii function II';
    diGr1: DpName:='Gromov function I';
    diGr2: DpName:='Gromov function II';
    diCib: DpName:='Cibils';
    diLee: DpName:='Lee';
    diWer: DpName:='Werner';
    diIvan: DpName:='Ivanov';
    diE2F: DpName:='I/[1-exp(-qV/kT)] forward';
    diE2R: DpName:='I/[1-exp(-qV/kT)] reverse';
    diLam: DpName:='Lambert function curve fitting';
    diDE: DpName:='Evolution Algorithm';
    diHfunc: DpName:='H function';
  end;
  if BohlinMethod then  DpName:='Bohlin';

  if (not(DpType in [diExp,diEx,diNss,diLam,diDE]))or(BohlinMethod)
                      then Form.Caption:=DpName+' method parameters'
                      else Form.Caption:=DpName+' parameters';
//------ END Визначення імені форми ------------------

//------Розміщення потрібного малюнку та визначення максимально
//------необхідного місця у випадку, коли малюнки міняються------------------
   case DpType of
    diExp:begin
           DpName:='Exp';
           PictLoadScale(Img,'ExpFig');
           if GraphParameters.Iph_exp then  DpName:='ExpIph';
          end;
    diEx:  DpName:='Ex';
    diNss: DpName:='Nss';
    diKam1: DpName:='Kam1';
    diKam2: DpName:='Kam2';
    diGr1: DpName:='Gromov1';
    diGr2: DpName:='Gromov2';
    diIvan: DpName:='Ivanov2';
    diE2F: DpName:='ExpFor';
    DiE2R: DpName:='ExpRev';
    diLam: begin
             DpName:='DiodLam';
             PictLoadScale(Img,'PhotoDiodLamFig');
             if GraphParameters.Iph_Lam then  DpName:='PhotoDiodLam';
           end;
    diDE:  begin
            DpName:='DoubleDiod';
            PictLoadScale(Img,'ExpFig');
            if GraphParameters.Iph_DE then
                   if DDiod_DE then DpName:='DoubleDiodLight'
                               else DpName:='ExpIph'
                      else
                   if DDiod_DE then DpName:='DoubleDiod'
                               else DpName:='Exp';
           end;
    diHfunc: DpName:='Hfunc';
  end;
 if (DpType in [diExp,diLam,diDE]) then
   begin
     VerticalEnd:=Img.Top+Img.Height;
     Img.Height:=ImgHeight;
     Img.Width:=ImgWidth;
   end;

 PictLoadScale(Img,DpName+'Fig');
 Img.Visible:=True;
 if not(DpType in [diExp,diLam,diDE]) then  VerticalEnd:=Img.Top+Img.Height;
//------END Розміщення потрібного малюнку та визначення максимально



//------Додаткові мітки, поля, кнопки тощо--------------------
case DpType of
  diEx: Dp.LEXmin.EditLabel.Caption:='X min (X>0.06 V)';
  diNord: begin
           GLab:=TLabel.Create(Form);
           GLab.Parent:=Form;
           GLab.Caption:='Input gamma value:';
           GLab.Font.Color:=clGreen;
           GLab.Font.Height:=-17;
           GLab.Left:=MarginLeft;
           GLab.Top:=VerticalEnd+15;

           GEdit:=TEdit.Create(Form);
           GEdit.Parent:=Form;
           GEdit.Text:=FloatToStrF(GraphParameters.Gamma,ffGeneral,2,1);
           GEdit.Top:=GLab.Top;
           GEdit.Left:=GLab.Left+GLab.Width+10;
           GEdit.Name:='Gamma';

           VerticalEnd:=GLab.Top+Glab.Height;

           if  BohlinMethod then
             begin
              GEdit.Name:='Gamma1';
              GLab.Caption:='Input values:   gamma1=';

              GEdit.Text:=FloatToStrF(GraphParameters.Gamma1,ffGeneral,2,1);
              GEdit.Left:=GLab.Left+GLab.Width+4;

              GEdit2:=TLabeledEdit.Create(Form);
              GEdit2.Parent:=Form;
              GEdit2.Text:=FloatToStrF(GraphParameters.Gamma2,ffGeneral,2,1);
              GEdit2.LabelPosition:=lpLeft;
              GEdit2.EditLabel.Caption:='gamma2=';
              GEdit2.EditLabel.Font.Color:=clGreen;
              GEdit2.EditLabel.Font.Height:=-17;
              GEdit2.Top:=GLab.Top;
              GEdit2.Left:=GEdit.Left+GEdit.Width+20+GEdit2.EditLabel.Width+GEdit2.LabelSpacing;
              GEdit2.Name:='Gamma2';
             end;

          end; //  diNord:
  diExp,diLam,diDE:
       begin
        Iph_CB:=TCheckBox.Create(Form);;
        Iph_CB.Parent:=Form;
        Iph_CB.Caption:='photocurrent is used';
        Iph_CB.Width:=Form.Canvas.TextWidth(Iph_CB.Caption)+30;
        Iph_CB.Left:=MarginLeft+10;
        Iph_CB.Top:=VerticalEnd+15;
        VerticalEnd:=Iph_CB.Top+Iph_CB.Height;
        Param_But:=TButton.Create(Form);
        Param_But.Parent:=Form;
        Param_But.Caption:='Option';
        Param_But.Left:=Iph_CB.Left+Iph_CB.Width+70;
        Param_But.OnClick:=Form1.OnClickButton;
        Param_But.Top:=Iph_CB.Top-3;

        if DpType=diExp then
          begin
           Iph_CB.Checked:=GraphParameters.Iph_Exp;
           Iph_CB.Name:='ExpFormCB';
           Param_But.Name:='ExpFormBut';
          end;

        if DpType=diLam then
          begin
           Iph_CB.Checked:=GraphParameters.Iph_Lam;
           Iph_CB.Name:='LamFormCB';
           Param_But.Name:='LamFormBut';
          end;

        if DpType=diDE then
          begin
            Iph_CB.Checked:=GraphParameters.Iph_DE;
            Iph_CB.Name:='DEFormCB';
            Param_But.Name:='DEFormBut';
            DD_CB:=TCheckBox.Create(Form);;
            DD_CB.Parent:=Form;
            DD_CB.Caption:='double diod is used';
            DD_CB.Width:=Form.Canvas.TextWidth(DD_CB.Caption)+30;
            DD_CB.Left:=Iph_CB.Left;
            DD_CB.Checked:=DDiod_DE;
            DD_CB.Name:='DEFormDDCB';
            DD_CB.Top:=VerticalEnd+10;
            VerticalEnd:=DD_CB.Top+DD_CB.Height;
            DD_Cb.OnClick:=Form1.OnClickCheckBox;
          end;

         Iph_Cb.OnClick:=Form1.OnClickCheckBox;

       end;//diExp,diLam,diDE:
end;
//------END Додаткові мітки, поля, кнопки тощо--------------------

 Form.Width:=Img.Width+MarginLeft+MarginRight;

 Dp.Top:=VerticalEnd+25;

 Buttons:=TFrBut.Create(Form);
 Buttons.Parent:=Form;
 Buttons.ParentFont:=True;
 Buttons.ButOk.Height:=30;
 Buttons.ButCancel.Height:=30;
 Buttons.ButOk.Width:=79;
 Buttons.ButCancel.Width:=79;
 Buttons.ButCancel.Left:=ButShift;
 Buttons.Width:=Buttons.ButCancel.Left+Buttons.ButCancel.Width;
 Buttons.Height:=Buttons.ButOk.Height;
 Buttons.Left:=Form.Width-MarginLeft-Buttons.Width;
 Buttons.Top:=Dp.Top+Dp.Height+10;

 Form.Height:=Buttons.Top+Buttons.Height+MarginBottom+30;


  if Form.ShowModal=mrOk then
   begin
     FormFrToDiap(Dp,D[DpType]);

     if (DpType=diNord)and(not(BohlinMethod)) then   EditToFloat('Gamma',GraphParameters.Gamma);
     if BohlinMethod then
       begin
        EditToFloat('Gamma1',GraphParameters.Gamma1);
        LabeledEditToFloat('Gamma2',GraphParameters.Gamma2);
        if abs(GraphParameters.Gamma2-GraphParameters.Gamma1)<1e-3 then
                    begin
                    GraphParameters.Gamma1:=2;
                    GraphParameters.Gamma2:=2.5;
                    MessageDlg('Gamma1 cannot be equal Gamma2', mtError,[mbOk],0);
                    end;
       end;
     if DpType=diExp then CheckBoxToBool('ExpFormCB',GraphParameters.Iph_Exp);
     if DpType=diLam then CheckBoxToBool('LamFormCB',GraphParameters.Iph_Lam);
     if DpType=diDE then
      begin
        CheckBoxToBool('DEFormCB',GraphParameters.Iph_DE);
        CheckBoxToBool('DEFormDDCB',DDiod_DE);
      end;

     DiapShowNew(DpType);

   end;//  if Form.ShowModal=mrOk then


 for I := Form.ComponentCount-1 downto 0 do
     Form.Components[i].Free;
 Form.Hide;
 Form.Release;
end;


Function DiapFunName(Sender: TObject; var bohlin: Boolean):TDiapazons;
{залежно від елемента, який викликав цю функцію (Sender),
вибирається метод, для якого змінюватиметься діапазон
апроксимації;
використовується разом з FormDiapazon}
begin
bohlin:=False;
Result:=diNss;

if ((Sender as TButton).Name='ButtonParamCib') then Result:=diCib;
if ((Sender as TButton).Name='ButtonParamChung') then Result:=diChung;
if ((Sender as TButton).Name='ButtonParamE2F') then Result:=diE2F;
if ((Sender as TButton).Name='ButtonParamE2R') then Result:=diE2R;
if ((Sender as TButton).Name='ButtonParamIvan') then Result:=diIvan;
if ((Sender as TButton).Name='ButtonParamWer') then Result:=diWer;
if ((Sender as TButton).Name='ButtonParamH') then Result:=diHfunc;
if ((Sender as TButton).Name='ButtonParamMikh') then Result:=diMikh;
if ((Sender as TButton).Name='ButtonParamLee') then Result:=diLee;
if ((Sender as TButton).Name='ButtonParamGr1') then Result:=diGr1;
if ((Sender as TButton).Name='ButtonParamGr2') then Result:=diGr2;
if ((Sender as TButton).Name='ButtonParamKam1') then Result:=diKam1;
if ((Sender as TButton).Name='ButtonParamKam2') then Result:=diKam2;
if ((Sender as TButton).Name='ButtonParamNss') then Result:=diNss;
if ((Sender as TButton).Name='ButtonNss') then Result:=diNss;
if ((Sender as TButton).Name='ButtonParamEx') then Result:=diEx;
if ((Sender as TButton).Name='ButtonParamNord') then Result:=diNord;
if ((Sender as TButton).Name='ButtonParamBh') then
                                          begin
                                            Result:=diNord;
                                            bohlin:=true;
                                          end;
if ((Sender as TButton).Name='ButtonParamExp') then Result:=diExp;
if ((Sender as TButton).Name='ButtonParamLam') then Result:=diLam;
if ((Sender as TButton).Name='ButtonParamDE') then Result:=diDE;

if ((Sender as TButton).Name='ButtonKalkPar') then
  begin
   Result:=ConvertTGraphToTDiapazons(ConvertStringToTGraph(Form1.CBKalk));
   if Result=diNord then bohlin:=true;
  end;


end;

procedure TForm1.FormDpKeyPress(Sender: TObject; var Key: Char);
begin
if Key=#13 then
    begin
    SelectNext((Sender as TForm).ActiveControl,True,True);
    Key:=#0;
    end;
{XP Win}
if not(ANSIChar(Key) in [#8,'0'..'9','+','-','E','e',FormatSettings.DecimalSeparator])
//if not(Key in [#8,'0'..'9','+','-','E','e',DecimalSeparator])
 then Key:=#0;
end;

procedure TForm1.OnClickCheckBox(Sender: TObject);
    {чіпляється до CheckBox деяких дочірніх форм,
    дозволяє міняти картинку на формі}
var PictureName:string;
    i:integer;
    boolIph,boolDD:boolean;
begin
boolIph:=true;
boolDD:=true;

  if (Sender is TCheckBox)and((Sender as TCheckBox).Name='ExpFormCB') then
    begin
      if (Sender as TCheckBox).Checked then PictureName:='ExpIphFig'
                                       else PictureName:='ExpFig';
    end;

 if (Sender is TCheckBox)and((Sender as TCheckBox).Name='LamFormCB') then
    begin
      if (Sender as TCheckBox).Checked then PictureName:='PhotoDiodLamFig'
                                       else PictureName:='DiodLamFig';
    end;

 if (Sender is TCheckBox)and
   (((Sender as TCheckBox).Name='DEFormCB')or((Sender as TCheckBox).Name='DEFormDDCB')) then
    begin
      for I := 0 to (Sender as TCheckBox).Parent.ComponentCount-1 do
        begin
         if ((Sender as TCheckBox).Parent.Components[i] is TCheckBox)and
            (((Sender as TCheckBox).Parent.Components[i] as TCheckBox).Name='DEFormCB') then
              boolIph:=((Sender as TCheckBox).Parent.Components[i] as TCheckBox).Checked;

         if ((Sender as TCheckBox).Parent.Components[i] is TCheckBox)and
            (((Sender as TCheckBox).Parent.Components[i] as TCheckBox).Name='DEFormDDCB') then
              boolDD:=((Sender as TCheckBox).Parent.Components[i] as TCheckBox).Checked;

        end;
      if boolIph then
             if boolDD then PictureName:='DoubleDiodLightFig'
                       else PictureName:='ExpIphFig'
                else
             if boolDD then PictureName:='DoubleDiodFig'
                         else PictureName:='ExpFig';
    end;


for I := 0 to (Sender as TCheckBox).Parent.ComponentCount-1 do
 if ((Sender as TCheckBox).Parent.Components[i] is TImage) then
  begin
  ((Sender as TCheckBox).Parent.Components[i] as TImage).Width:=500;
  ((Sender as TCheckBox).Parent.Components[i] as TImage).Height:=500;
  PictLoadScale(((Sender as TCheckBox).Parent.Components[i] as TImage),PictureName);
  end;
end;

procedure TForm1.OnClickButton(Sender: TObject);
    {чіпляється до Button деяких дочірніх форм,
    викликає вікно з параметрами апроксимації}
var FuncName:string;
    i:integer;
    F:TFitFunctionNew;
    boolIph,boolDD:boolean;
begin
boolIph:=true;
boolDD:=true;

  if (Sender is TButton)and((Sender as TButton).Name='ExpFormBut') then
    begin
     for I := 0 to (Sender as TButton).Parent.ComponentCount-1 do
       if ((Sender as TButton).Parent.Components[i] is TCheckBox) then
        begin
          if ((Sender as TButton).Parent.Components[i] as TCheckBox).Checked
           then FuncName:=FFFunctionPhotoDiodLSM
           else FuncName:=FFFunctionDiodLSM;
        end;
    end;

  if (Sender is TButton)and((Sender as TButton).Name='LamFormBut') then
    begin
     for I := 0 to (Sender as TButton).Parent.ComponentCount-1 do
       if ((Sender as TButton).Parent.Components[i] is TCheckBox) then
        begin
          if ((Sender as TButton).Parent.Components[i] as TCheckBox).Checked
           then FuncName:=FFFunctionPhotoDiodLambert
           else FuncName:=FFFunctionDiodLambert;
        end;
    end;

  if (Sender is TButton)and((Sender as TButton).Name='DEFormBut') then
    begin
     for I := 0 to (Sender as TButton).Parent.ComponentCount-1 do
      begin
       if ((Sender as TButton).Parent.Components[i] is TCheckBox)and
          (((Sender as TButton).Parent.Components[i] as TCheckBox).Name='DEFormCB') then
            boolIph:=((Sender as TButton).Parent.Components[i] as TCheckBox).Checked;

       if ((Sender as TButton).Parent.Components[i] is TCheckBox)and
          (((Sender as TButton).Parent.Components[i] as TCheckBox).Name='DEFormDDCB') then
            boolDD:=((Sender as TButton).Parent.Components[i] as TCheckBox).Checked;
      end;

      if boolIph then
             if boolDD then FuncName:=FFFunctionPhotoDDiod
                       else FuncName:=FFFunctionPhotoDiod
                else
             if boolDD then FuncName:=FFFunctionDDiod
                         else FuncName:=FFFunctionDiod;
    end;

F:=FitFunctionFactory(FuncName);
if  not(Assigned(F)) then Exit;
F.SetParametersGR;
FreeAndNil(F);
end;

Function FuncFitting(A:TVector; B:TVector; FitName:string):boolean;
 var j:integer;
begin
  Result:=False;
  FitFunctionNew:=FitFunctionFactory(FitName);
  try
   FitFunctionNew.Fitting(A);
   if not(FitFunctionNew.ResultsIsReady) then
     begin
      FreeAndNil(FitFunctionNew);
      Exit;
     end;
   FitFunctionNew.OutputDataExport(EvolParam);
   A.CopyTo(B);
   for j:=0 to A.HighNumber do
     B.Y[j]:=FitFunctionNew.FinalFunc(A.X[j]);
  finally
  FreeAndNil(FitFunctionNew);
  end;
  Result:=True;
end;



Procedure ParameterSimplify(Source:TArrSingle;var Target:TArrSingle;FitName:string);
 var Ft:TFitFunctionNew;
     j:integer;
begin
 Ft:=FitFunctionFactory(FitName);
 SetLength(Target,High(Source)+1);
   for j := 0 to High(Target) do
       if Ft.ParameterName(j)='Rs' then Target[j]:=0
         else if Ft.ParameterName(j)='Rsh' then Target[j]:=1e12
           else if Ft.ParameterName(j)='Iph' then Target[j]:=0
             else Target[j]:=Source[j];
 FreeAndNil(Ft);
end;

Procedure ParameterSimplify(Source:TArrSingle;var Target:TArrSingle);overload;
 var j:integer;
begin
 SetLength(Target,High(Source)+1);
   for j := 0 to High(Target) do
       if FitFunctionNew.ParameterName(j)='Rs' then Target[j]:=0
         else if FitFunctionNew.ParameterName(j)='Rsh' then Target[j]:=1e12
           else if FitFunctionNew.ParameterName(j)='Iph' then Target[j]:=0
             else Target[j]:=Source[j];
end;


Function ParamDeterm(Source:TArrSingle;ParamName,FitName:string):double;
{вважаючи, що Source це набір визначених параметрів
апроксимації функцією FitName,
вибирається параметр з назвою ParamNameв}
// var Ft:TFitFunction;
 var Ft:TFitFunctionNew;
     j:integer;
begin
 Ft:=FitFunctionFactory(FitName);
 j:=Ft.ParameterIndexByName(ParamName);
 if j<0 then Result:=ErResult
        else Result:=Source[j];
 FreeAndNil(Ft);
end;

Function ParamDeterm(Source:TArrSingle;ParamName:string):double;
 var j:integer;
begin
 j:=FitFunctionNew.ParameterIndexByName(ParamName);
 if j<0 then Result:=ErResult
        else Result:=Source[j];
end;

Function RsRshIphModification(A:TVectorTransform;FitName:string):boolean;overload;
{дані в А модифікуються таким чином, щоб не лишилося
впливів послідовного та шунтуючого опорів та
фотоструму}
 var j:integer;
     EP:TArrSingle;
     Alim:TVector;
     Rs,temp:double;
begin
  Result:=False;
  Alim:=TVector.Create;
  if not(FuncLimit(A,Alim)) then
     begin
     Alim.Free;
     Exit;
     end;


  FitFunctionNew:=FitFunctionFactory(FitName);
  try
   FitFunctionNew.Fitting(A);
   if not(FitFunctionNew.ResultsIsReady) then
     begin
      FreeAndNil(FitFunctionNew);
      Exit;
     end;
   FitFunctionNew.OutputDataExport(EvolParam);
   ParameterSimplify(EvolParam,EP,FitName);

   Rs:=ParamDeterm(EvolParam,'Rs',FitName);

   for j:=0 to A.HighNumber do
     begin
     temp:=A.X[j];
     A.X[j]:=A.X[j]-A.Y[j]*Rs;
     A.Y[j]:=A.Y[j]-FitFunctionNew.FinalFunc(temp);
     end;
   FitFunctionNew.OutputDataImport(EP);
   for j:=0 to A.HighNumber do
     A.Y[j]:=A.Y[j]+FitFunctionNew.FinalFunc(A.X[j]);
   Result:=True;
  finally
   FreeAndNil(FitFunctionNew);
   Alim.Free;
  end;
end;

Function dB_dV_Build(A:TVector; B:TVector; fun:byte):boolean;
 var temp:TVectorShottky;
begin
 temp:=TVectorShottky.Create(A);
 Result:=temp.dB_dV_Build(B,fun);
 temp.Free;
end;

Function Rnp_Build(A:TVector; B:TVector; fun:byte):boolean;
 var temp:TVectorShottky;
begin
 temp:=TVectorShottky.Create(A);
 Result:=temp.Rnp_Build(B,fun);
 temp.Free;
end;

Function dRnp_dV_Build(A:TVector; B:TVector; fun:byte):boolean;
 var temp:TVectorShottky;
begin
 temp:=TVectorShottky.Create(A);
 Result:=temp.dRnp_dV_Build(B,fun);
 temp.Free;
end;

Function Rnp2_exp_Build(A:TVector; B:TVector; fun:byte):boolean;
 var temp:TVectorShottky;
begin
 temp:=TVectorShottky.Create(A);
 Result:=temp.Rnp2_exp_Build(B,fun);
 temp.Free;
end;

Function Gamma_Build(A:TVector; B:TVector; fun:byte):boolean;
 var temp:TVectorShottky;
begin
 temp:=TVectorShottky.Create(A);
 Result:=temp.Gamma_Build(B,fun);
 temp.Free;
end;

Function FuncLimit(A:TVectorTransform; B:TVector):boolean;
var   Diap:TDiapazon;
begin
  Result:=False;
  Diap:=D[diDE];

  if (Form1.LabIsc.Caption= FFFunctionPhotoDiodLSM)or
     (Form1.LabIsc.Caption= FFFunctionDiodLSM)
              then Diap:=D[diExp];

  if (Form1.LabIsc.Caption= FFFunctionPhotoDiodLambert)or
     (Form1.LabIsc.Caption= FFFunctionDiodLambert)
              then Diap:=D[diLam];

 try
  A.CopyDiapazonPoint(B,Diap);

  if (B.T=0)or(B.Count<3) then  Exit;
 finally
 end;
 Result:=True;
end;

Procedure dB_dV_Fun(A:TVectorShottky;B:TVector; fun:byte;
                    FitName:string;Rbool:boolean);overload;
   Procedure Rs_Modification(InitPoint:TVector; FunctionPoint:TVector;
                             Action:TFunCorrectionNew);
        {модифікація точок, отриманих з InitPoint в FunctionPoint
        за допомогою Action, яка полягає в тому, що враховується значення
        послідовного та шунтуючого опорів }
      var A_apr,B_apr:TVector;
    begin
      A_apr:=TVector.Create;
       if not(FuncFitting(InitPoint,A_apr,FitName)) then
         begin
           A_apr.Free;
           Exit;
         end;
      B_apr:=TVector.Create;
      if not(Action(A_apr,B_apr,fun)) then
         begin
         A_apr.Free;
         B_apr.Free;
         Exit;
         end;
      A_apr.Free;
      FunctionPoint.DeltaY(B_apr);
      B_apr.Free;
    end;

   Procedure BaseAdd(A:TVector);
    var Atemp:TVectorTransform;
        i:integer;
   begin
    Atemp:=TVectorTransform.Create(A);
    for i:=0 to 9 do Atemp.Itself(Atemp.Smoothing);
    A.DeltaY(Atemp);
    Atemp.Free;
   end;


var
    Alim:TVectorTransform;
    Action:TFunCorrectionNew;
begin
  Action:= FunCorrectionDefineNew();

 Alim:=TVectorTransform.Create(A);

 if Form1.CBoxRCons.Checked then
     RsRshIphModification(Alim,FitName);
 Action(Alim,B,fun);
 Alim.Free;
end;


Function FunCorrectionDefineNew():TFunCorrectionNew;
begin
  Result:=dB_dV_Build;
  if Form1.CBDLFunction.Items[Form1.CBDLFunction.ItemIndex]='Rnp' then  Result:=Rnp_Build;
  if Form1.CBDLFunction.Items[Form1.CBDLFunction.ItemIndex]='dRnp/dV' then  Result:=dRnp_dV_Build;
  if Form1.CBDLFunction.Items[Form1.CBDLFunction.ItemIndex]='L(V)' then  Result:=Rnp2_exp_Build;
  if Form1.CBDLFunction.Items[Form1.CBDLFunction.ItemIndex]='G(V)' then Result:=Gamma_Build;
end;




end.

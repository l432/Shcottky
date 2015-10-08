unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, TeeProcs, TeEngine, Chart, Buttons,
  OlegGraph, OlegType, OlegMath, OlegFunction, Math, FileCtrl, Grids, Series, IniFiles,
  TypInfo, Spin, OlegApprox,FrameButtons, FrDiap, OlegMaterialSamples;

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
            Rs_ExN,Rs_Lam,Rs_DE,Rs_EA,
            Is_Exp, Is_El, Is_Gr1, Is_Gr2, Is_Lee,
            Is_Bh, Is_Mk, Is_E2F, Is_E2R,
            Is_ExN,Is_Lam,Is_DE,Is1_EA,Is2_EA,
            n_Exp, n_El, n_Ch, n_K1, n_K2, n_Gr1, n_Gr2,
            n_Cb, n_Wer, n_Lee, n_Bh, n_Mk, n_E2F, n_E2R,
            n_ExN,n_Lam,n_DE,n1_EA,n2_EA,
            Fb_Exp, Fb_El, Fb_H, Fb_N, Fb_Gr1, Fb_Gr2,
            Fb_Lee, Fb_Bh, Fb_Mk, Fb_E2F, Fb_E2R, Kr,
            Fb_ExN,Fb_Lam,Fb_DE,
            Rsh_ExN,Rsh_Lam,Rsh_DE,Rsh_EA,
            If_ExN,If_Lam,If_DE,If_EA,
            Voc_ExN,Voc_Lam,Voc_DE,Voc_EA,
            Isc_ExN,Isc_Lam,Isc_DE,Isc_EA,
            Pm_ExN,Pm_Lam,Pm_DE,Pm_EA,
            FF_ExN,FF_Lam,FF_DE,FF_EA
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
  TDiapazons=(diChung, diMikh, diExp, diEx, diNord, diNss,
              diKam1, diKam2, diGr1, diGr2, diCib, diLee,
              diWer, diIvan, diE2F, DiE2R, diLam, diDE, diHfunc);

  TGraph=(Non,IP,FN,FNm,Ab,Abm,FP,FPm,Rev,Fo,Ka1,Ka2,Gr1,Gr2,Chu,
          Ci,Wer,FoRs,Ide,E2F,E2R,Hf,Nor,FV,FI,MAl,MBe,MId,MRs,
          Nssf,Ditf,Lef);
{допоміжний тип, кожне можливе значення відповідає
графіку, який можна побудувати}

  TForm1 = class(TForm)
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
//    CBAppr: TComboBox;
//    LAppr: TLabel;
    MemoAppr: TMemo;
//    CBoxAppr: TCheckBox;
//    Label1: TLabel;
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
    LabelDel: TLabel;
    ButtonDel: TButton;
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
//    CBoxIscCons: TCheckBox;
//    LabIscCons: TLabel;
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
    GroupBox39: TGroupBox;
    CBDateRs_ExN: TCheckBox;
    CBDaten_ExN: TCheckBox;
    CBDateIs_ExN: TCheckBox;
    CBDateFb_ExN: TCheckBox;
    LExN: TLabel;
    CBDateIf_ExN: TCheckBox;
    CBDateIsc_ExN: TCheckBox;
    CBDateVoc_ExN: TCheckBox;
    CBDatePm_ExN: TCheckBox;
    CBDateFF_ExN: TCheckBox;
    CBDateRsh_ExN: TCheckBox;
    GroupBox40: TGroupBox;
    LLam: TLabel;
    CBDateRs_Lam: TCheckBox;
    CBDaten_Lam: TCheckBox;
    CBDateIs_Lam: TCheckBox;
    CBDateFb_Lam: TCheckBox;
    CBDateIf_Lam: TCheckBox;
    CBDateIsc_Lam: TCheckBox;
    CBDateVoc_Lam: TCheckBox;
    CBDatePm_Lam: TCheckBox;
    CBDateFF_Lam: TCheckBox;
    CBDateRsh_Lam: TCheckBox;
    GroupBox41: TGroupBox;
    LDE: TLabel;
    CBDateRs_DE: TCheckBox;
    CBDaten_DE: TCheckBox;
    CBDateIs_DE: TCheckBox;
    CBDateFb_DE: TCheckBox;
    CBDateIf_DE: TCheckBox;
    CBDateIsc_DE: TCheckBox;
    CBDateVoc_DE: TCheckBox;
    CBDatePm_DE: TCheckBox;
    CBDateFF_DE: TCheckBox;
    CBDateRsh_DE: TCheckBox;
    CBoxRCons: TCheckBox;
    LabRCons: TLabel;
    GroupBox42: TGroupBox;
    LEA: TLabel;
    CBDateRs_EA: TCheckBox;
    CBDaten1_EA: TCheckBox;
    CBDateIs1_EA: TCheckBox;
    CBDateIs2_EA: TCheckBox;
    CBDateIf_EA: TCheckBox;
    CBDateIsc_EA: TCheckBox;
    CBDateVoc_EA: TCheckBox;
    CBDatePm_EA: TCheckBox;
    CBDateFF_EA: TCheckBox;
    CBDateRsh_EA: TCheckBox;
    CBDaten2_EA: TCheckBox;
    Button1: TButton;
    SButFit: TSpeedButton;
    ButFitSelect: TButton;
    ButFitOption: TButton;
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
    LaVarB: TLabel;
    LaPerm: TLabel;
    LaRich: TLabel;
    LaEg: TLabel;
    LaMeff: TLabel;
    LaVarA: TLabel;
    GBDiodParam: TGroupBox;
    Linsulator: TLabel;
    LArea: TLabel;
    LNd: TLabel;
    LEps_i: TLabel;
    LThick_i: TLabel;
    LabelEp: TLabel;
    LabelConcentr: TLabel;
    LabelArea: TLabel;
    ButEps_i: TButton;
    ButNd: TButton;
    ButArea: TButton;
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
//    procedure CBApprChange(Sender: TObject);
    procedure BApprClearClick(Sender: TObject);
//    procedure CBoxApprClick(Sender: TObject);
//    procedure ButtonParamExpClick(Sender: TObject);
//    procedure ButtonParamChungClick(Sender: TObject);
//    procedure ButtonParamHClick(Sender: TObject);
//    procedure ButtonParamExClick(Sender: TObject);
//    procedure ButtonParamNordClick(Sender: TObject);
    procedure ButtonParamRectClick(Sender: TObject);
    procedure ButtonKalkClick(Sender: TObject);
    procedure ButtonKalkParClick(Sender: TObject);
//    procedure Label1Click(Sender: TObject);
    procedure CBKalkChange(Sender: TObject);
//    procedure ButtonParamNssClick(Sender: TObject);
//    procedure ButtonAreaClick(Sender: TObject);
//    procedure RBnSiClick(Sender: TObject);
//    procedure ButtonRichClick(Sender: TObject);
//    procedure ButtonPermClick(Sender: TObject);
    procedure ButtonDelClick(Sender: TObject);
//    procedure ButtonEpClick(Sender: TObject);
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
//    procedure ButtonParamKam2Click(Sender: TObject);
//    procedure ButtonParamKam1Click(Sender: TObject);
    procedure ComboBoxRSChange(Sender: TObject);
    procedure ComboBoxNChange(Sender: TObject);
    procedure ComBForwRsChange(Sender: TObject);
    procedure ButRAClick(Sender: TObject);
    procedure ButRBClick(Sender: TObject);
{    procedure OnlyNumberPress(Sender: TObject; var Key: Char);
{процедура чіпляється до дії KeyPress всіх дочірніх форм,
дозволяє вводити в поля лише числові значення}
    procedure DataSheetDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure DataSheetSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure ButDelClick(Sender: TObject);
    procedure ButInputTClick(Sender: TObject);
//    procedure ButtonParamGr1Click(Sender: TObject);
//    procedure ButtonParamGr2Click(Sender: TObject);
//    procedure ButtonParamBhClick(Sender: TObject);
    procedure ButtonParamCibClick(Sender: TObject);
    procedure ButtonVaClick(Sender: TObject);
//    procedure ButtonParamLeeClick(Sender: TObject);
//    procedure ButtonParamWerClick(Sender: TObject);
//    procedure ButtonParamMikhClick(Sender: TObject);
    procedure ComboBoxNssRsChange(Sender: TObject);
    procedure ComboBoxNssFbChange(Sender: TObject);
//    procedure ButtonConcenClick(Sender: TObject);
//    procedure ButtonParamIvanClick(Sender: TObject);
    procedure ButRCClick(Sender: TObject);
//    procedure ButtonParamE2FClick(Sender: TObject);
//    procedure ButtonParamE2RClick(Sender: TObject);
    procedure RadioButtonM_VClick(Sender: TObject);
    procedure RadioButtonM_VDblClick(Sender: TObject);
    procedure CheckBoxM_VClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure CBoxDLBuildClick(Sender: TObject);
    procedure LDLBuildClick(Sender: TObject);
//    procedure LabIscConsClick(Sender: TObject);
    procedure CBoxBaseLineVisibClick(Sender: TObject);
    procedure ButSaveDLClick(Sender: TObject);
    procedure CBoxBaseLineUseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TrackPanAChange(Sender: TObject);
    procedure RButBaseLineClick(Sender: TObject);
    procedure ButBaseLineResetClick(Sender: TObject);
    procedure CBoxGLShowClick(Sender: TObject);
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
//    procedure ButtonParamLamClick(Sender: TObject);
//    procedure ButtonParamDEClick(Sender: TObject);
    procedure LabRConsClick(Sender: TObject);
    procedure ButFitSelectClick(Sender: TObject);
    procedure SButFitClick(Sender: TObject);
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
    procedure GrBoxGausClick(Sender: TObject);
    procedure ButAveLeftClick(Sender: TObject);
    procedure ButGLAutoClick(Sender: TObject);
    procedure CBDateFunClick(Sender: TObject);
    procedure CBMaterialChange(Sender: TObject);
    procedure LaVarBClick(Sender: TObject);
    {чіпляється до Button деяких дочірніх форм,
    викликає вікно з параметрами апроксимації}
  private
    { Private declarations }
    function GraphType (Sender: TObject):TGraph;
   {повертає значення, яке зв'язане з типом графіку, який
   будується залежно від назви об'єкта Sender}
  public
    { Public declarations }
// procedure OnlyNumberPress(Sender: TObject; var Key: Char);
//{процедура чіпляється до дії KeyPress всіх дочірніх форм,
//дозволяє вводити в поля лише числові значення}
  end;


procedure FileToDataSheet(Sheet:TStringGrid; NameFile:TLabel;
          Temperature:TLabel; a:PVector);
{процедура виведення на форму данних зі структури а:
координати самих точок в Sheet, коротку назву файла
в NameFile, температуру в Temperature}

procedure DataToGraph(SeriesPoint, SeriesLine:TChartSeries;
          Graph: TChart; Caption:string; a:PVector);
{занесення координат точок в змінні SeriesPoint та SeriesLine,
і присвоєння заголовку графіка Graph назви з Caption}

procedure NoLog(X,Y:TCheckBox; Graph:TChart);
{процедура, призначена для зняття галочок
у виборі логарифмічного масштабу та переведення
осей в лінійний режим}

procedure MarkerDraw (Graph,Vax:PVector; Point:Integer; F:TForm1);
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

procedure ApproxHide(Form1:TForm1);
{прибирається апроксимаційна крива,
відповідна кнопка переводиться в ненатиснутий стан}

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

{procedure ParamExp(Form1:TForm1; A:IRE);}
{записує на форму початкові значення аппроксимації
за формулою I=I0[exp(eV/nkT)-1]}

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

//procedure ModeShow(Mode:integer;Iph:boolean;LRs,LRsh,LIph:TLabel);
//{відображення режиму апроксимації
//ВАХ у відповідних мітках}

//procedure ModeToForm(Mode:integer;Iph:boolean;CB_Rs,CB_Rsh,CB_Iph:TCheckBox);
//{встановлення перемикачів CB_Rs,CB_Rsh,CB_Iph
//відповідно до режиму апроксимації, що
//задається параметрами Mode та Iph}
//
//procedure FormToMode(CB_Rs,CB_Rsh,CB_Iph:TCheckBox;var Mode:integer;var Iph:boolean);
//{встановлення  режиму апроксимації
//(параметрів Mode та Iph) відповідно до
//перемикачів CB_Rs,CB_Rsh,CB_Iph}

procedure StrToNumber(St:TCaption; Def:double; var Num:double);
{процедура переведення тестового рядка St в чисельне
значення Num;
якщо формат рядка поганий - змінна не зміниться,
буде показано віконечко з відповідним написом;
якщо рядок порожній - Num  буде присвоєне
значення Def}

Function RsDefineCB(A:PVector; CB, CBdod:TComboBox):double;
{в залежності від вибраного значення
в списку ComboBox
визначаеться величина послідовного опору;
якщо у відповідному методі необхідне
значення n, то воно обчислюється залежно від того,
що вибрано в CBdod}

Function RsDefineCB_Shot(A:PVector; CB:TComboBox):double;
{в залежності від вибраного значення
в списку ComboBox
визначаеться величина послідовного опору,
використовується для методів,
які дозволяють визначити Rs спираючись
лише на вигляд ВАХ, без додаткових параметрів}

Function nDefineCB(A:PVector; CB, CBdod:TComboBox):double;
{в залежності від вибраного значення
в списку ComboBox
визначаеться величина коефіцієнту неідеальності;
якщо у відповідному методі необхідне
значення Rs, то воно обчислюється залежно від того,
що вибрано в CBdod}

Function nDefineCB_Shot(A:PVector; CB:TComboBox):double;
{в залежності від вибраного значення
в списку ComboBox
визначаеться величина коефіцієнту неідеальності,
використовується для методів,
які дозволяють визначити n спираючись
лише на вигляд ВАХ, без додаткових параметрів}

Function FbDefineCB(A:PVector; CB:TComboBox; Rs:double):double;
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

//Procedure DiodParam(F:TForm1;N_Mat:integer;var Ar:double; var Eps:double);
//{встановлення в залежності від значення N_Mat величин
//сталої Річардсона Ar, діелектричної проникності
//напівпровідника Eps та виведення цих значень
//у відповідний блок
//N_Mat
//1 - n-Si; 2 - p-Si; 3 - n-GaAs; 4 - n-InP;
//5 - 4H-SiC; 6 - n-GaN; 7 - n-CdTe; 8 - CuInSe2;
//9 - p-GaTe; 10 - p-GaSe; 11- Other
//У відповідних RadioButton Tag потрібно встановити
//так само як ці номери, тобто RBnSi.Tag=1, RBOther.Tag=11...
//}

Procedure MaterialOnForm;
{виведення на форму параметрів матеріалу, які
беруться зі змінної Semi}

Procedure DiodOnForm;
{виведення на форму параметрів діоду, які
беруться зі змінної Diod}

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

//Procedure dB_dV_Fun(A:Pvector; var B:Pvector; fun:byte; Isc0:double;
//              Iscbool,Rbool:boolean;D:Diapazon; Mode:byte;
//              Light:boolean;Func:byte);
//{по даним у векторі А будує залежність похідної
//диференційного нахилу ВАХ від напруги (метод Булярського)
//fun - кількість зглажувань
//Isc - струм короткого замикання
//Iscbool=true - потрібно враховувати Isc
//Rbool=true - потрібно враховувати послідовний
//та шунтуючі опори
//D, Mode, Light та Func потрібні лише для
//виклику функції ExpKalkNew}
Procedure dB_dV_Fun(A:Pvector; var B:Pvector; fun:byte;
                    FitName:string;Rbool:boolean);
{по даним у векторі А будує залежність похідної
диференційного нахилу ВАХ від напруги (метод Булярського)
fun - кількість зглажувань
Rbool=true - потрібно враховувати послідовний
та шунтуючі опори;
FitName - назва функції, якв буде використовуватись
для апроксимації}


var
  Form1: TForm1;
  Fit:TFitFunction;

  Ft:TFitFunction;

  BohlinMethod: Boolean;
  {використовується при показі віконечок для введення параметрів методів}
  Directory, Directory0, CurDirectory:string;
  VaxFile, VaxGraph, VaxTemp, VaxTempLim{,my_temp}:Pvector;
  GrLim:Limits;
//  EvolType:TEvolutionType;{змінна, де зберігається
//           спосіб еволюційної апроксимації}
  GausLines:array of TLineSeries; {масив для ліній, які
  виводяться при апроксимації гаусіанами}
  GausLinesCur:array of Curve3;
  {масив для параметрів Гаусіан}
  BaseLine:TLineSeries;
  {для кривої відліку в методі визначення гливоких рівнів}
  BaseLineCur:Curve3;
  {для збереження параметрів параболи, яка описує
  лінію відліку в методі визначення глибоких рівнів}
//  ApprFormula:TStringList; {масив зі виглядом формул апроксимації}
  ApprExp:IRE;{початкові значення для аппроксимації експонентою}
  D:array[diChung..diHfunc] of TDiapazon;
{  DChung, DHfunc, DExp, DEx, DNord, DNss, DKam1, DKam2,
  DGr1, DGr2, DCib, DLee, DWer, DMikh: Diapazon;}
  Gamma:double;
  {Gamma - величина параметра гамма у функції Норда}
  Vrect:double;{напруга, при якій відбувається вимірювання
             коефіцієнта випрямлення}
  Rss,nn,Fbb,I00,Krec,Gamma1,Gamma2,Va:double;
  {змінні, в які заносяться результати
  обчислень параметрів різними методами
  Krec - коефіцієнт випрямлення
  Gamma1,Gamma2 - коефіцієнти для побудови функцій Норда
                  у методі Бохліна
  Va - напруга, яка використовується для побудови
       допоміжних функцій у методах Сібілса та Лі
  }
//  Semi:TMaterial;
//  {містить параметри матеріалу}

//  AA, Sk, del, ep, eps, Ndd, RA, RB, RC:double;
  RA, RB, RC:double;
  {АА - стала Річардсона
  Sk - площа контакту
  del - товщина діелектричного прошарку
  ep - відносна діелектрична проникність діелектричного шару
  eps - відносна діелектрична проникність напівпровідника
  Ndd - концентрація ноcіїв в напіпровіднику
  RA, RB, RC - змінні для обчислення послідовного опору за залежністю
      Rs=A+B*T+C*T^2}
  Isc,Voc,Iph,Rsh,Pm,FF:double;
  {Isc - струм короткого замикання
  Voc - напруга холостого ходу
  Iph - фотострум
  Rsh - шунтуючий опір
  Pm - максимальна вихідна потужність фотоелементв
  FF - коефіцієнт форми ВАХ фотоелементу}
//  Mode_Exp,Mode_Lam,Mode_DE:integer;
  {при апроксамації функцією
  I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
  визначають чи всі параметри шукаються:
  0 - підбираються I0,n,Rs,Rsh;
  1 - вважається, що Rsh нескінченність (1е12);
  2 - вважається, що Rs нульовий(1е-4)
  3 - Rsh нескінченність + Rs нульовий
  Mode_Exp - пряма апроксимація за МНК
  Mode_Lam - апроксимація за МНК функції Ламберта
  Mode_DE - метод диференційної еволюції}
  Iph_Exp,Iph_Lam,Iph_DE,DDiod_DE:boolean;
  {визначають, чи потрібно підбирати фотострум
  (при True) у формулі
  I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph,
  тобто чи освітлена ВАХ апроксимується;
  Iph_Exp - пряма апроксимація за МНК
  Iph_Lam - апроксимація за МНК функції Ламберта
  Iph_DE - метод диференційної еволюції,
  DDiod_DE - чи використовується вираз для
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
  EvolParam:TArrSingle;
  {масив з double, використовується в еволюційних процедурах}
  II01,II02,IA,IE:array of double;

implementation

uses ApprWindows, FormSelectFit;

{$R *.dfm}
{$R Fig.RES}


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
  if not (ComboBoxRS.ItemIndex in [0,1,2,3,6,7,10,11,13,14,15,16]) then
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

procedure TForm1.FormCreate(Sender: TObject);
var
    i,j{Imat}:integer;
    ConfigFile:TIniFile;
    st:string;
    DP: TDiapazons;
    DR:TDirName;
    CL:TColName;
//    idMaterialName :TMaterialName;
begin
 Form1.Scaled:=false;
 GroupBox20.ParentBackground:=False;
 GroupBox20.Color:=RGB(254,226,218);
 GroupBox12.ParentBackground:=False;
 GroupBox12.Color:=RGB(222,254,233);
 Directory0:= GetCurrentDir;
 DecimalSeparator:='.';

  CBKalk.Sorted:=False;
  CBKalk.Items.Add('Method');
  CBKalk.Items.Add('Cheung');
  CBKalk.Items.Add('H-function');
  CBKalk.Items.Add('Norde');
  CBKalk.Items.Add('I=I0[exp(Vef/E)-1]+Vef/Rsh-Iph');
  CBKalk.Items.Add('I=I0exp(eV/nkT)');
  CBKalk.Items.Add('Rect.Koef');
  CBKalk.Items.Add('Kaminskii I');
  CBKalk.Items.Add('Kaminskii II');
  CBKalk.Items.Add('Gromov I');
  CBKalk.Items.Add('Gromov II');
  CBKalk.Items.Add('Bohlin');
  CBKalk.Items.Add('Cibils');
  CBKalk.Items.Add('Lee');
  CBKalk.Items.Add('Werner');
  CBKalk.Items.Add('Mikhelashvili');
  CBKalk.Items.Add('Ivanov');
  CBKalk.Items.Add('If/[1-exp(-qVf/kT)]');
  CBKalk.Items.Add('Ir/[1-exp(-qVr/kT)]');
  CBKalk.Items.Add('Lambert function');
  CBKalk.Items.Add('Evolution Algorithm');
  CBKalk.ItemIndex:=0;

  ComboBoxRs.Sorted:=False;
  ComboBoxRs.Items.Add('R=0');
  ComboBoxRs.Items.Add('Cheung');
  ComboBoxRs.Items.Add('I Kaminskii');
  ComboBoxRs.Items.Add('II Kaminskii');
  ComboBoxRs.Items.Add('H-functin');
  ComboBoxRs.Items.Add('Norde');
  ComboBoxRs.Items.Add('A+B*T+C*T^2');
  ComboBoxRs.Items.Add('I Gromov');
  ComboBoxRs.Items.Add('II Gromov');
  ComboBoxRs.Items.Add('Bohlin');
  ComboBoxRs.Items.Add('Cibils');
  ComboBoxRs.Items.Add('Lee');
  ComboBoxRs.Items.Add('Werner');
  ComboBoxRs.Items.Add('Mikhelashvili');
  ComboBoxRs.Items.Add('Full Exp');
  ComboBoxRs.Items.Add('Lambert');
  ComboBoxRs.Items.Add('Dif Evol');

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
  ComboBoxRS_n.Items.Add('n=1');
  ComboBoxRS_n.Items.Add('Cheung');
  ComboBoxRS_n.Items.Add('I Kaminskii');
  ComboBoxRS_n.Items.Add('II Kaminskii');
  ComboBoxRS_n.Items.Add('I Gromov');
  ComboBoxRS_n.Items.Add('II Gromov');
  ComboBoxRS_n.Items.Add('Bohlin');
  ComboBoxRS_n.Items.Add('Cibils');
  ComboBoxRS_n.Items.Add('Lee');
  ComboBoxRS_n.Items.Add('Werner');
  ComboBoxRS_n.Items.Add('Mikhelashvili');
  ComboBoxRS_n.Items.Add('Full Exp');
  ComboBoxRS_n.Items.Add('Lambert');
  ComboBoxRS_n.Items.Add('Dif Evol');

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
  ComboBoxN.Items.Add('n=1');
  ComboBoxN.Items.Add('Cheung');
  ComboBoxN.Items.Add('I Kaminskii');
  ComboBoxN.Items.Add('II Kaminskii');
  ComboBoxN.Items.Add('I0(exp(qV/nkT)-1)');
  ComboBoxN.Items.Add('I0exp(qV/nkT)');
  ComboBoxN.Items.Add('I Gromov');
  ComboBoxN.Items.Add('II Gromov');
  ComboBoxN.Items.Add('Bohlin');
  ComboBoxN.Items.Add('Cibils');
  ComboBoxN.Items.Add('Lee');
  ComboBoxN.Items.Add('Werner');
  ComboBoxN.Items.Add('Mikhelashvili');
  ComboBoxN.Items.Add('If/[1-exp(qVf/kT)]');
  ComboBoxN.Items.Add('Ir/[1-exp(qVr/kT)]');
  ComboBoxN.Items.Add('Full Exp');
  ComboBoxN.Items.Add('Lambert');
  ComboBoxN.Items.Add('Dif Evol');

  ComBHfuncN.Sorted:=False;
  ComBHfuncN.Items:=ComboBoxN.Items;
  ComBNordN.Sorted:=False;
  ComBNordN.Items:=ComboBoxN.Items;
  ComBDateNordN.Sorted:=False;
  ComBDateNordN.Items:=ComboBoxN.Items;
  ComBDateHfunN.Sorted:=False;
  ComBDateHfunN.Items:=ComboBoxN.Items;

  ComboBoxN_Rs.Sorted:=False;
  ComboBoxN_Rs.Items.Add('R=0');
  ComboBoxN_Rs.Items.Add('Cheung');
  ComboBoxN_Rs.Items.Add('I Kaminskii');
  ComboBoxN_Rs.Items.Add('II Kaminskii');
  ComboBoxN_Rs.Items.Add('A+B*T+C*T^2');
  ComboBoxN_Rs.Items.Add('I Gromov');
  ComboBoxN_Rs.Items.Add('II Gromov');
  ComboBoxN_Rs.Items.Add('Bohlin');
  ComboBoxN_Rs.Items.Add('Cibils');
  ComboBoxN_Rs.Items.Add('Lee');
  ComboBoxN_Rs.Items.Add('Werner');
  ComboBoxN_Rs.Items.Add('Mikhelashvili');
  ComboBoxN_Rs.Items.Add('Full Exp');
  ComboBoxN_Rs.Items.Add('Lambert');
  ComboBoxN_Rs.Items.Add('Dif Evol');

  ComBDateHfunN_Rs.Sorted:=False;
  ComBDateHfunN_Rs.Items:=ComboBoxN_Rs.Items;
  ComBDateNordN_Rs.Sorted:=False;
  ComBDateNordN_Rs.Items:=ComboBoxN_Rs.Items;
  ComBHfuncN_Rs.Sorted:=False;
  ComBHfuncN_Rs.Items:=ComboBoxN_Rs.Items;
  ComBNordN_Rs.Sorted:=False;
  ComBNordN_Rs.Items:=ComboBoxN_Rs.Items;

  ComboBoxNssFb.Sorted:=False;
  ComboBoxNssFb.Items.Add('Norde');
  ComboBoxNssFb.Items.Add('I0(exp(qV/nkT)-1)');
  ComboBoxNssFb.Items.Add('I0exp(qV/nkT)');
  ComboBoxNssFb.Items.Add('I Gromov');
  ComboBoxNssFb.Items.Add('II Gromov');
  ComboBoxNssFb.Items.Add('Bohlin');
  ComboBoxNssFb.Items.Add('Lee');
  ComboBoxNssFb.Items.Add('Mikhelashvili');
  ComboBoxNssFb.Items.Add('If/[1-exp(qVf/kT)]');
  ComboBoxNssFb.Items.Add('Ir/[1-exp(qVr/kT)]');
  ComboBoxNssFb.Items.Add('Full Exp');
  ComboBoxNssFb.Items.Add('Lambert');
  ComboBoxNssFb.Items.Add('Dif Evol');

  ComboBNssFb.Sorted:=False;
  ComboBNssFb.Items:=ComboBoxNssFb.Items;

 ConfigFile:=TIniFile.Create(Directory0+'\Shottky.ini');
 Directory:=ConfigFile.ReadString('Direct','Dir',GetCurrentDir);
 CurDirectory:=ConfigFile.ReadString('Direct','CDir',Directory);
 ChooseDirect(Form1);


 CBMaterial.Sorted:=False;
// for idMaterialName :=Low(TMaterialName) to High(TMaterialName) do
//      CBMaterial.Items.Add(Materials[idMaterialName].Name);
 for i :=Ord(Low(TMaterialName)) to ord(High(TMaterialName)) do
      CBMaterial.Items.Add(Materials[TMaterialName(i)].Name);
 CBMaterial.ItemIndex:=ConfigFile.ReadInteger('Parameters','Material',0);

 Semi:=TMaterial.Create(TMaterialName(CBMaterial.ItemIndex));

 if Semi.Name=Materials[High(TMaterialName)].Name
    then Semi.ReadFromIniFile(ConfigFile);

 MaterialOnForm;
//showmessage(Semi.Name);

 Diod:=TDiodSample.Create;
 Diod.ReadFromIniFile(ConfigFile);
 Diod.Material:=Semi;

 DiodOnForm;
// showmessage(floattostr(Diod.Area));
// showmessage(floattostr(Diod.Material.ARich));



//  Sk:=ConfigFile.ReadFloat('Parameters','Square',3.14e-6);
//  Ndd:=ConfigFile.ReadFloat('Parameters','Concentration',5e21);
//  del:=ConfigFile.ReadFloat('Parameters','InsulDepth',3e-7);
//  ep:=ConfigFile.ReadFloat('Parameters','InsulPerm',4);
//
//
//  LabelArea.Caption:=FloatToStrF(Sk,ffExponent,3,2)+' m2';
//  LabelConcentr.Caption:=FloatToStrF(Ndd,ffExponent,3,2)+' m-3';
//  LabelDel.Caption:=FloatToStrF(del,ffExponent,3,2);
//  LabelEp.Caption:=FloatToStrF(ep,ffGeneral,3,2);


GrLim.MinXY:=ConfigFile.ReadInteger('Limit','MinXY',0);
GrLim.MaxXY:=ConfigFile.ReadInteger('Limit','MaxXY',0);
GrLim.MinValue[0]:=ConfigFile.ReadFloat('Limit','MinV0',ErResult);
GrLim.MinValue[1]:=ConfigFile.ReadFloat('Limit','MinV1',ErResult);
GrLim.MaxValue[0]:=ConfigFile.ReadFloat('Limit','MaxV0',ErResult);
GrLim.MaxValue[1]:=ConfigFile.ReadFloat('Limit','MaxV1',ErResult);
  LimitSetup(GrLim, RdGrMin, RdGrMax, LabelMin, LabelMax);

{  ApprExp[1]:=ConfigFile.ReadFloat('Approx','I0',1e-8);
  ApprExp[3]:=ConfigFile.ReadFloat('Approx','Et',0.025);
  ApprExp[2]:=ConfigFile.ReadFloat('Approx','Rs',15000);
  ParamExp(Form1,ApprExp);}
// Mode_Exp:=ConfigFile.ReadInteger('Approx','ModeExp',0);
// Mode_Lam:=ConfigFile.ReadInteger('Approx','ModeLam',0);
// Mode_DE:=ConfigFile.ReadInteger('Approx','ModeDE',0);
 Iph_Exp:=ConfigFile.ReadBool('Approx','Iph_Exp',True);
 Iph_Lam:=ConfigFile.ReadBool('Approx','Iph_Lam',True);
 Iph_DE:=ConfigFile.ReadBool('Approx','Iph_DE',True);
 DDiod_DE:=ConfigFile.ReadBool('Approx','DDiod_DE',True);

// RBGausSelect.OnClick(Self);
// ModeShow(Mode_Exp,Iph_Exp,LabelExpRs,LabelExpRsh,LabelExpIph);
// ModeShow(Mode_Lam,Iph_Lam,LabelLamRs,LabelLamRsh,LabelLamIph);
// ModeShow(Mode_DE,Iph_DE,LabelDERs,LabelDERsh,LabelDEIph);
// if DDiod_DE then LabelDERs.Caption:='Double diod is used'
//             else LabelDERs.Caption:='Double diod does not used';



  for DP := Low(DP) to High(DP) do
   begin
    D[DP]:=TDiapazon.Create;
    D[DP].XMin:=ConfigFile.ReadFloat('Diapaz',
        GetEnumName(TypeInfo(TDiapazons),ord(DP))+' XMin',0.001);
    D[DP].YMin:=ConfigFile.ReadFloat('Diapaz',
        GetEnumName(TypeInfo(TDiapazons),ord(DP))+' YMin',0);
    D[DP].XMax:=ConfigFile.ReadFloat('Diapaz',
        GetEnumName(TypeInfo(TDiapazons),ord(DP))+' XMax',ErResult);
    D[DP].YMax:=ConfigFile.ReadFloat('Diapaz',
        GetEnumName(TypeInfo(TDiapazons),ord(DP))+' Ymax',ErResult);
    D[DP].Br:=ConfigFile.ReadString('Diapaz',
        GetEnumName(TypeInfo(TDiapazons),ord(DP))+' Br','F')[1];
   end;
  if D[diEx].XMin<0.06 then D[diEx].XMin:=0.07;
  if D[diIvan].XMin<0.06 then D[diIvan].XMin:=0.07;
  if D[diLee].XMin<0.05 then D[diLee].XMin:=0.05;
  D[diE2R].Br:='R';

  Gamma:=ConfigFile.ReadFloat('Diapaz','Gamma',2);
  Gamma1:=ConfigFile.ReadFloat('Diapaz','Gamma1',2);
  Gamma2:=ConfigFile.ReadFloat('Diapaz','Gamma2',2.5);
  Va:=ConfigFile.ReadFloat('Diapaz','Va',0.05);
  Vrect:=ConfigFile.ReadFloat('Diapaz','Vrect',0.12);
//  LabelNordGamma.Caption:='gamma: '+FloatToStrF(Gamma,ffGeneral,2,1);
//  LabBohGam1.Caption:='gamma1 = '+FloatToStrF(Gamma1,ffGeneral,2,1);
//  LabBohGam2.Caption:='gamma2 = '+FloatToStrF(Gamma2,ffGeneral,2,1);
  LabelVa.Caption:='Va = '+FloatToStrF(Va,ffGeneral,3,2)+' V';
  LabelRect.Caption:=FloatToStrF(Vrect,ffGeneral,3,2)+' V';

//  Sk:=ConfigFile.ReadFloat('Parameters','Square',3.14e-6);
//  Ndd:=ConfigFile.ReadFloat('Parameters','Concentration',5e21);
//  del:=ConfigFile.ReadFloat('Parameters','InsulDepth',3e-7);
//  ep:=ConfigFile.ReadFloat('Parameters','InsulPerm',4);

  RA:=ConfigFile.ReadFloat('Resistivity','RA',1);
  RB:=ConfigFile.ReadFloat('Resistivity','RB',0);
  RC:=ConfigFile.ReadFloat('Resistivity','RC',0);

//  LabelArea.Caption:=FloatToStrF(Sk,ffExponent,3,2)+' m2';
//  LabelConcentr.Caption:=FloatToStrF(Ndd,ffExponent,3,2)+' m-3';
//  LabelDel.Caption:=FloatToStrF(del,ffExponent,3,2);
//  LabelEp.Caption:=FloatToStrF(ep,ffGeneral,3,2);

  LabRA.Caption:='A = '+FloatToStrF(RA,ffGeneral,3,2);
  LabRB.Caption:='B = '+FloatToStrF(RB,ffExponent,3,2);
  LabRC.Caption:='C = '+FloatToStrF(RC,ffExponent,3,2);
  LabIsc.Caption:=ConfigFile.ReadString('Parameters','DLFunctionName','Photo D-Diod');
  LDateFun.Caption:=ConfigFile.ReadString('Parameters','DateFunctionName','Photo D-Diod');
  ButDateOption.Enabled:=not((LDateFun.Caption='None'));
//    if ((LDateFun.Caption='None')or
////           (LDateFun.Caption='Linear')or
////           (LDateFun.Caption='Quadratic')or
////           (LDateFun.Caption='Exponent')or
////           (LDateFun.Caption='Median filtr')or
////           (LDateFun.Caption='Derivative')or
////           (LDateFun.Caption='Smoothing')or
////           (LDateFun.Caption='Gromov / Lee')or
//           (LDateFun.Caption='Ivanov'))
//           then
//               ButDateOption.Enabled:=False
//           else
//               ButDateOption.Enabled:=True;


  for DP := Low(DP) to High(DP) do
      DiapShowNew(DP);
 {
  DiapShow(D[diExp],LabelExpXmin,LabelExpYmin,LabelExpXmax,LabelExpYmax);
  DiapShow(D[diChung],LabelChungXmin,LabelChungYmin,LabelChungXmax,LabelChungYmax);
  DiapShow(D[diHfunc],LabelHXmin,LabelHYmin,LabelHXmax,LabelHYmax);
  DiapShow(D[diNord],LabelNordXmin,LabelNordYmin,LabelNordXmax,LabelNordYmax);
  DiapShow(D[diCib],LabelCibXmin,LabelCibYmin,LabelCibXmax,LabelCibYmax);
  DiapShow(D[diLee],LabelLeeXmin,LabelLeeYmin,LabelLeeXmax,LabelLeeYmax);
  DiapShow(D[diWer],LabelWerXmin,LabelWerYmin,LabelWerXmax,LabelWerYmax);
  DiapShow(D[diMikh],LabelMikhXmin,LabelMikhYmin,LabelMikhXmax,LabelMikhYmax);
  DiapShow(D[diNss],LabelNssXmin,LabelNssYmin,LabelNssXmax,LabelNssYmax);
  DiapShow(D[diEx],LabelExXmin,LabelExYmin,LabelExXmax,LabelExYmax);
  DiapShow(D[diKam2],LabelKam2Xmin,LabelKam2Ymin,LabelKam2Xmax,LabelKam2Ymax);
  DiapShow(D[diKam1],LabelKam1Xmin,LabelKam1Ymin,LabelKam1Xmax,LabelKam1Ymax);
  DiapShow(D[diGr1],LabelGr1Xmin,LabelGr1Ymin,LabelGr1Xmax,LabelGr1Ymax);
  DiapShow(D[diGr2],LabelGr2Xmin,LabelGr2Ymin,LabelGr2Xmax,LabelGr2Ymax);
  DiapShow(D[diIvan],LabelIvanXmin,LabelIvanYmin,LabelIvanXmax,LabelIvanYmax);
  DiapShow(D[diE2F],LabelE2FXmin,LabelE2FYmin,LabelE2FXmax,LabelE2FYmax);
  DiapShow(D[diE2R],LabelE2RXmin,LabelE2RYmin,LabelE2RXmax,LabelE2RYmax);
  DiapShow(D[diLam],LabelLamXmin,LabelLamYmin,LabelLamXmax,LabelLamYmax);
  DiapShow(D[diDE],LabelDEXmin,LabelDEYmin,LabelDEXmax,LabelDEYmax);
}
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




//Imat:=ConfigFile.ReadInteger('Parameters','MaterialNumber',1);
//DiodParam(Form1,Imat,AA,eps);

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

RadioButtonNssNvM.Checked:=ConfigFile.ReadBool('Graph','Nss_N(V)',False);
RadButNssNvM.Checked:=ConfigFile.ReadBool('Dir','NssN(V)',False);
//ColParam(StrGridData);

//i:=ConfigFile.ReadInteger('Parameters','EvolutionType',0);
//case i of
// 1:EvolType:=TMABC;
// 2:EvolType:=TTLBO;
// 3:EvolType:=TPSO;
// else EvolType:=TDE;
//end;
//case EvolType of
//       TMABC:GroupBoxParamDE.Caption:='MABC';
//       TTLBO:GroupBoxParamDE.Caption:='TLBO';
//       TPSO:GroupBoxParamDE.Caption:='PSO';
//       else GroupBoxParamDE.Caption:='DE';
//    end;

//  ApprFormula:=TStringlist.Create;
//  ApprFormula.Add('');
//  ApprFormula.Add('y=A+Bx');
//  ApprFormula.Add('y=A+Bx+Cx^2');
//  ApprFormula.Add('y=I0exp(x/nkT)');
//  ApprFormula.Add('Y=I0[exp(Xef/E)-1]+Xef/Rsh-Yph');
//  ApprFormula.Add('3-point smoothing');
//  ApprFormula.Add('3-point median filtering');
//  ApprFormula.Add('Derivation');
//  ApprFormula.Add('y=A+Bx+Cln(x)');
//  ApprFormula.Add('Parametric aproxmation');
//  ApprFormula.Add('One Diod, Lambert aproxmation');
//  ApprFormula.Add('One Diod, Evolution Method');
////  ApprFormula.Add('Teaching Learning');
////  ApprFormula.Add('Artificial Bee Colony');
//  ApprFormula.Add('Double Diod, Evolution Method');
//  CBAppr.ItemIndex:=0;
  SButFit.Caption:='None';
  CBKalk.ItemIndex:=0;
//  LAppr.Caption:=ApprFormula.Strings[CBAppr.ItemIndex];
  MemoAppr.Clear;

  new(VaxFile);
  new(VaxGraph);
  new(VaxTemp);
  new(VaxTempLim);
//  new(my_temp);

  MarkerHide(Form1);
  VaxFile^.n:=0;
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
//  SGridGaussian.Cells[0,0]:='N';
//  SGridGaussian.Cells[1,0]:='U0';
//  SGridGaussian.Cells[2,0]:='Et';
//  SGridGaussian.Cells[3,0]:='Deviation';
//  SGridGaussian.Cells[4,0]:='Max Value';
//  SGridGaussian.Cells[5,0]:='Quota';

  RBGausSelect.Checked:=ConfigFile.ReadBool('Approx','SelectGaus',True);
  RBAveSelect.Checked:=not(RBGausSelect.Checked);


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

  DLParamPassive;
  ConfigFile.Free;

    SetLength(II01,42);
   SetLength(II02,42);
   SetLength(IA,42);
   SetLength(IE,42);

IA[2]:=8.123E-7;
IA[3]:=1.222E-6;
IA[4]:=1.591E-6;
IA[5]:=1.856E-6;
IA[6]:=2.479E-6;
IA[7]:=2.792E-6;
IA[8]:=3.681E-6;
IA[9]:=4.169E-6;
IA[10]:=4.848E-6;
IA[11]:=5.889E-6;
IA[12]:=6.693E-6;
IA[13]:=9.166E-6;
IA[14]:=1.049E-5;
IA[15]:=1.225E-5;
IA[16]:=1.545E-5;
IA[17]:=1.774E-5;
IA[18]:=2.047E-5;
IA[19]:=2.588E-5;
IA[20]:=2.957E-5;
IA[21]:=3.366E-5;
IA[22]:=4.111E-5;
IA[23]:=4.654E-5;
IA[24]:=5.208E-5;
IA[25]:=6.277E-5;
IA[26]:=7.012E-5;
IA[27]:=7.813E-5;
IA[28]:=8.706E-5;
IA[29]:=1.045E-4;
IA[30]:=1.158E-4;
IA[31]:=1.275E-4;
IA[32]:=1.398E-4;
IA[33]:=1.551E-4;
IA[34]:=1.798E-4;
IA[35]:=1.985E-4;
IA[36]:=2.167E-4;
IA[37]:=2.393E-4;
IA[38]:=2.76E-4;
IA[39]:=3.049E-4;
IA[40]:=3.348E-4;
IA[41]:=3.697E-4;

II01[0]:=0;
II01[1]:=0;
II01[2]:=142.5;
II01[3]:=119.2;
II01[4]:=113;
II01[5]:=118.3;
II01[6]:=100.8;
II01[7]:=105.5;
II01[8]:=88.06;
II01[9]:=88.92;
II01[10]:=85.81;
II01[11]:=77.34;
II01[12]:=75.59;
II01[13]:=57.07;
II01[14]:=54.55;
II01[15]:=50.31;
II01[16]:=41.59;
II01[17]:=38.82;
II01[18]:=35.82;
II01[19]:=29.04;
II01[20]:=26.88;
II01[21]:=24.96;
II01[22]:=20.89;
II01[23]:=19.37;
II01[24]:=18.2;
II01[25]:=15.31;
II01[26]:=14.33;
II01[27]:=13.41;
II01[28]:=12.51;
II01[29]:=10.43;
II01[30]:=9.747;
II01[31]:=9.183;
II01[32]:=8.679;
II01[33]:=8.062;
II01[34]:=6.982;
II01[35]:=6.49;
II01[36]:=6.13;
II01[37]:=5.689;
II01[38]:=4.923;
II01[39]:=4.547;
II01[40]:=4.226;
II01[41]:=3.894;



IE[2]:=0.7587;
IE[3]:=0.7428;
IE[4]:=0.7318;
IE[5]:=0.7264;
IE[6]:=0.7138;
IE[7]:=0.7083;
IE[8]:=0.6948;
IE[9]:=0.6893;
IE[10]:=0.6832;
IE[11]:=0.674;
IE[12]:=0.6687;
IE[13]:=0.6517;
IE[14]:=0.6461;
IE[15]:=0.6387;
IE[16]:=0.6257;
IE[17]:=0.6192;
IE[18]:=0.6119;
IE[19]:=0.5982;
IE[20]:=0.5911;
IE[21]:=0.5846;
IE[22]:=0.5723;
IE[23]:=0.5657;
IE[24]:=0.5601;
IE[25]:=0.5479;
IE[26]:=0.5419;
IE[27]:=0.536;
IE[28]:=0.5297;
IE[29]:=0.5169;
IE[30]:=0.5109;
IE[31]:=0.5056;
IE[32]:=0.5004;
IE[33]:=0.4946;
IE[34]:=0.4844;
IE[35]:=0.4784;
IE[36]:=0.4738;
IE[37]:=0.4684;
IE[38]:=0.4588;
IE[39]:=0.4527;
IE[40]:=0.4474;
IE[41]:=0.4415;

II02[2]:=279.3;
II02[3]:=168.8;
II02[4]:=119.8;
II02[5]:=103.2;
II02[6]:=68.85;
II02[7]:=58.82;
II02[8]:=37.76;
II02[9]:=32.05;
II02[10]:=26.59;
II02[11]:=19.79;
II02[12]:=16.91;
II02[13]:=9.538;
II02[14]:=8.026;
II02[15]:=6.352;
II02[16]:=4.12;
II02[17]:=3.348;
II02[18]:=2.655;
II02[19]:=1.674;
II02[20]:=1.335;
II02[21]:=1.084;
II02[22]:=0.7186;
II02[23]:=0.5809;
II02[24]:=0.4875;
II02[25]:=0.3238;
II02[26]:=0.2676;
II02[27]:=0.2213;
II02[28]:=0.1808;
II02[29]:=0.1176;
II02[30]:=0.09695;
II02[31]:=0.08211;
II02[32]:=0.06962;
II02[33]:=0.05779;
II02[34]:=0.04106;
II02[35]:=0.03382;
II02[36]:=0.02917;
II02[37]:=0.0246;
II02[38]:=0.01782;
II02[39]:=0.01458;
II02[40]:=0.01232;
II02[41]:=0.01014;



end;

procedure TForm1.FormDestroy(Sender: TObject);
var
    ConfigFile:TIniFile;
    i:integer;
    DP:TDiapazons;
    DR:TDirName;
    CL:TColName;
begin
 ConfigFile:=TIniFile.Create(Directory0+'\Shottky.ini');
// ApprFormula.Free;
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

{ ConfigFile.WriteFloat('Approx','I0',ApprExp[1]);
 ConfigFile.WriteFloat('Approx','Et',ApprExp[3]);
 ConfigFile.WriteFloat('Approx','Rs',ApprExp[2]);}
// ConfigFile.WriteInteger('Approx','ModeExp',Mode_Exp);
// ConfigFile.WriteInteger('Approx','ModeLam',Mode_Lam);
// ConfigFile.WriteInteger('Approx','ModeDE',Mode_DE);
 ConfigFile.WriteBool('Approx','Iph_Exp',Iph_Exp);
 ConfigFile.WriteBool('Approx','Iph_Lam',Iph_Lam);
 ConfigFile.WriteBool('Approx','Iph_DE',Iph_DE);
 ConfigFile.WriteBool('Approx','DDiod_DE',DDiod_DE);
 ConfigFile.WriteBool('Approx','SelectGaus',RBGausSelect.Checked);

  for DP := Low(DP) to High(DP) do
   begin
   ConfigFile.WriteFloat('Diapaz',
    GetEnumName(TypeInfo(TDiapazons),ord(DP))+' XMin',D[Dp].XMin);
   ConfigFile.WriteFloat('Diapaz',
    GetEnumName(TypeInfo(TDiapazons),ord(DP))+' YMin',D[Dp].YMin);
   ConfigFile.WriteFloat('Diapaz',
    GetEnumName(TypeInfo(TDiapazons),ord(DP))+' XMax',D[Dp].XMax);
   ConfigFile.WriteFloat('Diapaz',
    GetEnumName(TypeInfo(TDiapazons),ord(DP))+' Ymax',D[Dp].YMax);
   ConfigFile.WriteString('Diapaz',
    GetEnumName(TypeInfo(TDiapazons),ord(DP))+' Br',D[Dp].Br);
   D[DP].Free;
   end;

  ConfigFile.WriteFloat('Diapaz','Gamma',Gamma);
  ConfigFile.WriteFloat('Diapaz','Gamma1',Gamma1);
  ConfigFile.WriteFloat('Diapaz','Gamma2',Gamma2);
  ConfigFile.WriteFloat('Diapaz','Va',Va);
  ConfigFile.WriteFloat('Diapaz','Vrect',Vrect);

//  ConfigFile.WriteFloat('Parameters','Square',Sk);
//  ConfigFile.WriteFloat('Parameters','Concentration',Ndd);
//  ConfigFile.WriteFloat('Parameters','InsulDepth',del);
//  ConfigFile.WriteFloat('Parameters','InsulPerm',ep);
//  ConfigFile.WriteFloat('Parameters','RichConst',AA);
  ConfigFile.WriteFloat('Resistivity','RA',RA);
  ConfigFile.WriteFloat('Resistivity','RB',RB);
  ConfigFile.WriteFloat('Resistivity','RC',RC);
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

Diod.WriteToIniFile(ConfigFile);
Diod.Free;
ConfigFile.WriteInteger('Parameters','Material',CBMaterial.ItemIndex);
if Semi.Name=Materials[High(TMaterialName)].Name
    then  Semi.WriteToIniFile(ConfigFile);
Semi.Free;

//case EvolType of
//   TDE:ConfigFile.WriteInteger('Parameters','EvolutionType',0);
//   TMABC:ConfigFile.WriteInteger('Parameters','EvolutionType',1);
//   TTLBO:ConfigFile.WriteInteger('Parameters','EvolutionType',2);
//   TPSO:ConfigFile.WriteInteger('Parameters','EvolutionType',3);
//end;

  if Assigned(BaseLine) then BaseLine.Free;
  if Assigned(BaseLineCur) then BaseLineCur.Free;
  GausLinesSave;
  GausLinesFree;
  
 dispose(VaxFile);
 dispose(VaxGraph);
 dispose(VaxTemp);
 dispose(VaxTempLim);
// dispose(my_temp);
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

 IVchar(VaxFile,VaxGraph);
//  showmessage('2222 '+inttostr(VaxGraph^.n));
 DataToGraph(Series1,Series2,Graph,'I-V-characteristic',VaxGraph);

 IVChar(VaxGraph,VaxTemp);
end;

function TForm1.GraphType(Sender: TObject): TGraph;
   {повертає значення, яке зв'язане з типом графіку, який
   будується залежно від назви об'єкта Sender}
begin
Result:=Non;
if (TComponent(Sender).Name='RadioButtonM_V') or
   (TComponent(Sender).Name='ButM_V') then Result:=IP;
if (TComponent(Sender).Name='RadioButtonFN') or
   (TComponent(Sender).Name='ButFow_Nor') then Result:=FN;
if (TComponent(Sender).Name='RadioButtonFNEm') or
   (TComponent(Sender).Name='ButFow_NorE') then Result:=FNm;
if (TComponent(Sender).Name='RadioButtonAb') or
   (TComponent(Sender).Name='ButAbeles') then Result:=Ab;
if (TComponent(Sender).Name='RadioButtonAbEm') or
   (TComponent(Sender).Name='ButAbelesE') then Result:=Abm;
if (TComponent(Sender).Name='RadioButtonFP') or
   (TComponent(Sender).Name='ButFr_Pool') then Result:=FP;
if (TComponent(Sender).Name='RadioButtonFPEm') or
   (TComponent(Sender).Name='ButFr_PoolE') then Result:=FPm;
if (TComponent(Sender).Name='RadioButtonLee') or
   (TComponent(Sender).Name='ButLee')  then Result:=Lef;
if (TComponent(Sender).Name='RadioButtonKam1') or
   (TComponent(Sender).Name='ButKam1') then Result:=Ka1;
if (TComponent(Sender).Name='RadioButtonKam2') or
   (TComponent(Sender).Name='ButKam2') then Result:=Ka2;
if (TComponent(Sender).Name='RadioButtonGr1') or
   (TComponent(Sender).Name='ButGr1')  then Result:=Gr1;
if (TComponent(Sender).Name='RadioButtonGr2') or
   (TComponent(Sender).Name='ButGr2')  then Result:=Gr2;
if (TComponent(Sender).Name='Chung') or
   (TComponent(Sender).Name='ButChung')then Result:=Chu;
if (TComponent(Sender).Name='RadioButtonCib') or
   (TComponent(Sender).Name='ButCib')  then Result:=Ci;
if (TComponent(Sender).Name='RadioButtonWer') or
   (TComponent(Sender).Name='ButWer')  then Result:=Wer;
if (TComponent(Sender).Name='RadioButtonForwRs') or
   (TComponent(Sender).Name='ButForwRs')then Result:=FoRs;
if (TComponent(Sender).Name='RadioButtonN') or
   (TComponent(Sender).Name='ButtonN')  then Result:=Ide;
if (TComponent(Sender).Name='RadioButtonEx2F') or
   (TComponent(Sender).Name='ButExp2F') then Result:=E2F;
if (TComponent(Sender).Name='RadioButtonEx2R') or
   (TComponent(Sender).Name='ButExp2R') then Result:=E2R;
if (TComponent(Sender).Name='Hfunc') or
   (TComponent(Sender).Name='ButHfunc') then Result:=Hf;
if (TComponent(Sender).Name='Nord') or
   (TComponent(Sender).Name='ButNord')  then Result:=Nor;
if (TComponent(Sender).Name='RadioButtonF_V') then Result:=FV;
if (TComponent(Sender).Name='RadioButtonF_I') then Result:=FI;
if (TComponent(Sender).Name='RadioButtonMikhAlpha') or
   (TComponent(Sender).Name='ButMAlpha')then Result:=MAl;
if (TComponent(Sender).Name='RadioButtonMikhN') or
   (TComponent(Sender).Name='ButMN')    then Result:=MId;
if (TComponent(Sender).Name='RadioButtonMikhRs') or
   (TComponent(Sender).Name='ButMRs')   then Result:=MRs;
if (TComponent(Sender).Name='RadioButtonMikhBetta') or
   (TComponent(Sender).Name='ButMBetta')then Result:=MBe;
if (TComponent(Sender).Name='RadioButtonNss') or
   (TComponent(Sender).Name='ButNss')   then Result:=Nssf;
if (TComponent(Sender).Name='RadioButtonDit') or
   (TComponent(Sender).Name='ButDit')   then Result:=Ditf;
if TComponent(Sender).Name='ForIV' then Result:=Fo;
if TComponent(Sender).Name='RevIV' then Result:=Rev;
end;

procedure TForm1.GrBoxGausClick(Sender: TObject);
begin

end;

//procedure TForm1.Label1Click(Sender: TObject);
//begin
//CBoxAppr.Checked:= not CBoxAppr.Checked;
////CBoxApprClick(Label1);
//end;




procedure TForm1.LabelXLogClick(Sender: TObject);
begin
 XLogCheck.Checked:= not XLogCheck.Checked;
// XLogCheckClick(LabelXLog);
end;

procedure TForm1.LabelYLogClick(Sender: TObject);
begin
 YLogCheck.Checked:= not YLogCheck.Checked;
// YLogCheckClick(LabelYLog);
 end;

//procedure TForm1.LabIscConsClick(Sender: TObject);
//begin
// CBoxIscCons.Checked:= not CBoxIscCons.Checked;
// CBoxDLBuildClick(LabIscCons);
//end;

procedure TForm1.LabRConsClick(Sender: TObject);
begin
 CBoxRCons.Checked:= not CBoxRCons.Checked;
 CBoxDLBuildClick(LabRCons);
end;

procedure TForm1.LaVarBClick(Sender: TObject);
var Value:double;
    st:string;
begin
if (Sender as TLabel).Name='LaVarB' then Value:=Semi.VarshB;
if (Sender as TLabel).Name='LaVarA' then Value:=Semi.VarshA;
if (Sender as TLabel).Name='LaMeff' then Value:=Semi.Meff;
if (Sender as TLabel).Name='LaEg' then Value:=Semi.Eg0;
if (Sender as TLabel).Name='LaPerm' then Value:=Semi.Eps;
if (Sender as TLabel).Name='LaRich' then Value:=Semi.ARich;


st:=FloatToStrF(Value,ffGeneral,4,3);
if st='ErResult' then st:='';


st:=InputBox('Input value',
             'the material parameter value is expected',
             st);

StrToNumber(st, ErResult, Value);
if (Sender as TLabel).Name='LaVarB' then Semi.VarshB:=Value;
if (Sender as TLabel).Name='LaVarA' then Semi.VarshA:=Value;
if (Sender as TLabel).Name='LaMeff' then Semi.Meff:=Value;
if (Sender as TLabel).Name='LaEg' then Semi.Eg0:=Value;
if (Sender as TLabel).Name='LaPerm' then Semi.Eps:=Value;
if (Sender as TLabel).Name='LaRich' then Semi.ARich:=Value;

MaterialOnForm;
end;

procedure TForm1.LDLBuildClick(Sender: TObject);
begin
 CBoxDLBuild.Checked:= not CBoxDLBuild.Checked;
// CBoxDLBuildClick(LDLBuild);
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
//showmessage(inttostr(High(GausLinesCur)));
   Try    ChDir(Directory);
          OpenDialog1.InitialDir:=Directory;
   Except ChDir(Directory0);
          OpenDialog1.InitialDir:=Directory0;
   End;
   if OpenDialog1.Execute()
     then
       begin
       ProcessPath(OpenDialog1.FileName, drive, path, fileName);
       Directory:=drive + ':' + path;
       CurDirectory:=Directory;
       ChooseDirect(Form1);
       ChDir(Directory);
       DirName.Caption:=Directory;
       if FileExists(fileName) then Read_File(fileName,VaxFile);
       if VaxFile^.n=0 then
           begin
           MessageDlg('File '+VaxGraph^.name+' has not correct datas',
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
//               GausLines[0].SeriesColor:=clRed;
//               GausLines[0].Active:=True;
               SEGauss.Enabled:=True;
//               GausLines[0].ParentChart:=Graph;
//               Series1.Active:=False;
//               Series2.Active:=False;
               SGridGaussian.Enabled:=True;
               ButGlDel.Enabled:=True;
               ButGausSave.Enabled:=True;
             end; // if High(GausLines)<0 then
//          showmessage(inttostr(High(GausLines)));
          SetLength(GausLines,High(GausLines)+2);
          GausLines[High(GausLines)]:=TLineSeries.Create(Form1);
          VectorToGraph(VaxFile,GausLines[High(GausLines)]);
          SGridGaussian.RowCount:=SGridGaussian.RowCount+1;
          SGridGaussian.Cells[0,SGridGaussian.RowCount-4]:=
                       IntToStr(High(GausLines));
          SGridGaussian.Cells[1,SGridGaussian.RowCount-4]:=VaxFile^.name;

          if SEGauss.Value<>0 then GausLines[SEGauss.Value].SeriesColor:=clNavy;
          GausLines[High(GausLines)].SeriesColor:=clBlue;
//          Graph.RemoveSeries(GausLines[0]);
          GraphAverage(GausLines);
//          GausLines[0].ParentChart:=Graph;
          GausLines[High(GausLines)].ParentChart:=Graph;
          GausLines[High(GausLines)].Active:=True;
          SEGauss.MaxValue:=High(GausLines);
          SEGauss.Value:=SEGauss.MaxValue;
          GraphToVector(GausLines[0],VaxFile);
          VaxFile^.T:=0;
          VaxFile^.name:='average';
         end;
          // if (PageControl1.ActivePageIndex=3)and(RBAveSelect.Checked) then
//                                                                   else
         GraphShow(Form1);
       end;
end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin
case PageControl1.ActivePageIndex of
 1,3:begin
   Graph.Parent:=PageControl1.Pages[PageControl1.ActivePageIndex];
   Close1.Parent:=PageControl1.Pages[PageControl1.ActivePageIndex];
 {  if PageControl1.ActivePageIndex=1 then  Close1.Left:=Form1.ClientWidth-120
                                     else Close1.Left:=Form1.ClientWidth-95;}
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
   VaxGraph.n:=0;
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
const
  cnbb=' can not be built';
  cnbd=' can not be determined';
  tIVc='The I-V-characteristic has not point';
  bfcia=#10'because forward current is absent';
  rsi=#10'because range is selected improperly or'#10'forward characteristic has a repetitive element';
var str:string;
    tg:TGraph;
begin
tg:=GraphType(Sender);
ClearGraph(Form1);
VaxGraph^.n:=0;
Rss:=ErResult;
nn:=ErResult;

repeat
if tg in [FoRs,Ide,E2F,E2R,Nssf,Ditf,Hf] then
  begin
  case tg of
    FoRs,Ide,E2F,E2R:
       Rss:=RsDefineCB(VaxFile,Form1.ComboBoxRs,Form1.ComboBoxRs_n);
    Hf:
       nn:=nDefineCB(VaxFile,Form1.ComboBoxN,Form1.ComboBoxN_Rs);
    Nssf,Ditf:
       Rss:=RsDefineCB(VaxFile,ComboBoxNssRs,ComboBoxNssRs_n);
    end; //case
  if (Rss=ErResult)and(tg in [FoRs,Ide,E2F,E2R,Nssf,Ditf]) then
              str:='Curve'+cnbb+#10'because Rs'+cnbd;
  if (nn=ErResult)and(tg=Hf) then
              str:='H-function'+cnbb+#10'because n'+cnbd;
  if (Rss=ErResult)and(nn=ErResult) then
              begin
              tg:=Non;
              Break;
              end;
  if tg=Nssf then
              begin
              Fbb:=FbDefineCB(VaxFile,ComboBoxNssFb,Rss);
              if Fbb=ErResult then
                        begin
                        str:='Curve'+cnbb+#10'because Fb'+cnbd;
                        tg:=Non;
                        Break;
                        end
              end;

  end; //if tg in [FoRs,Ide,E2F,E2R,Nssf,Ditf,Hf] then

case tg of
  Non: ;
  IP,FN,FNm,Ab,Abm,FP,FPm:
     begin
      M_V_Fun(VaxFile,VaxGraph,CheckBoxM_V.Checked,ord(tg));
      case tg of
        IP: str:='The power index function';
        FN: str:='The Fowler-Nordheim function';
        FNm:str:='The Fowler-Nordheim function (max electric field)';
        Ab: str:='The Abeles function';
        Abm:str:='The Abeles function (max electric field)' ;
        FP: str:='The Frenkel-Pool function';
        FPm:str:='The Frenkel-Pool function (max electric field)' ;
       end;
      if CheckBoxM_V.Checked then str:=str+' for forward branch'
                             else str:=str+' for reverse branch';
     end ;
  Rev:
    begin
     ReverseIV(VaxFile,VaxGraph);
     str:='Reverse I-V-characteristic';
    end;
  Fo:
    begin
    ForwardIV(VaxFile,VaxGraph);
    str:='Forward I-V-characteristic';
    end;
  Ka1:
    begin
    Kam1_Fun(VaxFile,VaxGraph,D[diKam1]);
    str:='Kaminski function I';
    end;
  Ka2:
    begin
    Kam2_Fun(VaxFile,VaxGraph,D[diKam2]);
    str:='Kaminski function II';
    end;
  Gr1:
    begin
    Gr1_Fun(VaxFile,VaxGraph);
    str:='Gromov function I';
    end;
  Gr2:
    begin
    Gr2_Fun(VaxFile,VaxGraph, Diod);
    str:='Gromov function II';
    end;
  Chu:
    begin
    ChungFun(VaxFile,VaxGraph);
    str:='Cheung function';
    end;
  Ci:
    begin
    CibilsFun(VaxFile,D[diCib],VaxGraph);
    str:='Cibils function';
    end;
  Wer:
    begin
    WernerFun(VaxFile,VaxGraph);
    str:='Werner function';
    end;
  FoRs:
    begin
    ForwardIVwithRs(VaxFile,VaxGraph,Rss);
    str:='Forward I-V-characteristic with Rs';
    end;
  Ide:
    begin
    N_V_Fun(VaxFile,VaxGraph,Rss);
    str:='Ideality factor vs voltage';
    end;
  E2F:
    begin
    Forward2Exp(VaxFile,VaxGraph,Rss);
    str:='Forward I/[1-exp(-qV/kT)] vs V characteristic with Rs';
    end;
  E2R:
    begin
    Reverse2Exp(VaxFile,VaxGraph,Rss);
    str:='Reverse I/[1-exp(-qV/kT)] vs V characteristic with Rs';
    end;
  Hf:
    begin
    HFun(VaxFile,VaxGraph, Diod, nn);
    str:='H - function';
    end;
  Nor:
    begin
    NordeFun(VaxFile,VaxGraph, Diod, Gamma);
    str:='Norde"s function';
    end;
  FV:
    begin
    CibilsFunDod(VaxFile,VaxGraph,Va);
    str:='F(V) = V - Va * ln( I )';
    end;
  FI:
    begin
    LeeFunDod(VaxFile,VaxGraph,Va);
    str:='F(I) = V - Va * ln( I )';
    end;
  MAl:
    begin
    MikhAlpha_Fun(VaxFile,VaxGraph);
    str:='Alpha function (Mikhelashvili"s method)';
    end;
  MBe:
    begin
    MikhBetta_Fun(VaxFile,VaxGraph);
    str:='Betta function (Mikhelashvili"s method)';
    end;
  MId:
    begin
    MikhN_Fun(VaxFile,VaxGraph);
    str:='Ideality factor vs voltage (Mikhelashvili"s method)';
    end;
  MRs:
    begin
    MikhRs_Fun(VaxFile,VaxGraph);
    str:='Series resistant vs voltage (Mikhelashvili"s method)';
    end;
  Nssf:
    begin
    Nss_Fun(VaxFile, VaxGraph,Fbb,Rss,Diod,D[diNss],RadioButtonNssNvD.Checked);
    str:='Deep level density';
    end;
  Ditf:
    begin
    Dit_Fun(VaxFile, VaxGraph,Rss,Diod,D[diIvan]);
    str:='Deep level density';
    end;
  Lef:
    begin
     LeeFun(VaxFile,D[diLee],VaxGraph);
     str:='Lee function';
    end;
end;
until true;


if VaxGraph^.n=0 then
    begin
    case tg of
      Non: ;
      IP,FN,FNm,Ab,Abm,FP,FPm:
           str:=str+cnbb;
      Rev,E2R:
           str:=tIVc+#10'with negative voltage';
      Fo:  str:=tIVc+#10'with positive voltage';
      Ka1: str:=str+cnbb+rsi;
      Ka2: str:=str+cnbb+rsi+#10'or negative current';
      Gr1: str:=str+cnbb+#10'because I-V-characteristic has not point'#10'with positive voltage';
      Gr2,Chu,Wer,Hf,Nor:
           str:=str+cnbb+bfcia;
      Ci,Lef:
           str:=str+cnbb+bfcia+#10'or range is selected improperly';
      FoRs,E2F:
           str:=tIVc+#10'with positive current';
      Ide: str:=str+cnbb+bfcia+#10'or forward characteristic has a negative current';
      FV,FI:
           str:='The function'+cnbb+bfcia;
      MAl: str:=str+#10+cnbb+bfcia+#10'or there is no maximum on the curve';
      MBe,MId,MRs:
           str:=str+cnbb+#10'because impossible to build Alpha function';
      Nssf:str:='The Nss function'+cnbb;
      Ditf:str:='The Dit function'+cnbb;
     end;   //case
    MessageDlg(str, mtError, [mbOK], 0);
    end
            else
     case tg of
       Gr1: DiapToLimToTForm1(D[diGr1],Form1);
       Gr2: DiapToLimToTForm1(D[diGr2],Form1);
       Chu: DiapToLimToTForm1(D[diChung],Form1);
       Wer: DiapToLimToTForm1(D[diWer],Form1);
       FoRs:DiapToLimToTForm1(D[diEx],Form1);
       E2F: DiapToLimToTForm1(D[diE2F],Form1);
       E2R: DiapToLimToTForm1(D[diE2R],Form1);
       Hf:  DiapToLimToTForm1(D[diHfunc],Form1);
       Nor: DiapToLimToTForm1(D[diNord],Form1);
       FV:  DiapToLimToTForm1(D[diCib],Form1);
       FI:  DiapToLimToTForm1(D[diLee],Form1);
       MAl,MBe,MId,MRs:
            DiapToLimToTForm1(D[diMikh],Form1);
       Nssf:DiapToLimToTForm1(D[diNss],Form1);
       Ditf:DiapToLimToTForm1(D[diIvan],Form1);
     end;  //case


ShowGraph(Form1,str);
end;

procedure TForm1.RadioButtonM_VDblClick(Sender: TObject);
var st:string;
    tg:TGraph;
begin
tg:=GraphType(Sender);
case tg of
  IP:   st:='Y = d (ln I)/d (ln V)'#10'X = V';
  FN:   st:='Y = ln (I/V^2)'#10'X = 1/V';
  FNm:  st:='Y = ln (I/V)'#10'X = 1/V^0.5';
  Ab:   st:='Y = ln (I/V)'#10'X = 1/V';
  Abm:  st:='Y = ln (I/V^0.5)'#10'X = 1/V^0.5';
  FP:   st:='Y = ln (I/V)'#10'X = V^0.5';
  FPm:  st:='Y = ln (I/V^0.5)'#10'X = V^0.25';
  Lef:  st:='X - arbitrary voltage Va'#10+
            'Y = -C/B, where C and B are the coefficienfs of'#10+
            'function (V-Va*ln(I)) approximation by equation A+B*I+C*ln(I)';
  Ka1:  st:='Y = ( I - I0 )^(-1)  int (I dV)'#10'X = ( I + I0 ) / 2';
  Ka2:  st:='Y = ln( I / I0 ) / ( I - I0 )'#10'X = ( V - V0 ) / ( I - I0 )';
  Gr1:  st:='Y = V'#10'X = I';
  Gr2:  st:='Y = (V/2) - (kT/e) ln [I/(S Ar T^2)]'#10'X = I ';
  Chu:  st:='C ( I )  =  d V / d ( ln I )';
  Ci:   st:='X - arbitrary voltage Va'#10'Y = I0, minimum of function (V-Va*ln(I))';
  Wer:  st:='Y = (dI/dV) / I'#10'X = dI/dV';
  FoRs: st:='V replaced by (V - I Rs)';
  Ide:  st:='n = d ( V ) / d ( ln I ) (k T)^(-1)';
  E2F,E2R: st:='Y = I / [ 1 - exp(-q (V - I Rs) / kT]'#10'X = (V - I Rs)';
  Hf:   st:='H(I) = V-n (kT/e) ln[I/(S Ar T^2)] = I Rs + n Фb';
  Nor:  st:='F(V) = (V/gamma) - (kT/e) ln [I/(S Ar T^2)]';
  FV:   st:='F(V) = V - Va * ln( I )';
  FI:   st:='F(I) = V - Va * ln( I )';
  MAl:  st:='Y = d(lnI)/d(lnV)'#10'X = V';
  MId:  st:='Y = q V (Alpha - 1) [1 + Betta / (Alpha - 1)] / k T Alpha^2'#10'X = V';
  MRs:  st:='Y = V (1- Betta) / I Alpha^2'#10'X = V';
  MBe:  st:='Y = d(ln Alpha)/d(ln V)'#10'X = V';
  Nssf: st:='Nss = ep ep0 ( n - 1 ) / ( d e )';
  Ditf: st:='Dit=ep ep0 /d * (q^-2) * d(Vcal-Vexp)/dVs';
  else  st:='some error';
end;
MessageDlg(st, mtInformation,[mbOk],0);
end;

procedure TForm1.RBAveSelectClick(Sender: TObject);
var i:integer;
begin
if RBAveSelect.Checked then
 begin
   ButGLLoad.Visible:=False;
   ButGLRes.Visible:=False;
   CBoxGLShow.Visible:=False;
   CBoxGLShow.Checked:=False;
//   CBoxGLShow.Enabled:=False;

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
//   GroupBox36.Enabled:=True;
//   ButLGAdd.Enabled:=True;
//   SetLength(GausLinesCur,0);
//   SetLength(GausLines,0);
 end
                       else
 begin
   ButGLLoad.Visible:=True;
   ButGLRes.Visible:=True;
   CBoxGLShow.Visible:=True;
//   CBoxGLShow.Enabled:=True;

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
//   RBPointClick(Self);
//   SEGauss.MaxValue:=0;
   SEGauss.Value:=0;
//   CBoxGLShow.Checked:=False;

//   SetLength(GausLinesCur,0);
//   SetLength(GausLines,0);

 end

end;

procedure TForm1.RBLineClick(Sender: TObject);
begin
 Series1.Active:=False;
 Series2.Active:=True;
end;

//procedure TForm1.RBnSiClick(Sender: TObject);
//begin
//DiodParam(Form1,(Sender as TComponent).Tag,AA,eps);
//end;

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

procedure TForm1.SButFitClick(Sender: TObject);
//var
//    i:integer;
//    F:TFitFunction;
begin
 if SButFit.Down then
  begin

  if   SButFit.Caption='None' then Exit;
  FunCreate(SButFit.Caption,Fit);

  if (SButFit.Caption='Linear')or
   (SButFit.Caption='Quadratic') then
       Fit.FittingGraphFile(VaxGraph,EvolParam,Series4,XLogCheck.Checked,YLogCheck.Checked)
                                 else
       Fit.FittingGraphFile(VaxGraph,EvolParam,Series4);
//       Fit.FittingGraphFile(XLogCheck.Checked,YLogCheck.Checked,VaxGraph,EvolParam,Series4)
//                                 else
//       Fit.FittingGraphFile(VaxGraph,EvolParam,Series4);

   if EvolParam[0]=ErResult then Exit;
   Series4.Active:=True;
   if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
   if ((SButFit.Caption<>'Smoothing')and
       (SButFit.Caption<>'Median filtr')and
       (SButFit.Caption<>'Derivative'))
       then
        begin
         MemoAppr.Lines.Add('');
         MemoAppr.Lines.Add(VaxFile.name);
         MemoAppr.Lines.Add(SButFit.Caption);
        end;

   Fit.DataToStrings(EvolParam,MemoAppr.Lines);
//   for I := 0 to Fit.Ns-1 do
//               MemoAppr.Lines.Add(Fit.Xname[i]+'='+
//                        FloatToStrF(EvolParam[i],ffExponent,4,3));
//   for I := 0 to High(Fit.DodX) do
//               MemoAppr.Lines.Add(Fit.DodXname[i]+'='+
//                        FloatToStrF(Fit.DodX[i],ffExponent,4,3));
  Fit.Free;
  end  //if SButFit.Down then
   else Series4.Active:=False;
end;

procedure TForm1.SEGaussChange(Sender: TObject);
var i:integer;
begin

// showmessage(inttostr(SEGauss.Value));
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

procedure TForm1.SpButLimitClick(Sender: TObject);
begin
MarkerHide(Form1);
CBMarker.Checked:=False;

 if SpButLimit.Down then
    begin
      IVchar(VaxGraph,VaxTempLim);
      LimitFun(VaxTempLim, VaxFile, VaxGraph, GrLim);
      if VaxGraph^.n=0 then
                begin
                  IVchar(VaxTempLim,VaxGraph);
                  SpButLimit.Down:=False;
                  Exit;
                end;
    end
                    else  IVchar(VaxTempLim,VaxGraph);

DataToGraph(Series1,Series2,Graph,Graph.Title.Text.Strings[0],VaxGraph);
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
var temp:PVector;
begin
ClearGraphLog(Form1);

if XLogCheck.Checked then
  begin
   new(temp);
   LogX(VaxGraph,temp);
   if temp^.n=0 then
                begin
                 XLogCheck.Checked:=False;
                 MessageDlg('No points on the graph have positive abscissa',
                            mtError, [mbOK], 0);
                 Exit;
                end;
   IVChar(temp,VaxGraph);
   DataToGraph(Series1,Series2,Graph,Graph.Title.Text.Strings[0],VaxGraph);
   Graph.BottomAxis.Logarithmic:=True;
   dispose(temp);
  end;

if not(XLogCheck.Checked) then
  begin
   if YLogCheck.Checked then LogY(VaxTemp,VaxGraph);
   if not(YLogCheck.Checked) then IVChar(VaxTemp,VaxGraph);
   DataToGraph(Series1,Series2,Graph,Graph.Title.Text.Strings[0],VaxGraph);
   Graph.BottomAxis.Logarithmic:=False;
  end;
end;

procedure TForm1.YLogCheckClick(Sender: TObject);
var temp:PVector;
begin
ClearGraphLog(Form1);

if YLogCheck.Checked then
  begin
   new(temp);
   LogY(VaxGraph,temp);
   if temp^.n=0 then
                begin
                 YLogCheck.Checked:=False;
                 MessageDlg('Any points on the graph have non-positive ordinate',
                            mtError, [mbOK], 0);
                 Exit;
                end;
   IVChar(temp,VaxGraph);
   DataToGraph(Series1,Series2,Graph,Graph.Title.Text.Strings[0],VaxGraph);
   Graph.LeftAxis.Logarithmic:=True;
   dispose(temp);
  end;

if not(YLogCheck.Checked) then
  begin
   if XLogCheck.Checked then LogX(VaxTemp,VaxGraph);
   if not(XLogCheck.Checked) then IVChar(VaxTemp,VaxGraph);
   DataToGraph(Series1,Series2,Graph,Graph.Title.Text.Strings[0],VaxGraph);
   Graph.LeftAxis.Logarithmic:=False;
  end;
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
st:=VaxGraph^.name;
delete(st,LastDelimiter('.',VaxGraph^.name),4);
SGMarker.Cells[1,SGMarker.RowCount-4]:=st;
SGMarker.Cells[2,SGMarker.RowCount-4]:=
 FloatToStrF(VaxFile^.X[TrackBarMar.Position+VaxGraph^.N_begin],ffGeneral,4,3);
SGMarker.Cells[3,SGMarker.RowCount-4]:=
 FloatToStrF(VaxFile^.Y[TrackBarMar.Position+VaxGraph^.N_begin],ffExponent,3,2);
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
      then  GraphAverage(GausLines,0.002,SEGauss.Value,-0.002);
  if(Sender is TButton)and((Sender as TButton).Caption='>')
      then  GraphAverage(GausLines,0.002,SEGauss.Value,0.002);
  GaussLinesToGraph(True);
  GraphToVector(GausLines[0],VaxFile);
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
var I:integer;
    filename:string;
begin
 if MessageDlg('Are you sure?'#10#13'The selected data removing is irreversible!',
                 mtWarning,mbOkCancel,0)=mrOK
  then
   begin
   for i := SelectedRow-1 to High(VaxFile^.x)-1 do
      begin
        VaxFile^.X[i]:=VaxFile^.X[i+1];
        VaxFile^.Y[i]:=VaxFile^.Y[i+1];
      end;
   VaxFile^.n:=VaxFile^.n-1;
   SetLength(VaxFile^.X, VaxFile^.n);
   SetLength(VaxFile^.Y, VaxFile^.n);
   ChDir(Directory);
   CurDirectory:=Directory;
   ChooseDirect(Form1);
   filename:=VaxFile^.name;
   i:=FileAge(filename);
   Write_File(filename, VaxFile);
   if i>-1 then FileSetDate(filename,i);
   Read_File(filename,VaxFile);
   GraphShow(Form1);
   end;
end;

procedure TForm1.ButFitOptionClick(Sender: TObject);
var //F:TFitFunction;
    str:string;
begin
str:='None';
if (Sender is TButton)and((Sender as TButton).Name='ButFitOption')
     then  str:=SButFit.Caption;
if (Sender is TButton)and((Sender as TButton).Name='ButLDFitOption')
     then  str:=LabIsc.Caption;
if (Sender is TButton)and((Sender as TButton).Name='ButDateOption')
     then  str:=LDateFun.Caption;

FunCreate(str,Fit);
if  not(Assigned(Fit)) then Exit;

Fit.SetValueGR;
Fit.Free;
end;

procedure TForm1.ButFitSelectClick(Sender: TObject);
var str:string;
begin
 if FormSF.ShowModal=mrOk then
  begin
   str:=FormSF.CB.Items[FormSF.CB.ItemIndex];
   if (Sender is TButton)and((Sender as TButton).Name='ButFitSelect')
     then
       begin
       SButFit.Caption:=str;
       ApproxHide(Form1);
       end;
   if (Sender is TButton)and((Sender as TButton).Name='ButDateSelect')
     then
       begin
       LDateFun.Caption:=str;
       CBDateFun.Checked:=False;
       end;

//    if ((str='None')or
////           (str='Linear')or
////           (str='Quadratic')or
////           (str='Exponent')or
////           (str='Median filtr')or
////           (str='Derivative')or
////           (str='Smoothing')or
////           (str='Gromov / Lee')or
////           (str='Ivanov'))
//           then
//            begin
             if (Sender is TButton)and((Sender as TButton).Name='ButFitSelect')
               then ButFitOption.Enabled:=not(str='None');
            if (Sender is TButton)and((Sender as TButton).Name='ButDateSelect')
               then ButDateOption.Enabled:=not(str='None');
//            end
//
//           else
//            begin
//             if (Sender is TButton)and((Sender as TButton).Name='ButFitSelect')
//               then ButFitOption.Enabled:=True;
//            if (Sender is TButton)and((Sender as TButton).Name='ButDateSelect')
//               then ButDateOption.Enabled:=True;
//            end
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
      Write_File(SaveDialog1.FileName, VaxFile);
 end  // if RBAveSelect.Checked then
                       else  // if RBAveSelect.Checked
 begin
 SaveDialog1.FileName:=copy(VaxFile^.name,1,length(VaxFile^.name)-4)+'gl.dat';
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
//   Showmessage(inttostr(SEGauss.MaxValue));

   GaussLinesToGrid;
 end; // else  RBAveSelect.Checked
end;

procedure TForm1.ButGLAutoClick(Sender: TObject);
var tempVector:PVector;
    i:byte;
    Fit:TFitFunctionAAA;
begin
 try
  new(tempVector);
 except
  Exit;
 end;

 try
 GraphToVector((Graph.Series[1] as TLineSeries),tempVector);
 except
  dispose(tempVector);
  Exit;
 end;



 Fit:=TNGausian.Create(SEGauss.MaxValue);
 Fit.Fitting(tempVector,EvolParam);

 for I := 1 to SEGauss.MaxValue do
  begin
   GausLinesCur[i].A:=EvolParam[3*i-3];
   GausLinesCur[i].B:=EvolParam[3*i-2];
   GausLinesCur[i].C:=EvolParam[3*i-1];
  end;

 Fit.Free;
 dispose(tempVector);
 ButGLResClick(Sender);
 SEGaussChange(Sender);
// SEGauss.Value:=SEGauss.maxValue;
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
  GraphAverage(GausLines);
  GraphToVector(GausLines[0],VaxFile);
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
temp:=VaxFile^.T;
st:=FloatToStrF(temp,ffGeneral,4,1);
stHint:='Input Temperature';
st:=InputBox('Temperature',stHint,st);
StrToNumber(st, temp, temp2);
VaxFile^.T:=temp2;
if VaxFile^.T<=0 then
   begin
    VaxFile^.T:=temp;
    MessageDlg('Thermodynamic temperature must be positive', mtError,[mbOk],0);
   end;
GraphShow(Form1);
end;

procedure TForm1.ButLDFitSelectClick(Sender: TObject);
begin
 if FormSF.ShowModal=mrOk then
    if (FormSF.CB.Items[FormSF.CB.ItemIndex]=FuncName[10])or
       (FormSF.CB.Items[FormSF.CB.ItemIndex]=FuncName[11])or
       (FormSF.CB.Items[FormSF.CB.ItemIndex]=FuncName[12])or
       (FormSF.CB.Items[FormSF.CB.ItemIndex]=FuncName[13])or
       (FormSF.CB.Items[FormSF.CB.ItemIndex]=FuncName[14])or
       (FormSF.CB.Items[FormSF.CB.ItemIndex]=FuncName[9])or
       (FormSF.CB.Items[FormSF.CB.ItemIndex]=FuncName[19])or
       (FormSF.CB.Items[FormSF.CB.ItemIndex]=FuncName[20])
        then LabIsc.Caption:=FormSF.CB.Items[FormSF.CB.ItemIndex];
 CBoxDLBuildClick(Sender);
end;

procedure TForm1.ButRAClick(Sender: TObject);
var st,stHint:string;
    temp:double;
begin
temp:=RA;
st:=FloatToStrF(RA,ffGeneral,3,2);
stHint:='Input parameter A for Rs=A+B*T+C*T^2';
st:=InputBox('Rs parameters',stHint,st);
StrToNumber(st, temp, RA);
LabRA.Caption:=FloatToStrF(RA,ffGeneral,3,2);
end;

procedure TForm1.ButRBClick(Sender: TObject);
var st,stHint:string;
    temp:double;
begin
temp:=RB;
st:=FloatToStrF(RB,ffExponent,3,2);
stHint:='Input parameter B for Rs=A+B*T+C*T^2';
st:=InputBox('Rs parameters',stHint,st);
StrToNumber(st, temp, RB);
LabRB.Caption:=FloatToStrF(RB,ffExponent,3,2);
end;

procedure TForm1.ButRCClick(Sender: TObject);
var st,stHint:string;
    temp:double;
begin
temp:=RC;
st:=FloatToStrF(RC,ffExponent,3,2);
stHint:='Input parameter C for Rs=A+B*T+C*T^2';
st:=InputBox('Rs parameters',stHint,st);
StrToNumber(st, temp, RC);
LabRC.Caption:=FloatToStrF(RC,ffExponent,3,2);
end;

procedure TForm1.ButtonVaClick(Sender: TObject);
var st, stHint:string;
begin
st:=FloatToStrF(Va,ffGeneral,3,2);

stHint:='Enter voltage Va '+Chr(13)+
       'for function F(V) and F(I) building' +Chr(13);

st:=InputBox('Input Va voltage',stHint,st);
StrToNumber(st, 0.05, Va);
LabelVa.Caption:='Va = '+FloatToStrF(Va,ffGeneral,3,2)+' V';
if RadioButtonF_V.Checked then
                 RadioButtonM_VClick(RadioButtonF_V);
if RadioButtonF_I.Checked then
                 RadioButtonM_VClick(RadioButtonF_I);
end;


procedure TForm1.ButSaveDLClick(Sender: TObject);
var
    aprr:Pvector;
begin
SaveDialog1.FileName:=copy(VaxFile^.name,1,length(VaxFile^.name)-4)+'dl.dat';
   if SaveDialog1.Execute()
     then
       begin
       Write_File_Series(SaveDialog1.FileName,Series1);
       end;

new(aprr);
Splain3Vec(VaxGraph,0.05,0.002,aprr);
if aprr^.n>0 then Write_File(copy(SaveDialog1.FileName,1,length(SaveDialog1.FileName)-4)+'ap.dat',aprr);
dispose(aprr);
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
         I:=Full_IV(V,n*Kb*T,Rs,I0,1e13,0);
         if (I>=1e-10) then
           begin
             dat.Add(FloatToStrF(RandG(V,sigV),ffExponent,4,0)+' '+
                  FloatToStrF(RandG(I,sigI*I),ffExponent,4,0));
           end;
         if I>Ilim then Break;
     until false;
     dat.SaveToFile(CurDirectory+'\'+name);
     comment.Add(name);
     comment.Add('T='+FloatToStrF(T,ffgeneral,4,1));
     comment.Add('');
    T:=T+10;
   end;
  comment.SaveToFile(CurDirectory+'\'+'comments');
  comment.Free;
  dat.Free;
end;


Procedure AccurSet(SigImax,SigVmax,stepI,stepV,Ilim:double);
var
    Fbstr,Rsstr,nstr:TStringList;
    RsmykLee,nmykLee,FbmykLee,
    RsmykGr,nmykGr,FbmykGr,
    RsmykLeeN,nmykLeeN,FbmykLeeN,
    RsmykGrN,nmykGrN,FbmykGrN
//    ,RsmykMABC,nmykMABC,FbmykMABC,
//    RsmykLSM,nmykLSM,FbmykLSM,
//    RsmykLam,nmykLam,FbmykLam
         :double;
    Vax:PVector;
    Nf,ip,k,Nsprob:integer;
    SigV,SigI:double;
    name:string;
    T,V,I,n,Rs,Fb,I0:double;
    bool:boolean;

begin
if not(SetCurrentDir(CurDirectory)) then
   begin
   MessageDlg('Current directory is not exist', mtError,[mbOk],0);
   Exit;
   end;

Fbstr:=TStringList.Create;
Rsstr:=TStringList.Create;
nstr:=TStringList.Create;
Fbstr.Add('SigV SigI logFbGr logFbLee FbGr FbLee');
Rsstr.Add('SigV SigI logRsGr logRsLee RsGr RsLee');
nstr.Add('SigV SigI lognGr lognLee nGr nLee');

//Fbstr.Add('SigV SigI logFbLee logFbGr logFbMABC logFbLSM logFbLam FbLee FbGr FbMABC FbLSM FbLam');
//Rsstr.Add('SigV SigI logRsLee logRsGr logRsMABC logRsLSM logRsLam RsLee RsGr RsMABC RsLSM RsLam');
//nstr.Add('SigV SigI lognLee lognGr lognMABC lognLSM lognLam nLee nGr nMABC nLSM nLam');


bool:=true;
Nsprob:=500;

SigV:=0;

repeat
 SigI:=0;
 repeat
    DecimalSeparator:='.';

//         RsmykLee:=0;
//         nmykLee:=0;
//         FbmykLee:=0;
//
//         RsmykGr:=0;
//         nmykGr:=0;
//         FbmykGr:=0;

         RsmykLeeN:=0;
         nmykLeeN:=0;
         FbmykLeeN:=0;

         RsmykGrN:=0;
         nmykGrN:=0;
         FbmykGrN:=0;

//         RsmykMABC:=0;
//         nmykMABC:=0;
//         FbmykMABC:=0;
//
//         RsmykLSM:=0;
//         nmykLSM:=0;
//         FbmykLSM:=0;
//
//         RsmykLam:=0;
//         nmykLam:=0;
//         FbmykLam:=0;



     if bool then
      begin
        SigV:=0.003;
        SigI:=0.035;
        bool:=false;
      end;


         Nf:=0;

        T:=130;
        while T<335 do
         begin
           n:=n_T(T);
           Rs:=Rs_T(T);
           Fb:=Fb_T(T);
           I0:=3.14e-6*1.12e6*T*T*exp(-Fb/Kb/T);

           RsmykLee:=0;
           nmykLee:=0;
           FbmykLee:=0;

           RsmykGr:=0;
           nmykGr:=0;
           FbmykGr:=0;

         k:=1;
         repeat


          Randomize;
           new(Vax);
           Vax^.T:=T;
           ip:=0;
           Vax^.name:=FloatToStrF(SigV,ffgeneral,3,2)+' '+
                      FloatToStrF(SigI,ffgeneral,3,2)+' '+
                      inttostr(round(T));
//           Form1.Button1.Caption:=Vax^.name;
           Vax^.N_begin:=0;

           V:=0;
           repeat
               V:=V+0.01;
               I:=Full_IV(V,n*Kb*T,Rs,I0,1e13,0);
               if (I>=1e-10) then
                 begin
                   inc(ip);
                   SetLenVector(Vax,ip);
                   name:=FloatToStrF(RandG(V,SigV),ffExponent,4,0);
                   Vax^.X[High(Vax^.X)]:=strtofloat(name);
                   name:=FloatToStrF(RandG(I,SigI*I),ffExponent,4,0);
                   Vax^.Y[High(Vax^.X)]:=strtofloat(name);
                 end;
                if I>Ilim then Break;
           until false;

     LeeKalk (Vax,D[diLee],Diod,Rss,nn,Fbb,I00);
         if (Rss=ErResult)or(Fbb=ErResult) then
            showmessage('SigV='+floattostr(SigV)+#10+#13+
                        'SigI='+floattostr(SigI))
                    else
                    begin
           RsmykLee:=RsmykLee+abs((Rss-Rs)/Rs);
           nmykLee:=nmykLee+abs((nn-n)/n);
           FbmykLee:=FbmykLee+abs((Fbb-Fb)/Fb);

//         RsmykLee:=RsmykLee+ln(abs((Rss-Rs)/Rs));
//         FbmykLee:=FbmykLee+ln(abs((Fbb-Fb)/Fb));
//         nmykLee:=nmykLee+ln(abs((nn-n)/n));
//         inc(Nf);
                    end;


     Gr1Kalk (Vax,D[diGr1],Diod,Rss,nn,Fbb,I00);
         if (Rss=ErResult)or(Fbb=ErResult) then
            showmessage('SigV='+floattostr(SigV)+#10+#13+
                        'SigI='+floattostr(SigI))
                    else
                    begin
           RsmykGr:=RsmykGr+abs((Rss-Rs)/Rs);
           nmykGr:=nmykGr+abs((nn-n)/n);
           FbmykGr:=FbmykGr+abs((Fbb-Fb)/Fb);

//         RsmykGr:=RsmykGr+ln(abs((Rss-Rs)/Rs));
//         FbmykGr:=FbmykGr+ln(abs((Fbb-Fb)/Fb));
//         nmykGr:=nmykGr+ln(abs((nn-n)/n));
                    end;

//       Fit:=TDiod.Create;
//       Fit.FittingDiapazon(Vax,EvolParam,D[diDE]);
//         if EvolParam[1]=ErResult then
//            showmessage('SigV='+floattostr(SigV)+#10+#13+
//                        'SigI='+floattostr(SigI))
//                    else
//                    begin
//         RsmykMABC:=RsmykMABC+ln(abs((EvolParam[1]-Rs)/Rs));
//         nmykMABC:=nmykMABC+ln(abs((EvolParam[0]-n)/n));
//         FbmykMABC:=FbmykMABC+ln(abs((Fit.DodX[0]-Fb)/Fb));
//                    end;
//          Fit.Free;
//
//          Fit:=TDiodLSM.Create;
//          Fit.FittingDiapazon(Vax,EvolParam,D[diExp]);
//         if EvolParam[1]=ErResult then
//            showmessage('SigV='+floattostr(SigV)+#10+#13+
//                        'SigI='+floattostr(SigI))
//                    else
//                    begin
//         RsmykLSM:=RsmykLSM+ln(abs((EvolParam[1]-Rs)/Rs));
//         nmykLSM:=nmykLSM+ln(abs((EvolParam[0]-n)/n));
//         FbmykLSM:=FbmykLSM+ln(abs((Fit.DodX[0]-Fb)/Fb));
//                    end;
//          Fit.Free;
//
//
//          Fit:=TDiodLam.Create;
//          Fit.FittingDiapazon(Vax,EvolParam,D[diLam]);
//         if EvolParam[1]=ErResult then
//            showmessage('SigV='+floattostr(SigV)+#10+#13+
//                        'SigI='+floattostr(SigI))
//                    else
//                    begin
//         RsmykLam:=RsmykLam+ln(abs((EvolParam[1]-Rs)/Rs));
//         nmykLam:=nmykLam+ln(abs((EvolParam[0]-n)/n));
//         FbmykLam:=FbmykLam+ln(abs((Fit.DodX[0]-Fb)/Fb));
//                    end;
//          Fit.Free;
            dispose(Vax);
            inc(k);
           until(k>Nsprob);

           RsmykLee:=RsmykLee/Nsprob;
           nmykLee:=nmykLee/Nsprob;
           FbmykLee:=FbmykLee/Nsprob;
           RsmykGr:=RsmykGr/Nsprob;
           nmykGr:=nmykGr/Nsprob;
           FbmykGr:=FbmykGr/Nsprob;

         RsmykLeeN:=RsmykLeeN+ln(RsmykLee);
         nmykLeeN:=nmykLeeN+ln(nmykLee);
         FbmykLeeN:=FbmykLeeN+ln(FbmykLee);

         RsmykGrN:=RsmykGrN+ln(RsmykGr);
         nmykGrN:=nmykGrN+ln(nmykGr);
         FbmykGrN:=FbmykGrN+ln(FbmykGr);

          inc(Nf);
          T:=T+10;
//          Rsstr.SaveToFile('temp.dat');
         end;

         RsmykLeeN:=exp(RsmykLeeN/Nf);
         nmykLeeN:=exp(nmykLeeN/Nf);
         FbmykLeeN:=exp(FbmykLeeN/Nf);

         RsmykGrN:=exp(RsmykGrN/Nf);
         nmykGrN:=exp(nmykGrN/Nf);
         FbmykGrN:=exp(FbmykGrN/Nf);


            Fbstr.Add(FloatToStrF(SigV,ffExponent,4,3)
                      +' '+FloatToStrF(SigI,ffExponent,4,3)
                      +' '+FloatToStrF(log10(FbmykGrN),ffExponent,4,3)
                      +' '+FloatToStrF(log10(FbmykLeeN),ffExponent,4,3)
                      +' '+FloatToStrF(FbmykGrN,ffExponent,5,4)
                      +' '+FloatToStrF(FbmykLeeN,ffExponent,5,4)
                      );

            Rsstr.Add(FloatToStrF(SigV,ffExponent,4,3)
                      +' '+FloatToStrF(SigI,ffExponent,4,3)
                      +' '+FloatToStrF(log10(RsmykGrN),ffExponent,4,3)
                      +' '+FloatToStrF(log10(RsmykLeeN),ffExponent,4,3)
                      +' '+FloatToStrF(RsmykGrN,ffExponent,5,4)
                      +' '+FloatToStrF(RsmykLeeN,ffExponent,5,4)
                      );

            nstr.Add(FloatToStrF(SigV,ffExponent,4,3)
                      +' '+FloatToStrF(SigI,ffExponent,4,3)
                      +' '+FloatToStrF(log10(nmykGrN),ffExponent,4,3)
                      +' '+FloatToStrF(log10(nmykLeeN),ffExponent,4,3)
                      +' '+FloatToStrF(nmykGrN,ffExponent,5,4)
                      +' '+FloatToStrF(nmykLeeN,ffExponent,5,4)
                      );


  Rsstr.SaveToFile('tempRs.dat');
  Fbstr.SaveToFile('tempFb.dat');
  nstr.SaveToFile('tempnd.dat');

 SigI:=SigI+StepI;
 until(SigI>SigIMax);


 SigV:=SigV+StepV;
until(SigV>SigVMax);

Fbstr.SaveToFile('ErrFbsh.dat');
Rsstr.SaveToFile('ErrRssh.dat');
nstr.SaveToFile('Errndsh.dat');
Fbstr.Free;
Rsstr.Free;
nstr.Free;
showmessage('УРЯЯ!');
end;


Procedure TemperAve(Ilim,sigV,sigI:double);
var
    Rsstr:TStringList;
    Rsmyk,nmyk,Fbmyk,nmyEk,FbmyEk,FbbE,nnE:double;
    Vax:PVector;
    Nf,ip,k,Nsprob:integer;
    name,nnn:string;
    T:integer;
    V,I,n,Rs,Fb,I0:double;
    RsAv,delRsAv,FbAv,delFbAv,nAv,delnAv,FbEAv,delFbEAv,nEAv,delnEAv:double;

begin
if not(SetCurrentDir(CurDirectory)) then
   begin
   MessageDlg('Current directory is not exist', mtError,[mbOk],0);
   Exit;
   end;

nnn:='Bohl';
Nsprob:=1000;
Rsstr:=TStringList.Create;



Rsstr.Add('T Rs Rs'+nnn+' delRs delRs2 Fb Fb'+nnn+' delFb delFb2 n n'+nnn+' deln deln2 ');
//Rsstr.Add('T Rs Rs'+nnn+' delRs delRs2 Fb Fb'+nnn+' delFb delFb2 Fb'+nnn+
//            'Exp delFbE delFb2E n n'+nnn+' deln deln2 n'+nnn+'Exp delnE deln2E');





         Rsmyk:=0;
         nmyk:=0;
         Fbmyk:=0;
//         nmyEk:=0;
//         FbmyEk:=0;
         Nf:=0;


        T:=130;
        while T<335 do
         begin

         n:=n_T(T);
         Rs:=Rs_T(T);
         Fb:=Fb_T(T);
         I0:=3.14e-6*1.12e6*T*T*exp(-Fb/Kb/T);

         RsAv:=0;
         delRsAv:=0;
         FbAv:=0;
         delFbAv:=0;
         nAv:=0;
         delnAv:=0;
//         FbEAv:=0;
//         delFbEAv:=0;
//         nEAv:=0;
//         delnEAv:=0;

         k:=1;
         repeat
           Randomize;

           new(Vax);
           Vax^.T:=T;
           ip:=0;
           Vax^.name:=inttostr(k)+' '+
                      inttostr(T);
//           Form1.Button1.Caption:=Vax^.name;
           Vax^.N_begin:=0;
           V:=0;

           repeat
               V:=V+0.01;
               I:=Full_IV(V,n*Kb*T,Rs,I0,1e13,0);
               if (I>=1e-10) then
                 begin
                   inc(ip);
                   SetLenVector(Vax,ip);
                   name:=FloatToStrF(RandG(V,SigV),ffExponent,4,0);
                   Vax^.X[High(Vax^.X)]:=strtofloat(name);
                   name:=FloatToStrF(RandG(I,SigI*I),ffExponent,4,0);
                   Vax^.Y[High(Vax^.X)]:=strtofloat(name);
                 end;
                if I>Ilim then Break;
           until false;
//          Fit:=TDiod.Create;
//          Fit.FittingDiapazon(Vax,EvolParam,D[diDE]);

//          Fit:=TDiodLSM.Create;
//          Fit.FittingDiapazon(Vax,EvolParam,D[diExp]);

//          Fit:=TDiodLam.Create;
//          Fit.FittingDiapazon(Vax,EvolParam,D[diLam]);
      try


//     Gr1Kalk (Vax,D[diGr1],AA,Sk,Rss,nn,Fbb,I00);
//     LeeKalk (Vax,D[diLee],AA,Sk,Rss,nn,Fbb,I00);
//     MikhKalk (Vax,D[diMikh],AA,Sk,Rss,nn,I00,Fbb);

//     ChungKalk(Vax,D[diChung],Rss,nn);
//     HFunKalk(Vax,D[diHfunc],AA,Sk,nn,Rss,Fbb);
//     ChungKalk(Vax,D[diChung],Rss,nn);

//     Kam1Kalk(Vax,D[diKam1],Rss,nn);
//     Kam2Kalk(Vax,D[diKam2],Rss,nn);
//     CibilsKalk(Vax,D[diCib],Rss,nn);
//     WernerKalk(Vax,D[diWer],Rss,nn);
//
//     ExKalk_nconst(1,Vax,D[diEx],Rss,AA,Sk,nn,I00,Fbb);
//     ExKalk(1,Vax,D[diEx],Rss,AA,Sk,nnE,I00,FbbE);

       BohlinKalk(Vax,D[diNord],Diod,1.6,3.5,Rss,nn,Fbb,I00);
//      NordKalk(Vax,D[diNord],AA,Sk,1.8,n_T(Vax^.T),Rss,Fbb);
//       nn:=1;
        except
        Continue;
      end;

{}
         if (abs((Rss-Rs)/Rs)>10)or
             (Rss=ErResult)or(Fbb=ErResult)or(nn=ErResult)or
             (abs((nn-n)/n)>10)or
             (abs((Fbb-Fb)/Fb)>10)or
             (Rss<0)or
             (nn<0)or
             (Fbb<0)
                      then  Continue;

             RsAv:=RsAv+Rss;
             delRsAv:=delRsAv+abs((Rss-Rs)/Rs);
             FbAv:=FbAv+Fbb;
             delFbAv:=delFbAv+abs((Fbb-Fb)/Fb);
             nAv:=nAv+nn;
             delnAv:=delnAv+abs((nn-n)/n);

//             FbEAv:=FbEAv+FbbE;
//             delFbEAv:=delFbEAv+abs((FbbE-Fb)/Fb);
//             nEAv:=nEAv+nnE;
//             delnEAv:=delnEAv+abs((nnE-n)/n);


{}
{
         if (abs((EvolParam[1]-Rs)/Rs)>10)or
             (EvolParam[1]=ErResult)or(Fit.DodX[0]=ErResult)or(EvolParam[0]=ErResult)or
             (abs((EvolParam[0]-n)/n)>10)or
             (abs((Fit.DodX[0]-Fb)/Fb)>10)or
             (EvolParam[1]<0)or
             (EvolParam[0]<0)or
             (Fit.DodX[0]<0)
                      then  Continue;

             RsAv:=RsAv+EvolParam[1];
             delRsAv:=delRsAv+abs((EvolParam[1]-Rs)/Rs);
             FbAv:=FbAv+Fit.DodX[0];
             delFbAv:=delFbAv+abs((Fit.DodX[0]-Fb)/Fb);
             nAv:=nAv+EvolParam[0];
             delnAv:=delnAv+abs((EvolParam[0]-n)/n);
             Fit.Free;
 {}
            dispose(Vax);
            inc(k);
           until(k>Nsprob);
             RsAv:=RsAv/Nsprob;
             delRsAv:=delRsAv/Nsprob;
             FbAv:=FbAv/Nsprob;
             delFbAv:=delFbAv/Nsprob;
             nAv:=nAv/Nsprob;
             delnAv:=delnAv/Nsprob;

//             FbEAv:=FbEAv/Nsprob;
//             delFbEAv:=delFbEAv/Nsprob;
//             nEAv:=nEAv/Nsprob;
//             delnEAv:=delnEAv/Nsprob;


 Rsstr.Add(inttostr(T)+' '+
             FloatToStrF(Rs_T(T),ffExponent,5,4)+' '+
             FloatToStrF(RsAv,ffExponent,5,4)+' '+
             FloatToStrF(delRsAv,ffExponent,5,4)+' '+
             FloatToStrF(sqr(delRsAv),ffExponent,5,4)+' '+
             FloatToStrF(Fb_T(T),ffExponent,5,4)+' '+
             FloatToStrF(FbAv,ffExponent,5,4)+' '+
             FloatToStrF(delFbAv,ffExponent,5,4)+' '+
             FloatToStrF(sqr(delFbAv),ffExponent,5,4)+' '+

//             FloatToStrF(FbEAv,ffExponent,5,4)+' '+
//             FloatToStrF(delFbEAv,ffExponent,5,4)+' '+
//             FloatToStrF(sqr(delFbEAv),ffExponent,5,4)+' '+

             FloatToStrF(n_T(T),ffExponent,5,4)+' '+
             FloatToStrF(nAv,ffExponent,5,4)+' '+
             FloatToStrF(delnAv,ffExponent,5,4)+' '+
             FloatToStrF(sqr(delnAv),ffExponent,5,4)
//             +' '+FloatToStrF(nEAv,ffExponent,5,4)+' '+
//             FloatToStrF(delnEAv,ffExponent,5,4)+' '+
//             FloatToStrF(sqr(delnEAv),ffExponent,5,4)
             );

         Rsmyk:=Rsmyk+ln(delRsAv);
         Fbmyk:=Fbmyk+ln(delFbAv);
         nmyk:=nmyk+ln(delnAv);

//         FbmyEk:=FbmyEk+ln(delFbEAv);
//         nmyEk:=nmyEk+ln(abs(delnEAv));

         inc(Nf);


          T:=T+10;
          Rsstr.SaveToFile('temp.dat');
         end;

  Rsstr.SaveToFile(nnn+'_I'+
                   inttostr(round(sigI*1000))+
                   'V'+inttostr(round(sigV*10000))+
                  '.dat');

  Rsstr.Clear;

//{
  Rsstr.Add('Rs'+nnn+'   Fb'+nnn+' n'+nnn);
  Rsstr.Add(FloatToStrF(exp(Rsmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(Fbmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(nmyk/Nf),ffExponent,5,4)
      );
{ }
{  Rsstr.Add('Rs'+nnn+'   Fb'+nnn+'   FbE'+nnn+' n'+nnn+' nE'+nnn);
  Rsstr.Add(FloatToStrF(exp(Rsmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(Fbmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(FbmyEk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(nmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(nmyEk/Nf),ffExponent,5,4)
      );
 }
 Rsstr.SaveToFile(nnn+'_E_I'+
                   inttostr(round(sigI*1000))+
                   'V'+inttostr(round(sigV*10000))+
                  '.dat');
Rsstr.Free;
//showmessage('УРЯЯ!');
end;

Procedure TemperIdAve(Ilim:double; Md:char);
var
    Rsstr:TStringList;
    Rsmyk,nmyk,Fbmyk{,nmyEk,FbmyEk,FbbE,nnE}:double;
    Vax:PVector;
    Nf,ip,k,Nsprob:integer;
    name,nnn:string;
    T:integer;
    V,I,n,Rs,Fb,I0:double;
    RsAv,delRsAv,FbAv,delFbAv,nAv,delnAv{,FbEAv,delFbEAv,nEAv,delnEAv}:double;
    Fit:TFitFunctionAAA;
begin
if not(SetCurrentDir(CurDirectory)) then
   begin
   MessageDlg('Current directory is not exist', mtError,[mbOk],0);
   Exit;
   end;

nnn:='Lam';
Nsprob:=20;
Rsstr:=TStringList.Create;



Rsstr.Add('T Rs Rs'+nnn+' delRs delRs2 Fb Fb'+nnn+' delFb delFb2 n n'+nnn+' deln deln2 ');
//Rsstr.Add('T Rs Rs'+nnn+' delRs delRs2 Fb Fb'+nnn+' delFb delFb2 Fb'+nnn+
//            'Exp delFbE delFb2E n n'+nnn+' deln deln2 n'+nnn+'Exp delnE deln2E');


         Rsmyk:=0;
         nmyk:=0;
         Fbmyk:=0;
//         nmyEk:=0;
//         FbmyEk:=0;
         Nf:=0;


        T:=130;
        while T<335 do
         begin

         RsAv:=0;
         delRsAv:=0;
         FbAv:=0;
         delFbAv:=0;
         nAv:=0;
         delnAv:=0;
//         FbEAv:=0;
//         delFbEAv:=0;
//         nEAv:=0;
//         delnEAv:=0;
         k:=1;
         repeat
         Randomize;

         n:=RandG(n_T(T),0.002*n_T(T));
         Rs:=RandG(Rs_T(T),0.002*Rs_T(T));
         Fb:=RandG(Fb_T(T),0.002*Fb_T(T));
         I0:=3.14e-6*1.12e6*T*T*exp(-Fb/Kb/T);
         case Md of
            'n':n:=n*1.2;
            'R':Rs:=Rs*3;
            'F':begin
                Fb:=Fb-0.1;
                I0:=3.14e-6*1.12e6*T*T*exp(-Fb/Kb/T);
               end;
            'I':begin
                I0:=I0*10;
                Fb:=Kb*T*ln(3.14e-6*1.12e6*T*T/I0);
                end;
         end;

           new(Vax);
           Vax^.T:=T;
           ip:=0;
           Vax^.name:=inttostr(k)+' '+
                      inttostr(T);
           Form1.Button1.Caption:=Vax^.name;
           Vax^.N_begin:=0;
           V:=0;

           repeat
               V:=V+0.01;
               I:=Full_IV(V,n*Kb*T,Rs,I0,1e13,0);
               if (I>=1e-10) then
                 begin
                   inc(ip);
                   SetLenVector(Vax,ip);
                   name:=FloatToStrF(RandG(V,0),ffExponent,4,0);
                   Vax^.X[High(Vax^.X)]:=strtofloat(name);
                   name:=FloatToStrF(RandG(I,0),ffExponent,4,0);
                   Vax^.Y[High(Vax^.X)]:=strtofloat(name);
                 end;
                if I>Ilim then Break;
           until false;

//          Fit:=TDiod.Create;
//          Fit.FittingDiapazon(Vax,EvolParam,D[diDE]);

//          Fit:=TDiodLSM.Create;
//          Fit.FittingDiapazon(Vax,EvolParam,D[diExp]);

          Ft:=TDiodLam.Create;
          Fit.FittingDiapazon(Vax,EvolParam,D[diLam]);

//     Gr1Kalk (Vax,D[diGr1],AA,Sk,Rss,nn,Fbb,I00);
//     LeeKalk (Vax,D[diLee],AA,Sk,Rss,nn,Fbb,I00);
//     MikhKalk (Vax,D[diMikh],AA,Sk,Rss,nn,I00,Fbb);

//     ChungKalk(Vax,D[diChung],Rss,nn);
//     HFunKalk(Vax,D[diHfunc],AA,Sk,nn,Rss,Fbb);
//     ChungKalk(Vax,D[diChung],Rss,nn);

//     Kam1Kalk(Vax,D[diKam1],Rss,nn);
//     Kam2Kalk(Vax,D[diKam2],Rss,nn);
//     CibilsKalk(Vax,D[diCib],Rss,nn);
//     WernerKalk(Vax,D[diWer],Rss,nn);

//     ExKalk_nconst(1,Vax,D[diEx],Rss,AA,Sk,nn,I00,Fbb);
//     ExKalk(1,Vax,D[diEx],Rss,AA,Sk,nnE,I00,FbbE);

//       BohlinKalk(Vax,D[diNord],AA,Sk,1.6,3.5,Rss,nn,Fbb,I00);
//      NordKalk(Vax,D[diNord],AA,Sk,1.8,n,Rss,Fbb);
//       nn:=1;

{
         if (abs((Rss-Rs)/Rs)>10)or
             (Rss=ErResult)or(Fbb=ErResult)or(nn=ErResult)or
             (abs((nn-n)/n)>10)or
             (abs((Fbb-Fb)/Fb)>10)or
             (Rss<0)or
             (nn<0)or
             (Fbb<0)
                      then  Continue;

             RsAv:=RsAv+Rss;
             delRsAv:=delRsAv+abs((Rss-Rs)/Rs);
             FbAv:=FbAv+Fbb;
             delFbAv:=delFbAv+abs((Fbb-Fb)/Fb);
             nAv:=nAv+nn;
             delnAv:=delnAv+abs((nn-n)/n);

//             FbEAv:=FbEAv+FbbE;
//             delFbEAv:=delFbEAv+abs((FbbE-Fb)/Fb);
//             nEAv:=nEAv+nnE;
//             delnEAv:=delnEAv+abs((nnE-n)/n);


//}
{}
          if (abs((EvolParam[1]-Rs)/Rs)>10)or
             (EvolParam[1]=ErResult)or(Fit.DodX[0]=ErResult)or(EvolParam[0]=ErResult)or
             (abs((EvolParam[0]-n)/n)>10)or
             (abs((Fit.DodX[0]-Fb)/Fb)>10)or
             (EvolParam[1]<0)or
             (EvolParam[0]<0)or
             (Fit.DodX[0]<0)
                      then  Continue;

             RsAv:=RsAv+EvolParam[1];
             delRsAv:=delRsAv+abs((EvolParam[1]-Rs)/Rs);
             FbAv:=FbAv+Fit.DodX[0];
             delFbAv:=delFbAv+abs((Fit.DodX[0]-Fb)/Fb);
             nAv:=nAv+EvolParam[0];
             delnAv:=delnAv+abs((EvolParam[0]-n)/n);
             Fit.Free;
 {}
            dispose(Vax);
            inc(k);

           until(k>Nsprob);

             RsAv:=RsAv/Nsprob;
             delRsAv:=delRsAv/Nsprob;
             FbAv:=FbAv/Nsprob;
             delFbAv:=delFbAv/Nsprob;
             nAv:=nAv/Nsprob;
             delnAv:=delnAv/Nsprob;

//             FbEAv:=FbEAv/Nsprob;
//             delFbEAv:=delFbEAv/Nsprob;
//             nEAv:=nEAv/Nsprob;
//             delnEAv:=delnEAv/Nsprob;


 Rsstr.Add(inttostr(T)+' '+
             FloatToStrF(Rs_T(T),ffExponent,5,4)+' '+
             FloatToStrF(RsAv,ffExponent,5,4)+' '+
             FloatToStrF(delRsAv,ffExponent,5,4)+' '+
             FloatToStrF(sqr(delRsAv),ffExponent,5,4)+' '+
             FloatToStrF(Fb_T(T),ffExponent,5,4)+' '+
             FloatToStrF(FbAv,ffExponent,5,4)+' '+
             FloatToStrF(delFbAv,ffExponent,5,4)+' '+
             FloatToStrF(sqr(delFbAv),ffExponent,5,4)+' '+

//             FloatToStrF(FbEAv,ffExponent,5,4)+' '+
//             FloatToStrF(delFbEAv,ffExponent,5,4)+' '+
//             FloatToStrF(sqr(delFbEAv),ffExponent,5,4)+' '+

             FloatToStrF(n_T(T),ffExponent,5,4)+' '+
             FloatToStrF(nAv,ffExponent,5,4)+' '+
             FloatToStrF(delnAv,ffExponent,5,4)+' '+
             FloatToStrF(sqr(delnAv),ffExponent,5,4)

//             +' '+FloatToStrF(nEAv,ffExponent,5,4)+' '+
//             FloatToStrF(delnEAv,ffExponent,5,4)+' '+
//             FloatToStrF(sqr(delnEAv),ffExponent,5,4)

             );

         Rsmyk:=Rsmyk+ln(delRsAv);
         Fbmyk:=Fbmyk+ln(delFbAv);
         nmyk:=nmyk+ln(abs(delnAv));

//         FbmyEk:=FbmyEk+ln(delFbEAv);
//         nmyEk:=nmyEk+ln(abs(delnEAv));

         inc(Nf);

         Rsstr.SaveToFile('temp.dat');
          T:=T+10;
         end;

  Rsstr.SaveToFile(nnn+Md+'.dat');

  Rsstr.Clear;

{ }
  Rsstr.Add('Rs'+nnn+'   Fb'+nnn+' n'+nnn);
  Rsstr.Add(FloatToStrF(exp(Rsmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(Fbmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(nmyk/Nf),ffExponent,5,4)
      );
 {}
 {
  Rsstr.Add('Rs'+nnn+'   Fb'+nnn+'   FbE'+nnn+' n'+nnn+' nE'+nnn);
  Rsstr.Add(FloatToStrF(exp(Rsmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(Fbmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(FbmyEk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(nmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(nmyEk/Nf),ffExponent,5,4)
      );
 {}
 Rsstr.SaveToFile(nnn+'_E_'+Md+'.dat');
 Rsstr.Free;
// showmessage('УРЯЯ!');
end;



Procedure IdealRs(Ilim:double);
var
    Rsstr:TStringList;
    Rsmyk,nmyk,Fbmyk,nmyEk,FbmyEk,FbbE,nnE:double;
    Vax:PVector;
    Nf,ip,k,Nsprob,Nfall:integer;
    name,nnn:string;
    T,V,I,n,Rs,Fb,I0,nT,I0T,RsT,FbT:double;
    bool:boolean;
    delRsAv,delFbAv,delnAv,delFbEAv,delnEAv:double;
begin
if not(SetCurrentDir(CurDirectory)) then
   begin
   MessageDlg('Current directory is not exist', mtError,[mbOk],0);
   Exit;
   end;

Rsstr:=TStringList.Create;


//Rsstr.Add('Rs logI0 logdelFb logdeln logdelRs I0 delFb deln delRs');
Rsstr.Add('Rs logI0 logdelFb logdeln logdelFbE logdelnE logdelRs I0 delFb deln delFbE delnE delRs');

nnn:='CibLong';
Nsprob:=50;
bool:=False;

Rs:=1;
repeat
 I0:=1e-10;
 repeat
         Randomize;
         Rsmyk:=0;
         nmyk:=0;
         Fbmyk:=0;
         nmyEk:=0;
         FbmyEk:=0;
         Nf:=0;

     if bool then
      begin
        Rs:=29;
        I0:=1e-10;//*Power(10,1.0/2.0);
        bool:=false;
      end;

        T:=130;
        while T<335 do
         begin


         delRsAv:=0;
         delFbAv:=0;
         delnAv:=0;
         delFbEAv:=0;
         delnEAv:=0;
         Nfall:=0;

         k:=1;
         repeat
           Randomize;

         nT:=RandG(n_T(T),0.002*n_T(T));
         RsT:=RandG(Rs,0.002*Rs);
         I0T:=RandG(I0,0.002*I0);
         FbT:=Kb*T*ln(3.14e-6*1.12e6*T*T/I0T);

           new(Vax);
           Vax^.T:=T;
           ip:=0;
           Vax^.name:=FloatToStrF(Rs,ffgeneral,3,2)+' '+
                      FloatToStrF(log10(I0),ffgeneral,3,2)+' '+
                      inttostr(round(T));
//           Form1.Button1.Caption:=Vax^.name;
           Vax^.N_begin:=0;
           V:=0;
           repeat
               V:=V+0.01;
               I:=Full_IV(V,nT*Kb*T,RsT,I0T,1e13,0);
               if (I>=1e-10) then
                 begin
                   inc(ip);
                   SetLenVector(Vax,ip);
                   name:=FloatToStrF(RandG(V,0),ffExponent,4,0);
                   Vax^.X[High(Vax^.X)]:=strtofloat(name);
                   name:=FloatToStrF(RandG(I,0),ffExponent,4,0);
                   Vax^.Y[High(Vax^.X)]:=strtofloat(name);
                 end;
                if I>Ilim then Break;
           until false;
//          Fit:=TDiod.Create;
//          Fit.FittingDiapazon(Vax,EvolParam,D[diDE]);

//          Fit:=TDiodLSM.Create;
//          Fit.FittingDiapazon(Vax,EvolParam,D[diExp]);

//          Fit:=TDiodLam.Create;
//          Fit.FittingDiapazon(Vax,EvolParam,D[diLam]);

//     Gr1Kalk (Vax,D[diGr1],AA,Sk,Rss,nn,Fbb,I00);
//     LeeKalk (Vax,D[diLee],AA,Sk,Rss,nn,Fbb,I00);
//     MikhKalk (Vax,D[diMikh],AA,Sk,Rss,nn,I00,Fbb);

//     ChungKalk(Vax,D[diChung],Rss,nn);
//     HFunKalk(Vax,D[diHfunc],AA,Sk,nn,Rss,Fbb);
//     ChungKalk(Vax,D[diChung],Rss,nn);

//     Kam1Kalk(Vax,D[diKam1],Rss,nn);
//     Kam2Kalk(Vax,D[diKam2],Rss,nn);
     CibilsKalk(Vax,D[diCib],Rss,nn);
//     WernerKalk(Vax,D[diWer],Rss,nn);

     ExKalk_nconst(1,Vax,D[diEx],Diod,Rss,nn,I00,Fbb);
     ExKalk(1,Vax,D[diEx],Rss,Diod,nnE,I00,FbbE);

//       BohlinKalk(Vax,D[diNord],AA,Sk,1.6,3.5,Rss,nn,Fbb,I00);
//      NordKalk(Vax,D[diNord],AA,Sk,1.8,n_T(Vax^.T),Rss,Fbb);
//       nn:=1;



         if (Rss=ErResult)or(Fbb=ErResult) then
//         if EvolParam[1]=ErResult then
            inc(Nfall)
//            showmessage('Rs='+floattostr(Rs)+#10+#13+
//                        'I0='+floattostr(I0))
                    else
                    begin
             delRsAv:=delRsAv+abs((Rss-RsT)/RsT);
             delFbAv:=delFbAv+abs((Fbb-FbT)/FbT);
             delnAv:=delnAv+abs((nn-nT)/nT);
             delFbEAv:=delFbEAv+abs((FbbE-FbT)/FbT);
             delnEAv:=delnEAv+abs((nnE-nT)/nT);

//             delRsAv:=delRsAv+abs((EvolParam[1]-RsT)/RsT);
//             delFbAv:=delFbAv+abs((Fit.DodX[0]-FbT)/FbT);
//             delnAv:=delnAv+abs((EvolParam[0]-nT)/nT);


                    end;
//          Fit.Free;

            dispose(Vax);
            inc(k);
           until(k>Nsprob);

         if Nsprob>Nfall then
         begin

         Rsmyk:=Rsmyk+ln(delRsAv/(Nsprob-Nfall));
         Fbmyk:=Fbmyk+ln(delFbAv/(Nsprob-Nfall));
         nmyk:=nmyk+ln(delnAv/(Nsprob-Nfall));
         FbmyEk:=FbmyEk+ln(delFbEAv/(Nsprob-Nfall));
         nmyEk:=nmyEk+ln(delnEAv/(Nsprob-Nfall));
         inc(Nf);
         end;

          T:=T+10;
         end;

            Rsstr.Add(FloatToStrF(Rs,ffExponent,4,3)+' '+
                      FloatToStrF(log10(I0),ffExponent,4,3)+' '+
                      FloatToStrF(log10(exp(Fbmyk/Nf)),ffExponent,4,3)+' '+
                      FloatToStrF(log10(exp(nmyk/Nf)),ffExponent,4,3)+' '+

                      FloatToStrF(log10(exp(FbmyEk/Nf)),ffExponent,4,3)+' '+
                      FloatToStrF(log10(exp(nmyEk/Nf)),ffExponent,4,3)+' '+

                      FloatToStrF(log10(exp(Rsmyk/Nf)),ffExponent,4,3)+' '+
                      FloatToStrF(I0,ffExponent,4,3)+' '+
                      FloatToStrF(exp(Fbmyk/Nf),ffExponent,5,4)+' '+
                      FloatToStrF(exp(nmyk/Nf),ffExponent,5,4)+' '+

                      FloatToStrF(exp(FbmyEk/Nf),ffExponent,5,4)+' '+
                      FloatToStrF(exp(nmyEk/Nf),ffExponent,5,4)+' '+

                      FloatToStrF(exp(Rsmyk/Nf),ffExponent,5,4));


 Rsstr.SaveToFile('temp.dat');
 I0:=I0*Power(10,1.0/2.0);
 until(I0>1.1e-4);

  Rs:=Rs+2;
until(Rs>52);
Rsstr.SaveToFile(nnn+'_Rs_I0_AV.dat');
Rsstr.Free;
end;


Procedure Ideal_n_I0(Ilim:double);
var
    Rsstr:TStringList;
    Rsmyk,nmyk,Fbmyk,nmyEk,FbmyEk,FbbE,nnE:double;
    Vax:PVector;
    Nf,ip,k,Nsprob:integer;
    name:string;
    T,V,I,n,Rs,Fb,I0,nT,I0T,RsT,FbT:double;
    bool:boolean;
    nnn:string;
    delRsAv,delFbAv,delnAv,delFbEAv,delnEAv:double;
  Nfall: Integer;
begin
if not(SetCurrentDir(CurDirectory)) then
   begin
   MessageDlg('Current directory is not exist', mtError,[mbOk],0);
   Exit;
   end;

Rsstr:=TStringList.Create;

//Rsstr.Add('Rs logI0 logdelFb logdeln logdelRs I0 delFb deln delRs');
Rsstr.Add('Rs logI0 logdelFb logdeln logdelFbE logdelnE logdelRs I0 delFb deln delFbE delnE delRs');

nnn:='CibLong';
Nsprob:=50;
bool:=false;
n:=1;
repeat
 I0:=1e-10;
 repeat
         Randomize;
         Rsmyk:=0;
         nmyk:=0;
         Fbmyk:=0;
         nmyEk:=0;
         FbmyEk:=0;
         Nf:=0;

     if bool then
      begin
        n:=1.04;
        I0:=1e-8*Power(10,1.0/2.0);
        bool:=false;
      end;


        T:=130;
        while T<335 do
         begin

         delRsAv:=0;
         delFbAv:=0;
         delnAv:=0;
         delFbEAv:=0;
         delnEAv:=0;
         Nfall:=0;

         k:=1;
         repeat
           Randomize;

         nT:=RandG(n,0.002*n);
         RsT:=RandG(Rs_T(T),0.002*Rs_T(T));
         I0T:=RandG(I0,0.002*I0);
         FbT:=Kb*T*ln(3.14e-6*1.12e6*T*T/I0T);

           new(Vax);
           Vax^.T:=T;
           ip:=0;
           Vax^.name:=FloatToStrF(n,ffgeneral,3,2)+' '+
                      FloatToStrF(log10(I0),ffgeneral,3,2)+' '+
                      inttostr(round(T));
//Form1.Button1.Caption:=Vax^.name;
           Vax^.N_begin:=0;
           V:=0;

           repeat
               V:=V+0.01;
               I:=Full_IV(V,nT*Kb*T,RsT,I0T,1e13,0);
               if (I>=1e-10) then
                 begin
                   inc(ip);
                   SetLenVector(Vax,ip);
                   name:=FloatToStrF(RandG(V,0),ffExponent,4,0);
                   Vax^.X[High(Vax^.X)]:=strtofloat(name);
                   name:=FloatToStrF(RandG(I,0),ffExponent,4,0);
                   Vax^.Y[High(Vax^.X)]:=strtofloat(name);
                 end;
                if I>Ilim then Break;
           until false;
//          Fit:=TDiod.Create;
//          Fit.FittingDiapazon(Vax,EvolParam,D[diDE]);

//          Fit:=TDiodLSM.Create;
//          Fit.FittingDiapazon(Vax,EvolParam,D[diExp]);

//          Fit:=TDiodLam.Create;
//          Fit.FittingDiapazon(Vax,EvolParam,D[diLam]);


//     Gr1Kalk (Vax,D[diGr1],AA,Sk,Rss,nn,Fbb,I00);
//     LeeKalk (Vax,D[diLee],AA,Sk,Rss,nn,Fbb,I00);
//     MikhKalk (Vax,D[diMikh],AA,Sk,Rss,nn,I00,Fbb);

//     ChungKalk(Vax,D[diChung],Rss,nn);
//     HFunKalk(Vax,D[diHfunc],AA,Sk,nn,Rss,Fbb);
//     ChungKalk(Vax,D[diChung],Rss,nn);

//     Kam1Kalk(Vax,D[diKam1],Rss,nn);
//     Kam2Kalk(Vax,D[diKam2],Rss,nn);
     CibilsKalk(Vax,D[diCib],Rss,nn);
//     WernerKalk(Vax,D[diWer],Rss,nn);

     ExKalk_nconst(1,Vax,D[diEx],Diod,Rss,nn,I00,Fbb);
     ExKalk(1,Vax,D[diEx],Rss,Diod,nnE,I00,FbbE);

//       BohlinKalk(Vax,D[diNord],AA,Sk,1.6,3.5,Rss,nn,Fbb,I00);
//      NordKalk(Vax,D[diNord],AA,Sk,1.8,n,Rss,Fbb);
//       nn:=0.5;


         if (Rss=ErResult)or(Fbb=ErResult) then
//         if EvolParam[1]=ErResult then
            inc(Nfall)
//            showmessage('Rs='+floattostr(Rs)+#10+#13+
//                        'I0='+floattostr(I0))
                    else
                    begin
             delRsAv:=delRsAv+abs((Rss-RsT)/RsT);
             delFbAv:=delFbAv+abs((Fbb-FbT)/FbT);
             delnAv:=delnAv+abs((nn-nT)/nT);
             delFbEAv:=delFbEAv+abs((FbbE-FbT)/FbT);
             delnEAv:=delnEAv+abs((nnE-nT)/nT);

//             delRsAv:=delRsAv+abs((EvolParam[1]-RsT)/RsT);
//             delFbAv:=delFbAv+abs((Fit.DodX[0]-FbT)/FbT);
//             delnAv:=delnAv+abs((EvolParam[0]-nT)/nT);

                    end;
//          Fit.Free;
          dispose(Vax);

           inc(k);
           until(k>Nsprob);

         if Nsprob>Nfall then
         begin

         Rsmyk:=Rsmyk+ln(delRsAv/(Nsprob-Nfall));
         Fbmyk:=Fbmyk+ln(delFbAv/(Nsprob-Nfall));
         nmyk:=nmyk+ln(delnAv/(Nsprob-Nfall));
         FbmyEk:=FbmyEk+ln(delFbEAv/(Nsprob-Nfall));
         nmyEk:=nmyEk+ln(delnEAv/(Nsprob-Nfall));
         inc(Nf);
         end;
          T:=T+10;
         end;

            Rsstr.Add(FloatToStrF(n,ffExponent,4,3)+' '+
                      FloatToStrF(log10(I0),ffExponent,4,3)+' '+
                      FloatToStrF(log10(exp(Fbmyk/Nf)),ffExponent,4,3)+' '+
                      FloatToStrF(log10(exp(nmyk/Nf)),ffExponent,4,3)+' '+

                      FloatToStrF(log10(exp(FbmyEk/Nf)),ffExponent,4,3)+' '+
                      FloatToStrF(log10(exp(nmyEk/Nf)),ffExponent,4,3)+' '+

                      FloatToStrF(log10(exp(Rsmyk/Nf)),ffExponent,4,3)+' '+
                      FloatToStrF(I0,ffExponent,4,3)+' '+
                      FloatToStrF(exp(Fbmyk/Nf),ffExponent,5,4)+' '+
                      FloatToStrF(exp(nmyk/Nf),ffExponent,5,4)+' '+

                      FloatToStrF(exp(FbmyEk/Nf),ffExponent,5,4)+' '+
                      FloatToStrF(exp(nmyEk/Nf),ffExponent,5,4)+' '+

                      FloatToStrF(exp(Rsmyk/Nf),ffExponent,5,4));


 Rsstr.SaveToFile('temp.dat');
 I0:=I0*Power(10,1.0/2.0);
 until(I0>1.1e-4);

 n:=n+0.04;

until(n>1.8);
Rsstr.SaveToFile(nnn+'_n_I_AV.dat');
Rsstr.Free;
end;



Procedure AdditData(method:string);
var
    Fbstr,Rsstr,nstr:TStringList;
    Rsmyk,nmyk,Fbmyk,G1,G2,stepG,Glim,Vtemp:double;
    Vax:PVector;
    Nf,ip:integer;
    SR : TSearchRec;
  T,k, Nsprob: Integer;
  RsAv,delRsAv,FbAv,delFbAv,nAv,delnAv,Fb,n,Rs,V,I,Ilim,SigV,SigI: Double;
  name:string;

begin
if not(SetCurrentDir(CurDirectory)) then
   begin
   MessageDlg('Current directory is not exist', mtError,[mbOk],0);
   Exit;
   end;
Nsprob:=50;
Ilim:=0.1;


Fbstr:=TStringList.Create;
Rsstr:=TStringList.Create;
nstr:=TStringList.Create;

        StepG:=0.01;
        Glim:=0.15;
        G1:=4.1;
        Vtemp:=D[diGr1].Xmin;

if method='Gromov' then
        begin
        StepG:=0.01;
        Glim:=0.15;
        G1:=4.1;
        Vtemp:=D[diGr1].Xmin;
        end;

if method='Nord' then
        begin
        StepG:=0.02;
        Glim:=4.0001;
        G1:=4.1;
        end;

if method='Bohlin' then
        begin
        StepG:=0.05;
        Glim:=4.0001;
        G1:=1.5;
        end;


repeat

 G2:=1.5;
 if method='Gromov' then G2:=0.069;
 if (method='Nord')or(method='Bohlin') then G2:=1.5;

 repeat
 if method='Gromov' then D[diGr1].Xmin:=G2;


  if (method='Bohlin')and(abs(G2-G1)<0.005) then
   begin
      Fbstr.Add(FloatToStrF(G1,ffExponent,4,3)+' '+
                FloatToStrF(G2,ffExponent,4,3)+' '+
                '-');
      Rsstr.Add(FloatToStrF(G1,ffExponent,4,3)+' '+
                FloatToStrF(G2,ffExponent,4,3)+' '+
                '-');
      nstr.Add(FloatToStrF(G1,ffExponent,4,3)+' '+
                FloatToStrF(G2,ffExponent,4,3)+' '+
                '-');
     G2:=G2+StepG;
     Continue;
   end;

//   if method='Bohlin' then
//    begin
//       if G2>G1 then
//         SetCurrentDir('D:\Samples\stat_rozrah\Norde\NordeS_ideal')
//                else
//         SetCurrentDir('D:\Samples\stat_rozrah\Norde\NordeS_G10');
//    end;

         Rsmyk:=0;
         nmyk:=0;
         Fbmyk:=0;
         Nf:=0;


//      if FindFirst('*.dat', faAnyFile, SR) = 0 then
//        begin
//
//          new(Vax);
//
//          repeat
//          if AnsiUpperCase(SR.name)[length(SR.name)-4]<>'N' then Continue;
//
//           Read_File(SR.name,Vax);
        Form1.Button1.Caption:=FloatToStr(G1)+' '+FloatToStr(G2);
        T:=130;
        while T<335 do
         begin



//       if G2<G1 then
//          begin
         n:=n_T(T);
         Rs:=Rs_T(T);
         Fb:=Fb_T(T);
         I0:=3.14e-6*1.12e6*T*T*exp(-Fb/Kb/T);
         sigV:=0.0003;
         sigI:=0.01;
//          end;
 {}
         RsAv:=0;
         delRsAv:=0;
         FbAv:=0;
         delFbAv:=0;
         nAv:=0;
         delnAv:=0;

         k:=1;
         repeat
           Randomize;

       if G2>G1 then
          begin
         n:=RandG(n,0.002*n);
         Rs:=RandG(Rs,0.002*Rs);
         Fb:=RandG(Fb,0.002*Fb);
         I0:=3.14e-6*1.12e6*T*T*exp(-Fb/Kb/T);
         sigV:=0;
         sigI:=0;
          end;

           new(Vax);
           Vax^.T:=T;
           ip:=0;
           Vax^.name:=inttostr(k)+' '+
                      inttostr(T);
           Vax^.N_begin:=0;
           V:=0;

           repeat
               V:=V+0.01;
               I:=Full_IV(V,n*Kb*T,Rs,I0,1e13,0);
               if (I>=1e-10) then
                 begin
                   inc(ip);
                   SetLenVector(Vax,ip);
                   name:=FloatToStrF(RandG(V,SigV),ffExponent,4,0);
                   Vax^.X[High(Vax^.X)]:=strtofloat(name);
                   name:=FloatToStrF(RandG(I,SigI*I),ffExponent,4,0);
                   Vax^.Y[High(Vax^.X)]:=strtofloat(name);
                 end;
                if I>Ilim then Break;
           until false;
 


          if method='Nord' then
           NordKalk(Vax,D[diNord],Diod,G2,n,Rss,Fbb);

          if method='Bohlin' then
            BohlinKalk(Vax,D[diNord],Diod,G1,G2,Rss,nn,Fbb,I00);

          if method='Gromov' then
           Gr2Kalk (Vax,D[diGr1],Diod,Rss,nn,Fbb,I00);

             RsAv:=RsAv+Rss;
             delRsAv:=delRsAv+abs((Rss-Rs)/Rs);
             FbAv:=FbAv+Fbb;
             delFbAv:=delFbAv+abs((Fbb-Fb)/Fb);
             nAv:=nAv+nn;
             delnAv:=delnAv+abs((nn-n)/n);


             dispose(Vax);

            inc(k);
           until(k>Nsprob);

             delRsAv:=delRsAv/Nsprob;
             delFbAv:=delFbAv/Nsprob;
             delnAv:=delnAv/Nsprob;


         Rsmyk:=Rsmyk+ln(delRsAv);
         Fbmyk:=Fbmyk+ln(delFbAv);
         nmyk:=nmyk+ln(abs(delnAv));


         inc(Nf);

          T:=T+10;
          Fbstr.SaveToFile(method+'temp.dat');
         end;

//           Rsmyk:=Rsmyk+ln(abs((Rss-Rs_T(Vax^.T))/Rs_T(Vax^.T)));
//           nmyk:=nmyk+ln(abs((nn-n_T(Vax^.T))/n_T(Vax^.T)));
//           Fbmyk:=Fbmyk+ln(abs((Fbb-Fb_T(Vax^.T))/Fb_T(Vax^.T)));
//           inc(Nf);


//          until FindNext(SR) <> 0;

//          dispose(Vax);
//          FindClose(SR);

          if method='Bohlin' then
            begin
            Fbstr.Add(
                      FloatToStrF(G1,ffExponent,4,3)+' '+
                      FloatToStrF(G2,ffExponent,4,3)+' '+
                      FloatToStrF(log10(exp(Fbmyk/Nf)),ffExponent,5,4));
            Rsstr.Add(
                      FloatToStrF(G1,ffExponent,4,3)+' '+
                      FloatToStrF(G2,ffExponent,4,3)+' '+
                      FloatToStrF(log10(exp(Rsmyk/Nf)),ffExponent,5,4));
            nstr.Add(
                      FloatToStrF(G1,ffExponent,4,3)+' '+
                      FloatToStrF(G2,ffExponent,4,3)+' '+
                      FloatToStrF(log10(exp(nmyk/Nf)),ffExponent,5,4));

            end;

          if (method='Gromov')or(method='Nord') then
            begin
//            showmessage(floattostr(Rsmyk));
            Fbstr.Add(
                      FloatToStrF(G2,ffExponent,4,3)+' '+
                      FloatToStrF(exp(Fbmyk/Nf),ffExponent,5,4));
            Rsstr.Add(
                      FloatToStrF(G2,ffExponent,4,3)+' '+
                      FloatToStrF(exp(Rsmyk/Nf),ffExponent,5,4));
            nstr.Add(
                      FloatToStrF(G2,ffExponent,4,3)+' '+
                      FloatToStrF(exp(nmyk/Nf),ffExponent,5,4));

            end;


//        end;
 G2:=G2+StepG;
 until(G2>Glim);

 G1:=G1+StepG;
until(G1>Glim);

if method='Gromov' then D[diGr1].Xmin:=Vtemp;

Fbstr.SaveToFile(method+'Fb.dat');
Rsstr.SaveToFile(method+'Rs.dat');
nstr.SaveToFile(method+'nd.dat');
Fbstr.Free;
Rsstr.Free;
nstr.Free;
end;


Procedure All_Method();
var
    Vax:PVector;
    Nf:integer;
    SR : TSearchRec;
    Str1: TStringList;
//  Fit:TFitFunction;
   Rsmy,nmy,Fbmy,nmyE,FbmyE:double;
   Rsmyk,nmyk,Fbmyk,nmyEk,FbmyEk:double;
   nnn:string;
   Dtemp,Dtemp2:TDiapazon;

begin

if not(SetCurrentDir(CurDirectory)) then
   begin
   MessageDlg('Current directory is not exist', mtError,[mbOk],0);
   Exit;
   end;

   Str1:=TStringList.Create;
   new(Vax);
   Dtemp:=TDiapazon.Create;
   Dtemp2:=TDiapazon.Create;


   Rsmyk:=0;
   nmyk:=0;
   Fbmyk:=0;
   Nf:=0;
   nmyEk:=0;
   FbmyEk:=0;



    // обчислення за функцією Чюнга
  Str1.Clear;
 if FindFirst('*.dat', faAnyFile, SR) = 0 then
  begin
   Rsmyk:=0;
   nmyk:=0;
   Fbmyk:=0;
   Nf:=0;
   Dtemp.Copy(D[diChung]);
   Dtemp2.Copy(D[diHfunc]);
   if AnsiPos('F50',CurDirectory)=0
    then Dtemp.Ymax:=0.02
    else Dtemp.Ymax:=0.1;
   if AnsiPos('F50',CurDirectory)=0
    then Dtemp2.Ymax:=0.02
    else Dtemp2.Ymax:=0.1;
     nnn:='Ch';
     Form1.Button1.Caption:=nnn;

    repeat
    if AnsiUpperCase(SR.name)[length(SR.name)-4]<>'N' then Continue;

     Read_File(SR.name,Vax);
     try
     ChungKalk(Vax,Dtemp,Rss,nn);
     Rsmy:=Rss;
     nmy:=nn;
     HFunKalk(Vax,Dtemp2,Diod,nmy,Rss,Fbb);
     Fbmy:=Fbb;

     Str1.Add(FloatToStrF(Vax^.T,ffGeneral,4,1)+' '+
             FloatToStrF(Rs_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(Rsmy,ffExponent,5,4)+' '+
             FloatToStrF((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(Fb_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(Fbmy,ffExponent,5,4)+' '+
             FloatToStrF((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(n_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(nmy,ffExponent,5,4)+' '+
             FloatToStrF((nmy-n_T(Vax^.T))/n_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((nmy-n_T(Vax^.T))/n_T(Vax^.T)),ffExponent,5,4)
             );
     Rsmyk:=Rsmyk+ln(abs((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T)));
     nmyk:=nmyk+ln(abs((nmy-n_T(Vax^.T))/n_T(Vax^.T)));
     Fbmyk:=Fbmyk+ln(abs((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T)));
     inc(Nf);
     except

     end;
    until FindNext(SR) <> 0;
  end;
    FindClose(SR);

    Str1.Insert(0,'T Rs Rs'+nnn+' delRs delRs2 Fb Fb'+nnn+' delFb delFb2 n n'+nnn+' deln deln2 ');
    Str1.SaveToFile(nnn+'_'+
                 copy(CurDirectory,
                 LastDelimiter ('\',CurDirectory)+1,
                 length(CurDirectory)-LastDelimiter ('\',CurDirectory))+
                  '.dat');
  Str1.Clear;
  Str1.Add('Rs'+nnn+'   Fb'+nnn+'   n'+nnn);
  str1.Add(FloatToStrF(exp(Rsmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(Fbmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(nmyk/Nf),ffExponent,5,4));
  Str1.SaveToFile(nnn+'_E_'+
                 copy(CurDirectory,
                 LastDelimiter ('\',CurDirectory)+1,
                 length(CurDirectory)-LastDelimiter ('\',CurDirectory))+
                 '.dat');
    // обчислення за функцією Чюнга





     // обчислення за функцією Камінські І-роду
  Str1.Clear;
 if FindFirst('*.dat', faAnyFile, SR) = 0 then
  begin
   Rsmyk:=0;
   nmyk:=0;
   Fbmyk:=0;
   nmyEk:=0;
   FbmyEk:=0;
   Nf:=0;
   Dtemp.Copy(D[diKam1]);
   Dtemp2.Copy(D[diEx]);
//   if AnsiPos('F50',CurDirectory)=0
//    then Dtemp.Ymax:=0.02
//    else Dtemp.Ymax:=0.1;
   if AnsiPos('F50',CurDirectory)=0
    then Dtemp2.Ymax:=0.02
    else Dtemp2.Ymax:=0.1;
     nnn:='Kam1';
     Form1.Button1.Caption:=nnn;

    repeat
    if AnsiUpperCase(SR.name)[length(SR.name)-4]<>'N' then Continue;

     Read_File(SR.name,Vax);
     Kam1Kalk(Vax,Dtemp,Rss,nn);
     Rsmy:=Rss;
     nmy:=nn;
     ExKalk_nconst(1,Vax,Dtemp2,Diod,Rsmy,nmy,I00,Fbb);
     Fbmy:=Fbb;
     ExKalk(1,Vax,Dtemp2,Rsmy,Diod,nn,I00,Fbb);
     FbmyE:=Fbb;
     nmyE:=nn;

     Str1.Add(FloatToStrF(Vax^.T,ffGeneral,4,1)+' '+
             FloatToStrF(Rs_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(Rsmy,ffExponent,5,4)+' '+
             FloatToStrF((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(Fb_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(Fbmy,ffExponent,5,4)+' '+
             FloatToStrF((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(FbmyE,ffExponent,5,4)+' '+
             FloatToStrF((FbmyE-Fb_T(Vax^.T))/Fb_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((FbmyE-Fb_T(Vax^.T))/Fb_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(n_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(nmy,ffExponent,5,4)+' '+
             FloatToStrF((nmy-n_T(Vax^.T))/n_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((nmy-n_T(Vax^.T))/n_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(nmyE,ffExponent,5,4)+' '+
             FloatToStrF((nmyE-n_T(Vax^.T))/n_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((nmyE-n_T(Vax^.T))/n_T(Vax^.T)),ffExponent,5,4)
             );
     Rsmyk:=Rsmyk+ln(abs((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T)));
     nmyk:=nmyk+ln(abs((nmy-n_T(Vax^.T))/n_T(Vax^.T)));
     Fbmyk:=Fbmyk+ln(abs((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T)));
     nmyEk:=nmyEk+ln(abs((nmyE-n_T(Vax^.T))/n_T(Vax^.T)));
     FbmyEk:=FbmyEk+ln(abs((FbmyE-Fb_T(Vax^.T))/Fb_T(Vax^.T)));
     inc(Nf);
    until FindNext(SR) <> 0;
  end;
    FindClose(SR);

    Str1.Insert(0,'T Rs Rs'+nnn+' delRs delRs2 Fb Fb'+nnn+' delFb delFb2 Fb'+nnn+
                'Exp delFbE delFb2E n n'+nnn+' deln deln2 n'+nnn+'2Exp delnE deln2E');
    Str1.SaveToFile(nnn+'_'+
                 copy(CurDirectory,
                 LastDelimiter ('\',CurDirectory)+1,
                 length(CurDirectory)-LastDelimiter ('\',CurDirectory))+
                  '.dat');
  Str1.Clear;
  Str1.Add('Rs'+nnn+'   Fb'+nnn+'   n'+nnn+'   FbE'+nnn+'   nE'+nnn);
  str1.Add(FloatToStrF(exp(Rsmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(Fbmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(nmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(FbmyEk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(nmyEk/Nf),ffExponent,5,4));
  Str1.SaveToFile(nnn+'_E_'+
                 copy(CurDirectory,
                 LastDelimiter ('\',CurDirectory)+1,
                 length(CurDirectory)-LastDelimiter ('\',CurDirectory))+
                 '.dat');
    // обчислення за функцією Камінські І-роду

     // обчислення за функцією Камінські ІI-роду
  Str1.Clear;
 if FindFirst('*.dat', faAnyFile, SR) = 0 then
  begin
   Rsmyk:=0;
   nmyk:=0;
   Fbmyk:=0;
   nmyEk:=0;
   FbmyEk:=0;
   Nf:=0;
   Dtemp.Copy(D[diKam2]);
   Dtemp2.Copy(D[diEx]);
   if AnsiPos('F50',CurDirectory)=0
    then Dtemp.Ymax:=0.02
    else Dtemp.Ymax:=0.1;
   if AnsiPos('F50',CurDirectory)=0
    then Dtemp2.Ymax:=0.02
    else Dtemp2.Ymax:=0.1;
     nnn:='Kam2';
     Form1.Button1.Caption:=nnn;

    repeat
    if AnsiUpperCase(SR.name)[length(SR.name)-4]<>'N' then Continue;

     Read_File(SR.name,Vax);
     Kam2Kalk(Vax,Dtemp,Rss,nn);
     Rsmy:=Rss;
     nmy:=nn;
     ExKalk_nconst(1,Vax,Dtemp2,Diod,Rsmy,nmy,I00,Fbb);
     Fbmy:=Fbb;
     ExKalk(1,Vax,Dtemp2,Rsmy,Diod,nn,I00,Fbb);
     FbmyE:=Fbb;
     nmyE:=nn;

     Str1.Add(FloatToStrF(Vax^.T,ffGeneral,4,1)+' '+
             FloatToStrF(Rs_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(Rsmy,ffExponent,5,4)+' '+
             FloatToStrF((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(Fb_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(Fbmy,ffExponent,5,4)+' '+
             FloatToStrF((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(FbmyE,ffExponent,5,4)+' '+
             FloatToStrF((FbmyE-Fb_T(Vax^.T))/Fb_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((FbmyE-Fb_T(Vax^.T))/Fb_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(n_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(nmy,ffExponent,5,4)+' '+
             FloatToStrF((nmy-n_T(Vax^.T))/n_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((nmy-n_T(Vax^.T))/n_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(nmyE,ffExponent,5,4)+' '+
             FloatToStrF((nmyE-n_T(Vax^.T))/n_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((nmyE-n_T(Vax^.T))/n_T(Vax^.T)),ffExponent,5,4)
             );
     Rsmyk:=Rsmyk+ln(abs((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T)));
     nmyk:=nmyk+ln(abs((nmy-n_T(Vax^.T))/n_T(Vax^.T)));
     Fbmyk:=Fbmyk+ln(abs((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T)));
     nmyEk:=nmyEk+ln(abs((nmyE-n_T(Vax^.T))/n_T(Vax^.T)));
     FbmyEk:=FbmyEk+ln(abs((FbmyE-Fb_T(Vax^.T))/Fb_T(Vax^.T)));
     inc(Nf);
    until FindNext(SR) <> 0;
  end;
    FindClose(SR);

    Str1.Insert(0,'T Rs Rs'+nnn+' delRs delRs2 Fb Fb'+nnn+' delFb delFb2 Fb'+nnn+
                'Exp delFbE delFb2E n n'+nnn+' deln deln2 n'+nnn+'2Exp delnE deln2E');
    Str1.SaveToFile(nnn+'_'+
                 copy(CurDirectory,
                 LastDelimiter ('\',CurDirectory)+1,
                 length(CurDirectory)-LastDelimiter ('\',CurDirectory))+
                  '.dat');
  Str1.Clear;
  Str1.Add('Rs'+nnn+'   Fb'+nnn+'   n'+nnn+'   FbE'+nnn+'   nE'+nnn);
  str1.Add(FloatToStrF(exp(Rsmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(Fbmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(nmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(FbmyEk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(nmyEk/Nf),ffExponent,5,4));
  Str1.SaveToFile(nnn+'_E_'+
                 copy(CurDirectory,
                 LastDelimiter ('\',CurDirectory)+1,
                 length(CurDirectory)-LastDelimiter ('\',CurDirectory))+
                 '.dat');
    // обчислення за функцією Камінські ІI-роду


     // обчислення за методом Сібілса

  Str1.Clear;
 if FindFirst('*.dat', faAnyFile, SR) = 0 then
  begin
   Rsmyk:=0;
   nmyk:=0;
   Fbmyk:=0;
   nmyEk:=0;
   FbmyEk:=0;
   Nf:=0;
   Dtemp.Copy(D[diCib]);
   Dtemp2.Copy(D[diEx]);
   if AnsiPos('F50',CurDirectory)=0
    then Dtemp.Ymax:=0.02
    else Dtemp.Ymax:=0.1;
   if AnsiPos('F50',CurDirectory)=0
    then Dtemp2.Ymax:=0.02
    else Dtemp2.Ymax:=0.1;
     nnn:='Cib';
     Form1.Button1.Caption:=nnn;


    repeat
    if AnsiUpperCase(SR.name)[length(SR.name)-4]<>'N' then Continue;

     Read_File(SR.name,Vax);
     try
     CibilsKalk(Vax,Dtemp,Rss,nn);
     Rsmy:=Rss;
     nmy:=nn;
     ExKalk_nconst(1,Vax,Dtemp2,Diod,Rsmy,nmy,I00,Fbb);
     Fbmy:=Fbb;
     ExKalk(1,Vax,Dtemp2,Rsmy,Diod,nn,I00,Fbb);
     FbmyE:=Fbb;
     nmyE:=nn;

     Str1.Add(FloatToStrF(Vax^.T,ffGeneral,4,1)+' '+
             FloatToStrF(Rs_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(Rsmy,ffExponent,5,4)+' '+
             FloatToStrF((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(Fb_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(Fbmy,ffExponent,5,4)+' '+
             FloatToStrF((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(FbmyE,ffExponent,5,4)+' '+
             FloatToStrF((FbmyE-Fb_T(Vax^.T))/Fb_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((FbmyE-Fb_T(Vax^.T))/Fb_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(n_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(nmy,ffExponent,5,4)+' '+
             FloatToStrF((nmy-n_T(Vax^.T))/n_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((nmy-n_T(Vax^.T))/n_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(nmyE,ffExponent,5,4)+' '+
             FloatToStrF((nmyE-n_T(Vax^.T))/n_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((nmyE-n_T(Vax^.T))/n_T(Vax^.T)),ffExponent,5,4)
             );
     Rsmyk:=Rsmyk+ln(abs((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T)));
     nmyk:=nmyk+ln(abs((nmy-n_T(Vax^.T))/n_T(Vax^.T)));
     Fbmyk:=Fbmyk+ln(abs((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T)));
     nmyEk:=nmyEk+ln(abs((nmyE-n_T(Vax^.T))/n_T(Vax^.T)));
     FbmyEk:=FbmyEk+ln(abs((FbmyE-Fb_T(Vax^.T))/Fb_T(Vax^.T)));
     inc(Nf);
     except

     end;
    until FindNext(SR) <> 0;

  end;
    FindClose(SR);

    Str1.Insert(0,'T Rs Rs'+nnn+' delRs delRs2 Fb Fb'+nnn+' delFb delFb2 Fb'+nnn+
                'Exp delFbE delFb2E n n'+nnn+' deln deln2 n'+nnn+'2Exp delnE deln2E');
    Str1.SaveToFile(nnn+'_'+
                 copy(CurDirectory,
                 LastDelimiter ('\',CurDirectory)+1,
                 length(CurDirectory)-LastDelimiter ('\',CurDirectory))+
                  '.dat');
  Str1.Clear;
  Str1.Add('Rs'+nnn+'   Fb'+nnn+'   n'+nnn+'   FbE'+nnn+'   nE'+nnn);
  str1.Add(FloatToStrF(exp(Rsmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(Fbmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(nmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(FbmyEk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(nmyEk/Nf),ffExponent,5,4));
  Str1.SaveToFile(nnn+'_E_'+
                 copy(CurDirectory,
                 LastDelimiter ('\',CurDirectory)+1,
                 length(CurDirectory)-LastDelimiter ('\',CurDirectory))+
                 '.dat');
    // обчислення за методом Сібілса


     // обчислення за методом Вернера
  Str1.Clear;
 if FindFirst('*.dat', faAnyFile, SR) = 0 then
  begin
   Rsmyk:=0;
   nmyk:=0;
   Fbmyk:=0;
   nmyEk:=0;
   FbmyEk:=0;
   Nf:=0;
   Dtemp.Copy(D[diWer]);
   Dtemp2.Copy(D[diEx]);
   if AnsiPos('F50',CurDirectory)=0
    then Dtemp.Ymax:=0.02
    else Dtemp.Ymax:=0.1;
   if AnsiPos('F50',CurDirectory)=0
    then Dtemp2.Ymax:=0.02
    else Dtemp2.Ymax:=0.1;
     nnn:='Wer';
     Form1.Button1.Caption:=nnn;

    repeat
    if AnsiUpperCase(SR.name)[length(SR.name)-4]<>'N' then Continue;

     Read_File(SR.name,Vax);
     WernerKalk(Vax,Dtemp,Rss,nn);
     Rsmy:=Rss;
     nmy:=nn;
     ExKalk_nconst(1,Vax,Dtemp2,Diod,Rsmy,nmy,I00,Fbb);
     Fbmy:=Fbb;
     ExKalk(1,Vax,Dtemp2,Rsmy,Diod,nn,I00,Fbb);
     FbmyE:=Fbb;
     nmyE:=nn;

     Str1.Add(FloatToStrF(Vax^.T,ffGeneral,4,1)+' '+
             FloatToStrF(Rs_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(Rsmy,ffExponent,5,4)+' '+
             FloatToStrF((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(Fb_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(Fbmy,ffExponent,5,4)+' '+
             FloatToStrF((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(FbmyE,ffExponent,5,4)+' '+
             FloatToStrF((FbmyE-Fb_T(Vax^.T))/Fb_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((FbmyE-Fb_T(Vax^.T))/Fb_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(n_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(nmy,ffExponent,5,4)+' '+
             FloatToStrF((nmy-n_T(Vax^.T))/n_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((nmy-n_T(Vax^.T))/n_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(nmyE,ffExponent,5,4)+' '+
             FloatToStrF((nmyE-n_T(Vax^.T))/n_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((nmyE-n_T(Vax^.T))/n_T(Vax^.T)),ffExponent,5,4)
             );
     Rsmyk:=Rsmyk+ln(abs((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T)));
     nmyk:=nmyk+ln(abs((nmy-n_T(Vax^.T))/n_T(Vax^.T)));
     Fbmyk:=Fbmyk+ln(abs((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T)));
     nmyEk:=nmyEk+ln(abs((nmyE-n_T(Vax^.T))/n_T(Vax^.T)));
     FbmyEk:=FbmyEk+ln(abs((FbmyE-Fb_T(Vax^.T))/Fb_T(Vax^.T)));
     inc(Nf);
    until FindNext(SR) <> 0;
  end;
    FindClose(SR);

    Str1.Insert(0,'T Rs Rs'+nnn+' delRs delRs2 Fb Fb'+nnn+' delFb delFb2 Fb'+nnn+
                'Exp delFbE delFb2E n n'+nnn+' deln deln2 n'+nnn+'2Exp delnE deln2E');
    Str1.SaveToFile(nnn+'_'+
                 copy(CurDirectory,
                 LastDelimiter ('\',CurDirectory)+1,
                 length(CurDirectory)-LastDelimiter ('\',CurDirectory))+
                  '.dat');
  Str1.Clear;
  Str1.Add('Rs'+nnn+'   Fb'+nnn+'   n'+nnn+'   FbE'+nnn+'   nE'+nnn);
  str1.Add(FloatToStrF(exp(Rsmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(Fbmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(nmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(FbmyEk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(nmyEk/Nf),ffExponent,5,4));
  Str1.SaveToFile(nnn+'_E_'+
                 copy(CurDirectory,
                 LastDelimiter ('\',CurDirectory)+1,
                 length(CurDirectory)-LastDelimiter ('\',CurDirectory))+
                 '.dat');
    // обчислення за методом Вернера



    // обчислення за функцією Громова І-роду
  Str1.Clear;
 if FindFirst('*.dat', faAnyFile, SR) = 0 then
  begin
   Rsmyk:=0;
   nmyk:=0;
   Fbmyk:=0;
   Nf:=0;
   Dtemp.Copy(D[diGr1]);
   if AnsiPos('F50',CurDirectory)=0
    then Dtemp.Ymax:=0.02
    else Dtemp.Ymax:=0.1;
     nnn:='Gr1';
     Form1.Button1.Caption:=nnn;

    repeat
    if AnsiUpperCase(SR.name)[length(SR.name)-4]<>'N' then Continue;

     Read_File(SR.name,Vax);
     Gr1Kalk (Vax,Dtemp,Diod,Rss,nn,Fbb,I00);
     Rsmy:=Rss;
     nmy:=nn;
     Fbmy:=Fbb;

     Str1.Add(FloatToStrF(Vax^.T,ffGeneral,4,1)+' '+
             FloatToStrF(Rs_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(Rsmy,ffExponent,5,4)+' '+
             FloatToStrF((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(Fb_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(Fbmy,ffExponent,5,4)+' '+
             FloatToStrF((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(n_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(nmy,ffExponent,5,4)+' '+
             FloatToStrF((nmy-n_T(Vax^.T))/n_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((nmy-n_T(Vax^.T))/n_T(Vax^.T)),ffExponent,5,4)
             );
     Rsmyk:=Rsmyk+ln(abs((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T)));
     nmyk:=nmyk+ln(abs((nmy-n_T(Vax^.T))/n_T(Vax^.T)));
     Fbmyk:=Fbmyk+ln(abs((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T)));
     inc(Nf);
    until FindNext(SR) <> 0;
  end;
    FindClose(SR);

    Str1.Insert(0,'T Rs Rs'+nnn+' delRs delRs2 Fb Fb'+nnn+' delFb delFb2 n n'+nnn+' deln deln2 ');
    Str1.SaveToFile(nnn+'_'+
                 copy(CurDirectory,
                 LastDelimiter ('\',CurDirectory)+1,
                 length(CurDirectory)-LastDelimiter ('\',CurDirectory))+
                  '.dat');
  Str1.Clear;
  Str1.Add('Rs'+nnn+'   Fb'+nnn+'   n'+nnn);
  str1.Add(FloatToStrF(exp(Rsmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(Fbmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(nmyk/Nf),ffExponent,5,4));
  Str1.SaveToFile(nnn+'_E_'+
                 copy(CurDirectory,
                 LastDelimiter ('\',CurDirectory)+1,
                 length(CurDirectory)-LastDelimiter ('\',CurDirectory))+
                 '.dat');
    // обчислення за функцією Громова І-роду


    // обчислення за функцією Лі
  Str1.Clear;
 if FindFirst('*.dat', faAnyFile, SR) = 0 then
  begin
   Rsmyk:=0;
   nmyk:=0;
   Fbmyk:=0;
   Nf:=0;
   Dtemp.Copy(D[diLee]);
   if AnsiPos('F50',CurDirectory)=0
    then Dtemp.Ymax:=0.02
    else Dtemp.Ymax:=0.1;
     nnn:='Lee';
     Form1.Button1.Caption:=nnn;

    repeat
    if AnsiUpperCase(SR.name)[length(SR.name)-4]<>'N' then Continue;

     Read_File(SR.name,Vax);
     LeeKalk (Vax,Dtemp,Diod,Rss,nn,Fbb,I00);
//     LeeKalk (Vax,D[diLee],Diod,Rss,nn,Fbb,I00);
     Rsmy:=Rss;
     nmy:=nn;
     Fbmy:=Fbb;

     Str1.Add(FloatToStrF(Vax^.T,ffGeneral,4,1)+' '+
             FloatToStrF(Rs_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(Rsmy,ffExponent,5,4)+' '+
             FloatToStrF((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(Fb_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(Fbmy,ffExponent,5,4)+' '+
             FloatToStrF((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(n_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(nmy,ffExponent,5,4)+' '+
             FloatToStrF((nmy-n_T(Vax^.T))/n_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((nmy-n_T(Vax^.T))/n_T(Vax^.T)),ffExponent,5,4)
             );
     Rsmyk:=Rsmyk+ln(abs((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T)));
     nmyk:=nmyk+ln(abs((nmy-n_T(Vax^.T))/n_T(Vax^.T)));
     Fbmyk:=Fbmyk+ln(abs((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T)));
     inc(Nf);
    until FindNext(SR) <> 0;
  end;
    FindClose(SR);

    Str1.Insert(0,'T Rs Rs'+nnn+' delRs delRs2 Fb Fb'+nnn+' delFb delFb2 n n'+nnn+' deln deln2 ');
    Str1.SaveToFile(nnn+'_'+
                 copy(CurDirectory,
                 LastDelimiter ('\',CurDirectory)+1,
                 length(CurDirectory)-LastDelimiter ('\',CurDirectory))+
                  '.dat');
  Str1.Clear;
  Str1.Add('Rs'+nnn+'   Fb'+nnn+'   n'+nnn);
  str1.Add(FloatToStrF(exp(Rsmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(Fbmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(nmyk/Nf),ffExponent,5,4));
  Str1.SaveToFile(nnn+'_E_'+
                 copy(CurDirectory,
                 LastDelimiter ('\',CurDirectory)+1,
                 length(CurDirectory)-LastDelimiter ('\',CurDirectory))+
                 '.dat');
    // обчислення за функцією Лі


    // обчислення за функцією Міхелашвілі
  Str1.Clear;
 if FindFirst('*.dat', faAnyFile, SR) = 0 then
  begin
   Rsmyk:=0;
   nmyk:=0;
   Fbmyk:=0;
   Nf:=0;
   Dtemp.Copy(D[diMikh]);
   if AnsiPos('F50',CurDirectory)=0
    then Dtemp.Ymax:=0.02
    else Dtemp.Ymax:=0.1;
     nnn:='Mikh';
     Form1.Button1.Caption:=nnn;

    repeat
    if AnsiUpperCase(SR.name)[length(SR.name)-4]<>'N' then Continue;

     Read_File(SR.name,Vax);
     MikhKalk (Vax,Dtemp,Diod,Rss,nn,I00,Fbb);
     Rsmy:=Rss;
     nmy:=nn;
     Fbmy:=Fbb;

     Str1.Add(FloatToStrF(Vax^.T,ffGeneral,4,1)+' '+
             FloatToStrF(Rs_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(Rsmy,ffExponent,5,4)+' '+
             FloatToStrF((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(Fb_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(Fbmy,ffExponent,5,4)+' '+
             FloatToStrF((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(n_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(nmy,ffExponent,5,4)+' '+
             FloatToStrF((nmy-n_T(Vax^.T))/n_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((nmy-n_T(Vax^.T))/n_T(Vax^.T)),ffExponent,5,4)
             );
     Rsmyk:=Rsmyk+ln(abs((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T)));
     nmyk:=nmyk+ln(abs((nmy-n_T(Vax^.T))/n_T(Vax^.T)));
     Fbmyk:=Fbmyk+ln(abs((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T)));
     inc(Nf);
    until FindNext(SR) <> 0;
  end;
    FindClose(SR);

    Str1.Insert(0,'T Rs Rs'+nnn+' delRs delRs2 Fb Fb'+nnn+' delFb delFb2 n n'+nnn+' deln deln2 ');
    Str1.SaveToFile(nnn+'_'+
                 copy(CurDirectory,
                 LastDelimiter ('\',CurDirectory)+1,
                 length(CurDirectory)-LastDelimiter ('\',CurDirectory))+
                  '.dat');
  Str1.Clear;
  Str1.Add('Rs'+nnn+'   Fb'+nnn+'   n'+nnn);
  str1.Add(FloatToStrF(exp(Rsmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(Fbmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(nmyk/Nf),ffExponent,5,4));
  Str1.SaveToFile(nnn+'_E_'+
                 copy(CurDirectory,
                 LastDelimiter ('\',CurDirectory)+1,
                 length(CurDirectory)-LastDelimiter ('\',CurDirectory))+
                 '.dat');
    // обчислення за функцією Міхелашвілі


    // обчислення за еволюційні методи
//  Str1.Clear;
// if FindFirst('*.dat', faAnyFile, SR) = 0 then
//  begin
//   Rsmyk:=0;
//   nmyk:=0;
//   Fbmyk:=0;
//   Nf:=0;
//   Dtemp.Copy(D[diDE]);
//   if AnsiPos('F50',CurDirectory)=0
//    then Dtemp.Ymax:=0.02
//    else Dtemp.Ymax:=0.1;
//     nnn:='MABC';
//     Form1.Button1.Caption:=nnn;
//
//    repeat
//    if AnsiUpperCase(SR.name)[length(SR.name)-4]<>'N' then Continue;
//
//     Read_File(SR.name,Vax);
//     Fit:=TDiod.Create;
//     Fit.FittingDiapazon(Vax,EvolParam,Dtemp);
//      Rsmy:=EvolParam[1];
//      nmy:=EvolParam[0];
//      Fbmy:=Fit.DodX[0];
//
//     Str1.Add(FloatToStrF(Vax^.T,ffGeneral,4,1)+' '+
//             FloatToStrF(Rs_T(Vax^.T),ffExponent,5,4)+' '+
//             FloatToStrF(Rsmy,ffExponent,5,4)+' '+
//             FloatToStrF((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T),ffExponent,5,4)+' '+
//             FloatToStrF(sqr((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T)),ffExponent,5,4)+' '+
//             FloatToStrF(Fb_T(Vax^.T),ffExponent,5,4)+' '+
//             FloatToStrF(Fbmy,ffExponent,5,4)+' '+
//             FloatToStrF((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T),ffExponent,5,4)+' '+
//             FloatToStrF(sqr((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T)),ffExponent,5,4)+' '+
//             FloatToStrF(n_T(Vax^.T),ffExponent,5,4)+' '+
//             FloatToStrF(nmy,ffExponent,5,4)+' '+
//             FloatToStrF((nmy-n_T(Vax^.T))/n_T(Vax^.T),ffExponent,5,4)+' '+
//             FloatToStrF(sqr((nmy-n_T(Vax^.T))/n_T(Vax^.T)),ffExponent,5,4)
//             );
//     Rsmyk:=Rsmyk+ln(abs((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T)));
//     nmyk:=nmyk+ln(abs((nmy-n_T(Vax^.T))/n_T(Vax^.T)));
//     Fbmyk:=Fbmyk+ln(abs((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T)));
//     inc(Nf);
//     Fit.Free;
//    until FindNext(SR) <> 0;
//  end;
//    FindClose(SR);
//
//    Str1.Insert(0,'T Rs Rs'+nnn+' delRs delRs2 Fb Fb'+nnn+' delFb delFb2 n n'+nnn+' deln deln2 ');
//    Str1.SaveToFile(nnn+'_'+
//                 copy(CurDirectory,
//                 LastDelimiter ('\',CurDirectory)+1,
//                 length(CurDirectory)-LastDelimiter ('\',CurDirectory))+
//                  '.dat');
//  Str1.Clear;
//  Str1.Add('Rs'+nnn+'   Fb'+nnn+'   n'+nnn);
//  str1.Add(FloatToStrF(exp(Rsmyk/Nf),ffExponent,5,4)
//      +' '+FloatToStrF(exp(Fbmyk/Nf),ffExponent,5,4)
//      +' '+FloatToStrF(exp(nmyk/Nf),ffExponent,5,4));
//  Str1.SaveToFile(nnn+'_E_'+
//                 copy(CurDirectory,
//                 LastDelimiter ('\',CurDirectory)+1,
//                 length(CurDirectory)-LastDelimiter ('\',CurDirectory))+
//                 '.dat');
    // обчислення за еволюційні методи


    dispose(Vax);
    Str1.Free;
    Dtemp.Free;
    Dtemp2.Free;

end;



procedure TForm1.Button1Click(Sender: TObject);
//var comment,dat:TStringList;
//    name:string;
//    T,V,I,n,Rs,Fb,I0,Ilim:double;
//    Fbstr,Rsstr,nstr:TStringList;
//    Rsmyk,nmyk,Fbmyk,G1,G2,stepG,Glim:double;
//    Vax:PVector;
//    Nf:integer;
//    Fbstring,Rsstring,nstring:string;
//    SR : TSearchRec;
//    ip:integer;
//    SigV,SigI,StepV,StepI,SigVMax,SigIMax:double;
//    z,x,W,L0,z_max,x_Max,Fb0,Vn,Del,x0,Pot,Del2,x02,L02:double;
 begin
//------------------------------------------------------------
// Patch();
//------------------------------------------------------------
//GenerIVSet(0,0,0.02,'n.dat');
//GenerIVSet(0.05,0.003,0.02,'G5030n.dat');
//GenerIVSet(sigI,sigV,Ilim:double;f_end:string);
//-------------------------------------------------------
//AdditData('Bohlin');
//-------------------------------------------------------
//AccurSet(0.050001,0.00300001,0.002,0.0001,0.02);
AccurSet(0.050001,0.00300001,0.005,0.00025,0.02);
//AccurSet(0.000050001,0.00000300001,0.005,0.0002,0.02);
//--------------------------------------------------------
//All_Method()
//--------------------------------------------------------
//IdealRs(0.02);
//Ideal_n_I0(0.2);
//--------------------------------------------------------
//TemperAve(0.1,0.0003,0.01);
//TemperAve(0.1,0.002,0.01);
//TemperAve(0.1,0.0003,0.005);
//TemperAve(Ilim,sigV,sigI:double);

//TemperIdAve(0.02,'O');
//TemperIdAve(0.02,'n');
//TemperIdAve(0.02,'R');
//TemperIdAve(0.02,'F');
//TemperIdAve(0.02,'I');
//TemperIdAve(Ilim:double);
//-----------------------------------
end;




//procedure TForm1.ButtonAreaClick(Sender: TObject);
//var st,stHint:string;
//    Sk_temp:double;
//begin
//Sk_temp:=Sk;
//st:=FloatToStrF(Sk,ffExponent,3,2);
//stHint:='Input contact area, [ ] = m2';
//st:=InputBox('Diode area',stHint,st);
//StrToNumber(st, Sk_temp, Sk);
//if Sk<=0 then
//         begin
//         MessageDlg('Contact area must be positive', mtError,[mbOk],0);
//         Sk:=Sk_temp;
//         end;
//LabelArea.Caption:=FloatToStrF(Sk,ffExponent,3,2)+' m2';
//end;

//procedure TForm1.ButtonConcenClick(Sender: TObject);
//var st,stHint:string;
//    Ndd_temp:double;
//begin
//Ndd_temp:=Ndd;
//st:=FloatToStrF(Ndd,ffExponent,3,2);
//stHint:='Input carrier concentration, [ ] = m^-3';
//st:=InputBox('carrier concentration',stHint,st);
//StrToNumber(st, Ndd_temp, Ndd);
//if Ndd<=0 then
//         begin
//         MessageDlg('Carrier concentration must be positive', mtError,[mbOk],0);
//         Ndd:=Ndd_temp;
//         end;
//LabelConcentr.Caption:=FloatToStrF(Ndd,ffExponent,3,2)+' m-3';
//end;

procedure TForm1.ButtonCreateDateClick(Sender: TObject);
var
  SR : TSearchRec;
  mask,ShotName:string;
  Vax,Vax2,Vax3,Vax4:Pvector;
  Rs,n,n2,I02:double;
  i,j,ij:integer;
  T_bool:boolean;
  dat:array {[0..ord(High(TColName)){Ndate}{]} of string;
  F:TextFile;
  CL:TColName;
  Str1: TStringList;
  str:string;
  a,b:double;
//  Fit:TFitFunction;
  Rsmy,nmy,Fbmy,nmyE,FbmyE:double;
  Rsmyk,nmyk,Fbmyk,nmyEk,FbmyEk:double;
  Nf:integer;
  nnn,temp_str:string;
  nameBool:boolean;
  Fit:TFitFunctionAAA;

begin
DecimalSeparator:='.';
SetLength(dat,ord(High(TColName))+1);
//showmessage(inttostr(High(dat)));
if (LDateFun.Caption<>'None')and(CBDateFun.Checked) then
 begin
  FunCreate(LDateFun.Caption,Fit);

  SetLength(dat,High(dat)+1+High(Fit.Xname)+1+High(Fit.DodXname)+1);

  Fit.Free;
 end;
//showmessage(inttostr(High(dat)));
 //ColParam(StrGridData);

//    new(Vax2);
//    new(Vax3);
//    new(Vax4);
   Str1:=TStringList.Create;
   Rsmyk:=0;
   nmyk:=0;
   Fbmyk:=0;
   nmyEk:=0;
   FbmyEk:=0;
   Nf:=0;
   Rsmy:=0;
   nmy:=0;
   nameBool:=false;

T_bool:=False;
if not(SetCurrentDir(CurDirectory)) then
   begin
   MessageDlg('Current directory is not exist', mtError,[mbOk],0);
   Exit;
   end;
mask:='*.dat';
//kkkkkkkkkkkkkkkkkkk

{for ij:= 0 to High(Volt) do
begin
SetLenVector(Vax3,0);
{Str1.Clear;
str:='T'+' V'+floattostrf(abs(Volt[ij]),ffGeneral,2,1);
Str1.Add(str);{}
//kkkkkkkkkkkkkkkkkkkkkk


if FindFirst(mask, faAnyFile, SR) = 0 then
  begin
    new(Vax);


//    str:='T';
//    for i:= 0 to High(Volt) do
//     str:=str+' V'+floattostrf(abs(Volt[i]),ffGeneral,2,1);
//    Str1.Add(str);

    StrGridData.RowCount:=2;
    StrGridData.ColCount:=StrGridData.ColCount+1;
{створюємо ще одну колонку, куди будемо заносити
ціле число, яке пов'язане з часом створення
файлу - SR.Time; головна ідея цього - відсортувати
в кінці StrGridData саме по вмісту цієї колонки;
якщо сортувати по вмісту колонки з явним часом,
то 9:00 більше ніж 10:00 -
в кінці-кінців поміняв на сортування за назвою файлу,
але цей шматок вже не викидав }

    repeat
     ShotName:=AnsiUpperCase(SR.name);
//     if ShotName[length(ShotName)-4]<>'N' then Continue;
//    if ShotName[length(ShotName)-4]<>'V' then Continue;
    if Pos('DATES',ShotName)<>0 then Continue;
    if Pos('FIT',ShotName)<>0 then Continue;
//        showmessage(SR.name);
     Read_File(SR.name,Vax);
//     ShotName:=copy(ShotName,1,length(ShotName)-5);
     ShotName:=copy(ShotName,1,length(ShotName)-4);
     //в ShotName коротке ім'я файла - те що вводиться при вимірах :)
     if Vax^.T=0 then T_bool:=True;
     {встановлюється змінна, яка показує що є файли з невизначеною температурою}

     dat[ord(fname)]:=ShotName;
     if length(dat[ord(fname)])<4 then insert('0',dat[0],1);
     if length(dat[ord(fname)])<4 then insert('0',dat[0],1);
     if length(dat[ord(fname)])<4 then insert('0',dat[0],1);

     if Vax^.time='' then dat[ord(time)]:=IntToStr(SR.Time)
                     else dat[ord(time)]:=Vax^.time;

     dat[ord(Tem)]:=FloatToStrF(Vax^.T,ffGeneral,4,1);
     if Vax^.T=0 then dat[ord(kT_1)]:='555'
                 else dat[ord(kT_1)]:=FloatToStrF(1/Kb/Vax^.T,ffGeneral,4,2);

      if Vax^.T=0 then  Vax^.T:=300;

     // обчислення за функцією Чюнга
     if (Rs_Ch in ColNames) or (n_Ch in ColNames) then
      begin
      ChungKalk(Vax,D[diChung],Rss,nn);
      dat[ord(Rs_Ch)]:=FloatToStrF(Rss,ffExponent,3,2);
      dat[ord(n_Ch)]:=FloatToStrF(nn,ffGeneral,4,3);
//--------------------------
      Rsmy:=Rss;
      nmy:=nn;
      nnn:='Ch';
//---------------------------
      end;

     // обчислення за Н-функцією
     if (Rs_H in ColNames) or (Fb_H in ColNames) then
      begin
      n:=nDefineCB(Vax,ComBDateHfunN,ComBDateHfunN_Rs);
      HFunKalk(Vax,D[diHfunc],Diod,n,Rss,Fbb);
      dat[ord(Rs_H)]:=FloatToStrF(Rss,ffExponent,3,2);
      dat[ord(Fb_H)]:=FloatToStrF(Fbb,ffGeneral,3,2);
//--------------------------
      HFunKalk(Vax,D[diHfunc],Diod,nmy,Rss,Fbb);
      Fbmy:=Fbb;
//---------------------------
      end; // (Rs_H in ColNames) or (Fb_H in ColNames) then

     // обчислення за функцією Норда
     if (Rs_N in ColNames) or (Fb_N in ColNames) then
      begin
      n:=nDefineCB(Vax,ComBDateNordN,ComBDateNordN_Rs);
      NordKalk(Vax,D[diNord],Diod,Gamma,n,Rss,Fbb);
      dat[ord(Rs_N)]:=FloatToStrF(Rss,ffExponent,3,2);
      dat[ord(Fb_N)]:=FloatToStrF(Fbb,ffGeneral,3,2);
////--------------------------
      n:=n_T(Vax^.T);
//    Fit:=TDiod.Create;
//    Fit.FittingDiapazon(Vax,EvolParam,D[diDE]);
//    Fit.Free;
      NordKalk(Vax,D[diNord],Diod,1.8,n,Rss,Fbb);
      Rsmy:=Rss;
      Fbmy:=Fbb;
      nnn:='Nord';

////---------------------------


      end;//(Rs_N in ColNames) or (Fb_N in ColNames) then

     // обчислення шляхом апроксимації І=I0(exp(V/nkT)-1)
     if (Is_Exp in ColNames) or (n_Exp in ColNames)
         or (Fb_Exp in ColNames) then
      begin
       Rs:=RsDefineCB(Vax,ComBDateExpRs,ComBDateExpRs_n);
       ExpKalk(Vax,D[diExp],Rs,Diod,ApprExp,nn,I00,Fbb);
       dat[ord(n_Exp)]:=FloatToStrF(nn,ffGeneral,4,3);
       dat[ord(Is_Exp)]:=FloatToStrF(I00,ffExponent,3,2);
       dat[ord(Fb_Exp)]:=FloatToStrF(Fbb,ffGeneral,3,2);
      end;

      //обчислення шляхом апроксимації І/[1-exp(-qV/kT)]=I0exp(V/nkT), пряма ділянка
      if (Is_E2F in ColNames) or (n_E2F in ColNames)
         or (Fb_E2F in ColNames) then
       begin
        Rs:=RsDefineCB(Vax,ComBDateEx2FRs,ComBDateEx2FRs_n);
        ExKalk(2,Vax,D[diE2F],Rs,Diod,nn,I00,Fbb);
        dat[ord(n_E2F)]:=FloatToStrF(nn,ffGeneral,4,3);
        dat[ord(Is_E2F)]:=FloatToStrF(I00,ffExponent,3,2);
        dat[ord(Fb_E2F)]:=FloatToStrF(Fbb,ffGeneral,3,2);
      end;

      //обчислення шляхом апроксимації І/[1-exp(-qV/kT)]=I0exp(V/nkT), зворотня ділянка
      if (Is_E2R in ColNames) or (n_E2R in ColNames)
         or (Fb_E2R in ColNames) then
       begin
        Rs:=RsDefineCB(Vax,ComBDateEx2RRs,ComBDateEx2RRs_n);
        ExKalk(3,Vax,D[diE2R],Rs,Diod,nn,I00,Fbb);
        dat[ord(n_E2R)]:=FloatToStrF(nn,ffGeneral,4,3);
        dat[ord(Is_E2R)]:=FloatToStrF(I00,ffExponent,3,2);
        dat[ord(Fb_E2R)]:=FloatToStrF(Fbb,ffGeneral,3,2);
      end;

     //обчислення коефіцієнту випрямлення
    if (Kr in ColNames) then
     begin
     Krec:=Krect(Vax,Vrect);
     dat[ord(Kr)]:=FloatToStrF(Krec,ffGeneral,3,2);
     end;

     // обчислення за функцією Камінські І-роду
     if (Rs_K1 in ColNames) or (n_K1 in ColNames) then
      begin
      Kam1Kalk(Vax,D[diKam1],Rss,nn);
      dat[ord(Rs_K1)]:=FloatToStrF(Rss,ffExponent,3,2);
      dat[ord(n_K1)]:=FloatToStrF(nn,ffGeneral,4,3);
//--------------------------
      Rsmy:=Rss;
      nmy:=nn;
      nnn:='Kam1';
//---------------------------
      end;  //if (Rs_K1 in ColNames) or (n_K1 in ColNames) then

     // обчислення за функцією Камінські IІ-роду
     if (Rs_K2 in ColNames) or (n_K2 in ColNames) then
      begin
      Kam2Kalk(Vax,D[diKam2],Rss,nn);
      dat[ord(Rs_K2)]:=FloatToStrF(Rss,ffExponent,3,2);
      dat[ord(n_K2)]:=FloatToStrF(nn,ffGeneral,4,3);
//--------------------------
      Rsmy:=Rss;
      nmy:=nn;
      nnn:='Kam2';
//---------------------------

      end;  //Rs_K2 in ColNames) or (n_K2 in ColNames) then

     // обчислення за функцією Громова І-роду
     if (Rs_Gr1 in ColNames) or (n_Gr1 in ColNames)
         or (Is_Gr1 in ColNames) or (Fb_Gr1 in ColNames) then
      begin
      Gr1Kalk (Vax,D[diGr1],Diod,Rss,nn,Fbb,I00);
      dat[ord(Rs_Gr1)]:=FloatToStrF(Rss,ffExponent,3,2);
      dat[ord(n_Gr1)]:=FloatToStrF(nn,ffGeneral,4,3);
      dat[ord(Is_Gr1)]:=FloatToStrF(I00,ffExponent,3,2);
      dat[ord(Fb_Gr1)]:=FloatToStrF(Fbb,ffGeneral,3,2);
//--------------------------
      Rsmy:=Rss;
      nmy:=nn;
      Fbmy:=Fbb;
      nnn:='Gr1';
//---------------------------

      end;

     // обчислення за функцією Громова ІI-роду
     if (Rs_Gr2 in ColNames) or (n_Gr2 in ColNames)
         or (Is_Gr2 in ColNames) or (Fb_Gr2 in ColNames) then
      begin
      Gr2Kalk (Vax,D[diGr2],Diod,Rss,nn,Fbb,I00);
      dat[ord(Rs_Gr2)]:=FloatToStrF(Rss,ffExponent,3,2);
      dat[ord(n_Gr2)]:=FloatToStrF(nn,ffGeneral,4,3);
      dat[ord(Is_Gr2)]:=FloatToStrF(I00,ffExponent,3,2);
      dat[ord(Fb_Gr2)]:=FloatToStrF(Fbb,ffGeneral,3,2);
//--------------------------
      Rsmy:=Rss;
      nmy:=nn;
      Fbmy:=Fbb;
      nnn:='Gr2';
//---------------------------

      end;

     // обчислення за методом Вернера
     if (Rs_Wer in ColNames) or (n_Wer in ColNames) then
      begin
      WernerKalk(Vax,D[diWer],Rss,nn);
      dat[ord(Rs_Wer)]:=FloatToStrF(Rss,ffExponent,3,2);
      dat[ord(n_Wer)]:=FloatToStrF(nn,ffGeneral,4,3);
////--------------------------
      Rsmy:=Rss;
      nmy:=nn;
      nnn:='Wer';
////---------------------------

      end;  //if (Rs_Wer in ColNames) or (n_Wer in ColNames) then

     // обчислення за методом Сібілса
     if (Rs_Cb in ColNames) or (n_Cb in ColNames) then
      begin
      CibilsKalk(Vax,D[diCib],Rss,nn);
      dat[ord(Rs_Cb)]:=FloatToStrF(Rss,ffExponent,3,2);
      dat[ord(n_Cb)]:=FloatToStrF(nn,ffGeneral,4,3);
////--------------------------
      Rsmy:=Rss;
      nmy:=nn;
      nnn:='Cib';
////---------------------------

      end;  //if (Rs_Cb in ColNames) or (n_Cb in ColNames) then


      //обчислення шляхом апроксимації І=I0exp(V/nkT)
      if (Is_El in ColNames) or (n_El in ColNames)
         or (Fb_El in ColNames) then
       begin
        Rs:=RsDefineCB(Vax,ComBDateExRs,ComBDateExRs_n);
        ExKalk(1,Vax,D[diEx],Rs,Diod,nn,I00,Fbb);
        dat[ord(n_El)]:=FloatToStrF(nn,ffGeneral,4,3);
        dat[ord(Is_El)]:=FloatToStrF(I00,ffExponent,3,2);
        dat[ord(Fb_El)]:=FloatToStrF(Fbb,ffGeneral,3,2);
//----------------------------------
       ExKalk(1,Vax,D[diEx],Rsmy,Diod,nmyE,I00,FbmyE);
       ExKalk_nconst(1,Vax,D[diEx],Diod,Rsmy,nmy,I00,Fbmy);
//----------------------------------
      end;

     // обчислення за методом Бохліна
     if (Rs_Bh in ColNames) or (n_Bh in ColNames)
         or (Is_Bh in ColNames) or (Fb_Bh in ColNames) then
      begin
      BohlinKalk(Vax,D[diNord],Diod,Gamma1,Gamma2,Rss,nn,Fbb,I00);
      dat[ord(Rs_Bh)]:=FloatToStrF(Rss,ffExponent,3,2);
      dat[ord(n_Bh)]:=FloatToStrF(nn,ffGeneral,4,3);
      dat[ord(Is_Bh)]:=FloatToStrF(I00,ffExponent,3,2);
      dat[ord(Fb_Bh)]:=FloatToStrF(Fbb,ffGeneral,3,2);
//--------------------------
      BohlinKalk(Vax,D[diNord],Diod,1.6,1.9,Rss,nn,Fbb,I00);
      Rsmy:=Rss;
      nmy:=nn;
      Fbmy:=Fbb;
      nnn:='Bohl';
//---------------------------

      end;

     // обчислення за методом Лі
     if (Rs_Lee in ColNames) or (n_Lee in ColNames)
         or (Is_Lee in ColNames) or (Fb_Lee in ColNames) then
      begin
      LeeKalk (Vax,D[diLee],Diod,Rss,nn,Fbb,I00);
      dat[ord(Rs_Lee)]:=FloatToStrF(Rss,ffExponent,3,2);
      dat[ord(n_Lee)]:=FloatToStrF(nn,ffGeneral,4,3);
      dat[ord(Is_Lee)]:=FloatToStrF(I00,ffExponent,3,2);
      dat[ord(Fb_Lee)]:=FloatToStrF(Fbb,ffGeneral,3,2);
//--------------------------
      Rsmy:=Rss;
      nmy:=nn;
      Fbmy:=Fbb;
      nnn:='Lee';
//---------------------------

      end;

     //Обчислення за методом Міхелашвілі
     if (Rs_Mk in ColNames) or (n_Mk in ColNames)
         or (Is_Mk in ColNames) or (Fb_Mk in ColNames) then
      begin
      MikhKalk (Vax,D[diMikh],Diod,Rss,nn,I00,Fbb);
      dat[ord(Rs_Mk)]:=FloatToStrF(Rss,ffExponent,3,2);
      dat[ord(n_Mk)]:=FloatToStrF(nn,ffGeneral,4,3);
      dat[ord(Is_Mk)]:=FloatToStrF(I00,ffExponent,3,2);
      dat[ord(Fb_Mk)]:=FloatToStrF(Fbb,ffGeneral,3,2);
//--------------------------
      Rsmy:=Rss;
      nmy:=nn;
      Fbmy:=Fbb;
      nnn:='Mikh';
//---------------------------

      end;

   //обчислення шляхом апроксимації І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
     if (Rs_ExN in ColNames) or (n_ExN in ColNames)
         or (Is_ExN in ColNames) or (Fb_ExN in ColNames)
         or (Rsh_ExN in ColNames) or (If_ExN in ColNames)
         or (Isc_ExN in ColNames) or (Voc_ExN in ColNames)
         or (Pm_ExN in ColNames) or (FF_ExN in ColNames)
         then
      begin
        if Iph_Exp then Ft:=TPhotoDiodLSM.Create
                   else Ft:=TDiodLSM.Create;
        Fit.FittingDiapazon(Vax,EvolParam,D[diExp]);
        dat[ord(Rs_ExN)]:=FloatToStrF(EvolParam[1],ffExponent,3,2);
        dat[ord(n_ExN)]:=FloatToStrF(EvolParam[0],ffGeneral,4,3);
        dat[ord(Is_ExN)]:=FloatToStrF(EvolParam[2],ffExponent,3,2);
        dat[ord(Rsh_ExN)]:=FloatToStrF(EvolParam[3],ffExponent,3,2);
        if Iph_Exp then
          begin
            dat[ord(Fb_ExN)]:='555';
            dat[ord(If_ExN)]:=FloatToStrF(EvolParam[4],ffExponent,3,2);
            dat[ord(Isc_ExN)]:=FloatToStrF(Fit.DodX[1],ffExponent,3,2);
            dat[ord(Pm_ExN)]:=FloatToStrF(Fit.DodX[2],ffExponent,3,2);
            dat[ord(Voc_ExN)]:=FloatToStrF(Fit.DodX[0],ffGeneral,4,3);
            dat[ord(FF_ExN)]:=FloatToStrF(Fit.DodX[3],ffGeneral,4,3);
          end
                  else
          begin
            dat[ord(Fb_ExN)]:=FloatToStrF(Fit.DodX[0],ffGeneral,4,3);
            dat[ord(If_ExN)]:='0';
            dat[ord(Isc_ExN)]:='0';
            dat[ord(Pm_ExN)]:='0';
            dat[ord(Voc_ExN)]:='0';
            dat[ord(FF_ExN)]:='0';
          end;

          Rsmy:=EvolParam[1];
          nmy:=EvolParam[0];
          Fbmy:=Fit.DodX[0];
          nnn:='LSM';

        Fit.Free;

//      ExpKalkNew(Vax,D[diExp],Mode_Exp,Iph_Exp,0,AA,Sk,nn,I00,Fbb,Rss,Rsh,Iph,Voc,Isc,Pm,FF);
//      dat[ord(Rs_ExN)]:=FloatToStrF(Rss,ffExponent,3,2);
//      dat[ord(n_ExN)]:=FloatToStrF(nn,ffGeneral,4,3);
//      dat[ord(Is_ExN)]:=FloatToStrF(I00,ffExponent,3,2);
//      dat[ord(Fb_ExN)]:=FloatToStrF(Fbb,ffGeneral,3,2);
//      dat[ord(Rsh_ExN)]:=FloatToStrF(Rsh,ffExponent,3,2);
//      dat[ord(If_ExN)]:=FloatToStrF(Iph,ffExponent,3,2);
//      dat[ord(Isc_ExN)]:=FloatToStrF(Isc,ffExponent,3,2);
//      dat[ord(Pm_ExN)]:=FloatToStrF(Pm,ffExponent,3,2);
//      dat[ord(Voc_ExN)]:=FloatToStrF(Voc,ffGeneral,4,3);
//      dat[ord(FF_ExN)]:=FloatToStrF(FF,ffGeneral,4,3);
      end;

   //обчислення шляхом апроксимації І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
   //функцією Ламберта
     if (Rs_Lam in ColNames) or (n_Lam in ColNames)
         or (Is_Lam in ColNames) or (Fb_Lam in ColNames)
         or (Rsh_Lam in ColNames) or (If_Lam in ColNames)
         or (Isc_Lam in ColNames) or (Voc_Lam in ColNames)
         or (Pm_Lam in ColNames) or (FF_Lam in ColNames)
         then
      begin
        if Iph_Lam then Ft:=TPhotoDiodLam.Create
                   else Ft:=TDiodLam.Create;
        Fit.FittingDiapazon(Vax,EvolParam,D[diLam]);
        dat[ord(Rs_Lam)]:=FloatToStrF(EvolParam[1],ffExponent,3,2);
        dat[ord(n_Lam)]:=FloatToStrF(EvolParam[0],ffGeneral,4,3);
        dat[ord(Is_Lam)]:=FloatToStrF(EvolParam[2],ffExponent,3,2);
        dat[ord(Rsh_Lam)]:=FloatToStrF(EvolParam[3],ffExponent,3,2);
        if Iph_Lam then
          begin
            dat[ord(Fb_Lam)]:='555';
            dat[ord(If_Lam)]:=FloatToStrF(EvolParam[4],ffExponent,3,2);
            dat[ord(Isc_Lam)]:=FloatToStrF(Fit.DodX[1],ffExponent,3,2);
            dat[ord(Pm_Lam)]:=FloatToStrF(Fit.DodX[2],ffExponent,3,2);
            dat[ord(Voc_Lam)]:=FloatToStrF(Fit.DodX[0],ffGeneral,4,3);
            dat[ord(FF_Lam)]:=FloatToStrF(Fit.DodX[3],ffGeneral,4,3);
          end
                  else
          begin
            dat[ord(Fb_Lam)]:=FloatToStrF(Fit.DodX[0],ffGeneral,4,3);
            dat[ord(If_Lam)]:='0';
            dat[ord(Isc_Lam)]:='0';
            dat[ord(Pm_Lam)]:='0';
            dat[ord(Voc_Lam)]:='0';
            dat[ord(FF_Lam)]:='0';
          end;

          Rsmy:=EvolParam[1];
          nmy:=EvolParam[0];
          Fbmy:=Fit.DodX[0];
          nnn:='Lam';


        Fit.Free;
//
// {}     ExpKalkNew(Vax,D[diLam],Mode_Lam,Iph_Lam,1,AA,Sk,nn,I00,Fbb,Rss,Rsh,Iph,Voc,Isc,Pm,FF);
//      dat[ord(Rs_Lam)]:=FloatToStrF(Rss,ffExponent,3,2);
//      dat[ord(n_Lam)]:=FloatToStrF(nn,ffGeneral,4,3);
//      dat[ord(Is_Lam)]:=FloatToStrF(I00,ffExponent,3,2);
//      dat[ord(Fb_Lam)]:=FloatToStrF(Fbb,ffGeneral,3,2);
//      dat[ord(Rsh_Lam)]:=FloatToStrF(Rsh,ffExponent,3,2);
//      dat[ord(If_Lam)]:=FloatToStrF(Iph,ffExponent,3,2);
//      dat[ord(Isc_Lam)]:=FloatToStrF(Isc,ffExponent,3,2);
//      dat[ord(Pm_Lam)]:=FloatToStrF(Pm,ffExponent,3,2);
//      dat[ord(Voc_Lam)]:=FloatToStrF(Voc,ffGeneral,4,3);
//      dat[ord(FF_Lam)]:=FloatToStrF(FF,ffGeneral,4,3);
//      {}

 {
//      A_B_Diapazon(False,Vax,Vax2,D[diDE]);
     // DifEvol (Vax2,RevShSCLC,0,EvolParam);
//      DifEvol (Vax,RevShTwo,0,EvolParam);
//      MABC (Vax,RevShTwo,0,EvolParam);
      DifEvol (Vax,RevShNew,0,EvolParam);
      dat[ord(Rs_Lam)]:=FloatToStrF(EvolParam[2],ffExponent,4,3);
      dat[ord(n_Lam)]:=FloatToStrF(EvolParam[1],ffGeneral,4,3);
      dat[ord(Is_Lam)]:=FloatToStrF(EvolParam[0],ffExponent,4,3);
 //     dat[ord(Voc_Lam)]:=FloatToStrF(EvolParam[3],ffExponent,4,3);
      CreateFile(ShotName+'tt.dat',Vax,EvolParam);
   }
 //  Str1:=TStringList.Create;


// str:=floattostrf(Vax^.T,ffGeneral,4,1);
{ SetCurrentDir('D:\Oleg\SAMPLE\LH\LH1\Final\temper1\S\');
 Read_File(Inttostr(round(abs(10*Volt[ij])))+'s.dat',Vax2);
 a:=abs(ChisloY(Vax2,Vax^.T));
 b:=abs(ChisloY(Vax,abs(Volt[ij])));
    if not((a=ErResult)or(b<1e-9)or(b>0.01)or(a=0))
        then
         begin
         SetLenVector(Vax3,Vax3^.n+1);
         Vax3^.X[Vax3^.n-1]:=Vax^.T;
         Vax3^.Y[Vax3^.n-1]:=(b-a)/a;
         end;
{ for i:= 0 to High(Volt) do
   begin
   SetCurrentDir('D:\Oleg\SAMPLE\LH\LH1\Final\temper1\S\');
   Read_File(Inttostr(round(abs(10*Volt[i])))+'s.dat',Vax2);

   a:=abs(ChisloY(Vax2,Vax^.T));
   b:=abs(ChisloY(Vax,abs(Volt[i])));
   if (a=ErResult)or(b<1e-9)or(b>0.01)
        then str:=str+' 0'
        else str:=str+' '+FloatToStrF((b-a)/a,ffExponent,4,0);

   end;
  Str1.Add(str);}

{  SetCurrentDir(CurDirectory);
{   for i:=2 to 41 do
     begin
   Str1.Add(FloatToStrF(i*0.1,ffExponent,4,0)+' '+
       FloatToStrF(RevZrizSCLC(1/(Vax^.T*Kb),-Tpow,II01[i],IA[i])+
                   RevZrizFun(1/(Vax^.T*Kb),2,II02[i],IE[i]),
                       ffExponent,4,0));

     end;

  Str1.SaveToFile(ShotName+'tt.dat');}
//  Str1.SaveToFile('del_rev.dat');
//  Str1.Free;

 {    KalkDiodTwo(Vax,D[diDE],AA,Sk,nn,I00,Fbb,Rss,Iph,FF);
      dat[ord(Rs_Lam)]:=FloatToStrF(Rss,ffExponent,4,3);
      dat[ord(n_Lam)]:=FloatToStrF(nn,ffGeneral,4,3);
      dat[ord(Is_Lam)]:=FloatToStrF(I00,ffExponent,4,3);
      dat[ord(Fb_Lam)]:=FloatToStrF(Fbb,ffGeneral,4,3);
      dat[ord(If_Lam)]:=FloatToStrF(Iph,ffExponent,4,3);
      dat[ord(Voc_Lam)]:=FloatToStrF(FF,ffGeneral,4,3);{}

 {    KalkDiodTwoFull(Vax,D[diDE],AA,Sk,nn,I00,Fbb,Rss,Iph,Voc,Isc);
      dat[ord(Rs_Lam)]:=FloatToStrF(Rss,ffExponent,4,3);
      dat[ord(n_Lam)]:=FloatToStrF(nn,ffGeneral,4,3);
      dat[ord(Is_Lam)]:=FloatToStrF(I00,ffExponent,4,3);
      dat[ord(Fb_Lam)]:=FloatToStrF(Fbb,ffGeneral,4,3);
      dat[ord(If_Lam)]:=FloatToStrF(Iph,ffExponent,4,3);
      dat[ord(Voc_Lam)]:=FloatToStrF(Voc,ffGeneral,4,3);
      dat[ord(Isc_Lam)]:=FloatToStrF(Isc,ffGeneral,4,3);{}

      end;


   //обчислення шляхом апроксимації
   //І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph,
   //еволюційні методи
     if (Rs_DE in ColNames) or (n_DE in ColNames)
         or (Is_DE in ColNames) or (Fb_DE in ColNames)
         or (Rsh_DE in ColNames) or (If_DE in ColNames)
         or (Isc_DE in ColNames) or (Voc_DE in ColNames)
         or (Pm_DE in ColNames) or (FF_DE in ColNames)
         then
      begin
        if Iph_DE then Fit:=TPhotoDiod.Create
                   else Fit:=TDiod.Create;
        Fit.FittingDiapazon(Vax,EvolParam,D[diDE]);
        dat[ord(Rs_DE)]:=FloatToStrF(EvolParam[1],ffExponent,3,2);
        dat[ord(n_DE)]:=FloatToStrF(EvolParam[0],ffGeneral,4,3);
        dat[ord(Is_DE)]:=FloatToStrF(EvolParam[2],ffExponent,3,2);
        dat[ord(Rsh_DE)]:=FloatToStrF(EvolParam[3],ffExponent,3,2);
        if Iph_DE then
          begin
            dat[ord(Fb_DE)]:='555';
            dat[ord(If_DE)]:=FloatToStrF(EvolParam[4],ffExponent,3,2);
            dat[ord(Isc_DE)]:=FloatToStrF(Fit.DodX[1],ffExponent,3,2);
            dat[ord(Pm_DE)]:=FloatToStrF(Fit.DodX[2],ffExponent,3,2);
            dat[ord(Voc_DE)]:=FloatToStrF(Fit.DodX[0],ffGeneral,4,3);
            dat[ord(FF_DE)]:=FloatToStrF(Fit.DodX[3],ffGeneral,4,3);
          end
                  else
          begin
            dat[ord(Fb_DE)]:=FloatToStrF(Fit.DodX[0],ffGeneral,4,3);
            dat[ord(If_DE)]:='0';
            dat[ord(Isc_DE)]:='0';
            dat[ord(Pm_DE)]:='0';
            dat[ord(Voc_DE)]:='0';
            dat[ord(FF_DE)]:='0';
          end;

          Rsmy:=EvolParam[1];
          nmy:=EvolParam[0];
          Fbmy:=Fit.DodX[0];
          nnn:='MABC';

        Fit.Free;
//
////     ExpKalkNew(Vax,D[diDE],Mode_DE,Iph_DE,2,AA,Sk,nn,I00,Fbb,Rss,Rsh,Iph,Voc,Isc,Pm,FF);
//     KalkOneDiod(Vax,D[diDE],Mode_DE,Iph_DE,EvolType,nn,I00,Rss,Rsh,Iph,Voc,Isc,Pm,FF);
//      dat[ord(Rs_DE)]:=FloatToStrF(Rss,ffExponent,4,3);
//      dat[ord(n_DE)]:=FloatToStrF(nn,ffGeneral,4,3);
//      dat[ord(Is_DE)]:=FloatToStrF(I00,ffExponent,4,3);
//      dat[ord(Fb_DE)]:=FloatToStrF(Kb*Vax^.T*ln(Sk*AA*sqr(Vax^.T)/I00),
//                                   ffGeneral,4,3);
//      dat[ord(Rsh_DE)]:=FloatToStrF(Rsh,ffExponent,4,3);
//      dat[ord(If_DE)]:=FloatToStrF(Iph,ffExponent,4,3);
//      dat[ord(Isc_DE)]:=FloatToStrF(Isc,ffExponent,4,3);
//      dat[ord(Pm_DE)]:=FloatToStrF(Pm,ffExponent,4,3);
//      dat[ord(Voc_DE)]:=FloatToStrF(Voc,ffGeneral,4,3);
//      dat[ord(FF_DE)]:=FloatToStrF(FF,ffGeneral,4,3);
      end;


   //обчислення шляхом апроксимації
   //І=I01*[exp(q(V-IRs)/n1kT)-1]+I02*[exp(q(V-IRs)/n2kT)-1]+(V-IRs)/Rsh-Iph,
   //еволюційні методи
     if (Rs_EA in ColNames) or (n1_EA in ColNames)
         or (Is1_EA in ColNames) or (n2_EA in ColNames) or (Is2_EA in ColNames)
         or (Rsh_EA in ColNames) or (If_EA in ColNames)
         or (Isc_EA in ColNames) or (Voc_EA in ColNames)
         or (Pm_EA in ColNames) or (FF_EA in ColNames)
         then
      begin
        if Iph_DE then Fit:=TDoubleDiodLight.Create
                   else Fit:=TDoubleDiod.Create;
        Fit.FittingDiapazon(Vax,EvolParam,D[diDE]);
        dat[ord(Rs_EA)]:=FloatToStrF(EvolParam[1],ffExponent,3,2);
        dat[ord(n1_EA)]:=FloatToStrF(EvolParam[0],ffGeneral,4,3);
        dat[ord(Is1_EA)]:=FloatToStrF(EvolParam[2],ffExponent,3,2);
        dat[ord(Rsh_EA)]:=FloatToStrF(EvolParam[3],ffExponent,3,2);
        dat[ord(n2_EA)]:=FloatToStrF(EvolParam[4],ffGeneral,4,3);
        dat[ord(Is2_EA)]:=FloatToStrF(EvolParam[5],ffExponent,3,2);
        if Iph_DE then
          begin
            dat[ord(If_EA)]:=FloatToStrF(EvolParam[6],ffExponent,4,3);
            dat[ord(Isc_EA)]:=FloatToStrF(Fit.DodX[1],ffExponent,4,3);
            dat[ord(Pm_EA)]:=FloatToStrF(Fit.DodX[2],ffExponent,4,3);
            dat[ord(Voc_EA)]:=FloatToStrF(Fit.DodX[0],ffGeneral,4,3);
            dat[ord(FF_EA)]:=FloatToStrF(Fit.DodX[3],ffGeneral,4,3);
          end
                  else
          begin
            dat[ord(If_EA)]:='0';
            dat[ord(Isc_EA)]:='0';
            dat[ord(Pm_EA)]:='0';
            dat[ord(Voc_EA)]:='0';
            dat[ord(FF_EA)]:='0';
          end;
        Fit.Free;

//
//     KalkTwoDiod(Vax,D[diDE],Mode_DE,Iph_DE,EvolType,nn,I00,n2,I02,Rss,Rsh,Iph,Voc,Isc,Pm,FF);
//      dat[ord(Rs_EA)]:=FloatToStrF(Rss,ffExponent,4,3);
//      dat[ord(n1_EA)]:=FloatToStrF(nn,ffGeneral,4,3);
//      dat[ord(Is1_EA)]:=FloatToStrF(I00,ffExponent,4,3);
//      dat[ord(n2_EA)]:=FloatToStrF(n2,ffGeneral,4,3);
//      dat[ord(Is2_EA)]:=FloatToStrF(I02,ffExponent,4,3);
//      dat[ord(Rsh_EA)]:=FloatToStrF(Rsh,ffExponent,4,3);
//      dat[ord(If_EA)]:=FloatToStrF(Iph,ffExponent,4,3);
//      dat[ord(Isc_EA)]:=FloatToStrF(Isc,ffExponent,4,3);
//      dat[ord(Pm_EA)]:=FloatToStrF(Pm,ffExponent,4,3);
//      dat[ord(Voc_EA)]:=FloatToStrF(Voc,ffGeneral,4,3);
//      dat[ord(FF_EA)]:=FloatToStrF(FF,ffGeneral,4,3);{}
      end;

    //обчислення за допомогою обраної функції
    if (LDateFun.Caption<>'None')and(CBDateFun.Checked) then
     begin
      FunCreate(LDateFun.Caption,Fit);
      Fit.Fitting(Vax,EvolParam);
//      showmessage(inttostr(ord(High(TColName))+1));
      for i:=0 to High(Fit.Xname) do
        dat[ord(High(TColName))+1+i]:=
           FloatToStrF(EvolParam[i],ffExponent,4,3);

//      showmessage(inttostr(ord(High(TColName))+1+High(Fit.Xname)+1));
      for i:=0 to High(Fit.DodXname) do
        dat[ord(High(TColName))+1+High(Fit.Xname)+1+i]:=
           FloatToStrF(Fit.DodX[i],ffExponent,4,3);
      Fit.Free;
     end;

// if Rsmy=ErResult then Continue;
// if abs((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T))>100 then  Continue;


 temp_str:=dat[ord(Tem)]+' '+
             FloatToStrF(Rs_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(Rsmy,ffExponent,5,4)+' '+
             FloatToStrF((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T)),ffExponent,5,4)+' '+
             FloatToStrF(Fb_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(Fbmy,ffExponent,5,4)+' '+
             FloatToStrF((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T)),ffExponent,5,4);

     Rsmyk:=Rsmyk+ln(abs((Rsmy-Rs_T(Vax^.T))/Rs_T(Vax^.T)));
     Fbmyk:=Fbmyk+ln(abs((Fbmy-Fb_T(Vax^.T))/Fb_T(Vax^.T)));
     inc(Nf);


     nameBool:=(nnn='Kam1')or(nnn='Kam2')or(nnn='Wer')or(nnn='Cib');

     if nameBool then
      temp_str:=temp_str+' '+
             FloatToStrF(FbmyE,ffExponent,5,4)+' '+
             FloatToStrF((FbmyE-Fb_T(Vax^.T))/Fb_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((FbmyE-Fb_T(Vax^.T))/Fb_T(Vax^.T)),ffExponent,5,4);


  if not(nnn='Nord') then
           begin
       temp_str:=temp_str+' '+
             FloatToStrF(n_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(nmy,ffExponent,5,4)+' '+
             FloatToStrF((nmy-n_T(Vax^.T))/n_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((nmy-n_T(Vax^.T))/n_T(Vax^.T)),ffExponent,5,4);
       nmyk:=nmyk+ln(abs((nmy-n_T(Vax^.T))/n_T(Vax^.T)));
           end;

     if nameBool then
       begin
      temp_str:=temp_str+' '+
             FloatToStrF(nmyE,ffExponent,5,4)+' '+
             FloatToStrF((nmyE-n_T(Vax^.T))/n_T(Vax^.T),ffExponent,5,4)+' '+
             FloatToStrF(sqr((nmyE-n_T(Vax^.T))/n_T(Vax^.T)),ffExponent,5,4);
     nmyEk:=nmyEk+ln(abs((nmyE-n_T(Vax^.T))/n_T(Vax^.T)));
     FbmyEk:=FbmyEk+ln(abs((FbmyE-Fb_T(Vax^.T))/Fb_T(Vax^.T)));


       end;
  Str1.Add(temp_str);



    i:=0;
    for CL:=Low(CL) to High(CL) do
      if (CL in ColNames) then
        begin
        StrGridData.Cells[i,StrGridData.RowCount-1]:=dat[ord(CL)];
        i:=i+1;
        end;
    StrGridData.Cells[StrGridData.ColCount-1,StrGridData.RowCount-1]:=IntToStr(SR.Time);
    if (LDateFun.Caption<>'None')and(CBDateFun.Checked) then
     begin
      FunCreate(LDateFun.Caption,Fit);

      for i:=0 to High(Fit.DodXname) do
        StrGridData.Cells[StrGridData.ColCount-2-i,StrGridData.RowCount-1]:=
           dat[High(dat)-i];
      for i:=0 to High(Fit.Xname) do
        StrGridData.Cells[StrGridData.ColCount-2-High(Fit.DodXname)-1-i,StrGridData.RowCount-1]:=
           dat[High(dat)-High(Fit.DodXname)-1-i];
      Fit.Free;
     end;

    StrGridData.RowCount:=StrGridData.RowCount+1;


    until FindNext(SR) <> 0;

   StrGridData.RowCount:=StrGridData.RowCount-1;
   SortGrid(StrGridData,0);
   StrGridData.ColCount:=StrGridData.ColCount-1;

   AssignFile(f,CurDirectory+'\'+'dates.dat');
   Rewrite(f);
   for j := 0 to StrGridData.RowCount-1 do
     begin
     for I := 0 to StrGridData.ColCount-1 do
                           write(f,StrGridData.Cells[i,j],' ');
     writeln(f);
     end;
    CloseFile(f);
    dispose(Vax);

    FindClose(SR);
//    MessageDlg('File dates.dat was created sucsesfully', mtInformation,[mbOk],0);
    if T_bool then MessageDlg('Some data can be equal 555 because temperuture is undefined', mtInformation,[mbOk],0);
  end
                                     else
          MessageDlg('No *.dat file in current directory', mtError,[mbOk],0);
//kkkkkkkkkkkkkkkkkkkkkkkk
{  Sorting(Vax3);
  Smoothing (Vax3,Vax4);
  Smoothing (Vax4,Vax3);
  Smoothing (Vax3,Vax4);
  a:=Ceil(Vax4^.X[0]/5)*5;
  SetLenVector(Vax3,0);
  repeat
    SetLenVector(Vax3,Vax3^.n+1);
    Vax3^.x[Vax3^.n-1]:=a;
    Vax3^.Y[Vax3^.n-1]:=ChisloY(Vax4,a);
    a:=a+5;
  until (a>Vax4^.x[High(Vax4^.x)]);
//  IVchar(Vax4,Vax3);
{  if ij=0 then
    begin
      str:='R';
      for j:= High(Vax3^.X) downto 0 do
        str:=str+' T'+IntToStr(round(Vax3^.X[j]));
      Str1.Add(str);
    end;

  str:=floattostrf(abs(Volt[ij]),ffGeneral,2,1);
  for j:= High(Vax3^.X) downto 0 do
    begin
    str:=str+' '+FloatToStrF(Vax3^.Y[j],ffExponent,4,0);
//    if j=0 then showmessage(floattostr(Volt[ij]));
    end;
  Str1.Add(str);
    {}
{      for j:= 0 to High(Vax3^.X) do
    Str1.Add(FloatToStrF(Vax3^.X[j],ffExponent,4,0)+' '+
             FloatToStrF(Vax3^.Y[j],ffExponent,4,0));
   Str1.SaveToFile('vv'+IntTostr(round(abs(10*Volt[ij])))+'.dat');
 {}

{  end;}
//kkkkkkkkkkkkkkkkkkkkkkk
//  dispose(Vax2);
//  dispose(Vax3);
//  dispose(Vax4);

 if (nnn='Nord') then
   temp_str:='T Rs Rs'+nnn+' delRs delRs2 Fb Fb'+nnn+' delFb delFb2';

 if nameBool then
   temp_str:='T Rs Rs'+nnn+' delRs delRs2 Fb Fb'+nnn+' delFb delFb2 Fb'+nnn+
            'Exp delFbE delFb2E n n'+nnn+' deln deln2 n'+nnn+'Exp delnE deln2E';

 if (not(nameBool))and(not(nnn='Nord')) then
   temp_str:='T Rs Rs'+nnn+' delRs delRs2 Fb Fb'+nnn+' delFb delFb2 n n'+nnn+' deln deln2 ';

  Str1.Insert(0,temp_str);


//  Str1.SaveToFile(nnn+'_'+
//                 copy(CurDirectory,
//                 LastDelimiter ('\',CurDirectory)+1,
//                 length(CurDirectory)-LastDelimiter ('\',CurDirectory))+
//                  '.dat');

  Str1.Clear;

  if (nnn='Nord') then
    begin
  Str1.Add('Rs'+nnn+'   Fb'+nnn);
  str1.Add(FloatToStrF(exp(Rsmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(Fbmyk/Nf),ffExponent,5,4));
    end;

 if nameBool then
   begin

  Str1.Add('Rs'+nnn+'   Fb'+nnn+'   n'+nnn+'   FbE'+nnn+'   nE'+nnn);
  str1.Add(FloatToStrF(exp(Rsmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(Fbmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(nmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(FbmyEk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(nmyEk/Nf),ffExponent,5,4));
   end;

 if (not(nameBool))and(not(nnn='Nord')) then
  begin
  Str1.Add('Rs'+nnn+'   Fb'+nnn+'   n'+nnn);
  str1.Add(FloatToStrF(exp(Rsmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(Fbmyk/Nf),ffExponent,5,4)
      +' '+FloatToStrF(exp(nmyk/Nf),ffExponent,5,4));
  end;

//  Str1.SaveToFile(nnn+'_E_'+
//                 copy(CurDirectory,
//                 LastDelimiter ('\',CurDirectory)+1,
//                 length(CurDirectory)-LastDelimiter ('\',CurDirectory))+
//                 '.dat');
  Str1.Free;
end;

procedure TForm1.ButtonCreateFileClick(Sender: TObject);
var
  SR : TSearchRec;
  mask,ShotName:string;
  Vax, tempVax:Pvector;
  j:integer;
  T_bool:boolean;
  Inform:TStringList;
  F:TextFile;
  DR:TDirName;
//  ttt:Pvector;
begin
T_bool:=False;
if not(SetCurrentDir(CurDirectory)) then
   begin
   MessageDlg('Current directory is not exist', mtError,[mbOk],0);
   Exit;
   end;
mask:='*.dat';
if FindFirst(mask, faAnyFile, SR) = 0 then
  begin
    new(Vax);
    new(tempVax);
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
     if ShotName[length(ShotName)-4]<>'N' then Continue;
     Read_File(SR.name,Vax);
     ShotName:=copy(ShotName,1,length(ShotName)-5);
     //в ShotName коротке ім'z файла - те що вводиться при вимірах :)
     Inform.Add(ShotName);
     Inform.Add('T='+FloatToStrF(Vax^.T,ffGeneral,4,1));

     if Vax^.T=0 then T_bool:=True;
     {встановлюється змінна, яка показує що є файли з невизначеною температурою}


     for DR := Low(DR) to High(DR) do
        if (DR in DirNames) then
      begin
      case DR of
       ForwRs:
        ForwardIVwithRs(Vax,tempVax,RsDefineCB(Vax,ComBForwRs,ComBForwRs_n));
{---------------------------------------------}
       Cheung:
        ChungFun(Vax,tempVax);
{---------------------------------------------}
       Hfunct:
        HFun(Vax,tempVax,Diod,nDefineCB(Vax,CombHfuncN,CombHfuncN_Rs));
{---------------------------------------------}
       Norde:
         NordeFun(Vax,tempVax,Diod,Gamma);
//begin
//  NordeFun(Vax,tempVax,AA,Sk,Gamma);
//  new(ttt);
//Splain3Vec(tempVax,tempVax^.X[0],0.01,ttt);
//  Write_File(CurDirectory+'\'+
//         GetEnumName(TypeInfo(TDirName),ord(DR))+'\'+ShotName+
//         'ttt.dat',ttt);
//  dispose(ttt);
//end;
{---------------------------------------------}
       Ideal:
         N_V_Fun(Vax,tempVax,RsDefineCB(Vax,ComBNRs,ComBNRs_n));
{---------------------------------------------}
       Nss:
         begin
        Nss_Fun(Vax,tempVax,
               FbDefineCB(Vax,ComboBNssFb,RsDefineCB(Vax,ComBNssRs,ComBNssRs_n)),
               RsDefineCB(Vax,ComBNssRs,ComBNssRs_n),
               Diod,D[diNss],RadButNssNvD.Checked);
          Sorting(tempVax)
         end;
{---------------------------------------------}
       Reverse:
        ReverseIV(Vax,tempVax);
{---------------------------------------------}
       Kamin1:
         Kam1_Fun(Vax,tempVax,D[diKam1]);
{---------------------------------------------}
       Kamin2:
         Kam2_Fun(Vax,tempVax,D[diKam2]);
{---------------------------------------------}
       Gromov1:
         Gr1_Fun(Vax,tempVax);
{---------------------------------------------}
       Gromov2:
         Gr2_Fun(Vax,tempVax,Diod);
{---------------------------------------------}
       Cibil:
         CibilsFun(Vax,D[diCib],tempVax);
{---------------------------------------------}
       Lee:
         LeeFun(Vax,D[diLee],tempVax);
{---------------------------------------------}
       Werner:
         WernerFun(Vax,tempVax);
{---------------------------------------------}
       MAlpha:
         MikhAlpha_Fun(Vax,tempVax);
{---------------------------------------------}
       MBetta:
         MikhBetta_Fun(Vax,tempVax);
{---------------------------------------------}
       MIdeal:
         MikhN_Fun(Vax,tempVax);
{---------------------------------------------}
       MRserial:
         MikhRs_Fun(Vax,tempVax);
{---------------------------------------------}
       Dit:
         Dit_Fun(Vax,tempVax,
                 RsDefineCB(Vax,ComBDitRs,ComBDitRs_n),
                 Diod,D[diIvan]);
{---------------------------------------------}
      Exp2F:
        Forward2Exp(Vax,tempVax,RsDefineCB(Vax,ComBExp2FRs,ComBExp2FRs_n));
{---------------------------------------------}
      Exp2R:
        Reverse2Exp(Vax,tempVax,RsDefineCB(Vax,ComBExp2RRs,ComBExp2RRs_n));
{---------------------------------------------}
       M_V:
         M_V_Fun(Vax,tempVax,CBM_Vdod.Checked,1);
{---------------------------------------------}
       Fow_Nor:
         M_V_Fun(Vax,tempVax,CBFow_Nordod.Checked,2);
{---------------------------------------------}
       Fow_NorE:
         M_V_Fun(Vax,tempVax,CBFow_NorEdod.Checked,3);
{---------------------------------------------}
       Abeles:
         M_V_Fun(Vax,tempVax,CBAbelesdod.Checked,4);
{---------------------------------------------}
       AbelesE:
         M_V_Fun(Vax,tempVax,CBAbelesEdod.Checked,5);
{---------------------------------------------}
       Fr_Pool:
         M_V_Fun(Vax,tempVax,CBFr_Pooldod.Checked,6);
{---------------------------------------------}
       Fr_PoolE:
         M_V_Fun(Vax,tempVax,CBFr_PoolEdod.Checked,7);
     end; //case
       Write_File(CurDirectory+'\'+
         GetEnumName(TypeInfo(TDirName),ord(DR))+'\'+ShotName+
         GetEnumName(TypeInfo(Tfile_end),ord(DR))+'.dat',tempVax);
       end;

    until FindNext(SR) <> 0;

    for DR := Low(DR) to High(DR) do
      if (DR in DirNames) then
       begin
        AssignFile(f,CurDirectory+'\'+
        GetEnumName(TypeInfo(TDirName),ord(DR))+'\'+'comments');
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
    dispose(Vax);
    dispose(tempVax);
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
//showmessage(floattostr(Lambert(1000)));
st:=CurDirectory;
SelectDirectory('Chose Directory','C:', CurDirectory);
ChooseDirect(Form1);
Directory:=CurDirectory;
end;

procedure TForm1.ButtonDelClick(Sender: TObject);
var st:string;
    temp:double;

begin
if (Sender as TButton).Name='ButtonDel' then
 begin
  temp:=Diod.Thick_i;
  st:=InputBox('Layer thickness',
               'Thickness of the interfacial insulator layer, [ ] = m',
               FloatToStrF(temp,ffExponent,3,2));
  StrToNumber(st, temp, temp);
  Diod.Thick_i:=temp;
 end;

if (Sender as TButton).Name='ButEps_i' then
 begin
  temp:=Diod.Eps_i;
  st:=InputBox('Layer permittivity',
               'Permittivity of the interfacial insulator layer',
               FloatToStrF(temp,ffExponent,3,2));
  StrToNumber(st, temp, temp);
  Diod.Eps_i:=temp;
 end;

if (Sender as TButton).Name='ButNd' then
 begin
  temp:=Diod.Nd;
  st:=InputBox('Carrier concentration',
               'Input carrier concentration, [ ] = m^(-3)',
                FloatToStrF(temp,ffExponent,3,2));
  StrToNumber(st, temp, temp);
  Diod.Nd:=temp;
 end;

if (Sender as TButton).Name='ButArea' then
 begin
  temp:=Diod.Area;
  st:=InputBox('Diode area',
               'Input contact area, [ ] = m^2',
               FloatToStrF(temp,ffExponent,3,2));
  StrToNumber(st, temp, temp);
  Diod.Area:=temp;
 end;

DiodOnForm;

end;

//procedure TForm1.ButtonEpClick(Sender: TObject);
//var st,stHint:string;
//    temp:double;
//begin
//temp:=ep;
//st:=FloatToStrF(ep,ffGeneral,3,2);
//stHint:='Permittivity of the interfacial insulator layer';
//st:=InputBox('Layer permittivity',stHint,st);
//StrToNumber(st, temp, ep);
//if ep<=0 then
//         begin
//         MessageDlg('Layer permittivity must be positive', mtError,[mbOk],0);
//         ep:=temp;
//         end;
//LabelEp.Caption:=FloatToStrF(ep,ffGeneral,3,2);
//end;

procedure TForm1.ButtonKalkClick(Sender: TObject);
var Fit:TFitFunctionAAA;
begin
LabelKalk1.Visible:=False;
LabelKalk2.Visible:=False;
LabelKalk3.Visible:=False;
Rss:=ErResult;
nn:=ErResult;
Fbb:=ErResult;
Krec:=ErResult;

if VaxFile^.T<=0 then
 begin
  case CBKalk.ItemIndex of
   0: ;
   {не вибрано спосіб апроксимції}
   1,7,8,9,12,13,15: MessageDlg('Only Rs can be calculated by this method,'+#10+#13+
                'because T is undefined',mtError, [mbOK], 0);
   {вибрано або метод Чюнга, або Камінського І та ІІ роду,
    або Громова І роду, або Сібілса, або Лі, або Міхелашвілі}
   2,3,4,5,10,11,14,16,17,18,19,20:
   {вибрано інший метод, де без температури нічого порахувати не можна}
      begin
       MessageDlg('Anything can not be calculated by this method,'+#10+#13+
                'because T is undefined',mtError, [mbOK], 0);
       Exit;
      end;
  end; //case
 end;  // if VaxFile^.T<=0 then

case CBKalk.ItemIndex of
 2,3:      nn:=nDefineCB(VaxFile,Form1.ComboBoxN,Form1.ComboBoxN_Rs);
 {4,}5,17,18:Rss:=RsDefineCB(VaxFile,Form1.ComboBoxRs,Form1.ComboBoxRs_n);
 16:       Rss:=RsDefineCB(VaxFile,ComboBoxNssRs,ComboBoxNssRs_n);
end;

//QueryPerformanceCounter(StartValue);

case CBKalk.ItemIndex of
  0: ; //не вибрано спосіб апроксамації
 //-------------------------------------------
  1: // обчислення за функцією Чюнга
    ChungKalk(VaxFile,D[diChung],Rss,nn);
 //-------------------------------------------------------------
   2:  // обчислення за Н-функцією
      HFunKalk(VaxFile,D[diHfunc],Diod,nn,Rss,Fbb);
 //--------------------------------------------------------------
   3:   // обчислення за функцією Норда
    NordKalk(VaxFile,D[diNord],Diod,Gamma,nn,Rss,Fbb);
//---------------------------------------------------------------
   4: //обчислення шляхом апроксимації І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
     begin
        if Iph_Exp then Ft:=TPhotoDiodLSM.Create
                   else Ft:=TDiodLSM.Create;
        Fit.FittingDiapazon(VaxFile,EvolParam,D[diExp]);
        Rss:=EvolParam[1];
        nn:=EvolParam[0];
        if Iph_Exp then Fbb:=ErResult
                   else Fbb:=Fit.DodX[0];
        Fit.Free;
     end;

//    ExpKalkNew(VaxFile,D[diExp],Mode_Exp,Iph_Exp,0,AA,Sk,nn,I00,Fbb,Rss,Rsh,Iph,Voc,Isc,Pm,FF);
{   I=I0(exp(V/nkT)-1)
     ExpKalk(VaxFile,D[diExp],Rss,AA,Sk,ApprExp,nn,I00,Fbb);}
//------------------------------------------------------------
   5: //обчислення шляхом апроксимації І=I0exp(V/nkT)
     ExKalk(1,VaxFile,D[diEx],Rss,Diod,nn,I00,Fbb);
//------------------------------------------------------------
  6: //Обчислення коефіцієнту випрямлення
     Krec:=Krect(VaxFile,Vrect);
//----------------------------------------------------------
  7: //Обчислення за функцією Камінськи І-роду
   Kam1Kalk(VaxFile,D[diKam1],Rss,nn);
 //--------------------------------------------------------
  8: //Обчислення за функцією Камінськи ІІ-роду
   Kam2Kalk(VaxFile,D[diKam2],Rss,nn);
 //--------------------------------------------------------
  9: //Обчислення за методом Громова І-роду
   Gr1Kalk (VaxFile,D[diGr1],Diod,Rss,nn,Fbb,I00);
 //--------------------------------------------------------
  10: //Обчислення за методом Громова ІI-роду
   Gr2Kalk (VaxFile,D[diGr2],Diod,Rss,nn,Fbb,I00);
 //--------------------------------------------------------
  11: //Обчислення за методом Бохліна
   BohlinKalk(VaxFile,D[diNord],Diod,Gamma1,Gamma2,Rss,nn,Fbb,I00);
 //--------------------------------------------------------
  12: //Обчислення за методом Сібілса
   CibilsKalk(VaxFile,D[diCib],Rss,nn);
 //--------------------------------------------------------
  13: //Обчислення за методом Лі
   LeeKalk (VaxFile,D[diLee],Diod,Rss,nn,Fbb,I00);
 //--------------------------------------------------------
  14: //Обчислення за методом Вернера
   WernerKalk(VaxFile,D[diWer],Rss,nn);
//--------------------------------------------------------
  15: //Обчислення за методом Міхелашвілі
   MikhKalk (VaxFile,D[diMikh],Diod,Rss,nn,I00,Fbb);
//--------------------------------------------------------
  16: //Обчислення за методом Іванова
     IvanovKalk(VaxFile,D[diIvan],Rss,Diod,Krec,Fbb);
//----------------------------------------------------
   17: //обчислення шляхом апроксимації І/[1-exp(-qV/kT)]=I0exp(V/nkT), пряма ділянка
     ExKalk(2,VaxFile,D[diE2F],Rss,Diod,nn,I00,Fbb);
//----------------------------------------------------
   18: //обчислення шляхом апроксимації І/[1-exp(-qV/kT)]=I0exp(V/nkT), зворотня ділянка
     ExKalk(3,VaxFile,D[diE2R],Rss,Diod,nn,I00,Fbb);
   19:  //апроксимація І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph функцією Ламберта
      begin
        if Iph_Lam then Ft:=TPhotoDiodLam.Create
                   else Ft:=TDiodLam.Create;
        Fit.FittingDiapazon(VaxFile,EvolParam,D[diLam]);
        Rss:=EvolParam[1];
        nn:=EvolParam[0];
        if Iph_Lam then Fbb:=ErResult
                   else Fbb:=Fit.DodX[0];
        Fit.Free;
      end;
//    ExpKalkNew(VaxFile,D[diLam],Mode_Lam,Iph_Lam,1,AA,Sk,nn,I00,Fbb,Rss,Rsh,Iph,Voc,Isc,Pm,FF);
   20: //функція І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph, метод differential evolution
      begin
        if Iph_DE then Fit:=TPhotoDiod.Create
                   else Fit:=TDiod.Create;
        Fit.FittingDiapazon(VaxFile,EvolParam,D[diDE]);
        Rss:=EvolParam[1];
        nn:=EvolParam[0];
        if Iph_DE then Fbb:=ErResult
                   else Fbb:=Fit.DodX[0];
        Fit.Free;
      end;
//
//    ExpKalkNew(VaxFile,D[diDE],Mode_DE,Iph_DE,2,AA,Sk,nn,I00,Fbb,Rss,Rsh,Iph,Voc,Isc,Pm,FF);
 end; //case;

//QueryPerformanceCounter(EndValue);
//QueryPerformanceFrequency(Freq);
//showmessage('tics='+inttostr(EndValue-StartValue)+#10+#13+
//             'time='+floattostr((EndValue-StartValue)/Freq)
//             +' s'+#10+#13+
//                'freq+'+inttostr(Freq));


case CBKalk.ItemIndex of
 2,3:         nn:=ErResult;
 {4,}5,17,18:   Rss:=ErResult;
 16:begin
    nn:=ErResult;
    Rss:=ErResult;
    end;
end;


LabelKalk1.Visible:=(Rss<>ErResult);
if LabelKalk1.Visible then
    LabelKalk1.Caption:='Rs='+FloatToStrF(Rss,ffExponent,3,2);
LabelKalk2.Visible:=(nn<>ErResult);
if LabelKalk2.Visible then
    LabelKalk2.Caption:='n='+FloatToStrF(nn,ffGeneral,4,3);
LabelKalk3.Visible:=(Fbb<>ErResult);
if LabelKalk3.Visible then
    LabelKalk3.Caption:='Фb='+FloatToStrF(Fbb,ffGeneral,3,2);
if not(LabelKalk2.Visible) then
 begin
  LabelKalk2.Visible:=(Krec<>ErResult);
  if LabelKalk2.Visible then
    case CBKalk.ItemIndex of
    6:LabelKalk2.Caption:='Krect='+FloatToStrF(Krec,ffGeneral,3,2);
    16:LabelKalk2.Caption:='del='+ FloatToStrF(Krec,ffExponent,2,1)+' m';
    end;
 end;
end;

procedure TForm1.ButtonKalkParClick(Sender: TObject);
begin



case CBKalk.ItemIndex of
  0: ;//не вибрано спосіб апроксамації
  6: //Обчислення коефіцієнту випрямлення
     ButtonParamRectClick(ButtonKalkPar);
  else
   begin
   ButtonParamCibClick(ButtonKalkPar);
   CBKalkChange(ButtonKalkPar);
   end;
 end //case
// //-------------------------------------------
//  1: // обчислення за функцією Чюнга
//     ButtonParamCibClick(ButtonKalkPar);
////    ButtonParamChungClick(ButtonKalkPar);
//  2:  // обчислення за Н-функцією
//    ButtonParamCibClick(ButtonKalkPar);
//  3:   // обчислення за функцією Норда
//    ButtonParamCibClick(ButtonKalkPar);
//  4: //обчислення шляхом апроксимації І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
//    ButtonParamCibClick(ButtonKalkPar);
//  5: //обчислення шляхом апроксимації І=I0exp(V/nkT)
//    ButtonParamCibClick(ButtonKalkPar);
//  7: //обчислення за функцією Камінськи І-роду
//    ButtonParamCibClick(ButtonKalkPar);
//  8: //обчислення за функцією Камінськи ІІ-роду
//    ButtonParamCibClick(ButtonKalkPar);
//  9: //обчислення за методом Громова І-роду
//    ButtonParamCibClick(ButtonKalkPar);
//  10: //обчислення за методом Громова ІI-роду
//    ButtonParamCibClick(ButtonKalkPar);
//  11: //обчислення за методом Бохліна
//    ButtonParamCibClick(ButtonKalkPar);
//  12: //обчислення за методом Сібліса
//    ButtonParamCibClick(ButtonKalkPar);
//  13: //обчислення за методом Лі
//    ButtonParamCibClick(ButtonKalkPar);
//  14: //обчислення за методом Вернера
//    ButtonParamCibClick(ButtonKalkPar);
//  15: //обчислення за методом Міхелешвілі
//    ButtonParamCibClick(ButtonKalkPar);
//  16: //обчислення за методом Іванова
//    ButtonParamCibClick(ButtonKalkPar);
//  17: //обчислення шляхом апроксимації І/[1-exp(-qV/kT)]=I0exp(V/nkT), пряма ділянка
//    ButtonParamCibClick(ButtonKalkPar);
//  18: //обчислення шляхом апроксимації І/[1-exp(-qV/kT)]=I0exp(V/nkT), зворотня ділянка
//    ButtonParamCibClick(ButtonKalkPar);
//  19: //апроксимація І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph функцією Ламберта
//    ButtonParamCibClick(ButtonKalkPar);
//  20: //функція І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph, метод differential evolution
//    ButtonParamCibClick(ButtonKalkPar);
// end; //case;
//CBKalkChange(ButtonKalkPar);
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
                IVChar(VaxTempLim, VaxGraph);
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
                IVChar(VaxTempLim, VaxGraph);
                DataToGraph(Series1,Series2,Graph,
                Graph.Title.Text.Strings[0],VaxGraph);
                MarkerHide(Form1);
                Form1.CBMarker.Checked:=False;
                end;
end;

//procedure TForm1.ButtonParamBhClick(Sender: TObject);
//var Gamma1tmp,Gamma2tmp:double;
//begin
//if BohlinForm.ShowModal=mrOk then
// begin
// Gamma1tmp:=Gamma1;
// Gamma2tmp:=Gamma2;
// if BohlinForm.EditGamma1.Text='' then Gamma1:=2
//                                  else
//          begin
//           try
//            Gamma1:=StrToFloat(BohlinForm.EditGamma1.Text);
//           except
//            on Exception : EConvertError do
//                   begin
//                   ShowMessage(Exception.Message);
//                   Gamma1:=Gamma1tmp;
//                   end;
//           end;//try
//          end;//else
// if BohlinForm.EditGamma2.Text='' then Gamma2:=2.5
//         else
//          begin
//           try
//            Gamma2:=StrToFloat(BohlinForm.EditGamma2.Text);
//           except
//            on Exception : EConvertError do
//                   begin
//                   ShowMessage(Exception.Message);
//                   Gamma2:=Gamma2tmp;
//                   end;
//           end;//try
//          end;//else
//if Gamma1<2 then
//            begin
//            Gamma1:=Gamma1tmp;
//            MessageDlg('Gamma must be more or equal 2', mtError,[mbOk],0);
//            end;
//if Gamma2<2 then
//            begin
//            Gamma2:=Gamma2tmp;
//            MessageDlg('Gamma must be more or equal 2', mtError,[mbOk],0);
//            end;
//if abs(Gamma2-Gamma1)<1e-3 then
//            begin
//            Gamma1:=Gamma1tmp;
//            Gamma2:=Gamma2tmp;
//            MessageDlg('Gamma1 cannot be equal Gamma2', mtError,[mbOk],0);
//            end;
// LabBohGam1.Caption:='gamma1 = '+FloatToStrF(Gamma1,ffGeneral,2,1);
// LabBohGam2.Caption:='gamma2 = '+FloatToStrF(Gamma2,ffGeneral,2,1);
// end;//if BohlinForm.ShowModal=mrOk
//end;

//procedure TForm1.ButtonParamChungClick(Sender: TObject);
//begin
//if ChungForm.ShowModal=mrOk then
//    begin
//      FormToDiap(ChungForm.LEXmin,ChungForm.LEYmin,
//         ChungForm.LEXmax,ChungForm.LEYMax,D[diChung]);
//      DiapShow(D[diChung],LabelChungXmin,LabelChungYmin,LabelChungXmax,LabelChungYmax);
//    end;
//end;

//procedure TForm1.ButtonParamE2FClick(Sender: TObject);
//begin
//if Ex2FForm.ShowModal=mrOk then
//    begin
//      FormToDiap(Ex2FForm.LEXmin,Ex2FForm.LEYmin,
//         Ex2FForm.LEXmax,Ex2FForm.LEYMax,D[diE2F]);
//      DiapShow(D[diE2F],LabelE2FXmin,LabelE2FYmin,LabelE2FXmax,LabelE2FYmax);
//    end;
//end;

//procedure TForm1.ButtonParamE2RClick(Sender: TObject);
//begin
//if Ex2RForm.ShowModal=mrOk then
//    begin
//      FormToDiap(Ex2RForm.LEXmin,Ex2RForm.LEYmin,
//         Ex2RForm.LEXmax,Ex2RForm.LEYMax,D[diE2R]);
//      DiapShow(D[diE2R],LabelE2RXmin,LabelE2RYmin,LabelE2RXmax,LabelE2RYmax);
//    end;
//end;

//procedure TForm1.ButtonParamExClick(Sender: TObject);
//begin
//if ExForm.ShowModal=mrOk then
//    begin
//      FormToDiap(ExForm.LEXmin,ExForm.LEYmin,
//         ExForm.LEXmax,ExForm.LEYMax,D[diEx]);
//      DiapShow(D[diEx],LabelExXmin,LabelExYmin,LabelExXmax,LabelExYmax);
//    end;
//end;

//procedure TForm1.ButtonParamExpClick(Sender: TObject);
//begin
//if ExpForm.ShowModal=mrOk then
//    begin
//      FormToDiap(ExpForm.LEXmin,ExpForm.LEYmin,
//         ExpForm.LEXmax,ExpForm.LEYMax,D[diExp]);
//      FormToMode(ExpForm.CB_Rs,ExpForm.CB_Rsh,ExpForm.CB_Iph,
//                 Mode_Exp,Iph_Exp);
//      DiapShow(D[diExp],LabelExpXmin,LabelExpYmin,LabelExpXmax,LabelExpYmax);
//      ModeShow(Mode_Exp,Iph_Exp,LabelExpRs,LabelExpRsh,LabelExpIph);
//    end;
//end;

//procedure TForm1.ButtonParamGr1Click(Sender: TObject);
//begin
//if GrIForm.ShowModal=mrOk then
//    begin
//      FormToDiap(GrIForm.LEXmin,GrIForm.LEYmin,
//         GrIForm.LEXmax,GrIForm.LEYMax,D[diGr1]);
//      DiapShow(D[diGr1],LabelGr1Xmin,LabelGr1Ymin,LabelGr1Xmax,LabelGr1Ymax);
//    end;
//end;

//procedure TForm1.ButtonParamGr2Click(Sender: TObject);
//begin
//if GrIIForm.ShowModal=mrOk then
//    begin
//      FormToDiap(GrIIForm.LEXmin,GrIIForm.LEYmin,
//         GrIIForm.LEXmax,GrIIForm.LEYMax,D[diGr2]);
//      DiapShow(D[diGr2],LabelGr2Xmin,LabelGr2Ymin,LabelGr2Xmax,LabelGr2Ymax);
//    end;
//end;

//procedure TForm1.ButtonParamHClick(Sender: TObject);
//begin
//if HfuncForm.ShowModal=mrOk then
//    begin
//      FormToDiap(HfuncForm.LEXmin,HfuncForm.LEYmin,
//         HfuncForm.LEXmax,HfuncForm.LEYMax,D[diHfunc]);
//      DiapShow(D[diHfunc],LabelHXmin,LabelHYmin,LabelHXmax,LabelHYmax);
//    end;
//end;

//procedure TForm1.ButtonParamIvanClick(Sender: TObject);
//begin
//if IvanovForm.ShowModal=mrOk then
//    begin
//      FormToDiap(IvanovForm.LEXmin,IvanovForm.LEYmin,
//         IvanovForm.LEXmax,IvanovForm.LEYMax,D[diIvan]);
//      DiapShow(D[diIvan],LabelIvanXmin,LabelIvanYmin,LabelIvanXmax,LabelIvanYmax);
//    end;
//end;

//procedure TForm1.ButtonParamKam1Click(Sender: TObject);
//begin
//if Kam1Form.ShowModal=mrOk then
//    begin
//      FormToDiap(Kam1Form.LEXmin,Kam1Form.LEYmin,
//         Kam1Form.LEXmax,Kam1Form.LEYMax,D[diKam1]);
//      DiapShow(D[diKam1],LabelKam1Xmin,LabelKam1Ymin,LabelKam1Xmax,LabelKam1Ymax);
//    end;
//end;

//procedure TForm1.ButtonParamKam2Click(Sender: TObject);
//begin
//if Kam2Form.ShowModal=mrOk then
//    begin
//      FormToDiap(Kam2Form.LEXmin,Kam2Form.LEYmin,
//         Kam2Form.LEXmax,Kam2Form.LEYMax,D[diKam2]);
//      DiapShow(D[diKam2],LabelKam2Xmin,LabelKam2Ymin,LabelKam2Xmax,LabelKam2Ymax);
//    end;
//end;

//procedure TForm1.ButtonParamLamClick(Sender: TObject);
//begin
//if LambForm.ShowModal=mrOk then
//    begin
//      FormToDiap(LambForm.LEXmin,LambForm.LEYmin,
//         LambForm.LEXmax,LambForm.LEYMax,D[diLam]);
//      FormToMode(LambForm.CB_Rs,LambForm.CB_Rsh,LambForm.CB_Iph,
//                 Mode_Lam,Iph_Lam);
//      DiapShow(D[diLam],LabelLamXmin,LabelLamYmin,LabelLamXmax,LabelLamYmax);
//      ModeShow(Mode_Lam,Iph_Lam,LabelLamRs,LabelLamRsh,LabelLamIph);
//    end;
//end;

//procedure TForm1.ButtonParamLeeClick(Sender: TObject);
//begin
//if LeeForm.ShowModal=mrOk then
//    begin
//      FormToDiap(LeeForm.LEXmin,LeeForm.LEYmin,
//         LeeForm.LEXmax,LeeForm.LEYMax,D[diLee]);
//      DiapShow(D[diLee],LabelLeeXmin,LabelLeeYmin,LabelLeeXmax,LabelLeeYmax);
//    end;
//end;

//procedure TForm1.ButtonParamMikhClick(Sender: TObject);
//begin
//if MikhelashviliForm.ShowModal=mrOk then
//    begin
//      FormToDiap(MikhelashviliForm.LEXmin,MikhelashviliForm.LEYmin,
//         MikhelashviliForm.LEXmax,MikhelashviliForm.LEYMax,D[diMikh]);
//      DiapShow(D[diMikh],LabelMikhXmin,LabelMikhYmin,LabelMikhXmax,LabelMikhYmax);
//    end;
//end;

//procedure TForm1.ButtonParamNordClick(Sender: TObject);
//begin
//if NordForm.ShowModal=mrOk then
//    begin
//      FormToDiap(NordForm.LEXmin,NordForm.LEYmin,
//         NordForm.LEXmax,NordForm.LEYMax,D[diNord]);
//      DiapShow(D[diNord],LabelNordXmin,LabelNordYmin,LabelNordXmax,LabelNordYmax);
//      if NordForm.EditGamma.Text='' then Gamma:=2
//         else
//          begin
//           try
//            StrToInt(NordForm.EditGamma.Text);
//           except
//            on Exception : EConvertError do
//                   begin
//                   ShowMessage(Exception.Message);
//                   Exit;
//                   end;
//           end;//try
//           Gamma:=StrToInt(NordForm.EditGamma.Text);
//          end;//else
//       if Gamma<2 then
//                  begin
//                    Gamma:=2;
//                    MessageDlg('Gamma must be integer and more 1', mtError,[mbOk],0);
//                  end;
//      LabelNordGamma.Caption:='gamma: '+IntToStr(Gamma);
//    end;
//end;

//procedure TForm1.ButtonParamNssClick(Sender: TObject);
//begin
//if NssForm.ShowModal=mrOk then
//    begin
//      FormToDiap(NssForm.LEXmin,NssForm.LEYmin,
//         NssForm.LEXmax,NssForm.LEYMax,D[diNss]);
//      DiapShow(D[diNss],LabelNssXmin,LabelNssYmin,LabelNssXmax,LabelNssYmax);
//    end;
//end;

procedure TForm1.ButtonParamRectClick(Sender: TObject);
var st, stHint:string;
begin
st:=FloatToStrF(Vrect,ffGeneral,3,2);

stHint:='Enter rectification voltage Vrec;'+Chr(13)+Chr(13)+
       'The rectification coeficient' +Chr(13)+
       'Kr = Iforward(Vrec) / Ireverse(Vrec)'+Chr(13);

st:=InputBox('Input rectification voltage',stHint,st);
StrToNumber(st, 0.12, Vrect);
LabelRect.Caption:=FloatToStrF(Vrect,ffGeneral,3,2)+' V';
end;

//procedure TForm1.ButtonParamWerClick(Sender: TObject);
//begin
//if WernerForm.ShowModal=mrOk then
//    begin
//      FormToDiap(WernerForm.LEXmin,WernerForm.LEYmin,
//         WernerForm.LEXmax,WernerForm.LEYMax,D[diWer]);
//      DiapShow(D[diWer],LabelWerXmin,LabelWerYmin,LabelWerXmax,LabelWerYmax);
//    end;
//end;

procedure TForm1.ButtonParamCibClick(Sender: TObject);
begin
FormDiapazon(DiapFunName(Sender, BohlinMethod));
//if CibilsForm.ShowModal=mrOk then
//    begin
//      FormToDiap(CibilsForm.LEXmin,CibilsForm.LEYmin,
//         CibilsForm.LEXmax,CibilsForm.LEYMax,D[diCib]);
//      DiapShow(D[diCib],LabelCibXmin,LabelCibYmin,LabelCibXmax,LabelCibYmax);
//    end;
end;

//procedure TForm1.ButtonParamDEClick(Sender: TObject);
//begin
//if DEForm.ShowModal=mrOk then
//    begin
//      FormToDiap(DEForm.LEXmin,DEForm.LEYmin,
//         DEForm.LEXmax,DEForm.LEYMax,D[diDE]);
//      FormToMode(DEForm.CB_Rs,DEForm.CB_Rsh,DEForm.CB_Iph,
//                 Mode_DE,Iph_DE);
//      case DEForm.RG.ItemIndex of
//        1:EvolType:=TMABC;
//        2:EvolType:=TTLBO;
//        3:EvolType:=TPSO;
//       else EvolType:=TDE;
//      end;
//      case EvolType of
//       TMABC:GroupBoxParamDE.Caption:='MABC';
//       TTLBO:GroupBoxParamDE.Caption:='TLBO';
//       TPSO:GroupBoxParamDE.Caption:='PSO';
//       else GroupBoxParamDE.Caption:='DE';
//      end;
//
//      DiapShow(D[diDE],LabelDEXmin,LabelDEYmin,LabelDEXmax,LabelDEYmax);
//      ModeShow(Mode_DE,Iph_DE,LabelDERs,LabelDERsh,LabelDEIph);
//    end;
//end;

//procedure TForm1.ButtonPermClick(Sender: TObject);
//var st,stHint:string;
//    temp:double;
//begin
//temp:=eps;
//st:=FloatToStrF(eps,ffGeneral,3,2);
//stHint:='Input semiconductor relative permittivity';
//st:=InputBox('Semiconductor permittivity',stHint,st);
//StrToNumber(st, temp, eps);
//if eps<=0 then
//         begin
//         MessageDlg('Semiconductor permittivity must be positive', mtError,[mbOk],0);
//         eps:=temp;
//         end;
//LabelPerm.Caption:=FloatToStrF(eps,ffGeneral,3,2);
//end;
//
//procedure TForm1.ButtonRichClick(Sender: TObject);
//var st,stHint:string;
//    temp:double;
//begin
//temp:=AA;
//st:=FloatToStrF(AA,ffExponent,3,2);
//stHint:='Input effective Richardson constant, '+#10+'[ ] = A/(m K)^2';
//st:=InputBox('Richardson constant',stHint,st);
//StrToNumber(st, temp, AA);
//if AA<=0 then
//         begin
//         MessageDlg('Richardson constant must be positive', mtError,[mbOk],0);
//         AA:=temp;
//         end;
//LabelRich.Caption:=FloatToStrF(AA,ffExponent,3,2);
//end;

procedure TForm1.ButtonVoltClick(Sender: TObject);
var
  SR : TSearchRec;
  mask,ShotName:string;
  Vax:Pvector;
  i,j,k{,nt,T}:integer;
  F:TextFile;
  Grid:TStringGrid;
  Cur,Rs{,a,b}:double;
  StrRez,StrAppr:TStringList;
//  str:string;

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
    new(Vax);
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
       end;

    repeat
     ShotName:=AnsiUpperCase(SR.name);
     if ShotName[length(ShotName)-4]<>'N' then Continue;
     Read_File(SR.name,Vax);
     ShotName:=copy(ShotName,1,length(ShotName)-5);
     //в ShotName коротке ім'z файла - те що вводиться при вимірах :)
     if length(ShotName)<3 then insert('0',ShotName,1);
     if length(ShotName)<3 then insert('0',ShotName,1);

     Grid.Cells[0,Grid.RowCount-1]:=ShotName;
     {mask:=TimeToStr(FileDateToDateTime (SR.Time));
     delete(mask,length(mask)-2,3);
     Grid.Cells[1,Grid.RowCount-1]:=mask;}
     Grid.Cells[1,Grid.RowCount-1]:=Vax^.time;
     Grid.Cells[2,Grid.RowCount-1]:=FloatToStrF(Vax^.T,ffGeneral,4,1);
     if Vax^.T=0 then Grid.Cells[3,Grid.RowCount-1]:='555'
                 else Grid.Cells[3,Grid.RowCount-1]:=FloatToStrF(1/Kb/Vax^.T,ffGeneral,4,2);
     Grid.Cells[Grid.ColCount-1,Grid.RowCount-1]:=IntToStr(SR.Time);

     for I := 0 to High(Volt) do
     begin
       Cur:=abs(ChisloY(Vax,Volt[i]));
       Grid.Cells[k*i+4,Grid.RowCount-1]:=FloatToStrF(Cur,ffExponent,4,3);
       if (CheckBoxLnIT2.Checked)then
           if ((Vax^.T)>0)and(Cur<>ErResult)
                         then Grid.Cells[k*i+1+4,Grid.RowCount-1]:=
                                  FloatToStrF(ln(Cur/sqr(Vax^.T)),ffExponent,5,4)
                         else Grid.Cells[k*i+1+4,Grid.RowCount-1]:='555';

       Rs:=RsDefineCB(Vax,ComBDateExRs,ComBDateExRs_n);
       ExKalk(1,Vax,D[diEx],Rs,Diod,nn,I00,Fbb);

       if (CheckBoxnLnIT2.Checked)and(not(CheckBoxLnIT2.Checked)) then
           if ((Vax^.T)>0)and(Cur<>ErResult)and(nn<>ErResult)
                         then Grid.Cells[k*i+1+4,Grid.RowCount-1]:=
                                  FloatToStrF(nn*ln(Cur/sqr(Vax^.T)),ffExponent,5,4)
                         else Grid.Cells[k*i+1+4,Grid.RowCount-1]:='555';
       if k=3 then
           if ((Vax^.T)>0)and(Cur<>ErResult)and(nn<>ErResult)
                         then Grid.Cells[k*i+2+4,Grid.RowCount-1]:=
                                  FloatToStrF(nn*ln(Cur/sqr(Vax^.T)),ffExponent,5,4)
                         else Grid.Cells[k*i+2+4,Grid.RowCount-1]:='555';
     end;
    Grid.RowCount:=Grid.RowCount+1;
    until FindNext(SR) <> 0;

   Grid.RowCount:=Grid.RowCount-1;
   SortGrid(Grid,0);
   Grid.ColCount:=Grid.ColCount-1;

   StrRez:=TStringList.Create;
   StrAppr:=TStringList.Create;
{//   StrRez.Add('V I01 E1 I02 E2');
//   StrRez.Add('V I01 A I02 E');
//   StrRez.Add('V I01 Tc I02 E');
   str:='555 ';
   T:=130;
   repeat
     str:=str+inttostr(T)+' ';
     T:=T+5;
   until (T>330);
   StrRez.Add(str);
}
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

    if Grid.RowCount<2 then Continue;
    SetLenVector(Vax,Grid.RowCount-1);
    for j := 1 to Grid.RowCount-1 do
      begin
       Vax^.X[j-1]:=StrToFloat(Grid.Cells[3,j]);
       Vax^.Y[j-1]:=StrToFloat(Grid.Cells[k*i+4,j]);
      end;
    Sorting (Vax);
    for j:= 0 to High(Vax^.X) do
      if Vax^.Y[j]<9e-8 then Break;
    if j<Vax^.n-1 then SetLenVector(Vax,j);

//    for j:= 0 to High(Vax^.X) do
//      Vax^.X[j]:=1/(Vax^.X[j]*Kb);

{}  Write_File(CurDirectory+'\Zriz\'+
       Inttostr(round(abs(10*Volt[i])))+'s.dat',Vax);

{  repeat
     try
//       DifEvol (Vax,RevZriz,0,EvolParam)
       DifEvol (Vax,RevZriz2,0,EvolParam)
//       DifEvol (Vax,RevZriz3,0,EvolParam)
      except
        SetLength(EvolParam,1);
        EvolParam[0]:=ErResult;
       end;
  until((EvolParam[0]<>ErResult)and(EvolParam[3]>0.4));

      if EvolParam[0]=ErResult then  Continue;

       for j := 0 to High(Vax^.X) do
               begin
//               a:=EvolParam[0]*exp(-EvolParam[1]*Vax^.X[j])*Power(Vax^.X[j]*Kb,Tpow);
               a:=RevZrizSCLC(Vax^.X[j],-Tpow,EvolParam[0],EvolParam[1]);
//               a:=EvolParam[0]*exp(-Power((EvolParam[1]*Vax^.X[j]*Kb),0.25))*Power(Vax^.X[j]*Kb,-2);
               b:=RevZrizFun(Vax^.X[j],2,EvolParam[2],EvolParam[3]);
               StrAppr.Add(FloatToStrF(Vax^.X[j],ffExponent,4,0)+' '+
                       FloatToStrF(Vax^.Y[j],ffExponent,4,0)+' '+
                       FloatToStrF(a,ffExponent,4,0)+' '+
                       FloatToStrF(b,ffExponent,4,0)+' '+
                       FloatToStrF(a+b,ffExponent,4,0));
               end;
}
{        StrAppr.SaveToFile(CurDirectory+'\Zriz\'+'vol'+mask+'t.dat');
        StrAppr.Clear;
{
   str:=FloatToStrF(abs(Volt[i]),ffExponent,4,0)+' ';
   T:=130;
   repeat
     a:=RevZrizSCLC(1/(T*Kb),-Tpow,EvolParam[0],EvolParam[1]);
     b:=RevZrizFun(1/(T*Kb),2,EvolParam[2],EvolParam[3]);
     a:=a/(a+b);
//     a:=RevZrizSCLC(1/(T*Kb),-Tpow,II01[round(abs(Volt[i])*10)],IA[round(abs(Volt[i])*10)]);
     b:=RevZrizSCLC(1/(T*Kb),-Tpow,II01[round(abs(Volt[i])*10)],IA[round(abs(Volt[i])*10)]);
     b:=b/(b+RevZrizFun(1/(T*Kb),2,II02[round(abs(Volt[i])*10)],IE[round(abs(Volt[i])*10)]));
//     str:=str+FloatToStrF(a/(a+b),ffExponent,4,0)+' ';
     str:=str+FloatToStrF(b-a,ffExponent,4,0)+' ';
     T:=T+5;
   until (T>330);
   str:=str+FloatToStrF(EvolParam[3],ffExponent,4,0);
   StrRez.Add(str);

     {   StrRez.Add(FloatToStrF(abs(Volt[i]),ffExponent,4,0)+' '+
                   FloatToStrF(EvolParam[0],ffExponent,4,0)+' '+
                   FloatToStrF(EvolParam[1],ffExponent,4,0)+' '+
                   FloatToStrF(EvolParam[2],ffExponent,4,0)+' '+
                   FloatToStrF(EvolParam[3],ffExponent,4,0));
      }
    end;
{     StrRez.SaveToFile(CurDirectory+'\Zriz\sqr.dat');
 }
    dispose(Vax);
    FindClose(SR);
    Grid.Free;
    StrRez.Free;
    StrAppr.Free;
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

//procedure TForm1.CBApprChange(Sender: TObject);
//begin
// LAppr.Caption:=ApprFormula.Strings[CBAppr.ItemIndex];
// ApproxHide(Form1);
//end;

procedure TForm1.CBDateFunClick(Sender: TObject);
var i:integer;
begin
ColParam(Form1.StrGridData);
if LDateFun.Caption='None' then Exit;
if CBDateFun.Checked then
       begin
//        if LDateFun.Caption='None' then Exit;
        FunCreate(LDateFun.Caption,Fit);
        if  not(Assigned(Fit)) then Exit;

        for i:=0 to High(Fit.Xname) do
          begin
          StrGridData.ColCount:=StrGridData.ColCount+1;
          StrGridData.Cells[StrGridData.ColCount-1, 0]:=Fit.Xname[i];
          StrGridData.Cells[StrGridData.ColCount-1, 1]:='';
          end;
//        for i:=0 to High(Fit.DodXname) do
//          begin
//          StrGridData.ColCount:=StrGridData.ColCount+1;
//          StrGridData.Cells[StrGridData.ColCount-1, 0]:=Fit.DodXname[i];
//          StrGridData.Cells[StrGridData.ColCount-1, 1]:='';
//          end;

        Fit.Free;
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
  4: //обчислення шляхом апроксимації І=I0(exp(V/nkT)-1)
     DiapToLimToTForm1(D[diExp],Form1);
  5: //обчислення шляхом апроксимації І=I0exp(V/nkT)
     DiapToLimToTForm1(D[diEx],Form1);
  6:; //Обчислення коефіцієнту випрямлення
  7:; //обчислення за функцією Камінськи І-роду
  8:; //обчислення за функцією Камінськи ІІ-роду
  9: //обчислення за методом Громова І-роду
     DiapToLimToTForm1(D[diGr1],Form1);
  10: //обчислення за методом Громова ІI-роду
     DiapToLimToTForm1(D[diGr2],Form1);
  12: //обчислення за методом Сібілса
     DiapToLimToTForm1(D[diCib],Form1);
  13: //обчислення за методом Лі
     DiapToLimToTForm1(D[diLee],Form1);
  14: //обчислення за методом Вернера
     DiapToLimToTForm1(D[diWer],Form1);
  15: //обчислення за методом Міхелешвілі
     DiapToLimToTForm1(D[diMikh],Form1);
  16: //обчислення за методом Іванова
     DiapToLimToTForm1(D[diIvan],Form1);
  17: //обчислення шляхом апроксимації І/[1-exp(-qV/kT)]=I0exp(V/nkT), пряма ділянка
     DiapToLimToTForm1(D[diE2F],Form1);
  18: //обчислення шляхом апроксимації І/[1-exp(-qV/kT)]=I0exp(V/nkT), зворотня ділянка
     DiapToLimToTForm1(D[diE2R],Form1);
  19: //апроксимація І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph функцією Ламберта
     DiapToLimToTForm1(D[diLam],Form1);
  20: //функція І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph, метод differential evolution
     DiapToLimToTForm1(D[diDE],Form1);
  end; //case;
end;

procedure TForm1.CBMarkerClick(Sender: TObject);
var i:integer;
    bool:boolean;
begin
if CBMarker.Checked then
  begin
   MarkerDraw(VaxGraph,VaxFile,round(VaxGraph.n/2),Form1);
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
   TrackBarMar.Max:=VaxGraph^.n-1;
   TrackBarMar.Position:=round(VaxGraph.n/2);
  end
                    else
  begin
   MarkerHide(Form1);
  end;
end;

procedure TForm1.CBMaterialChange(Sender: TObject);
var ConfigFile:TIniFile;
begin
if (Semi.Name=Materials[High(TMaterialName)].Name)
//MaterialName[High(MaterialName)])
     and(Semi.Name<>CBMaterial.Text) then
      begin
       ConfigFile:=TIniFile.Create(Directory0+'\Shottky.ini');
       Semi.WriteToIniFile(ConfigFile);
       ConfigFile.Free;
      end;
if (CBMaterial.Text=Materials[High(TMaterialName)].Name)
     and(Semi.Name<>CBMaterial.Text) then
      begin
       Semi.ChangeMaterial(TMaterialName(CBMaterial.ItemIndex));
       ConfigFile:=TIniFile.Create(Directory0+'\Shottky.ini');
       Semi.ReadFromIniFile(ConfigFile);
       ConfigFile.Free;
//       Exit;
      end;
if Semi.Name<>CBMaterial.Text then Semi.ChangeMaterial(TMaterialName(CBMaterial.ItemIndex));
MaterialOnForm;
//showmessage(floattostr(Semi.ARich));
end;

//procedure TForm1.CBoxApprClick(Sender: TObject);
//const Np=150; //кількість точок, по яким будується апроксимація
//var h:double; //крок між точками
//    y,x,xl,a,b,c,d,e,f{,g}:double;
// {   IREap:IRE;}
//    i{,rez}:integer;
//    tempVax:Pvector;
//     Str1:TStringList;
////     F:TFitFunction;
//
//Function Linear(x,a,b:double):double;
//begin
//Result:=a+b*x;
//end;
//
//Function Parab(x,a,b,c:double):double;
//begin
//  Result:=a+b*x+c*x*x;
//end;
//
//Function ExpIE(x,a,b:double):double;
////y=a[exp(x/b)-1]
//begin
//  Result:=a*(exp(x/b)-1);
//end;
//
//Function ExpIERsh(x,a,b,c:double):double;
////y=a[exp(x/b)-1]+x/c;
//begin
//  Result:=a*(exp(x/b)-1)+x/c;
//end;
//
//Function Gromov(x,a,b,c:double):double;
//begin
//  Result:=a+b*x+c*ln(x);
//end;
//
//Procedure Ivanov(x0,AA,Szr,T,Nd,ep,del,Fb:double;var x,y:double);
//var Vd:double;
//begin
//  Vd:=del*sqrt(2*Qelem*Nd*ep/Eps0)*(sqrt(Fb)-sqrt(Fb-x0));
//  x:=Vd+x0;
//  y:=AA*Szr*T*T*exp(-Fb/Kb/T)*exp(x0/Kb/T);
//end;
//
//begin
//if CBoxAppr.Checked then
//    begin
//      new(tempVax);
//      tempVax.n:=VaxGraph.n;
//      SetLength(tempVax^.X, tempVax^.n);
//      SetLength(tempVax^.Y, tempVax^.n);
//
//      for i := 0 to High(tempVax^.X)do
//      begin
//        if XLogCheck.Checked then tempVax^.X[i]:=Log10(VaxGraph^.X[i])
//                             else tempVax^.X[i]:=VaxGraph^.X[i];
//        if YLogCheck.Checked then tempVax^.Y[i]:=Log10(VaxGraph^.Y[i])
//                             else tempVax^.Y[i]:=VaxGraph^.Y[i];
//      end;
//
//
//      h:=(Series1.MaxXValue-Series1.MinXValue)/Np;
//      Series4.Clear;
//      case CBAppr.ItemIndex of
//       0:  //не вибрано спосіб апроксимації
//           begin
//{            F:=TPhotodiod.Create;
//
//            F.FittingGraphFile(VaxGraph,EvolParam,Series4);
//            Series4.Active:=True;
//            if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//            MemoAppr.Lines.Add('');
//            MemoAppr.Lines.Add(VaxFile.name);
//            MemoAppr.Lines.Add(SButFit.Caption);
//            for I := 0 to F.Ns-1 do
//               MemoAppr.Lines.Add(F.Xname[i]+'='+
//                        FloatToStrF(EvolParam[i],ffExponent,4,3));
//            F.Free;
// }
//{
//  F:=TDiodLSM.Create;
//  F.AproxN(VaxGraph,EvolParam);
//            if EvolParam[0]=ErResult then
//                 begin
//                  MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
//                  CBoxAppr.Checked:=False;
//                  dispose(tempVax);
//                  Exit;
//                 end;
//           for I := 0 to Np do
//              begin
//              x:=Series1.MinXValue+i*h;
//              y:=Full_IV(x,EvolParam[0]*Kb*VaxFile^.T,EvolParam[1],EvolParam[2],EvolParam[3],0);
//              Series4.AddXY(x, y);
//              end;
//   Series4.Active:=True;
//   if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//   if ((SButFit.Caption<>'Smoothing')and
//       (SButFit.Caption<>'Median filtr')and
//       (SButFit.Caption<>'Derivative'))
//       then
//        begin
//         MemoAppr.Lines.Add('');
//         MemoAppr.Lines.Add(VaxFile.name);
//         MemoAppr.Lines.Add(SButFit.Caption);
//        end;
//   for I := 0 to F.Ns-1 do
//               MemoAppr.Lines.Add(F.Xname[i]+'='+
//                        FloatToStrF(EvolParam[i],ffExponent,4,3));
//   for I := 0 to High(F.DodX) do
//               MemoAppr.Lines.Add(F.DodXname[i]+'='+
//                        FloatToStrF(F.DodX[i],ffExponent,4,3));
//  F.Free;
//{}
// {          try
////           DifEvol (VaxGraph,RevShNew2,0,EvolParam)
//           MABC (VaxGraph,RevShNew2,0,EvolParam)
//           except
//           SetLength(EvolParam,1);
//           EvolParam[0]:=ErResult;
//           end;
//            if EvolParam[0]=ErResult then
//                 begin
//                  MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
//                  CBoxAppr.Checked:=False;
//                  dispose(tempVax);
//                  Exit;
//                 end;
//           Str1:=TStringList.Create;
//
//            for I := 0 to High(VaxGraph^.x) do
//               begin
//               a:=RevShNewFun(VaxGraph^.X[i],VaxGraph^.T,EvolParam[0],EvolParam[1],EvolParam[2]);
//               b:=RevShNewFun(VaxGraph^.X[i],VaxGraph^.T,EvolParam[3],EvolParam[4],0);
//               Str1.Add(FloatToStrF(VaxGraph^.X[i],ffExponent,4,0)+' '+
//                       FloatToStrF(VaxGraph^.Y[i],ffExponent,4,0)+' '+
//                       FloatToStrF(a,ffExponent,4,0)+' '+
//                       FloatToStrF(b,ffExponent,4,0)+' '+
//                       FloatToStrF(a+b,ffExponent,4,0));
//               end;
//            Str1.SaveToFile('000.dat');
//            Str1.Free;
//
//           for I := 0 to Np do
//              begin
//              x:=Series1.MinXValue+i*h;
//              y:=RevShNewFun(x,VaxGraph^.T,EvolParam[0],EvolParam[1],EvolParam[2])
//                 +RevShNewFun(x,VaxGraph^.T,EvolParam[3],EvolParam[4],0);
//              Series4.AddXY(x, y);
//              end;
//           Series4.Active:=True;
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
//           MemoAppr.Lines.Add('I01='+ FloatToStrF(EvolParam[0],ffExponent,4,3));
//           MemoAppr.Lines.Add('Al1='+ FloatToStrF(EvolParam[1],ffExponent,4,3));
//           MemoAppr.Lines.Add('Bt='+ FloatToStrF(EvolParam[2],ffGeneral,4,3));
//           MemoAppr.Lines.Add('I02='+ FloatToStrF(EvolParam[3],ffExponent,4,3));
//           MemoAppr.Lines.Add('Al2='+ FloatToStrF(EvolParam[4],ffExponent,4,3));
//           {}
//
// {          try
//           DifEvol (VaxGraph,RevShNew,0,EvolParam)
//           except
//           SetLength(EvolParam,1);
//           EvolParam[0]:=ErResult;
//           end;
//            if EvolParam[0]=ErResult then
//                 begin
//                  MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
//                  CBoxAppr.Checked:=False;
//                  dispose(tempVax);
//                  Exit;
//                 end;
//           Str1:=TStringList.Create;
//
//            for I := 0 to High(VaxGraph^.x) do
//               begin
//               Str1.Add(FloatToStrF(VaxGraph^.X[i],ffExponent,4,0)+' '+
//                       FloatToStrF(VaxGraph^.Y[i],ffExponent,4,0)+' '+
//                       FloatToStrF(RevShNewFun(VaxGraph^.X[i],VaxGraph^.T,EvolParam[0],EvolParam[1],EvolParam[2]),ffExponent,4,0));
//               end;
//            Str1.SaveToFile('000.dat');
//            Str1.Free;
//
//           for I := 0 to Np do
//              begin
//              x:=Series1.MinXValue+i*h;
//              y:=RevShNewFun(x,VaxGraph^.T,EvolParam[0],EvolParam[1],EvolParam[2]);
//              Series4.AddXY(x, y);
//              end;
//           Series4.Active:=True;
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
//           MemoAppr.Lines.Add('I0='+ FloatToStrF(EvolParam[0],ffExponent,4,3));
//           MemoAppr.Lines.Add('Al='+ FloatToStrF(EvolParam[1],ffExponent,4,3));
//           MemoAppr.Lines.Add('Bt='+ FloatToStrF(EvolParam[2],ffGeneral,4,3));
//           {}
// {          try
//           DifEvol (VaxGraph,Tun,0,EvolParam)
//           except
//           SetLength(EvolParam,1);
//           EvolParam[0]:=ErResult;
//           end;
//            if EvolParam[0]=ErResult then
//                 begin
//                  MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
//                  CBoxAppr.Checked:=False;
//                  dispose(tempVax);
//                  Exit;
//                 end;
//           Str1:=TStringList.Create;
//
//            for I := 0 to High(VaxGraph^.x) do
//               begin
//               a:=TunFun(VaxGraph^.X[i],EvolParam);
//               Str1.Add(FloatToStrF(VaxGraph^.X[i],ffExponent,4,0)+' '+
//                       FloatToStrF(VaxGraph^.Y[i],ffExponent,4,0)+' '+
//                       FloatToStrF(a,ffExponent,4,0));
//               end;
//            Str1.SaveToFile('000.dat');
//            Str1.Free;
//
//           for I := 0 to Np do
//              begin
//              x:=Series1.MinXValue+i*h;
//              y:=TunFun(x,EvolParam);
//              Series4.AddXY(x, y);
//              end;
//           Series4.Active:=True;
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
//           MemoAppr.Lines.Add('I0='+ FloatToStrF(EvolParam[0],ffExponent,4,3));
//           MemoAppr.Lines.Add('A='+ FloatToStrF(EvolParam[1],ffExponent,4,3));
//           MemoAppr.Lines.Add('B='+ FloatToStrF(EvolParam[2],ffExponent,4,3));
//           {}
//
// {          try
//           DifEvol (VaxGraph,RevZriz3,0,EvolParam)
//           except
//           SetLength(EvolParam,1);
//           EvolParam[0]:=ErResult;
//           end;
//            if EvolParam[0]=ErResult then
//                 begin
//                  MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
//                  CBoxAppr.Checked:=False;
//                  dispose(tempVax);
//                  Exit;
//                 end;
//           Str1:=TStringList.Create;
//
//            for I := 0 to High(VaxGraph^.x) do
//               begin
//               c:=VaxFile^.X[i]*Kb;
//               a:=EvolParam[0]*exp(-Power((EvolParam[1]*c),0.25))*Power(c,-2);
//               b:=EvolParam[2]/sqr(c)*exp(-EvolParam[3]*VaxFile^.X[i]);
//               Str1.Add(FloatToStrF(VaxGraph^.X[i],ffExponent,4,0)+' '+
//                       FloatToStrF(VaxGraph^.Y[i],ffExponent,4,0)+' '+
//                       FloatToStrF(a,ffExponent,4,0)+' '+
//                       FloatToStrF(b,ffExponent,4,0)+' '+
//                       FloatToStrF(a+b,ffExponent,4,0));
//               end;
//            Str1.SaveToFile('000.dat');
//            Str1.Free;
//
//           for I := 0 to Np do
//              begin
//              x:=Series1.MinXValue+i*h;
//              c:=x*Kb;
//              y:=EvolParam[0]*exp(-Power((EvolParam[1]*c),0.25))*Power(c,-2)
//                +EvolParam[2]/sqr(c)*exp(-EvolParam[3]*x);
//              Series4.AddXY(x, y);
//              end;
//           Series4.Active:=True;
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
//           MemoAppr.Lines.Add('I01='+ FloatToStrF(EvolParam[0],ffExponent,4,3));
//           MemoAppr.Lines.Add('Tc='+ FloatToStrF(EvolParam[1],ffExponent,4,3));
//           MemoAppr.Lines.Add('I02='+ FloatToStrF(EvolParam[2],ffExponent,4,3));
//           MemoAppr.Lines.Add('E='+ FloatToStrF(EvolParam[3],ffExponent,4,3));
//           {}
// {         try
//           DifEvol (VaxGraph,RevShSCLC3,0,EvolParam)
//           except
//           SetLength(EvolParam,1);
//           EvolParam[0]:=ErResult;
//           end;
//            if EvolParam[0]=ErResult then
//                 begin
//                  MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
//                  CBoxAppr.Checked:=False;
//                  dispose(tempVax);
//                  Exit;
//                 end;
//           Str1:=TStringList.Create;
//
//            for I := 0 to High(VaxGraph^.x) do
//               begin
//               a:=EvolParam[0]*Power(VaxGraph^.X[i],EvolParam[1])+EvolParam[2]*Power(VaxGraph^.X[i],EvolParam[3]);
//              c:=0.775-7.021e-4*sqr(VaxGraph^.T)/(VaxGraph^.T+1108);
//              d:=Kb*VaxGraph^.T*ln(2.5e4*1.12*Power(VaxGraph^.T/300,1.5)/7.25);
//              e:=2*Qelem*7.25e21/8.85e-12/11.7;
//              f:=4.9e-5*1.12e6*sqr(VaxGraph^.T)*exp(-DbGaus(VaxGraph^.T,0.9995,0.775,0.018,1.066,0.0118)/Kb/VaxGraph^.T);
//              b:=f*exp(EvolParam[5]*sqrt(e*(c-d+VaxGraph^.X[i]))/Kb/VaxGraph^.T)*(1-exp(-VaxGraph^.X[i]/Kb/VaxGraph^.T));
////               b:=EvolParam[4]*exp(EvolParam[5]*sqrt(e*(c-d+VaxGraph^.X[i]))/Kb/VaxGraph^.T)*(1-exp(-VaxGraph^.X[i]/Kb/VaxGraph^.T));
//               Str1.Add(FloatToStrF(VaxGraph^.X[i],ffExponent,4,0)+' '+
//                       FloatToStrF(VaxGraph^.Y[i],ffExponent,4,0)+' '+
//                       FloatToStrF(a,ffExponent,4,0)+' '+
//                       FloatToStrF(b,ffExponent,4,0)+' '+
//                       FloatToStrF(a+b,ffExponent,4,0));
//               end;
//            Str1.SaveToFile('000.dat');
//            Str1.Free;
//
//           for I := 0 to Np do
//              begin
//              x:=Series1.MinXValue+i*h;
//
//              y:=EvolParam[0]*Power(x,EvolParam[1])+EvolParam[2]*Power(x,EvolParam[3])+
//                f*exp(EvolParam[5]*sqrt(e*(c-d+x))/Kb/VaxGraph^.T)*(1-exp(-x/Kb/VaxGraph^.T));
////                EvolParam[4]*exp(EvolParam[5]*sqrt(e*(c-d+x))/Kb/VaxGraph^.T)*(1-exp(-x/Kb/VaxGraph^.T));
//              Series4.AddXY(x, y);
//              end;
//           Series4.Active:=True;
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
//           MemoAppr.Lines.Add('I01='+ FloatToStrF(EvolParam[0],ffExponent,4,3));
//           MemoAppr.Lines.Add('m1='+ FloatToStrF(EvolParam[1],ffExponent,4,3));
//           MemoAppr.Lines.Add('I02='+ FloatToStrF(EvolParam[2],ffExponent,4,3));
//           MemoAppr.Lines.Add('m2='+ FloatToStrF(EvolParam[3],ffExponent,4,3));
//           MemoAppr.Lines.Add('I03='+ FloatToStrF(EvolParam[4],ffExponent,4,3));
//           MemoAppr.Lines.Add('Al='+ FloatToStrF(EvolParam[5],ffGeneral,4,3));
//           {}
// {         try
//           DifEvol (VaxGraph,RevShSCLC2,0,EvolParam)
//           except
//           SetLength(EvolParam,1);
//           EvolParam[0]:=ErResult;
//           end;
//            if EvolParam[0]=ErResult then
//                 begin
//                  MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
//                  CBoxAppr.Checked:=False;
//                  dispose(tempVax);
//                  Exit;
//                 end;
//           Str1:=TStringList.Create;
//
//            for I := 0 to High(VaxGraph^.x) do
//               begin
//               a:=EvolParam[0]*(Power(VaxGraph^.X[i],1+477.6/VaxGraph^.T)+0.1169*Power(VaxGraph^.X[i],1+2212/VaxGraph^.T));
//              c:=0.775-7.021e-4*sqr(VaxGraph^.T)/(VaxGraph^.T+1108);
//              d:=Kb*VaxGraph^.T*ln(2.5e4*1.12*Power(VaxGraph^.T/300,1.5)/7.25);
//              e:=2*Qelem*7.25e21/8.85e-12/11.7;
//              f:=4.9e-5*1.12e6*sqr(VaxGraph^.T)*exp(-DbGaus(VaxGraph^.T,0.9995,0.775,0.018,1.066,0.0118)/Kb/VaxGraph^.T);
////              b:=f*exp(EvolParam[2]*sqrt(e*(c-d+VaxGraph^.X[i]))/Kb/VaxGraph^.T)*(1-exp(-VaxGraph^.X[i]/Kb/VaxGraph^.T));
//               b:=EvolParam[1]*exp(EvolParam[2]*sqrt(e*(c-d+VaxGraph^.X[i]))/Kb/VaxGraph^.T)*(1-exp(-VaxGraph^.X[i]/Kb/VaxGraph^.T));
//               Str1.Add(FloatToStrF(VaxGraph^.X[i],ffExponent,4,0)+' '+
//                       FloatToStrF(VaxGraph^.Y[i],ffExponent,4,0)+' '+
//                       FloatToStrF(a,ffExponent,4,0)+' '+
//                       FloatToStrF(b,ffExponent,4,0)+' '+
//                       FloatToStrF(a+b,ffExponent,4,0));
//               end;
//            Str1.SaveToFile('000.dat');
//            Str1.Free;
//
//           for I := 0 to Np do
//              begin
//              x:=Series1.MinXValue+i*h;
//
//              y:=EvolParam[0]*(Power(x,1+477.6/VaxGraph^.T)+0.1169*Power(x,1+2212/VaxGraph^.T))+
////                f*exp(EvolParam[2]*sqrt(e*(c-d+x))/Kb/VaxGraph^.T)*(1-exp(-x/Kb/VaxGraph^.T));
//                EvolParam[1]*exp(EvolParam[2]*sqrt(e*(c-d+x))/Kb/VaxGraph^.T)*(1-exp(-x/Kb/VaxGraph^.T));
//              Series4.AddXY(x, y);
//              end;
//           Series4.Active:=True;
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
//           MemoAppr.Lines.Add('I01='+ FloatToStrF(EvolParam[0],ffExponent,4,3));
//           MemoAppr.Lines.Add('I02='+ FloatToStrF(EvolParam[1],ffExponent,4,3));
//           MemoAppr.Lines.Add('Al='+ FloatToStrF(EvolParam[2],ffGeneral,4,3));
//           {}
// {          try
//           DifEvol (VaxGraph,Power2,0,EvolParam)
//           except
//           SetLength(EvolParam,1);
//           EvolParam[0]:=ErResult;
//           end;
//            if EvolParam[0]=ErResult then
//                 begin
//                  MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
//                  CBoxAppr.Checked:=False;
//                  dispose(tempVax);
//                  Exit;
//                 end;
//           Str1:=TStringList.Create;
//
//            for I := 0 to High(VaxGraph^.x) do
//               begin
//               a:=EvolParam[0]*Power(VaxGraph^.X[i],EvolParam[2]);
//               b:=EvolParam[0]*EvolParam[1]*Power(VaxGraph^.X[i],EvolParam[3]);
//               Str1.Add(FloatToStrF(VaxGraph^.X[i],ffExponent,4,0)+' '+
//                       FloatToStrF(VaxGraph^.Y[i],ffExponent,4,0)+' '+
//                       FloatToStrF(a,ffExponent,4,0)+' '+
//                       FloatToStrF(b,ffExponent,4,0)+' '+
//                       FloatToStrF(a+b,ffExponent,4,0));
//               end;
//            Str1.SaveToFile('000.dat');
//            Str1.Free;
//
//           for I := 0 to Np do
//              begin
//              x:=Series1.MinXValue+i*h;
//              y:=EvolParam[0]*(Power(x,EvolParam[2])+
//                 EvolParam[1]*Power(x,EvolParam[3]));
//              Series4.AddXY(x, y);
//              end;
//           Series4.Active:=True;
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
//           MemoAppr.Lines.Add('A1='+ FloatToStrF(EvolParam[0],ffExponent,4,3));
//           MemoAppr.Lines.Add('m1='+ FloatToStrF(EvolParam[2],ffExponent,4,3));
//           MemoAppr.Lines.Add('A2='+ FloatToStrF(EvolParam[1],ffGeneral,4,3));
//           MemoAppr.Lines.Add('m2='+ FloatToStrF(EvolParam[3],ffExponent,4,3));
//           {}
// {          try
//           DifEvol (VaxGraph,RevZriz2,0,EvolParam)
//           except
//           SetLength(EvolParam,1);
//           EvolParam[0]:=ErResult;
//           end;
//            if EvolParam[0]=ErResult then
//                 begin
//                  MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
//                  CBoxAppr.Checked:=False;
//                  dispose(tempVax);
//                  Exit;
//                 end;
//           Str1:=TStringList.Create;
//
//            for I := 0 to High(VaxGraph^.x) do
//               begin
////               c:=VaxFile^.X[i]*Kb;
//               a:=RevZrizSCLC(VaxFile^.X[i],-Tpow,EvolParam[0],EvolParam[1]);
////               EvolParam[0]*Power(c,Tpow)*Power(EvolParam[1],EvolParam[4]*c);
//               b:=RevZrizFun(VaxFile^.X[i],2,EvolParam[2],EvolParam[3]);
////               EvolParam[2]/sqr(c)*exp(-EvolParam[3]*VaxFile^.X[i]);
//               Str1.Add(FloatToStrF(VaxGraph^.X[i],ffExponent,4,0)+' '+
//                       FloatToStrF(VaxGraph^.Y[i],ffExponent,4,0)+' '+
//                       FloatToStrF(a,ffExponent,4,0)+' '+
//                       FloatToStrF(b,ffExponent,4,0)+' '+
//                       FloatToStrF(a+b,ffExponent,4,0));
//               end;
//            Str1.SaveToFile('000.dat');
//            Str1.Free;
//
//           for I := 0 to Np do
//              begin
//              x:=Series1.MinXValue+i*h;
//              c:=x*Kb;
//              y:=RevZrizSCLC(x,-Tpow,EvolParam[0],EvolParam[1])+
//                 RevZrizFun(x,2,EvolParam[2],EvolParam[3]);
////              EvolParam[0]*Power(c,Tpow)*Power(EvolParam[1],EvolParam[4]*c)
////                +EvolParam[2]/sqr(c)*exp(-EvolParam[3]*x);
//              Series4.AddXY(x, y);
//              end;
//           Series4.Active:=True;
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
//           MemoAppr.Lines.Add('I01='+ FloatToStrF(EvolParam[0],ffExponent,4,3));
//           MemoAppr.Lines.Add('B='+ FloatToStrF(EvolParam[1],ffExponent,4,3));
////           MemoAppr.Lines.Add('Tc='+ FloatToStrF(EvolParam[4],ffGeneral,4,3));
//           MemoAppr.Lines.Add('I02='+ FloatToStrF(EvolParam[2],ffExponent,4,3));
//           MemoAppr.Lines.Add('E='+ FloatToStrF(EvolParam[3],ffExponent,4,3));
//           {}
//
// {          try
//           MABC (VaxGraph,DiodTwo,0,EvolParam)
//           except
//           SetLength(EvolParam,1);
//           EvolParam[0]:=ErResult;
//           end;
//            if EvolParam[0]=ErResult then
//                 begin
//                  MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
//                  CBoxAppr.Checked:=False;
//                  dispose(tempVax);
//                  Exit;
//                 end;
//           Str1:=TStringList.Create;
//
//            for I := 0 to High(VaxGraph^.x) do
//               begin
//               a:=EvolParam[4]*(exp(VaxGraph^.X[i]/(EvolParam[3]*Kb*VaxFile^.T))-1);
//               b:=Full_IV(VaxGraph^.X[i],EvolParam[0]*Kb*VaxFile^.T,EvolParam[1],EvolParam[2],1e13,0);
//               Str1.Add(FloatToStrF(VaxGraph^.X[i],ffExponent,4,0)+' '+
//                       FloatToStrF(VaxGraph^.Y[i],ffExponent,4,0)+' '+
//                       FloatToStrF(a,ffExponent,4,0)+' '+
//                       FloatToStrF(b,ffExponent,4,0)+' '+
//                       FloatToStrF(VaxGraph^.Y[i]-a,ffExponent,4,0)+' '+
//                       FloatToStrF(VaxGraph^.Y[i]-b,ffExponent,4,0));
//               end;
//            Str1.SaveToFile('000.dat');
//            Str1.Free;
//
//
//           for I := 0 to Np do
//              begin
//              x:=Series1.MinXValue+i*h;
//              y:=Full_IV(x,EvolParam[0]*Kb*VaxFile^.T,EvolParam[1],EvolParam[2],1e13,0)+
//                 EvolParam[4]*(exp(x/(EvolParam[3]*Kb*VaxFile^.T))-1);
//              Series4.AddXY(x, y);
//              end;
//           Series4.Active:=True;
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
//           MemoAppr.Lines.Add('I01='+ FloatToStrF(EvolParam[2],ffExponent,4,3));
//           MemoAppr.Lines.Add('n1='+ FloatToStrF(EvolParam[0],ffGeneral,4,3));
//           MemoAppr.Lines.Add('Rs='+ FloatToStrF(EvolParam[1],ffExponent,4,3));
//           MemoAppr.Lines.Add('I02='+ FloatToStrF(EvolParam[4],ffExponent,4,3));
//           MemoAppr.Lines.Add('n2='+ FloatToStrF(EvolParam[3],ffGeneral,4,3));
//           {}
// {          try
////           MABC (VaxGraph,RevShSCLC,0,EvolParam)
//           DifEvol (VaxGraph,RevShSCLC,0,EvolParam)
//           except
//           SetLength(EvolParam,1);
//           EvolParam[0]:=ErResult;
//           end;
//            if EvolParam[0]=ErResult then
//                 begin
//                  MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
//                  CBoxAppr.Checked:=False;
//                  dispose(tempVax);
//                  Exit;
//                 end;
//           Str1:=TStringList.Create;
//
//            for I := 0 to High(VaxGraph^.x) do
//               begin
//               a:=EvolParam[0]*Power(VaxGraph^.X[i],EvolParam[1]);
//              c:=0.775-7.021e-4*sqr(VaxGraph^.T)/(VaxGraph^.T+1108);
//              d:=Kb*VaxGraph^.T*ln(2.5e4*1.12*Power(VaxGraph^.T/300,1.5)/7.25);
//              e:=2*Qelem*7.25e21/8.85e-12/11.7;
//              f:=4.9e-5*1.12e6*sqr(VaxGraph^.T)*exp(-DbGaus(VaxGraph^.T,0.9995,0.775,0.018,1.066,0.0118)/Kb/VaxGraph^.T);
////              b:=f*exp(EvolParam[2]*sqrt(e*(c-d+VaxGraph^.X[i]))/Kb/VaxGraph^.T)*(1-exp(-VaxGraph^.X[i]/Kb/VaxGraph^.T));
//               b:=EvolParam[3]*exp(EvolParam[2]*sqrt(e*(c-d+VaxGraph^.X[i]))/Kb/VaxGraph^.T)*(1-exp(-VaxGraph^.X[i]/Kb/VaxGraph^.T));
//               Str1.Add(FloatToStrF(VaxGraph^.X[i],ffExponent,4,0)+' '+
//                       FloatToStrF(VaxGraph^.Y[i],ffExponent,4,0)+' '+
//                       FloatToStrF(a,ffExponent,4,0)+' '+
//                       FloatToStrF(b,ffExponent,4,0)+' '+
//                       FloatToStrF(a+b,ffExponent,4,0));
//               end;
//            Str1.SaveToFile('000.dat');
//            Str1.Free;
//
//           for I := 0 to Np do
//              begin
//              x:=Series1.MinXValue+i*h;
//
//              y:=EvolParam[0]*Power(x,EvolParam[1])+
////                f*exp(EvolParam[2]*sqrt(e*(c-d+x))/Kb/VaxGraph^.T)*(1-exp(-x/Kb/VaxGraph^.T));
//                EvolParam[3]*exp(EvolParam[2]*sqrt(e*(c-d+x))/Kb/VaxGraph^.T)*(1-exp(-x/Kb/VaxGraph^.T));
//              Series4.AddXY(x, y);
//              end;
//           Series4.Active:=True;
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
//           MemoAppr.Lines.Add('I01='+ FloatToStrF(EvolParam[0],ffExponent,4,3));
//           MemoAppr.Lines.Add('m='+ FloatToStrF(EvolParam[1],ffGeneral,4,3));
// //          MemoAppr.Lines.Add('I02='+ FloatToStrF(f,ffExponent,4,3));
//           MemoAppr.Lines.Add('I02='+ FloatToStrF(EvolParam[3],ffExponent,4,3));
//           MemoAppr.Lines.Add('Al='+ FloatToStrF(EvolParam[2],ffGeneral,4,3));
//           {}
//
// {          try
//      //     DifEvol (VaxGraph,RevShTwo,0,EvolParam)
//           MABC (VaxGraph,RevShTwo,0,EvolParam)
//           except
//           SetLength(EvolParam,1);
//           EvolParam[0]:=ErResult;
//           end;
//            if EvolParam[0]=ErResult then
//                 begin
//                  MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
//                  CBoxAppr.Checked:=False;
//                  dispose(tempVax);
//                  Exit;
//                 end;
//           Str1:=TStringList.Create;
//
//            for I := 0 to High(VaxGraph^.x) do
//               begin
////              c:=0.775-7.021e-4*sqr(VaxGraph^.T)/(VaxGraph^.T+1108);
////              d:=Kb*VaxGraph^.T*ln(2.5e4*1.12*Power(VaxGraph^.T/300,1.5)/7.25);
////              e:=2*Qelem*7.25e21/8.85e-12/11.7;
//
////              f:=4.9e-5*1.12e6*sqr(VaxGraph^.T)*exp(-DbGaus(VaxGraph^.T,0.9995,0.775,0.018,1.066,0.0118)/Kb/VaxGraph^.T);
////              b:=f*exp(EvolParam[2]*sqrt(e*(c-d+VaxGraph^.X[i]))/Kb/VaxGraph^.T)*(1-exp(-VaxGraph^.X[i]/Kb/VaxGraph^.T));
//        //      a:=RevShFun(VaxGraph^.X[i],VaxGraph^.T,EvolParam[0],EvolParam[2]);
//          //    b:=RevShFun(VaxGraph^.X[i],VaxGraph^.T,EvolParam[1],EvolParam[3]);
////              a:=EvolParam[0]*exp(EvolParam[2]*sqrt(e*(c-d+VaxGraph^.X[i]))/Kb/VaxGraph^.T)*(1-exp(-VaxGraph^.X[i]/Kb/VaxGraph^.T));
////              b:=EvolParam[1]*exp(EvolParam[3]*sqrt(e*(c-d+VaxGraph^.X[i]))/Kb/VaxGraph^.T)*(1-exp(-VaxGraph^.X[i]/Kb/VaxGraph^.T));
//               Str1.Add(FloatToStrF(VaxGraph^.X[i],ffExponent,4,0)+' '+
//                       FloatToStrF(VaxGraph^.Y[i],ffExponent,4,0)+' '+
//                       FloatToStrF(RevShFun(VaxGraph^.X[i],VaxGraph^.T,EvolParam[0],EvolParam[2]),ffExponent,4,0)+' '+
//                       FloatToStrF(RevShFun(VaxGraph^.X[i],VaxGraph^.T,EvolParam[1],EvolParam[3]),ffExponent,4,0)+' '+
//                       FloatToStrF(RevShTwoFun(VaxGraph^.X[i],VaxGraph^.T,EvolParam),ffExponent,4,0));
//               end;
//            Str1.SaveToFile('000.dat');
//            Str1.Free;
//
//           for I := 0 to Np do
//              begin
//              x:=Series1.MinXValue+i*h;
//
//              y:=RevShTwoFun(x,VaxGraph^.T,EvolParam);
////              (EvolParam[0]*exp(EvolParam[2]*sqrt(e*(c-d+x))/Kb/VaxGraph^.T)
//              // f*exp(EvolParam[2]*sqrt(e*(c-d+x))/Kb/VaxGraph^.T)*(1-exp(-x/Kb/VaxGraph^.T));
//  //              +EvolParam[1]*exp(EvolParam[3]*sqrt(e*(c-d+x))/Kb/VaxGraph^.T))*(1-exp(-x/Kb/VaxGraph^.T));
//              Series4.AddXY(x, y);
//              end;
//           Series4.Active:=True;
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
//           MemoAppr.Lines.Add('I01='+ FloatToStrF(EvolParam[0],ffExponent,4,3));
//           MemoAppr.Lines.Add('Al1='+ FloatToStrF(EvolParam[2],ffGeneral,4,3));
//           MemoAppr.Lines.Add('I02='+ FloatToStrF(EvolParam[1],ffExponent,4,3));
//           MemoAppr.Lines.Add('Al2='+ FloatToStrF(EvolParam[3],ffGeneral,4,3));
//           {}
// {          try
//           DifEvol (VaxGraph,RevZriz,0,EvolParam)
//           except
//           SetLength(EvolParam,1);
//           EvolParam[0]:=ErResult;
//           end;
//            if EvolParam[0]=ErResult then
//                 begin
//                  MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
//                  CBoxAppr.Checked:=False;
//                  dispose(tempVax);
//                  Exit;
//                 end;
//           Str1:=TStringList.Create;
//
//            for I := 0 to High(VaxGraph^.x) do
//               begin
////               a:=RevZrizFun(VaxFile^.X[i],-Tpow,EvolParam[0],EvolParam[1]);
////               b:=RevZrizFun(VaxFile^.X[i],2,EvolParam[2],EvolParam[3]);
////               a:=EvolParam[0]*exp(-EvolParam[1]*VaxFile^.X[i])*Power(VaxFile^.X[i]*Kb,Tpow);
////               b:=EvolParam[2]/sqr(VaxFile^.X[i]*Kb)*exp(-EvolParam[3]*VaxFile^.X[i]);
//               Str1.Add(FloatToStrF(VaxGraph^.X[i],ffExponent,4,0)+' '+
//                       FloatToStrF(VaxGraph^.Y[i],ffExponent,4,0)+' '+
//                       FloatToStrF(RevZrizFun(VaxFile^.X[i],-Tpow,EvolParam[0],EvolParam[1]),ffExponent,4,0)+' '+
//                       FloatToStrF(RevZrizFun(VaxFile^.X[i],2,EvolParam[2],EvolParam[3]),ffExponent,4,0)+' '+
//                       FloatToStrF(RevZrizFitFun(VaxFile^.X[i],EvolParam),ffExponent,4,0));
//               end;
//            Str1.SaveToFile('000.dat');
//            Str1.Free;
//
//           for I := 0 to Np do
//              begin
//              x:=Series1.MinXValue+i*h;
//              y:=RevZrizFitFun(x,EvolParam);
////              y:=EvolParam[0]*exp(-EvolParam[1]*x)*Power(x*Kb,Tpow)
////                +EvolParam[2]/sqr(x*Kb)*exp(-EvolParam[3]*x);
//              Series4.AddXY(x, y);
//              end;
//           Series4.Active:=True;
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
//           MemoAppr.Lines.Add('I01='+ FloatToStrF(EvolParam[0],ffExponent,4,3));
//           MemoAppr.Lines.Add('E1='+ FloatToStrF(EvolParam[1],ffGeneral,4,3));
//           MemoAppr.Lines.Add('I02='+ FloatToStrF(EvolParam[2],ffExponent,4,3));
//           MemoAppr.Lines.Add('E2='+ FloatToStrF(EvolParam[3],ffExponent,4,3));
//           {}
// {          try
//           MABC (VaxGraph,DiodTwoFull,0,EvolParam)
//           except
//           SetLength(EvolParam,1);
//           EvolParam[0]:=ErResult;
//           end;
//            if EvolParam[0]=ErResult then
//                 begin
//                  MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
//                  CBoxAppr.Checked:=False;
//                  dispose(tempVax);
//                  Exit;
//                 end;
//           Str1:=TStringList.Create;
//
//            for I := 0 to High(VaxGraph^.x) do
//               begin
//               a:=Full_IV(VaxGraph^.X[i],EvolParam[3]*Kb*VaxFile^.T,EvolParam[5],EvolParam[4],1e13,0);
//               b:=Full_IV(VaxGraph^.X[i],EvolParam[0]*Kb*VaxFile^.T,EvolParam[1],EvolParam[2],1e13,0);
//               Str1.Add(FloatToStrF(VaxGraph^.X[i],ffExponent,4,0)+' '+
//                       FloatToStrF(VaxGraph^.Y[i],ffExponent,4,0)+' '+
//                       FloatToStrF(a,ffExponent,4,0)+' '+
//                       FloatToStrF(b,ffExponent,4,0)+' '+
//                       FloatToStrF(VaxGraph^.Y[i]-a,ffExponent,4,0)+' '+
//                       FloatToStrF(VaxGraph^.Y[i]-b,ffExponent,4,0));
//               end;
//            Str1.SaveToFile('000.dat');
//            Str1.Free;
//
//           for I := 0 to Np do
//              begin
//              x:=Series1.MinXValue+i*h;
//              y:=Full_IV(x,EvolParam[0]*Kb*VaxFile^.T,EvolParam[1],EvolParam[2],1e13,0)+
//                 Full_IV(x,EvolParam[3]*Kb*VaxFile^.T,EvolParam[5],EvolParam[4],1e13,0);
//              Series4.AddXY(x, y);
//              end;
//           Series4.Active:=True;
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
//           MemoAppr.Lines.Add('I01='+ FloatToStrF(EvolParam[2],ffExponent,4,3));
//           MemoAppr.Lines.Add('n1='+ FloatToStrF(EvolParam[0],ffGeneral,4,3));
//           MemoAppr.Lines.Add('Rs1='+ FloatToStrF(EvolParam[1],ffExponent,4,3));
//           MemoAppr.Lines.Add('I02='+ FloatToStrF(EvolParam[4],ffExponent,4,3));
//           MemoAppr.Lines.Add('n2='+ FloatToStrF(EvolParam[3],ffGeneral,4,3));
//           MemoAppr.Lines.Add('Rs2='+ FloatToStrF(EvolParam[5],ffExponent,4,3));
//           {}
// {          try
//     //      MABC (VaxGraph,DGaus,0,EvolParam)
//           DifEvol (VaxGraph,DGaus,0,EvolParam)
//           except
//           SetLength(EvolParam,1);
//           EvolParam[0]:=ErResult;
//           end;
//            if EvolParam[0]=ErResult then
//                 begin
//                  MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
//                  CBoxAppr.Checked:=False;
//                  dispose(tempVax);
//                  Exit;
//                 end;
//
//           for I := 0 to Np do
//              begin
//              x:=Series1.MinXValue+i*h;
//              a:=x*Kb;
//              y:=-a*ln(EvolParam[0]*exp(-(EvolParam[1]-7.021e-4*sqr(x)/(1108+x))/a+sqr(EvolParam[2])/2/sqr(a))+
//               (1-EvolParam[0])*exp(-(EvolParam[3]-7.021e-4*sqr(x)/(1108+x))/a+sqr(EvolParam[4])/2/sqr(a)));
//              Series4.AddXY(x, y);
//              end;
//           Series4.Active:=True;
//           Write_File_Series('Fbapr.dat',Series4);
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
//           MemoAppr.Lines.Add('A1='+ FloatToStrF(EvolParam[0],ffExponent,4,3));
//           MemoAppr.Lines.Add('A2='+ FloatToStrF(1-EvolParam[0],ffExponent,4,3));
//           MemoAppr.Lines.Add('Fb1='+ FloatToStrF(EvolParam[1],ffGeneral,4,3));
//           MemoAppr.Lines.Add('Sig1='+ FloatToStrF(EvolParam[2],ffExponent,4,3));
//           MemoAppr.Lines.Add('Fb2='+ FloatToStrF(EvolParam[3],ffExponent,4,3));
//           MemoAppr.Lines.Add('Sig2='+ FloatToStrF(EvolParam[4],ffGeneral,4,3));
//           {}
// {          try
//           MABC (VaxGraph,LinEg,0,EvolParam)
//           except
//           SetLength(EvolParam,1);
//           EvolParam[0]:=ErResult;
//           end;
//            if EvolParam[0]=ErResult then
//                 begin
//                  MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
//                  CBoxAppr.Checked:=False;
//                  dispose(tempVax);
//                  Exit;
//                 end;
//           h:=(260-120)/Np;
//           for I := 0 to Np do
//              begin
//              x:=120+i*h;
////              x:=Series1.MinXValue+i*h;
// //             y:=EvolParam[0]-7.021e-4*sqr(x)/(1108+x)-Kb*x*ln(EvolParam[1]);
//              y:=LinEgF(x,EvolParam);
//              Series4.AddXY(x, y);
//              end;
//           Series4.Active:=True;
//           Write_File_Series('Fbapr.dat',Series4);
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
////           MemoAppr.Lines.Add('Fb0='+ FloatToStrF(EvolParam[0],ffExponent,4,3));
////           MemoAppr.Lines.Add('fp='+ FloatToStrF(EvolParam[1],ffGeneral,4,3));
//           MemoAppr.Lines.Add('gamm0='+ FloatToStrF(EvolParam[0],ffExponent,4,3));
//           MemoAppr.Lines.Add('C1='+ FloatToStrF(EvolParam[1],ffGeneral,4,3));
////           MemoAppr.Lines.Add('Fb0='+ FloatToStrF(EvolParam[2],ffExponent,4,3));
//           {}
//          end;
//       1: //лінійнa апроксимація y=a+b*x
//          begin
//           LinAprox(tempVax,a,b);
//           for I := 0 to Np do
//              begin
//              x:=Series1.MinXValue+i*h;
//              if XLogCheck.Checked then xl:=log10(x)
//                                   else xl:=x;
//              if YLogCheck.Checked
//                 then y:=exp(Linear(xl,a,b)*ln(10))
//                 else y:=Linear(xl,a,b);
//
//              Series4.AddXY(x, y);
//              end;
//           Series4.Active:=True;
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
//           MemoAppr.Lines.Add('A='+ FloatToStrF(a,ffExponent,3,2));
//           MemoAppr.Lines.Add('B='+ FloatToStrF(b,ffExponent,3,2));
//          end; // '1' case
//        2: //параболічна апроксимація y=a+b*x+c*x^2
//           begin
//           ParabAprox(tempVax,a,b,c);
//           for I := 0 to Np do
//              begin
//              x:=Series1.MinXValue+i*h;
//              if XLogCheck.Checked then xl:=log10(x)
//                                   else xl:=x;
//              if YLogCheck.Checked
//                 then y:=exp(Parab(xl,a,b,c)*ln(10))
//                 else y:=Parab(xl,a,b,c);
//
//              Series4.AddXY(x, y);
//              end;
//           Series4.Active:=True;
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
//           MemoAppr.Lines.Add('A='+ FloatToStrF(a,ffExponent,3,2));
//           MemoAppr.Lines.Add('B='+ FloatToStrF(b,ffExponent,3,2));
//           MemoAppr.Lines.Add('C='+ FloatToStrF(c,ffExponent,3,2));
//           end; //'2' case
//        3: //експоненціна апроксимація y=I0exp(x/E)
//           begin
//           try
//           ExKalk(VaxGraph,AA,Sk,nn,I00,Fbb);
//{           Newts(4,VaxGraph,1e-6,ApprExp,IREap,rez);}
//           except
//           MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
//           nn:=ErResult;
//           end;
//           if nn=ErResult then
//                 begin
//                  CBoxAppr.Checked:=False;
//                  dispose(tempVax);
//                  Exit;
//                 end;
//           for I := 0 to Np do
//              begin
//              x:=Series1.MinXValue+i*h;
//              y:=I00*exp(x/nn/Kb/VaxFile^.T);
//{              y:=ExpIE(x,IREap[1],IREap[3]);}
//              Series4.AddXY(x, y);
//              end;
//           Series4.Active:=True;
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
//           MemoAppr.Lines.Add('I0='+ FloatToStrF(I00,ffExponent,3,2));
//           MemoAppr.Lines.Add('n='+ FloatToStrF(nn,ffGeneral,3,2));
//           MemoAppr.Lines.Add('Fb='+ FloatToStrF(Fbb,ffGeneral,3,2));
//{           MemoAppr.Lines.Add('I0='+ FloatToStrF(IREap[1],ffExponent,3,2));
//           MemoAppr.Lines.Add('n='+ FloatToStrF(IREap[3]/Kb/VaxFile.T,ffGeneral,3,2));}
//           end; //'3' case
//        4: //експоненціна апроксимація І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
//           begin
//           Iph:=0;
//           try
//           if Iph_Exp then Aprox (3,VaxGraph, Mode_Exp,nn,Rss,I00,Rsh,Isc,Voc,Iph)
//                      else Aprox (0,VaxGraph,Mode_Exp,nn,Rss,I00,Rsh,Isc,Voc,Iph);
//           except
//           nn:=ErResult;
//           end;
//            if nn=ErResult then
//                 begin
//                  MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
//                  CBoxAppr.Checked:=False;
//                  dispose(tempVax);
//                  Exit;
//                 end;
//           for I := 0 to Np do
//              begin
//              x:=Series1.MinXValue+i*h;
//              y:=Full_IV(x,nn*Kb*VaxFile^.T,Rss,I00,Rsh,Iph);
//{              y:=ExpIE(x,IREap[1],IREap[3]);}
//{              y:=ExpIERsh(x,IREap[1],IREap[3],IREap[2]);}
//              Series4.AddXY(x, y);
//              end;
//           Series4.Active:=True;
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
//           MemoAppr.Lines.Add('I0='+ FloatToStrF(I00,ffExponent,3,2));
//           MemoAppr.Lines.Add('n='+ FloatToStrF(nn,ffGeneral,3,2));
//           case Mode_exp of
//             0:begin
//               MemoAppr.Lines.Add('Rs='+ FloatToStrF(Rss,ffExponent,3,2));
//               MemoAppr.Lines.Add('Rsh='+ FloatToStrF(Rsh,ffExponent,3,2));
//               end;
//              1:
//               MemoAppr.Lines.Add('Rs='+ FloatToStrF(Rss,ffExponent,3,2));
//              2:
//               MemoAppr.Lines.Add('Rsh='+ FloatToStrF(Rsh,ffExponent,3,2));
//           end;
//           if Iph_exp then
//             begin
//             MemoAppr.Lines.Add('Voc='+ FloatToStrF(Voc,ffGeneral,3,2));
//             MemoAppr.Lines.Add('Isc='+ FloatToStrF(Isc,ffExponent,3,2));
//             MemoAppr.Lines.Add('Iph='+ FloatToStrF(Iph,ffExponent,3,2));
//             end;
//           end; //'4' case
//        5: //зглажування
//           begin
//           Smoothing (VaxGraph,tempVax);
//           if tempVax^.n=0 then
//                    begin
//                    MessageDlg('The smoothing is imposible,'+#10+
//                    'the points" quantity is very low', mtError, [mbOK], 0);
//                    CBoxAppr.Checked:=False;
//                    dispose(tempVax);
//                    Exit;
//                    end;
//           for I := 0 to High(tempVax^.X) do
//               Series4.AddXY(tempVax^.X[i],tempVax^.Y[i]);
//           Series4.Active:=True;
//           end;
//        6: //застосування медіанного фільтру
//           begin
//           Median (VaxGraph,tempVax);
//           if tempVax^.n=0 then
//                    begin
//                    MessageDlg('The median filter"s using is imposible,'+#10+
//                    'the points" quantity is very low', mtError, [mbOK], 0);
//                    CBoxAppr.Checked:=False;
//                    dispose(tempVax);
//                    Exit;
//                    end;
//           for I := 0 to High(tempVax^.X) do
//               Series4.AddXY(tempVax^.X[i],tempVax^.Y[i]);
//           Series4.Active:=True;
//           end;       //6:
//        7: //знаходження похідної
//           begin
//           Diferen (VaxGraph,tempVax);
//           if tempVax^.n=0 then
//                    begin
//                    MessageDlg('The derivation is imposible,'+#10+
//                    'the points" quantity is very low', mtError, [mbOK], 0);
//                    CBoxAppr.Checked:=False;
//                    dispose(tempVax);
//                    Exit;
//                    end;
//           for I := 0 to High(tempVax^.X) do
//               Series4.AddXY(tempVax^.X[i],tempVax^.Y[i]);
//           Series4.Active:=True;
//           end;  //7:
//        8: //апроксимація залежністю y=a+b*x+c*ln(x)
//          begin
//          GromovAprox(VaxGraph,a,b,c);
//          if a=ErResult then
//                 begin
//                 MessageDlg('The approximation is imposible'+#10+
//               '(may be some points have negative abscissa)', mtError, [mbOK], 0);
//                  CBoxAppr.Checked:=False;
//                  dispose(tempVax);
//                  Exit;
//                 end;
//          for I := 0 to Np do
//              begin
//              x:=Series1.MinXValue+i*h;
//              y:=Gromov(x,a,b,c);
//              Series4.AddXY(x,y);
//              end;
//           Series4.Active:=True;
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
//           MemoAppr.Lines.Add('A='+ FloatToStrF(a,ffExponent,3,2));
//           MemoAppr.Lines.Add('B='+ FloatToStrF(b,ffExponent,3,2));
//           MemoAppr.Lines.Add('C='+ FloatToStrF(c,ffExponent,3,2));
//          end;  // 8:
//        9:{апроксимація параметричною залежністю
//            I=Szr AA T^2 exp(-Fb/kT) exp(qVs/kT)
//            V=Vs+del*[Sqrt(2q Nd ep / eps0) (Sqrt(Fb/q)-Sqrt(Fb/q-Vs))]}
//           begin
//           IvanovAprox(VaxGraph,AA,Sk,Ndd,eps,a,b);
//           if b=ErResult then
//               begin
//                  CBoxAppr.Checked:=False;
//                  dispose(tempVax);
//                  Exit;
//               end;
//           for I := 0 to Np do
//              begin
//              Ivanov(Series1.MinXValue+i*h,AA,Sk,VaxFile^.T,Ndd,eps,a,b,x,y);
//              Series4.AddXY(x, y);
//              end;
//           Series4.Active:=True;
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
//           MemoAppr.Lines.Add('del/epd ='+ FloatToStrF(a,ffExponent,2,1)+' m');
//           MemoAppr.Lines.Add('Фb='+ FloatToStrF(b,ffGeneral,3,2)+' eV');
//           end; //'9' case
//          10: //апроксимація І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph функцією Ламберта
//           begin
//           Iph:=0;
//           try
//           if Iph_Lam then Aprox (4,VaxGraph, Mode_Lam,nn,Rss,I00,Rsh,Isc,Voc,Iph)
//                      else Aprox (1,VaxGraph,Mode_Lam,nn,Rss,I00,Rsh,Isc,Voc,Iph);
//           except
//           nn:=ErResult;
//           end;
//            if nn=ErResult then
//                 begin
//                  MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
//                  CBoxAppr.Checked:=False;
//                  dispose(tempVax);
//                  Exit;
//                 end;
//     {             Str1:=TStringList.Create;
//            for I := 0 to High(VaxGraph^.X) do
//               begin
//               b:=LambertAprShot(VaxGraph^.X[i],nn*Kb*VaxFile^.T,Rss,I00,Rsh);
////               b:=LambertLightAprShot(VaxGraph^.X[i],nn*Kb*VaxFile^.T,Rss,I00,Rsh,Iph);
//               Str1.Add(FloatToStrF(VaxGraph^.X[i],ffExponent,4,0)+' '+
//                       FloatToStrF(b,ffExponent,4,0)+' '+
//                       FloatToStrF(VaxGraph^.Y[i],ffExponent,4,0));
//               end;
//            Str1.SaveToFile('000.dat');
//            Str1.Free;
//      {}
//
//
//           for I := 0 to Np do
//              begin
//              x:=Series1.MinXValue+i*h;
//              if Iph_Lam then y:=LambertLightAprShot(x,nn*Kb*VaxFile^.T,Rss,I00,Rsh,Iph)//y:=LambertAprShot(x,nn*Kb*VaxFile^.T,Rss,I00,Rsh)
//                         else y:=LambertAprShot(x,nn*Kb*VaxFile^.T,Rss,I00,Rsh);//y:=LambertLightAprShot(x,nn*Kb*VaxFile^.T,Rss,I00,Rsh,Iph);
//              Series4.AddXY(x, y);
//              end;
//           Series4.Active:=True;
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
//           MemoAppr.Lines.Add('I0='+ FloatToStrF(I00,ffExponent,3,2));
//           MemoAppr.Lines.Add('n='+ FloatToStrF(nn,ffGeneral,3,2));
//           case Mode_Lam of
//             0:begin
//               MemoAppr.Lines.Add('Rs='+ FloatToStrF(Rss,ffExponent,3,2));
//               MemoAppr.Lines.Add('Rsh='+ FloatToStrF(Rsh,ffExponent,3,2));
//               end;
//              1:
//               MemoAppr.Lines.Add('Rs='+ FloatToStrF(Rss,ffExponent,3,2));
//              2:
//               MemoAppr.Lines.Add('Rsh='+ FloatToStrF(Rsh,ffExponent,3,2));
//           end;
//           if Iph_Lam then
//             begin
//             MemoAppr.Lines.Add('Voc='+ FloatToStrF(Voc,ffGeneral,3,2));
//             MemoAppr.Lines.Add('Isc='+ FloatToStrF(Isc,ffExponent,3,2));
//             MemoAppr.Lines.Add('Iph='+ FloatToStrF(Iph,ffExponent,3,2));
//             end;
//           end; //'10' case
//          11: //функція І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph,
//              //еволюційні методи
//           begin
//           Iph:=0;
//           try
//           if Iph_DE then
//                case EvolType of
//                  TMABC:MABC (VaxGraph,photodiod,Mode_DE,EvolParam);
//                  TTLBO:TLBO (VaxGraph,photodiod,Mode_DE,EvolParam);
//                  TPSO:DifEvol (VaxGraph,photodiod,Mode_DE,EvolParam);
//                  else DifEvol (VaxGraph,photodiod,Mode_DE,EvolParam);
//                end
//                     else
//                case EvolType of
//                  TMABC:MABC (VaxGraph,diod,Mode_DE,EvolParam);
//                  TTLBO:TLBO (VaxGraph,diod,Mode_DE,EvolParam);
//                  TPSO:DifEvol (VaxGraph,diod,Mode_DE,EvolParam);
//                  else DifEvol (VaxGraph,diod,Mode_DE,EvolParam);
//                end;
//
//
//{           case CBAppr.ItemIndex of
//             11:if Iph_DE then DifEvol (VaxGraph,photodiod,Mode_DE,EvolParam)
//                           else DifEvol (VaxGraph,diod,Mode_DE,EvolParam);
//             12:if Iph_DE then TLBO (VaxGraph,photodiod,Mode_DE,EvolParam)
//                            else TLBO (VaxGraph,diod,Mode_DE,EvolParam);
//             13:begin
//               if Iph_DE then MABC (VaxGraph,photodiod,Mode_DE,EvolParam)
//                            else MABC (VaxGraph,diod,Mode_DE,EvolParam);
//
//               end;
//             end; //case}
//           except
//           SetLength(EvolParam,1);
//           EvolParam[0]:=ErResult;
//           end;
//            if EvolParam[0]=ErResult then
//                 begin
//                  MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
//                  CBoxAppr.Checked:=False;
//                  dispose(tempVax);
//                  Exit;
//                 end;
//
//
//          nn:=EvolParam[0];
//          Rss:=EvolParam[1];
//          I00:=EvolParam[2];
//          Rsh:=EvolParam[3];
//          if Iph_DE then Iph:=EvolParam[4];
//          if (Iph>1e-7) then
//            begin
//              Voc:=Voc_Isc_Pm(1,VaxGraph,nn,Rss,I00,Rsh,Iph);
//              Isc:=Voc_Isc_Pm(2,VaxGraph,nn,Rss,I00,Rsh,Iph);
//            end;
//
//            Str1:=TStringList.Create;
//            for I := 0 to High(VaxGraph^.X) do
//               begin
//               b:=Full_IV(VaxGraph^.X[i],nn*Kb*VaxFile^.T,Rss,I00,Rsh,Iph);
//               Str1.Add(FloatToStrF(VaxGraph^.X[i],ffExponent,4,0)+' '+
//                       FloatToStrF(VaxGraph^.Y[i],ffExponent,4,0)+' '+
//                       FloatToStrF(b,ffExponent,4,0));
//               end;
//            Str1.SaveToFile('000.dat');
//            Str1.Free;
//
//
//
//           for I := 0 to Np do
//              begin
//              x:=Series1.MinXValue+i*h;
//              y:=Full_IV(x,nn*Kb*VaxFile^.T,Rss,I00,Rsh,Iph);
//              Series4.AddXY(x, y);
//              end;
//           Series4.Active:=True;
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
//           MemoAppr.Lines.Add('I0='+ FloatToStrF(I00,ffExponent,4,3));
//           MemoAppr.Lines.Add('n='+ FloatToStrF(nn,ffGeneral,4,3));
//           case Mode_DE of
//             0:begin
//               MemoAppr.Lines.Add('Rs='+ FloatToStrF(Rss,ffExponent,4,3));
//               MemoAppr.Lines.Add('Rsh='+ FloatToStrF(Rsh,ffExponent,4,3));
//               end;
//              1:
//               MemoAppr.Lines.Add('Rs='+ FloatToStrF(Rss,ffExponent,4,3));
//              2:
//               MemoAppr.Lines.Add('Rsh='+ FloatToStrF(Rsh,ffExponent,4,3));
//           end;
//           if Iph_DE then
//             begin
//             MemoAppr.Lines.Add('Voc='+ FloatToStrF(Voc,ffGeneral,4,3));
//             MemoAppr.Lines.Add('Isc='+ FloatToStrF(Isc,ffExponent,4,3));
//             MemoAppr.Lines.Add('Iph='+ FloatToStrF(Iph,ffExponent,4,3));
//             end;
//           end; //'11' case
//          12: //функція І=I01*[exp(q(V-IRs)/n1kT)-1]+I02*[exp(q(V-IRs)/n2kT)-1]
//                  // +(V-IRs)/Rsh-Iph,
//                 //методи еволюційної апроксимації
//           begin
//           Iph:=0;
//           try
//           if Iph_DE then
//                case EvolType of
//                  TMABC:MABC (VaxGraph,DoubleDiodLight,Mode_DE,EvolParam);
//                  TTLBO:TLBO (VaxGraph,DoubleDiodLight,Mode_DE,EvolParam);
//                  TPSO:DifEvol (VaxGraph,DoubleDiodLight,Mode_DE,EvolParam);
//                  else DifEvol (VaxGraph,DoubleDiodLight,Mode_DE,EvolParam);
//                end
//                     else
//                case EvolType of
//                  TMABC:MABC (VaxGraph,DoubleDiod,Mode_DE,EvolParam);
//                  TTLBO:TLBO (VaxGraph,DoubleDiod,Mode_DE,EvolParam);
//                  TPSO:DifEvol (VaxGraph,DoubleDiod,Mode_DE,EvolParam);
//                  else DifEvol (VaxGraph,DoubleDiod,Mode_DE,EvolParam);
//                end
//           except
//           SetLength(EvolParam,1);
//           EvolParam[0]:=ErResult;
//           end;
//            if EvolParam[0]=ErResult then
//                 begin
//                  MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
//                  CBoxAppr.Checked:=False;
//                  dispose(tempVax);
//                  Exit;
//                 end;
//
//
//          nn:=EvolParam[0];
//          Rss:=EvolParam[1];
//          I00:=EvolParam[2];
//          Rsh:=EvolParam[3];
//          if Iph_DE then Iph:=EvolParam[6]
//             else
//             begin
//             SetLength(EvolParam,7);
//             EvolParam[6]:=0;
//             end;
//
//      {}    if (Iph>1e-7) then
//            begin
//              Voc:=Voc_Isc_Pm_DoubleDiod(1,EvolParam[0]*Kb*VaxFile^.T,EvolParam[4]*Kb*VaxFile^.T,
//               EvolParam[1],EvolParam[2],EvolParam[5],EvolParam[3],EvolParam[6]);
//              Isc:=Voc_Isc_Pm_DoubleDiod(2,EvolParam[0]*Kb*VaxFile^.T,EvolParam[4]*Kb*VaxFile^.T,
//               EvolParam[1],EvolParam[2],EvolParam[5],EvolParam[3],EvolParam[6]);
//              Pm:=Voc_Isc_Pm_DoubleDiod(3,EvolParam[0]*Kb*VaxFile^.T,EvolParam[4]*Kb*VaxFile^.T,
//               EvolParam[1],EvolParam[2],EvolParam[5],EvolParam[3],EvolParam[6]);
//            end;
//       {}
//            Str1:=TStringList.Create();
//            for I := 0 to High(VaxGraph^.x) do
//               begin
//               a:=Full_IV_2Exp(VaxGraph^.X[i],EvolParam[0]*Kb*VaxFile^.T,EvolParam[4]*Kb*VaxFile^.T,
//               EvolParam[1],EvolParam[2],EvolParam[5],EvolParam[3],EvolParam[6]);
//               Str1.Add(FloatToStrF(VaxGraph^.X[i],ffExponent,4,0)+' '+
//                       FloatToStrF(VaxGraph^.Y[i],ffExponent,4,0)+' '+
//                       FloatToStrF(a,ffExponent,4,0));
//               end;
//            Str1.SaveToFile('000.dat');
//            Str1.Free;
//
//
//           for I := 0 to Np do
//              begin
//              x:=Series1.MinXValue+i*h;
//              y:=Full_IV_2Exp(x,EvolParam[0]*Kb*VaxFile^.T,EvolParam[4]*Kb*VaxFile^.T,
//               EvolParam[1],EvolParam[2],EvolParam[5],EvolParam[3],EvolParam[6]);
//              Series4.AddXY(x, y);
//              end;
//           Series4.Active:=True;
//           if MemoAppr.Lines.Count>1000 then MemoAppr.Clear;
//           MemoAppr.Lines.Add('');
//           MemoAppr.Lines.Add(VaxFile.name);
//           MemoAppr.Lines.Add(LAppr.Caption);
//           MemoAppr.Lines.Add('I01='+ FloatToStrF(EvolParam[2],ffExponent,4,3));
//           MemoAppr.Lines.Add('n1='+ FloatToStrF(EvolParam[0],ffGeneral,4,3));
//           MemoAppr.Lines.Add('I02='+ FloatToStrF(EvolParam[5],ffExponent,4,3));
//           MemoAppr.Lines.Add('n2='+ FloatToStrF(EvolParam[4],ffGeneral,4,3));
//           case Mode_DE of
//             0:begin
//               MemoAppr.Lines.Add('Rs='+ FloatToStrF(Rss,ffExponent,4,3));
//               MemoAppr.Lines.Add('Rsh='+ FloatToStrF(Rsh,ffExponent,4,3));
//               end;
//              1:
//               MemoAppr.Lines.Add('Rs='+ FloatToStrF(Rss,ffExponent,4,3));
//              2:
//               MemoAppr.Lines.Add('Rsh='+ FloatToStrF(Rsh,ffExponent,4,3));
//           end;
//           if Iph_DE then
//             begin
//             MemoAppr.Lines.Add('Voc='+ FloatToStrF(Voc,ffGeneral,4,3));
//             MemoAppr.Lines.Add('Isc='+ FloatToStrF(Isc,ffExponent,4,3));
//             MemoAppr.Lines.Add('Iph='+ FloatToStrF(Iph,ffExponent,4,3));
//             MemoAppr.Lines.Add('Pm='+ FloatToStrF(Pm,ffExponent,4,3));
//             end;
//           end; //'14,15' case
//       else;
//      end; //case
//    dispose(tempVax);
//    end    //then CBoxAppr.Checked
//                    else
//                   Series4.Active:=False;
//end;

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
//            else BaseLineCur.A:=Series1.MinYValue;
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
VaxGraph^.n:=0;
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
//     dB_dV_Fun(VaxFile,VaxGraph,SpinEditDL.Value,Isc,CBoxIscCons.Checked,
//               CBoxRCons.Checked,D[diDE],Mode_DE,Iph_DE,2);
     str:='dB/dV';
    end;
ShowGraph(Form1,str);
end;

procedure TForm1.CBoxGLShowClick(Sender: TObject);
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

//      showmessage(inttostr(SEGauss.MaxValue));

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

//procedure TForm1.OnlyNumberPress(Sender: TObject; var Key: Char);
//{процедура чіпляється до дії onKeyPress всіх дочірніх форм,
//дозволяє вводити в поля лише числові значення}
//begin
//if Key=#13 then
//    begin
//   SelectNext((Sender as TForm).ActiveControl,True,True);
//    Key:=#0;
////    SendMessage( Self.Handle, WM_NEXTDLGCTL, 0, 0);
//    end;
//if not(Key in [#8,'0'..'9','+','-','E','e',DecimalSeparator])
// then Key:=#0;
//end;


procedure FileToDataSheet(Sheet:TStringGrid; NameFile:TLabel;
          Temperature:TLabel; a:PVector);
var i:integer;
begin
  Sheet.Visible:=True;
  Sheet.RowCount:=2;
  for i:=0 to High(a^.X) do
    begin
      Sheet.Cells[0,i+1]:=IntToStr(i+1);
      Sheet.Cells[1,i+1]:=FloatToStrF(a^.X[i],ffGeneral,4,3);
      Sheet.Cells[2,i+1]:=FloatToStrF(a^.Y[i],ffExponent,3,2);
      Sheet.RowCount:=Sheet.RowCount+1;
    end;
  Sheet.RowCount:=Sheet.RowCount-1;
  NameFile.Visible:=True;
  Temperature.Visible:=True;
  NameFile.Caption:='File name: '+ a^.name;
  Temperature.Caption:='Temperature = '
      + FloatToStrF(a^.T,ffGeneral,4,1)+' K';
end;

procedure DataToGraph(SeriesPoint, SeriesLine:TChartSeries;
          Graph: TChart; Caption:string; a:PVector);
var i:word;
begin
 SeriesPoint.Clear;
 SeriesLine.Clear;
 Graph.LeftAxis.Automatic:=true;
 Graph.BottomAxis.Automatic:=true;


 if a^.n>0 then
  begin
//      showmessage('1111');
   for i:=0 to High(a^.X) do
    begin
     SeriesPoint.AddXY(a^.X[i],a^.Y[i],'',clRed);
     SeriesLine.AddXY(a^.X[i],a^.Y[i],'',clRed);
    end;
  end;
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

procedure MarkerDraw (Graph,Vax:PVector; Point:Integer; F:TForm1);
{процедура малювання вертикального маркера
в точці з номером Рoint масиву Graph;
в мітки виводяться номер та координати точки, через
яку проводиться маркер; координати виводяться
як точок вихідної ВАХ (масив VAX), так і перебудованої
кривої (з масиву Graph)}
begin
  F.Series3.Clear;
  F.Series3.AddXY(VaxGraph.X[Point],F.Series2.MinYValue);
  F.Series3.AddXY(Graph.X[Point],F.Series2.MaxYValue);
  F.Series3.Active:=True;
  F.LabMarN.Caption:='N='+IntToStr(Point+1+Graph.N_begin);
  F.LabMarX.Caption:='X='+FloatToStrF(Vax^.X[Point+Graph.N_begin],ffGeneral,4,3);
  F.LabMarY.Caption:='Y='+FloatToStrF(Vax^.Y[Point+Graph.N_begin],ffExponent,3,2);
  F.LabelMarXGr.Caption:='X='+FloatToStrF(Graph^.X[Point],ffExponent,2,1);
  F.LabelMarYGr.Caption:='Y='+FloatToStrF(Graph^.Y[Point],ffExponent,3,2);
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

procedure ApproxHide(Form1:TForm1);
{прибирається апроксимаційна крива,
відповідна кнопка переводиться в ненатиснутий стан}
begin
//  Form1.CBoxAppr.Checked:=False;
  Form1.SButFit.Down:=False;
  Form1.Series4.Active:=False;
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
Form1.CBoxGLShow.Checked:=False;
if High(GausLines)<0 then
  begin
    GausLinesFree;
    GaussLinesToGrid;
  end;
if Form1.SpButLimit.Down then Form1.SpButLimit.Down:=False;
ApproxHide(Form1);
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
                IVChar(VaxTempLim, VaxGraph);
                end;
ApproxHide(Form1);
end;

{procedure ParamExp(Form1:TForm1; A:IRE);
{записує на форму початкові значення аппроксимації
за формулою I=I0[exp(eV/nkT)-1]}
{begin
  Form1.LabelExpI0.Caption:='I0='+FloatToStrF(A[1],ffExponent,2,1);
  Form1.LabelExpN.Caption:='n='+FloatToStrF(A[3]/Kb/290,ffGeneral,3,2);
end;}

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
            LabelExpIph.Caption:=IphUsed(Iph_Exp);
          end;
   diEx: DiapShow(D[diEx],LabelExXmin,LabelExYmin,LabelExXmax,LabelExYmax);
   diNord:begin
            DiapShow(D[diNord],LabelNordXmin,LabelNordYmin,LabelNordXmax,LabelNordYmax);
            LabelNordGamma.Caption:='gamma= '+FloatToStrF(Gamma,ffGeneral,2,1);
            LabBohGam1.Caption:='gamma1 = '+FloatToStrF(Gamma1,ffGeneral,2,1);
            LabBohGam2.Caption:='gamma2 = '+FloatToStrF(Gamma2,ffGeneral,2,1);
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
           LabelLamIph.Caption:=IphUsed(Iph_Lam);
         end;
   diDE: begin
           DiapShow(D[diDE],LabelDEXmin,LabelDEYmin,LabelDEXmax,LabelDEYmax);
           LabelDEIph.Caption:=IphUsed(Iph_DE);
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

//procedure ModeShow(Mode:integer;Iph:boolean;LRs,LRsh,LIph:TLabel);
//{відображення режиму апроксимації
//ВАХ у відповідних мітках}
//begin
//if Iph then LIph.Caption:='Iph is varied'
//       else LIph.Caption:='Iph = 0';
//if (Mode=1)or(Mode=3) then LRsh.Caption:='Rsh = 1 TOhm'
//                      else LRsh.Caption:='Rsh is varied';
//if (Mode=2)or(Mode=3) then LRs.Caption:='Rs = 0 Ohm'
//                      else LRs.Caption:='Rs is varied';
//end;

//procedure ModeToForm(Mode:integer;Iph:boolean;CB_Rs,CB_Rsh,CB_Iph:TCheckBox);
//{встановлення перемикачів CB_Rs,CB_Rsh,CB_Iph
//відповідно до режиму апроксимації, що
//задається параметрами Mode та Iph}
//begin
//if (Mode=2) or (Mode=3) then CB_Rs.Checked:=False
//                        else CB_Rs.Checked:=True;
//if (Mode=1) or (Mode=3) then CB_Rsh.Checked:=False
//                        else CB_Rsh.Checked:=True;
//CB_Iph.Checked:=Iph;
//end;
//
//procedure FormToMode(CB_Rs,CB_Rsh,CB_Iph:TCheckBox;var Mode:integer;var Iph:boolean);
//{встановлення  режиму апроксимації
//(параметрів Mode та Iph) відповідно до
//перемикачів CB_Rs,CB_Rsh,CB_Iph}
//begin
//Iph:=CB_Iph.Checked;
//if (CB_Rsh.Checked)and(CB_Rsh.Checked) then Mode:=0;
//if not(CB_Rsh.Checked) then Mode:=1;
//if not(CB_Rs.Checked) then Mode:=2;
//if (not(CB_Rsh.Checked))and(not(CB_Rs.Checked)) then Mode:=3;
//end;

procedure StrToNumber(St:TCaption; Def:double; var Num:double);
{процедура переведення тестового рядка St в чисельне
значення Num;
якщо формат рядка поганий - змінна не зміниться,
буде показано віконечко з відповідним написом;
якщо рядок порожній - Num  буде присвоєне
значення Def}
var temp:real;
begin
if St='' then Num:=Def
         else
          begin
           try
            temp:=StrToFloat(St);
           except
            on Exception : EConvertError do
                   begin
                   ShowMessage(Exception.Message);
                   Exit;
                   end;
           end;//try
           Num:=temp;
          end;//else
end;


Function RsDefineCB(A:PVector; CB, CBdod:TComboBox):double;
{в залежності від вибраного значення
в списку ComboBox
визначаеться величина послідовного опору;
якщо у відповідному методі необхідне
значення n, то воно обчислюється залежно від того,
що вибрано в CBdod}
var n_tmp:double;
    Fit:TFitFunctionAAA;
begin
 Result:=ErResult;
 n_tmp:=ErResult;
 if (CB.ItemIndex>3)and(CB.ItemIndex<6)
        then
        begin
        n_tmp:=nDefineCB_Shot(A,CBdod);
        if n_tmp=ErResult then Exit;
        end;
 case CB.ItemIndex of
    0: //Rs не розраховується
     Result:=0;
    1:  //Rs рахується за допомогою функції Чюнга
     ChungKalk(A,D[diChung],Result,nn);
    4:  {Rs рахується за допомогою H-функції}
       HFunKalk(A,D[diHfunc],Diod,n_tmp,Result,Fbb);
    5: {Rs рахується за допомогою функції Норда}
       NordKalk(A,D[diNord],Diod,Gamma,n_tmp,Result,Fbb);
    2: {Rs рахується за допомогою функції Камінські І-роду}
       Kam1Kalk (A,D[diKam1],Result,nn);
    3: {Rs рахується за допомогою функції Камінські IІ-роду}
       Kam2Kalk (A,D[diKam2],Result,nn);
    6: {Rs рахується за допомогою виразу Rs=A+B*T}
       Result:=RA+RB*A^.T+RC*sqr(A^.T);
    7:{Rs рахується за допомогою методу Громова І-роду}
       Gr1Kalk (A,D[diGr1],Diod,Result,nn,Fbb,I00);
    8:{Rs рахується за допомогою методу Громова ІI-роду}
       Gr2Kalk (A,D[diGr2],Diod,Result,nn,Fbb,I00);
    9:{Rs рахується за допомогою методу Бохліна}
       BohlinKalk(A,D[diNord],Diod,Gamma1,Gamma2,Result,nn,Fbb,I00);
    10:{Rs рахується за допомогою методу Сібілса}
       CibilsKalk(A,D[diCib],Result,nn);
    11:{Rs рахується за допомогою методу Лі}
       LeeKalk (A,D[diLee],Diod,Result,nn,Fbb,I00);
    12:{Rs рахується за допомогою методу Вернера}
       WernerKalk(A,D[diWer],Result,nn);
    13:{Rs рахується за допомогою методу Міхелешвілі}
       MikhKalk (A,D[diMikh],Diod,Result,nn,I00,Fbb);
    14: //Rs рахується шляхом апроксимації
      //І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
     begin
        if Iph_Exp then Ft:=TPhotoDiodLSM.Create
                   else Ft:=TDiodLSM.Create;
        Fit.FittingDiapazon(A,EvolParam,D[diExp]);
        Result:=EvolParam[1];
        Fit.Free;
     end;
//          ExpKalkNew(A,D[diExp],Mode_Exp,Iph_Exp,0,AA,Sk,nn,I00,Fbb,Result,Rsh,Iph,Voc,Isc,Pm,FF);
    15: //Rs рахується шляхом апроксимації
      //І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph,
      //функцією Ламберта
      begin
        if Iph_Lam then Ft:=TPhotoDiodLam.Create
                   else Ft:=TDiodLam.Create;
        Fit.FittingDiapazon(A,EvolParam,D[diLam]);
        Result:=EvolParam[1];
        Fit.Free;
      end;
//      ExpKalkNew(A,D[diLam],Mode_Lam,Iph_Lam,1,AA,Sk,nn,I00,Fbb,Result,Rsh,Iph,Voc,Isc,Pm,FF);
    16: //Rs рахується шляхом апроксимації
      //І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph,
      //метод differential evolution
      begin
        if Iph_DE then Fit:=TPhotoDiod.Create
                   else Fit:=TDiod.Create;
        Fit.FittingDiapazon(A,EvolParam,D[diDE]);
        Result:=EvolParam[1];
        Fit.Free;
      end;
//      ExpKalkNew(A,D[diDE],Mode_DE,Iph_DE,2,AA,Sk,nn,I00,Fbb,Result,Rsh,Iph,Voc,Isc,Pm,FF);
    else;
 end; //case
end;

Function RsDefineCB_Shot(A:PVector; CB:TComboBox):double;
{в залежності від вибраного значення
в списку ComboBox
визначаеться величина послідовного опору,
використовується для методів,
які дозволяють визначити Rs спираючись
лише на вигляд ВАХ, без додаткових параметрів}
var Fit:TFitFunctionAAA;
begin
 Result:=ErResult;
 case CB.ItemIndex of
    0: //Rs не розраховується
     Result:=0;
    1:  //Rs рахується за допомогою функції Чюнга
     ChungKalk(A,D[diChung],Result,nn);
    2: {Rs рахується за допомогою функції Камінські І-роду}
       Kam1Kalk (A,D[diKam1],Result,nn);
    3: {Rs рахується за допомогою функції Камінські IІ-роду}
       Kam2Kalk (A,D[diKam2],Result,nn);
    4: {Rs рахується за допомогою виразу Rs=A+B*T}
       Result:=RA+RB*A^.T+RC*sqr(A^.T);
    5:{Rs рахується за допомогою методу Громова І-роду}
       Gr1Kalk (A,D[diGr1],Diod,Result,nn,Fbb,I00);
    6:{Rs рахується за допомогою методу Громова ІI-роду}
       Gr2Kalk (A,D[diGr2],Diod,Result,nn,Fbb,I00);
    7:{Rs рахується за допомогою методу Бохліна}
       BohlinKalk(A,D[diNord],Diod,Gamma1,Gamma2,Result,nn,Fbb,I00);
    8:{Rs рахується за допомогою методу Сібілса}
       CibilsKalk(A,D[diCib],Result,nn);
    9:{Rs рахується за допомогою методу Лі}
       LeeKalk (A,D[diLee],Diod,Result,nn,Fbb,I00);
    10:{Rs рахується за допомогою методу Вернера}
       WernerKalk(A,D[diWer],Result,nn);
    11:{Rs рахується за допомогою методу Міхелешвілі}
       MikhKalk (A,D[diMikh],Diod,Result,nn,I00,Fbb);
    12: //Rs рахується шляхом апроксимації
      //І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
     begin
        if Iph_Exp then Ft:=TPhotoDiodLSM.Create
                   else Ft:=TDiodLSM.Create;
        Fit.FittingDiapazon(A,EvolParam,D[diExp]);
        Result:=EvolParam[1];
        Fit.Free;
     end;
//       ExpKalkNew(A,D[diExp],Mode_Exp,Iph_Exp,0,AA,Sk,nn,I00,Fbb,Result,Rsh,Iph,Voc,Isc,Pm,FF);
    13: //Rs рахується шляхом апроксимації
      //І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph,
      //функцією Ламберта
      begin
        if Iph_Lam then Ft:=TPhotoDiodLam.Create
                   else Ft:=TDiodLam.Create;
        Fit.FittingDiapazon(A,EvolParam,D[diLam]);
        Result:=EvolParam[1];
        Fit.Free;
      end;
//       ExpKalkNew(A,D[diLam],Mode_Lam,Iph_Lam,1,AA,Sk,nn,I00,Fbb,Result,Rsh,Iph,Voc,Isc,Pm,FF);
    14: //Rs рахується шляхом апроксимації
      //І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph,
      //метод differential evolution
      begin
        if Iph_DE then Fit:=TPhotoDiod.Create
                   else Fit:=TDiod.Create;
        Fit.FittingDiapazon(A,EvolParam,D[diDE]);
        Result:=EvolParam[1];
        Fit.Free;
      end;
//       ExpKalkNew(A,D[diDE],Mode_DE,Iph_DE,2,AA,Sk,nn,I00,Fbb,Result,Rsh,Iph,Voc,Isc,Pm,FF);
    else;
 end; //case
end;

Function nDefineCB(A:PVector; CB, CBdod:TComboBox):double;
{в залежності від вибраного значення
в списку ComboBox
визначаеться величина коефіцієнту неідеальності;
якщо у відповідному методі необхідне
значення Rs, то воно обчислюється залежно від того,
що вибрано в CBdod}
var Rs_tmp:double;
    Fit:TFitFunctionAAA;
begin
Result:=ErResult;
Rs_tmp:=ErResult;
if CB.ItemIndex in [4,5,13,14] then
     begin
     Rs_tmp:=RsDefineCB_Shot(A,CBdod);
     if Rs_tmp=ErResult then Exit;
     end;
case CB.ItemIndex of
    0: // структура вважається ідеальною
     Result:=1;
    1:  //n рахується за допомогою функції Чюнга
//       Result:=n_T(A^.T);
//begin
//    Fit:=TDiod.Create;
//    Fit.FittingDiapazon(A,EvolParam,D[diDE]);
//    Result:=EvolParam[0];
//    Fit.Free;
//end;
     ChungKalk(A,D[diChung],Rss,Result);
    4:  //n рахується за допомогою апроксимації I=I0(exp(V/nkT)-1)
     ExpKalk(A,D[diExp],Rs_tmp,Diod,ApprExp,Result,I00,Fbb);
    5:   //n рахується за допомогою апроксимації I=I0exp(V/nkT)
     ExKalk(1,A,D[diEx],Rs_tmp,Diod,Result,I00,Fbb);
    2: //n рахується за допомогою функції Камінські І-роду
     Kam1Kalk (A,D[diKam1],Rss,Result);
    3: //n рахується за допомогою функції Камінські ІI-роду
     Kam2Kalk (A,D[diKam2],Rss,Result);
    6:{n рахується за допомогою методу Громова І-роду}
       Gr1Kalk (A,D[diGr1],Diod,Rss,Result,Fbb,I00);
    7:{n рахується за допомогою методу Громова ІI-роду}
       Gr2Kalk (A,D[diGr2],Diod,Rss,Result,Fbb,I00);
    8:{n рахується за допомогою методу Бохліна}
       BohlinKalk(A,D[diNord],Diod,Gamma1,Gamma2,Rss,Result,Fbb,I00);
    9:{n рахується за допомогою методу Сібілса}
       CibilsKalk(A,D[diCib],Rss,Result);
    10:{n рахується за допомогою методу Лі}
       LeeKalk (A,D[diLee],Diod,Rss,Result,Fbb,I00);
    11:{n рахується за допомогою методу Вернера}
       WernerKalk(A,D[diWer],Rss,Result);
    12:{n рахується за допомогою методу Міхелешвілі}
       MikhKalk (A,D[diMikh],Diod,Rss,Result,I00,Fbb);
    13: {n рахується за допомогою апроксимації
        І/[1-exp(-qV/kT)]=I0exp(V/nkT), пряма ділянка}
       ExKalk(2,A,D[diE2F],Rs_tmp,Diod,Result,I00,Fbb);
    14: {n рахується за допомогою апроксимації
        І/[1-exp(-qV/kT)]=I0exp(V/nkT), зворотня ділянка}
       ExKalk(3,A,D[diE2R],Rs_tmp,Diod,Result,I00,Fbb);
    15: //n рахується шляхом апроксимації
      //І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
     begin
        if Iph_Exp then Ft:=TPhotoDiodLSM.Create
                   else Ft:=TDiodLSM.Create;
        Fit.FittingDiapazon(A,EvolParam,D[diExp]);
        Result:=EvolParam[0];
        Fit.Free;
     end;
//       ExpKalkNew(A,D[diExp],Mode_Exp,Iph_Exp,0,AA,Sk,Result,I00,Fbb,Rss,Rsh,Iph,Voc,Isc,Pm,FF);
    16: //n рахується шляхом апроксимації
      //І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph,
      //функцією Ламберта
      begin
        if Iph_Lam then Ft:=TPhotoDiodLam.Create
                   else Ft:=TDiodLam.Create;
        Fit.FittingDiapazon(A,EvolParam,D[diLam]);
        Result:=EvolParam[0];
        Fit.Free;
      end;
//       ExpKalkNew(A,D[diLam],Mode_Lam,Iph_Lam,1,AA,Sk,Result,I00,Fbb,Rss,Rsh,Iph,Voc,Isc,Pm,FF);
    17: //n рахується шляхом апроксимації
      //І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph,
      //метод differential evolution
      begin
        if Iph_DE then Fit:=TPhotoDiod.Create
                   else Fit:=TDiod.Create;
        Fit.FittingDiapazon(A,EvolParam,D[diDE]);
        Result:=EvolParam[0];
        Fit.Free;
      end;
//       ExpKalkNew(A,D[diDE],Mode_DE,Iph_DE,2,AA,Sk,Result,I00,Fbb,Rss,Rsh,Iph,Voc,Isc,Pm,FF);
    else;
 end; //case
end;

Function nDefineCB_Shot(A:PVector; CB:TComboBox):double;
{в залежності від вибраного значення
в списку ComboBox
визначаеться величина коефіцієнту неідеальності,
використовується для методів,
які дозволяють визначити n спираючись
лише на вигляд ВАХ, без додаткових параметрів}
var Fit:TFitFunctionAAA;
begin
Result:=ErResult;
case CB.ItemIndex of
    0: // структура вважається ідеальною
     Result:=1;
    1:  //n рахується за допомогою функції Чюнга
     ChungKalk(A,D[diChung],Rss,Result);
    2: //n рахується за допомогою функції Камінські І-роду
     Kam1Kalk (A,D[diKam1],Rss,Result);
    3: //n рахується за допомогою функції Камінські ІI-роду
     Kam2Kalk (A,D[diKam2],Rss,Result);
    4:{n рахується за допомогою методу Громова І-роду}
      Gr1Kalk (A,D[diGr1],Diod,Rss,Result,Fbb,I00);
    5:{n рахується за допомогою методу Громова ІI-роду}
      Gr2Kalk (A,D[diGr2],Diod,Rss,Result,Fbb,I00);
    6:{n рахується за допомогою методу Бохліна}
      BohlinKalk(A,D[diNord],Diod,Gamma1,Gamma2,Rss,Result,Fbb,I00);
    7:{n рахується за допомогою методу Сібілса}
      CibilsKalk(A,D[diCib],Rss,Result);
    8:{n рахується за допомогою методу Лі}
      LeeKalk (A,D[diLee],Diod,Rss,Result,Fbb,I00);
    9:{n рахується за допомогою методу Вернера}
       WernerKalk(A,D[diWer],Rss,Result);
    10:{n рахується за допомогою методу Міхелешвілі}
       MikhKalk (A,D[diMikh],Diod,Rss,Result,I00,Fbb);
    11: //n рахується шляхом апроксимації
      //І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
     begin
        if Iph_Exp then Ft:=TPhotoDiodLSM.Create
                   else Ft:=TDiodLSM.Create;
        Fit.FittingDiapazon(A,EvolParam,D[diExp]);
        Result:=EvolParam[0];
        Fit.Free;
     end;
//       ExpKalkNew(A,D[diExp],Mode_Exp,Iph_Exp,0,AA,Sk,Result,I00,Fbb,Rss,Rsh,Iph,Voc,Isc,Pm,FF);
    12: //n рахується шляхом апроксимації
      //І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph,
      //функцією Ламберта
      begin
        if Iph_Lam then Ft:=TPhotoDiodLam.Create
                   else Ft:=TDiodLam.Create;
        Fit.FittingDiapazon(A,EvolParam,D[diLam]);
        Result:=EvolParam[0];
        Fit.Free;
      end;
//       ExpKalkNew(A,D[diLam],Mode_Lam,Iph_Lam,1,AA,Sk,Result,I00,Fbb,Rss,Rsh,Iph,Voc,Isc,Pm,FF);
    13: //n рахується шляхом апроксимації
      //І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph,
      //метод differential evolution
      begin
        if Iph_DE then Fit:=TPhotoDiod.Create
                   else Fit:=TDiod.Create;
        Fit.FittingDiapazon(A,EvolParam,D[diDE]);
        Result:=EvolParam[0];
        Fit.Free;
      end;
//       ExpKalkNew(A,D[diDE],Mode_DE,Iph_DE,2,AA,Sk,Result,I00,Fbb,Rss,Rsh,Iph,Voc,Isc,Pm,FF);
    else;
 end; //case
end;

Function FbDefineCB(A:PVector; CB:TComboBox; Rs:double):double;
{в залежності від вибраного значення
в списку ComboBox
визначаеться величина висоти бар'єру,
для деякий методів необхідне значення Rs,
яке використовується як параметр}
var Fit:TFitFunctionAAA;
begin
Result:=ErResult;
if (Rs=ErResult) and (CB.ItemIndex in [1,2]) then Exit;

case CB.ItemIndex of
    0: {Fb рахується за допомогою функції Норда}
     NordKalk(A,D[diNord],Diod,Gamma,nn,Rss,Result);
    1: //Fb рахується за допомогою апроксимації I=I0(exp(V/nkT)-1)
     ExpKalk(A,D[diExp],Rs,Diod,ApprExp,nn,I00,Result);
    2: //Fb рахується за допомогою апроксимації I=I0exp(V/nkT)
     ExKalk(1,A,D[diEx],Rs,Diod,nn,I00,Result);
    3:{Fb рахується за допомогою методу Громова І-роду}
      Gr1Kalk (A,D[diGr1],Diod,Rss,nn,Result,I00);
    4:{Fb рахується за допомогою методу Громова ІI-роду}
      Gr2Kalk (A,D[diGr2],Diod,Rss,nn,Result,I00);
    5:{Fb рахується за допомогою методу Бохліна}
      BohlinKalk(A,D[diNord],Diod,Gamma1,Gamma2,Rss,nn,Result,I00);
    6:{Fb рахується за допомогою методу Лі}
      LeeKalk (A,D[diLee],Diod,Rss,nn,Result,I00);
    7:{Fb рахується за допомогою методу Міхелешвілі}
       MikhKalk (A,D[diMikh],Diod,Rss,nn,I00,Result);
    8: {Fb рахується за допомогою апроксимації
        І/[1-exp(-qV/kT)]=I0exp(V/nkT), пряма ділянка}
      ExKalk(2,A,D[diE2F],Rs,Diod,nn,I00,Result);
    9: {Fb n рахується за допомогою апроксимації
        І/[1-exp(-qV/kT)]=I0exp(V/nkT), зворотня ділянка}
      ExKalk(3,A,D[diE2R],Rs,Diod,nn,I00,Result);
    10: //Fb рахується шляхом апроксимації
      //І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
      begin
        if Iph_Exp then Ft:=TPhotoDiodLam.Create
                   else Ft:=TDiodLam.Create;
        Fit.FittingDiapazon(A,EvolParam,D[diLam]);
        if Iph_Exp then Result:=ErResult
                   else Result:=Fit.DodX[0];
        Fit.Free;
      end;
//       ExpKalkNew(A,D[diExp],Mode_Exp,Iph_Exp,0,AA,Sk,nn,I00,Result,Rss,Rsh,Iph,Voc,Isc,Pm,FF);
    11: //Fb рахується шляхом апроксимації
      //І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph,
      //функцією Ламберта
      begin
        if Iph_Lam then Ft:=TPhotoDiodLam.Create
                   else Ft:=TDiodLam.Create;
        Fit.FittingDiapazon(A,EvolParam,D[diLam]);
        if Iph_Lam then Result:=ErResult
                   else Result:=Fit.DodX[0];
        Fit.Free;
      end;
//       ExpKalkNew(A,D[diLam],Mode_Lam,Iph_Lam,1,AA,Sk,nn,I00,Result,Rss,Rsh,Iph,Voc,Isc,Pm,FF);
    12: //Fb рахується шляхом апроксимації
      //І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph,
      //метод differential evolution
      begin
        if Iph_DE then Fit:=TPhotoDiod.Create
                   else Fit:=TDiod.Create;
        Fit.FittingDiapazon(A,EvolParam,D[diDE]);
        if Iph_DE then Result:=ErResult
                   else Result:=Fit.DodX[0];
        Fit.Free;
      end;
//       ExpKalkNew(A,D[diDE],Mode_DE,Iph_DE,2,AA,Sk,nn,I00,Result,Rss,Rsh,Iph,Voc,Isc,Pm,FF);
    else;
 end; //case
end;


Procedure ShowGraph(F:TForm1; st:string);
{намагається вивести на графік дані,
розташовані в VaxGraph;
якщо кількість точок в цьому масиві нульова -
виводиться вихідна ВАХ з файлу;
st - назва графіку}
begin
  if VaxGraph^.n=0 then
   begin
     F.FullIV.Checked:=True;
     IVchar(VaxFile,VaxGraph);
     DataToGraph(F.Series1,F.Series2,F.Graph,'I-V-characteristic',VaxGraph);
     IVChar(VaxGraph,VaxTemp);
   end
                 else
   begin
    DataToGraph(F.Series1,F.Series2,F.Graph, st ,VaxGraph);
    IVChar(VaxGraph,VaxTemp);
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

//Procedure DiodParam(F:TForm1;N_Mat:integer;var Ar:double; var Eps:double);
//{встановлення в залежності від значення N_Mat величин
//сталої Річардсона Ar, діелектричної проникності
//напівпровідника Eps та виведення цих значень
//у відповідний блок
//N_Mat
//1 - n-Si; 2 - p-Si; 3 - n-GaAs; 4 - n-InP;
//5 - 4H-SiC; 6 - n-GaN; 7 - n-CdTe; 8 - CuInSe2;
//9 - p-GaTe; 10 - p-GaSe; 11- Other
//У відповідних RadioButton Tag потрібно встановити
//так само як ці номери, тобто RBnSi.Tag=1, RBOther.Tag=11...
//}
//const
//   Nm=11;
//   Richard:array [1..Nm] of double=
//    (1.12e6, 0.32e6, 0.0816e6, 0.6e6, 0.75e6, 0.269e6,
//     0.12e6, 0.853e6, 1.19e6, 2.47e6, ErResult);
//   Perm:array [1..Nm] of double=
//    (11.7, 11.7, 12.9, 12.5, 9.7, 8.9,
//     ErResult, ErResult, ErResult, ErResult, ErResult);
//begin
//  F.LabelPerm.Visible:=True;
//  F.ButtonRich.Enabled:=False;
//  F.ButtonPerm.Enabled:=False;
//  if (Richard[N_Mat]<>ErResult) then Ar:=Richard[N_Mat];
//  if (Perm[N_Mat]<>ErResult) then Eps:=Perm[N_Mat]
//                        else F.LabelPerm.Visible:=False;
//  if N_Mat=Nm then
//    begin
//    F.LabelPerm.Visible:=True;
//    F.ButtonRich.Enabled:=True;
//    F.ButtonPerm.Enabled:=True;
//    end;
// F.LabelRich.Caption:=FloatToStrF(Ar,ffExponent,3,2);
// F.LabelPerm.Caption:=FloatToStrF(Eps,ffGeneral,3,2);
//end;

Procedure MaterialOnForm;
{виведення на форму параметрів матеріалу, які
беруться зі змінної Semi}
begin
with Form1 do
 begin
  if Semi.Eg0<>ErResult
     then LabelEg.Caption:=FloatToStrF(Semi.Eg0,ffFixed,3,2)
     else LabelEg.Caption:='?';
  LabelPerm.Caption:=FloatToStrF(Semi.Eps,ffFixed,3,2);
  LabelMeff.Caption:=FloatToStrF(Semi.Meff,ffFixed,3,2);
  if Semi.ARich<>ErResult
     then LabelRich.Caption:=FloatToStrF(Semi.ARich,ffExponent,3,2)
     else LabelRich.Caption:='?';
  if Semi.VarshA<>ErResult
     then LabelVarA.Caption:=FloatToStrF(Semi.VarshA,ffgeneral,5,1)
     else LabelVarA.Caption:='?';
  if Semi.VarshB<>ErResult
     then LabelVarB.Caption:=FloatToStrF(Semi.VarshB,ffExponent,3,2)
     else LabelVarB.Caption:='?';
  if Semi.Name=Materials[High(TMaterialName)].Name then
      begin
       LaVarB.Visible:=True;
       LaVarA.Visible:=True;
       LaMeff.Visible:=True;
       LaPerm.Visible:=True;
       LaEg.Visible:=True;
       LaRich.Visible:=True;
      end
                                                 else
      begin
       LaVarB.Visible:=False;
       LaVarA.Visible:=False;
       LaMeff.Visible:=False;
       LaPerm.Visible:=False;
       LaEg.Visible:=False;
       LaRich.Visible:=False;
      end

 end;//with Form1 do
end;

Procedure DiodOnForm;
{виведення на форму параметрів діоду, які
беруться зі змінної Diod}
begin
with Form1 do
 begin
  LabelArea.Caption:=FloatToStrF(Diod.Area,ffExponent,3,2);
  LabelConcentr.Caption:=FloatToStrF(Diod.Nd,ffExponent,3,2);
  LabelDel.Caption:=FloatToStrF(Diod.Thick_i,ffExponent,3,2);
  LabelEp.Caption:=FloatToStrF(Diod.Eps_i,ffFixed,3,2);
 end;//with Form1 do
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
Dates.ColCount:=4;
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
 if VaxFile^.n>0 then
  begin
   FileToDataSheet(F.DataSheet,F.NameFile,F.Temper,VaxFile);
   ClearGraph(Form1);
   IVchar(VaxFile,VaxGraph);
   DataToGraph(F.Series1,F.Series2,F.Graph,'I-V-characteristic',VaxGraph);
   IVChar(VaxGraph,VaxTemp);
   F.FullIV.Checked:=True;

   for I := 0 to F.ComponentCount-1 do
   begin
     if (F.Components[i].Tag=55) then
      (F.Components[i] as TControl).Enabled:=True;
     if (F.Components[i].Tag=56) then
       if VaxFile^.T>0 then (F.Components[i] as TControl).Enabled:=True
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
//    if SEGauss.Value=0 then Exit;

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
    ConfigFile:TIniFile;
    i:integer;
    st:string;
begin
 ConfigFile:=TIniFile.Create(Directory0+'\Shottky.ini');
 ConfigFile.WriteInteger('Gauss','NLine',High(GausLinesCur));
   for I := 1 to High(GausLinesCur) do
     begin
       st:=inttostr(i);
       ConfigFile.WriteFloat('Gauss','A'+st,GausLinesCur[i].A);
       ConfigFile.WriteFloat('Gauss','B'+st,GausLinesCur[i].B);
       ConfigFile.WriteFloat('Gauss','C'+st,GausLinesCur[i].C);
     end;
 ConfigFile.Free;
end;

Procedure GausLinesLoad;
{зчитування пареметрів гаусіан з ini-файла}
var
    ConfigFile:TIniFile;
    i:integer;
    st:string;
begin
 ConfigFile:=TIniFile.Create(Directory0+'\Shottky.ini');
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
 ConfigFile.Free;
end;


Procedure GaussLinesToGrid;
{виведення параметрів гаусіан у таблицю}
 Function Eg(T:double):double;
  {обчислення ширина забороненої зони кремнію
  при температурі Т}
  begin
    Result:=1.169-7.021e-4*T*T/(T+1108);
  end;
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
    Form1.SGridGaussian.Cells[2,Form1.SGridGaussian.RowCount-4]:=
      FloatToStrF((Eg(VaxFile.T)-GausLinesCur[i].B)/2,ffFixed,3,2);
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
//Result:=Default;
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
           if Iph_exp then  DpName:='ExpIph';
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
             if Iph_Lam then  DpName:='PhotoDiodLam';
           end;
    diDE:  begin
            DpName:='DoubleDiod';
            PictLoadScale(Img,'ExpFig');
            if Iph_DE then
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
           GEdit.Text:=FloatToStrF(Gamma,ffGeneral,2,1);
           GEdit.Top:=GLab.Top;
           GEdit.Left:=GLab.Left+GLab.Width+10;
           GEdit.Name:='Gamma';

           VerticalEnd:=GLab.Top+Glab.Height;

           if  BohlinMethod then
             begin
              GEdit.Name:='Gamma1';
              GLab.Caption:='Input values:   gamma1=';

              GEdit.Text:=FloatToStrF(Gamma1,ffGeneral,2,1);
              GEdit.Left:=GLab.Left+GLab.Width+4;

              GEdit2:=TLabeledEdit.Create(Form);
              GEdit2.Parent:=Form;
              GEdit2.Text:=FloatToStrF(Gamma2,ffGeneral,2,1);
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
           Iph_CB.Checked:=Iph_Exp;
           Iph_CB.Name:='ExpFormCB';
           Param_But.Name:='ExpFormBut';
          end;

        if DpType=diLam then
          begin
           Iph_CB.Checked:=Iph_Lam;
           Iph_CB.Name:='LamFormCB';
           Param_But.Name:='LamFormBut';
          end;

        if DpType=diDE then
          begin
            Iph_CB.Checked:=Iph_DE;
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

     if (DpType=diNord)and(not(BohlinMethod)) then   EditToFloat('Gamma',Gamma);
     if BohlinMethod then
       begin
        EditToFloat('Gamma1',Gamma1);
        LabeledEditToFloat('Gamma2',Gamma2);
        if abs(Gamma2-Gamma1)<1e-3 then
                    begin
                    Gamma1:=2;
                    Gamma2:=2.5;
                    MessageDlg('Gamma1 cannot be equal Gamma2', mtError,[mbOk],0);
                    end;
       end;
     if DpType=diExp then CheckBoxToBool('ExpFormCB',Iph_Exp);
     if DpType=diLam then CheckBoxToBool('LamFormCB',Iph_Lam);
     if DpType=diDE then
      begin
        CheckBoxToBool('DEFormCB',Iph_DE);
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
   if Form1.CBKalk.Items[Form1.CBKalk.ItemIndex]='Cibils' then Result:=diCib;
   if Form1.CBKalk.Items[Form1.CBKalk.ItemIndex]='Cheung' then Result:=diChung;
   if Form1.CBKalk.Items[Form1.CBKalk.ItemIndex]='If/[1-exp(-qVf/kT)]' then Result:=diE2F;
   if Form1.CBKalk.Items[Form1.CBKalk.ItemIndex]='Ir/[1-exp(-qVr/kT)]' then Result:=diE2R;
   if Form1.CBKalk.Items[Form1.CBKalk.ItemIndex]='Ivanov' then Result:=diIvan;
   if Form1.CBKalk.Items[Form1.CBKalk.ItemIndex]='Werner' then Result:=diWer;
   if Form1.CBKalk.Items[Form1.CBKalk.ItemIndex]='H-function' then Result:=diHfunc;
   if Form1.CBKalk.Items[Form1.CBKalk.ItemIndex]='Mikhelashvili' then Result:=diMikh;
   if Form1.CBKalk.Items[Form1.CBKalk.ItemIndex]='Lee' then Result:=diLee;
   if Form1.CBKalk.Items[Form1.CBKalk.ItemIndex]='Gromov I' then Result:=diGr1;
   if Form1.CBKalk.Items[Form1.CBKalk.ItemIndex]='Gromov II' then Result:=diGr2;
   if Form1.CBKalk.Items[Form1.CBKalk.ItemIndex]='Kaminskii I' then Result:=diKam1;
   if Form1.CBKalk.Items[Form1.CBKalk.ItemIndex]='Kaminskii II' then Result:=diKam2;
   if Form1.CBKalk.Items[Form1.CBKalk.ItemIndex]='I=I0exp(eV/nkT)' then Result:=diEx;
   if Form1.CBKalk.Items[Form1.CBKalk.ItemIndex]='Norde' then Result:=diNord;
   if Form1.CBKalk.Items[Form1.CBKalk.ItemIndex]='Bohlin' then
                                          begin
                                            Result:=diNord;
                                            bohlin:=true;
                                          end;
   if Form1.CBKalk.Items[Form1.CBKalk.ItemIndex]='I=I0[exp(Vef/E)-1]+Vef/Rsh-Iph' then Result:=diExp;
   if Form1.CBKalk.Items[Form1.CBKalk.ItemIndex]='Lambert function' then Result:=diLam;
   if Form1.CBKalk.Items[Form1.CBKalk.ItemIndex]='Evolution Algorithm' then Result:=diDE;
  end;
end;

procedure TForm1.FormDpKeyPress(Sender: TObject; var Key: Char);
begin
if Key=#13 then
    begin
    SelectNext((Sender as TForm).ActiveControl,True,True);
    Key:=#0;
    end;
if not(Key in [#8,'0'..'9','+','-','E','e',DecimalSeparator])
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
    F:TFitFunction;
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
           then FuncName:='PhotoDiod, LSM'
           else FuncName:='Diod, LSM';
        end;
    end;

  if (Sender is TButton)and((Sender as TButton).Name='LamFormBut') then
    begin
     for I := 0 to (Sender as TButton).Parent.ComponentCount-1 do
       if ((Sender as TButton).Parent.Components[i] is TCheckBox) then
        begin
          if ((Sender as TButton).Parent.Components[i] as TCheckBox).Checked
           then FuncName:='PhotoDiod, Lambert'
           else FuncName:='Diod, Lambert';
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
             if boolDD then FuncName:='Photo D-Diod'
                       else FuncName:='PhotoDiod'
                else
             if boolDD then FuncName:='D-Diod'
                         else FuncName:='Diod';
    end;


FunCreate(FuncName,F);
if  not(Assigned(F)) then Exit;
F.SetValueGR;
F.Free;
end;



Procedure dB_dV_Fun(A:Pvector; var B:Pvector; fun:byte;
                    FitName:string;Rbool:boolean);
{по даним у векторі А будує залежність похідної
диференційного нахилу ВАХ від напруги (метод Булярського)
fun - кількість зглажувань
Rbool=true - потрібно враховувати послідовний
та шунтуючі опори;
FitName - назва функції, якв буде використовуватись
для апроксимації}

var j,id:integer;
    temp,A_apr,{temp_apr,}B_apr,Alim:Pvector;
    tsingle:double;
//    Fit:TFitFunction;
    Light:boolean;
    Diap:TDiapazon;
begin
  Light:=false;
  Diap:=D[diDE];

  if (FitName= FuncName[10])or
     (FitName= FuncName[12])or
     (FitName= FuncName[14])or
     (FitName= FuncName[20])
              then Light:=true;


  if (FitName= FuncName[12])or
     (FitName= FuncName[11])
              then Diap:=D[diExp];

  if (FitName= FuncName[14])or
     (FitName= FuncName[13])
              then Diap:=D[diLam];

//  showmessage(BooltoStr(Light));

 B^.n:=0;
 new(Alim);
 A_B_Diapazon(A,Alim,Diap,Light);


 if (Alim^.T=0)or(Alim^.n<3) then
     begin
     dispose(Alim);
     Exit;
     end;

  new(temp);
  IVchar(Alim,temp);

  Diferen (temp,B);

 if B^.n=0 then
           begin
            dispose(temp);
            dispose(Alim);
            Exit;
          end;

 tsingle:=Alim^.T*Kb;
 for j:=0 to High(B^.X) do
        B^.Y[j]:=1/B^.Y[j]*Alim^.Y[j]/tsingle;

 ForwardIV(B,temp);
 IVchar(temp,B);

 for j:=1 to fun do
  begin
   Smoothing (B,temp);
   IVchar(temp,B);
  end;

 Diferen (B,temp);

 id:=0;
 for j:=0 to High(temp^.X) do
        if (temp^.X[j]>0.038)and(temp^.X[j]<(temp^.X[High(temp^.X)]-0.04)) then id:=id+1;
 if id<1 then
     begin
       B^.n:=0;
       dispose(temp);
       dispose(Alim);
       Exit;
     end;

 SetLenVector(B,id);

 id:=0;
 for j:=0 to High(temp^.X) do
        if (temp^.X[j]>0.038)and(temp^.X[j]<(temp^.X[High(temp^.X)]-0.04)) then
         begin
          B^.X[id]:=temp^.X[j];
          B^.Y[id]:=temp^.Y[j];
          id:=id+1;
         end;

 dispose(temp);
//--------------------------------------------



if Rbool then
  begin
  FunCreate(FitName,Fit);
  Fit.Fitting(Alim,EvolParam);
  if EvolParam[0]=ErResult then
          begin
            dispose(Alim);
            Exit;
          end;
  new(A_apr);
  new(temp);
  IVchar(Alim,A_apr);
  for j:=0 to High(Alim^.X) do
     A_apr^.Y[j]:=Fit.FinalFunc(Alim^.X[j],EvolParam);

  Fit.Free;  
  IVchar(A_apr,temp);
  new(B_apr);
  Diferen (temp,B_apr);

  for j:=0 to High(B_apr^.X) do
      B_apr^.Y[j]:=1/B_apr^.Y[j]*A_apr^.Y[j]/tsingle;
  dispose(A_apr);

  ForwardIV(B_apr,temp);
  IVchar(temp,B_apr);



  for j:=1 to fun do
   begin
     Smoothing (B_apr,temp);
     IVchar(temp,B_apr);
   end;
 Diferen (B_apr,temp);

 SetLenVector(B_apr,B^.n);
 id:=0;
 for j:=0 to High(temp^.X) do
        if (temp^.X[j]>0.038)and(temp^.X[j]<(temp^.X[High(temp^.X)]-0.04)) then
         begin
          B_apr^.X[id]:=temp^.X[j];
          B_apr^.Y[id]:=temp^.Y[j];
          id:=id+1;
         end;
  for j := 0 to High(B^.X) do
    B^.Y[j]:=B^.Y[j]-B_apr^.Y[j];
//  showmessage(FitName);

 dispose(temp);
 dispose(B_apr);
 end;  //if Rbool then

  dispose(Alim);
// if (Rbool)and(Light) then DataFileWrite('rez.dat',A,EvolParam);
end;

end.

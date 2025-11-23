unit OApproxCaption;

interface

uses
  OApproxNew, FitDigital, FitSimple, FitGradient, OApproxFunction, 
  OApproxFunction2, OApproxFunction3, FitManyArguments, OlegParametricFitting;

type
  TFitFuncCategory=(ffc_none,ffc_trans,ffc_digital,
                   ffc_simple,ffc_schottky,ffc_cc,ffc_diode,ffc_2diode,
                   ffc_3diode,ffc_ThinDiode,ffc_Custom,ffc_fb, ffc_is);

  TFitFunctionNew_Class=class of TFitFunctionNew;


const
  FitFuncCategoryNames:array[TFitFuncCategory]of string=
           ('None','Transform','Digital filter','Simple',
           'Schottky diode','Complex current','n-p diode','Double Diode',
           'Triple diode','Thin film diode','Custom','Fe-B','Impedance spectroscopy');

  FFFunctionDiod='Diode';
  FFFunctionPhotoDiod='PhotoDiode';
  FFFunctionDiodLSM='Diode, LSM';
  FFFunctionPhotoDiodLSM='PhotoDiode, LSM';
  FFFunctionDiodLambert='Diode, Lambert';
  FFFunctionPhotoDiodLambert='PhotoDiode, Lambert';
  FFFunctionDDiod='2-Diode';
  FFFunctionPhotoDDiod='2-Diode, illum';


//  FitFuncCategoryNumbers:array[TFitFuncCategory]of integer=
//           (-1,  //ffc_none
//            5,   //ffc_trans
//            9,   //ffc_digital
//            4,   //ffc_simple
//            1,   //ffc_schottky
//            4,   //ffc_diode
//            0);  //ffc_ThinDiode


  DFNumber=9;
  DFNames:array[0..DFNumber]of string=
   ('LP IIR Chebyshev', 'LP IIR Uniform',
    'LP IIR Uniform, 4k','LP FIR Simple Window',
    'LP FIR Blackman','LP FIR Hamming',
    'LP FIR Hann', 'LP FIR Bartlett',
    'LP FIR Chebyshev','HP FIR Simple Window');
  DFClasses:array[0..DFNumber]of TFitFunctionNew_Class=
  (TFFLP_IIR_Chebyshev,TFFLP_UniformIIRFilter,TFFLP_UniformIIRFilter4k,
  TFFLP_FIR_SimpleWindow,TFFLP_FIR_Blackman,TFFLP_FIR_HammingWindow,
  TFFLP_FIR_HannWindow,TFFLP_FIR_BartlettWindow,
  TFFLP_FIR_ChebyshevWindow,TFFHP_FIR_SimpleWindow);


  SFNumber=6;
  SFNames:array[0..SFNumber] of string=
   ('Linear','Ohm law','Quadratic function','Gromov / Lee',
   'Polynomial fitting','Variate Polynomial','Two power');
   SFClasses:array[0..SFNumber]of TFitFunctionNew_Class=
   (TFFLinear,TFFOhmLaw,TFFQuadratic,TFFGromov,
   TFFPolinom,TFFTwoPower,TFFPower2);

  SchDNumber=5;
  SchDNames:array[0..SchDNumber] of string=
   ('Exponent','Ivanov method','D-Gaussian','Patch Barrier',
   'Barrier height','TE reverse');
   SchDClasses:array[0..SchDNumber]of TFitFunctionNew_Class=
   (TFFExponent,TFFIvanov,TFFDGaus,TFFLinEg,
   TFFBarierHeigh,TFFRevSh);

  CCNumber=11;
  CCNames:array[0..CCNumber] of string=
   ('TE and SCLC on 1/kT','TE and SCLCexp on 1/kT',
    'TEstrict and SCLCexp on 1/kT','TE and TAHT on 1/kT',
    'TE and SCLC on V','TE and SCLC on V (II)','TE and SCLC on V (III)',
    'Phonon Tunneling on 1/kT','PAT and TE on 1/kT','PAT and TEsoft on 1/kT',
    'Phonon Tunneling on V','PAT and TE on V');
  CCClasses:array[0..CCNumber]of TFitFunctionNew_Class=
   (TFFTEandSCLC_kT1,TFFTEandSCLCexp_kT1,
   TFFTEstrAndSCLCexp_kT1,TFFTEandTAHT_kT1,
   TFFTEandSCLCV,TFFRevShSCLC3,TFFRevShSCLC2,
   TFFPhonAsTun_kT1,TFFPATandTE_kT1,TFFPhonAsTunAndTE2_kT1,
   TFFPhonAsTun_V,TFFPATandTE_V);

  DiodNumber=5;
  DiodNames:array[0..DiodNumber] of string=
   (FFFunctionDiod,FFFunctionDiodLSM,FFFunctionDiodLambert,
    FFFunctionPhotoDiod,FFFunctionPhotoDiodLSM,FFFunctionPhotoDiodLambert);
  DiodClasses:array[0..DiodNumber]of TFitFunctionNew_Class=
   (TFFDiod,TFFDiodLSM,TFFDiodLam,
    TFFPhotoDiod,TFFPhotoDiodLSM,TFFPhotoDiodLam);

  TwoDiodNumber=4;
  TwoDiodNames:array[0..TwoDiodNumber] of string=
   (FFFunctionDDiod,'2-Diode, Tau','Two Diode Full',
    FFFunctionPhotoDDiod,'2-Diode, Tau, illum');
  TwoDiodClasses:array[0..TwoDiodNumber]of TFitFunctionNew_Class=
   (TFFDoubleDiod,TFFDoubleDiodTau,TFFDiodTwoFull,
    TFFDoubleDiodLight,TFFDoubleDiodTauLight);

  ThreeDiodNumber=1;
  ThreeDiodNames:array[0..ThreeDiodNumber] of string=
   ('3-Diode','3-Diode, illum');
  ThreeDiodClasses:array[0..ThreeDiodNumber]of TFitFunctionNew_Class=
   (TFFTripleDiod,TFFTripleDiodLight);

  ThinDiodeNumber=4;
  ThinDiodeNames:array[0..ThinDiodeNumber] of string=
   ('IV thin SC','Tun. diode forward',
   'Illum. tun. diode',
   'TAT reverse', 'TAT reverse & Rs');
  ThinDiodeClasses:array[0..ThinDiodeNumber]of TFitFunctionNew_Class=
   (TFFIV_thin,TFFDiodTun,
    TFFPhotoDiodTun,
    TFFTunRevers,TFFTunReversRs);

  CustomNumber=14;
  CustomNames:array[0..CustomNumber] of string=
   ('Lifetime in SCR','Mobility','n vs T (donors and traps)',
   'Tau DAP','Rsh vs T','Rsh,2 vs T','N Gausian','Tunneling rect.',
   'Tunneling trap.','Brailsford on T','Brailsford on w',
   'Shot-circuit Current','n vs T in CdTe','SC parameters',
   'Planck function');
  CustomClasses:array[0..CustomNumber]of TFitFunctionNew_Class=
   (TFFTauG,TFFMobility,TFFElectronConcentration,
   TFFTauDAP,TFFRsh_T,TFFRsh2_T,TFFNGausian,TFFTunnel,
   TFFTunnelFNmy,TFFBrailsford,TFFBrailsfordw,
   TFFCurrentSC,TFFElectronConcentrationDX,TFFPVParareters,TFFPlanc);

  FeBNumber=5;
  FeBNames:array[0..FeBNumber] of string=
   ('Ideal. Factor vs T','Ideal. Factor vs T & N_B & N_Fe',
   'Ideal. Factor vs T & N_B','Tau Fei-FeB','Isc Fei->FeB','Isc Fei->FeB - 2');
  FeBClasses:array[0..FeBNumber]of TFitFunctionNew_Class=
   (TFFnFeBPart,TFFn_FeB,
   TFFn_FeBNew,TFFTAU_Fei_FeB,TFFIsc_Fei_FeB,TFFIsc2_Fei_FeB);

  ISNumber=0;
  ISNames:array[0..ISNumber] of string=
   ('Rp - (Rs || CPE)');
  ISClasses:array[0..ISNumber]of TFitFunctionNew_Class=
   (TFF_IS_RRCPE);

var
  FitFuncNames:array[TFitFuncCategory]of array of string;


Function FitFunctionFactory(str:string; FileName:string=''):TFitFunctionNew;
{створює F того чи іншого типу залежно
від значення str}


procedure FitFuncNames_trans_Filling;

procedure FitFuncNames_Filling(ffc:TFitFuncCategory;
                               Names:array of string);

implementation

uses
  FitTransform;

procedure FitFuncNames_Filling(ffc:TFitFuncCategory;Names:array of string);
  var i:integer;
begin
   SetLength(FitFuncNames[ffc],Length(Names));
   for I := 0 to High(FitFuncNames[ffc]) do
    FitFuncNames[ffc,i]:=Names[i+Low(Names)];
end;


procedure FitFuncNames_trans_Filling;
  var i:TTransformFunction;
begin
 SetLength(FitFuncNames[ffc_trans],ord(High(TTransformFunction))+4);
  for I := Low(TTransformFunction) to High(TTransformFunction) do
   FitFuncNames[ffc_trans,ord(I)]:=TransformFunctionNames[i];
 FitFuncNames[ffc_trans,High(FitFuncNames[ffc_trans])-2]:='Moving Average Filter';
 FitFuncNames[ffc_trans,High(FitFuncNames[ffc_trans])-1]:='Noise Smoothing';
 FitFuncNames[ffc_trans,High(FitFuncNames[ffc_trans])]:='Cubic splines';
end;

Function FitFunctionFactory(str:string; FileName:string=''):TFitFunctionNew;
{створює F того чи іншого типу залежно
від значення str}
  var i:TTransformFunction;
      j:integer;
begin
   Result:=nil;

   for I := Low(TTransformFunction)
                to High(TTransformFunction) do
      if str=TransformFunctionNames[i] then
        begin
          Result:=TFitTransform.Create(str);
          Exit;
        end;

   for j := 0 to DFNumber do
      if str=DFNames[j] then
       begin
         Result:=DFClasses[j].Create;
         Exit;
       end;

   for j := 0 to SFNumber do
      if str=SFNames[j] then
       begin
         Result:=SFClasses[j].Create;
         Exit;
       end;

   for j := 0 to SchDNumber do
      if str=SchDNames[j] then
       begin
         Result:=SchDClasses[j].Create;
         Exit;
       end;

   for j := 0 to CCNumber do
      if str=CCNames[j] then
       begin
         Result:=CCClasses[j].Create;
         Exit;
       end;

   for j := 0 to DiodNumber do
      if str=DiodNames[j] then
       begin
         Result:=DiodClasses[j].Create;
         Exit;
       end;

   for j := 0 to TwoDiodNumber do
      if str=TwoDiodNames[j] then
       begin
         Result:=TwoDiodClasses[j].Create;
         Exit;
       end;

   for j := 0 to ThreeDiodNumber do
      if str=ThreeDiodNames[j] then
       begin
         Result:=ThreeDiodClasses[j].Create;
         Exit;
       end;

   for j := 0 to ThinDiodeNumber do
      if str=ThinDiodeNames[j] then
       begin
         Result:=ThinDiodeClasses[j].Create;
         Exit;
       end;

   for j := 0 to CustomNumber do
     if str=CustomNames[j] then
      begin
       Result:=CustomClasses[j].Create;
       Exit;
      end;

   for j := 0 to FeBNumber do
     if str=FeBNames[j] then
      begin
       Result:=FeBClasses[j].Create;
       Exit;
      end;

   for j := 0 to ISNumber do
     if str=ISNames[j] then
      begin
       Result:=ISClasses[j].Create;
       Exit;
      end;

   if str='Moving Average Filter' then
     begin
     Result:=TFFMovingAverageFilter.Create;
     Exit;
     end;



 if str='Noise Smoothing' then
     begin
     Result:=TFFNoiseSmoothing.Create;
     Exit;
     end;

 if str='Cubic splines' then
     begin
     Result:=TFFSplain.Create;
     Exit;
     end;

end;


initialization
 FitFuncNames_trans_Filling;
 FitFuncNames_Filling(ffc_digital,DFNames);
 FitFuncNames_Filling(ffc_simple,SFNames);
 FitFuncNames_Filling(ffc_schottky,SchDNames);
 FitFuncNames_Filling(ffc_cc,CCNames);
 FitFuncNames_Filling(ffc_diode,DiodNames);
 FitFuncNames_Filling(ffc_2diode,TwoDiodNames);
 FitFuncNames_Filling(ffc_3diode,ThreeDiodNames);
 FitFuncNames_Filling(ffc_ThinDiode,ThinDiodeNames);
 FitFuncNames_Filling(ffc_Custom,CustomNames);
 FitFuncNames_Filling(ffc_fb,FeBNames);
 FitFuncNames_Filling(ffc_is,ISNames);

end.

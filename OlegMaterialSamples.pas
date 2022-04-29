unit OlegMaterialSamples;

interface
uses IniFiles, TypInfo, OlegType,SysUtils,Dialogs, StdCtrls,
     OlegFunction,OlegMath, OlegVector;
type
    TMaterialName=(Si,GaAs,InP,H4SiC,GaN,CdTe,CdS,CdSe,CuInSe2,GaTe,GaSe,Ge,Other);
    TMaterialParametersName=(
            nEg0,   //ширина забороненої зони при T=0, []=eV
            nEps,   //діелектрична проникність
            nARich_n, //стала Річардсона для матеріалу n-типу, []=A/(m^2 A^2)
            nARich_p, //стала Річардсона для матеріалу p-типу, []=A/(m^2 A^2)
            nMe,  //відношення ефективної маси електрона до маси спокою електрона
            nMh,  //відношення ефективної маси дірки до маси спокою електрона
                //рівняння Варшні Eg(T)=Eg(0)-B*T^2/(T+A)
            nVarshA, //параметр А з рівняння Варшні
            nVarshB //параметр В з рівняння Варшні
             );
    TMaterialParameters=record
          Name:string;
          Parameters:array[TMaterialParametersName]of double;
          end;

    TSiAbsorbTable=(abGreen,     //M.A. Green / Solar Energy Materials & Solar Cells 92 (2008) 1305–1310
                    abSchinke    //Schinke at el / AIP ADVANCES 5, 067168 (2015)
                    );
//    TAbsorbParamNames=(nLambda,nCoef,nTemCoef);
//    TAbsorbParam=array[TAbsorbParamNames] of double;
//    TAbsorbParamArray=array of TAbsorbParam;

const
  VarshB_Si=7.021e-4;
  VarshA_Si=1108;
  Eg0_Si=1.169;




  Materials:array [TMaterialName] of TMaterialParameters=

//                                Eg0,     Eps,  ARich_n,  ARich_p,  Me,   Mh,   VarshA,   VarshB
   ((Name:'Si';     Parameters: (Eg0_Si,   11.7, 1.12e6,   0.32e6,   1.08, 0.58, VarshA_Si,VarshB_Si)),
    (Name:'GaAs';   Parameters: (1.519,    12.9, 8.16e4,   ErResult, 0.063,0.52, 204,      5.405e-4)),
    (Name:'InP';    Parameters: (1.42,     12.5, 0.6e6,    ErResult, 0.079,0.60, 327,      4.906e-4)),
    (Name:'4H-SiC'; Parameters: (3.26,     9.7,  0.75e6,   ErResult, 0.42, 1,    1300,     6.5e-4)),
    (Name:'GaN';    Parameters: (3.47,     8.9,  2.64e5,   7.50e5,   0.22, 0.60, 600,      7.7e-4)),
    (Name:'CdTe';   Parameters: (1.586,    10.2, 0.12e6,   ErResult, 0.11, 0.4,  160,      5.9117e-4)),
    (Name:'CdS';    Parameters: (2.557,    5.4,  2.34e5,   ErResult, 0.21, 0.8,  450,      8.21e-4)),
    (Name:'CdSe';   Parameters: (1.9,      10.2, 1.56e5,   ErResult, 0.13, 0.45, 0,        2.8e-4)),
    (Name:'CuInSe2';Parameters: (ErResult, 1,    8.53e5,   ErResult, 1,    1,    ErResult, ErResult)),
    (Name:'GaTe';   Parameters: (ErResult, 1,    1.19e6,   ErResult, 1,    1,    ErResult, ErResult)),
    (Name:'GaSe';   Parameters: (ErResult, 1,    2.47e6,   ErResult, 1,    1,    ErResult, ErResult)),
    (Name:'Ge';     Parameters: (0.7437,   16,   1.4e6,    ErResult, 0.55, 0.36, 235,      4.774e-4)),
    (Name:'Other';  Parameters: (ErResult, 1,    ErResult, ErResult, 1,    1,    ErResult, ErResult))
    );


   SecDiod='Parameters';
//   ім'я секції в .ini-файлі,
//   де зберігаються параметри діода

 T0_Siabsorb:array [TSiAbsorbTable] of double=(300,295);
 Lambda_Siabsorb:array [TSiAbsorbTable] of array of double=
 ([250, 260, 270,	280, 290,	300, 310,	320, 330,	340,	350,	360,
       370,	380,	390,	400,	410,	420,	430,  440,	450,	460,
       470,	480,	490,	500,	510,	520,	530,	540,	550,	560,
       570,	580,	590,	600,	610,	620,	630,	640,	650,	660,
       670,	680,	690,	700,	710,	720,	730,	740,	750,	760,
       770,	780,	790,	800,	810,	820,	830,	840,	850,	860,
       870,	880,  890,	900,	910,	920,	930,	940,	950,	960,
       970,	980,	990,	1000,	1010, 1020,	1030, 1040,	1050, 1060,
       1070,1080,	1090, 1100,	1110, 1120,	1130, 1140,	1150, 1160,
       1170,1180,	1190, 1200,	1210, 1220,	1230, 1240,	1250, 1260,
       1270,1280,	1290, 1300,	1310, 1320,	1330, 1340,	1350, 1360,
       1370,1380,	1390,	1400,	1410, 1420,	1430,	1440,	1450],
 [250, 260, 270,	280, 290,	300, 310,	320, 330,	340,	350,	360,
       370,	380,	390,	400,	410,	420,	430,  440,	450,	460,
       470,	480,	490,	500,	510,	520,	530,	540,	550,	560,
       570,	580,	590,	600,	610,	620,	630,	640,	650,	660,
       670,	680,	690,	700,	710,	720,	730,	740,	750,	760,
       770,	780,	790,	800,	810,	820,	830,	840,	850,	860,
       870,	880,  890,	900,	910,	920,	930,	940,	950,	960,
       970,	980,	990,	1000,	1010, 1020,	1030, 1040,	1050, 1060,
       1070,1080,	1090, 1100,	1110, 1120,	1130, 1140,	1150, 1160,
       1170,1180,	1190, 1200,	1210, 1220,	1230, 1240,	1250, 1260,
       1270,1280,	1290, 1300,	1310, 1320,	1330, 1340,	1350, 1360,
       1370,1380,	1390,	1400,	1410, 1420,	1430,	1440,	1450]);
 Alpha_Siabsorb:array [TSiAbsorbTable] of array of double=
 ([1.84E6,  1.97E6, 2.18E6, 2.37E6,  2.29E6,  1.77E6,  1.46E6,  1.3E6,
        	1.18E6, 1.1E6,  1.06E6,  1.04E6,  737000,  313000,  143000,
          93000,  69500,  52700,   40200,   30700,   24100,   19500,
          16600,  14400,  12600,   11100,   9700,    8800,    7850,
          7050,   6390,   5780,    5320,    4880,    4490,    4175,
          3800,   3520,   3280,    3030,    2790,    2570,    2390,
          2200,   2040,   1890,    1780,    1680,    1540,    1420,
          1310,   1190,   1100,    1030,    928,     850,     775,
          707,    647,    590,     534,     479,     431,     383,
         	343,    303,    271,     240,     209,     183,     156,
          134,    113,    96,      79,      64,      51.1,    39.9,
          30.2,   22.6,   16.3,    11.1,    8,       6.2,     4.7,
          3.5,    2.7,    2,       1.5,     1,       0.68,    0.42,
          0.22,   0.065,  0.036,   0.022,   0.013,   0.0082,  0.0047,
          0.0024, 1E-3,   3.6E-4,  2E-4,    1.2E-4,  7.1E-5,  4.5E-5,
          2.7E-5, 1.6E-5, 8E-6,    3.5E-6,  1.7E-6,  9.5E-7,  6E-7,
          3.8E-7, 2.3E-7, 1.4E-7,  8.5E-8,  5E-8,    2.5E-8,  1.8E-8, 1.2E-8],
 [1.804E6,  1.930E6,  2.139e6,  2.332E6,  2.302E6,  1.797E6,  1.469E6,
           1.289E6,  1.178E6,  1.093E6,  1.044E6,  1.017E6,  7.269e5,
           3.254e5,  1.621e5,  1.025e5,  7.395e4,  5.294e4,  4.023e4,
           3.199e4,  2.663e4,  2.161e4,  1.878e4,  1.566e4,  1.380e4,
           1.220e4,  1.080e4,  9.553e3,  8.252e3,  6.957e3,  6.406e3,
           5.958e3,  5.235e3,  4.744e3,  4.276e3,  3.879e3,  3.555e3,
           3.407e3,  3.245e3,  2.885e3,  2.793e3,  2.591e3,  2.402e3,
           2.226e3,  2.061e3,  1.907e3,  1.763e3,  1.629e3,  1.503e3,
           1.386e3,  1.276e3,  1.173e3,  1.078e3,  9.882e2,  9.049e2,
           8.271e2,  7.546e2,  6.871e2,  6.243e2,  5.659e2,  5.116e2,
           4.612e2,  4.145e2,  3.713e2,  3.313e2,  2.945e2,  2.605e2,
           2.293e2,  1.994e2,  1.746e2,  1.507e2,  1.286e2,  1.089e2,
           9.147e1,  7.570e1,  6.160e1,  4.929e1,  3.873e1,  2.934e1,
           2.170e1,  1.561e1,  1.096e1,  7.965,    6.070,    4.585,
           3.452,    2.594,    1.915,    1.377,    0.9503,   0.6215,
           0.3713,   1.896e-1, 5.917e-2, 2.445e-2, 1.456e-2, 8.398e-3,
           4.938e-3, 2.772e-3, 1.451e-3, 5.911e-4, 2.329e-4, 1.258e-4,
           7.391e-5, 4.364e-5, 2.632E-5, 1.521E-5, 8.301E-6, 3.972e-6,
           1.700E-6, 9.707E-7, 5.813E-7, 3.580E-7, 2.401E-7, 1.571E-7,
           9.360E-8, 5.385E-8, 3.796E-8, 1.791E-8, 1.203E-8, 9.447e-9]);
 TemCoef_Siabsorb:array [TSiAbsorbTable] of array of double=
 ([-0.9, -1.5,  -3.1,  -3.3,  0.8,   2.5,  3.2,   1.5,   0.7,  0.3,
       0,     -1.4,  4.2,   9.1,   26,   33,    31,    29,   29,
       28,    28,    29,    29,    30,   30,    31,    31,   32,
       33,    33,    33,    34,    34,   34,    34,    34,   35,
       35,    35,    35,    35,    35,   36,    36,    36,   37,
       37,    37,    37,    37,    37,   37,    37,    37,   38,
       40,    41,    42,    44,    45,   46,    47,    49,   51,
       52,    54,    56,    57,    59,   62,    65,    69,   73,
       78,    83,    90,    97,    105,  112,   120,   135,  145,
       155,   160,   165,   175,   180,  185,   190,   200,  210,
       230,   260,   320,   345,   355,  380,   390,   405,  410,
       430,   440,   455,   470,   500,  525,   550,   580,  610,
       650,   670,   675,   680,   685,  690,   700,   710,  720,
       730,   740,   750],
 [0.45, 0.75,    1.550,    1.650,    0.40,    2.352,   3.261,   1.818,    0.8743,
       0.2794,  0,        0.7,      4.102,   20.54,   38.94,   42.08,    38.43,
       36.12,   34.94,    34.50,    34.05,   34.02,   34.11,    33.36,   33.71,
       34.38,   35.14,    35.23,    34.87,   34.42,   35.61,    35.65,   35.55,
       37.02,   36.74,    35.70,    37.19,   35.81,   36.17,    38.83,   37.11,
       35.13,   38.30,    39.92,    39.02,   39.45,   40.62,    40.35,   40.32,
       41.98,   42.38,    42.62,    42.99,   43.49,   44.61,    46.36,   47.74,
       49.25,   51.38,    53.14,    55.03,   57.05,   59.69,    62.46,   64.86,
       67.89,   71.04,    73.82,    77.23,   81.26,   85.43,    90.22,   95.13,
       100.7,   119.9,    108.4,    112.2,   119.9,   126.7,    136.0,   148.1,
       157.2,   154.5,    154.3,    157.5,   163.0,   167.4,    173.0,   180.6,
       193.4,   208.9,    237.7,    291.9,   411.1,   349.4,    338.2,   352.0,
       361.4,   382.0,    407.7,    468.0,   468.2,   420.4,    441.1,   457.0,
       488.3,   550.0,    580.0,    610,     650,     670,      675,     680,
       685,     690,      700,      710,     720,     730,      740,     750]);

 n_r_Si:array of double=
 {refractive index (real part) for Si
 M.A. Green / Solar Energy Materials & Solar Cells 92 (2008) 1305–1310}
 [1.84E6,  1.97E6, 2.18E6, 2.37E6,  2.29E6,  1.77E6,  1.46E6,  1.3E6,
        	1.18E6, 1.1E6,  1.06E6,  1.04E6,  737000,  313000,  143000,
          93000,  69500,  52700,   40200,   30700,   24100,   19500,
          16600,  14400,  12600,   11100,   9700,    8800,    7850,
          7050,   6390,   5780,    5320,    4880,    4490,    4175,
          3800,   3520,   3280,    3030,    2790,    2570,    2390,
          2200,   2040,   1890,    1780,    1680,    1540,    1420,
          1310,   1190,   1100,    1030,    928,     850,     775,
          707,    647,    590,     534,     479,     431,     383,
         	343,    303,    271,     240,     209,     183,     156,
          134,    113,    96,      79,      64,      51.1,    39.9,
          30.2,   22.6,   16.3,    11.1,    8,       6.2,     4.7,
          3.5,    2.7,    2,       1.5,     1,       0.68,    0.42,
          0.22,   0.065,  0.036,   0.022,   0.013,   0.0082,  0.0047,
          0.0024, 1E-3,   3.6E-4,  2E-4,    1.2E-4,  7.1E-5,  4.5E-5,
          2.7E-5, 1.6E-5, 8E-6,    3.5E-6,  1.7E-6,  9.5E-7,  6E-7,
          3.8E-7, 2.3E-7, 1.4E-7,  8.5E-8,  5E-8,    2.5E-8,  1.8E-8, 1.2E-8];

 TempCoef_n_r_Si:array of double=
 {температурний коефіцієнт of refractive index (real part) for Si
 M.A. Green / Solar Energy Materials & Solar Cells 92 (2008) 1305–1310}
 [1.84E6,  1.97E6, 2.18E6, 2.37E6,  2.29E6,  1.77E6,  1.46E6,  1.3E6,
        	1.18E6, 1.1E6,  1.06E6,  1.04E6,  737000,  313000,  143000,
          93000,  69500,  52700,   40200,   30700,   24100,   19500,
          16600,  14400,  12600,   11100,   9700,    8800,    7850,
          7050,   6390,   5780,    5320,    4880,    4490,    4175,
          3800,   3520,   3280,    3030,    2790,    2570,    2390,
          2200,   2040,   1890,    1780,    1680,    1540,    1420,
          1310,   1190,   1100,    1030,    928,     850,     775,
          707,    647,    590,     534,     479,     431,     383,
         	343,    303,    271,     240,     209,     183,     156,
          134,    113,    96,      79,      64,      51.1,    39.9,
          30.2,   22.6,   16.3,    11.1,    8,       6.2,     4.7,
          3.5,    2.7,    2,       1.5,     1,       0.68,    0.42,
          0.22,   0.065,  0.036,   0.022,   0.013,   0.0082,  0.0047,
          0.0024, 1E-3,   3.6E-4,  2E-4,    1.2E-4,  7.1E-5,  4.5E-5,
          2.7E-5, 1.6E-5, 8E-6,    3.5E-6,  1.7E-6,  9.5E-7,  6E-7,
          3.8E-7, 2.3E-7, 1.4E-7,  8.5E-8,  5E-8,    2.5E-8,  1.8E-8, 1.2E-8];


//мені так і не вдалося задекларувати константні багатомірні
//масиви на кшталт того що нижче, тому зробив на трьох різних
//  SiabsorbParam:array [TSiAbsorbTable] of array of TAbsorbParam=
//  {M.A. Green / Solar Energy Materials & Solar Cells 92 (2008) 1305–1310}
// ((250,	1.84E6, -0.9),   (260, 1.97E6, -1.5),  (270,	2.18E6, -3.1),
// (280,	2.37E6, -3.3),   (290, 2.29E6, 0.8),   (300,  1.77E6,  2.5),
// (310,	1.46E6, 3.2),    (320,	1.3E6, 1.5),   (330,	1.18E6,  0.7),
// (340,	1.1E6,  0.3),    (350,	1.06E6, 0),    (360,	1.04E6, -1.4),
// (370,	737000, 4.2),    (380,	313000, 9.1),  (390,	143000,  26),
// (400,	93000,  33),     (410,	69500,  31),   (420,	52700,   29),
// (430,	40200,  29),     (440,	30700,  28),   (450,	24100,   28),
// (460,	19500,  29),     (470,	16600,  29),   (480,	14400,   30),
// (490,	12600,  30),     (500,	11100,  31),   (510,	9700,    31),
// (520,	8800,   32),     (530,	7850,   33),   (540,	7050,    33),
// (550,	6390,   33),     (560,	5780,   34),   (570,	5320,    34),
// (580,	4880,   34),     (590,	4490,   34),   (600,	4175,    34),
// (610,	3800,   35),     (620,	3520,   35),   (630,	3280,    35),
// (640,	3030,   35),     (650,	2790,   35),   (660,	2570,    35),
// (670,	2390,   36),     (680,	2200,   36),   (690,	2040,    36),
// (700,	1890,   37),     (710,	1780,   37),   (720,	1680,    37),
// (730,	1540,   37),     (740,	1420,   37),   (750,	1310,    37),
// (760,	1190,   37),     (770,	1100,   37),   (780,	1030,    37),
// (790,	928,    38),     (800,	850,    40),   (810,	775,     41),
// (820,	707,    42),     (830,	647,    44),   (840,	590,     45),
// (850,	534,    46),     (860,	479,    47),   (870,	431,     49),
// (880,	383,    51),     (890,	343,    52),   (900,	303,     54),
// (910,	271,   	56),     (920,	240,    57),   (930,	209,     59),
// (940,	183,    62),     (950,	156,    65),   (960,	134,     69),
// (970,	113,    73),     (980,	96,     78),   (990,	79,      83),
// (1000,	64,     90),     (1010, 51.1,   97),   (1020,	39.9,    105),
// (1030, 30.2,   112),    (1040,	22.6,   120),  (1050, 16.3,    135),
// (1060,	11.1,   145),    (1070, 8,      155),  (1080,	6.2,     160),
// (1090, 4.7,    165),    (1100,	3.5,    175),  (1110, 2.7,     180),
// (1120,	2,      185),    (1130, 1.5,    190),  (1140,	1,       200),
// (1150, 0.68,    210),   (1160,	0.42,   230),  (1170, 0.22,    260),
// (1180,	0.065,  320),    (1190, 0.036,  345),  (1200,	0.022,   355),
// (1210, 0.013,  380),    (1220,	0.0082, 390),  (1230, 0.0047,  405),
// (1240,	0.0024, 410),    (1250, 1E-3,   430),  (1260,	3.6E-4,  440),
// (1270, 2E-4,   455),    (1280,	1.2E-4, 470),  (1290, 7.1E-5,  500),
// (1300,	4.5E-5, 525),    (1310, 2.7E-5, 550),  (1320,	1.6E-5,  580),
// (1330, 8E-6,   610),    (1340,	3.5E-6, 650),  (1350, 1.7E-6,  670),
// (1360,	9.5E-7, 675),    (1370, 6E-7,   680),  (1380,	3.8E-7,  685),
// (1390,	2.3E-7, 690),    (1400,	1.4E-7, 700),  (1410, 8.5E-8,  710),
// (1420,	5E-8,   720),    (1430,	2.5E-8, 730),  (1440,	1.8E-8,  740),
// (1450,	1.2E-8, 750)),
//  {Schinke at el / AIP ADVANCES 5, 067168 (2015)}
// ((250,	1.804E6,  0.45),   (260,  1.930E6,  0.75),  (270,  2.139e6,  1.550),
// (280,	2.332E6,  1.650),  (290,	2.302E6,  0.40),  (300, 1.797E6,   2.352),
// (310,	1.469E6,  3.261),  (320,	1.289E6,  1.818), (330,	1.178E6,   0.8743),
// (340,	1.093E6,  0.2794), (350,	1.044E6,  0),     (360,	1.017E6,   0.7),
// (370,	7.269e5,  4.102),  (380,	3.254e5,  20.54), (390,	1.621e5,   38.94),
// (400,	1.025e5,  42.08),  (410,	7.395e4,  38.43), (420,	5.294e4,   36.12),
// (430,	4.023e4,  34.94),  (440,	3.199e4,  34.50), (450,	2.663e4,   34.05),
// (460,	2.161e4,  34.02),  (470,	1.878e4,  34.11), (480,	1.566e4,   33.36),
// (490,	1.380e4,  33.71),  (500,	1.220e4,  34.38), (510,	1.080e4,   35.14),
// (520,	9.553e3,  35.23),  (530,	8.252e3,  34.87), (540,	6.957e3,   34.42),
// (550,	6.406e3,  35.61),  (560,	5.958e3,  35.65), (570,	5.235e3,   35.55),
// (580,	4.744e3,  37.02),  (590,	4.276e3,  36.74), (600,	3.879e3,   35.70),
// (610,	3.555e3,  37.19),  (620,	3.407e3,  35.81), (630,	3.245e3,   36.17),
// (640,	2.885e3,  38.83),  (650,	2.793e3,  37.11), (660,	2.591e3,   35.13),
// (670,	2.402e3,  38.30),  (680,	2.226e3,  39.92), (690,	2.061e3,   39.02),
// (700,	1.907e3,  39.45),  (710,	1.763e3,  40.62), (720,	1.629e3,   40.35),
// (730,	1.503e3,  40.32),  (740,	1.386e3,  41.98), (750,	1.276e3,   42.38),
// (760,	1.173e3,  42.62),  (770,	1.078e3,  42.99), (780,	9.882e2,   43.49),
// (790,	9.049e2,  44.61),  (800,	8.271e2,  46.36), (810,	7.546e2,   47.74),
// (820,	6.871e2,  49.25),  (830,	6.243e2,  51.38), (840,	5.659e2,   53.14),
// (850,	5.116e2,  55.03),  (860,	4.612e2,  57.05), (870,	4.145e2,   59.69),
// (880,	3.713e2,  62.46),  (890,	3.313e2,  64.86), (900,	2.945e2,   67.89),
// (910,	2.605e2,  71.04),  (920,	2.293e2,  73.82), (930,	1.994e2,   77.23),
// (940,	1.746e2,  81.26),  (950,	1.507e2,  85.43), (960,	1.286e2,   90.22),
// (970,	1.089e2,  95.13),  (980,	9.147e1,  100.7), (990,	7.570e1,   119.9),
// (1000, 6.160e1,  108.4),  (1010, 4.929e1,  112.2), (1020, 3.873e1,  119.9),
// (1030, 2.934e1,  126.7),  (1040, 2.170e1,  136.0), (1050, 1.561e1,  148.1),
// (1060, 1.096e1,  157.2),  (1070, 7.965,    154.5), (1080, 6.070,    154.3),
// (1090, 4.585,    157.5),  (1100, 3.452,    163.0), (1110, 2.594,    167.4),
// (1120, 1.915,    173.0),  (1130, 1.377,    180.6), (1140, 0.9503,   193.4),
// (1150, 0.6215,   208.9),  (1160, 0.3713,   237.7), (1170, 1.896e-1, 291.9),
// (1180, 5.917e-2, 411.1),  (1190, 2.445e-2, 349.4), (1200, 1.456e-2, 338.2),
// (1210, 8.398e-3, 352.0),  (1220, 4.938e-3, 361.4), (1230, 2.772e-3, 382.0),
// (1240, 1.451e-3, 407.7),  (1250, 5.911e-4, 468.0), (1260, 2.329e-4, 468.2),
// (1270, 1.258e-4, 420.4),  (1280, 7.391e-5, 441.1), (1290, 4.364e-5, 457.0),
// (1300, 2.632E-5, 488.3),  (1310, 1.521E-5, 550.0), (1320, 8.301E-6, 580.0),
// (1330, 3.972e-6, 610),    (1340, 1.700E-6, 650),   (1350, 9.707E-7, 670),
// (1360, 5.813E-7, 675),    (1370, 3.580E-7, 680),   (1380, 2.401E-7, 685),
// (1390,	1.571E-7, 690),    (1400, 9.360E-8, 700),   (1410, 5.385E-8, 710),
// (1420, 3.796E-8, 720),    (1430,	1.791E-8, 730),   (1440, 1.203E-8, 740),
// (1450, 9.447e-9, 750));


type

    TMaterial=class
     private
      FParameters:TMaterialParameters;
      fMaterialName:TMaterialName;
     procedure SetAbsValue(Index:integer; value:double);
     procedure SetEpsValue (value:double);

     public
     Constructor Create(MaterialName:TMaterialName);
     procedure ChangeMaterial(value:TMaterialName);
     property MaterialName:TMaterialName read fMaterialName;
     property Name:string read FParameters.Name;
     property Eg0:double Index 1 read FParameters.Parameters[nEg0] write SetAbsValue;
     property Eps:double read FParameters.Parameters[nEps] write SetEpsValue;
     property ARich_n:double Index 2 read FParameters.Parameters[nARich_n] write SetAbsValue;
     property ARich_p:double Index 6 read FParameters.Parameters[nARich_p] write SetAbsValue;
     property Me:double Index 3 read FParameters.Parameters[nMe] write SetAbsValue;
     property Mh:double Index 7 read FParameters.Parameters[nMh] write SetAbsValue;
     property VarshA:double Index 4 read FParameters.Parameters[nVarshA] write SetAbsValue;
     property VarshB:double Index 5 read FParameters.Parameters[nVarshB] write SetAbsValue;

     procedure ReadFromIniFile(ConfigFile:TIniFile);
     procedure WriteToIniFile(ConfigFile:TIniFile);

     function Varshni(F0,T:double):double;
     function EgT(T:double):double;
      // ширина забороненої зони при температурі Т
     function Nc(T:double):double;
     function Nv(T:double):double;
//    ефективна густина станів в зоні провідності та валентній
     function n_i(T:double):double;
     function Ei(T:double):double;
     {положення рівня Фермі у власному}
     function Vth_n(T:double):double;
     function Vth_p(T:double):double;
     {теплова швидкість електронів та дірок}
     class function VarshniFull(F0,T:double;
                                Alpha:double=VarshA_Si;
                                Betta:double=VarshB_Si):double;
     class function CaugheyThomas(mu_min,mu_0,Nref,Ndoping,Alpha:double):double;
     class function FermiDiracDonor(const Ed:double;
                                    const Ef:double;
                                    const T:double=300):double;
     {значення функції Фермі-Дірака для донорного рівня
     Ed та Ef відраховуються від дна зони провідності}
     class function FDIntegral_05(const eta:double):double;
     {значення інтегралу Фермі-Дірака ступеня 1/2,
     апроксимація згідно з Phys.Lett., vol.64A, p409}
     end; // TMaterial=class

//     TMatParNameLab=array[TMaterialParametersName]of TLabel;

     TMaterialShow=class
       private
         LShowData:array[TMaterialParametersName]of TLabel;
         CBSelect:TComboBox;
         Prefix:string;//префікс, щоб відрізняти записи в ini-файлі
         ConfigFile:TIniFile;
         procedure CBSelectChange(Sender: TObject);
         procedure LInputDataClick (Sender: TObject);
         procedure ShowData();
       public
        Material:TMaterial;
        Constructor Create(LSD:array of TLabel;
                           CBSel:TComboBox;
                           Pr:string;
                           CF:TIniFile
                           );
        Procedure Free;
     end;   //TMaterialShow=class

    Silicon=class
      private
       class function CCDod(Concentration:double;Parameters:array of double):double;
       {допоміжна функція, використовується в CarrierConcentration,
       Parameters[0] - Resistivity
       Parameters[1] - T,
       Parameters[2] > 0 p-тип
                     <=0 n-тип}
       class function Rajkanan(Ephoton:double;T:double=300):double;
       {розраховується коефіцієнт поглинання за складною
       формулою, []=1/m}
       class function AbsorbFromTable(Lambda: Double;
               SiAbsorbTable: TSiAbsorbTable=abGreen; T: Double = 300):double;
       {визначається коефіцієнт поглинання
       з таблиць, наведених в роботах,
       [Result]=1/м
       [Lambda]=нм}
       class function g_e (gmax,p,n,N0,Tetta:double):double;
       {допоміжна функція при обчисленні коеф. Оже рекомбінації,
       розрахунок коеф. підсилення внаслідок
       кулонівської взаємодії, використовується
       в SolEnerMatSC_234_111428 (2022)}
       class function g_e2 (gmax,p,n,N0,Tetta:double):double;
       {ще один варіант цієї функції, використовується
       в SolEnerMatSC_235_111467 (2022)}
       class function gmax_n(g0:double;T:double=300):double;
       {описує температурну залежність gmax (див. попередні)
       для випадку Сn
       відповідно до J.Appl.Phys, 82, p.4938 (1997)}
       class function gmax_p(g0:double;T:double=300):double;
       {описує температурну залежність gmax (див. попередні)
       для випадку Сp
       відповідно до J.Appl.Phys, 82, p.4938 (1997)}
       class function Cp0_vs_T(ScaleFactor:double;T:double=300):double;
       {описує температурну залежність Cp0 для коеф.
       Оже рекомбінації відповідно до J.Appl.Phys, 82, p.4938 (1997);
       якщо рахувати за даними цієї роботи ScaleFactor=1,
       для інших (де нема своєї температурної залежності)
       ScaleFactor визначаємо індивідуально)
       []- м6/с}
      public
      class function Eg(T:double=300):double;
      class function Meff_e(T:double=300):double;
      class function Meff_h(T:double=300):double;
      class function A(A0,T,n:double):double;
      {функція A=A0*(T/300)^n}
//      class function mu_n(T: Double=300; Ndoping: Double=1e21):double;
//      class function mu_p(T: Double=300; Ndoping: Double=1e21):double;
      {рухливості електронів та дірок за формулами з книги
      Schroder, p.503,
      Ndoping - концентрація легуючої домішки,
      []=м^-3
      [Result]=м^2/(В с}
      class function mu_n(T: Double=300; Ndoping: Double=1e21;itIsMajority:Boolean=True):double;
      class function mu_p(T: Double=300; Ndoping: Double=1e21;itIsMajority:Boolean=True):double;
      {рухливості електронів та дірок за теорією KLAASSEN
      (Solid-State  Electronics, 35, pp.953-95(1992),
      викоритовувались ще формули з книги
      "Properties of Crystalline Silicon"
      Ndoping - концентрація легуючої домішки,
      []=м^-3
      [Result]=м^2/(В с}
      class function D_n(T: Double=300; Ndoping: Double=1e21):double;
      class function D_p(T: Double=300; Ndoping: Double=1e21):double;
      {коефіцієнт дифузії, []= м^2/с}
      class function Absorption(Lambda:double;T:double=300):double;
      {коефіцієнт поглинання світла,
      [Lambda]=нм, [Result]=1/м}
      class function AbsorptionFC_complex(Lambda:double;n,p:double;T:double=300):double;
      {коефіцієнт поглинання світла вільними носіями,
      [Lambda]=нм,
      [n,p]=1/м^3, концентрації носіїв
      [Result]=1/м,
      за роботою IEEE_JPV 11 p73,
      фактично в цій роботі запропоновано враховувати поглинання
      і основними, і неосновними носіями,
      використані формули з роботи JApplPhys_116_063106 (2014)
      (хоча там запропоновано окремі вирази для n та p
      напівпровідника зі словами, що формули справедливі для
      концентрацій 10^18-5*10^20 см^-3),
      крім того використано результати роботи
      JPhysCSolStPhys_12_p3837 (1979), де показано,
      що коеф. поглинання вільними носіями має бути лінійним по
      температурі; в більш пізніх роботах я залежності від температури
      не зустрічав... тому можливо краще використовувати більш прості
      варіанти як у функції AbsorptionFC}
      class function AbsorptionFC(Lambda:double;N:double;itIsDonor:boolean=True):double;
      {коефіцієнт поглинання світла вільними носіями,
      [Lambda]=нм,
      [N]=1/м^3, концентрації носіїв,
      поява itIsDonor викликана тим, що для n та p напівпровідників
      формули трохи різні
      [Result]=1/м,
      за роботою JApplPhys_116_063106 (2014)
      також всередині передбачено використання варіанту
      згідно з роботою
      IEEETransElecDev_60_p2156 (2013)}
      class function Nc(T:double=300):double;
      class function Nv(T:double=300):double;
      //    ефективні густини станів
      class function n_i(T:double=300):double;
      class function Ei(T:double=300):double;
     {положення рівня Фермі у власному}
      class function Vth_n(T:double=300):double;
      class function Vth_p(T:double=300):double;
     {теплова швидкість електронів та дірок}
      class function MinorityN(majority:double;T:double=300):double;
      {концентрація неосновних носіїв }
      class function Fpr(w:double;IsTextured:boolean=True;del_n:double=0):double;
      {fraction of radiatively emitted photons
      reabsorbed via band-to-band processes,
      використовується при розрахунку Brad,
      обчислення відповідно до SolEnerMatSC_235_111467 (2022)
      []=1
      w - товщина зразка, [w]=m
      IsTextured бо вирази різні для planar surfaces та surface texture
      del_n - нерівноважні носії, [del_n]=m^-3}
      class function Brel(Ndoping: Double=1e21; itIsDonor:Boolean=True;
                     T:double=300):double;
      {розрахунок поправочного коеф. для Brad
      []=1
      [Ndoping]=1/m^3
       Sol. Energy Mater. Sol. Cell. 230 (2021) 111198}
      class function Brel_2(n,p: Double; T:double=300):double;
      {ще один варіант розрахуноку поправочного коеф. для Brad
      n,p -концентрації носіїв з врахуванням нерівноважних
      []=1
      [n,p]=1/m^3
      P. P. Altermatt et al., “Injection dependence of spontaneous
      radiative recombination in c-Si: Experiment, theoretical analysis,
      and simulation,” in Proc. 5th Int. Conf. Numer. Simul.
      Optoelectron. Devices, Berlin, Germany, 2005, pp. 47–48,
      doi: 10.1109/NUSOD.2005.1518128
      кажуть про справедливість формули
      для Т=77-400 К та injection range 10^11-10^19 см^-3}
      class function Brad_low(T:double=300):double;
      {допоміжна функція для обчислення Brad
      Sol. Energy Mater. Sol. Cell. 230 (2021) 111198}
//      class function Brad(T:double=300):double;
      class function Brad(T:double=300;Ndoping: Double=1e21; itIsDonor:Boolean=True;
                          w:double=3e-4;IsTextured:boolean=True;del_n:double=0):double;
      {коефіцієнт міжзонної випромінювальної рекомбінації,
      []=м3/с;
      параметри див. у попередніх трьох функціях}
      class function Cn_Auger(n:double;T:double=300):double;
      {коефіцієнт Оже-рекомбінації електронів,
      []=м6/с
      n - рівноважна концентрація електронів, []=1/m^3;
      раніше це був розрахунок відповідно до
      J. Appl. Phys. 82, p.4938 (1997),
      зараз модифікований варіант Cn_AugerNew для
      випадку, коли надлишкових носіїв
      значно менше ніж основних}
      class function Cp_Auger(p:double;T:double=300):double;
      {коефіцієнт Оже-рекомбінації дірок,
      []=м6/с
      p - рівноважна концентрація дірок, []=1/m^3;
      див. попередню}
      class function Cp_AugerNew(n,p:double;T:double=300):double;
      class function Cn_AugerNew(n,p:double;T:double=300):double;
      {коефіцієнти Оже-рекомбінації,
      []=м^6/с
      n - концентрація електронів, []=1/m^3
      p - концентрація дірок, []=1/m^3;
      використовуються дані з нових робіт, але там
      нічого немає про температурну залежність -
      пишуть про 300 К, або взагалі не згадують;
      тому в цих функціях передбачено гібрид:
      температурну залежність беремо з J.Appl.Phys, 82, p.4938 (1997)}
      class function BGN(Ndoping: Double=1e21; itIsDonor:Boolean=True):double;
      {звуження забороненої зони,
      []=eV,
      [Ndoping]=1/m^3}
      class function CarrierConcentration(Resistivity:double;
                                          ItIsHoleMaterial:boolean=true;
                                          T:double=300):double;
      {концентрація носіїв за величиною питомого опору
      []=m^-3,
      [Resistivity]=Ohm cm}
      class function TAUbtb(Ndop,delN:double;T:double=300):double;
     {час життя, пов'язаний з міжзонною рекомбінацією
      Ndop - рівень легування; delN - нерівноважні носії
      [Ndop,delN]=1/m^3
      []=c
      J. Appl. Phys. 110, 053713}
      class function TAUceager(Na,delN:double;T:double=300):double;
      {час життя, пов'язаний з Coulomb-enhanced Auger recombination
       для р-напівпровідника
       Na - рівень легування; delN - нерівноважні носії
      [Nа,delN]=1/m^3
      []=c
      J. Appl. Phys. 110, 053713}
      class function TAUager_n(n:double;T:double=300):double;
      {час життя, пов'язаний з Оже рекомбінацією в n-матеріалі
      при низькому рівні інжекції
      [n]=m^-3
      []=c}
      class function TAUager_p(p:double;T:double=300):double;
      {час життя, пов'язаний з Оже рекомбінацією в p-матеріалі
      при низькому рівні інжекції
      [p]=m^-3
      []=c}
    end;

    TMaterialLayer=class
      private
       fIsNType:boolean;//тип провідності
       FNd:double; //концентрація носіїв []=m^(-3)
       FMaterial:TMaterial;
       procedure SetNd(value:double);
       procedure SetMaterial(value:TMaterial);
       function  GetARich: Double;
       function  GetMeff: Double;
      public
      property IsNType:boolean read fIsNType write fIsNType;
      property Nd:double read FNd write SetNd;
      property Material:TMaterial read FMaterial write SetMaterial;
      property ARich:Double read GetARich;
      property Meff:Double read GetMeff;
      function F(T:double=300):double;
      {положення рівня Фермі відносно вершини валентної;
      вважається, що напівпровідник невироджений}
    end; // TMaterialLayer=class



    TMaterialLayerShow=class
     private
      procedure NdRead();
      procedure CBNTypeClick(Sender: TObject);
     public
      NdShow:TParameterShow;
      CBNType:TCheckBox;
      MaterialLayer:TMaterialLayer;
      Constructor Create(ML:TMaterialLayer;
                         CBNT:TCheckBox;
                         STData: TStaticText;
                         STCaption:TLabel
          );
      procedure Free;

    end;//TMaterialLayerShow=class

    TDiodMaterial=class
     private
      FArea  :double; //площа []=m^2
      procedure SetArea(value:double);
     public
     property Area:double read FArea write SetArea;
     procedure ReadFromIniFile(ConfigFile:TIniFile);virtual;abstract;
     procedure WriteToIniFile(ConfigFile:TIniFile);virtual;abstract;
    end;//  TDiod=class

    TDiod_Schottky=class(TDiodMaterial)
     private
      FEps_i:double; //діелектрична проникність діелектрика
      FThick_i :double; //товщина діелектричного шару []=m
      FSemiconductor:TMaterialLayer;
     procedure SetThick(value:double);
     procedure SetEps (value:double);
     procedure SetMaterialLayer(value:TMaterialLayer);
     function Get_nu():double;

     public
     Constructor Create;
     destructor Destroy;override;
     property Eps_i:double read FEps_i write SetEps;
     property Thick_i:double read FThick_i write SetThick;
     property Semiconductor:TMaterialLayer read FSemiconductor write SetMaterialLayer;
     property nu:double read Get_nu;

     procedure ReadFromIniFile(ConfigFile:TIniFile); override;
     procedure WriteToIniFile(ConfigFile:TIniFile);override;

     function kTln(T:double):double;
     {повертає значення kT ln(Area*ARich*T^2)}
     function I0(T,Fb:double):double;
     {повертає струм насичення
     I0=Area*Arich*T^*exp(-Fb/Kb/T)}
     function Fb(T,I0:double):double;
     {повертає висоту бар'єру
     Fb=kT*ln(Area*ARich*T^2/I0)}
     function Vbi(T:double):double;
     {об'ємний потенціал (build in)}
     function Em(T,Fb0:double;Vrev:double=0;C1:double=0):double;
     {максимальне значення електричного поля}
     end; // TDiod=class

     TDiod_SchottkyShow=class
       private
        SemiconductorShow:TMaterialLayerShow;
        AreaShow,Eps_iShow,Thick_iShow:TParameterShow;
        procedure AreaRead();
        procedure EpsRead();
        procedure ThickRead();
       public
        Diod_Schottky:TDiod_Schottky;
        Constructor Create(DSc:TDiod_Schottky;
                         CBNT:TCheckBox;
                         STDataNd,STDataArea,STDataEps,STDataThick: TStaticText;
                         STCaptionNd,STCaptionArea,STCaptionEps,STCaptionThick:TLabel
          );
        procedure Free;
     end;

     TDiod_PN=class(TDiodMaterial)
      private
       FLayerN:TMaterialLayer;
       FLayerP:TMaterialLayer;
       function GetNd():double;
      public
       Constructor Create;
       procedure Free;
       property LayerN:TMaterialLayer read FLayerN write FLayerN;
       property LayerP:TMaterialLayer read FLayerP write FLayerP;
       property Nd:double read GetNd;
       {рівень легування для шару з більшим опором}
       procedure ReadFromIniFile(ConfigFile:TIniFile); override;
       procedure WriteToIniFile(ConfigFile:TIniFile);override;
       function Vdif(T:double;V:double=0):double;
       {дифузійний потенціал, пряма напруга V додатня, зворотня від'ємна, []=B}
       function W(T:double;V:double=0):double;
       {ширина ОПЗ, пряма напруга V додатня, зворотня від'ємна, []=м}
       function Wp(T:double;V:double=0):double;
       {ширина ОПЗ в р-області, пряма напруга V додатня, зворотня від'ємна, []=м}
       function Wn(T:double;V:double=0):double;
       {ширина ОПЗ в n-області, пряма напруга V додатня, зворотня від'ємна, []=м}
       function Rnp(T,V,I:double):double;
       {приведена швидкість рекомбінації, []=c^-1
       I - струм через діод}
       function n_i(T:double=300):double;
       {концентрація власних носіїв
       у шарі з більшим опором}
       function mu(T:double=300):double;
       {рухливість неосновних носіїв
       у шарі з більшим опором;
       правда використовується рухливість
       у кремнії}
       function TauRec(Igen, T: Double):double;
       {час рекомбінації по величині дифузійного струму;
       вважається що рекомбінація відбувається в області
       з меншою провідністю;}
       function Igen(TauRec, T: Double):double;
       {функція, зворотня до попередньої}
       function TauToLdif(tau,T:double):double;
       {довжина дифузії для неосновних
       носіїв в області з меншою провідністю
       tau - час життя цих носіїв}
       function LdifToTauRec(L,T:double):double;
       {зворотня функція}
       function TauGen(Iscr, T: Double):double;
       {час рекомбінації в ОПЗ по рекомбінаційного струму}
       function Iscr(TauGen, T, Voltage: Double):double;
       {функція, зворотня до попередньої}
       function fi(x,T:double;V:double=0):double;
       {значення потенціалу в ОПЗ,
       якщо х<0 - то це точка в n-області,
       перевірки на те що х має знаходитися
       в інтервалі [-Wn, Wp] нема;
       вважається що 0 відповідає
       точці x=-Wn}
       function n_SCR(x,T:double;V:double=0):double;
       function p_SCR(x,T:double;V:double=0):double;
       {повертає значення концентрації електронів (дірок)
       в точці ОПЗ з координатою х
       якщо х<0 - то це точка в n-області,
       перевірки на те що х має знаходитися
       в інтервалі [-Wn, Wp] нема}
       function R_Shockley(x,T:double;V:double=0):double;
       {темп рекомбінації згідно механізма Шоклі-Ріда
       в в точці ОПЗ з координатою х}
       function R_DAP(x,T:double;V:double=0):double;
       {темп рекомбінації згідно з механізмом
       міждефектної рекомбінації
        JApplPhys_78_3185.pdf}
       function I_Shockley(T,V:double):double;
       {струм в ОПЗ, розрахований по темпу рекомбінації}
       function Iscr_rec(T,V,tau_n,Kpn,Et:double):double;overload;
       {рекомбінаційний струм в ОПЗ, розрахований
       за теорією Шоклі в загальному вигляді
       формули з Proc23IEEE_PVSC_1993_p321-326.pdf
       tau_n - рекомбінаційний параметр для електронів
               (=1/(sigma_n*Vth*Nt))
       Kpn=tau_p/tau_n;
       Et - положення рівня відносно Ev
       }
       function Iscr_rec(T,V:double):double;overload;
       function delN(V:double;I:double=0;R:double=0;T:double=300):double;
       {концентрація нерівноважних (надлишкових) носіїв,
       справедлива при однорідній генерації у зразку
       V - напруга, I - струм, R - опір,
       формула від Костильова
       []=1/m3
       }
    end; // TDiod_PN=class(TDiodMaterial)

    TDiod_PNShow=class
       private
        LayerNShow:TMaterialLayerShow;
        LayerPShow:TMaterialLayerShow;
        AreaShow:TParameterShow;
        procedure AreaRead();
       public
        Diod_PN:TDiod_PN;
        Constructor Create(Dpn:TDiod_PN;
                         CBNTn,CBNTp:TCheckBox;
                         STDataNdN,STDataNdP,STDataArea: TStaticText;
                         STCaptionNdN,STCaptionNdP,STCaptionArea:TLabel
          );
        procedure Free;
    end;



var
  Diod:TDiod_Schottky;
  DiodPN:TDiod_PN;

Procedure AllSCR(DiodPN:TDiod_PN;
                 Vec:TVector;
                 Func:TFunTriple;
                 T:double=300;V:double=0;
                 FileName:string='';
                 Npoint:integer=100);overload;
{в Vec розміщується щось, що розраховується
в кожній точці ОПЗ діода DiodPN;
Npoint - кількість відрізків, на які ділиться
ОПЗ в n-області та ОПЗ в р-області,
Vec^.Y[i]=Func(Vec^.X[i],T,V)
Якщо FileName<>'', то отримана залежність
записується у файл
}

Procedure AllSCR(DiodPN:TDiod_PN;
                 Func:TFunTriple;
                 T:double=300;V:double=0;
                 FileName:string='';
                 Npoint:integer=100);overload;
{фактично, цей варіант лише для запису
у файл }


Function ElectronConcentrationSimple(const T:double;
                                     const Parameters:array of double;
                                     const Nd:byte;
                                     const Nt:byte;
                                     const Ef:double;
                                     Material:TMaterial):double;


Function ElectronConcentration(const T:double;
                               const Parameters:array of double;
                               const Nd:byte;
                               const Nt:byte;
                               const Ef0:double=0):double;
{розрахунок концентрації електронів для випадку наявності
декількох донорів та пасток
Parameters[0] - сталий від'ємний доданок до кількості носіїв
(фізично - концентрація акцепторів)
Parameters[1], Parameters[3]... Parameters[2Nd-1] - концентрації донорів і-го типу
Parameters[2], Parameters[4]... Parameters[2Nd] - енергетичні положення
рівнів донорів і-го типу (додатна величина, відраховується від дна зони провідності)
Parameters[2Nd+1], Parameters[2Nd+3]...Parameters[2Nd+2Nt-1] - концентрації
пасток і-го типу
Parameters[2Nd+2], Parameters[2Nd+4]...Parameters[2Nd+2Nt] - енергетичні положення
рівня пасток і-го типу (додатна величина, відраховується від дна зони провідності)
якщо Ef0=0, то положення рівня Фермі розраховується, виходячи
з даних в Parameters (самоузгоджено),
якщо ні - використовується дане в пераметрах функції
}


Function FermiLevelEquation(Ef:double;
                            Parameters:array of double):double;
{рівняння для визначення рівня Фермі в електронному напівпровіднику,
цю функцію треба підставити в Bisection для
безпосереднього визначення Ef;
вміст Parameters  - див. попередню функцію,
проте в Parameters[High(Parameters)-2] (тобто в Parameters[2Nd+2Nt+1]) має бути
кількість донорів Nd;
в Parameters[High(Parameters)-1] (тобто в Parameters[2Nd+2Nt+2]) -
кількість пасток Nt;
в Parameters[High(Parameters)] (тобто в Parameters[2Nd+2Nt+3]) - температура}

Function FermiLevelEquationSimple(Ef:double;
                            Parameters:array of double):double;
{рівняння для визначення рівня Фермі в електронному напівпровіднику
по значенням концентрації та температури;
цю функцію треба підставити в Bisection для
безпосереднього визначення Ef;
вміст Parameters[0] - концентрація носіїв;
Parameters[1] - температура}

Function FermiLevelDeterminationSimple(const n:double;const T:double):double;
{обчислюється значення рівня Фермі в електронному напівпровіднику
по значенням концентрації та температури}

Function Pklaas(T:double=300;Ndoping: Double=1e21;
          itIsMajority:Boolean=True; itIsElectron: Boolean=True):double;
{параметр Р з теорії KLAASSEN
(Solid-State  Electronics, 35, pp.953-95(1992),)
m - відношення ефективної маси носія до маси спокою,
за замовчуванням - для електрона в Si,
Ndoping - рівень легування, []=cm-3}

Function Gklaas(P:double;T: Double=300; itIsElectron: Boolean=True):double;
{функція G з теорії KLAASSEN
(Solid-State  Electronics, 35, pp.953-95(1992),)}

Function Fklaas(P:double;T: Double=300; itIsElectron: Boolean=True):double;
{функція F з теорії KLAASSEN
(Solid-State  Electronics, 35, pp.953-95(1992),)
m1 - відношення ефективної маси носія,
   який розсіюється, до маси спокою,
за замовчуванням - для електрона в Si,
m1 - відношення ефективної маси іншого носія до маси спокою,
за замовчуванням - для дірки в Si,
}


implementation

uses
  Controls, Graphics, Math, OlegVectorManipulation;

procedure TMaterial.SetAbsValue(Index:integer; value: Double);
begin
case Index of
 1: FParameters.Parameters[nEg0]:=abs(value);
 2: FParameters.Parameters[nARich_n]:=abs(value);
 6: FParameters.Parameters[nARich_p]:=abs(value);
 3: FParameters.Parameters[nMe]:=abs(value);
 7: FParameters.Parameters[nMh]:=abs(value);
 4: FParameters.Parameters[nVarshA]:=abs(value);
 5: FParameters.Parameters[nVarshB]:=abs(value);
 end;
end;

procedure TMaterial.SetEpsValue(value: Double);
begin
 if value>1 then FParameters.Parameters[nEps]:=value
            else FParameters.Parameters[nEps]:=1;
end;

function TMaterial.Varshni(F0,T:double):double;
begin
  Result:=VarshniFull(F0,T,VarshA,VarshB);
end;

class function TMaterial.VarshniFull(F0,T:double;
                                Alpha:double=VarshA_Si;
                                Betta:double=VarshB_Si):double;
begin
 Result:=F0-sqr(T)*Betta/(T+Alpha);
end;

function TMaterial.Vth_n(T: double): double;
begin
 if Name='Si' then
      begin
       Result:=Silicon.Vth_n(T);
       Exit;
      end;
 if Me=ErResult then Result:=ErResult
                else Result:=sqrt(3*Qelem*Kb*T/m0/Me)
end;

function TMaterial.Vth_p(T: double): double;
begin
 if Name='Si' then
      begin
       Result:=Silicon.Vth_p(T);
       Exit;
      end;
 if Mh=ErResult then Result:=ErResult
                else Result:=sqrt(3*Qelem*Kb*T/m0/Mh)
end;

Constructor TMaterial.Create(MaterialName:TMaterialName);
begin
  inherited Create;
  ChangeMaterial(MaterialName);
end;

class function TMaterial.CaugheyThomas(mu_min, mu_0, Nref, Ndoping,
  Alpha:double): double;
begin
 Result:=mu_min+mu_0/(1+Power(Ndoping/Nref,Alpha));
end;

procedure TMaterial.ChangeMaterial(value:TMaterialName);
begin
 fMaterialName:=value;
 FParameters:=Materials[value];
end;


function TMaterial.EgT(T: Double):Double;
begin
 if Eg0=ErResult then Result:=ErResult
                 else Result:=Varshni(Eg0,T);
end;

function TMaterial.Ei(T: double): double;
begin
 if Name='Si' then
      begin
       Result:=Silicon.Ei(T);
       Exit;
      end;
 if (Eg0=ErResult)or
    (Me=ErResult)or
    (Mh=ErResult)   then Result:=ErResult
                    else
                    Result:=0.5*(EgT(T)+Kb*T*ln(Nv(T)/Nc(T)));
end;

class function TMaterial.FDIntegral_05(const eta: double): double;
 var a:double;
begin
 a:=Power(eta,4)+50+33.6*eta*(1-0.68*exp(-0.17*sqr(eta+1)));
 Result:=1/(0.75*sqrt(Pi)*Power(a,-3.0/8.0)+exp(-eta));
end;

class function TMaterial.FermiDiracDonor(const Ed, Ef, T: double): double;
begin
 if T=0 then  Result:=ErResult
        else  Result:=1/(1+0.5{2}*exp((Ef-Ed)/T/Kb));
end;

function TMaterial.Nc(T:double):double;
//    ефективна густина станів
begin
 if Name='Si' then
      begin
       Result:=Silicon.Nc(T);
       Exit;
      end;
 if Me=ErResult then Result:=ErResult
                else Result:=2.5e25*Me*(T/300.0)*sqrt(Me*T/300.0);
end;

function TMaterial.Nv(T: double): double;
begin
 if Name='Si' then
      begin
       Result:=Silicon.Nv(T);
       Exit;
      end;
 if Mh=ErResult then Result:=ErResult
                else Result:=2.5e25*Mh*(T/300.0)*sqrt(Mh*T/300.0);
end;

function TMaterial.n_i(T: double): double;
begin
 if Name='Si' then
      begin
       Result:=Silicon.n_i(T);
       Exit;
      end;
 Result:=ErResult;
 if Eg0=ErResult then Exit;
 if (Mh=ErResult)or(Me=ErResult) then Exit;
 Result:=sqrt(Nc(T)*Nv(T)*exp(-EgT(T)/T/Kb));
end;

procedure TMaterial.ReadFromIniFile(ConfigFile:TIniFile);
var i:TMaterialParametersName;
begin
  for I := Low(TMaterialParametersName) to High(TMaterialParametersName) do
    FParameters.Parameters[i]:=
        ConfigFile.ReadFloat(Name,
                             GetEnumName(TypeInfo(TMaterialParametersName),ord(i)),
                             Materials[High(TMaterialName)].Parameters[i]);
end;

procedure TMaterial.WriteToIniFile(ConfigFile:TIniFile);
var i:TMaterialParametersName;
begin
  ConfigFile.EraseSection(Name);
  for I := Low(TMaterialParametersName) to High(TMaterialParametersName) do
   if FParameters.Parameters[i]<> Materials[High(TMaterialName)].Parameters[i]
     then ConfigFile.WriteFloat(Name,
                          GetEnumName(TypeInfo(TMaterialParametersName),ord(i)),
                          FParameters.Parameters[i]);
 end;


Procedure AllSCR(DiodPN:TDiod_PN;
                 Vec:TVector;
                 Func:TFunTriple;
                 T:double=300;V:double=0;
                 FileName:string='';
                 Npoint:integer=100);
 var i:integer;
     step,X:double;
begin
 Vec.Clear;
 step:=DiodPN.Wn(T,V)/Npoint;
 for I := 0 to Npoint do
   begin
    X:=-DiodPN.Wn(T,V)+step*i;
    Vec.Add(X,Func(X,T,V));
   end;
 step:=DiodPN.Wp(T,V)/Npoint;
 for I := 1 to Npoint do
   begin
    X:=step*i;
    Vec.Add(X,Func(X,T,V));
   end;
 if FileName<>'' then Vec.WriteToFile(FileName);
end;


Procedure AllSCR(DiodPN:TDiod_PN;
                 Func:TFunTriple;
                 T:double=300;V:double=0;
                 FileName:string='';
                 Npoint:integer=100);overload;
 var Vec:TVector;
begin
 Vec:=TVector.Create;
 AllSCR(DiodPN,Vec,Func,T,V,FileName,Npoint);
 Vec.Free;
end;

{ TMaterialShow }

procedure TMaterialShow.CBSelectChange(Sender: TObject);
begin
 if Material.Name=CBSelect.Text then Exit;
 if (Material.Name=Materials[High(TMaterialName)].Name) then
   Material.WriteToIniFile(ConfigFile);
 Material.ChangeMaterial(TMaterialName(CBSelect.ItemIndex));
 if (CBSelect.Text=Materials[High(TMaterialName)].Name) then
   Material.ReadFromIniFile(ConfigFile);
 ShowData();
end;

constructor TMaterialShow.Create(LSD{, LID}: array of TLabel;
                                 CBSel: TComboBox;
                                 Pr: string;
                                 CF:TIniFile
                                 );
  var i:integer;
      iMPN:TMaterialParametersName;
begin
  inherited Create;
  Prefix:=Pr;
  ConfigFile:=CF;
  if High(LSD)<ord(High(TMaterialParametersName))
    then
    showmessage('Label array is deficient for material parameters');


  for I := ord(Low(TMaterialParametersName)) to ord(High(TMaterialParametersName)) do
    LShowData[TMaterialParametersName(i)]:=LSD[i];

  for IMPN := Low(TMaterialParametersName) to High(TMaterialParametersName) do
       case iMPN of
        nMe,nARich_n:LShowData[IMPN].Font.Color:=clBlue;
        nMh,nARich_p:LShowData[IMPN].Font.Color:=clRed;
        else LShowData[IMPN].Font.Color:=clGreen;
       end;

  CBSelect:=CBSel;
  CBSelect.Sorted:=False;
  for i :=Ord(Low(TMaterialName)) to ord(High(TMaterialName)) do
      CBSelect.Items.Add(Materials[TMaterialName(i)].Name);
  CBSelect.ItemIndex:=ConfigFile.ReadInteger(SecDiod,Prefix+'Material',0);
  CBSelect.OnChange:=CBSelectChange;

 Material:=TMaterial.Create(TMaterialName(CBSelect.ItemIndex));
 if Material.Name=Materials[High(TMaterialName)].Name
    then Material.ReadFromIniFile(ConfigFile);

 ShowData();
end;

procedure TMaterialShow.Free;
begin
  ConfigFile.WriteInteger(SecDiod,Prefix+'Material',CBSelect.ItemIndex);
  if Material.Name=Materials[High(TMaterialName)].Name
      then  Material.WriteToIniFile(ConfigFile);
  inherited Free;
end;

procedure TMaterialShow.LInputDataClick(Sender: TObject);
 var
     st:string;
     i:TMaterialParametersName;
begin
  for I := Low(TMaterialParametersName) to High(TMaterialParametersName) do
    if (Sender as TLabel)=LShowData[i] then
      begin
        st:=LShowData[i].Caption;
        if (st='ErResult')or(st='?') then st:='';
        st:=InputBox('Input value',
                     'the material parameter value is expected',
                     st);
        StrToNumber(st, ErResult, Material.FParameters.Parameters[i]);
      end;
  ShowData();
end;

procedure TMaterialShow.ShowData;
 var i:TMaterialParametersName;
     temp:string;
begin
  for I := Low(TMaterialParametersName) to High(TMaterialParametersName) do
   begin
    if Material.FParameters.Parameters[i]<>ErResult then
     begin
       case i of
        nEg0,nEps,nMe,nMh:temp:=FloatToStrF(Material.FParameters.Parameters[i],ffFixed,3,2);
        nVarshA:temp:=FloatToStrF(Material.FParameters.Parameters[i],ffgeneral,5,1);
        else temp:=FloatToStrF(Material.FParameters.Parameters[i],ffExponent,3,2);
       end;
     end
                                                    else
     temp:='?';
    LShowData[i].Caption:=temp;
   end;

  if Material.Name=Materials[High(TMaterialName)].Name then
   for I := Low(TMaterialParametersName) to High(TMaterialParametersName) do
     begin
       LShowData[i].OnClick:=LInputDataClick;
       LShowData[i].Cursor:=crHandPoint;
     end
                                                       else
   for I := Low(TMaterialParametersName) to High(TMaterialParametersName) do
     begin
       LShowData[i].OnClick:=nil;
       LShowData[i].Cursor:=crDefault;
     end;
end;



function TMaterialLayer.F(T: double): double;
begin
 if IsNType then
      Result:=Material.EgT(T)-Kb*T*ln(Material.Nc(T)/Nd)
            else
      Result:=Kb*T*ln(Material.Nv(T)/Nd);
end;

function TMaterialLayer.GetARich: Double;
begin
 try
  if IsNType then Result:=Material.ARich_n
             else Result:=Material.ARich_p;
 except
  Result:=ErResult;
 end;
end;

function TMaterialLayer.GetMeff: Double;
begin
 try
  if IsNType then Result:=Material.Me
             else Result:=Material.Mh;
 except
  Result:=1;
 end;
end;


procedure TMaterialLayer.SetMaterial(value: TMaterial);
begin
   if Value = nil then
      Value:=TMaterial.Create(High(TMaterialName));
   FMaterial:=value;
end;

procedure TMaterialLayer.SetNd(value: Double);
begin
  fNd:=abs(value);
end;

{ TDiod }
procedure TDiodMaterial.SetArea(value: Double);
begin
  fArea:=abs(value);
end;

{ TDiod_Schottky }

constructor TDiod_Schottky.Create;
begin
 inherited Create;
 FSemiconductor:=TMaterialLayer.Create;
end;

procedure TDiod_Schottky.ReadFromIniFile(ConfigFile: TIniFile);
begin
  Area:=ConfigFile.ReadFloat(SecDiod,'Square Schottky',3.14e-6);
  Semiconductor.Nd:=ConfigFile.ReadFloat(SecDiod,'Concentration Schottky',5e21);
  Semiconductor.IsNType:=ConfigFile.ReadBool(SecDiod,'Layer type Schottky',True);
  Eps_i:=ConfigFile.ReadFloat(SecDiod,'InsulPerm',4.1);
  Thick_i:=ConfigFile.ReadFloat(SecDiod,'InsulDepth',3e-9);
end;

procedure TDiod_Schottky.WriteToIniFile(ConfigFile: TIniFile);
begin
  ConfigFile.WriteFloat(SecDiod,'Square Schottky',Area);
  ConfigFile.WriteFloat(SecDiod,'Concentration Schottky',Semiconductor.Nd);
  ConfigFile.WriteFloat(SecDiod,'InsulPerm',Eps_i);
  ConfigFile.WriteFloat(SecDiod,'InsulDepth',Thick_i);
  ConfigFile.WriteBool(SecDiod,'Layer type Schottky',Semiconductor.IsNType);
end;

procedure TDiod_Schottky.SetEps(value: double);
begin
 if value>1 then FEps_i:=value
            else FEps_i:=1;
end;

procedure TDiod_Schottky.SetMaterialLayer(value: TMaterialLayer);
begin
   if Value = nil then
      Value:=TMaterialLayer.Create;
   FSemiconductor:=value;
end;


procedure TDiod_Schottky.SetThick(value: double);
begin
 FThick_i:=abs(value);
end;

function TDiod_Schottky.Vbi(T: double): double;
{об'ємний потенціал (build in)}
  begin
   try
    Result:=Kb*T*ln(Semiconductor.Material.Nc(T)/Semiconductor.Nd);
    except
     Result:=ErResult;
   end;
  end;

destructor TDiod_Schottky.Destroy;
begin
  FSemiconductor.Free;
  inherited;
end;

function TDiod_Schottky.Em(T, Fb0, Vrev, C1: double): double;
{максимальне значення електричного поля}
 var a,b,c,Fb,Fa:double;
     i:integer;
 function FunEmTemp(Emtemp:double):double;
  begin
   try
    Result:=Emtemp-sqrt(2*Qelem*Semiconductor.Nd/Semiconductor.Material.Eps/Eps0*
            (Semiconductor.Material.Varshni(Fb0,T)-C1*Emtemp-Vbi(T)+Vrev));
   except
    Result:=ErResult;
   end;
  end;

begin
 Result:=ErResult;
 try
  if (C1=0) then
   begin
   Result:=sqrt(2*Qelem*Semiconductor.Nd/Semiconductor.Material.Eps/Eps0*
            (Semiconductor.Material.Varshni(Fb0,T)-Vbi(T)+Vrev));
   end
                     else
   begin
    a:=0;
    b:=sqrt(2*Qelem*Semiconductor.Nd/Semiconductor.Material.Eps/Eps0*
            (Semiconductor.Material.Varshni(Fb0,T)-Vbi(T)+Vrev));

    Fa:=FunEmTemp(a);
    Fb:=FunEmTemp(b);
    if (Fa=ErResult)or(Fb=ErResult) then Exit;
    repeat
     if Fb*Fa<=0 then Break;
     b:=2*b;
     Fb:=FunEmTemp(b);
    until false;
    i:=0;
    repeat
      inc(i);
      c:=(a+b)/2;
      Fb:=FunEmTemp(c);
      Fa:=FunEmTemp(a);
      if (Fb*Fa<=0) or (Fb=ErResult)
        then b:=c
        else a:=c;
    until (i>1e5)or(abs((b-a)/c)<1e-4);
    if (i>1e5) then Exit;
    Result:=c;
   end;
 except
 end;
end;


function TDiod_Schottky.Fb(T, I0: double): double;
{повертає висоту бар'єру
Fb=kT*ln(Area*ARich*T^2/I0)}
 begin
  try
   if Semiconductor.ARich=ErResult then
         Result:=ErResult
                                   else
         Result:=Kb*T*ln(Area*Semiconductor.Arich*sqr(T)/I0);
  except
   Result:=ErResult;
  end;
 end;

function TDiod_Schottky.Get_nu: double;
begin
 try
  Result:=Eps0*Semiconductor.Material.Eps/Qelem/Semiconductor.Nd;
 except
   Result:=ErResult;
 end;
end;

function TDiod_Schottky.I0(T, Fb: double): double;
{повертає струму насичення
I0=Area*Arich*T^*exp(-Fb/Kb/T)}
begin
  try
   if Semiconductor.ARich=ErResult then
         Result:=ErResult
                                   else
         Result:=Area*Semiconductor.ARich*sqr(T)*exp(-Fb/Kb/T);
  except
   Result:=ErResult;
  end;
end;

function TDiod_Schottky.kTln(T: double): double;
{повертає значення kT ln(Area*ARich*T^2)}
 begin
  try
   if Semiconductor.ARich=ErResult then
     Result:=ErResult
                                   else
     Result:=Kb*T*ln(Area*Semiconductor.ARich*sqr(T));
  except
   Result:=ErResult;
  end;
 end;


{ TMaterialLayerShow }

procedure TMaterialLayerShow.CBNTypeClick(Sender: TObject);
begin
 MaterialLayer.IsNType:=CBNType.Checked;
end;

constructor TMaterialLayerShow.Create(ML: TMaterialLayer;
                                      CBNT: TCheckBox;
                                      STData: TStaticText;
                                      STCaption:TLabel
                                      );
begin
  inherited Create;
  MaterialLayer:=ML;
  CBNType:=CBNT;
  CBNType.Caption:='n-type';
  CBNType.Checked:=MaterialLayer.IsNType;
  CBNType.OnClick:=CBNTypeClick;

  NdShow:=TParameterShow.Create(STData,STCaption,
                               'Carrier concentration, m^(-3):',
                               'Carrier concentration',
                               'Input carrier concentration, [ ] = m^(-3)',
                               MaterialLayer.Nd);
  NdShow.Hook:=NdRead;
end;

procedure TMaterialLayerShow.Free;
begin
 NdShow.Free;
 inherited Free;
end;

procedure TMaterialLayerShow.NdRead;
begin
  MaterialLayer.Nd:=NdShow.Data;
end;

{ TDiod_SchottkyShow }

procedure TDiod_SchottkyShow.AreaRead;
begin
  Diod_Schottky.Area:=AreaShow.Data;
end;

constructor TDiod_SchottkyShow.Create(DSc: TDiod_Schottky;
             CBNT: TCheckBox;
             STDataNd, STDataArea, STDataEps, STDataThick: TStaticText; STCaptionNd,
             STCaptionArea, STCaptionEps, STCaptionThick: TLabel
             );
begin
 inherited Create;
 Diod_Schottky:=DSc;
 SemiconductorShow:=TMaterialLayerShow.Create(Diod_Schottky.Semiconductor,
                       CBNT,STDataNd,STCaptionNd);
 AreaShow:=TParameterShow.Create(STDataArea,STCaptionArea,
                               'Area, m^2:',
                               'Diode area',
                               'Input contact area, [ ] = m^2',
                               Diod_Schottky.Area);
  AreaShow.Hook:=AreaRead;
  Eps_iShow:=TParameterShow.Create(STDataEps,STCaptionEps,
                               'Permittivity:',
                               'Layer permittivity',
                               'Permittivity of the interfacial insulator layer',
                               Diod_Schottky.Eps_i);
  Eps_iShow.Hook:=EpsRead;
  Thick_iShow:=TParameterShow.Create(STDataThick,STCaptionThick,
                               'Thickness, m:',
                               'Layer thickness',
                               'Thickness of the interfacial insulator layer, [ ] = m',
                               Diod_Schottky.FThick_i);
  Thick_iShow.Hook:=ThickRead;
end;

procedure TDiod_SchottkyShow.EpsRead;
begin
  Diod_Schottky.Eps_i:=Eps_iShow.Data;
end;

procedure TDiod_SchottkyShow.Free;
begin
 Thick_iShow.Free;
 Eps_iShow.Free;
 AreaShow.Free;
 SemiconductorShow.Free;
 inherited Free;
end;

procedure TDiod_SchottkyShow.ThickRead;
begin
  Diod_Schottky.Thick_i:=Thick_iShow.Data;
end;

{ TDiod_PN }

constructor TDiod_PN.Create;
begin
 inherited Create;
 FLayerN:=TMaterialLayer.Create;
 FLayerN.IsNType:=True;
 FLayerP:=TMaterialLayer.Create;
 FLayerP.IsNType:=False;
end;

function TDiod_PN.delN(V, I, R, T: double): double;
begin
 if FLayerN.Nd>FLayerP.Nd then
    Result:=-FLayerP.Nd/2
         +sqrt(sqr(FLayerP.Nd)/4
             +sqr(FLayerP.Material.n_i(T))
              *(exp((V-I*R)/T/Kb)-1))
                          else
    Result:=-FLayerN.Nd/2
         +sqrt(sqr(FLayerN.Nd)/4
             +sqr(FLayerN.Material.n_i(T))
              *(exp((V-I*R)/T/Kb)-1))
end;

function TDiod_PN.fi(x, T: double;V:double=0): double;
begin
 if x<0 then
   Result:=Qelem*FLayerN.Nd/(2*FLayerP.Material.Eps*Eps0)*
           sqr(Wn(T,V)+x)
        else
   Result:=Vdif(T,V)-Qelem*FLayerP.Nd/(2*FLayerP.Material.Eps*Eps0)*
           sqr(Wp(T,V)-x);
end;

procedure TDiod_PN.Free;
begin
 FLayerN.Free;
 FLayerP.Free;
 inherited Free;
end;

function TDiod_PN.GetNd: double;
begin
  if FLayerN.Nd>FLayerP.Nd then
    Result:=FLayerP.Nd
                           else
   Result:=FLayerN.Nd;
end;

function TDiod_PN.Igen(TauRec, T: Double): double;
begin
  Result:=Qelem*Area*Power(n_i(T),2)/Nd*sqrt(mu(T)*Kb*T/TauRec);
end;

function TDiod_PN.Iscr(TauGen, T, Voltage: Double): double;
begin
 Result:=Qelem*Area*n_i(T)*W(T,Voltage)/2/TauGen;
end;

function TDiod_PN.Iscr_rec(T, V: double): double;
 var tau_n, Kpn, Et: double;
begin
 Result:=0;
 tau_n:=1e-9;
 Kpn:=1e-2;
 Et:=0.5;
 Result:=Result+Iscr_rec(T, V, tau_n, Kpn, Et){+Igen(1e-7,T)*exp(V/Kb/T)};
end;

function TDiod_PN.Iscr_rec(T, V, tau_n, Kpn, Et: double): double;
 var kT,Tetta,b,Er0,ff,Alpha,Betta:double;
begin
 kT:=Kb*T;
 Tetta:=(Vdif(T,V)-V)/kT;
 Er0:=FLayerP.Material.Ei(T)-kT/2*ln(Kpn);
 b:=exp(-V/2/kT)*cosh((Et-Er0)/kT);
 Alpha:=2*sinh(Tetta/2);
 Betta:=sqrt(FLayerP.Nd/FLayerN.Nd/Kpn)+
        sqrt(FLayerN.Nd/FLayerP.Nd*Kpn)+
        2*b*cosh(Tetta/2);
 if sqr(b)<1 then
         ff:=ArcTan(Alpha/Betta*sqrt(1-sqr(b)))/sqrt(1-sqr(b))
    else if sqr(b)>1 then
         ff:=ArcTanh(Alpha/Betta*sqrt(sqr(b)-1))/sqrt(sqr(b)-1)
      else
         ff:=Alpha/Betta;

 Result:=2*Area*Qelem*FLayerP.Material.n_i(T)*sinh(V/2/kT)/
         (tau_n*sqrt(Kpn))*W(T,V)/Tetta*ff;
end;

function TDiod_PN.I_Shockley(T, V: double): double;
 var Vec:TVector;
begin
  Vec:=TVector.Create;
  AllSCR(Self,Vec,R_Shockley,T,V);
  Result:=Area*Qelem*Vec.Int_Trap;
  Vec.Free;
end;



function TDiod_PN.TauToLdif(tau, T: double): double;
begin
 Result:=sqrt(tau*mu(T)*Kb*T);
end;

function TDiod_PN.LdifToTauRec(L,T:double):double;
begin
 Result:=sqr(L)/(mu(T)*Kb*T);
end;

function TDiod_PN.mu(T: double=300): double;
begin
 if FLayerN.Nd>FLayerP.Nd then
    Result:=Silicon.mu_n(T,Nd)
                          else
    Result:=Silicon.mu_p(T,Nd);
end;

function TDiod_PN.n_i(T: double=300): double;
begin
  if FLayerN.Nd>FLayerP.Nd then
    Result:=FLayerP.Material.n_i(T)
                           else
   Result:=FLayerN.Material.n_i(T);
end;

function TDiod_PN.n_SCR(x, T: double;V:double=0): double;
begin
 Result:=FLayerN.Nd*exp(-fi(x,T,V)/Kb/T)
end;

function TDiod_PN.p_SCR(x, T: double;V:double=0): double;
begin
 Result:=FLayerP.Nd*exp(-(Vdif(T,V)-fi(x,T,V))/Kb/T);
end;

procedure TDiod_PN.ReadFromIniFile(ConfigFile: TIniFile);
begin
  Area:=ConfigFile.ReadFloat(SecDiod,'Square pn-Diod',130e-6);
  LayerP.Nd:=ConfigFile.ReadFloat(SecDiod,'Concentration p-layer',1e16);
  LayerN.Nd:=ConfigFile.ReadFloat(SecDiod,'Concentration n-layer',1e20);
end;

function TDiod_PN.Rnp(T, V, I: double): double;
 var Vd, Wd:double;
begin
 Wd:=W(T,V);
 if (Wd=ErResult)or (Area=ErResult) then
   begin
     Result:=ErResult;
     Exit
   end;
 Vd:=Vdif(T,V);
 Result:=I/(Wd*Area*FLayerP.Material.n_i(T)*(exp(V/2/Kb/T)-1))*
          (Vd-V)/2/Kb/T/Qelem;

end;

function TDiod_PN.R_DAP(x, T, V: double): double;
  const Eta=0;
        Etd=0.1;
//--------JApplPhys_78_3185.pdf
//        Etd=-0.35;
        Cad0=1.1e-13;
        r0=5e-9;
        a0=3.23e-9;
        Nt=1e26;
        A=0.215;
  var p,n,ni,ee,p1,n1,p2,n2,
      Sig_nA,Sig_pA,Sig_nD,Sig_pD,
      tau_nA,tau_pA,tau_nD,tau_pD,
      rrA,rrD,Ra,Rd,
      Rad,r,R12,S12:double;
  function L(r:double):double;
   begin
     Result:=(1+r/a0+sqr(r/a0)/3)*exp(-r/a0);
   end;
begin
 p:=p_SCR(x, T, V);
 n:=n_SCR(x, T, V);
 ni:=FLayerP.Material.n_i(T);
 ee:=exp(-(Etd-Eta)/Kb/T);
 p1:=ni*exp(-Eta/Kb/T);
 n1:=ni*exp(Eta/Kb/T);
 p2:=ni*exp(-Etd/Kb/T);
 n2:=ni*exp(Etd/Kb/T);
 r:=r0;
 Sig_nD:=A*sqr(r);
 Sig_pA:=A*sqr(r);
 Sig_pD:=Sig_nD/1e12;
 Sig_nA:=Sig_pA/1e12;
 tau_nA:=1/(Nt*Sig_nA*FLayerP.Material.Vth_n(T));
 tau_pA:=1/(Nt*Sig_pA*FLayerP.Material.Vth_p(T));
 tau_nD:=1/(Nt*Sig_nD*FLayerP.Material.Vth_n(T));
 tau_pD:=1/(Nt*Sig_pD*FLayerP.Material.Vth_p(T));
 Rad:=Cad0*L(r)*sqr(Nt);


 //--------JApplPhys_78_3185.pdf
//  ee:=exp((Etd-Eta)/Kb/T);
// Rad:=1e35;
// tau_nA:=1e-7;
// tau_pA:=1e-8;
// tau_nD:=100;
// tau_pD:=1e-7;
//-------------------------

 rrA:=tau_nA*(p+p1)+tau_pA*(n+n1);
 rrD:=tau_nD*(p+p2)+tau_pD*(n+n2);
 Ra:=(n*p-sqr(ni))/rrA;
 Rd:=(n*p-sqr(ni))/rrD;

 S12:=(1-ee*tau_nA*tau_pD/tau_nD/tau_pA)/
      (tau_nA*tau_pD*(1-ee))*(n*p-sqr(ni));
 R12:=rrA*rrD/(2*Rad*tau_nA*tau_pD*tau_nD*tau_pA*(1-ee))+
      (tau_nA*(p+p1)+tau_pD*(n+n2))/(2*tau_nA*tau_pD*(1-ee))+
      ee*(tau_nD*(p+p2)+tau_pA*(n+n1))/(2*tau_nD*tau_pA*(1-ee));
 Result:=Ra+Rd+(sqrt(sqr(R12)-S12)-R12)*
         (tau_nA*tau_pD*(n+n2)*(p+p1)-tau_nD*tau_pA*(n+n1)*(p+p2))/
         (rrA*rrD);

//--------JApplPhys_78_3185.pdf
// R12:=(p+p2)*rrA/(2*Rad*tau_nA*tau_pD*tau_pA*(1-ee))+
//       (tau_nA*(p+p1)+tau_pD*(n+n2))/(2*tau_nA*tau_pD*(1-ee));
// Result:=Ra+(R12-sqrt(sqr(R12)-
//                       (n*p-sqr(ni))/(tau_nA*tau_pD*(1-ee))))*
//          tau_pA*(n+n1)/rrA;
//--------------------------

end;

function TDiod_PN.R_Shockley(x, T, V: double): double;
 var p,n,ni:double;
begin
 p:=p_SCR(x, T, V);
 n:=n_SCR(x, T, V);
 ni:=FLayerP.Material.n_i(T);
 Result:=(n*p-sqr(ni))/(1e-6*(n+p+2*ni));
end;

function TDiod_PN.TauGen(Iscr, T: Double): double;
begin
  Result:=Qelem*Area*n_i(T)*W(T)/2/Iscr;
end;

function TDiod_PN.TauRec(Igen, T: Double): double;
begin
    Result:=Power(Qelem*Area,2)*Power(n_i(T),4)*mu(T)*Kb*T/sqr(Nd*Igen);
end;

function TDiod_PN.Vdif(T, V: double): double;
begin
 if (FLayerP.FMaterial.Eg0=ErResult)or
    (FLayerP.Material.Mh=ErResult)or
    (FLayerN.Material.Me=ErResult)or
    (FLayerP.Nd=ErResult)or
    (FLayerN.Nd=ErResult) then
      begin
       Result:=ErResult;
       Exit;
      end;
 Result:=FLayerP.Material.EgT(T)-
         Kb*T*ln(FLayerP.Material.Nv(T)*FLayerN.Material.Nc(T)/FLayerP.Nd/FLayerN.Nd)
         -V;
end;

function TDiod_PN.W(T, V: double): double;
 var Vd:double;
begin
 Vd:=Vdif(T,V)-2*Kb*T;
 if Vd=ErResult then
  begin
    Result:=ErResult;
    Exit;
  end;
 Result:=sqrt(2*FLayerP.Material.Eps*Eps0/Qelem*Vd*
             (FLayerN.Nd+FLayerP.Nd)/FLayerN.Nd/FLayerP.Nd);
end;

function TDiod_PN.Wn(T, V: double): double;
 var Wtotal:double;
begin
 Wtotal:=W(T,V);
 if Wtotal=ErResult then
    Result:=ErResult
                    else
    Result:=Wtotal*FLayerP.Nd/(FLayerN.Nd+FLayerP.Nd)
end;

function TDiod_PN.Wp(T, V: double): double;
 var Wtotal:double;
begin
 Wtotal:=W(T,V);
 if Wtotal=ErResult then
    Result:=ErResult
                    else
    Result:=Wtotal*FLayerN.Nd/(FLayerN.Nd+FLayerP.Nd)
end;

procedure TDiod_PN.WriteToIniFile(ConfigFile: TIniFile);
begin
  ConfigFile.WriteFloat(SecDiod,'Square pn-Diod',Area);
  ConfigFile.WriteFloat(SecDiod,'Concentration p-layer',LayerP.Nd);
  ConfigFile.WriteFloat(SecDiod,'Concentration n-layer',LayerN.Nd);
end;

{ TDiod_PNShow }

procedure TDiod_PNShow.AreaRead;
begin
 Diod_PN.Area:=AreaShow.Data;
end;

constructor TDiod_PNShow.Create(Dpn: TDiod_PN;
                                CBNTn, CBNTp: TCheckBox;
                                STDataNdN, STDataNdP, STDataArea: TStaticText;
                                STCaptionNdN, STCaptionNdP, STCaptionArea: TLabel);
begin
 inherited Create;
 Diod_PN:=Dpn;
 LayerNShow:=TMaterialLayerShow.Create(Diod_PN.LayerN,
                       CBNTn,STDataNdN,STCaptionNdN);
 LayerNShow.MaterialLayer.fIsNType:=True;
 LayerPShow:=TMaterialLayerShow.Create(Diod_PN.LayerP,
                       CBNTp,STDataNdP,STCaptionNdP);
 LayerPShow.MaterialLayer.fIsNType:=False;
 LayerNShow.NdShow.STCaption.Caption:='Electron density, m^(-3):';
 LayerPShow.NdShow.STCaption.Caption:='Hole concentration, m^(-3):';
 LayerNShow.CBNType.OnClick:=nil;
 LayerNShow.CBNType.Checked:=True;
 LayerNShow.CBNType.Enabled:=False;
 LayerPShow.CBNType.OnClick:=nil;
 LayerPShow.CBNType.Checked:=True;
 LayerPShow.CBNType.Enabled:=False;
 LayerPShow.CBNType.Caption:='p-type';
 AreaShow:=TParameterShow.Create(STDataArea,STCaptionArea,
                               'Area, m^2:',
                               'Diode area',
                               'Input contact area, [ ] = m^2',
                               Diod_PN.Area);
  AreaShow.Hook:=AreaRead;
end;

procedure TDiod_PNShow.Free;
begin
 AreaShow.Free;
 LayerPShow.Free;
 LayerNShow.Free;
 inherited Free;
end;

{ Silicon }

class function Silicon.A(A0, T, n: double): double;
begin
 Result:=A0*Power(T/300.0,n);
end;

class function Silicon.Absorption(Lambda:double;T:double=300): double;
// var  Ephoton:double;
begin
//  Result:=ErResult;
//  if (T<200)or(T>500)or(Lambda<250)or(Lambda>1450) then Exit;
  Result:=AbsorbFromTable(Lambda, abSchinke, T);

//  Ephoton:=Hpl*2*Pi*Clight/(Lambda*1e-9*Qelem);//[]=eV
//  Result:=Rajkanan(Ephoton,T);

end;

class function Silicon.AbsorptionFC(Lambda, N: double; itIsDonor: boolean): double;
      {коефіцієнт поглинання світла вільними носіями,
      [Lambda]=нм,
      [N]=1/м^3, концентрації носіїв,
      поява itIsDonor викликана тим, що для n та p напівпровідників
      формули трохи різні
      [Result]=1/м}
begin
//  JApplPhys_116_063106 (2014):
  if itIsDonor then Result:=1.68e-10*Power(Lambda*1e-7,2.88)*N
               else Result:=1.82e-13*Power(Lambda*1e-7,2.18)*N;
//  IEEETransElecDev_60_p2156 (2013):
//  if itIsDonor then Result:=1.8e-22*Power(Lambda*1e-3,2.6)*N
//            else Result:=2.6e-22*Power(Lambda*1e-3,2.4)*N;
end;

class function Silicon.AbsorptionFC_complex(Lambda, n, p, T: double): double;
      {коефіцієнт поглинання світла вільними носіями,
      [Lambda]=нм,
      [n,p]=1/м^3, концентрації носіїв
      [Result]=1/м}
begin
 Result:=T*1e-13*(5.6*Power(Lambda*1e-7,2.88)*n+6.1e-3*Power(Lambda*1e-7,2.18)*p);
end;

class function Silicon.BGN(Ndoping: Double; itIsDonor:Boolean): double;
begin
  if Ndoping<1e20 then
    begin
    Result:=0;
    Exit;
    end;
  if  itIsDonor then Result:=4.2e-5*Power(Ln(Ndoping/1e20),3)
                else Result:=4.72e-5*Power(Ln(Ndoping/1e20),3);
 {Di Yana and Andres Cuevas,
 JOURNAL OF APPLIED PHYSICS 116, 194505 (2014)}

//  Result:=6.92e-3*(Ln(Ndoping/1.3e17)+sqrt(0.5+sqr(Ln(Ndoping/1.3e17))));
end;

class function Silicon.Brad(T:double=300;Ndoping: Double=1e21; itIsDonor:Boolean=True;
                          w:double=3e-4;IsTextured:boolean=True;del_n:double=0): double;
begin

 Result:=Brad_low(T)*Brel(Ndoping,itIsDonor,T)*(1-Fpr(w,IsTextured,del_n));
{SolEnerMatSC_235_111467 (2022)}

// Result:=(-1336.5550952225+22.4496406414*T-0.148937976*sqr(T)
//        +4.9057776424E-4*Power(T,3)-8.0347065425E-7*Power(T,4)
//        +5.2400039351E-10*Power(T,5))*1e-21;
{APPLIED PHYSICS LETTERS 104, 112105 (2014), Nguyen}
end;

class function Silicon.Brad_low(T: double): double;
begin
 Result:=Power(10,
         -176.98+2.68812*T-0.018137*sqr(T)+6.56769e-5*Power(T,3)
         -1.21382e-7*Power(T,4)+8.99086e-11*Power(T,5))
         /sqr(n_i(T))*1e6;
end;

class function Silicon.Brel(Ndoping: Double; itIsDonor: Boolean;
  T: double): double;
begin
  Result:=exp(-BGN(Ndoping,itIsDonor)/T/Kb);
end;

class function Silicon.Brel_2(n, p, T: double): double;
 var bmin,b1,b3:double;
begin
 bmin:=0.2-0.2/(1+Power(T/320.0,2.5));
 b1:=1.5e18+(1e7-1.5e18)/(1+Power(T/550.0,3));
 b3:=4e18+(1e9-4e18)/(1+Power(T/365.0,3.54));
 Result:=bmin+(1-bmin)/(1+Power((n+p/b1)/1e6,0.54)
                        +Power((n+p/b3)/1e6,1.25));
end;

class function Silicon.CarrierConcentration(Resistivity: double;
         ItIsHoleMaterial: boolean; T: double): double;
begin
 if Resistivity<0.001 then
  begin
    Result:=ErResult;
    Exit;
  end;
 if ItIsHoleMaterial then Result:=Bisection(CCDod,[Resistivity,T,1],5e24,5e16,1e-8)
                     else Result:=Bisection(CCDod,[Resistivity,T,-1],5e24,5e16,1e-8)
end;

class function Silicon.CCDod(Concentration: double;
  Parameters: array of double): double;
begin
 if Parameters[2]>0 then
      Result:=Concentration-1/(Qelem*0.01*Parameters[0]*Silicon.mu_p(Parameters[1],Concentration))
                    else
      Result:=Concentration-1/(Qelem*0.01*Parameters[0]*Silicon.mu_n(Parameters[1],Concentration))
end;

class function Silicon.Cn_Auger(n, T: double): double;
begin
 Result:=Cn_AugerNew(n, MinorityN(n, T), T);

// Result:=2.8e-43*g_e(gmax_n(235548,T),
//                     0,n,5e22,0.34);
// Result:=2.8e-43*(1+(ThermallyPower(235548,-1.5013,T)-1)*
//                    (1-tanh(Power(n/5e22,0.34))));
 {J. Appl. Phys. 82, p.4938 (1997)}
end;

class function Silicon.Cn_AugerNew(n, p, T: double): double;
begin
 Result:=3.41e-43*g_e(gmax_n(23923.15,T),
                     p,n,3.2e23,2);
 {SolEnerMatSC_234_111428 (2022)}

// Result:=3.41e-43*g_e2(gmax_n(22928.53,T),
//                     p,n,4e23,2);
 {SolEnerMatSC_235_111467 (2022)}
end;

class function Silicon.Cp0_vs_T(ScaleFactor, T: double): double;
begin
 Result:=ScaleFactor*(7.91e-44-4.13e-47*T+3.59e-49*sqr(T));
end;

class function Silicon.Cp_Auger(p, T: double): double;
begin
  Result:=Cp_AugerNew(MinorityN(p, T), p, T);


//  Result:=Cp0_vs_T(1, T)
//        *g_e(gmax_p(564812,T), p,0,5e22,0.29);
//  Result:=(7.91e-44-4.13e-47*T+3.59e-49*sqr(T))
//        *(1+(ThermallyPower(564812,-1.6546,T)-1)*
//                    (1-tanh(Power(p/5e22,0.29))));
 {J. Appl. Phys. 82, p.4938 (1997)}
end;

class function Silicon.Cp_AugerNew(n, p, T: double): double;
begin
  Result:=Cp0_vs_T(1.17/1.238, T)
        *g_e(gmax_p(59487.146,T), p,n,3.2e23,2);
 {SolEnerMatSC_234_111428 (2022)}

// Result:=Cp0_vs_T(1.17/1.238, T)
//         *g_e2(gmax_p(61244.15,T),
//                     p,n,4e23,2);
 {SolEnerMatSC_235_111467 (2022)}
end;

class function Silicon.D_n(T: Double=300; Ndoping: Double=1e21): double;
begin
 Result:=mu_n(T,Ndoping)*Kb*T;
end;

class function Silicon.D_p(T: Double=300; Ndoping: Double=1e21): double;
begin
 Result:=mu_p(T,Ndoping)*Kb*T;
end;

class function Silicon.Eg(T: double=300): double;
 const Eg0=1.1701;
       Alpha=3.23e-4;
       Tetta=446;
       Delta2=0.2601;
 var gamma,ksi:double;
begin
 if T=0 then
    begin
    Result:=ErResult;
    Exit;
    end;
 gamma:=(1-3*Delta2)/(exp(Tetta/T)-1);
 ksi:=2*T/Tetta;
 Result:=Eg0-Alpha*Tetta*(gamma
    +3*Delta2/2*(Power((1+sqr(Pi*ksi)/3/(1+Delta2)
       +(3*Delta2-1)/4*Power(ksi,3)
       +8/3*Power(ksi,4)+Power(ksi,6)),1/6)-1));
//PHYSICAL REVIEW B 66, 085201 (2002), Passler

// Result:=TMaterial.VarshniFull(Eg0_Si,T)
end;

class function Silicon.Ei(T: double): double;
begin
   Result:=Eg(T)+Kb*T*ln(n_i(T)/Nc(T));
end;

class function Silicon.Fpr(w: double; IsTextured: boolean;
  del_n: double): double;
  var w1:double;
begin
  w1:=Log10(w*100);
  if IsTextured
    then Result:=0.8681-0.0411*Power(w1,3)-0.2393*Power(w1,2)-0.117*w1
    else Result:=0.9835+0.006841*w1-4.554e-9*Power(del_n*1e-6,0.4612);
end;

class function Silicon.AbsorbFromTable(Lambda: Double;
    SiAbsorbTable: TSiAbsorbTable=abGreen; T: Double = 300): double;
 var Vect,VectKoef:TVectorTransform;
     i,HN:integer;
begin

  Result:=ErResult;
  if (T<200)or(T>500)
     or(Lambda<Lambda_Siabsorb[SiAbsorbTable][Low(Lambda_Siabsorb[SiAbsorbTable])])
     or(Lambda>Lambda_Siabsorb[SiAbsorbTable][High(Lambda_Siabsorb[SiAbsorbTable])])
      then Exit;

  Vect:=TVectorTransform.Create;
  VectKoef:=TVectorTransform.Create;
//  HN:=trunc(High(Coef_Siabsorb[SiAbsorbTable])/2);

//  for I := 0 to HN do
//   begin
//     Vect.Add(Coef_Siabsorb[SiAbsorbTable][2*i],Coef_Siabsorb[SiAbsorbTable][2*i+1]);
//     VectKoef.Add(TemCoef_Siabsorb[SiAbsorbTable][2*i],TemCoef_Siabsorb[SiAbsorbTable][2*i+1]);
//   end;
    for I := 0 to High(Lambda_Siabsorb[SiAbsorbTable]) do
   begin
     Vect.Add(Lambda_Siabsorb[SiAbsorbTable][i],Alpha_Siabsorb[SiAbsorbTable][i]);
     VectKoef.Add(Lambda_Siabsorb[SiAbsorbTable][i],TemCoef_Siabsorb[SiAbsorbTable][i]);
   end;
  Result:=(Vect.YvalueSplain3(Lambda)*Power(T/T0_Siabsorb[SiAbsorbTable],
                                VectKoef.YvalueSplain3(T)*1e-4*T0_Siabsorb[SiAbsorbTable]))*100;
  Vect.Free;
  VectKoef.Free;
end;

class function Silicon.g_e(gmax, p, n, N0, Tetta: double): double;
begin
  Result:=1+(gmax-1)*(1-tanh(Power((p+n)/N0,Tetta)));
end;

class function Silicon.g_e2(gmax, p, n, N0, Tetta: double): double;
begin
  Result:=1+(gmax-1)*1/(1+Power((p+n)/N0,Tetta));
end;

class function Silicon.gmax_n(g0, T: double): double;
begin
 Result:=ThermallyPower(g0,-1.5013,T);
end;

class function Silicon.gmax_p(g0, T: double): double;
begin
 Result:=ThermallyPower(g0,-1.6546,T);
end;

class function Silicon.Meff_e(T: double): double;
begin
 Result:=NPolinom(T,6,[1.06270,-1.61708e-4,6.83008e-6,
                       -3.32013e-8,8.04032e-11,
                       -9.66067e-14,4.54649e-17])/Power(6,2/3);
{Handbook of semiconductor silicon technology,
W.C.O'Mara,R.B.Herring,L.P.Hant,1990}
// Result:=0.25;
end;

class function Silicon.Meff_h(T: double): double;
begin
 Result:=NPolinom(T,6,[0.590525,-5.23548e-4,1.85678e-5,
                       -9.67212e-8,2.30049e-10,
                       -2.59673e-13,1.11997e-16]);
{Handbook of semiconductor silicon technology,
W.C.O'Mara,R.B.Herring,L.P.Hant,1990}
//  Result:=0.58;
end;

class function Silicon.MinorityN(majority, T: double): double;
begin
 Result:=sqr(n_i(T))/majority;
end;

//class function Silicon.mu_n(T: Double=300; Ndoping: Double=1e21): double;
// var  mu_min,mu_0,Nref,Alpha:double;
//begin
// mu_min:=A(92e-4,T,-0.57);
// mu_0:=A(0.1268,T,-2.33);
// Nref:=A(1.3e23,T,2.4);
// Alpha:=A(0.91,T,-0.146);
// Result:=TMaterial.CaugheyThomas(mu_min,mu_0,Nref,Ndoping,Alpha);
//end;

class function Silicon.mu_n(T, Ndoping: Double;itIsMajority:Boolean): double;
 const mu_max=0.1414;
       mu_min=0.00685;
       Nref=9.2e22;
       al=0.711;
 var mu_L,mu_DA,
     Pp,p,n,N_D,N_A,
     Nsc,Neff:double;
begin
 mu_L:=ThermallyPower(mu_max,2.25,300/T);
 if itIsMajority then
   begin
    n:=Ndoping;
    p:=Silicon.MinorityN(Ndoping,T);
    N_D:=Ndoping;
    N_A:=0;
   end
                 else
   begin
    n:=Silicon.MinorityN(Ndoping,T);
    p:=Ndoping;
    N_D:=0;
    N_A:=Ndoping;
   end;

 Pp:=Pklaas(T, Ndoping, itIsMajority, True);

 Neff:=N_D+N_A*Gklaas(Pp,T,True)+p/Fklaas(Pp,T,True);
 Nsc:=N_D+N_A+p;

 mu_DA:=sqr(mu_max)/(mu_max-mu_min)*Nsc/Neff
         *Power(Nref/Nsc,al)
         *Power(T/300,3*al-1.5)
         +mu_max*mu_min/(mu_max-mu_min)*(n+p)/Neff*sqrt(300/T);
 Result:=1/(1/mu_L+1/mu_DA);
end;

class function Silicon.mu_p(T, Ndoping: Double; itIsMajority: Boolean): double;
 const mu_max=0.04705;
       mu_min=0.00449;
       Nref=2.23e23;
       al=0.719;
 var mu_L,mu_DA,
     Pp,p,n,N_D,N_A,
     Nsc,Neff:double;
begin
 mu_L:=ThermallyPower(mu_max,2.25,300/T);
 if itIsMajority then
   begin
    p:=Ndoping;
    n:=Silicon.MinorityN(Ndoping,T);
    N_A:=Ndoping;
    N_D:=0;
   end
                 else
   begin
    p:=Silicon.MinorityN(Ndoping,T);
    n:=Ndoping;
    N_A:=0;
    N_D:=Ndoping;
   end;

 Pp:=Pklaas(T, Ndoping, itIsMajority, False);

 Neff:=N_A+N_D*Gklaas(Pp,T,False)+n/Fklaas(Pp,T,False);
 Nsc:=N_A+N_D+n;

 mu_DA:=sqr(mu_max)/(mu_max-mu_min)*Nsc/Neff
         *Power(Nref/Nsc,al)
         *Power(T/300,3*al-1.5)
         +mu_max*mu_min/(mu_max-mu_min)*(n+p)/Neff*sqrt(300/T);
 Result:=1/(1/mu_L+1/mu_DA);
end;

//class function Silicon.mu_p(T: Double=300; Ndoping: Double=1e21): double;
// var  mu_min,mu_0,Nref,Alpha:double;
//begin
// mu_min:=A(54.3e-4,T,-0.57);
// mu_0:=A(0.04069,T,-2.23);
// Nref:=A(2.35e23,T,2.4);
// Alpha:=A(0.88,T,-0.146);
// Result:=TMaterial.CaugheyThomas(mu_min,mu_0,Nref,Ndoping,Alpha);
//end;

class function Silicon.Nc(T: double): double;
begin
  Result:=4.83e21*(1.094-1.312e-5*T
     +6.753e-7*sqr(T)-4.609e-10*Power(T,3))
     *Power(T,1.5);
  {J.Appl.Phys,115,093705 (2014), Couderc}
//  Result:=2.86e25*Power(T/300.0,1.58);
 {J.Appl.Phys., 67, p2944}
end;

class function Silicon.Nv(T: double): double;
begin
  Result:=4.83e21*(0.3426+3.376e-3*T
     -4.689e-6*sqr(T)+2.525e-9*Power(T,3))
     *Power(T,1.5);
  {J.Appl.Phys,115,093705 (2014), Couderc}
// Result:=3.1e25*Power(T/300.0,1.85);
 {J.Appl.Phys., 67, p2944}
end;

class function Silicon.n_i(T: double): double;
begin
 Result:=1.541e21*Power(T,1.712)*exp(-Eg(T)/2/T/Kb);
 {J.Appl.Phys,115,093705 (2014), Couderc}
// Result:=1.64e21*Power(T,1.706)*exp(-Eg(T)/2/T/Kb);
end;

class function Silicon.Rajkanan(Ephoton, T: double): double;
 const Eg0:array[0..2]of double=(Eg0_Si,2.5,3.2); {[]=eB}
       Ep:array[0..1]of double=(1.827e-2,5.773e-2);  {[]=eB}
       C:array[0..1]of double=(5.5,4.0);  {[]=1}
       A:array[0..2]of double=(3.231e2,7.237e3,1.052e6);  {[]=1/(cm eB^2)}
 var kT,S1ij,S2ij:double;
     EgT:array[0..2]of double;
     i,j:byte;
begin
  Result:=0;
  kT:=Kb*T;
  for I := 0 to High(Eg0) do
       EgT[i]:=TMaterial.VarshniFull(Eg0[i],T);

  for I := 0 to 1 do
    for j := 0 to 1 do
      begin
        S1ij:=(Ephoton-EgT[j]+Ep[i]);
        if S1ij<0 then S1ij:=0;
        S2ij:=(Ephoton-EgT[j]-Ep[i]);
        if S2ij<0 then S2ij:=0;
        Result:=Result+C[i]*A[j]*
                (sqr(S1ij)/(exp(Ep[i]/kT)-1)+
                sqr(S2ij)/(1-exp(-Ep[i]/kT)));
      end;
  if Ephoton>EgT[2] then
    Result:=Result+A[2]*sqrt(Ephoton-EgT[2]);
  Result:=Result*100;
end;



class function Silicon.TAUager_n(n, T: double): double;
begin
 Result:=1/(Cn_Auger(n,T)*n*n);
end;

class function Silicon.TAUager_p(p, T: double): double;
begin
   Result:=1/(Cp_Auger(p,T)*p*p);
end;

class function Silicon.TAUbtb(Ndop, delN, T: double): double;
begin
 Result:=1/(Brad(T)*(Ndop+MinorityN(Ndop,T)+delN))
end;

class function Silicon.TAUceager(Na, delN, T: double): double;
 var n0:double;
begin
 n0:=MinorityN(Na,T)/1e6;
 Result:=delN/((n0+delN/1e6)*(Na+delN)
               *(1.8e-24*Power(n0,0.65)+6e-25*Power(Na/1e6,0.65)+3e-27*Power(delN/1e6,0.8)));
end;

class function Silicon.Vth_n(T: double): double;
begin
 Result:=sqrt(8*Qelem*Kb*T/m0/Pi/0.28);
 {J.Appl.Phys., 67, p2944}
end;

class function Silicon.Vth_p(T: double): double;
begin
 Result:=sqrt(8*Qelem*Kb*T/m0/Pi/0.41);
 {J.Appl.Phys., 67, p2944}
end;

Function ElectronConcentrationSimple(const T:double;
                                     const Parameters:array of double;
                                     const Nd:byte;
                                     const Nt:byte;
                                     const Ef:double;
                                     Material:TMaterial):double;
 var
     i:byte;
begin
  Result:=ErResult;
  if T<=0 then Exit;
  if High(Parameters)<2*(Nd+Nt) then Exit;
  Result:=Material.n_i(T)-Parameters[0];
  i:=2;
  while(i<=2*(Nd+Nt)) do
   begin
   if i<(2*Nd+1)
     then Result:=Result+Parameters[i-1]*(1-TMaterial.FermiDiracDonor(Parameters[i],Ef,T))
     else Result:=Result-Parameters[i-1]*TMaterial.FermiDiracDonor(Parameters[i],Ef,T);
   i:=i+2;
   end;
end;

Function ElectronConcentration(const T:double;
                               const Parameters:array of double;
                               const Nd:byte;
                               const Nt:byte;
                               const Ef0:double=0):double;
{розрахунок концентрації електронів для випадку наявності
декількох донорів та пасток
Parameters[0] - сталий від'ємний доданок до кількості носіїв
(фізично - концентрація акцепторів)
Parameters[1], Parameters[3]... Parameters[2Nd-1] - концентрації донорів і-го типу
Parameters[2], Parameters[4]... Parameters[2Nd] - енергетичні положення
рівнів донорів і-го типу (додатна величина, відраховується від дна зони провідності)
Parameters[2Nd+1], Parameters[2Nd+3]...Parameters[2Nd+2Nt-1] - концентрації
пасток і-го типу
Parameters[2Nd+2], Parameters[2Nd+4]...Parameters[2Nd+2Nt] - енергетичні положення
рівня пасток і-го типу (додатна величина, відраховується від дна зони провідності)
якщо Ef0=0, то положення рівня Фермі розраховується, виходячи
з даних в Parameters (самоузгоджено),
якщо ні - використовується дане в пераметрах функції
}
 var Ef:double;
     tempParameters:array of double;
     i:byte;
begin
  Result:=ErResult;
  if T<=0 then Exit;
  if High(Parameters)<2*(Nd+Nt) then Exit;

  Result:=Diod.FSemiconductor.FMaterial.n_i(T);


  Result:=Result-Parameters[0];

  SetLength(tempParameters,2*(Nd+Nt)+4);
  for I := 0 to 2*(Nd+Nt) do tempParameters[i]:=Parameters[i];
  tempParameters[High(tempParameters)]:=T;
  tempParameters[High(tempParameters)-1]:=Nt;
  tempParameters[High(tempParameters)-2]:=Nd;
  if Ef0=0 then
   Ef:=Bisection(FermiLevelEquation,tempParameters,
                 Diod.FSemiconductor.FMaterial.EgT(T),0,5e-4)
           else
   Ef:=Ef0;

  i:=2;
  while(i<=2*(Nd+Nt)) do
   begin
   if i<(2*Nd+1)
     then Result:=Result+Parameters[i-1]*(1-TMaterial.FermiDiracDonor(Parameters[i],Ef,T))
     else Result:=Result-Parameters[i-1]*TMaterial.FermiDiracDonor(Parameters[i],Ef,T);
   i:=i+2;
   end;

end;


Function FermiLevelEquation(Ef:double;
                            Parameters:array of double):double;
{рівняння для визначення рівня Фермі в електронному напівпровіднику,
цю функцію треба підставити в Bisection для
безпосереднього визначення Ef;
вміст Parameters  - див. попередню функцію,
проте в Parameters[High(Parameters)-2] (тобто в Parameters[2Nd+2Nt+1]) має бути
кількість донорів Nd;
в Parameters[High(Parameters)-1] (тобто в Parameters[2Nd+2Nt+2]) -
кількість пасток Nt;
в Parameters[High(Parameters)] (тобто в Parameters[2Nd+2Nt+3]) - температура}


 var T:double;
     i,Nd,Nt:byte;
begin
 Result:=ErResult;
 try
   Nd:=round(Parameters[High(Parameters)-2]);
   Nt:=round(Parameters[High(Parameters)-1]);
 except
   Exit;
 end;


 if High(Parameters)<>(2*(Nd+Nt)+3) then Exit;
 T:=Parameters[High(Parameters)];
 if T<=0 then Exit;


 Result:=Diod.FSemiconductor.FMaterial.n_i(T)-
         Diod.FSemiconductor.FMaterial.Nc(T)*TMaterial.FDIntegral_05(-Ef/T/Kb);

 Result:=Result-Parameters[0];

  i:=2;
  while(i<(High(Parameters)-2)) do
   begin
   if i<(2*Nd+1)
     then Result:=Result+Parameters[i-1]*(1-TMaterial.FermiDiracDonor(Parameters[i],Ef,T))
     else Result:=Result-Parameters[i-1]*TMaterial.FermiDiracDonor(Parameters[i],Ef,T);
   i:=i+2;
   end;

end;


Function FermiLevelEquationSimple(Ef:double;
                            Parameters:array of double):double;
{рівняння для визначення рівня Фермі в електронному напівпровіднику
по значенням концентрації та температури;
цю функцію треба підставити в Bisection для
безпосереднього визначення Ef;
вміст Parameters[0] - концентрація носіїв;
Parameters[1] - температура}
 var T:double;
begin
 Result:=ErResult;
 if High(Parameters)<>1 then Exit;
 T:=Parameters[High(Parameters)];
 if T<=0 then Exit;
 Result:=abs(Parameters[0])-
         Diod.FSemiconductor.FMaterial.Nc(T)*TMaterial.FDIntegral_05(-Ef/T/Kb);
end;

Function FermiLevelDeterminationSimple(const n:double;const T:double):double;
{обчислюється значення рівня Фермі в електронному напівпровіднику
по значенням концентрації та температури}
begin
  Result:=Bisection(FermiLevelEquationSimple,[n,T],
                 Diod.FSemiconductor.FMaterial.EgT(T),0,5e-4);
end;

Function Pklaas(T, Ndoping: Double; itIsMajority, itIsElectron: Boolean):double;
 var Z,Pbh,Pcw:double;
begin

  Pbh:=1.36e26/(Ndoping+Silicon.MinorityN(Ndoping,T))*sqr(T/300);
  if itIsElectron then
       Pbh:=Pbh*Silicon.Meff_e(T)
                  else
       Pbh:=Pbh*Silicon.Meff_h(T);
  Pbh:=3.83/Pbh;

  if itIsMajority then
   begin
    if itIsElectron then
       Z:=1+1/(0.21+sqr(4e26/Ndoping))
                  else
       Z:=1+1/(0.5+sqr(7.2e26/Ndoping));
    Pcw:=3.97e19*Power(Power(T/300/Z,3)/Ndoping,2/3);
    Pcw:=2.46/Pcw;
   end            else
   Pcw:=0;
   Result:=1/(Pbh+Pcw);
end;

Function Gklaas(P:double;T: Double=300; itIsElectron: Boolean=True):double;
 const s1=0.89233;
       s2=0.41372;
       s3=0.19778;
       s4=0.28227;
       s5=0.005978;
       s6=1.80618;
       s7=0.72169;
 var m:double;
begin
 if itIsElectron then m:=Silicon.Meff_e(T)
                 else m:=Silicon.Meff_h(T);

 Result:=1-s1/Power(s2+Power((T/300/m),s4)*P,s3)
           +s5/Power(Power(m*300/T,s7)*P,s6);
end;

Function Fklaas(P:double; T: Double=300; itIsElectron: Boolean=True):double;
 const r1=0.7643;
       r2=2.2999;
       r3=6.5502;
       r4=2.3670;
       r5=-0.01552;
       r6=0.6478;
 var m12:double;
begin
 if itIsElectron then m12:=Silicon.Meff_e(T)/Silicon.Meff_h(T)
                 else m12:=Silicon.Meff_h(T)/Silicon.Meff_e(T);
 Result:=(r1*Power(P,r6)+r2+r3*m12)
        /(Power(P,r6)+r4+r5*m12);
end;

end.

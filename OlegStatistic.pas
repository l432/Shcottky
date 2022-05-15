unit OlegStatistic;

interface

uses OlegType, OlegMath, OlegVector, OlegVectorManipulation, System.UITypes;

const

WilcoxonPNumber=7;
WilcoxonP: array [0..WilcoxonPNumber] of double=(0.25, 0.10, 0.05, 0.025, 0.01, 0.005, 0.0025, 0.0005);
WilcoxonValues: array [4..100] of array [0..WilcoxonPNumber] of integer=
{4-6}   ((2, 0, -1, -1, -1, -1, -1,-1),(4, 2, 0, -1, -1, -1, -1, -1),(6, 3, 2, 0, -1, -1, -1, -1),
{7-9}    (9, 5, 3, 2, 0, -1, -1, -1),(12, 8, 5, 3, 1, 0, -1, -1),(16, 10, 8, 5, 3, 1, 0, -1),
{10-12}  (20, 14, 10, 8, 5, 3, 1, -1),(24, 17, 13, 10, 7, 5, 3, 0),(29, 21, 17, 13, 9, 7, 5, 1),
{13-15}  (35, 26, 21, 17, 12, 9, 7, 2),(40, 31, 25, 21, 15, 12, 9, 4),(47, 36, 30, 25, 19, 15, 12, 6),
{16-18}  (54, 42, 35, 29, 23, 19, 15, 8),(61, 48, 41, 34, 27, 23, 19, 11),(69, 55, 47, 40, 32, 27, 23, 14),
{19-21}  (77, 62, 53, 46, 37, 32, 27, 18),(86, 69, 60, 52, 43, 37, 32, 21),(95, 77, 67, 58, 49, 42, 37, 25),
{22-24}  (104, 86, 75, 65, 55, 48, 42, 30),(114, 94, 83, 73, 62, 54, 48, 35),(125, 104, 91, 81, 69, 61, 54, 40),
{25-27}  (136, 113, 100, 89, 76, 68, 60, 45),(148, 124, 110, 98, 84, 75, 67, 51),(160, 134, 119, 107, 92, 83, 74, 57),
{28-30}  (172, 145, 130, 116, 101, 91, 82, 64),(185, 157, 140, 126, 110, 100, 90, 71),(198, 169, 151, 137, 120, 109, 98, 78),
{31-33}  (212, 181, 163, 147, 130, 118, 107, 86),(226, 194, 175, 159, 140, 128, 116, 94),(241, 207, 187, 170, 151, 138, 126, 102),
{34-36}  (257, 221, 200, 182, 162, 148, 136, 111),(272, 235, 213, 195, 173, 159, 146, 120),(289, 250, 227, 208, 185, 171, 157, 130),
{37-39}  (305, 265, 241, 221, 198, 182, 168, 140),(323, 281, 256, 235, 211, 194, 180, 150),(340, 297, 271, 249, 224, 207, 192, 161),
{40-42}  (358, 313, 286, 264, 238, 220, 204, 172),(377, 330, 302, 279, 252, 233, 217, 183),(396, 348, 319, 294, 266, 247, 230, 195),
{43-45}  (416, 365, 336, 310, 281, 261, 244, 207),(436, 384, 353, 327, 296, 276, 258, 220),(456, 402, 371, 343, 312, 291, 272, 233),
{46-48}  (477, 422, 389, 361, 328, 307, 287, 246),(499, 441, 407, 378, 345, 322, 302, 260),(521, 462, 426, 396, 362, 339, 318, 274),
{49-51}  (543, 482, 446, 415, 379, 355, 334, 289),(566, 503, 466, 434, 397, 373, 350, 304),(590, 525, 486, 453, 416, 390, 367, 319),
{52-54}  (613, 547, 507, 473, 434, 408, 384, 335),(638, 569, 529, 494, 454, 427, 402, 351),(668, 592, 550, 514, 473, 445, 420, 368),
{55-57}  (688, 615, 573, 536, 493, 465, 438, 385),(714, 639, 595, 557, 514, 484, 457, 402),(740, 664, 618, 579, 535, 504, 477, 420),
{58-60}  (767, 688, 642, 602, 556, 525, 497, 438),(794, 714, 666, 625, 578, 546, 517, 457),(822, 739, 690, 648, 600, 567, 537, 476),
{61-63}  (850, 765, 715, 672, 623, 589, 558, 495),(879, 792, 741, 697, 646, 611, 580, 515),(908, 819, 767, 721, 669, 634, 602, 535),
{64-66}  (938, 847, 793, 747, 693, 657, 624, 556),(968, 875, 820, 772, 718, 681, 647, 577),(998, 903, 847, 798, 742, 705, 670, 599),
{67-69}  (1029, 932, 875, 825, 768, 729, 694, 621),(1061, 962, 903, 852, 793, 754, 718, 643),(1093, 992, 931, 879, 819, 779, 742, 666),
{70-72}  (1126, 1022, 960, 907, 846, 805, 767, 689),(1159, 1053, 990, 936, 873, 831, 792, 712),(1192, 1084, 1020, 964, 901, 858, 818, 736),
{73-75}  (1226, 1116, 1050, 994, 928, 884, 844, 761),(1261, 1148, 1081, 1023, 957, 912, 871, 786),(1296, 1181, 1112, 1053, 986, 940, 898, 811),
{76-78}  (1331, 1214, 1144, 1084, 1015, 968, 925, 836),(1367, 1247, 1176, 1115, 1044, 997, 953, 862),(1403, 1282, 1209, 1147, 1075, 1026, 981, 889),
{79-81}  (1440, 1316, 1242, 1179, 1105, 1056, 1010, 916),(1478, 1351, 1276, 1211, 1136, 1086, 1039, 943),(1516, 1387, 1310, 1244, 1168, 1116, 1069, 971),
{82-84}  (1554, 1423, 1345, 1277, 1200, 1147, 1099, 999),(1593, 1459, 1380, 1311, 1232, 1178, 1129, 1028),(1632, 1496, 1415, 1345, 1265, 1210, 1160, 1057),
{85-87}  (1672, 1533, 1451, 1380, 1298, 1242, 1191, 1086),(1712, 1571, 1487, 1415, 1332, 1275, 1223, 1116),(1753, 1609, 1524, 1451, 1366, 1308, 1255, 1146),
{88-90}  (1794, 1648, 1561, 1487, 1400, 1342, 1288, 1177),(1836, 1688, 1599, 1523, 1435, 1376, 1321, 1208),(1878, 1727, 1638, 1560, 1471, 1410, 1355, 1240),
{91-93}  (1921, 1767, 1676, 1597, 1507, 1445, 1389, 1271),(1964, 1808, 1715, 1635, 1543, 1480, 1423, 1304),(2008, 1849, 1755, 1674, 1580, 1516, 1458, 1337),
{94-96}  (2052, 1891, 1795, 1712, 1617, 1552, 1493, 1370),(2097, 1933, 1836, 1752, 1655, 1589, 1529, 1404),(2142, 1976, 1877, 1791, 1693, 1626, 1565, 1438),
{97-99}  (2187, 2019, 1918, 1832, 1731, 1664, 1601, 1472),(2233, 2062, 1960, 1872, 1770, 1702, 1638, 1507),(2280, 2106, 2003, 1913, 1810, 1740, 1676, 1543),
{100}    (2327, 2151, 2045, 1955, 1850, 1779, 1714, 1578)
 );


MultipleSignPNumber=1;
MultipleSignP: array [0..MultipleSignPNumber] of double=(0.10, 0.05);
MultipleSignNNumber=25;
MultipleSignN: array [0..MultipleSignNNumber] of double=(5,6,7,8,9,10,11,12,13,14,15,16,
                                                         17,18,19,20,21,22,23,24,25,30,
                                                         35,40,45,50);
MultipleSignValues: array [0..MultipleSignNNumber] of array [2..9] of array [0..MultipleSignPNumber] of integer=
({m=(k-1) 2      3       4      5       6       7       8       9
{5}   ((0,-1), (0,-1),(-1,-1),(-1,-1),(-1,-1),(-1,-1),(-1,-1),(-1,-1)),
{6}   ((0,0),  (0,0), (0,-1), (0,-1), (0,-1), (-1,-1),(-1,-1),(-1,-1)),
{7}   ((0,0),  (0,0), (0,0),  (0,0),  (0,-1), (0,-1), (0,-1), (0,-1)),
{8}   ((1,0),  (1,0), (0,0),  (0,0),  (0,0),  (0,0),  (0,0),  (0,0)),
{9}   ((1,1),  (1,0), (1,0),  (1,0),  (0,0),  (0,0),  (0,0),  (0,0)),
{10}  ((1,1),  (1,1), (1,1),  (1,0),  (1,0),  (1,0),  (1,0),  (1,0)),
{11}  ((2,1),  (2,1), (1,1),  (1,1),  (1,1),  (1,1),  (1,0),  (1,0)),
{12}  ((2,2),  (2,1), (2,1),  (2,1),  (1,1),  (1,1),  (1,1),  (1,1)),
{13}  ((3,2),  (2,2), (2,2),  (2,1),  (2,1),  (2,1),  (2,1),  (2,1)),
{14}  ((3,2),  (3,2), (2,2),  (2,2),  (2,2),  (2,2),  (2,1),  (2,1)),
{15}  ((3,3),  (3,2), (3,2),  (3,2),  (3,2),  (2,2),  (2,2),  (2,2)),
{16}  ((4,3),  (3,3), (3,3),  (3,3),  (3,2),  (3,2),  (3,2),  (3,2)),
{17}  ((4,4),  (4,3), (4,3),  (3,3),  (3,3),  (3,3),  (3,2),  (3,2)),
{18}  ((5,4),  (4,4), (4,3),  (4,3),  (4,3),  (4,3),  (3,3),  (3,3)),
{19}  ((5,4),  (5,4), (4,4),  (4,4),  (4,3),  (4,3),  (4,3),  (4,3)),
{20}  ((5,5),  (5,4), (5,4),  (5,4),  (4,4),  (4,4),  (4,3),  (4,3)),
{21}  ((6,5),  (5,5), (5,5),  (5,4),  (5,4),  (5,4),  (5,4),  (5,4)),
{22}  ((6,6),  (6,5), (6,5),  (5,5),  (5,4),  (5,4),  (5,4),  (5,4)),
{23}  ((7,6),  (6,6), (6,5),  (6,5),  (6,5),  (5,5),  (5,5),  (5,5)),
{24}  ((7,6),  (7,6), (6,6),  (6,5),  (6,5),  (6,5),  (6,5),  (6,5)),
{25}  ((7,7),  (7,6), (7,6),  (7,6),  (6,6),  (6,6),  (6,5),  (6,5)),
{30}  ((10,9), (9,8), (9,8),  (9,8),  (8,8),  (8,8),  (8,7),  (8,7)),
{35}  ((12,11),(11,10),(11,10),(11,10),(10,10),(10,9),(10,9),(10,9)),
{40}  ((14,13),(13,12),(13,12),(13,12),(13,12),(12,11),(12,11),(12,11)),
{45}  ((16,15),(16,14),(15,14),(15,14),(15,14),(14,13),(14,13),(14,13)),
{50}  ((18,17),(18,17),(17,16),(17,16),(17,16),(17,16),(16,15),(16,15))
 );




type

TMetaMethod=(mmPSO, mmIPOPES, mmCHC, mmSSGA, mmSSBLX, mmSSArit, mmDEBin, mmDEExp, mmSaDE);
TMethods=(mmA,mmB,mmC,mmD);

{Alpha - рівень значущості (level of significance)
p-value - ймовірність отримання такого як є результату за умови,
що гіпотеза H0 (про те, що різниці нема) справедлива}


TDistribution=class
 public
  class function CDF(x:double):double;virtual;abstract;
  {функція розподілу ймовірності:
ймовірність того, що величина має значення не більше-рівно x
CDF - cumulative distribution function}
  class function PDF(x:double):double;virtual;abstract;
{густина розподілу ймовірності;
PDF -  probability density function}
end;

TNormalD=class(TDistribution)
{нормальний розподіл}
 private
  fMu:double; // середнє
  fSigma:double; //  fSigma^2 - дисперсія
  procedure SetSigma(Value:double);
 public
  property Mean:double read fMu write fMu;
  property Sigma:double read fSigma write SetSigma;
  constructor Create(mu:double=0;sigm:double=1);
end;


Function NormalCDF(x:double;mu:double=0;sigma:double=1):double;
{функція розподілу ймовірності для нормального розподілу,
ймовірність того, що величина має значення не більше-рівно x
mu - середнє,
sigma^2 - дисперсія;
FCD - cumulative distribution function}

Function NormalCDF_AB(a,b:double;mu:double=0;sigma:double=1):double;
{ймовірність того, що величина має значення a<x<=b при
нормальному розподілу з середнім mu та дисперсією sigma^2}

Function NormalPlim(z:double;mu:double=0;sigma:double=1):double;
{ймовірність, що відхилення від середнього не менші |z-mu|,
при z>=mu Result=2*(1-NormalCDF(z,mu,sigma))
при z<mu Result=2*NormalCDF((z,mu,sigma)
}

Function NormalPDF(x:double;mu:double=0;sigma:double=1):double;
{густина розподілу ймовірності при нормальному розподілі
(функція Гауса)
mu - середнє,
sigma^2 - дисперсія;
PDF -  probability density function}


Function ChiSquaredPDF(x:double;k:word):double;
{густина розподілу ймовірності при хі-квадрат розподілі
x>=0,
k - кількість ступенів вільності}

Function ChiSquaredCDF(x:double;k:word):double;
{функція розподілу ймовірності при хі-квадрат розподілі,
ймовірність того, що величина має значення не більше-рівно x,
x>=0,
k - кількість ступенів вільності, для k=1 рахувало препаршиво,
тому поставив обмеження, що k>1}


Function FisherPDF(x:double;k1,k2:word):double;
{густина розподілу ймовірності при F-розподілі (розподілі Фішера),
x>=0,
k1, k2 - кількість ступенів вільності}

Function FisherCDF(x:double;k1,k2:word):double;
{функція розподілу ймовірності при F-розподілі,
ймовірність того, що величина має значення не більше-рівно x,
x>=0,
k1, k2 - кількість ступенів вільності,
про всяк випадок поставив обмеження k1>1, k2>1}

Function NchooseK(n,k:word):Int64;
{Біноміальний коефіцієнт,
кількість виборок по k з n,
n!/k!(n-k)!}

Function BinomialProbKN(n,k:word;p:double):double;
{ймовірність успіху при k випробуваннях з n спроб,
якщо успіх при одному випробуванні р,
0<=p<=1}

Function BinomialPDF(n,k:word;p:double):double;
{густина розподілу ймовірності при біноміальному розподілі,
k - кількість вдалих випробувань,
n - загальна кількість випробувань, n>=k;
p - ймовірність успіху при одному випровуванні,0<p<1
}

Function BinomialCDF(n,k:word;p:double):double;
{функція розподілу ймовірності при біноміальному розподілі,
ймовірність того, що вдалих випробувань не більше k}

Function WinsNumber(A,B:TVector;ItIsError:boolean=True):word;
{кількість перемог в A.Y порівняно з B.Y,
при ItIsError=True перемога означає менше значення;
має бути A.X[i]=B.X[i], A.Count=B.Count,
інакше перемог 0}

Function SignTestPvalue(A,B:TVector;ItIsError:boolean=True):double;

Function SignTestAbetterB(A,B:TVector;p:double=0.05;ItIsError:boolean=True):boolean;
{результат парного тесту про те, що А краще при щонайбільшому p-value,
0<p<1}

Function WilcoxonNmin(n:word;p:double):integer;
{критичне значення для розподілу Wilcoxon при
n задачах і р-value відповідно до
таблиці, якщо для даних n та р значення
відсутнє повертається -1}

Function WilcoxonT(A,B:TVector;ItIsError:boolean=True):double;
{min(R+,R-) для критерію Wilcoxon;
 знак результату визначає кого більше:
 Result>0 якщо R+ > R-}

Procedure MinMaxValues(Arr:array of TVector; Target:TVector);
{Target.X[i]=min(Arr[].Y[i]),Target.Y[i]=max(Arr[].Y[i]),
кількість точок в Target визначається найменшим розміром Arr}

Function WilcoxonTestAbetterB(A,B:TVector;p:double=0.05;ItIsError:boolean=True):boolean;overload;
{результат парного тесту про те, що А краще при щонайбільшому p-value,
0<p<1}

Function WilcoxonTestAbetterB(A,B:TVectorTransform;MinMax:Tvector;p:double=0.05;ItIsError:boolean=True):boolean;overload;
{на відміну від попереднього, ще й нормалізує дані в А та В відповідно до MinMax}

Function MultipleSignNmin(m,n:word;p:double=0.05):integer;
{критичне значення для Multiple Sign Test при
(m+1) алгоритмах (всього, порівняння відбувається якогось з рештою m),
n задачах і р-value відповідно до
таблиці, якщо для даних m, n та р значення
відсутнє повертається -1}

Procedure MultipleSignTest(ControlAlgorithm:TVector;OtherAlgorithms:array of TVector;
                           Results:TVector;p:double=0.05;ItIsError:boolean=True);
{перевірка гіпотез щодо співвідношення медіанних відгуків
контрольного алгоритму з іншими;
Results.Count=High(OtherAlgorithms)+1 - кількість алгоритмів для порівняння,
Results.X[i] = номер алгоритму в OtherAlgorithms,
Results.Y[i] = 1 якщо можна відкинути гіпотезу про те,
що медіанний відгук  OtherAlgorithms[i] кращий, ніж у ControlAlgorithm;
(лишається гіпотеза, що ControlAlgorithm кращий);
              -1 якщо можна відкинути гіпотезу про те,
що медіанний відгук  ControlAlgorithm кращий, ніж у OtherAlgorithms[i];
             =0 якщо відкинути гіпотези не вдалося;
розміри  ControlAlgorithm та OtherAlgorithms мають бути однаковими,
інакше в  Results.Y одні нулі
}

Function ExtremCountVectorArray(Arr:array of TVector;ItIsMin:boolean=true):byte;
{мінімальний чи максимальний розмір весторів з Arr}

Function DimensionsNotDetermined(Arr:array of TVector;var ProblemNumbers:integer;
                                                      var AlgorithmNumbers:integer):boolean;
{має бути, що Arr - масив результатів роботи AlgorithmNumbers=High(Arr)+1 алгоритмів
на ProblemNumbers=Arr[AlgorithmNumber].Count проблемах, самі результати
мають бути в Arr[AlgorithmNumber].Y[ProblemNumber]
розмір всіх векторів має бути однаковим;
фактично, визначаються кількості алгоритмів та задач і перевіряються обмеження:
- розмір всіх векторів має бути однаковим;
- кількості алгоритмів чи проблем не менше 2}


type

TOneToNTest=class
 private
 fAlgorithmResult:array of TVector;
 fAlgorithAmount:byte;
 fProblemAmount:byte;
 fError:boolean;
 fItIsError:boolean;
 function RijFooter(ProblemNumber,AlgorithmNumber:byte):double;virtual;abstract;
 function StatisticFooter():double;virtual;abstract;
 function ZvalueFooter(ControlAlgorithm,СomparisonAlgorithm:byte):double;virtual;abstract;
 public
 constructor Create(Arr:array of TVector;ItIsError:boolean=True);
{Arr - масив результатів роботи k=High(Arr)+1 алгоритмів
на n=Arr[AlgorithmNumber].Count проблемах, самі результати
мають бути в Arr[AlgorithmNumber].Y[ProblemNumber]
розмір всіх векторів має бути однаковим;}
 destructor Destroy; override;
 function Zvalue(ControlAlgorithm,СomparisonAlgorithm:byte):double;
 {z-value на масиві fAlgorithmResult для визначення чи кращий алгоритм
з номером ControlAlgorithm порівняно з СomparisonAlgorithm-м алгоритмом}
 function UnadjustedP(ControlAlgorithm,СomparisonAlgorithm:byte):double;
{ймовірність того, що ControlAlgorithm випадковим чином кращий
для даного набору даних ніж СomparisonAlgorithm;
якщо щось погано - повертається 1,
тобто ніяких підстав стверджувати, що алгоритм кращий}
 function Rij(ProblemNumber,AlgorithmNumber:byte):double;
 {повертає ранг AlgorithmNumber-го алгоритму по вирішенню ProblemNumber-ої задачі,
 якщо щось піде не так - Result=-1}
 function Rj(AlgorithmNumber:byte):double;
{аргумент - див попередню функцію;
повертає усереднений ранг  AlgorithmNumber-го алгоритму;
якщо щось піде не так - Result=-1}
 function Statistic():double;
end;

TFriedman=class(TOneToNTest)
 private
  function RijFooter(ProblemNumber,AlgorithmNumber:byte):double;override;
  function StatisticFooter():double;override;
  function ZvalueFooter(ControlAlgorithm,СomparisonAlgorithm:byte):double;override;
 public
end;

TImanDavenport=class(TFriedman)
 private
  function StatisticFooter():double;override;
 public
end;

TFriedmanAligned=class(TOneToNTest)
 private
  function RijFooter(ProblemNumber,AlgorithmNumber:byte):double;override;
  function StatisticFooter():double;override;
  function ZvalueFooter(ControlAlgorithm,СomparisonAlgorithm:byte):double;override;
 public
  function RjTotal(AlgorithmNumber:byte):double;
{сумарний ранг для AlgorithmNumber-го алгоритму;
якщо щось піде не так - Result=-1}
  function RiTotal(ProblemNumber:byte):double;
{сумарний ранг для ProblemNumber-ої проблеми;
якщо щось піде не так - Result=-1}
end;


implementation

uses
  System.Math, Vcl.Dialogs, System.SysUtils;

Function NormalCDF(x,mu,sigma:double):double;
begin
  try
   Result:=0.5*(1+Erf((x-mu)/sqrt(2)/sigma))
  except
   Result:=ErResult;
  end;
end;

Function NormalCDF_AB(a,b:double;mu:double=0;sigma:double=1):double;
begin
  if sigma=0 then
   begin
     Result:=ErResult;
     Exit
   end;
  Result:=NormalCDF(b,mu,sigma)-NormalCDF(a,mu,sigma);
end;

Function NormalPlim(z:double;mu:double=0;sigma:double=1):double;
begin
  if z>=mu then Result:=2*(1-NormalCDF(z,mu,sigma))
           else Result:=2*NormalCDF(z,mu,sigma)
end;

Function NormalPDF(x:double;mu:double=0;sigma:double=1):double;
begin
  try
   Result:=1/sigma/sqrt(2*Pi)*exp(-sqr((x-mu)/sigma)/2);
  except
   Result:=ErResult;
  end;
end;

Function ChiSquaredPDF(x:double;k:word):double;
 var G,k2:double;
begin
 if (k<1)or(x<0)or((k=1)and(x<=0)) then
   begin
     Result:=ErResult;
     Exit
   end;
 k2:=k/2.0;
 if odd(k) then G:=Gamma(k2)
           else G:=Gamma(round(k2));
 Result:=Power(x,k2-1)*exp(-x/2.0)
         /Power(2,k2)/G;
end;

Function ChiSquaredCDF(x:double;k:word):double;
  var G,k2:double;
begin
 if (k<2)or(x<0) then
   begin
     Result:=ErResult;
     Exit
   end;
 k2:=k/2.0;
 if odd(k) then G:=Gamma(k2)
           else G:=Gamma(round(k2));
 Result:=GammaLowerIncomplete(k2,x/2.0)/G;
end;

Function FisherPDF(x:double;k1,k2:word):double;
begin
 if (x<0)or(x>1) then
   begin
     Result:=ErResult;
     Exit
   end;
 Result:=Power(k1/k2,k1/2.0)*Power(x,k1/2.0-1)
         *Power((1+k1/k2*x),-(k1+k2)/2.0)/Betta(k1/2.0,k2/2.0);
end;

Function FisherCDF(x:double;k1,k2:word):double;
begin
 if (x<0)or(x>1) then
   begin
     Result:=ErResult;
     Exit
   end;
 Result:=BettaRegularizedIncomplete(k1*x/(k1*x+k2),k1/2.0,k2/2.0);
end;

Function NchooseK(n,k:word):Int64;
begin
  if k>n then
    begin
      Result:=0;
      Exit;
    end;
  Result:=Round(Factorial(n)/Factorial(k)/Factorial(n-k));
end;

Function BinomialProbKN(n,k:word;p:double):double;
begin
  if (p<0)or(p>1)or(k>n) then
   begin
     Result:=0;
     Exit;
   end;
  Result:=Power(p,k)*Power((1-p),(n-k));
end;

Function BinomialPDF(n,k:word;p:double):double;
begin
  if (p<0)or(p>1)or(k>n) then
   begin
     Result:=ErResult;
     Exit;
   end;
  Result:=NchooseK(n,k)*BinomialProbKN(n,k,p);
end;

Function BinomialCDF(n,k:word;p:double):double;
 var i:word;
begin
 if (p<0)or(p>1)or(k>n) then
   begin
     Result:=ErResult;
     Exit;
   end;
 Result:=0;
 for I := 0 to k do
   Result:=Result+BinomialPDF(n,i,p);
end;

Function WinsNumber(A,B:TVector;ItIsError:boolean=True):word;
 var WinsTemp:double;
     i:integer;
begin
  Result:=0;
  if A.Count<>B.Count  then Exit;
  WinsTemp:=0;
  for I := 0 to A.HighNumber do
   if IsEqual(A.X[i],B.X[i]) then
    begin
      if IsEqual(A.Y[i],B.Y[i]) then
                   begin
                    WinsTemp:=WinsTemp+0.5;
                    Continue;
                   end;
      if ItIsError and (A.Y[i]<B.Y[i]) then WinsTemp:=WinsTemp+1;
      if not(ItIsError) and (A.Y[i]>B.Y[i]) then WinsTemp:=WinsTemp+1;
//      showmessage(floattostr(A.Y[i])+' '+floattostr(B.Y[i])+' '+floattostr(WinsTemp));
    end                      else Exit;
   Result:=Floor(WinsTemp);
end;

Function SignTestPvalue(A,B:TVector;ItIsError:boolean):double;
 var Wins:word;
begin
  Wins:=WinsNumber(A,B,ItIsError);
  if Wins>A.Count/2.0 then Result:=2*(1-NormalCDF(Wins,A.Count/2.0,sqrt(A.Count)/2.0))
                      else Result:=1;
end;

Function SignTestAbetterB(A,B:TVector;p:double=0.05;ItIsError:boolean=True):boolean;
begin
  if (p<=0) or (p>=1) then
     begin
       Result:=False;
       Exit;
     end;
  Result:= (SignTestPvalue(A,B,ItIsError)<p);
end;

Function WilcoxonNmin(n:word;p:double):integer;
 var p_number,i:integer;
begin
 Result:=-1;
 if (n<Low(WilcoxonValues))or(n>High(WilcoxonValues))
    then Exit;
 p_number:=-1;
 for I := 0 to WilcoxonPNumber do
   if IsEqual(p,WilcoxonP[i]) then
           begin
             p_number:=i;
             Break;
           end;
 if p_number<0 then Exit;
 Result:=WilcoxonValues[n,p_number];
end;

Function WilcoxonT(A,B:TVector;ItIsError:boolean=True):double;
{min(R+,R-) для критерію Wilcoxon}
 var d:TVectorTransform;
     i:integer;
     Rplus,Rminus:double;
begin
  Result:=-1;
  if (A.Count<>B.Count)  then Exit;

  d:=TVectorTransform.Create(B);
  d.DeltaY(A);
  d.Itself(d.Rank);

  Rplus:=0;
  Rminus:=0;
  for I := 0 to d.HighNumber do
   begin
     if IsEqual(d.X[i],0) then
      begin
        Rplus:=Rplus+0.5*d.Y[i];
        Rminus:=Rminus+0.5*d.Y[i];
        Continue;
      end;
     if d.X[i]>0 then Rplus:=Rplus+d.Y[i]
                  else Rminus:=Rminus+d.Y[i];
   end;

//  showmessage('R+='+floattostr(Rplus)+' R-='+floattostr(Rminus)+' Sum='+floattostr(Rminus+Rplus));
  Result:=min(Rplus,Rminus);
  if Rminus>Rplus then Result:=-Result;


  FreeAndNil(d);
end;

Procedure MinMaxValues(Arr:array of TVector; Target:TVector);
 var temp:TVector;
     i,j:integer;
begin
  Target.Clear;
  temp:=TVector.Create;
  for I := 0 to ExtremCountVectorArray(Arr)-1 do
    begin
     for j := 0 to High(Arr) do temp.Add(j,Arr[j].Y[i]);
     Target.Add(temp.MinY,temp.MaxY);
     temp.Clear;
    end;
  FreeAndNil(temp);
end;

Function WilcoxonTestAbetterB(A,B:TVector;p:double=0.05;ItIsError:boolean=True):boolean;
 var mu,sigma,T:double;
     n,W:integer;
begin
  Result:=False;
  if (p<=0) or (p>=1) then Exit;
  if A.Count<>B.Count then Exit;
  n:=A.Count;
  T:=WilcoxonT(A,B,ItIsError);
  W:=WilcoxonNmin(n,p);
  if W>=0 then Result:=abs(T)<=W
          else
           begin
            mu:=n*(n+1)/4;
            sigma:=sqrt(n*(n+1)*(2*n+1)/24);
            Result:=p>=(1-NormalCDF((abs(abs(T)-mu)-0.5)/sigma));
           end;
  if ItIsError then  Result:= Result and (T>0)
               else  Result:= Result and (T<0);
end;

Function WilcoxonTestAbetterB(A,B:TVectorTransform;MinMax:Tvector;p:double=0.05;ItIsError:boolean=True):boolean;
 var Anew,Bnew:TVector;
 begin
  Anew:=TVector.Create;
  Bnew:=TVector.Create;
  A.MinMax(Anew,MinMax);
  B.MinMax(Bnew,MinMax);
  Result:=WilcoxonTestAbetterB(Anew,Bnew,p,ItIsError);
  FreeAndNil(Anew);
  FreeAndNil(Bnew);
 end;

Function MultipleSignNmin(m,n:word;p:double):integer;
 var p_number,n_number,i:integer;
begin
 Result:=-1;
 if (m<Low(MultipleSignValues[0]))
    or (m>High(MultipleSignValues[0])) then Exit;
 p_number:=-1;
 for I := 0 to MultipleSignPNumber do
   if IsEqual(p,MultipleSignP[i]) then
           begin
             p_number:=i;
             Break;
           end;
 if p_number<0 then Exit;
 n_number:=-1;
 for I := 0 to MultipleSignNNumber do
   if n=MultipleSignN[i] then
           begin
             n_number:=i;
             Break;
           end;
 if n_number<0 then Exit;

 Result:=MultipleSignValues[n_number,m,p_number];
end;

Procedure MultipleSignTest(ControlAlgorithm:TVector;OtherAlgorithms:array of TVector;
                           Results:TVector;p:double=0.05;ItIsError:boolean=True);
 var i:integer;
     d:TVector;
begin
 Results.Clear;
 if High(OtherAlgorithms)<0 then Exit;
 for I := 0 to High(OtherAlgorithms) do
    Results.Add(i,0);
 if ExtremCountVectorArray(OtherAlgorithms,True)<> ExtremCountVectorArray(OtherAlgorithms,False)
    then Exit;
 if ExtremCountVectorArray(OtherAlgorithms)<> ControlAlgorithm.Count
    then Exit;
 d:=TVector.Create;

// showmessage(inttostr(MultipleSignNmin(High(OtherAlgorithms)+1,ControlAlgorithm.Count,p)));
 for I := 0 to High(OtherAlgorithms) do
   begin
    if ItIsError then
           begin
            OtherAlgorithms[i].CopyTo(d);
            d.DeltaY(ControlAlgorithm);
           end   else
           begin
            ControlAlgorithm.CopyTo(d);
            d.DeltaY(OtherAlgorithms[i]);
           end;
//     showmessage(inttostr(i)+' '+d.XYtoString+' r-='+inttostr(d.NegativeInY)+' r+='+inttostr(d.PositiveInY));
     if d.NegativeInY<=MultipleSignNmin(High(OtherAlgorithms)+1,d.Count,p)
         then Results.Y[i]:=1;
     if d.PositiveInY<=MultipleSignNmin(High(OtherAlgorithms)+1,d.Count,p)
         then Results.Y[i]:=-1;
   end;
 FreeAndNil(d);
end;

Function ExtremCountVectorArray(Arr:array of TVector;ItIsMin:boolean=true):byte;
 var temp:TVector;
     i:integer;
begin
  temp:=TVector.Create;
  for I := 0 to High(Arr) do
    temp.Add(i,Arr[i].Count);
  if ItIsMin then Result:=round(temp.MinY)
             else Result:=round(temp.MaxY);
   FreeAndNil(temp);
end;


Function DimensionsNotDetermined(Arr:array of TVector;var ProblemNumbers:integer;
                                                      var AlgorithmNumbers:integer):boolean;
begin
 Result:=True;
 AlgorithmNumbers:=High(Arr)+1;
 ProblemNumbers:=ExtremCountVectorArray(Arr);
 if (AlgorithmNumbers<2)or(ProblemNumbers<2) then Exit;
 if ProblemNumbers<> ExtremCountVectorArray(Arr,False) then Exit;
 Result:=False;
end;


{ TOneToNTest }

constructor TOneToNTest.Create(Arr: array of TVector; ItIsError: boolean);
 var i:integer;
begin
 inherited Create;
 fItIsError:=ItIsError;
 fError:=False;
 fAlgorithAmount:=High(Arr)+1;
 fProblemAmount:=ExtremCountVectorArray(Arr);
 if (fAlgorithAmount<2)or(fProblemAmount<2) then fError:=True;
 if fProblemAmount<> ExtremCountVectorArray(Arr,False) then fError:=True;
 if fError then
    begin
      MessageDlg('Bad data',mtError, [mbOK], 0);
      Exit;
    end;
  SetLength(fAlgorithmResult,High(Arr)+1);
  for I := 0 to High(fAlgorithmResult) do
    fAlgorithmResult[i]:=TVector.Create(Arr[i]);
end;

destructor TOneToNTest.Destroy;
 var i:integer;
begin
 for I := 0 to High(fAlgorithmResult) do FreeAndNil(fAlgorithmResult[i]);
 inherited;
end;

function TOneToNTest.Rij(ProblemNumber, AlgorithmNumber: byte): double;
begin
 Result:=-1;
 if fError then Exit;
 if (ProblemNumber<1)or(ProblemNumber>fProblemAmount)
     or(AlgorithmNumber<1)or(AlgorithmNumber>fAlgorithAmount) then Exit;
 Result:=RijFooter(ProblemNumber, AlgorithmNumber);
end;

function TOneToNTest.Rj(AlgorithmNumber: byte): double;
 var temp:TVector;
     i:integer;
begin
 Result:=-1;
 if fError then Exit;
 if AlgorithmNumber>fAlgorithAmount then Exit;
 temp:=TVector.Create;
 for I := 0 to fProblemAmount-1 do
   begin
     temp.Add(i,Self.Rij(i+1,AlgorithmNumber));
     if temp.Y[i]<0 then
       begin
        FreeAndNil(temp);
        Exit;
       end;
   end;
 Result:=temp.MeanY;
 FreeAndNil(temp);
end;

function TOneToNTest.Statistic: double;
begin
  Result:=-1;
  if fError then Exit;
  Result:=StatisticFooter();
end;

function TOneToNTest.UnadjustedP(ControlAlgorithm,
  СomparisonAlgorithm: byte): double;
 var z:double;
begin
  Result:=1;
  try
  z:=Zvalue(ControlAlgorithm,СomparisonAlgorithm);
  if z<0 then Exit;
  result:=2*(1-NormalCDF(z));
  except
  end;
end;

function TOneToNTest.Zvalue(ControlAlgorithm,
  СomparisonAlgorithm: byte): double;
begin
  Result:=-1;
  if fError then Exit;
  if (ControlAlgorithm<1)or(ControlAlgorithm>fAlgorithAmount)
     or(СomparisonAlgorithm<1)or(СomparisonAlgorithm>fAlgorithAmount) then Exit;
  Result:=ZValueFooter(ControlAlgorithm,  СomparisonAlgorithm);
end;

{ TFriedman }

function TFriedman.RijFooter(ProblemNumber, AlgorithmNumber: byte): double;
 var i:integer;
     temp1,temp2:TVectorTransform;
begin
 temp1:=TVectorTransform.Create;
 temp2:=TVectorTransform.Create;
 for i := 1 to fAlgorithAmount do
   temp1.Add(i,fAlgorithmResult[i-1].Y[ProblemNumber-1]);
 temp1.Rank(temp2,True,True,fItIsError);
 Result:=temp2.Y[AlgorithmNumber-1];
 FreeAndNil(temp2);
 FreeAndNil(temp1);
end;

function TFriedman.StatisticFooter: double;
 var j:integer;
begin
  Result:=0;
  for j := 1 to fAlgorithAmount do Result:=Result+sqr(Self.Rj(j));
  Result:=(Result-fAlgorithAmount*sqr(fAlgorithAmount+1)/4)
      *12*fProblemAmount/fAlgorithAmount/(fAlgorithAmount+1);
end;

function TFriedman.ZvalueFooter(ControlAlgorithm, СomparisonAlgorithm: byte): double;
 var Ri,Rj:double;
begin
  Result:=-1;
  Ri:=Self.Rj(ControlAlgorithm);
//  Ri:=1.96;
  if Ri<0 then Exit;
  Rj:=Self.Rj(СomparisonAlgorithm);
//  Rj:=2.48;
  if Rj<0 then Exit;
  Result:=(Rj-Ri)/sqrt(fAlgorithAmount*(fAlgorithAmount+1)/6.0/fProblemAmount);
end;

{ TImanDavenport }

function TImanDavenport.StatisticFooter: double;
 var ksi_F:double;
begin
//  Result:=-1;
  ksi_F:=inherited StatisticFooter();
  try
  Result:=(fProblemAmount-1)*ksi_F/(fProblemAmount*(fAlgorithAmount-1)-ksi_F);
  except
   Result:=-1;
  end;

end;

{ TFriedmanAligned }

function TFriedmanAligned.RijFooter(ProblemNumber,
  AlgorithmNumber: byte): double;
 var i,j:integer;
     temp1,temp2:TVectorTransform;
     MeanForProblem:TVector;
begin
 temp1:=TVectorTransform.Create;
 temp2:=TVectorTransform.Create;
 MeanForProblem:=TVector.Create;
 for I := 1 to fProblemAmount do
   begin
     temp1.Clear;
     for j := 1 to fAlgorithAmount do
       Temp1.Add(j,fAlgorithmResult[j-1].Y[i-1]);
     MeanForProblem.Add(i,temp1.MeanY);
   end;
 temp1.Clear;
 for I := 1 to fProblemAmount do
  for j := 1 to fAlgorithAmount do
     Temp1.Add(i,fAlgorithmResult[j-1].Y[i-1]-MeanForProblem.Y[i-1]);

 temp1.Rank(temp2,True,False,fItIsError);
 result:=temp2.Y[(ProblemNumber-1)*fAlgorithAmount+(AlgorithmNumber-1)];

 FreeAndNil(MeanForProblem);
 FreeAndNil(temp2);
 FreeAndNil(temp1);
end;

function TFriedmanAligned.RiTotal(ProblemNumber: byte): double;
 var temp:TVector;
     i:integer;
begin
 Result:=-1;
 if fError then Exit;
 if ProblemNumber > fProblemAmount then Exit;
 temp:=TVector.Create;
 for I := 0 to fAlgorithAmount-1 do
   begin
     temp.Add(i,Self.Rij(ProblemNumber,i+1));
     if temp.Y[i]<0 then
       begin
        FreeAndNil(temp);
        Exit;
       end;
   end;
 Result:=temp.SumY;
 FreeAndNil(temp);
end;

function TFriedmanAligned.RjTotal(AlgorithmNumber: byte): double;
 var temp:TVector;
     i:integer;
begin
 Result:=-1;
 if fError then Exit;
 if AlgorithmNumber>fAlgorithAmount then Exit;
 temp:=TVector.Create;
 for I := 0 to fProblemAmount-1 do
   begin
     temp.Add(i,Self.Rij(i+1,AlgorithmNumber));
     if temp.Y[i]<0 then
       begin
        FreeAndNil(temp);
        Exit;
       end;
   end;
 Result:=temp.SumY;
 FreeAndNil(temp);
end;

function TFriedmanAligned.StatisticFooter: double;
 var j:integer;
     Rj_sum,Ri_sum:double;
begin
  Rj_sum:=0;
  for j := 1 to fAlgorithAmount do Rj_sum:=Rj_sum+sqr(RjTotal(j));
  Ri_sum:=0;
  for j := 1 to fProblemAmount do Ri_sum:=Ri_sum+sqr(RiTotal(j));
  try
   Result:=(fAlgorithAmount-1)*(Rj_sum-fAlgorithAmount
              *sqr(fProblemAmount*(fAlgorithAmount*fProblemAmount+1))/4)
            /(((fAlgorithAmount*fProblemAmount*(fAlgorithAmount*fProblemAmount+1)
            *(2*fAlgorithAmount*fProblemAmount+1))/6.0)-Ri_sum/fAlgorithAmount);
  except
   Result:=-1;
  end;

end;

function TFriedmanAligned.ZvalueFooter(ControlAlgorithm,
  СomparisonAlgorithm: byte): double;
 var Ri,Rj:double;
begin
  Result:=-1;
  Ri:=Self.Rj(ControlAlgorithm);
//  Ri:=35.6;
  if Ri<0 then Exit;
  Rj:=Self.Rj(СomparisonAlgorithm);
//  Rj:=48.52;
  if Rj<0 then Exit;
  Result:=(Rj-Ri)/sqrt(fAlgorithAmount*(fProblemAmount+1)/6.0);
//  Result:=1.314534;
end;

{ TNormalD }

constructor TNormalD.Create(mu, sigm: double);
begin
 inherited Create;
 Mean:=mu;
 Sigma:=sigm;
end;

procedure TNormalD.SetSigma(Value: double);
begin
 if Value>0 then fSigma:=Value
            else fSigma:=1;
end;

end.


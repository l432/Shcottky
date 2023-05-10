unit OlegStatistic;

interface

uses OlegType, OlegMath, OlegVector, OlegVectorManipulation, System.UITypes, OlegFunction,
  OlegTypePart2;

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

//TNormalD=class(TDistribution)
TNormalD=class
{нормальний розподіл}
 private
  fMu:double; // середнє
  fSigma:double; //  fSigma^2 - дисперсія
  procedure SetSigma(Value:double);
 public
  property Mean:double read fMu write fMu;
  property Sigma:double read fSigma write SetSigma;
  constructor Create(mu:double=0;sigm:double=1);
  class function CDF(x:double;mu:double=0;sigma:double=1):double;
  class function PDF(x:double;mu:double=0;sigma:double=1):double;
  class function Plim(z:double;mu:double=0;sigma:double=1):double;
 {ймовірність, що відхилення від середнього не менші |z-mu|,
 при z>=mu Result=2*(1-NormalCDF(z,mu,sigma))
 при z<mu Result=2*NormalCDF((z,mu,sigma)}
  class function CDF_AB(a,b:double;mu:double=0;sigma:double=1):double;
{ймовірність того, що величина має значення a<x<=b при
нормальному розподілу з середнім mu та дисперсією sigma^2}
end;

TChiSquaredD=class
{хі-квадрат розподіл}
 private
  class function Gam(k:word):double;
 public
  class function CDF(x:double;k:word):double;
  class function PDF(x:double;k:word):double;
{x>=0,
k - кількість ступенів вільності, для k=1 рахувало препаршиво,
тому поставив обмеження, що k>1}
end;

TFisherD=class
{F-розподіл (розподіл Фішера)}
 private
  class function BadParameters(x:double;k1,k2:word):boolean;
 public
  class function CDF(x:double;k1,k2:word):double;
  class function PDF(x:double;k1,k2:word):double;
{x>=0,
k1, k2 - кількість ступенів вільності,
про всяк випадок поставив обмеження k1>1, k2>1}
end;

TBinomialD=class
{біномінальний розподіл}
 private
  class function BadParameters(n,k:word;p:double):boolean;
 public
  class function ProbKN(n,k:word;p:double):double;
 {ймовірність успіху при k випробуваннях з n спроб}
  class function CDF(n,k:word;p:double):double;
{ймовірність того, що вдалих випробувань не більше k}
  class function PDF(n,k:word;p:double):double;
{k - кількість вдалих випробувань,
n - загальна кількість випробувань, n>=k;
p - ймовірність успіху при одному випровуванні,0<=p<=1}
end;

TOneToOneTest=class(TNamedObject)
 private
 fA:TVector;
 fB:TVector;
// fAlgorithAmount:byte;
// fProblemAmount:byte;
 fError:boolean;
 fItIsError:boolean;
 function AbetterBFooter(p:double=0.05):boolean;virtual;abstract;
// function StatisticFooter():double;virtual;abstract;
// function ZvalueFooter(ControlAlgorithm,СomparisonAlgorithm:byte):double;virtual;abstract;
 public
 constructor Create(A,B:TVector;ItIsError:boolean=True);
{A та В - результати роботи двох алгоритмів,
A.X[i] - номер i-ої задачі, задачі нумерюються з 1
A.Y[i] - результат алгоритму А для цієї задачі
має бути A.Count=B.Count;
при ItIsError=True перемога означає менше значення}
 destructor Destroy; override;
 function AbetterB(p:double=0.05):boolean;
{результат парного тесту про те, що А краще при щонайбільшому p-value,
0<p<1}
end;

TSignTest=class(TOneToOneTest)
 private
  fWins:word;
  function GetWinsNumber:word;
  function Pvalue:double;
  function AbetterBFooter(p:double=0.05):boolean;override;
 public
  property WinsNumber:word read fWins;
  constructor Create(A,B:TVector;ItIsError:boolean=True);
end;

TWilcoxonTest=class(TOneToOneTest)
 private
  fT:double;
  fmu:double;
  fsigma:double;
  function WilcoxonT():double;
{min(R+,R-) для критерію Wilcoxon;
 знак результату визначає кого більше:
 Result>0 якщо R+ > R-
 якщо щось не так - результат=-0.2}
 function WilcoxonNmin(n:word;p:double):integer;
{критичне значення для розподілу Wilcoxon при
n задачах і р-value відповідно до
таблиці, якщо для даних n та р значення
відсутнє повертається -1}
  function AbetterBFooter(p:double=0.05):boolean;override;
 public
  constructor Create(A,B:TVector;ItIsError:boolean=True);
  function AbetterB(MinMax:Tvector;p:double=0.05):boolean;overload;
{на відміну від попереднього, ще й нормалізує дані в А та В відповідно до MinMax;
у цьому тесті проводиться ранжування різниць показників роботи алгоритмів на різних
задачах і якщо ці показники суттєво різні, то краще нормалізувати
MinMax.X[i] - найкращий результат для і-ої задачі по всім алгоритмам
MinMax.Y[i] - найгірший результат для і-ої задачі по всім алгоритмам;
далі є процедура для створення такого вектора -  MinMaxValues
}
end;

Function AbetterBWilcoxon(A,B:TVector;ItIsError:boolean=True;p:double=0.05):boolean;overload;
{функція, всередині якої створення екземпляру класу}

Function AbetterBWilcoxon(A,B,MinMax:TVector;ItIsError:boolean=True;p:double=0.05):boolean;overload;


Function NchooseK(n,k:word):Int64;
{Біноміальний коефіцієнт,
кількість виборок по k з n,
n!/k!(n-k)!}

Procedure MinMaxValues(Arr:array of TVector; Target:TVector);
{Target.X[i]=min(Arr[].Y[i]),Target.Y[i]=max(Arr[].Y[i]),
кількість точок в Target визначається найменшим розміром Arr}

//Function MultipleSignNmin(m,n:word;p:double=0.05):integer;
//{критичне значення для Multiple Sign Test при
//(m+1) алгоритмах (всього, порівняння відбувається якогось з рештою m),
//n задачах і р-value відповідно до
//таблиці, якщо для даних m, n та р значення
//відсутнє повертається -1}

//Procedure MultipleSignTest(ControlAlgorithm:TVector;OtherAlgorithms:array of TVector;
//                           Results:TVector;p:double=0.05;ItIsError:boolean=True);
//{перевірка гіпотез щодо співвідношення медіанних відгуків
//контрольного алгоритму з іншими;
//Results.Count=High(OtherAlgorithms)+1 - кількість алгоритмів для порівняння,
//Results.X[i] = номер алгоритму в OtherAlgorithms,
//Results.Y[i] = 1 якщо можна відкинути гіпотезу про те,
//що медіанний відгук  OtherAlgorithms[i] кращий, ніж у ControlAlgorithm;
//(лишається гіпотеза, що ControlAlgorithm кращий);
//              -1 якщо можна відкинути гіпотезу про те,
//що медіанний відгук  ControlAlgorithm кращий, ніж у OtherAlgorithms[i];
//             =0 якщо відкинути гіпотези не вдалося;
//розміри  ControlAlgorithm та OtherAlgorithms мають бути однаковими,
//інакше в  Results.Y одні нулі
//}

Function ExtremCountVectorArray(Arr:array of TVector;ItIsMin:boolean=true):byte;
{мінімальний чи максимальний розмір векторів з Arr}

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

TOneToNTestPrimitive=class(TNamedObject)
 private
 fAlgorithmResult:array of TVector;
 fAlgorithmAmount:byte;
 fProblemAmount:byte;
 fError:boolean;
 fItIsError:boolean;
 procedure Rename();virtual;
 public
 constructor Create(Arr:array of TVector;ItIsError:boolean=True);
{Arr - масив результатів роботи k=High(Arr)+1 алгоритмів
на n=Arr[AlgorithmNumber].Count проблемах, самі результати
мають бути в Arr[AlgorithmNumber].Y[ProblemNumber]
розмір всіх векторів має бути однаковим;}
 destructor Destroy; override;
end;

TMultipleSign=class(TOneToNTestPrimitive)
 private
  Function Nmin(p:double=0.05):integer;
{критичне значення для Multiple Sign Test при
(m+1) алгоритмах (всього, порівняння відбувається якогось з рештою m),
n задачах і р-value відповідно до
таблиці, якщо для даних m, n та р значення
відсутнє повертається -1}
  procedure Rename();override;
 public
  procedure Test(ControlAlgorithm:byte;Results:TVector;p:double=0.05);
{перевірка гіпотез щодо співвідношення медіанних відгуків
контрольного алгоритму з номером ControlAlgorithm з іншими;
Results.Count=High(OtherAlgorithms)+1 - кількість алгоритмів для порівняння,
Results.X[i] = номер алгоритму, з яким порівнюється, у вихідному масиві,
нумерація алгоритмів з 1;
Results.Y[i] = 1 якщо можна відкинути гіпотезу про те,
що медіанний відгук  OtherAlgorithms[i] кращий, ніж у ControlAlgorithm;
(лишається гіпотеза, що ControlAlgorithm кращий);
              -1 якщо можна відкинути гіпотезу про те,
що медіанний відгук  ControlAlgorithm кращий, ніж у OtherAlgorithms[i];
             =0 якщо відкинути гіпотези не вдалося;
розміри  ControlAlgorithm та OtherAlgorithms мають бути однаковими,
інакше в  Results.Y одні нулі
}
end;


TOneToNTest=class(TOneToNTestPrimitive)
 private
 fp_unadj:TVector;
 fhelpVector:TVector;

 function RijFooter(ProblemNumber,AlgorithmNumber:byte):double;virtual;abstract;
 function StatisticFooter():double;virtual;abstract;
 function ZvalueFooter(ControlAlgorithm,СomparisonAlgorithm:byte):double;virtual;abstract;
 function Total(Number:byte;Fun:TFunIJObj;forAlgorithm:boolean=True):double;
 {сума значень, які повертає Fun;
 при forAlgorithm=True сумування по першому параметру Fun,
 тобто Number - номер алгоритму}
  procedure p_unadjFill(ControlAlgorithm:byte);
{в fp_unadj.X[] некореговані значення р порівняно з
алгоритмом з номером ControlAlgorithm, сортовані за зростанням;
в fp_unadj.Y[] номер алгоритму, з яким порівнювалося, у початковому
наборі fp_unadj.Y[]=[1..fAlgorithmAmount, <>ControlAlgorithm];
нумерація елементів від 0 до (fAlgorithmAmount-2)}
  function СomparisonAlgorithmNumberInP_unadj(СomparisonAlgorithm:byte):byte;
{повертає номер запису в fp_unadj, який відноситься до
алгоритму з номером СomparisonAlgorithm,
Result=[0..(fAlgorithmAmount-1)]}
 public
 constructor Create(Arr:array of TVector;ItIsError:boolean=True);
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
 {значення статистики для методи, фактично на основі
 порівняння цієї величини з чимось(залежно від
 конкретного методу) робиться висновок про ймовірність нульової
 гіпотези, див.нижче}
 function NullhypothesisP():double;virtual;abstract;
 {гіпотеза про те, що всі методи однакові;
 повертає ймовірність цього}
 function BonferroniAPV(ControlAlgorithm,СomparisonAlgorithm:byte):double;
 {APV - adjusted p-values}
 function HolmAPV(ControlAlgorithm,СomparisonAlgorithm:byte):double;
 function HollandAPV(ControlAlgorithm,СomparisonAlgorithm:byte):double;
 function FinnerAPV(ControlAlgorithm,СomparisonAlgorithm:byte):double;
 function HochbergAPV(ControlAlgorithm,СomparisonAlgorithm:byte):double;
 function HommelAPV(ControlAlgorithm,СomparisonAlgorithm:byte):double;
{не вийшло - чи то я дурний, чи то чергова помилка в описі}
 function LiAPV(ControlAlgorithm,СomparisonAlgorithm:byte):double;

end;

TFriedman=class(TOneToNTest)
 private
  procedure Rename();override;
  function RijFooter(ProblemNumber,AlgorithmNumber:byte):double;override;
  function StatisticFooter():double;override;
  function ZvalueFooter(ControlAlgorithm,СomparisonAlgorithm:byte):double;override;
 public
  function NullhypothesisP():double;override;
end;

TImanDavenport=class(TFriedman)
 private
  procedure Rename();override;
  function StatisticFooter():double;override;
 public
 function NullhypothesisP():double;override;
end;

TFriedmanAligned=class(TOneToNTest)
 private
  procedure Rename();override;
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
 function NullhypothesisP():double;override;
end;

TQuade=class(TFriedman)
 private
  fQ:TVectorTransform;
  procedure Rename();override;
  function StatisticFooter():double;override;
  function ZvalueFooter(ControlAlgorithm,СomparisonAlgorithm:byte):double;override;
 public
  constructor Create(Arr:array of TVector;ItIsError:boolean=True);
  destructor Destroy; override;
  function Sij(ProblemNumber,AlgorithmNumber:byte):double;
  {average rank AlgorithmNumber-го алгоритму within ProblemNumber problems,
  може бути від'ємним}
  function Wij(ProblemNumber,AlgorithmNumber:byte):double;
  {незважений ранг}
  function SjTotal(AlgorithmNumber:byte):double;
  {сумарнй, може бути від'ємним}
  function WjTotal(AlgorithmNumber:byte):double;
  function Tj(AlgorithmNumber:byte):double;
  {average ranking for the AlgorithmNumber-th algorithm}
  function NullhypothesisP():double;override;
end;

TMultipleComparisons=class(TFriedman)
 private
  fPairAmount:byte;
  {кількість можливих пар для порівняння}
  fShafferIndexValues:TVector;
  {зберігаються можливі значення індекса Shaffer}
  procedure Rename();override;
  procedure FillShafferIndexValues;
  function NumberInP_unadj(ControlAlgorithm,СomparisonAlgorithm:byte):integer;
{повертає номер запису в fp_unadj, який відноситься до
пари (ControlAlgorithm,СomparisonAlgorithm),
якщо все добре, то
Result=[0..(fPairAmount-1)],
якщо такої пари немає,
то Result:=-1}
  function ShafferIndex(j:integer):integer;
  {j=(0..(fPairAmount-1)}
 public
//  property p_unadj:TVector read fp_unadj;
  constructor Create(Arr:array of TVector;ItIsError:boolean=True);
{в fp_unadj.X[] некореговані значення р для
всіх можливих пар, сортовані за зростанням;
загалом UnadjustedP(i,j)<>UnadjustedP(j,i),
але тільки в одному випадку значення буде менше 1,
при заповненні fp_unadj.X будуть вибрані саме такі
пари, для яких p<1;
в fp_unadj.Y[] сховані номери вихідних алгоритмів,
для яких отримані дані значення р:
в цілій частині fp_unadj.Y[] - ControlAlgorithm,
в дробовій частині fp_unadj.Y[] - СomparisonAlgorithm}
  destructor Destroy; override;
  function MultipleNemenyi(ControlAlgorithm,СomparisonAlgorithm:byte):double;
  function MultipleHolmAPV(ControlAlgorithm,СomparisonAlgorithm:byte):double;
  function MultipleShafferStaticAPV(ControlAlgorithm,СomparisonAlgorithm:byte):double;
end;

implementation

uses
  System.Math, Vcl.Dialogs, System.SysUtils;

Function NchooseK(n,k:word):Int64;
begin
  if k>n then
    begin
      Result:=0;
      Exit;
    end;
  Result:=Round(Factorial(n)/Factorial(k)/Factorial(n-k));
end;


//Function WinsNumber(A,B:TVector;ItIsError:boolean=True):word;
// var WinsTemp:double;
//     i:integer;
//begin
//  Result:=0;
//  if A.Count<>B.Count  then Exit;
//  WinsTemp:=0;
//  for I := 0 to A.HighNumber do
//   if IsEqual(A.X[i],B.X[i]) then
//    begin
//      if IsEqual(A.Y[i],B.Y[i]) then
//                   begin
//                    WinsTemp:=WinsTemp+0.5;
//                    Continue;
//                   end;
//      if ItIsError and (A.Y[i]<B.Y[i]) then WinsTemp:=WinsTemp+1;
//      if not(ItIsError) and (A.Y[i]>B.Y[i]) then WinsTemp:=WinsTemp+1;
////      showmessage(floattostr(A.Y[i])+' '+floattostr(B.Y[i])+' '+floattostr(WinsTemp));
//    end                      else Exit;
//   Result:=Floor(WinsTemp);
//end;
//
//Function SignTestPvalue(A,B:TVector;ItIsError:boolean):double;
// var Wins:word;
//begin
//  Wins:=WinsNumber(A,B,ItIsError);
//  if Wins>A.Count/2.0 then Result:=TNormalD.Plim(Wins,A.Count/2.0,sqrt(A.Count)/2.0)
////  2*(1-TNormalD.CDF(Wins,A.Count/2.0,sqrt(A.Count)/2.0))
//                      else Result:=1;
//end;
//
//Function SignTestAbetterB(A,B:TVector;p:double=0.05;ItIsError:boolean=True):boolean;
//begin
//  if (p<=0) or (p>=1) then
//     begin
//       Result:=False;
//       Exit;
//     end;
//  Result:= (SignTestPvalue(A,B,ItIsError)<p);
//end;

//Function WilcoxonNmin(n:word;p:double):integer;
// var p_number,i:integer;
//begin
// Result:=-1;
// if (n<Low(WilcoxonValues))or(n>High(WilcoxonValues))
//    then Exit;
// p_number:=-1;
// for I := 0 to WilcoxonPNumber do
//   if IsEqual(p,WilcoxonP[i]) then
//           begin
//             p_number:=i;
//             Break;
//           end;
// if p_number<0 then Exit;
// Result:=WilcoxonValues[n,p_number];
//end;
//
//Function WilcoxonT(A,B:TVector;ItIsError:boolean=True):double;
//{min(R+,R-) для критерію Wilcoxon}
// var d:TVectorTransform;
//     i:integer;
//     Rplus,Rminus:double;
//begin
//  Result:=-1;
//  if (A.Count<>B.Count)  then Exit;
//
//  d:=TVectorTransform.Create(B);
//  d.DeltaY(A);
//  d.Itself(d.Rank);
//
//  Rplus:=0;
//  Rminus:=0;
//  for I := 0 to d.HighNumber do
//   begin
//     if IsEqual(d.X[i],0) then
//      begin
//        Rplus:=Rplus+0.5*d.Y[i];
//        Rminus:=Rminus+0.5*d.Y[i];
//        Continue;
//      end;
//     if d.X[i]>0 then Rplus:=Rplus+d.Y[i]
//                  else Rminus:=Rminus+d.Y[i];
//   end;
//
////  showmessage('R+='+floattostr(Rplus)+' R-='+floattostr(Rminus)+' Sum='+floattostr(Rminus+Rplus));
//  Result:=min(Rplus,Rminus);
//  if Rminus>Rplus then Result:=-Result;
//
//
//  FreeAndNil(d);
//end;

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

//Function WilcoxonTestAbetterB(A,B:TVector;p:double=0.05;ItIsError:boolean=True):boolean;
// var mu,sigma,T:double;
//     n,W:integer;
//begin
//  Result:=False;
//  if (p<=0) or (p>=1) then Exit;
//  if A.Count<>B.Count then Exit;
//  n:=A.Count;
//  T:=WilcoxonT(A,B,ItIsError);
//  W:=WilcoxonNmin(n,p);
//  if W>=0 then Result:=abs(T)<=W
//          else
//           begin
//            mu:=n*(n+1)/4;
//            sigma:=sqrt(n*(n+1)*(2*n+1)/24);
//            Result:=(p>=(1-TNormalD.CDF((abs(abs(T)-mu)-0.5)/sigma)));
//           end;
//  if ItIsError then  Result:= Result and (T>0)
//               else  Result:= Result and (T<0);
//end;
//
//Function WilcoxonTestAbetterB(A,B:TVectorTransform;MinMax:Tvector;p:double=0.05;ItIsError:boolean=True):boolean;
// var Anew,Bnew:TVector;
// begin
//  Anew:=TVector.Create;
//  Bnew:=TVector.Create;
//  A.MinMax(Anew,MinMax);
//  B.MinMax(Bnew,MinMax);
//  Result:=WilcoxonTestAbetterB(Anew,Bnew,p,ItIsError);
//  FreeAndNil(Anew);
//  FreeAndNil(Bnew);
// end;

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

//Procedure MultipleSignTest(ControlAlgorithm:TVector;OtherAlgorithms:array of TVector;
//                           Results:TVector;p:double=0.05;ItIsError:boolean=True);
// var i:integer;
//     d:TVector;
//begin
// Results.Clear;
// if High(OtherAlgorithms)<0 then Exit;
// for I := 0 to High(OtherAlgorithms) do
//    Results.Add(i,0);
// if ExtremCountVectorArray(OtherAlgorithms,True)<> ExtremCountVectorArray(OtherAlgorithms,False)
//    then Exit;
// if ExtremCountVectorArray(OtherAlgorithms)<> ControlAlgorithm.Count
//    then Exit;
// d:=TVector.Create;
//
//// showmessage(inttostr(MultipleSignNmin(High(OtherAlgorithms)+1,ControlAlgorithm.Count,p)));
// for I := 0 to High(OtherAlgorithms) do
//   begin
//    if ItIsError then
//           begin
//            OtherAlgorithms[i].CopyTo(d);
//            d.DeltaY(ControlAlgorithm);
//           end   else
//           begin
//            ControlAlgorithm.CopyTo(d);
//            d.DeltaY(OtherAlgorithms[i]);
//           end;
////     showmessage(inttostr(i)+' '+d.XYtoString+' r-='+inttostr(d.NegativeInY)+' r+='+inttostr(d.PositiveInY));
//     if d.NegativeInY<=MultipleSignNmin(High(OtherAlgorithms)+1,d.Count,p)
//         then Results.Y[i]:=1;
//     if d.PositiveInY<=MultipleSignNmin(High(OtherAlgorithms)+1,d.Count,p)
//         then Results.Y[i]:=-1;
//   end;
// FreeAndNil(d);
//end;

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

//constructor TOneToNTest.Create(Arr: array of TVector; ItIsError: boolean);
// var i:integer;
//begin
// inherited Create;
// fItIsError:=ItIsError;
// fError:=False;
// fAlgorithAmount:=High(Arr)+1;
// fProblemAmount:=ExtremCountVectorArray(Arr);
// if (fAlgorithAmount<2)or(fProblemAmount<2) then fError:=True;
// if fProblemAmount<> ExtremCountVectorArray(Arr,False) then fError:=True;
// if fError then
//    begin
//      MessageDlg('Bad data',mtError, [mbOK], 0);
//      Exit;
//    end;
//  SetLength(fAlgorithmResult,High(Arr)+1);
//  for I := 0 to High(fAlgorithmResult) do
//    fAlgorithmResult[i]:=TVector.Create(Arr[i]);
//end;

//destructor TOneToNTest.Destroy;
// var i:integer;
//begin
// for I := 0 to High(fAlgorithmResult) do FreeAndNil(fAlgorithmResult[i]);
// inherited;
//end;

function TOneToNTest.BonferroniAPV(ControlAlgorithm,
  СomparisonAlgorithm: byte): double;
 var p_Unad:double;
begin
  Result:=1;
  if fError then Exit;
  p_Unad:=UnadjustedP(ControlAlgorithm,СomparisonAlgorithm);
  if p_Unad=1 then Result:=1
              else Result:=min((fAlgorithmAmount-1)*p_Unad,1);
end;

constructor TOneToNTest.Create(Arr: array of TVector; ItIsError: boolean);
begin
 inherited Create(Arr,ItIsError);
 fp_unadj:=TVector.Create;
 fhelpVector:=TVector.Create;
end;

destructor TOneToNTest.Destroy;
begin
  FreeAndNil(fhelpVector);
  FreeAndNil(fp_unadj);
  inherited;
end;

function TOneToNTest.FinnerAPV(ControlAlgorithm,
  СomparisonAlgorithm: byte): double;
 var i:byte;
begin
 p_unadjFill(ControlAlgorithm);
 fhelpVector.Clear;
 for I := 0 to СomparisonAlgorithmNumberInP_unadj(СomparisonAlgorithm) do
  fhelpVector.Add(i,1-Power((1-fp_unadj.X[i]),(fAlgorithmAmount-1)/(i+1)));
 Result:=min(1,fhelpVector.MaxY);
end;

function TOneToNTest.HochbergAPV(ControlAlgorithm,
  СomparisonAlgorithm: byte): double;
 var i:byte;
begin
 p_unadjFill(ControlAlgorithm);
 fhelpVector.Clear;
 for I := (fAlgorithmAmount-2) downto СomparisonAlgorithmNumberInP_unadj(СomparisonAlgorithm) do
  fhelpVector.Add(i,(fAlgorithmAmount-i-1)*fp_unadj.X[i]);
 Result:=fhelpVector.MinY;
end;


function TOneToNTest.HollandAPV(ControlAlgorithm,
  СomparisonAlgorithm: byte): double;
 var i:byte;
begin
 p_unadjFill(ControlAlgorithm);
 fhelpVector.Clear;
 for I := 0 to СomparisonAlgorithmNumberInP_unadj(СomparisonAlgorithm) do
  fhelpVector.Add(i,1-Power((1-fp_unadj.X[i]),(fAlgorithmAmount-i-1)));
 Result:=min(1,fhelpVector.MaxY);
end;

function TOneToNTest.HolmAPV(ControlAlgorithm,
  СomparisonAlgorithm: byte): double;
 var i:byte;
begin
 p_unadjFill(ControlAlgorithm);
 fhelpVector.Clear;
 for I := 0 to СomparisonAlgorithmNumberInP_unadj(СomparisonAlgorithm) do
  fhelpVector.Add(i,(fAlgorithmAmount-i-1)*fp_unadj.X[i]);
 Result:=min(1,fhelpVector.MaxY);
end;

function TOneToNTest.LiAPV(ControlAlgorithm,
  СomparisonAlgorithm: byte): double;
begin
 p_unadjFill(ControlAlgorithm);
 Result:=fp_unadj.X[СomparisonAlgorithmNumberInP_unadj(СomparisonAlgorithm)]
         /(fp_unadj.X[СomparisonAlgorithmNumberInP_unadj(СomparisonAlgorithm)]+1
           -fp_unadj.X[fp_unadj.HighNumber]);
end;

function TOneToNTest.HommelAPV(ControlAlgorithm,
  СomparisonAlgorithm: byte): double;
 var j,i:byte;
     Cmin:double;
begin
 p_unadjFill(ControlAlgorithm);
 result:=fp_unadj.X[СomparisonAlgorithmNumberInP_unadj(СomparisonAlgorithm)];
 fhelpVector.Clear;
 j:=fAlgorithmAmount-1;
 repeat
   fhelpVector.Clear;
   for I :=(fAlgorithmAmount-j) to fAlgorithmAmount-1 do
     fhelpVector.Add(i,j*fp_unadj.X[i-1]/(j+i-fAlgorithmAmount+1));
   Cmin:=fhelpVector.MinY;
   if (СomparisonAlgorithmNumberInP_unadj(СomparisonAlgorithm)+1) in [(fAlgorithmAmount-j)..(fAlgorithmAmount-1)]
   then
     result:=max(result,Cmin);
   for I := 1 to (fAlgorithmAmount-j-1) do
     if i=СomparisonAlgorithmNumberInP_unadj(СomparisonAlgorithm)+1 then
      Result:=max(Result,min(Cmin,j*fp_unadj.X[i-1]));
   j:=j-1;
 until j<2;
end;

procedure TOneToNTest.p_unadjFill(ControlAlgorithm: byte);
 var i:byte;
begin
 fp_unadj.Clear;
 for I := 1 to fAlgorithmAmount do
   if i<> ControlAlgorithm then
      fp_unadj.Add(UnadjustedP(ControlAlgorithm,i),i);
 fp_unadj.Sorting();
end;

function TOneToNTest.Rij(ProblemNumber, AlgorithmNumber: byte): double;
begin
 Result:=-1;
 if fError then Exit;
 if (ProblemNumber<1)or(ProblemNumber>fProblemAmount)
     or(AlgorithmNumber<1)or(AlgorithmNumber>fAlgorithmAmount) then Exit;
 Result:=RijFooter(ProblemNumber, AlgorithmNumber);
end;

function TOneToNTest.Rj(AlgorithmNumber: byte): double;
begin
 Result:=Total(AlgorithmNumber,Rij);
 if Result<0 then Exit;
 Result:=Result/fProblemAmount;
end;

function TOneToNTest.Statistic: double;
begin
  Result:=-1;
  if fError then Exit;
  Result:=StatisticFooter();
end;

function TOneToNTest.Total(Number: byte; Fun: TFunIJObj;
  forAlgorithm: boolean): double;
 var temp:TVector;
     i,maxIndex:integer;

begin
 Result:=-1;
 if fError or (Number=0) then Exit;

 if forAlgorithm then
    if Number>fAlgorithmAmount then Exit
                 else
    if Number>fProblemAmount then Exit;
 temp:=TVector.Create;
 if forAlgorithm then maxIndex:=fProblemAmount-1
                 else maxIndex:=fAlgorithmAmount-1;
 for I := 0 to maxIndex do
   begin
     if forAlgorithm then temp.Add(i,Fun(i+1,Number))
                     else temp.Add(i,Fun(Number,i+1));
//     if temp.Y[i]<0 then
//       begin
//        FreeAndNil(temp);
//        Exit;
//       end;
   end;
 Result:=temp.SumY;
 FreeAndNil(temp);
end;

function TOneToNTest.UnadjustedP(ControlAlgorithm,
  СomparisonAlgorithm: byte): double;

// const
// pFr:array [1..8] of double=(0.000006,0.009823,0.000332,
//  0.014171,0.083642,0.141093,0.518605,0.660706);
// pQua:array [1..8] of double=(0.021720,0.052904,0.118631,
//  0.158192,0.259289,0.357754,0.803179,0.928037);

 var z:double;
begin
  Result:=1;
  try
  z:=Zvalue(ControlAlgorithm,СomparisonAlgorithm);
  if z<0 then Exit;
  result:=TNormalD.Plim(z);
//  result:=pFr[СomparisonAlgorithm];
//  result:=pQua[СomparisonAlgorithm];
  except
  end;
end;

function TOneToNTest.Zvalue(ControlAlgorithm,
  СomparisonAlgorithm: byte): double;
begin
  Result:=-1;
  if fError then Exit;
  if (ControlAlgorithm<1)or(ControlAlgorithm>fAlgorithmAmount)
     or(СomparisonAlgorithm<1)or(СomparisonAlgorithm>fAlgorithmAmount) then Exit;
  Result:=ZValueFooter(ControlAlgorithm,  СomparisonAlgorithm);
end;

function TOneToNTest.СomparisonAlgorithmNumberInP_unadj(
  СomparisonAlgorithm: byte): byte;
 var i:byte;
begin
 Result:=0;
 for I := 0 to fp_unadj.HighNumber do
  if round(fp_unadj.Y[i])=СomparisonAlgorithm
      then
       begin
        Result:=i;
        Break;
       end;
end;

{ TFriedman }

function TFriedman.NullhypothesisP: double;
 var stat:double;
begin
 result:=1;
 stat:=Self.Statistic;
 if stat<0 then Exit;
 try
 Result:=1-TChiSquaredD.CDF(stat,fAlgorithmAmount-1);
 except
 end;
end;

procedure TFriedman.Rename;
begin
 fName:='Friedman';
end;

function TFriedman.RijFooter(ProblemNumber, AlgorithmNumber: byte): double;
 var i:integer;
     temp1,temp2:TVectorTransform;
begin
 temp1:=TVectorTransform.Create;
 temp2:=TVectorTransform.Create;
 for i := 1 to fAlgorithmAmount do
   temp1.Add(i,fAlgorithmResult[i-1].Y[ProblemNumber-1]);
 temp1.Rank(temp2,True,True,fItIsError);
 Result:=temp2.Y[AlgorithmNumber-1];
 FreeAndNil(temp2);
 FreeAndNil(temp1);
end;

function TFriedman.StatisticFooter: double;
//  const s:array [1..4] of double=(1.771, 2.479, 2.479, 3.271);
 var j:integer;
begin
//    fAlgorithmAmount:=4;
//  fProblemAmount:=24;

  Result:=0;
  for j := 1 to fAlgorithmAmount do Result:=Result+sqr(Self.Rj(j));
//  for j := 1 to fAlgorithmAmount do Result:=Result+sqr(s[j]);
  Result:=(Result-fAlgorithmAmount*sqr(fAlgorithmAmount+1)/4)
      *12*fProblemAmount/fAlgorithmAmount/(fAlgorithmAmount+1);
//  Result:=35.99733;
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
  Result:=(Rj-Ri)/sqrt(fAlgorithmAmount*(fAlgorithmAmount+1)/6.0/fProblemAmount);
end;

{ TImanDavenport }

function TImanDavenport.NullhypothesisP: double;
 var stat:double;
begin
 result:=1;
 stat:=Self.Statistic;
 if stat<0 then Exit;
 try
 Result:=1-TFisherD.CDF(stat,fAlgorithmAmount-1,(fAlgorithmAmount-1)*(fProblemAmount-1));
 except
 end;
end;

procedure TImanDavenport.Rename;
begin
 fName:='ImanDavenport';
end;

function TImanDavenport.StatisticFooter: double;
 var ksi_F:double;
begin
//  Result:=-1;
  ksi_F:=inherited StatisticFooter();
//  ksi_F:=16.225;
//      fAlgorithmAmount:=4;
//  fProblemAmount:=24;
  try
  Result:=(fProblemAmount-1)*ksi_F/(fProblemAmount*(fAlgorithmAmount-1)-ksi_F);
  except
   Result:=-1;
  end;

end;

{ TFriedmanAligned }

function TFriedmanAligned.NullhypothesisP: double;
 var stat:double;
begin
 result:=1;
 stat:=Self.Statistic;
 if stat<0 then Exit;
 try
 Result:=1-TChiSquaredD.CDF(stat,fAlgorithmAmount-1);
 except

 end;
end;

procedure TFriedmanAligned.Rename;
begin
 fName:='FriedmanAligned';
end;

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
     for j := 1 to fAlgorithmAmount do
       Temp1.Add(j,fAlgorithmResult[j-1].Y[i-1]);
     MeanForProblem.Add(i,temp1.MeanY);
   end;
 temp1.Clear;
 for I := 1 to fProblemAmount do
  for j := 1 to fAlgorithmAmount do
     Temp1.Add(i,fAlgorithmResult[j-1].Y[i-1]-MeanForProblem.Y[i-1]);

 temp1.Rank(temp2,True,False,fItIsError);
 result:=temp2.Y[(ProblemNumber-1)*fAlgorithmAmount+(AlgorithmNumber-1)];

 FreeAndNil(MeanForProblem);
 FreeAndNil(temp2);
 FreeAndNil(temp1);
end;

function TFriedmanAligned.RiTotal(ProblemNumber: byte): double;
begin
  Result:=Total(ProblemNumber,Rij,False);
end;

function TFriedmanAligned.RjTotal(AlgorithmNumber: byte): double;
begin
  Result:=Total(AlgorithmNumber,Rij);
end;

function TFriedmanAligned.StatisticFooter: double;
//  const s:array [1..4] of double=(703.5, 1121.5, 1129.5, 1701.5);
 var j:integer;
     Rj_sum,Ri_sum:double;
begin
//  fAlgorithmAmount:=4;
//  fProblemAmount:=24;
  Rj_sum:=0;
  for j := 1 to fAlgorithmAmount do Rj_sum:=Rj_sum+sqr(RjTotal(j));
//  for j := 1 to fAlgorithmAmount do Rj_sum:=Rj_sum+sqr(s[j]);
//  showmessage('Rj='+floattostr(Rj_sum));

  Ri_sum:=0;
  for j := 1 to fProblemAmount do Ri_sum:=Ri_sum+sqr(RiTotal(j));
//  Ri_sum:=926830;
//    showmessage('Ri='+floattostr(Ri_sum));
  try
   Result:=(fAlgorithmAmount-1)*(Rj_sum-fAlgorithmAmount
              *sqr(fProblemAmount*(fAlgorithmAmount*fProblemAmount+1))/4)
            /(((fAlgorithmAmount*fProblemAmount*(fAlgorithmAmount*fProblemAmount+1)
            *(2*fAlgorithmAmount*fProblemAmount+1))/6.0)-Ri_sum/fAlgorithmAmount);
//   Result:=21.31479;
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
  Result:=(Rj-Ri)/sqrt(fAlgorithmAmount*(fProblemAmount+1)/6.0);
//  Result:=1.314534;
end;

{ TNormalD }

class function TNormalD.CDF(x, mu, sigma: double): double;
begin
  try
   Result:=0.5*(1+Erf((x-mu)/sqrt(2)/sigma))
  except
   Result:=ErResult;
  end;
end;

class function TNormalD.CDF_AB(a, b, mu, sigma: double): double;
begin
  if sigma=0 then
   begin
     Result:=ErResult;
     Exit
   end;
  Result:=Self.CDF(b,mu,sigma)-Self.CDF(a,mu,sigma);
end;

constructor TNormalD.Create(mu, sigm: double);
begin
 inherited Create;
 Mean:=mu;
 Sigma:=sigm;
end;

class function TNormalD.Plim(z, mu, sigma: double): double;
 var cdf_value:double;
begin
 Result:=ErResult;
 cdf_value:=Self.CDF(z,mu,sigma);
 if cdf_value=ErResult then Exit;
 if z>=mu then Result:=2*(1-cdf_value)
          else Result:=2*cdf_value;
end;

class function TNormalD.PDF(x, mu, sigma: double): double;
begin
  try
   Result:=1/sigma/sqrt(2*Pi)*exp(-sqr((x-mu)/sigma)/2);
  except
   Result:=ErResult;
  end;
end;

procedure TNormalD.SetSigma(Value: double);
begin
 if Value>0 then fSigma:=Value
            else fSigma:=1;
end;

{ TChiSquaredD }

class function TChiSquaredD.CDF(x: double; k: word): double;
begin
 if (k<2)or(x<0) then
   begin
     Result:=ErResult;
     Exit
   end;
 Result:=GammaLowerIncomplete(k/2.0,x/2.0)/Gam(k);
end;

class function TChiSquaredD.Gam(k: word): double;
 var k2:double;
begin
 k2:=k/2.0;
 if odd(k) then Result:=Gamma(k2)
           else Result:=Gamma(round(k2));
end;

class function TChiSquaredD.PDF(x: double; k: word): double;
begin
 if (k<2)or(x<0) then
   begin
     Result:=ErResult;
     Exit
   end;
 Result:=Power(x,k/2.0-1)*exp(-x/2.0)
         /Power(2,k/2.0)/Gam(k);
end;

{ TFisherD }

class function TFisherD.BadParameters(x: double; k1, k2: word): boolean;
begin
if (x<0)or(k1<2)or(k2<2)
   then Result:=True
   else Result:=False;
end;

class function TFisherD.CDF(x: double; k1, k2: word): double;
begin
 if BadParameters(x,k1,k2) then
   begin
     Result:=ErResult;
     Exit
   end;
 Result:=BettaRegularizedIncomplete(k1*x/(k1*x+k2),k1/2.0,k2/2.0);
 Result:=min(Result,1);
end;

class function TFisherD.PDF(x: double; k1, k2: word): double;
begin
 if BadParameters(x,k1,k2) then
   begin
     Result:=ErResult;
     Exit
   end;
 Result:=Power(k1/k2,k1/2.0)*Power(x,k1/2.0-1)
         *Power((1+k1/k2*x),-(k1+k2)/2.0)/Betta(k1/2.0,k2/2.0);
end;

{ TBinomialD }

class function TBinomialD.BadParameters(n, k: word; p: double): boolean;
begin
  if (p<0)or(p>1)or(k>n)
   then Result:=True
   else Result:=False;
end;

class function TBinomialD.CDF(n,k:word;p:double): double;
 var i:word;
begin
 if BadParameters(n, k, p) then
   begin
     Result:=ErResult;
     Exit;
   end;
 Result:=0;
 for I := 0 to k do
   Result:=Result+PDF(n,i,p)
end;

class function TBinomialD.PDF(n, k: word; p: double): double;
begin
  if BadParameters(n, k, p) then
   begin
     Result:=ErResult;
     Exit;
   end;
  Result:=NchooseK(n,k)*ProbKN(n,k,p);
end;

class function TBinomialD.ProbKN(n, k: word; p: double): double;
begin
  if BadParameters(n, k, p) then
   begin
     Result:=0;
     Exit;
   end;
  Result:=Power(p,k)*Power((1-p),(n-k));
end;

{ TOneToOneTest }

function TOneToOneTest.AbetterB(p: double): boolean;
begin
  if (p<=0) or (p>=1) or fError then
     begin
       Result:=False;
       Exit;
     end;
  Result:= AbetterBFooter(p);
end;

constructor TOneToOneTest.Create(A, B: TVector; ItIsError: boolean);
begin
 inherited Create('OneToOneTest');
 fItIsError:=ItIsError;
 fError:=A.Count<>B.Count;
 if fError then
    begin
      MessageDlg('Bad data',mtError, [mbOK], 0);
      Exit;
    end;
  fA:=TVector.Create(A);
  fB:=TVector.Create(B);
end;

destructor TOneToOneTest.Destroy;
begin
 FreeAndNil(fB);
 FreeAndNil(fA);
 inherited;
end;

{ TSignTest }

function TSignTest.AbetterBFooter(p: double): boolean;
begin
  Result:= (Pvalue()<p);
end;

constructor TSignTest.Create(A, B: TVector; ItIsError: boolean);
begin
 inherited Create(A,B,ItIsError);
 if fError then Exit;

 fWins:=GetWinsNumber;
 fName:='SignTest';
end;

function TSignTest.GetWinsNumber: word;
 var WinsTemp:double;
     i:integer;
begin
  Result:=0;
  if fError  then Exit;
  WinsTemp:=0;
  for I := 0 to fA.HighNumber do
   if IsEqual(fA.X[i],fB.X[i]) then
    begin
      if IsEqual(fA.Y[i],fB.Y[i]) then
                   begin
                    WinsTemp:=WinsTemp+0.5;
                    Continue;
                   end;
      if fItIsError and (fA.Y[i]<fB.Y[i]) then WinsTemp:=WinsTemp+1;
      if not(fItIsError) and (fA.Y[i]>fB.Y[i]) then WinsTemp:=WinsTemp+1;
    end                      else Exit;
   Result:=Floor(WinsTemp);
end;

function TSignTest.Pvalue: double;
begin
  if fWins>fA.Count/2.0 then Result:=TNormalD.Plim(fWins,fA.Count/2.0,sqrt(fA.Count)/2.0)
//  2*(1-TNormalD.CDF(Wins,A.Count/2.0,sqrt(A.Count)/2.0))
                      else Result:=1;
end;

{ TWilcoxonTest }

function TWilcoxonTest.AbetterB(MinMax: Tvector; p: double): boolean;
 var Anew,Bnew:TVector;
     Aold,Bold:TVectorTransform;
     WT:TWilcoxonTest;
 begin
  Result:=False;
  if (fA.Count>MinMax.Count)or fError then Exit;

  Anew:=TVector.Create;
  Bnew:=TVector.Create;
  Aold:=TVectorTransform.Create(fA);
  Bold:=TVectorTransform.Create(fB);
  Aold.MinMax(Anew,MinMax);
  Bold.MinMax(Bnew,MinMax);
  WT:=TWilcoxonTest.Create(Anew,Bnew,fItIsError);
  Result:=WT.AbetterB(p);
  FreeAndNil(WT);
  FreeAndNil(Aold);
  FreeAndNil(Bold);
  FreeAndNil(Anew);
  FreeAndNil(Bnew);
 end;


function TWilcoxonTest.AbetterBFooter(p: double): boolean;
 var W:integer;
begin
  W:=WilcoxonNmin(fA.Count,p);
  if W>-1 then Result:=abs(fT)<=W
          else Result:=(p>=(1-TNormalD.CDF((abs(abs(fT)-fmu)-0.5)/fsigma)));
  if fItIsError then  Result:= Result and (fT>0)
                else  Result:= Result and (fT<0);
end;

constructor TWilcoxonTest.Create(A, B: TVector; ItIsError: boolean);
 var n:integer;
begin
 inherited Create(A,B,ItIsError);
 if fError then Exit;
 fT:=WilcoxonT;
 if (fT<0)and(fT>-0.5) then fError:=True;
 n:=fA.Count;
 fmu:=n*(n+1)/4;
 fsigma:=sqrt(n*(n+1)*(2*n+1)/24);
 fName:='WilcoxonTest';
end;

function TWilcoxonTest.WilcoxonNmin(n: word; p: double): integer;
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

function TWilcoxonTest.WilcoxonT: double;
 var d:TVectorTransform;
     i:integer;
     Rplus,Rminus:double;
begin
  Result:=-0.2;
  if fError  then Exit;

  d:=TVectorTransform.Create(fB);
  d.DeltaY(fA);
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

  Result:=min(Rplus,Rminus);
  if Rminus>Rplus then Result:=-Result;
  FreeAndNil(d);
end;

{ TOneToNTestPrimitive }

constructor TOneToNTestPrimitive.Create(Arr: array of TVector;
  ItIsError: boolean);
 var i:integer;
begin
 inherited Create('OneToNTestPrimitive');
 fItIsError:=ItIsError;
 fError:=False;
 fAlgorithmAmount:=High(Arr)+1;
 fProblemAmount:=ExtremCountVectorArray(Arr);
 if (fAlgorithmAmount<2)or(fProblemAmount<2) then fError:=True;
 if fProblemAmount<> ExtremCountVectorArray(Arr,False) then fError:=True;
 if fError then
    begin
      MessageDlg('Bad data',mtError, [mbOK], 0);
      Exit;
    end;
  SetLength(fAlgorithmResult,High(Arr)+1);
  for I := 0 to High(fAlgorithmResult) do
    fAlgorithmResult[i]:=TVector.Create(Arr[i]);
  Rename();
end;

destructor TOneToNTestPrimitive.Destroy;
 var i:integer;
begin
 for I := 0 to High(fAlgorithmResult) do FreeAndNil(fAlgorithmResult[i]);
 inherited;
end;

procedure TOneToNTestPrimitive.Rename;
begin
end;

{ TMultipleSign }

function TMultipleSign.Nmin(p: double): integer;
 var p_number,n_number,i:integer;
begin
 Result:=-1;
 if ((fAlgorithmAmount-1)<Low(MultipleSignValues[0]))
    or ((fAlgorithmAmount-1)>High(MultipleSignValues[0])) then Exit;
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
   if fProblemAmount=MultipleSignN[i] then
           begin
             n_number:=i;
             Break;
           end;
 if n_number<0 then Exit;

 Result:=MultipleSignValues[n_number,(fAlgorithmAmount-1),p_number];

end;

procedure TMultipleSign.Rename;
begin
 fName:='MultipleSign';
end;

procedure TMultipleSign.Test(ControlAlgorithm: byte; Results: TVector;
                     p: double);
 var i:integer;
     d:TVector;
begin
 Results.Clear;
 if fError then Exit;
 if ControlAlgorithm>fAlgorithmAmount then Exit;

 for I := 1 to fAlgorithmAmount do
   if ControlAlgorithm<>i then Results.Add(i,0);

 d:=TVector.Create;

 for I := 0 to fAlgorithmAmount-1 do
  if ControlAlgorithm<>(i+1) then
   begin
    if fItIsError then
           begin
            fAlgorithmResult[i].CopyTo(d);
            d.DeltaY(fAlgorithmResult[ControlAlgorithm-1]);
           end   else
           begin
            fAlgorithmResult[ControlAlgorithm-1].CopyTo(d);
            d.DeltaY(fAlgorithmResult[i]);
           end;
//     showmessage(inttostr(i)+' '+d.XYtoString+' r-='+inttostr(d.NegativeInY)+' r+='+inttostr(d.PositiveInY));
     if d.NegativeInY<=Nmin(p)
         then Results.Y[i]:=1;
     if d.PositiveInY<=Nmin(p)
         then Results.Y[i]:=-1;
   end;
 FreeAndNil(d);

end;

{ TQuade }

constructor TQuade.Create(Arr: array of TVector; ItIsError: boolean);
 var tempV:TVectorTransform;
     i:Integer;
begin
 inherited Create(Arr, ItIsError);
 fQ:=TVectorTransform.Create;
 if fError then Exit;
 MinMaxValues(fAlgorithmResult,fQ);
 tempV:=TVectorTransform.Create;
 for I := 0 to fProblemAmount-1 do
   begin
//   showmessage('i='+inttostr(i)+' min='+floattostr(fQ.X[i])+' max='+floattostr(fQ.Y[i]));
   tempV.Add(i,fQ.Y[i]-fQ.X[i]);
//   showmessage('i='+inttostr(i)+' delta='+floattostr(tempV.Y[i]));
   end;
 tempV.Rank(fQ,True);
 for I := 0 to fProblemAmount-1 do
   begin
   fQ.X[i]:=fAlgorithmResult[0].X[i];
//   showmessage('i='+inttostr(i)+' Qi='+floattostr(fQ.Y[i]));
   end;

 FreeAndNil(tempV);
end;

destructor TQuade.Destroy;
begin
  FreeAndNil(fQ);
  inherited;
end;

function TQuade.NullhypothesisP: double;
 var stat:double;
begin
 result:=1;
 stat:=Self.Statistic;
 if stat<0 then Exit;
 try
 Result:=1-TFisherD.CDF(stat,fAlgorithmAmount-1,(fAlgorithmAmount-1)*(fProblemAmount-1));
 except

 end;
end;

procedure TQuade.Rename;
begin
 fName:='Quade';
end;

function TQuade.Sij(ProblemNumber, AlgorithmNumber: byte): double;
 var r:double;
begin
 Result:=-ErResult;
 r:=Rij(ProblemNumber, AlgorithmNumber);
 if (r<0)or fError then Exit;
// showmessage('R='+floattostr(r)+' Q='+floattostr(fQ.Y[ProblemNumber]));
 Result:=fQ.Y[ProblemNumber-1]*(r-(fAlgorithmAmount+1)/2.0);
end;

function TQuade.SjTotal(AlgorithmNumber: byte): double;
begin
 Result:=Total(AlgorithmNumber,Sij);
end;

function TQuade.StatisticFooter: double;
// const s:array [1..4] of double=(332, 11, 27.5, 293.5);
 var j:integer;
     A,B:double;
begin
  B:=0;
  for j := 1 to fAlgorithmAmount do B:=B+sqr(SjTotal(j));
  B:=B/fProblemAmount;
  A:=fProblemAmount*(fProblemAmount+1)*(2*fProblemAmount+1)
     *fAlgorithmAmount*(fAlgorithmAmount+1)*(fAlgorithmAmount-1)/72;

  try
   Result:=(fProblemAmount-1)*B/(A-B);
  except
   Result:=-1;
  end;

end;

function TQuade.Tj(AlgorithmNumber: byte): double;
 var w:double;
begin
 w:=WjTotal(AlgorithmNumber);
 if w<0 then
    begin
      Result:=-1;
      Exit;
    end;
 Result:=w*2/fProblemAmount/(fProblemAmount+1);
end;

function TQuade.Wij(ProblemNumber, AlgorithmNumber: byte): double;
 var r:double;
begin
 Result:=-1;
 r:=Rij(ProblemNumber, AlgorithmNumber);
 if (r<0)or fError then Exit;
 Result:=fQ.Y[ProblemNumber-1]*r;
end;

function TQuade.WjTotal(AlgorithmNumber: byte): double;
begin
 Result:=Total(AlgorithmNumber,Wij);
end;

function TQuade.ZvalueFooter(ControlAlgorithm,
  СomparisonAlgorithm: byte): double;
 var Ti,Tj:double;
begin
  Result:=-1;
  Ti:=Self.Tj(ControlAlgorithm);
//  Ti:=1.7231;
  if Ti<0 then Exit;
  Tj:=Self.Tj(СomparisonAlgorithm);
//  Tj:=2.48;
  if Tj<0 then Exit;
  Result:=(Tj-Ti)/sqrt(fAlgorithmAmount*(fAlgorithmAmount+1)
           *(2*fProblemAmount+1)*(fAlgorithmAmount-1)/18/fProblemAmount
           /(fProblemAmount+1));
//  Result:=1.314534;

end;

{ TMultipleComparisons }

constructor TMultipleComparisons.Create(Arr: array of TVector;
  ItIsError: boolean);
  var i,j{,k}:byte;
      p:double;

// const pFr:array [1..36] of double=(0.000006,0.000045,0.000108,
//  0.000332,0.001633,0.002313,0.003246,0.005294,
//  0.009823,0.014171,0.032109,0.03424,0.038867,
//  0.044015,0.052808,0.052808,0.063023,0.070701,
//  0.083642,0.141093,0.196706,0.255925,0.266889,
//  0.278172,0.3017,0.313946,0.326516,0.352622,0.394183,
//  0.40867,0.469706,0.518605,0.660706,0.796253,0.836354,
//  0.897279);

begin
 inherited Create(Arr,ItIsError);
 fPairAmount:=round(fAlgorithmAmount*(fAlgorithmAmount-1)/2);
 fp_unadj.Clear;
 for I := 1 to fAlgorithmAmount do
   for j := 1 to (i-1) do
    begin
     p:=UnadjustedP(i,j);
     if p<1 then fp_unadj.Add(p,i+IntToFrac(j))
            else fp_unadj.Add(UnadjustedP(j,i),j+IntToFrac(i));
    end;
 fp_unadj.Sorting();

 fShafferIndexValues:=TVector.Create;
 FillShafferIndexValues();
// showmessage(fShafferIndexValues.XYtoString);
// showmessage(fp_unadj.XYtoString+#10+inttostr(NumberInP_unadj(1,5))+#10+inttostr(NumberInP_unadj(5,1)));
// for I := 0 to fp_unadj.HighNumber do
//    fp_unadj.X[i]:=pFr[i+1];
// k:=0;
// for I := 1 to fAlgorithmAmount do
//   for j := 1 to (i-1) do
//    begin
//     fp_unadj.Y[k]:=i+IntToFrac(j);
//     inc(k);
//    end;
// showmessage(fp_unadj.XYtoString);

end;

destructor TMultipleComparisons.Destroy;
begin
  FreeAndNil(fShafferIndexValues);
  inherited;
end;

procedure TMultipleComparisons.FillShafferIndexValues;
  var S:array of TVector;
      i,j,m:word;
      Cj2:Int64;
begin
 if fAlgorithmAmount<2 then
     begin
     fShafferIndexValues.Add(0,0);
     Exit;
     end;
 SetLength(S,fAlgorithmAmount+1);
 for i := 0 to High(S) do
   S[i]:=TVector.Create;
 S[0].Add(0,0);
 S[1].Add(0,0);
 for I := 2 to fAlgorithmAmount do
   begin
     for j := 1 to i do
       begin
         Cj2:=NchooseK(j,2);
         for m := 0 to S[i-j].HighNumber do
           S[i].Add(Cj2+round(S[i-j].X[m]));
       end;
     S[i].DeleteDuplicate;
   end;
 S[fAlgorithmAmount].CopyTo(fShafferIndexValues);
 fShafferIndexValues.Sorting(False);
 for i := 0 to High(S) do
   FreeAndNil(S[i]);
end;

function TMultipleComparisons.MultipleHolmAPV(ControlAlgorithm,
  СomparisonAlgorithm: byte): double;
 var i:integer;
begin
 fhelpVector.Clear;
 for I := 0 to NumberInP_unadj(ControlAlgorithm,СomparisonAlgorithm) do
  fhelpVector.Add(i,(fPairAmount-i)*fp_unadj.X[i]);
 if fhelpVector.HighNumber<0
    then Result:=1
    else Result:=min(1,fhelpVector.MaxY);
end;

function TMultipleComparisons.MultipleNemenyi(ControlAlgorithm,
  СomparisonAlgorithm: byte): double;
 var i:integer;
begin
 i:=NumberInP_unadj(ControlAlgorithm,СomparisonAlgorithm);
 if i<0 then Result:=1
        else Result:=min(fPairAmount*fp_unadj.X[i],1);
end;

function TMultipleComparisons.MultipleShafferStaticAPV(ControlAlgorithm,
  СomparisonAlgorithm: byte): double;
 var i,j:integer;
begin
 j:= NumberInP_unadj(ControlAlgorithm,СomparisonAlgorithm);
 if j<0 then
   begin
     Result:=1;
     Exit;
   end;
 fhelpVector.Clear;
 for I := 0 to j do
  fhelpVector.Add(i,ShafferIndex(i)*fp_unadj.X[i]);
 Result:=min(1,fhelpVector.MaxY);
end;

function TMultipleComparisons.NumberInP_unadj(ControlAlgorithm,
  СomparisonAlgorithm: byte): integer;
 var i:byte;
begin
 Result:=-1;
 for I := 0 to fp_unadj.HighNumber do
  if (trunc(fp_unadj.Y[i])=ControlAlgorithm)
   and IsEqual(frac(fp_unadj.Y[i]),IntToFrac(СomparisonAlgorithm))
      then
       begin
        Result:=i;
        Break;
       end;
end;

procedure TMultipleComparisons.Rename;
begin
 fName:='MultipleComparisons';
end;

function TMultipleComparisons.ShafferIndex(j:integer): integer;
  var i:word;
begin
 Result:=0;
 if (j<0)or(j>(fPairAmount-1)) then  Exit;
 for I := 0 to fShafferIndexValues.HighNumber do
   if (fShafferIndexValues.X[i]<=(fPairAmount-j)) then
     begin
       Result:=round(fShafferIndexValues.X[i]);
       Break;
     end;
end;


Function AbetterBWilcoxon(A,B:TVector;ItIsError:boolean=True;p:double=0.05):boolean;
{функція, всередині якої створення екземпляру класу}
 var WT:TWilcoxonTest;
begin
 WT:=TWilcoxonTest.Create(A,B,ItIsError);
 Result:=WT.AbetterB(p);
 FreeAndNil(WT);
end;

Function AbetterBWilcoxon(A,B,MinMax:TVector;ItIsError:boolean=True;p:double=0.05):boolean;overload;
 var WT:TWilcoxonTest;
begin
 WT:=TWilcoxonTest.Create(A,B,ItIsError);
 Result:=WT.AbetterB(MinMax,p);
 FreeAndNil(WT);
end;


end.


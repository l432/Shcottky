unit HighResolutionTimer;
{стягнув з http://expert.delphi.int.ru/question/5313/}

interface
 
uses Windows;
 
type
  // --------------------- Класс - высокоточный таймер -------------------------
  THRTimer = class(TObject)
    constructor Create;
    function StartTimer: Boolean; // Обнуление таймера
    function ReadTimer: Double;   // Чтение значения таймера в миллисекундах
  private
    StartTime: Double;
    ClockRate: Double;
  public
    Exists: Boolean;    // Флаг успешного создания таймера
  end;

var
  Timer: THRTimer; // Глобальая переменная. Создаётся при запуске программы


{ Фукнция высокоточной задержки.
 Delphi:
   Синтаксис: function HRDelay(const Milliseconds: Double): Double;
   Milliseconds: Double - задержка в миллисекундах (может быть дробной)
   Результат функции - фактически произошедшая задержка с погрешностью.
   Пример вызова функции: X:= HRDelay(100.0); или HRDelay(100.0);
}

implementation


{ THRTimer }

constructor THRTimer.Create;
var
  QW: LARGE_INTEGER;
begin
  inherited Create;
  Exists := QueryPerformanceFrequency(Int64(QW));
  ClockRate := QW.QuadPart;
end;

function THRTimer.StartTimer: Boolean;
var
  QW: LARGE_INTEGER;
begin
  Result := QueryPerformanceCounter(Int64(QW));
  StartTime := QW.QuadPart;
end;

function THRTimer.ReadTimer: Double;
var
  ET: LARGE_INTEGER;
begin
  QueryPerformanceCounter(Int64(ET));
  Result := 1000.0 * (ET.QuadPart - StartTime) / ClockRate;
end;


initialization
  Timer:= THRTimer.Create();

finalization
  Timer.Free();
end.

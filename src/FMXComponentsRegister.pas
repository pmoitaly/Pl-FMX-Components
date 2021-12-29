unit FMXComponentsRegister;

interface


procedure Register;

implementation

uses
  System.Classes, pl.FMXClock;

procedure Register;
begin
  RegisterComponents('Pl Components', [TplFmxClock]);
end;

end.

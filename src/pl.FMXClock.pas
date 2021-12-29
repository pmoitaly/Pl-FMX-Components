{*****************************************************************************}
{       plFramework for Delphi FMX                                            }
{       Copyright (C) 2020 Paolo Morandotti                                   }
{       Unit pl.FMXClock                                                      }
{*****************************************************************************}
{                                                                             }
{Permission is hereby granted, free of charge, to any person obtaining        }
{a copy of this software and associated documentation files (the "Software"), }
{to deal in the Software without restriction, including without limitation    }
{the rights to use, copy, modify, merge, publish, distribute, sublicense,     }
{and/or sell copies of the Software, and to permit persons to whom the        }
{Software is furnished to do so, subject to the following conditions:         }
{                                                                             }
{The above copyright notice and this permission notice shall be included in   }
{all copies or substantial portions of the Software.                          }
{                                                                             }
{THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS      }
{OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  }
{FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  }
{AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER       }
{LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING      }
{FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS }
{IN THE SOFTWARE.                                                             }
{*****************************************************************************}
unit pl.FMXClock;

interface

uses
  System.SysUtils, System.Classes, System.UITypes, System.Generics.Collections,
  FMX.Types, FMX.Controls, FMX.Objects, FMX.Layouts, FMX.StdCtrls,
  pl.FMXComponents.Types, pl.FMXClock.Dots, pl.FMXClock.Hands,
  pl.FMXClock.DigitalClock, pl.FMXClock.AnalogClock;

type

  TplFmxClock = class(TCircle)
  private
    { Private declarations }
    FAnalogClock: TplAnalogClock;
    FDigitalClock: TplDigitalClock;
    FOnClockUpdate: TNotifyEvent;
    FOnClockStop: TNotifyEvent;
    FOnClockStart: TNotifyEvent;
    function GetActive: boolean;
    procedure SetActive(const Value: boolean);
    procedure SetupTimer;
  protected
    { Protected declarations }
    FTimer: TTimer;
    procedure Resize; override;
    procedure UpdateClock(Sender: TObject);
    procedure Start;
    procedure Stop;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property Active: boolean read GetActive write SetActive;
    property AnalogClock: TplAnalogClock read FAnalogClock write FAnalogClock;
    property DigitalClock: TplDigitalClock read FDigitalClock write FDigitalClock;
    property OnClockStart: TNotifyEvent read FOnClockStart write FOnClockStart;
    property OnClockStop: TNotifyEvent read FOnClockStop write FOnClockStop;
    property OnClockUpdate: TNotifyEvent read FOnClockUpdate write FOnClockUpdate;
  end;

implementation
uses
  System.Types, FMX.Styles, System.Math;
(*
{$IFDEF MACOS}
{$R *.mac.res}
{$ENDIF}
{$IFDEF ANDROID}
{$R *.android.res}
{$ENDIF}{$IFDEF MSWINDOWS}
{$R *.win.res}
{$ENDIF}
*)

{$REGION  'TplFmxClock'}

constructor TplFmxClock.Create(AOwner: TComponent);
begin
  inherited;
  FAnalogClock := TplAnalogClock.Create(Self);
  FDigitalClock := TplDigitalClock.Create(Self);
  FTimer := TTimer.Create(Self);
  SetupTimer;
  Width := 200;
  Height := 200;
end;

destructor TplFmxClock.Destroy;
begin
  FTimer.Enabled := False;
  FTimer.Free;
  FAnalogClock.Free;
  FDigitalClock.Free;
  inherited;
end;

function TplFmxClock.GetActive: boolean;
begin
  Result := FTimer.Enabled;
end;

procedure TplFmxClock.Resize;
begin
  FAnalogClock.Dots.AdaptSize(Self);
  FAnalogClock.Hands.AdaptSize(Self);
  inherited;
end;

procedure TplFmxClock.SetActive(const Value: boolean);
begin
  FTimer.Enabled := Value;
end;

procedure TplFmxClock.SetupTimer;
begin
  FTimer.Interval := 200;
  FTimer.OnTimer := UpdateClock;
end;

procedure TplFmxClock.Start;
begin
  if not Active then
    begin
      Active := True;
      if Assigned(FOnClockStart) then
        FOnClockStop(Self);
    end;
end;

procedure TplFmxClock.Stop;
begin
  if Active then
    begin
      Active := False;
      if Assigned(FOnClockStop) then
        FOnClockStop(Self);
    end;
end;

procedure TplFmxClock.UpdateClock(Sender: TObject);
begin
  FAnalogClock.UpdateTime;
  FDigitalClock.UpdateTime;
  if Assigned(FOnClockUpdate) then
    FOnClockUpdate(Sender);
end;
{$ENDREGION}


end.

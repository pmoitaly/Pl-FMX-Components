{*****************************************************************************}
{       plFramework for Delphi FMX                                            }
{       Copyright (C) 2020 Paolo Morandotti                                   }
{       Unit pl.FMXClock.AnalogClock                                          }
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
unit pl.FMXClock.AnalogClock;

interface

uses
  System.SysUtils, System.Classes, System.UITypes, System.Generics.Collections,
  FMX.Objects,
  pl.FMXClock.Dots, pl.FMXClock.Hands;

type
  TplAnalogClock = class(TPersistent)
  private
    FActive: boolean;
    FDots: TplDots;
    FHands: TplHands;
    procedure SetDots(const Value: TplDots);
    procedure SetHands(const Value: TplHands);
  public
    constructor Create(AOwner: TCircle);
    destructor Destroy; override;
    procedure ShowHours(const isVisible: boolean);
    procedure ShowMins(const isVisible: boolean);
    procedure ShowSecs(const isVisible: boolean);
    procedure UpdateTime;
  published
    { Published declarations }
    property Active: boolean read FActive write FActive;
    property Dots: TplDots read FDots write SetDots;
    property Hands: TplHands read FHands write SetHands;
  end;


implementation

uses
  pl.FMXComponents.Types;

{$REGION 'TAnalogClock' }

constructor TplAnalogClock.Create(AOwner: TCircle);
begin
  inherited Create;
  FDots := TplDots.Create(AOwner);
  FHands := TplHands.Create(AOwner);
end;

destructor TplAnalogClock.Destroy;
begin
  FDots.Free;
  FHands.Free;
  inherited;
end;

procedure TplAnalogClock.SetDots(const Value: TplDots);
begin
  FDots.Assign(Value);
end;

procedure TplAnalogClock.SetHands(const Value: TplHands);
begin
  FHands.Assign(Value);
end;

procedure TplAnalogClock.ShowHours(const isVisible: boolean);
begin
  FHands.Hand[hsHour].Visible := isVisible;
end;

procedure TplAnalogClock.ShowMins(const isVisible: boolean);
begin
  FHands.Hand[hsMinute].Visible := isVisible;
end;

procedure TplAnalogClock.ShowSecs(const isVisible: boolean);
begin
  FHands.Hand[hsSecond].Visible := isVisible;
end;

procedure TplAnalogClock.UpdateTime;
begin
  if FActive then
    FHands.RotateToTime;
end;

{$ENDREGION}

end.

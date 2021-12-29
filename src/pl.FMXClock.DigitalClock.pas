{*****************************************************************************}
{       plFramework for Delphi FMX                                            }
{       Copyright (C) 2020 Paolo Morandotti                                   }
{       Unit pl.FMXClock.DigitalClock                                         }
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
unit pl.FMXClock.DigitalClock;

interface

uses
  FMX.StdCtrls, System.Classes, FMX.Graphics, FMX.Objects, FMX.Types;

type


  TplDigitalClock = class(TPersistent)
  private
    FActive: boolean;
    FLabel: TLabel;
    FTimeFormat: string;
    FVisible: Boolean;
    function GetTextSettings: TTextSettings;
    function GetStyledSettings: TStyledSettings;
    procedure SetStyledSettings(const Value: TStyledSettings);
    procedure SetTextSettings(const Value: TTextSettings);
    procedure SetTimeFormat(const Value: string);
    procedure SetVisible(const Value: Boolean);
  public
    constructor Create(AOwner: TCircle);
    destructor Destroy; override;
    property ClockLabel: TLabel read FLabel write FLabel;
    procedure UpdateTime;
  published
    property Active: boolean read FActive write FActive;
    property StyledSettings: TStyledSettings read GetStyledSettings write SetStyledSettings;
    property TextSettings: TTextSettings read GetTextSettings write SetTextSettings;
    property TimeFormat: string read FTimeFormat write SetTimeFormat;
    property Visible: Boolean read FVisible write SetVisible;
  end;

implementation

uses
  System.SysUtils;

{ TClockLabel }

constructor TplDigitalClock.Create(AOwner: TCircle);
begin
  inherited Create;
  FTimeFormat := 'hh:mm:ss';
  FLabel := TLabel.Create(AOwner);
  FLabel.Stored := False;
  FLabel.Parent := AOwner;
  FLabel.Visible := Visible;
  FLabel.AutoSize := False;
  FLabel.Align := TAlignLayout.Client;
  FLabel.Name := 'lblInternalClock';
  FLabel.BringToFront;
  FLabel.TextSettings.HorzAlign := TTextAlign.Center;
  FLabel.Text := '00:00:00';
  FLabel.Align := TAlignLayout.Scale;
end;

destructor TplDigitalClock.Destroy;
begin
  FLabel.Free;
  inherited;
end;

function TplDigitalClock.GetStyledSettings: TStyledSettings;
begin
  Result := FLabel.StyledSettings;
end;

function TplDigitalClock.GetTextSettings: TTextSettings;
begin
  Result := FLabel.TextSettings;
end;

procedure TplDigitalClock.SetStyledSettings(const Value: TStyledSettings);
begin
  FLabel.StyledSettings := Value;
end;

procedure TplDigitalClock.SetTextSettings(const Value: TTextSettings);
begin
  FLabel.TextSettings.Assign(Value);
  FLabel.TextSettings.Font.Assign(Value.Font);
end;

procedure TplDigitalClock.SetTimeFormat(const Value: string);
begin
  if FTimeFormat <> Value then
    begin
      FTimeFormat := Value;
      UpdateTime;
    end;
end;

procedure TplDigitalClock.SetVisible(const Value: Boolean);
begin
Assert(Assigned(FLabel), 'FLabel not assigned in SetVisible procedure');
  if Value <> FVisible then
    begin
      FVisible := Value;
      FLabel.Align := TAlignLayout.Client;
      FLabel.Visible := Value;
      FLabel.Align := TAlignLayout.Scale;
    end;
end;

procedure TplDigitalClock.UpdateTime;
begin
  Assert(Assigned(FLabel), 'FLabel not assigned in UpdateTime procedure');
  if FActive then
    begin
      FLabel.Align := TAlignLayout.Client;
      FLabel.Text := FormatDateTime(FTimeFormat, Now());
      FLabel.Align := TAlignLayout.Scale;
    end;
end;

end.

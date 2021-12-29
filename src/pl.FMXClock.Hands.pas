{*****************************************************************************}
{       plFramework for Delphi FMX                                            }
{       Copyright (C) 2020 Paolo Morandotti                                   }
{       Unit pl.FMXClock.Hands                                                }
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
unit pl.FMXClock.Hands;

interface

uses
  System.Generics.Collections, System.Classes,
  FMX.Layouts, System.UITypes, FMX.Objects,
  pl.FMXComponents.Types;

type
  TplClockHand  = class(TPersistent)
  private
    FHandStyle: THandStyle;
    FHandLayout: TLayout;
    FHand: TRoundRect;
    FVScale: TplScaleRange;
    FHScale: Single;
    FMinWidth: Integer;
    function GetAlphaColor: TAlphaColor;
    procedure SetAlphaColor(const Value: TAlphaColor);
    procedure SetHandStyle(const Value: THandStyle);
    procedure SetHScale(const Value: Single);
    procedure SetVScale(const Value: TplScaleRange);
    procedure SetMinWidth(const Value: Integer);
    function GetVisible: Boolean;
    procedure SetVisible(const Value: Boolean);
  public
    constructor Create(AOwner: TLayout; AStyle: THandStyle); reintroduce; overload;
    destructor Destroy; override;
    procedure RotateToTime;
    procedure SetupPosition;
    property HandStyle: THandStyle read FHandStyle write SetHandStyle;
  published
    property Color: TAlphaColor read GetAlphaColor write SetAlphaColor;
    property HScale: Single read FHScale write SetHScale;
    property MinWidth: Integer read FMinWidth write SetMinWidth;
    property Visible: Boolean read GetVisible write SetVisible;
    property VScale: TplScaleRange read FVScale write SetVScale;
  end;

  TplHandsArray = array[hsHour..hsSecond] of TplClockHand;

  TplHands = class(TPersistent)
  strict private
    FHandsList: TplHandsArray;
    FHandsLayout: TLayout;
  private
    function GetHand(const Style: THandStyle): TplClockHand;
    procedure SetHoursHand(const Value: TplClockHand);
    procedure SetMinutesHand(const Value: TplClockHand);
    procedure SetSecondsHand(const Value: TplClockHand);
    function GetHoursHand: TplClockHand;
    function GetMinutesHand: TplClockHand;
    function GetSecondsHand: TplClockHand;
    function GetVisible: Boolean;
    procedure SetVisible(const Value: Boolean);
  public
    constructor Create(AOwner: TCircle); reintroduce; overload;
    destructor Destroy; override;
    property Hand[const Style: THandStyle]: TplClockHand read GetHand; default;
    property HandsLayout: TLayout read FHandsLayout;
    procedure AdaptSize(Sender: TObject);
    procedure RotateToTime;
  published
    property HoursHand: TplClockHand read GetHoursHand write SetHoursHand;
    property MinutesHand: TplClockHand read GetMinutesHand write SetMinutesHand;
    property SecondsHand: TplClockHand read GetSecondsHand write SetSecondsHand;
    property Visible: Boolean read GetVisible write SetVisible;
  end;

implementation

uses
  FMX.Types, System.SysUtils, System.Math, FMX.Controls;


{$REGION 'TplClockHand'}

constructor TplClockHand.Create(AOwner: TLayout; AStyle: THandStyle);
const
  HSCALES: array[hsHour..hsSecond] of Single = (0.05, 0.03, 0.01);
  VSCALES: array[hsHour..hsSecond] of TplScaleRange = (30, 40, 50);
  MINIMUMWIDTH: array[hsHour..hsSecond] of Integer = (5,3,1);
  DEFAULTCOLORS: array[hsHour..hsSecond] of TAlphaColor = (TAlphaColors.Orangered, TAlphaColors.Salmon, TAlphaColors.Snow);
  DEFAULTNAMES: array[hsHour..hsSecond] of string = ('hndHour', 'hndMinute', 'hndSecond');
begin
    inherited Create;
  FHScale := HSCALES[AStyle];
  FVScale := VSCALES[AStyle];
  FMinWidth := MINIMUMWIDTH[AStyle];
  FHandLayout := TLayout.Create(AOwner);
  FHandLayout.Name := DEFAULTNAMES[AStyle];
  FHandLayout.Stored := False;
  FHandLayout.Parent := AOwner;

  FHand := TRoundRect.Create(FHandLayout);
  Color := DEFAULTCOLORS[AStyle];
  SetHandStyle(AStyle);
  FHand.Parent := FHandLayout;
  FHand.Stored := False;
  FHandLayout.Align := TAlignLayout.HorzCenter;
  FHandLayout.Size.PlatformDefault := False;
end;

destructor TplClockHand.Destroy;
begin
  FHand.Free;
  FHandLayout.Free;
  inherited;
end;

function TplClockHand.GetAlphaColor: TAlphaColor;
begin
  Result := FHand.Fill.Color;
end;

function TplClockHand.GetVisible: Boolean;
begin
  Result := FHandLayout.Visible;
end;

procedure TplClockHand.RotateToTime;
begin
  case HandStyle of
    hsHour: FHandLayout.RotationAngle := (30 * StrToInt(FormatDateTime('h', now))) + ( 6 * (StrToInt(FormatDateTime('n', now))/12));
    hsMinute: FHandLayout.RotationAngle := 6 * StrToInt(FormatDateTime('n', now));
    hsSecond: FHandLayout.RotationAngle := 6 * StrToInt(FormatDateTime('ss', now));
  end;
end;

procedure TplClockHand.SetAlphaColor(const Value: TAlphaColor);
begin
  FHand.Fill.Color := Value;
  FHand.Stroke.Color := Value;
end;

procedure TplClockHand.SetHandStyle(const Value: THandStyle);
begin
  if FHandStyle <> Value then
    begin
      FHandStyle := Value;
      SetupPosition;
    end;
end;

procedure TplClockHand.SetHScale(const Value: Single);
begin
  FHScale := Value;
  SetupPosition;
end;

procedure TplClockHand.SetMinWidth(const Value: Integer);
begin
  FMinWidth := Value;
  SetupPosition;
end;

procedure TplClockHand.SetupPosition;
var
  aParent: TCircle;
  baseHeight: integer;
  newWidth: integer;
begin
  // reset margins and height
  aParent := TCircle(FHandLayout.Parent);
  baseHeight := Trunc(aParent.Height);
  FHandLayout.Height := baseHeight;
  newWidth := Trunc(aParent.Width * FHScale);
  FHandLayout.Width := Max(newWidth, FMinWidth);
  FHand.Height := baseHeight*FVscale/100;
  FHand.Align := TAlignLayout.Bottom;
  FHand.Margins.Bottom := Trunc(baseHeight / 2);
end;
procedure TplClockHand.SetVisible(const Value: Boolean);
begin
  FHandLayout.Visible := Value;
end;

procedure TplClockHand.SetVScale(const Value: TplScaleRange);
begin
  FVScale := Value;
  SetupPosition;
end;

{$ENDREGION}

{$REGION 'TplHands'}
procedure TplHands.AdaptSize(Sender: TObject);
var
  i: THandStyle;
  aParent: TControl;
begin
  aParent := TControl(FHandsLayout.Parent);
  FHandsLayout.Height := Min(aParent.Width, aParent.Height);
  if aParent.Height > aParent.Width then
    FHandsLayout.Align := TAlignLayout.VertCenter
  else
    FHandsLayout.Align := TAlignLayout.HorzCenter;

  for i := Low(THandStyle) to High(THandStyle) do
    FHandsList[i].SetupPosition;
end;

constructor TplHands.Create(AOwner: TCircle);
begin
  inherited Create;
  FHandsLayout := TLayout.Create(AOwner);
  FHandsLayout.Stored := False;
  FHandsLayout.Parent := AOwner;
  FHandsLayout.Align := TAlignLayout.Client;
{ TODO 1 -oPMo -cRefactoring : OnResized on Tokyo and above? }
  {FHandsLayout.OnResized := AdaptSize;}
  FHandsLayout.OnResize := AdaptSize;
  FHandsList[hsHour] := TplClockHand.Create(FHandsLayout, hsHour);
  FHandsList[hsMinute] := TplClockHand.Create(FHandsLayout, hsMinute);
  FHandsList[hsSecond] := TplClockHand.Create(FHandsLayout, hsSecond);
  RotateToTime;
end;

destructor TplHands.Destroy;
var
  i: THandStyle;
begin
  for i := Low(THandStyle) to High(THandStyle) do
    FHandsList[i].Free;
  inherited;
end;

function TplHands.GetHand(const Style: THandStyle): TplClockHand;
begin
  Result := FHandsList[Style];
end;

function TplHands.GetHoursHand: TplClockHand;
begin
  Result := GetHand(hsHour);
end;

function TplHands.GetMinutesHand: TplClockHand;
begin
  Result := GetHand(hsMinute) ;
end;

function TplHands.GetSecondsHand: TplClockHand;
begin
  Result := GetHand(hsSecond);
end;

function TplHands.GetVisible: Boolean;
begin
  Result := FHandsList[hsHour].Visible;
end;

procedure TplHands.RotateToTime;
var
  i: THandStyle;
begin
  for i := Low(THandStyle) to High(THandStyle) do
    FHandsList[i].RotateToTime;
end;
procedure TplHands.SetHoursHand(const Value: TplClockHand);
begin
  FHandsList[hsHour] := Value;
end;

procedure TplHands.SetMinutesHand(const Value: TplClockHand);
begin
  FHandsList[hsMinute] := Value;
end;

procedure TplHands.SetSecondsHand(const Value: TplClockHand);
begin
  FHandsList[hsSecond] := Value;
end;

procedure TplHands.SetVisible(const Value: Boolean);
var
  hand: THandStyle;
begin
  for hand := hsHour to hsSecond do
    FHandsList[hand].Visible := Value;
end;

{$ENDREGION}


end.

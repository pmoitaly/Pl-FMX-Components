{*****************************************************************************}
{       plFramework for Delphi FMX                                            }
{       Copyright (C) 2020 Paolo Morandotti                                   }
{       Unit pl.FMXClock.Dots                                                 }
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
unit pl.FMXClock.Dots;

interface

uses
  System.Generics.Collections, System.Classes,
  FMX.Layouts, System.UITypes, FMX.Objects,
  pl.FMXComponents.Types;

type
  TplClockDot = class(TLayout)
  private
    FDot: TCircle;
    FWidthAutoScale: TplScaleRange;
    function GetAlphaColor: TAlphaColor;
    procedure ScaleDot;
    procedure SetAlphaColor(const Value: TAlphaColor);
    procedure SetWidthAutoScale(const Value: TplScaleRange);
  public
    constructor Create(AOwner: TLayout; AColor: TAlphaColor; AScale: TplScaleRange); reintroduce; overload;
    destructor Destroy; override;
    property Color: TAlphaColor read GetAlphaColor write SetAlphaColor;
    property Dot: TCircle read FDot;
    property WidthAutoScale: TplScaleRange read FWidthAutoScale write SetWidthAutoScale;
  end;

  TplDots = class(TPersistent)
  private
    FDotList: TList<TplClockDot>;
    FDotsLayer: TLayout;
    FColor: TAlphaColor;
    FCurrentColor: TAlphaColor;
    FCurrentMinute: Integer;
    FExtraTimeColor: TAlphaColor;
    FExtraTimeLenght: Integer;
    FFutureColor: TAlphaColor;
    FHideUnusedDots: boolean;
    FPastColor: TAlphaColor;
    FPeriodLenght: Integer;
    FDotsScale: TplScaleRange;
    procedure ColorDot(const ADot: TplClockDot; const AColor: TAlphaColor; const Hide: Boolean);
    procedure ColorDots;
    function GetVisible: Boolean;
    procedure ScaleDots;
    procedure SetColor(const Value: TAlphaColor);
    procedure SetCurrentColor(const Value: TAlphaColor);
    procedure SetCurrentMinute(const Value: Integer);
    procedure SetDotsScale(const Value: TplScaleRange);
    procedure SetFutureColor(const Value: TAlphaColor);
    procedure SetPastColor(const Value: TAlphaColor);
    procedure SetPeriodLenght(const Value: Integer);
    procedure SetExtraTimeColor(const Value: TAlphaColor);
    procedure SetExtraTimeLenght(const Value: Integer);
    procedure SetHideUnusedDots(const Value: boolean);
    procedure SetupDots;
    procedure SetVisible(const Value: Boolean);
  protected
    property Dots: TList<TplClockDot> read FDotList;
  public
    constructor Create(AOwner: TCircle); reintroduce; overload;
    destructor Destroy; override;
    property DotsLayer: TLayout read FDotsLayer;
    procedure AdaptSize(Sender: TObject);
  published
    property Color: TAlphaColor read FColor write SetColor;
    property CurrentColor: TAlphaColor read FCurrentColor write SetCurrentColor;
    property CurrentMinute: Integer read FCurrentMinute write SetCurrentMinute;
    property DotsScale: TplScaleRange read FDotsScale write SetDotsScale;
    property ExtraTimeColor: TAlphaColor read FExtraTimeColor write SetExtraTimeColor;
    property ExtraTimeLenght: Integer read FExtraTimeLenght write SetExtraTimeLenght;
    property FutureColor: TAlphaColor read FFutureColor write SetFutureColor;
    property HideUnusedDots: boolean read FHideUnusedDots write SetHideUnusedDots;
    property PastColor: TAlphaColor read FPastColor write SetPastColor;
    property PeriodLenght: Integer read FPeriodLenght write SetPeriodLenght;
    property Visible: Boolean read GetVisible write SetVisible;
  end;


implementation

uses
  FMX.Types, System.Math, FMX.Controls;

{$REGION 'TplClockDot'}

constructor TplClockDot.Create(AOwner: TLayout; AColor: TAlphaColor; AScale: TplScaleRange);
begin
  inherited Create(AOwner.Owner);
  Parent := AOwner;
  FDot := TCircle.Create(Self);
  FDot.Parent := Self;
  FDot.Stored := False;
  Align := TAlignLayout.HorzCenter;
  Color := AColor;
  Stored := False;
  WidthAutoScale := AScale;
  {To place dots within the circle}
// Layers outside the Circle if: Anchors := [TAnchorKind.akLeft,TAnchorKind.akTop,TAnchorKind.akRight,TAnchorKind.akBottom];
// Dots no more centered if:  Align := TAlignLayout.Scale;
//  Align := TAlignLayout.Scale;

end;

destructor TplClockDot.Destroy;
begin
  FDot.Free;
  inherited;
end;

function TplClockDot.GetAlphaColor: TAlphaColor;
begin
  Result := FDot.Fill.Color;
end;

procedure TplClockDot.ScaleDot;
var
  aParent: TCircle;
begin
  aParent := TCircle(Owner);
  Width := trunc(Min(aParent.Width, aParent.Height) / FWidthAutoScale);
  if Width < 3  then
     Width := 3;
  FDot.Height := Width;
  FDot.Width := Width;
  FDot.Align := TAlignLayout.Top;
//  FDot.Align := TAlignLayout.Scale;
end;

procedure TplClockDot.SetAlphaColor(const Value: TAlphaColor);
begin
  FDot.Fill.Color := Value;
  FDot.Stroke.Color := Value;
end;

procedure TplClockDot.SetWidthAutoScale(const Value: TplScaleRange);
begin
  if FWidthAutoScale <> Value then
    begin
      FWidthAutoScale := Value;
      ScaleDot;
    end;
end;

{$ENDREGION}

{$REGION 'TplDots'}
procedure TplDots.AdaptSize(Sender: TObject);
var
  dot: TplClockDot;
  aParent: TControl;
begin
  aParent := TControl(FDotsLayer.Parent);
  FDotsLayer.Height := Min(aParent.Width, aParent.Height);
  if aParent.Height > aParent.Width then
      FDotsLayer.Align := TAlignLayout.VertCenter
  else
      FDotsLayer.Align := TAlignLayout.HorzCenter;

  if Assigned(FDotList) then
    for dot in FDotList do
      dot.ScaleDot;
end;

procedure TplDots.ColorDot(const ADot: TplClockDot; const AColor: TAlphaColor;
  const Hide: Boolean);
begin
  ADot.Color := AColor;
  ADot.Visible := not Hide;
end;

procedure TplDots.ColorDots;
var
  i: Integer;
begin
  if FCurrentMinute > -1 then
    begin
      for i := 0 to FCurrentMinute - 1 do
        ColorDot(FDotList[i], FPastColor, False);
      for i := FCurrentMinute + 1 to FPeriodLenght - 1 do
        ColorDot(FDotList[i], FFutureColor, False);
      for i := FPeriodLenght to FPeriodLenght + FExtraTimeLenght - 1 do
        ColorDot(FDotList[i], FExtraTimeColor, False);
      ColorDot(FDotList[FCurrentMinute], FCurrentColor, False);
    end;
  for i := FPeriodLenght + FExtraTimeLenght + 1 to FDotList.Count - 1 do
     ColorDot(FDotList[i], FColor, (FHideUnusedDots and(FCurrentMinute > -1)));
end;

constructor TplDots.Create(AOwner: TCircle);
begin
  inherited Create;
  FDotsLayer := TLayout.Create(AOwner);
  FDotsLayer.Stored := False;
{ TODO 1 -oPMo -cRefactoring : OnResized on Tokyo and above? }
  {FDotsLayer.OnResized := AdaptSize;}
  FDotsLayer.OnResize := AdaptSize;
  FDotsScale := 100;

  FDotsLayer.Parent := AOwner;
  FDotsLayer.Align := TAlignLayout.Client;

  FCurrentMinute := -1;
  FPeriodLenght := 0;
  FDotList := TList<TplClockDot>.Create;
  SetupDots;
end;

destructor TplDots.Destroy;
begin
  FDotList.Free;
  FDotsLayer.Free;
  inherited;
end;

function TplDots.GetVisible: Boolean;
begin
  Result := FDotsLayer.Visible;
end;

procedure TplDots.ScaleDots;
var
  i: integer;
begin
  for i := Low(TMinutesRange) to High(TMinutesRange) do
    FDotList[i].WidthAutoScale := DotsScale;
end;

procedure TplDots.SetColor(const Value: TAlphaColor);
begin
  if FColor <> Value then
    begin
      FColor := Value;
      ColorDots;
    end;
end;

procedure TplDots.SetCurrentColor(const Value: TAlphaColor);
begin
  if FCurrentColor <> Value then
    begin
      FCurrentColor := Value;
      ColorDots;
    end;
end;

procedure TplDots.SetCurrentMinute(const Value: Integer);
begin
  if FCurrentMinute <> Value then
    begin
      FCurrentMinute := Value mod 60;
      ColorDots;
    end;
end;

procedure TplDots.SetExtraTimeColor(const Value: TAlphaColor);
begin
  if FExtraTimeColor <> Value then
    begin
      FExtraTimeColor := Value;
      ColorDots;
    end;
end;

procedure TplDots.SetExtraTimeLenght(const Value: Integer);
begin
  if FExtraTimeLenght <> Value then
    begin
      FExtraTimeLenght := Value;
      ColorDots;
    end;
end;

procedure TplDots.SetFutureColor(const Value: TAlphaColor);
begin
  if FFutureColor <> Value then
    begin
      FFutureColor := Value;
      ColorDots;
    end;
end;

procedure TplDots.SetHideUnusedDots(const Value: boolean);
begin
  if FHideUnusedDots <> Value then
    begin
      FHideUnusedDots := Value;
      ColorDots;
    end;
end;

procedure TplDots.SetPastColor(const Value: TAlphaColor);
begin
  if FPastColor <> Value then
    begin
      FPastColor := Value;
      ColorDots;
    end;
end;

procedure TplDots.SetPeriodLenght(const Value: Integer);
begin
  if FPeriodLenght <> Value then
    begin
      FPeriodLenght := Value;
      ColorDots;
    end;
end;

procedure TplDots.SetDotsScale(const Value: TplScaleRange);
begin
  if FDotsScale <> Value then
    begin
      FDotsScale := Value;
      ScaleDots;
    end;
end;

procedure TplDots.SetupDots;
const
  SECS = 59;
var
  i: TMinutesRange;
begin
  FDotList.Capacity := SECS;
  for i := Low(TMinutesRange) to High(TMinutesRange) do
    begin
      FDotList.Add(TplClockDot.Create(FDotsLayer, FColor, FDotsScale));
      FDotList[i].RotationAngle := 6 * i;
    end;
end;

procedure TplDots.SetVisible(const Value: Boolean);
begin
  FDotsLayer.Visible := Value;
end;

{$ENDREGION}

end.

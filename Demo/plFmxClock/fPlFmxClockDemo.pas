{*****************************************************************************}
{       plFramework for Delphi FMX                                            }
{       Copyright (C) 2021 Paolo Morandotti                                   }
{       Unit fPlFmxClockDemo                                                  }
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
unit fPlFmxClockDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.TabControl,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects,
  FMX.Colors, FMX.Layouts, FMX.Edit, FMX.EditBox, FMX.SpinBox,
  FMX.ListBox,
  pl.FMXClock;

type
  TfrmPlFmxClockDemo = class(TForm)
    HeaderToolBar: TToolBar;
    TabControl1: TTabControl;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    ccbDots: TComboColorBox;
    ccbFutureColor: TComboColorBox;
    ccbPastColor: TComboColorBox;
    ccbPresentColor: TComboColorBox;
    chkDotsShow: TCheckBox;
    chkHideUnusedDots: TCheckBox;
    lblDotColor: TLabel;
    lblFutureColor: TLabel;
    lblPastColor: TLabel;
    lblPeriod: TLabel;
    lblPresentColor: TLabel;
    lblCurrentMinute: TLabel;
    pnlClock: TPanel;
    spbCurrentMinute: TSpinBox;
    spbPeriod: TSpinBox;
    tbiAnalogClock: TTabItem;
    lblTitle: TLabel;
    lblExtraTime: TLabel;
    spbExtraTime: TSpinBox;
    lblExtraTimeColor: TLabel;
    ccbExtraTimeColor: TComboColorBox;
    MixedClock: TplFmxClock;
    rct2: TRectangle;
    tbiDigitalClock: TTabItem;
    pclAnalog: TplFmxClock;
    chkShowHours: TCheckBox;
    chkActive: TCheckBox;
    chkShowMinutes: TCheckBox;
    chkShowSeconds: TCheckBox;
    tbrScale: TTrackBar;
    procedure FormCreate(Sender: TObject);
    procedure FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure chkDotsShowChange(Sender: TObject);
    procedure ccbDotsChange(Sender: TObject);
    procedure ccbPastColorChange(Sender: TObject);
    procedure ccbFutureColorChange(Sender: TObject);
    procedure ccbPresentColorChange(Sender: TObject);
    procedure chkHideUnusedDotsChange(Sender: TObject);
    procedure spbPeriodChange(Sender: TObject);
    procedure spbCurrentMinuteChange(Sender: TObject);
    procedure spbExtraTimeChange(Sender: TObject);
    procedure ccbExtraTimeColorChange(Sender: TObject);
    procedure MixedClockClockUpdate(Sender: TObject);
    procedure chkShowHoursChange(Sender: TObject);
    procedure chkShowMinutesChange(Sender: TObject);
    procedure chkShowSecondsChange(Sender: TObject);
    procedure chkActiveChange(Sender: TObject);
    procedure tbrScaleChange(Sender: TObject);
  private
    { Private declarations }
    procedure SetupClockTab;
  public
    { Public declarations }
  end;

var
  frmPlFmxClockDemo: TfrmPlFmxClockDemo;

implementation

uses
  System.DateUtils,
  pl.FMXComponents.Types;
{$R *.fmx}

procedure TfrmPlFmxClockDemo.MixedClockClockUpdate(Sender: TObject);
var
  second: Integer;
begin
  second := (SecondOf(Now())) mod 60;
  MixedClock.AnalogClock.Dots.PeriodLenght := second;
  MixedClock.AnalogClock.Dots.CurrentMinute := second;
end;

procedure TfrmPlFmxClockDemo.ccbDotsChange(Sender: TObject);
begin
  pclAnalog.AnalogClock.Dots.Color := ccbDots.Color;
end;

procedure TfrmPlFmxClockDemo.ccbExtraTimeColorChange(Sender: TObject);
begin
  pclAnalog.AnalogClock.Dots.ExtraTimeColor := ccbExtraTimeColor.Color;
end;

procedure TfrmPlFmxClockDemo.ccbFutureColorChange(Sender: TObject);
begin
  pclAnalog.AnalogClock.Dots.FutureColor := ccbFutureColor.Color;
end;

procedure TfrmPlFmxClockDemo.ccbPastColorChange(Sender: TObject);
begin
  pclAnalog.AnalogClock.Dots.PastColor := ccbPastColor.Color;
end;

procedure TfrmPlFmxClockDemo.ccbPresentColorChange(Sender: TObject);
begin
  pclAnalog.AnalogClock.Dots.CurrentColor := ccbPresentColor.Color;
end;

procedure TfrmPlFmxClockDemo.chkActiveChange(Sender: TObject);
begin
  pclAnalog.AnalogClock.Active := chkActive.IsChecked;
end;

procedure TfrmPlFmxClockDemo.chkDotsShowChange(Sender: TObject);
begin
  pclAnalog.AnalogClock.Dots.Visible := chkDotsShow.IsChecked;
end;

procedure TfrmPlFmxClockDemo.chkHideUnusedDotsChange(Sender: TObject);
begin
  pclAnalog.AnalogClock.Dots.HideUnusedDots := chkHideUnusedDots.IsChecked;
end;

procedure TfrmPlFmxClockDemo.chkShowHoursChange(Sender: TObject);
begin
  pclAnalog.AnalogClock.ShowHours(chkShowHours.IsChecked);
end;

procedure TfrmPlFmxClockDemo.chkShowMinutesChange(Sender: TObject);
begin
  pclAnalog.AnalogClock.ShowMins(chkShowMinutes.IsChecked);
end;

procedure TfrmPlFmxClockDemo.chkShowSecondsChange(Sender: TObject);
begin
  pclAnalog.AnalogClock.ShowSecs(chkShowSeconds.IsChecked);
end;

procedure TfrmPlFmxClockDemo.FormCreate(Sender: TObject);
begin
  { This defines the default active tab at runtime }
  TabControl1.ActiveTab := tbiAnalogClock;
   SetupClockTab;
end;

procedure TfrmPlFmxClockDemo.FormGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
{$IFDEF ANDROID}
  case EventInfo.GestureID of
    sgiLeft:
    begin
      if TabControl1.ActiveTab <> TabControl1.Tabs[TabControl1.TabCount-1] then
        TabControl1.ActiveTab := TabControl1.Tabs[TabControl1.TabIndex+1];
      Handled := True;
    end;

    sgiRight:
    begin
      if TabControl1.ActiveTab <> TabControl1.Tabs[0] then
        TabControl1.ActiveTab := TabControl1.Tabs[TabControl1.TabIndex-1];
      Handled := True;
    end;
  end;
{$ENDIF}
end;

procedure TfrmPlFmxClockDemo.SetupClockTab;
begin
  chkDotsShow.IsChecked := True;
  chkHideUnusedDots.IsChecked := False;
  ccbDots.Color := TAlphaColors.Snow;
  ccbFutureColor.Color := TAlphaColors.Blue;
  ccbPresentColor.Color := TAlphaColors.Green;
  ccbPastColor.Color := TAlphaColors.Red;
end;

procedure TfrmPlFmxClockDemo.spbCurrentMinuteChange(Sender: TObject);
begin
  pclAnalog.AnalogClock.Dots.CurrentMinute := Trunc(spbCurrentMinute.Value);
end;

procedure TfrmPlFmxClockDemo.spbExtraTimeChange(Sender: TObject);
begin
  pclAnalog.AnalogClock.Dots.ExtraTimeLenght := Trunc(spbExtraTime.Value);
end;

procedure TfrmPlFmxClockDemo.spbPeriodChange(Sender: TObject);
begin
  pclAnalog.AnalogClock.Dots.PeriodLenght := Trunc(spbPeriod.Value);
end;

procedure TfrmPlFmxClockDemo.tbrScaleChange(Sender: TObject);
begin
   pclAnalog.AnalogClock.Dots.DotsScale := Trunc(tbrScale.Value);
end;

end.

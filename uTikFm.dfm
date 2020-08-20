object TikFm: TTikFm
  Left = 195
  Top = 107
  Width = 719
  Height = 554
  Caption = #1058#1080#1082#1086#1074#1099#1081' '#1075#1088#1072#1092#1080#1082
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Chart1: TChart
    Left = 0
    Top = 0
    Width = 1017
    Height = 188
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Text.Strings = (
      'TChart')
    Title.Visible = False
    Legend.Visible = False
    View3D = False
    BevelOuter = bvNone
    TabOrder = 0
    object Series1: TFastLineSeries
      Marks.ArrowLength = 8
      Marks.Visible = False
      SeriesColor = clRed
      LinePen.Color = clRed
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Y'
      YValues.Multiplier = 1
      YValues.Order = loNone
    end
  end
  object Chart2: TChart
    Left = 8
    Top = 384
    Width = 704
    Height = 68
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Text.Strings = (
      'TChart')
    Title.Visible = False
    Legend.Visible = False
    View3D = False
    BevelOuter = bvNone
    TabOrder = 1
    object Series2: TPointSeries
      Marks.ArrowLength = 0
      Marks.Frame.Visible = False
      Marks.Visible = False
      SeriesColor = clRed
      Pointer.HorizSize = 2
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.VertSize = 2
      Pointer.Visible = True
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Y'
      YValues.Multiplier = 1
      YValues.Order = loNone
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 473
    Width = 1017
    Height = 19
    Panels = <
      item
        Width = 300
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object MainMenu1: TMainMenu
    Left = 312
    Top = 8
    object Createpipe1: TMenuItem
      Caption = 'Create pipe'
      object GAZR1: TMenuItem
        Caption = 'GAZR'
        OnClick = GAZR1Click
      end
      object SBRF1: TMenuItem
        Caption = 'SBRF'
        OnClick = SBRF1Click
      end
    end
    object Loaddata1: TMenuItem
      Caption = 'Load data'
      object Start1: TMenuItem
        Caption = 'Start'
        OnClick = Start1Click
      end
      object Stop1: TMenuItem
        Caption = 'Stop'
        OnClick = Stop1Click
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 680
    Top = 656
  end
end

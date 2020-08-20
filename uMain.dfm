object Form1: TForm1
  Left = 272
  Top = 146
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'AskChart'
  ClientHeight = 484
  ClientWidth = 661
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 544
    Top = 272
    Width = 32
    Height = 13
    Caption = 'Label1'
    Visible = False
  end
  object Label2: TLabel
    Left = 544
    Top = 296
    Width = 32
    Height = 13
    Caption = 'Label2'
    Visible = False
  end
  object Button1: TButton
    Left = 576
    Top = 280
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 576
    Top = 320
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 1
    Visible = False
    OnClick = Button2Click
  end
  object Chart1: TChart
    Left = 8
    Top = 8
    Width = 521
    Height = 337
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Text.Strings = (
      'TChart')
    Title.Visible = False
    Legend.Visible = False
    View3D = False
    View3DWalls = False
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object Series1: TPointSeries
      Marks.ArrowLength = 8
      Marks.Visible = False
      SeriesColor = clRed
      ValueFormat = '#,##0.#####'
      Pointer.Brush.Color = 16711808
      Pointer.HorizSize = 2
      Pointer.InflateMargins = True
      Pointer.Pen.Visible = False
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
    object Series2: TFastLineSeries
      Marks.ArrowLength = 8
      Marks.Visible = False
      SeriesColor = 4227327
      ValueFormat = '#,##0.#####'
      LinePen.Color = 4227327
      LinePen.Width = 2
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Y'
      YValues.Multiplier = 1
      YValues.Order = loNone
    end
    object Series3: TLineSeries
      Marks.ArrowLength = 8
      Marks.Visible = False
      SeriesColor = clGreen
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Y'
      YValues.Multiplier = 1
      YValues.Order = loNone
    end
    object Series4: TLineSeries
      Marks.ArrowLength = 8
      Marks.Visible = False
      SeriesColor = clYellow
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
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
  object Button3: TButton
    Left = 576
    Top = 192
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 3
    Visible = False
    OnClick = Button3Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 352
    Width = 401
    Height = 113
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object CheckBox1: TCheckBox
    Left = 424
    Top = 360
    Width = 129
    Height = 17
    Caption = #1042#1099#1095#1080#1089#1083#1103#1090#1100' '#1087#1086#1083#1080#1085#1086#1084'.'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object Button4: TButton
    Left = 576
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Modeling'
    TabOrder = 6
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 576
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Button5'
    TabOrder = 7
    Visible = False
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 576
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Button6'
    TabOrder = 8
    Visible = False
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 576
    Top = 96
    Width = 75
    Height = 25
    Caption = 'FX.terminal'
    TabOrder = 9
    OnClick = Button7Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 465
    Width = 661
    Height = 19
    Panels = <
      item
        Width = 130
      end
      item
        Width = 80
      end
      item
        Width = 120
      end
      item
        Width = 120
      end
      item
        Width = 120
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object Demo: TCheckBox
    Left = 560
    Top = 424
    Width = 97
    Height = 17
    Caption = 'Slow demo'
    TabOrder = 11
    Visible = False
    OnClick = DemoClick
  end
  object CheckBox2: TCheckBox
    Left = 424
    Top = 384
    Width = 97
    Height = 17
    Caption = 'Real-time demo'
    Checked = True
    State = cbChecked
    TabOrder = 12
  end
  object CheckBox3: TCheckBox
    Left = 424
    Top = 408
    Width = 97
    Height = 17
    Caption = #1042#1080#1079#1091#1072#1083#1080#1079#1072#1094#1080#1103
    TabOrder = 13
  end
  object Button8: TButton
    Left = 576
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Button8'
    TabOrder = 14
    Visible = False
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 440
    Top = 432
    Width = 75
    Height = 25
    Caption = #1058#1080#1082#1086#1074#1099#1081' '#1075#1088'.'
    TabOrder = 15
    OnClick = Button9Click
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 60
    OnTimer = Timer1Timer
    Left = 568
    Top = 56
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 47
    OnTimer = Timer2Timer
    Left = 616
    Top = 56
  end
  object Timer3: TTimer
    Enabled = False
    OnTimer = Timer3Timer
    Left = 576
    Top = 384
  end
end

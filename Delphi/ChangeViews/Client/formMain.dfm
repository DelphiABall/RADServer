object Form1: TForm1
  Left = 0
  Top = 0
  Margins.Left = 6
  Margins.Top = 6
  Margins.Right = 6
  Margins.Bottom = 6
  Caption = 'Form1'
  ClientHeight = 943
  ClientWidth = 1274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -24
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 192
  DesignSize = (
    1274
    943)
  TextHeight = 32
  object Label1: TLabel
    Left = 0
    Top = 145
    Width = 1274
    Height = 32
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Align = alTop
    Caption = 'Stats'
    ExplicitWidth = 50
  end
  object Label2: TLabel
    Left = 24
    Top = 628
    Width = 295
    Height = 32
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Caption = 'Sessions Lifespan (Seconds)'
  end
  object MemoStatus: TMemo
    Left = 0
    Top = 177
    Width = 1274
    Height = 376
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Align = alTop
    Lines.Strings = (
      'MemoStatus')
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1274
    Height = 145
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Button1: TButton
      Left = 24
      Top = 33
      Width = 233
      Height = 81
      Caption = 'Button1'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object seLifeSpanSeconds: TSpinEdit
    Left = 416
    Top = 625
    Width = 185
    Height = 43
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    MaxValue = 3600
    MinValue = 5
    TabOrder = 2
    Value = 60
  end
  object btnSweep: TButton
    Left = 24
    Top = 688
    Width = 577
    Height = 95
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Anchors = [akTop, akRight]
    Caption = 'Sweep'
    TabOrder = 3
    OnClick = btnSweepClick
  end
  object EMSEdgeService1: TEMSEdgeService
    ModuleName = 'ChangeViewsDemo'
    ModuleVersion = '1'
    Provider = EMSProvider1
    ListenerProtocol = 'http'
    ListenerService.Port = 8888
    ListenerService.Host = 'localhost'
    Left = 1000
    Top = 304
  end
  object EMSProvider1: TEMSProvider
    ApiVersion = '2'
    URLHost = 'localhost'
    URLPort = 8080
    Left = 832
    Top = 280
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    ScreenCursor = gcrHourGlass
    Left = 688
    Top = 552
  end
  object TimerStatsUpdate: TTimer
    OnTimer = TimerStatsUpdateTimer
    Left = 848
    Top = 56
  end
  object TimerSweep: TTimer
    OnTimer = TimerSweepTimer
    Left = 1136
    Top = 72
  end
end

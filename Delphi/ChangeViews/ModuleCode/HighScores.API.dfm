object dataHighscoresResource: TdataHighscoresResource
  Height = 600
  Width = 1200
  PixelsPerInch = 192
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=c:\data\sub.ib'
      'User_Name=sysdba'
      'Password=masterkey'
      'DriverID=IB')
    LoginPrompt = False
    Left = 92
    Top = 40
  end
  object qryHIGHSCORES: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from HIGHSCORES'
      '{if !SORT}order by !SORT{fi}')
    Left = 260
    Top = 112
    MacroData = <
      item
        Value = Null
        Name = 'SORT'
      end>
  end
  object dsrHIGHSCORES: TEMSDataSetResource
    AllowedActions = [List, Get, Post, Put, Delete]
    DataSet = qryHIGHSCORES
    Left = 372
    Top = 248
  end
end

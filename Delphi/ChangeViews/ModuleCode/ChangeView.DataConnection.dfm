object ChangeViewConnection: TChangeViewConnection
  Height = 1920
  Width = 2560
  PixelsPerInch = 192
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=c:\data\sub.ib'
      'User_Name=sysdba'
      'Password=masterkey'
      'DriverID=IB')
    TxOptions.Isolation = xiSnapshot
    TxOptions.AutoStop = False
    TxOptions.DisconnectAction = xdRollback
    LoginPrompt = False
    Transaction = FDTransaction1
    Left = 108
    Top = 56
  end
  object qryData: TFDQuery
    Connection = FDConnection
    Transaction = FDTransaction1
    SQL.Strings = (
      'select * from HIGHSCORES'
      '{if !SORT}order by !SORT{fi}')
    Left = 716
    Top = 168
    MacroData = <
      item
        Value = Null
        Name = 'SORT'
      end>
  end
  object qryActivateChangeView: TFDQuery
    Connection = FDConnection
    Transaction = FDTransaction1
    SecurityOptions.AllowedCommandKinds = [skExecute, skStartTransaction, skCommit, skRollback, skSet]
    SecurityOptions.AllowMultiCommands = False
    SQL.Strings = (
      'set subscription !SubscriptionName at !DeviceID active;')
    Left = 484
    Top = 168
    MacroData = <
      item
        Value = 'sub_highscore'
        Name = 'SUBSCRIPTIONNAME'
      end
      item
        Value = 'MyDeviceID'
        Name = 'DEVICEID'
        DataType = mdString
      end>
  end
  object FDTransaction1: TFDTransaction
    Options.Isolation = xiSnapshot
    Options.AutoStop = False
    Options.DisconnectAction = xdRollback
    Connection = FDConnection
    Left = 192
    Top = 192
  end
end

object DataResource1: TDataResource1
  Height = 558
  Width = 778
  PixelsPerInch = 192
  object FDConnection1: TFDConnection
    Params.Strings = (
      
        'Database=C:\Source\git\DelphiABall\RADServer\Delphi\TasksExample' +
        '\SIMPLETESTDB.IB'
      'User_Name=sysdba'
      'Password=masterkey'
      'DriverID=IB')
    Connected = True
    LoginPrompt = False
    Left = 94
    Top = 24
  end
  object qryTASKS: TFDQuery
    Connection = FDConnection1
    UpdateOptions.AssignedValues = [uvGeneratorName]
    UpdateOptions.GeneratorName = 'NEWID'
    UpdateOptions.AutoIncFields = 'TASK_ID'
    SQL.Strings = (
      'select * from TASKS')
    Left = 274
    Top = 32
    object qryTASKSTASK_ID: TIntegerField
      FieldName = 'TASK_ID'
      Origin = 'TASK_ID'
      Required = True
    end
    object qryTASKSTASK_NAME: TStringField
      FieldName = 'TASK_NAME'
      Origin = 'TASK_NAME'
      Size = 255
    end
    object qryTASKSCOMPLETED: TBooleanField
      FieldName = 'COMPLETED'
      Origin = 'COMPLETED'
      Required = True
    end
  end
  object dsrTASKS: TEMSDataSetResource
    AllowedActions = [List, Get, Post, Put, Delete]
    DataSet = qryTASKS
    KeyFields = 'TASK_ID'
    Options = [roEnableParams, roEnablePaging, roEnableSorting, roReturnNewEntityKey, roReturnNewEntityValue]
    Left = 282
    Top = 184
  end
end

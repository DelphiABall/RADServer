object MailResource1: TMailResource1
  Height = 514
  Width = 1176
  PixelsPerInch = 192
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=C:\data\SENCHAMAILSERVER.IB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Port=3050'
      'InstanceName=instance2'
      'DriverID=IB')
    UpdateOptions.AssignedValues = [uvGeneratorName]
    UpdateOptions.GeneratorName = 'G_ID'
    LoginPrompt = False
    Left = 60
    Top = 32
  end
  object qryCONTACTS: TFDQuery
    Connection = FDConnection1
    UpdateOptions.KeyFields = 'ID'
    UpdateOptions.AutoIncFields = 'ID'
    SQL.Strings = (
      'select * from CONTACTS')
    Left = 260
    Top = 32
    object qryCONTACTSID: TFDAutoIncField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      IdentityInsert = True
    end
    object qryCONTACTSFIRST_NAME: TStringField
      FieldName = 'FIRST_NAME'
      Origin = 'FIRST_NAME'
      Size = 50
    end
    object qryCONTACTSLAST_NAME: TStringField
      FieldName = 'LAST_NAME'
      Origin = 'LAST_NAME'
      Size = 50
    end
    object qryCONTACTSEMAIL: TStringField
      FieldName = 'EMAIL'
      Origin = 'EMAIL'
      Size = 320
    end
  end
  object dsrCONTACTS: TEMSDataSetResource
    AllowedActions = [List, Get, Post, Put, Delete]
    DataSet = qryCONTACTS
    KeyFields = 'ID'
    PageSize = 20
    Left = 260
    Top = 144
  end
  object qryLABELS: TFDQuery
    Connection = FDConnection1
    UpdateOptions.KeyFields = 'ID'
    UpdateOptions.AutoIncFields = 'ID'
    SQL.Strings = (
      'select * from LABELS')
    Left = 460
    Top = 32
    object qryLABELSID: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryLABELSPARENT_ID: TIntegerField
      FieldName = 'PARENT_ID'
      Origin = 'PARENT_ID'
    end
    object qryLABELSNAME: TStringField
      FieldName = 'NAME'
      Origin = 'NAME'
      Required = True
      Size = 50
    end
    object qryLABELSLEAF: TBooleanField
      FieldName = 'LEAF'
      Origin = 'LEAF'
      Required = True
    end
    object qryLABELSEXPANDED: TBooleanField
      FieldName = 'EXPANDED'
      Origin = 'EXPANDED'
      Required = True
    end
  end
  object dsrLABELS: TEMSDataSetResource
    AllowedActions = [List, Get, Post, Put, Delete]
    DataSet = qryLABELS
    KeyFields = 'ID'
    Left = 460
    Top = 144
  end
  object qryMESSAGES: TFDQuery
    Connection = FDConnection1
    UpdateOptions.AssignedValues = [uvGeneratorName]
    UpdateOptions.GeneratorName = 'G_ID'
    UpdateOptions.KeyFields = 'ID'
    UpdateOptions.AutoIncFields = 'ID'
    SQL.Strings = (
      'select * from MESSAGES')
    Left = 660
    Top = 32
    object qryMESSAGESID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryMESSAGESFIRST_NAME: TStringField
      FieldName = 'FIRST_NAME'
      Origin = 'FIRST_NAME'
      Size = 50
    end
    object qryMESSAGESLAST_NAME: TStringField
      FieldName = 'LAST_NAME'
      Origin = 'LAST_NAME'
      Size = 50
    end
    object qryMESSAGESEMAIL: TStringField
      FieldName = 'EMAIL'
      Origin = 'EMAIL'
      Size = 320
    end
    object qryMESSAGESDATE: TSQLTimeStampField
      FieldName = 'DATE'
      Origin = '"DATE"'
      Required = True
    end
    object qryMESSAGESSUBJECT: TStringField
      FieldName = 'SUBJECT'
      Origin = 'SUBJECT'
      Size = 998
    end
    object qryMESSAGESMESSAGE: TMemoField
      FieldName = 'MESSAGE'
      Origin = '"MESSAGE"'
      BlobType = ftMemo
    end
    object qryMESSAGESUNREAD: TBooleanField
      FieldName = 'UNREAD'
      Origin = 'UNREAD'
      Required = True
    end
    object qryMESSAGESDRAFT: TBooleanField
      FieldName = 'DRAFT'
      Origin = 'DRAFT'
      Required = True
    end
    object qryMESSAGESSENT: TBooleanField
      FieldName = 'SENT'
      Origin = 'SENT'
      Required = True
    end
    object qryMESSAGESSTARRED: TBooleanField
      FieldName = 'STARRED'
      Origin = 'STARRED'
      Required = True
    end
    object qryMESSAGESOUTGOING: TBooleanField
      FieldName = 'OUTGOING'
      Origin = 'OUTGOING'
      Required = True
    end
  end
  object dsrMESSAGES: TEMSDataSetResource
    AllowedActions = [List, Get, Post, Put, Delete]
    DataSet = qryMESSAGES
    KeyFields = 'ID'
    PageSize = 100
    Left = 660
    Top = 144
  end
  object qryMESSAGE_LABELS: TFDQuery
    MasterSource = dsMessages
    MasterFields = 'ID'
    DetailFields = 'MESSAGE_ID'
    Connection = FDConnection1
    SQL.Strings = (
      'select * from MESSAGE_LABELS')
    Left = 916
    Top = 32
  end
  object dsrMESSAGE_LABELS: TEMSDataSetResource
    AllowedActions = [List]
    DataSet = qryMESSAGE_LABELS
    KeyFields = 'MESSAGE_ID;LABEL_ID'
    PageSize = 100
    Left = 916
    Top = 144
  end
  object dsMessages: TDataSource
    DataSet = qryMESSAGES
    Left = 912
    Top = 336
  end
  object qryLabelChildren: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from LABELS')
    Left = 452
    Top = 320
  end
end

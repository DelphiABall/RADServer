object LabelsResource1: TLabelsResource1
  Height = 600
  Width = 1200
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
  object qryInsert: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'INSERT INTO MESSAGE_LABELS'
      '(MESSAGE_ID, LABEL_ID)'
      'VALUES'
      '(:MESSAGE_ID, :LABEL_ID);')
    Left = 224
    Top = 192
    ParamData = <
      item
        Name = 'MESSAGE_ID'
        ParamType = ptInput
      end
      item
        Name = 'LABEL_ID'
        ParamType = ptInput
      end>
  end
  object qryDelete: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      
        'DELETE FROM MESSAGE_LABELS WHERE MESSAGE_ID =:MESSAGE_ID AND LAB' +
        'EL_ID = :LABEL_ID')
    Left = 384
    Top = 192
    ParamData = <
      item
        Name = 'MESSAGE_ID'
        ParamType = ptInput
      end
      item
        Name = 'LABEL_ID'
        ParamType = ptInput
      end>
  end
end

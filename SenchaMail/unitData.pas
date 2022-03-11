unit unitData;

// EMS Resource Module

interface

uses
  System.SysUtils, System.Classes, System.JSON,
  EMS.Services, EMS.ResourceAPI, EMS.ResourceTypes, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.IB, FireDAC.Phys.IBDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  EMS.DataSetResource, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  [ResourceName('data')]
  TMailResource1 = class(TDataModule)
    FDConnection1: TFDConnection;
    qryCONTACTS: TFDQuery;
    [ResourceSuffix('contacts')]
    dsrCONTACTS: TEMSDataSetResource;
    qryLABELS: TFDQuery;
    [ResourceSuffix('labels')]
    dsrLABELS: TEMSDataSetResource;
    qryMESSAGES: TFDQuery;
    [ResourceSuffix('messages')]
    dsrMESSAGES: TEMSDataSetResource;
    qryMESSAGE_LABELS: TFDQuery;
    [ResourceSuffix('message_labels')]
    dsrMESSAGE_LABELS: TEMSDataSetResource;
    dsMessages: TDataSource;
    qryLabelChildren: TFDQuery;
    qryLABELSID: TIntegerField;
    qryLABELSPARENT_ID: TIntegerField;
    qryLABELSNAME: TStringField;
    qryLABELSLEAF: TBooleanField;
    qryLABELSEXPANDED: TBooleanField;
    qryCONTACTSID: TFDAutoIncField;
    qryCONTACTSFIRST_NAME: TStringField;
    qryCONTACTSLAST_NAME: TStringField;
    qryCONTACTSEMAIL: TStringField;
    qryMESSAGESFIRST_NAME: TStringField;
    qryMESSAGESLAST_NAME: TStringField;
    qryMESSAGESEMAIL: TStringField;
    qryMESSAGESDATE: TSQLTimeStampField;
    qryMESSAGESSUBJECT: TStringField;
    qryMESSAGESMESSAGE: TMemoField;
    qryMESSAGESUNREAD: TBooleanField;
    qryMESSAGESDRAFT: TBooleanField;
    qryMESSAGESSENT: TBooleanField;
    qryMESSAGESSTARRED: TBooleanField;
    qryMESSAGESOUTGOING: TBooleanField;
    qryMESSAGESID: TIntegerField;

  published
    [ResourceSuffix('messagesfull')]
    [EndPointRequestSummary('messages', 'Get messages (with labels)', 'Retrieves list of messages with their labels', 'application/json', '')]
    [EndPointResponseDetails(200, 'Ok', TAPIDoc.TPrimitiveType.spObject, TAPIDoc.TPrimitiveFormat.None, '', '')]
    procedure Get(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);

    [ResourceSuffix('labelsnested')]
    [EndPointRequestSummary('labels', 'Get list of labels in their nested structure', 'Retrieves list of labels', 'application/json', '')]
    [EndPointResponseDetails(200, 'Ok', TAPIDoc.TPrimitiveType.spObject, TAPIDoc.TPrimitiveFormat.None, '', '')]
    procedure GetLabels(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
  end;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure ConvertRecordToJSONObject(
  const  AResponse: TEndpointResponse;
  DataSet : TDataSet;
  MasterField : string = '';
  IncFieldName : Boolean = True);
var
  FieldIdx : Integer;
begin
  for FieldIdx := 0 to DataSet.FieldCount -1 do
  begin
    // Skip master field
    if (MasterField > '') and
      (Uppercase(MasterField) =
       Uppercase(DataSet.Fields[FieldIdx].
       FieldName)) then
      Continue;

    // Add name value pairs (except if labels array, just write the values)
    if IncFieldName then
      if DataSet.Fields[FieldIdx].DisplayName > '' then
        AResponse.Body.JSONWriter.WritePropertyName(DataSet.Fields[FieldIdx].DisplayName)
      else
        AResponse.Body.JSONWriter.WritePropertyName(DataSet.Fields[FieldIdx].FieldName);

    case DataSet.Fields[FieldIdx].DataType of
      ftSmallint,
      ftInteger,
      ftWord,
      ftLargeint,
      ftLongWord,
      ftShortint  :   AResponse.Body.JSONWriter.WriteValue(DataSet.Fields[FieldIdx].AsInteger);

      ftFloat,
      ftCurrency,
      ftExtended,
      ftSingle    :   AResponse.Body.JSONWriter.WriteValue(DataSet.Fields[FieldIdx].AsFloat);

      ftBoolean   :   AResponse.Body.JSONWriter.WriteValue(DataSet.Fields[FieldIdx].AsBoolean);

      ftDate,
      ftDateTime,
      ftTimeStamp,
      ftOraTimeStamp :  AResponse.Body.JSONWriter.WriteValue(DataSet.Fields[FieldIdx].AsDateTime);

      else
        AResponse.Body.JSONWriter.WriteValue(DataSet.Fields[FieldIdx].AsString);
    end;
  end;
end;

procedure TMailResource1.Get(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
begin
  qryMESSAGES.Open;
  qryMESSAGE_LABELS.Open('SELECT * FROM MESSAGE_LABELS WHERE MESSAGE_ID = :ID');

  AResponse.Body.JSONWriter.WriteStartArray;

  qryMessages.First;
  while not qryMessages.Eof do begin
    // Build Message
    AResponse.Body.JSONWriter.WriteStartObject;
    ConvertRecordToJSONObject(AResponse,qryMessages);

    // Add the Labels
    AResponse.Body.JSONWriter.WritePropertyName('labels');
    AResponse.Body.JSONWriter.WriteStartArray;
    qryMessage_Labels.First;

    while not qryMessage_Labels.Eof do begin
      ConvertRecordToJSONObject(AResponse, qryMessage_Labels,'MESSAGE_ID',False);
      qryMessage_Labels.Next;
    end;

    AResponse.Body.JSONWriter.WriteEndArray;
    AResponse.Body.JSONWriter.WriteEndObject;
    qryMessages.Next;
  end;
  AResponse.Body.JSONWriter.WriteEndArray;

end;

procedure TMailResource1.GetLabels(const AContext: TEndpointContext;
  const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);

  procedure loadChlildren(ParentQry:TFDDataSet);
  var
    Qry : TFDMemTable;
  begin
    AResponse.Body.JSONWriter.WritePropertyName('children');
    AResponse.Body.JSONWriter.WriteStartArray;

    if qryLabelChildren.Locate('PARENT_ID', ParentQry.FieldByName('ID').AsInteger) then begin

      Qry := TFDMemTable.Create(Self);
      try
        Qry.CloneCursor(qryLabelChildren,True);
        Qry.Filter := 'PARENT_ID = '+ParentQry.FieldByName('ID').AsString;
        Qry.Filtered := True;


        while not Qry.Eof do begin
          AResponse.Body.JSONWriter.WriteStartObject;
          ConvertRecordToJSONObject(AResponse, Qry,'PARENT_ID');
          loadChlildren(Qry);
          AResponse.Body.JSONWriter.WriteEndObject;
          Qry.Next;
        end;

      finally
        Qry.Free;
      end;
    end;

    AResponse.Body.JSONWriter.WriteEndArray;
  end;

begin
  // Get the top level list
  qryLABELS.Open('SELECT * FROM LABELS WHERE PARENT_ID IS NULL ORDER BY ID');
  // List of all linked nodes to work with
  qryLabelChildren.Open('SELECT * FROM LABELS WHERE PARENT_ID IS NOT NULL ORDER BY PARENT_ID, ID');

  AResponse.Body.JSONWriter.WriteStartArray;

  qryLABELS.First;
  while not qryLABELS.Eof do begin
    // Build Message
    AResponse.Body.JSONWriter.WriteStartObject;
    ConvertRecordToJSONObject(AResponse,qryLabels,'PARENT_ID');
    // Add child labels Labels
    loadChlildren(qryLABELS);

    AResponse.Body.JSONWriter.WriteEndObject;
    qryLABELS.Next;
  end;
  AResponse.Body.JSONWriter.WriteEndArray;
end;

procedure Register;
begin
  RegisterResource(TypeInfo(TMailResource1));
end;


initialization
  Register;
end.



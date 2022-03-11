unit unitLabels;

// EMS Resource Module

interface

uses
  System.SysUtils, System.Classes, System.JSON,
  EMS.Services, EMS.ResourceAPI, EMS.ResourceTypes, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.IB, FireDAC.Phys.IBDef, FireDAC.ConsoleUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet;

type
  [ResourceName('labels')]
  TLabelsResource1 = class(TDataModule)
    FDConnection1: TFDConnection;
    qryInsert: TFDQuery;
    qryDelete: TFDQuery;
  published

    [EndPointRequestSummary('Tests', 'PostItem', 'Creates new item', '', 'application/json')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Body, 'body', 'A new item content', true, TAPIDoc.TPrimitiveType.spObject,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spObject, '', '')]
    [EndPointResponseDetails(200, 'Ok', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(409, 'Item Exist', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [ResourceSuffix('{messageid}/{labelid}')]
    procedure Post(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);

    [EndPointRequestSummary('Tests', 'DeleteItem', 'Deletes item with specified ID', '', '')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Path, 'item', 'A item ID', true, TAPIDoc.TPrimitiveType.spString,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spString, '', '')]
    [EndPointResponseDetails(200, 'Ok', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(404, 'Not Found', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [ResourceSuffix('{messageid}/{labelid}')]
    procedure DeleteItem(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
  end;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TLabelsResource1.Post(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  FMessageID, FLabelID: string;
begin
  FLabelID := ARequest.Params.Values['labelid'];
  FMessageID := ARequest.Params.Values['messageid'];

  if StrToIntDef(FMessageID,-1) < 0 then
    AResponse.RaiseNotFound('Invalid Message ID');
  if StrToIntDef(FLabelID,-1) < 0 then
    AResponse.RaiseNotFound('Invalid Label ID');

  qryInsert.ParamByName('MESSAGE_ID').AsString := FMessageID;
  qryInsert.ParamByName('LABEL_ID').AsString := FLabelID;
  try
    qryInsert.ExecSQL;
  except
    on e:Exception do
      AResponse.RaiseDuplicate('Duplicate message label');
  end;

end;

procedure TLabelsResource1.DeleteItem(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  FMessageID, FLabelID: string;
begin
  FMessageID := ARequest.Params.Values['messageid'];
  FLabelID := ARequest.Params.Values['labelid'];

  if StrToIntDef(FMessageID,-1) < 0 then
    AResponse.RaiseNotFound('Invalid Message ID');
  if StrToIntDef(FLabelID,-1) < 0 then
    AResponse.RaiseNotFound('Invalid Label ID');

  qryDelete.ParamByName('MESSAGE_ID').AsString := FMessageID;
  qryDelete.ParamByName('LABEL_ID').AsString := FLabelID;

  try
    qryDelete.ExecSQL;
  except
    on e:Exception do
      AResponse.RaiseBadRequest('Invalid Request',e.message);
  end;

end;

procedure Register;
begin
  RegisterResource(TypeInfo(TLabelsResource1));
end;

initialization
  Register;
end.



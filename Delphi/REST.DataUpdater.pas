unit REST.DataUpdater;

interface

uses System.Classes, REST.Client, REST.Response.Adapter,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Types;

type
  TRestDataSetUpdater = class(TComponent)
  type
    TRDSUTransport = class(TComponent)
    private
      FDataSet   : TFDDataSet;
      FRequest   : TRESTRequest;
      FResponse  : TRESTResponse;
      FDataSetAdapter: TRESTRequestDataSetAdapter;
      function RDSU : TRestDataSetUpdater;
    public
      // Need to create constructor, set these options then put into the thread model.
      constructor Create(AOwner : TRestDataSetUpdater;  UpdateKind : TRESTRequestMethod); reintroduce;
      function Execute(AutoUpdateDataSetSavePoint : Boolean = True) : Boolean;
    end;

  private
    FRESTClient : TRESTClient;
    FDataSet : TFDDataSet;
    FKeyFieldName: string;
    FslError : TStringList;
    FResourcePut: string;
    FResourceDelete: string;
    FResourcePost: string;

    procedure SetDataSet(const Value: TFDDataSet);
    procedure SetClient(const Value: TRESTClient);
    procedure SetKeyFieldName(const Value: string);
    procedure LogError(aErrorMessage: string);
    procedure SetResourceDelete(const Value: string);
    procedure SetResourcePost(const Value: string);
    procedure SetResourcePut(const Value: string);
  public
    constructor Create(AOwner : TComponent); reintroduce; overload;
    constructor Create(AOwner : TComponent; ARESTClient : TRESTClient; AResource, AKeyFieldName : string; ADataSet : TFDDataSet); reintroduce; overload;
    destructor Destroy; override;

    function ApplyRemoteUpdates(AutoUpdateDataSetSavePoint : Boolean = True) : Boolean;

    property DataSet : TFDDataSet read FDataSet write SetDataSet;

    // Insert
    property ResourcePost : string read FResourcePost write SetResourcePost;
    // Update
    property ResourcePut : string read FResourcePut write SetResourcePut;
    // Delete
    property ResourceDelete : string read FResourceDelete write SetResourceDelete;

    property Client : TRESTClient read FRESTClient write SetClient;

    // Name the paramater for the ID to be the same as the field in the dataset, this way it will get set.
    property KeyFieldName : string read FKeyFieldName write SetKeyFieldName;

    property ErrorLog : TStringList read FslError;
  end;

implementation

uses Data.DBJson, System.SysUtils;

{ TRestDataSetUpdater }

function TRestDataSetUpdater.ApplyRemoteUpdates(AutoUpdateDataSetSavePoint : Boolean = True): Boolean;
var
  ResultI, ResultU, ResultD : Boolean;
begin
  // Check Client is set.
  Assert(Assigned(DataSet),'DataSet Missing');
  Assert(Assigned(Client),'RESTClient Connection missing');
  Assert(KeyFieldName > '','Key FieldName Missing');

  if not DataSet.UpdatesPending then
    Exit(True);

  FslError.Clear;

  //
  ResultI := False;
  ResultU := False;
  ResultD := False;

  var InsertTransport := TRDSUTransport.Create(Self,TRESTRequestMethod.rmPOST);
  try
    try
      ResultI := InsertTransport.Execute(AutoUpdateDataSetSavePoint);
    except
      on e:Exception do
        LogError('rmPOST Error: '+e.Message);
    end;
  finally
    InsertTransport.Free;
  end;

  // Updates
  var UpdateTransport := TRDSUTransport.Create(Self,TRESTRequestMethod.rmPUT);
  try
    try
      ResultU := UpdateTransport.Execute(AutoUpdateDataSetSavePoint);
    except
      on e:Exception do
        LogError('rmPUT Error: '+e.Message);
    end;
  finally
    UpdateTransport.Free;
  end;

  // Delete
  var DeleteTransport := TRDSUTransport.Create(Self,TRESTRequestMethod.rmDELETE);
  try
    try
      ResultD := DeleteTransport.Execute(AutoUpdateDataSetSavePoint);
    except
      on e:Exception do
        LogError('rmDELETE Error: '+e.Message);
    end;
  finally
    DeleteTransport.Free;
  end;

  Result := ResultI and ResultU and ResultD;

  if AutoUpdateDataSetSavePoint and Result then
    FDataSet.CommitUpdates; // Clear the cache.
end;

constructor TRestDataSetUpdater.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FslError := TStringList.Create;
  FRESTClient := nil;
end;

constructor TRestDataSetUpdater.Create(AOwner: TComponent;
  ARESTClient: TRESTClient; AResource, AKeyFieldName: string; ADataSet : TFDDataSet);
begin
  Create(AOwner);
  Client := ARESTClient;

  if not AResource.EndsWith('/') then
    AResource := AResource+'/';

  // Insert (Put} doesn't take a param...
  ResourcePost := AResource;
  // Update and delete, use the Param. These can be overriden after creation.
  ResourcePut := AResource+'{'+AKeyFieldName+'}';
  ResourceDelete := AResource+'{'+AKeyFieldName+'}';

  DataSet := ADataSet;
  KeyFieldName := AKeyFieldName;
end;

destructor TRestDataSetUpdater.Destroy;
begin
  FslError.Free;
  inherited;
end;

procedure TRestDataSetUpdater.LogError(aErrorMessage: string);
begin
  FslError.Add(aErrorMessage);
end;

procedure TRestDataSetUpdater.SetClient(const Value: TRESTClient);
begin
  FRESTClient := Value;
end;

procedure TRestDataSetUpdater.SetDataSet(const Value: TFDDataSet);
begin
  FDataset := Value;
end;

procedure TRestDataSetUpdater.SetKeyFieldName(const Value: string);
begin
  FKeyFieldName := Value;
end;

procedure TRestDataSetUpdater.SetResourceDelete(const Value: string);
begin
  FResourceDelete := Value;
end;

procedure TRestDataSetUpdater.SetResourcePost(const Value: string);
begin
  FResourcePost := Value;
end;

procedure TRestDataSetUpdater.SetResourcePut(const Value: string);
begin
  FResourcePut := Value;
end;

{ TRestDataSetUpdater.TRDSUTransport }

constructor TRestDataSetUpdater.TRDSUTransport.Create(AOwner : TRestDataSetUpdater; UpdateKind : TRESTRequestMethod);
begin
  Assert(AOwner <> nil,'Owner not Assigned');

  inherited Create(AOwner);

  FDataSet := TFDMemTable.Create(Self);
  FDataSet.Data := AOwner.DataSet.Delta;

  FRequest := TRESTRequest.Create(Self);
  FRequest.Client := AOwner.Client;

  FResponse := TRESTResponse.Create(Self);
  FRequest.Response := FResponse;

  case UpdateKind of
    rmPOST   : FRequest.Resource := AOwner.ResourcePost;
    rmPUT    : FRequest.Resource := AOwner.ResourcePut;
    rmDELETE : FRequest.Resource := AOwner.ResourceDelete;
    //rmGET  : ;
    //rmPATCH: ;
    else
      FRequest.Resource := AOwner.ResourcePut;
  end;

  FRequest.Method := UpdateKind;

  FDataSetAdapter := TRESTRequestDataSetAdapter.Create(Self);
  FDataSetAdapter.Area := TJSONDataSetArea.Current;
  FDataSetAdapter.Request := FRequest;
  FDataSetAdapter.Dataset := FDataSet;

  // Ignore Nulls on Insert.
  if UpdateKind = rmPost then
    FDataSetAdapter.IncludeNulls := False;

  FDataSetAdapter.AutoUpdate := True;
end;

function TRestDataSetUpdater.TRDSUTransport.Execute(AutoUpdateDataSetSavePoint : Boolean = True) : Boolean;
begin

  case FRequest.Method of
    // Insert
    rmPOST    : FDataSet.FilterChanges := [rtInserted];
    // Update
    rmPUT,
    rmPATCH   : FDataSet.FilterChanges := [rtModified];
    // Delete
    rmDELETE  : FDataSet.FilterChanges := [rtDeleted];
    else
    //Should never be used - e.g. rmGET - Force a failure if it is.
      Exit(False);
  end;

  // If nothing to update, all is good, return true;
  if FDataSet.RecordCount = 0 then
    Exit(True);

  // Currently, it has to be done record by record.
  // Future update, check each field to build the data to push back when its a Patch.
  try
    Result := True;

    var KeyStr := RDSU.KeyFieldName;
    var FParam := FRequest.Params.ParameterByName(KeyStr);

    while not FDataSet.Eof do begin
      // AutoUpdate will update the REST Request body data
      // Update URL Param for current ITEM
      if Assigned(FParam) then
        FParam.Value := FDataSet.FieldByName(KeyStr).AsString;

      try
        FRequest.Execute;
      finally
        Result := (FResponse.StatusCode >= 200) and (FResponse.StatusCode <= 205);
      end;

      FDataSet.Next;
    end;


    // This isn't applying to the master dataset.... Is there away to do this record by record?
    if AutoUpdateDataSetSavePoint and Result then
      FDataSet.CommitUpdates; // Clear the cache.


  except
    on E:Exception do begin
      // Log the error
      RDSU.LogError('Execute error: '+e.Message);
      RDSU.LogError('DataPacket: '+FRequest.GetFullRequestBody);
      Result := False;
    end;
  end;

end;

function TRestDataSetUpdater.TRDSUTransport.RDSU: TRestDataSetUpdater;
begin
  Result := TRestDataSetUpdater(Owner);
end;

end.

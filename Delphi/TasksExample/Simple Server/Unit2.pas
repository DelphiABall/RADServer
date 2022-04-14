unit Unit2;

// EMS Resource Module

interface

uses
  System.SysUtils, System.Classes, System.JSON,
  EMS.Services, EMS.ResourceAPI, EMS.ResourceTypes, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.IB, FireDAC.Phys.IBDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  EMS.DataSetResource, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  [ResourceName('data')]
  TDataResource1 = class(TDataModule)
    FDConnection1: TFDConnection;
    qryTASKS: TFDQuery;
    [ResourceSuffix('TASKS')]
 // If using Delphi 11.0, use this workaround to enable POST to work.
 // [ResourceSuffix('post', './{dummy_id}')] // added "fake" parameter as work around
    dsrTASKS: TEMSDataSetResource;
    qryTASKSTASK_ID: TIntegerField;
    qryTASKSTASK_NAME: TStringField;
    qryTASKSCOMPLETED: TBooleanField;

  published
  end;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

uses System.IOUtils;

procedure Register;
begin
  RegisterResource(TypeInfo(TDataResource1));
end;

initialization
  Register;
end.



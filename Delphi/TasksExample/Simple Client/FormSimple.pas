unit FormSimple;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, REST.Types,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  System.Rtti, FMX.Grid.Style, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Controls,
  FMX.Layouts, Fmx.Bind.Navigator, Data.Bind.Components, Data.Bind.Grid,
  Data.Bind.DBScope, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter,
  REST.Client, Data.Bind.ObjectScope, FMX.StdCtrls, FMX.Memo.Types, FMX.Memo,
  FMX.TabControl, FMX.Edit;

type
  TForm1 = class(TForm)
    BindNavigator1: TBindNavigator;
    Layout1: TLayout;
    Button1: TButton;
    Button2: TButton;
    StringGrid1: TStringGrid;
    BindingsList1: TBindingsList;
    RESTClient1: TRESTClient;
    RESTRequestGet: TRESTRequest;
    RESTResponseGet: TRESTResponse;
    RESTResponseDataSetAdapterGet: TRESTResponseDataSetAdapter;
    FDMemTable1: TFDMemTable;
    BindSourceDB2: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB2: TLinkGridToDataSource;
    Memo1: TMemo;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Label1: TLabel;
    Label2: TLabel;
    MemoPostBody: TMemo;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}
uses REST.DataUpdater;

procedure TForm1.Button1Click(Sender: TObject);
begin
  RESTRequestGet.Execute;
  FDMemTable1.CachedUpdates := True;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  var Updater := TRestDataSetUpdater.Create(Self,RESTClient1, 'data/tasks/', 'TASK_ID', FDMemTable1);
  try
    // Uncomment For RAD Studio / Delphi 11.0 as you need to have a dummy param to make the post work. (known issue fixed in 11.1)
    // Updater.ResourcePost := Updater.ResourcePost+'/-1'; // Dummy ID for tempory workaround
    Updater.ApplyRemoteUpdates(True);
    Memo1.Lines.Text := Updater.ErrorLog.Text;
  finally
    Updater.Free;
  end;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  ShowMessage(FDMemTable1.ChangeCount.ToString);
end;

end.

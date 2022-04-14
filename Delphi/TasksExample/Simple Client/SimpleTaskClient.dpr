program SimpleTaskClient;

uses
  System.StartUpCopy,
  FMX.Forms,
  FormSimple in 'FormSimple.pas' {Form1},
  REST.DataUpdater in '..\..\REST.DataUpdater.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

program frmDatabaseHandeling_p;

uses
  Forms,
  frmDatabaseHandeling_u in 'frmDatabaseHandeling_u.pas' {Form1},
  dmCards_u in 'dmCards_u.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.

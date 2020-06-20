unit frmWinLose_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmWinLose = class(TForm)
    lblWin: TLabel;
    lblLose: TLabel;
    btnAgain: TButton;
    btnExitForm: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure btnAgainClick(Sender: TObject);
    procedure btnExitFormClick(Sender: TObject);
  private
    { Private declarations }
    bGoBack: boolean; // to know if the player wants to play again
  public
    { Public declarations }
  end;

var
  frmWinLose: TfrmWinLose;

implementation

uses
  frmEnter_u, frmGame_u;
{$R *.dfm}

procedure TfrmWinLose.btnAgainClick(Sender: TObject);
begin
  bGoBack := true; // hides frmEnter

  frmGame.Show;
  Self.Close;
end;

procedure TfrmWinLose.btnExitFormClick(Sender: TObject);
begin
  frmEnter.Show;
  Self.Close;
end;

procedure TfrmWinLose.FormActivate(Sender: TObject);
begin
  frmWinLose.Width := Screen.Width;
  frmWinLose.Height := Screen.Height;

  if frmGame.bGameEndWinner then
  begin
    lblWin.Visible := true;
    lblLose.Visible := false;

    frmWinLose.Caption := 'Winner!';
  end
  else
  begin
    lblWin.Visible := false;
    lblLose.Visible := true;

    frmWinLose.Caption := 'Loser!';
  end;

  bGoBack := false;
end;

procedure TfrmWinLose.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not(bGoBack) then // only show frmEnter if they click on the close button
  begin
    frmEnter.Show;
  end;
end;

end.

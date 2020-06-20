unit frmDatabaseHandeling_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, Spin, ExtCtrls, dmCards_u, Mask, math,
  DBCtrls, jpeg, ComCtrls;

type
  TForm1 = class(TForm)
    dbgCards: TDBGrid;
    cbxSort: TComboBox;
    btnSearchName: TButton;
    Panel1: TPanel;
    edtInsertName: TEdit;
    sedInsertAtk: TSpinEdit;
    edtInsertSrc: TEdit;
    Label1: TLabel;
    btnInsert: TButton;
    btnDelete: TButton;
    Panel2: TPanel;
    Label2: TLabel;
    edtEditName: TEdit;
    sedEdtAtk: TSpinEdit;
    btnEdit: TButton;
    edtEditSrc: TEdit;
    btnFind: TButton;
    redOutputField: TRichEdit;
    btnShowField: TButton;
    edtFieldName: TEdit;
    btnSum: TButton;
    procedure cbxSortChange(Sender: TObject);
    procedure btnSearchNameClick(Sender: TObject);
    procedure edtInsertNameClick(Sender: TObject);
    procedure edtInsertSrcClick(Sender: TObject);
    procedure edtInsertNameExit(Sender: TObject);
    procedure edtInsertSrcExit(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnShowFieldClick(Sender: TObject);
    procedure btnSumClick(Sender: TObject);
  private
    { Private declarations }
    procedure fixEdits(sFix: string; iEdit: integer);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnDeleteClick(Sender: TObject);
var
  sDelete: string;
begin
  sDelete := InputBox('Delete Record', 'Insert the name you wish to delete',
    '');

  with DataModule1 do
  begin
    tblCards.First;

    while not tblCards.eof do
    begin
      // makes everything uppercase
      if UpperCase(tblCards['cardName']) = UpperCase(sDelete) then
      begin
        ShowMessage(tblCards['cardName'] + ' has been removed');
        tblCards.Delete;
        tblCards.Refresh;
        Exit;
      end
      else
      begin
        tblCards.Next;
      end;
    end;
    ShowMessage('Could not find ' + sDelete);
  end;

end;

procedure TForm1.btnEditClick(Sender: TObject);
begin
  with DataModule1 do
  begin
    tblCards.Edit;
    tblCards['cardName'] := edtEditName.Text;
    tblCards['imageSRC'] := edtEditSrc.Text;
    tblCards['atk'] := sedEdtAtk.Value; ;
    tblCards.Post;

    ShowMessage(edtEditName.Text + ' was edited');
  end;
end;

procedure TForm1.btnFindClick(Sender: TObject);
var
  sRecord: string;
begin
  sRecord := InputBox('Search', 'Who would you like to search for?', 'Virgo');

  with DataModule1 do
  begin
    tblCards.First;

    while not tblCards.eof do
    begin
      if UpperCase(tblCards['cardName']) = UpperCase(sRecord) then
      begin
        edtEditName.Text := tblCards['cardName'];
        edtEditSrc.Text := tblCards['imageSRC'];
        sedEdtAtk.Value := tblCards['atk'];
        btnEdit.Enabled := true;
        Exit;
      end
      else
      begin
        tblCards.Next;
      end;
    end;
    ShowMessage('Could not find ' + sRecord);
  end;
end;

procedure TForm1.btnInsertClick(Sender: TObject);
begin
  with DataModule1 do
  begin
    tblCards.Insert;
    tblCards['cardName'] := edtInsertName.Text;
    tblCards['imageSRC'] := edtInsertSrc.Text;
    tblCards['atk'] := sedInsertAtk.Value;
    tblCards['used'] := False;
    tblCards.Post;
  end;
end;

procedure TForm1.btnSearchNameClick(Sender: TObject);
var
  sSearch: string;
begin
  sSearch := InputBox('Search', 'Who would you like to search for?', 'Virgo');

  with DataModule1 do
  begin
    tblCards.First;

    while not tblCards.eof do
    begin
      if UpperCase(tblCards['cardName']) = UpperCase(sSearch) then
      begin
        ShowMessage(tblCards['cardName'] + ' has ' + IntToStr(tblCards['atk'])
            + ' attack points');
        Exit;
      end
      else
      begin
        tblCards.Next;
      end;
    end;
    ShowMessage('Could not find ' + sSearch);
  end;

end;

procedure TForm1.btnShowFieldClick(Sender: TObject);
begin
  redOutputField.Lines.Clear;

  with DataModule1 do
  begin
    tblCards.First;

    if edtFieldName.Text = 'cardName' then
    begin
      while not tblCards.eof do
      begin
        redOutputField.Lines.Add(tblCards['cardName']);
        tblCards.Next;
      end;
    end
    else if edtFieldName.Text = 'atk' then
    begin
      while not tblCards.eof do
      begin
        redOutputField.Lines.Add(tblCards['atk']);
        tblCards.Next;
      end;
    end
    else if edtFieldName.Text = 'imageSRC' then
    begin
      while not tblCards.eof do
      begin
        redOutputField.Lines.Add(tblCards['imageSRC']);
        tblCards.Next;
      end;
    end
    else
    begin
      ShowMessage('This field could not be displayed');
    end;
  end;
end;

procedure TForm1.btnSumClick(Sender: TObject);
var
  iSum, iAvg: integer;
begin
  iSum := 0;
  with DataModule1 do
  begin
    tblCards.First;

    while not tblCards.eof do
    begin
      iSum := iSum + tblCards['atk'];
      tblCards.Next;
    end;
    ShowMessage('The sum of all the attack powers is: ' + IntToStr(iSum));

    iAvg := round(iSum / tblCards.RecordCount); // amounts of records in table
    ShowMessage('The average attack power is: ' + IntToStr(iAvg));
  end;
end;

procedure TForm1.cbxSortChange(Sender: TObject);
begin
  if cbxSort.ItemIndex = 0 then
  begin
    DataModule1.tblCards.Sort := 'atk ASC';
  end
  else if cbxSort.ItemIndex = 1 then
  begin
    DataModule1.tblCards.Sort := 'atk DESC'
  end
  else if cbxSort.ItemIndex = 2 then
  begin
    DataModule1.tblCards.Sort := 'cardName ASC'
  end
  else if cbxSort.ItemIndex = 3 then

  begin
    DataModule1.tblCards.Sort := 'cardName DESC'
  end;

end;

procedure TForm1.edtInsertNameClick(Sender: TObject);
begin
  fixEdits('clear', 1);
end;

procedure TForm1.edtInsertNameExit(Sender: TObject);
begin
  fixEdits('fix', 1);
end;

procedure TForm1.edtInsertSrcClick(Sender: TObject);
begin
  fixEdits('clear', 2);
end;

procedure TForm1.edtInsertSrcExit(Sender: TObject);
begin
  fixEdits('fix', 2);
end;

procedure TForm1.fixEdits(sFix: string; iEdit: integer);
begin
  {
    once the player clicks on a component, the component gets cleared
    if the component was clear of any characters, the default text goes onto the
    component again
  }
  if sFix = 'clear' then
  begin
    if iEdit = 1 then
    begin
      if edtInsertName.Text = 'Name' then
      begin
        edtInsertName.Text := '';
      end;
    end
    else if iEdit = 2 then
    begin
      if edtInsertSrc.Text = 'the/source/to/the/image.jpg' then
      begin
        edtInsertSrc.Text := '';
      end;
    end;
  end;

  if sFix = 'fix' then
  begin
    if iEdit = 1 then
    begin
      if edtInsertName.Text = '' then
      begin
        edtInsertName.Text := 'Name';
      end;
    end
    else if iEdit = 2 then
    begin
      if edtInsertSrc.Text = '' then
      begin
        edtInsertSrc.Text := 'the/source/to/the/image.jpg';
      end;
    end;
  end;
end;

end.

unit uPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, sqldb, DB, BufDataset, pqconnection, Forms, Controls,
  Graphics, Dialogs, StdCtrls, DBGrids;

type

  { TForm1 }

  TForm1 = class(TForm)
    bdsDependentesnmDependente: TStringField;
    bdsDependentesparentesco: TStringField;
    btnConectar: TButton;
    btnArquivo: TButton;
    btnAnvancar: TButton;
    bdsFuncionarios: TBufDataset;
    bdsFuncionarioscpf: TStringField;
    bdsFuncionariosestadoCivil: TStringField;
    bdsFuncionariosfuncao: TStringField;
    bdsFuncionariosid: TAutoIncField;
    bdsFuncionariosnmFuncionario: TStringField;
    bdsFuncionariossalario: TFloatField;
    bdsDependentes: TBufDataset;
    bdsDependentescpf: TStringField;
    bdsDependentesdtnascimento: TDateField;
    bdsDependentesfuncionario_id: TLongintField;
    bdsDependentesid: TAutoIncField;
    Button1: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    edtArquivo: TEdit;
    edtHost: TEdit;
    edtDatabase: TEdit;
    edtUsuario: TEdit;
    edtSenha: TEdit;
    lblDatabase: TLabel;
    lblHost1: TLabel;
    lblHost: TLabel;
    lblUsuario: TLabel;
    lblSenha: TLabel;
    openArquivo: TOpenDialog;
    SQLConnector1: TSQLConnector;
    SQLTransaction1: TSQLTransaction;
    procedure btnAnvancarClick(Sender: TObject);
    procedure btnArquivoClick(Sender: TObject);
    procedure btnConectarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FEmpresa: string;
    procedure ProcessarArquivo;
  public

  end;

var
  Form1: TForm1;

implementation
 uses
   uExportador;
{$R *.lfm}

{ TForm1 }

procedure TForm1.btnConectarClick(Sender: TObject);
begin
  if (edtHost.Text = '') or (edtDatabase.Text = '') or
    (edtUsuario.Text = '') or (edtSenha.Text = '') then
  begin
    ShowMessage('Preencha todas as informações para a conexão!');
    exit;
  end;

  SQLConnector1.HostName := edtHost.Text;
  SQLConnector1.DatabaseName := edtDatabase.Text;
  SQLConnector1.UserName := edtUsuario.Text;
  SQLConnector1.Password := edtSenha.Text;

  SQLConnector1.Open();

  if SQLConnector1.Connected then
    btnConectar.Enabled := False;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  DataSource1.DataSet := bdsDependentes;
end;

procedure TForm1.ProcessarArquivo;
var
  lLinha, lFuncionario, lDependente: string;
  lArquivo: TStringList;
  PosPipe, PosPipeEx, I: integer;

  procedure PreencheFuncionario;
  begin
    lFuncionario := lLinha;

    PosPipe := Pos('|', lFuncionario);
    bdsFuncionarios.Append();
    bdsFuncionariosnmFuncionario.AsString := Copy(lFuncionario, 1, PosPipe - 1);
    PosPipeEx := PosEx('|', lFuncionario, PosPipe + 1);
    bdsFuncionarioscpf.AsString := Copy(lFuncionario, PosPipe + 1, PosPipeEx - 1);
    PosPipe := PosPipeEx;
    PosPipeEx := PosEx('|', lFuncionario, PosPipe + 1);
    bdsFuncionariossalario.AsFloat :=
      StrToFloat(Copy(lFuncionario, PosPipe + 1, (PosPipeEx - PosPipe) - 1));
    PosPipe := PosPipeEx;
    PosPipeEx := PosEx('|', lFuncionario, PosPipe + 1);
    bdsFuncionariosfuncao.AsString :=
      Copy(lFuncionario, PosPipe + 1, (PosPipeEx - PosPipe) - 1);
    PosPipe := PosPipeEx;
    bdsFuncionariosestadoCivil.AsString :=
      Copy(lFuncionario, PosPipe + 1, Length(lFuncionario) - PosPipe);
    bdsFuncionarios.Post();
  end;

  procedure PreencherDependente;
  begin
    lDependente := lLinha;

    PosPipe := Pos('|', lDependente);
    bdsDependentes.Append();
    bdsDependentesfuncionario_id.AsInteger := bdsFuncionariosid.AsInteger;
    bdsDependentesnmDependente.AsString := Copy(lDependente, 1, PosPipe - 1);
    PosPipeEx := PosEx('|', lDependente, PosPipe + 1);
    bdsDependentescpf.AsString := Copy(lDependente, PosPipe + 1, PosPipeEx - 1);
    PosPipe := PosPipeEx;
    PosPipeEx := PosEx('|', lDependente, PosPipe + 1);
    bdsDependentesparentesco.AsString :=
      Copy(lDependente, PosPipe + 1, (PosPipeEx - PosPipe) - 1);
    PosPipe := PosPipeEx;
    bdsDependentesdtnascimento.AsDateTime :=
      StrToDateTime(Copy(lDependente, PosPipe + 1, Length(lDependente) - PosPipe));
    bdsDependentes.Post();
  end;

begin
  lArquivo := TStringList.Create();
  lArquivo.LoadFromFile(edtArquivo.Text);

  try
    PosPipe := pos('|', lArquivo[0]);
    FEmpresa := Copy(lArquivo[0], 1, PosPipe - 1);
    Form1.Caption := FEmpresa;

    bdsFuncionarios.CreateDataset();
    bdsFuncionarios.Open();

    bdsDependentes.CreateDataset();
    bdsDependentes.Open();

    for I := 1 to Pred(lArquivo.Count) do
    begin
      lLinha := lArquivo[I];

      if lLinha = '' then
      begin
        lFuncionario := '';
        lDependente := '';
        continue;
      end;

      if lFuncionario <> '' then
      begin
        PreencherDependente;
        continue;
      end;

      if (lFuncionario = '') and (lDependente = '') then
      begin
        PreencheFuncionario;
      end;
    end;
  finally
    lArquivo.Free();
  end;
end;

procedure TForm1.btnArquivoClick(Sender: TObject);
begin
  if not (edtArquivo.Text = '') then
  begin
    if FileExists(edtArquivo.Text) then
    begin
      btnArquivo.Caption := 'Carregado';
      btnArquivo.Enabled := False;
      exit;
    end;
    ShowMessage('Impossível encontrar o arquivo');
    exit;
  end;
  if openArquivo.Execute then
  begin
    edtArquivo.Text := openArquivo.FileName;
    btnArquivo.Caption := 'Carregado';
    btnArquivo.Enabled := False;
    exit;
  end;
end;

procedure TForm1.btnAnvancarClick(Sender: TObject);
begin

  if not (btnConectar.Enabled and btnArquivo.Enabled) then
    ProcessarArquivo();

end;

end.

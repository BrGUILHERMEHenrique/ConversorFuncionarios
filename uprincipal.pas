unit uPrincipal;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, StrUtils, sqldb, db, BufDataset, pqconnection, Forms, Controls,
			Graphics, Dialogs, StdCtrls, DBGrids;

type

			{ TForm1 }

      TForm1 = class(TForm)
						btnConectar: TButton;
						btnArquivo: TButton;
						btnAnvancar: TButton;
						BufDataset1: TBufDataset;
						BufDataset1cpf: TStringField;
						BufDataset1estadoCivil: TStringField;
						BufDataset1funcao: TStringField;
						BufDataset1id: TAutoIncField;
						BufDataset1nmFuncionario: TStringField;
						BufDataset1salario: TFloatField;
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
      private
        FEmpresa: String;
        procedure ProcessarArquivo;
      public

      end;

var
      Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnConectarClick(Sender: TObject);
begin
  if (edtHost.Text = '') or
    (edtDatabase.Text = '') or
    (edtUsuario.Text = '') or
    (edtSenha.Text = '') then
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

procedure TForm1.ProcessarArquivo;
var
  lLinha, lFuncionario, lDependente: string;
  lArquivo: TStringList;
  PosPipe, PosPipeEx, I: Integer;

  procedure PreencheFuncionario;
  begin
    lFuncionario := lLinha;
    PosPipe := Pos('|', lFuncionario);
    BufDataset1.Append();
    BufDataset1nmFuncionario.AsString := Copy(lFuncionario, 1, PosPipe -1);
    PosPipeEx := PosEx('|', lFuncionario, PosPipe + 1);
    BufDataset1cpf.AsString := Copy(lFuncionario, PosPipe + 1, PosPipeEx - 1);
    PosPipe := PosPipeEx;
    PosPipeEx := PosEx('|', lFuncionario, PosPipe + 1);
    BufDataset1salario.AsFloat := StrToFloat(Copy(lFuncionario, PosPipe +1, (PosPipeEx - PosPipe) -1));
    PosPipe := PosPipeEx;
    PosPipeEx := PosEx('|', lFuncionario, PosPipe + 1);
    BufDataset1funcao.AsString := Copy(lFuncionario, PosPipe +1, (PosPipeEx - PosPipe) -1);
    PosPipe := PosPipeEx;
    BufDataset1estadoCivil.AsString := Copy(lFuncionario, PosPipe +1, Length(lFuncionario) - PosPipe);
    BufDataset1.Post();
	end;

begin
  lArquivo := TStringList.Create();
  lArquivo.LoadFromFile(edtArquivo.Text);
  BufDataset1.Open();
  try
    PosPipe := pos('|', lArquivo[0]);
    FEmpresa := Copy(lArquivo[0], 1, PosPipe - 1);
    Form1.Caption := FEmpresa;

    for I := 1 to Pred(lArquivo.Count) do
    begin
      lLinha := lArquivo[I];

      if lLinha = '' then
        begin
          lFuncionario := '';
          lDependente := '';
          continue;
				end;

      if (lFuncionario = '') and (lDependente = '') then
        begin
          PreencheFuncionario;
				end;
      if lFuncionario <> '' then
        begin
          lDependente := '';
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
  BufDataset1.CreateDataset();
  if not (btnConectar.Enabled and btnArquivo.Enabled) then
    ProcessarArquivo();
end;

end.


unit uPrincipal;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, sqldb, pqconnection, Forms, Controls, Graphics,
			Dialogs, StdCtrls;

type

			{ TForm1 }

      TForm1 = class(TForm)
						btnConectar: TButton;
						edtHost: TEdit;
						edtDatabase: TEdit;
						edtUsuario: TEdit;
						edtSenha: TEdit;
						lblDatabase: TLabel;
						lblHost1: TLabel;
						lblHost: TLabel;
						lblUsuario: TLabel;
						lblSenha: TLabel;
						SQLConnector1: TSQLConnector;
						SQLTransaction1: TSQLTransaction;
						procedure btnConectarClick(Sender: TObject);
      private

      public

      end;

var
      Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnConectarClick(Sender: TObject);
begin
  if edtHost.Text.IsEmpty() or
    edtDatabase.Text.IsEmpty() or
    edtUsuario.Text.IsEmpty() or
    edtSenha.Text.IsEmpty() then
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
    ShowMessage('Conectou');
end;

end.


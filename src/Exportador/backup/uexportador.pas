unit uExportador;

{$mode objfpc}{$H+}

interface

uses
  DB, BufDataset, Classes, SysUtils, Variants;

type

  { TExportador }

  TExportador = class(TComponent)
  private


  public
    function ExportarFuncionario: TBufDataSet;
    function ExportarDependentes: TBufDataSet;
    procedure Exportar(Arquivo: TStringList);
  end;

implementation

{ TExportador }

function TExportador.ExportarFuncionario: TBufDataSet;
begin
  Result := Nil;
end;

function TExportador.ExportarDependentes: TBufDataSet;
begin
  Result := Nil;
end;

procedure TExportador.Exportar(Arquivo: TStringList);
var
  I: integer;
  lLinha, lFuncionario, lDependente: string;
begin
  for I := 0 to pred(Arquivo.Count) do
  begin
    lLinha := Arquivo[I];

    if lLinha = '' then
    begin
      lFuncionario := '';
      lDependente := '';
      continue;
    end;

    if lFuncionario <> '' then
      ExportarDependentes;

    if lFuncionario <> '' and lDependente <> '' then
      ExportarFuncionario;
  end;
end;

end.

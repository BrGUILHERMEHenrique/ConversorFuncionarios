unit uFuncionario_imp;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Variants, uDependente_imp;

Type ListaDependentes = array of TDependente;
{ TFuncionario }
Type TFuncionario = Class(TComponent)
private
			Fcpf: String;
			FestadoCivil: String;
			Ffuncao: String;
			FNome: String;
			Fsalario: Double;
      FDependentes: ListaDependentes;
      FTotalDependentes: Integer;
			procedure Setcpf(AValue: String);
			procedure SetestadoCivil(AValue: String);
			procedure Setfuncao(AValue: String);
      procedure SetNome(AValue: String);
			procedure Setsalario(AValue: Double);
public
  function CalcularIR(): Double;
  function CalcularIN(): Double;
  procedure AdicionarDependente(Dependente: TDependente);
  constructor Create;
published
  property nome: String read FNome write SetNome;
  property cpf: String read Fcpf write Setcpf;
  property salario: Double read Fsalario write Setsalario;
  property funcao: String read Ffuncao write Setfuncao;
  property estadoCivil: String read FestadoCivil write SetestadoCivil;
end;

implementation

{ TFuncionario }

procedure TFuncionario.SetNome(AValue: String);
begin
		  if FNome = AValue then
        Exit;
		  FNome:=AValue;
end;

procedure TFuncionario.Setcpf(AValue: String);
begin
			if Fcpf = AValue then
        Exit;
			Fcpf := AValue;
end;

procedure TFuncionario.SetestadoCivil(AValue: String);
begin
			if (FestadoCivil = AValue) or (Length(AValue) > 2) then
        Exit;
			FestadoCivil := AValue;
end;

procedure TFuncionario.Setfuncao(AValue: String);
begin
			if Ffuncao = AValue then
        Exit;
			Ffuncao := AValue;
end;

procedure TFuncionario.Setsalario(AValue: Double);
begin
			if (Fsalario = AValue) or (AValue <= 0) then
        Exit;
			Fsalario := AValue;
end;

function TFuncionario.CalcularIR(): Double;
begin
  // Implementação dos calculos de IRRF
  Result := 0;
end;

function TFuncionario.CalcularIN(): Double;
begin
  //Implementação dos calculos de INSS
  Result := 0;
end;

procedure TFuncionario.AdicionarDependente(Dependente: TDependente);
begin
  // Será Criado um log posteriormente para guardar essas informações
  if Dependente.CalculaIdade() > 18 then
    Exit;

  SetLength(FDependentes, FTotalDependentes + 1);
  FDependentes[FTotalDependentes] := Dependente;
  Inc(FTotalDependentes);

end;

constructor TFuncionario.Create;
begin
  FTotalDependentes := 0;
end;

end.


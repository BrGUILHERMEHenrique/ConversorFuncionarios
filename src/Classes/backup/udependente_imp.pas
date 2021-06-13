unit uDependente_imp;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, Variants;
Type EParentesco = (epFILHO, epSOBRINHO, epOUTROS);
 { TDependente }
Type TDependente = Class(TObject)
private
			FCpf: String;
			FDtNascimento: TDate;
			FNome: String;
			FParentesco: EParentesco;
			procedure SetCpf(AValue: String);
			procedure SetDtNascimento(AValue: TDate);
			procedure SetNome(AValue: String);
			procedure SetParentesco(AValue: EParentesco);
public
  function CalculaIdade(): Integer;
published
  property Nome: String read FNome write SetNome;
  property Cpf: String read FCpf write SetCpf;
  property Parentesco: EParentesco read FParentesco write SetParentesco;
  property DtNascimento: TDate read FDtNascimento write SetDtNascimento;
  end;

implementation
uses
  DateUtils;
{ TDependente }

procedure TDependente.SetCpf(AValue: String);
begin
			if FCpf = AValue then
        Exit;
			FCpf := AValue;
end;

procedure TDependente.SetDtNascimento(AValue: TDate);
begin
			if FDtNascimento = AValue then
        Exit;
			FDtNascimento := AValue;
end;

procedure TDependente.SetNome(AValue: String);
begin
			if FNome = AValue then
        Exit;
			FNome := AValue;
end;

procedure TDependente.SetParentesco(AValue: EParentesco);
begin
			if FParentesco = AValue then
        Exit;
			FParentesco := AValue;
end;

function TDependente.CalculaIdade(): Integer;
begin
  Result := CurrentYear - YearOf(FDtNascimento);
end;

end.


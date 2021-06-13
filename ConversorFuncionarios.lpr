program ConversorFuncionarios;

{$mode objfpc}{$H+}

uses
      {$IFDEF UNIX}{$IFDEF UseCThreads}
      cthreads,
      {$ENDIF}{$ENDIF}
      Interfaces, // this includes the LCL widgetset
      Forms, uPrincipal, uFuncionario_imp, uDependente_imp;

{$R *.res}

begin
      RequireDerivedFormResource:=True;
      Application.Scaled:=True;
      Application.Initialize;
			Application.CreateForm(TForm1, Form1);
      Application.Run;
end.


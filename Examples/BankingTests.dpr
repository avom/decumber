program BankingTests;

{$APPTYPE CONSOLE}

{$R *.res}

{$STRONGLINKTYPES ON}

uses
  System.SysUtils,
  Decumber,
  Banking.Account in 'Source\Banking.Account.pas',
  Banking.Iban in 'Source\Banking.Iban.pas',
  Banking.Transaction in 'Source\Banking.Transaction.pas',
  Banking.Money in 'Source\Banking.Money.pas',
  BankingTests.BankAccountStepDefinitions in 'Steps\BankingTests.BankAccountStepDefinitions.pas';

begin
  ReportMemoryLeaksOnShutdown := True;
  try
    TDecumber.RunTest('..\..\Features\BankAccount.feature');
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

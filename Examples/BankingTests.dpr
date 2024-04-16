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
  BankingTests.BankAccountStepDefinitions in 'Steps\BankingTests.BankAccountStepDefinitions.pas',
  Banking.MonthlyLoanPaymentCalculator in 'Source\Banking.MonthlyLoanPaymentCalculator.pas',
  Banking.LoanDecisionService in 'Source\Banking.LoanDecisionService.pas',
  Banking.LoanApplicaton in 'Source\Banking.LoanApplicaton.pas',
  Utils.DateTimeProvider in 'Source\Utils.DateTimeProvider.pas',
  Banking.InterestRateProvider in 'Source\Banking.InterestRateProvider.pas',
  BankingTests.LoanDecisionServiceStepDefinitions in 'Steps\BankingTests.LoanDecisionServiceStepDefinitions.pas',
  Helpers.DateTimeProvider in 'Helpers\Helpers.DateTimeProvider.pas';

begin
  ReportMemoryLeaksOnShutdown := True;
  try
    TDecumber.RunTests('..\..\Features');
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

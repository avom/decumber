unit Banking.MonthlyLoanPaymentCalculator;

interface

type
  TMonthlyLoanPaymentCalculator = class
  public
    class function CalculateMonthlyPayment(
      LoanAmount, InterestRate: Currency; Months: Integer): Currency;
  end;

implementation

uses
  System.Math;

{ TMonthlyLoanPaymentCalculator }

class function TMonthlyLoanPaymentCalculator.CalculateMonthlyPayment(
  LoanAmount, InterestRate: Currency; Months: Integer): Currency;
begin
  const P = LoanAmount;
  const I = InterestRate / 12 / 100;
  const Si = Power(1 + I, Months);
  Result := P * I * Si / (Si - 1);
end;

end.

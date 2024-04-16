unit Banking.InterestRateProvider;

interface

uses
  Banking.LoanApplicaton;

type
  IInterestRateProvider = interface
    function GetInterestRate(const Application: TLoanApplication): Currency;
  end;

  THomeLoanInterestRateProvider = class(TInterfacedObject, IInterestRateProvider)
  private
  public
    function GetInterestRate(const Application: TLoanApplication): Currency;
  end;

implementation

{ THomeLoanInterestRateProvider }

function THomeLoanInterestRateProvider.GetInterestRate(const Application: TLoanApplication): Currency;
begin
  Result := 6.5;
end;

end.

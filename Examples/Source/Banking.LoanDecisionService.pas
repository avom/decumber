unit Banking.LoanDecisionService;

interface

uses
  Banking.InterestRateProvider,
  Banking.LoanApplicaton,
  Banking.MonthlyLoanPaymentCalculator,
  Utils.DateTimeProvider;

type
  TLoanDecision = (ldApproved, ldDenied);

  TLoanDecisionService = class
  private
    FDateTimeProvider: IDateTimeProvider;
    FInterestRateProvider: IInterestRateProvider;
  public
    constructor Create(
      const DateTimeProvider: IDateTimeProvider;
      const InterestRateProvider: IInterestRateProvider);

    function GetLoanDecision(const Application: TLoanApplication): TLoanDecision;
  end;

implementation

uses
  System.DateUtils,
  System.SysUtils;

{ TLoanDecisionService }

constructor TLoanDecisionService.Create(
  const DateTimeProvider: IDateTimeProvider;
  const InterestRateProvider: IInterestRateProvider);
begin
  FDateTimeProvider := DateTimeProvider;
  FInterestRateProvider := InterestRateProvider;
end;

function TLoanDecisionService.GetLoanDecision(
  const Application: TLoanApplication): TLoanDecision;
const
  MinAgeForApproval = 18;
  MaxAgeDuringLastPaymentForApproval = 69;
  MaxObligationsForApproval = 0.3;
begin
  Result := TLoanDecision.ldDenied;
  const Today: TDateTime = FDateTimeProvider.Date;
  if Today < Application.ApplicantBirthDate.IncYear(MinAgeForApproval) then
    Exit;

  const LastPaymentDate = Today.IncMonth(Application.LoanPeriodMonths);
  if LastPaymentDate >=
    Application.ApplicantBirthDate.IncYear(MaxAgeDuringLastPaymentForApproval + 1) then
    Exit;

  const LoanAmount = Application.LoanAmount;
  const InterestRate = FInterestRateProvider.GetInterestRate(Application);
  const MonthlyPayment = TMonthlyLoanPaymentCalculator.CalculateMonthlyPayment(
    LoanAmount, InterestRate, Application.LoanPeriodMonths);
  const FutureObligations = Application.ExistingMonthlyObligations+ MonthlyPayment;

  if FutureObligations > Application.ApplicantIncome * MaxObligationsForApproval then
    Exit;

  Result := TLoanDecision.ldApproved;
end;

end.

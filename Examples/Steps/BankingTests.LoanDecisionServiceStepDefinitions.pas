unit BankingTests.LoanDecisionServiceStepDefinitions;

interface

uses
  Decumber,
  Banking.LoanApplicaton;

type
  TLoanDecisionServiceStepDefinitions = class
  private
    FApplication: TLoanApplication;
    FToday: TDateTime;
  public
    constructor Create;
    destructor Destroy; override;

    [Given('the loan applicant is {} years old')]
    procedure an_applicant_is_years_old(Age: Integer);

    [Given('he has a regular net income of {} euros a month')]
    procedure he_has_a_regular_net_income_of_euros_a_month(Income: Currency);

    [Given('has {} euros of existing monthly financial obligations')]
    procedure has_euros_of_existing_monthly_financial_obligations(Obligations: Currency);

    [When('he applies for a {} euro home Loan')]
    procedure he_applies_for_a_euro_home_loan(LoanAmount: Currency);

    [When('wants to pay it back in {} years')]
    procedure wants_to_pay_it_back_in_years(LoanPeriodYears: Integer);

    [Then_('the application should be {}')]
    procedure the_application_should_be(const DecisionStr: string);
  end;

implementation

uses
  System.DateUtils,
  System.Rtti,
  System.SysUtils,
  Banking.InterestRateProvider,
  Banking.LoanDecisionService,
  Banking.MonthlyLoanPaymentCalculator,
  Helpers.DateTimeProvider;

{ TLoanDecisionServiceStepDefinitions }

constructor TLoanDecisionServiceStepDefinitions.Create;
begin
  FApplication := TLoanApplication.Create;
end;

destructor TLoanDecisionServiceStepDefinitions.Destroy;
begin
  FApplication.Free;
  inherited;
end;

procedure TLoanDecisionServiceStepDefinitions.an_applicant_is_years_old(Age: Integer);
begin
  FToday := EncodeDate(2024, 4, 15);
  FApplication.ApplicantBirthDate := FToday.IncYear(-Age);
end;

procedure TLoanDecisionServiceStepDefinitions.he_has_a_regular_net_income_of_euros_a_month(
  Income: Currency);
begin
  FApplication.ApplicantIncome := Income;
end;

procedure TLoanDecisionServiceStepDefinitions.has_euros_of_existing_monthly_financial_obligations(
  Obligations: Currency);
begin
  FApplication.ExistingMonthlyObligations := Obligations;
end;

procedure TLoanDecisionServiceStepDefinitions.he_applies_for_a_euro_home_loan(LoanAmount: Currency);
begin
  FApplication.LoanAmount := LoanAmount;
end;

procedure TLoanDecisionServiceStepDefinitions.wants_to_pay_it_back_in_years(
  LoanPeriodYears: Integer);
begin
  FApplication.LoanPeriodMonths := LoanPeriodYears * 12;
end;

procedure TLoanDecisionServiceStepDefinitions.the_application_should_be(const DecisionStr: string);
begin
  const ExpectedDecision = TRttiEnumerationType.GetValue<TLoanDecision>('ld' + DecisionStr);
  const Service = TLoanDecisionService.Create(
    TFixedDateTimeProvider.Create(EncodeDate(2024, 4, 15)),
    THomeLoanInterestRateProvider.Create);
  try
    const Decision = Service.GetLoanDecision(FApplication);
    Assert(Decision = ExpectedDecision);
  finally
    Service.Free;
  end;
end;

end.

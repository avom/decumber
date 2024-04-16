unit Banking.LoanApplicaton;

interface

type
  TLoanType = (ltHomeLoan);

  TLoanApplication = class
  private
    FLoanAmount: Currency;
    FLoanPeriodMonths: Integer;
    FExistingMonthlyObligations: Currency;
    FApplicantIncome: Currency;
    FApplicantBirthDate: TDateTime;
    FLoanType: TLoanType;
  public
    property ApplicantBirthDate: TDateTime read FApplicantBirthDate write FApplicantBirthDate;
    property ApplicantIncome: Currency read FApplicantIncome write FApplicantIncome;
    property LoanType: TLoanType read FLoanType write FLoanType;
    property LoanAmount: Currency read FLoanAmount write FLoanAmount;
    property LoanPeriodMonths: Integer read FLoanPeriodMonths write FLoanPeriodMonths;
    property ExistingMonthlyObligations: Currency read FExistingMonthlyObligations
      write FExistingMonthlyObligations;
  end;

implementation

end.

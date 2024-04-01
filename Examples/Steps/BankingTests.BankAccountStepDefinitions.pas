unit BankingTests.BankAccountStepDefinitions;

interface

uses
  Decumber,
  Banking.Account;

type
  TBankAccountStepDefinitions = class
  private
    FAccount: TAccount;
  public
    destructor Destroy; override;

    [Given('the bank account with empty starting balance')]
    procedure the_bank_account_with_starting_balance;

    [When('{} euros are transferred to the account')]
    procedure euros_are_transferred_to_the_account(Amount: Currency);

    [&Then('the account balance is {} euros')]
    procedure the_account_balance_is(ExpectedBalance: Currency);
  end;

implementation

uses
  System.DateUtils,
  System.SysUtils,
  Banking.Iban,
  Banking.Money,
  Banking.Transaction;

{ TBankAccountStepDefinitions }

procedure TBankAccountStepDefinitions.the_bank_account_with_starting_balance;
begin
  FAccount := TAccount.Create(TIban.Create('EE391216437287892973'));
end;

destructor TBankAccountStepDefinitions.Destroy;
begin
  FAccount.Free;
  inherited;
end;

procedure TBankAccountStepDefinitions.euros_are_transferred_to_the_account(Amount: Currency);
begin
  const FromIban = TIban.Create('EE251261552788779739');
  const DateTime = EncodeDateTime(2024, 03, 13, 12, 15, 12, 123);
  const Euros = TMoney.Create(Amount, 'EUR');
  const Transaction = TTransaction.Create(FromIban, FAccount.Iban, DateTime, Euros);
  FAccount.AddTransaction(Transaction);
end;

procedure TBankAccountStepDefinitions.the_account_balance_is(ExpectedBalance: Currency);
begin
  const Balance = FAccount.GetBalance;
  Assert(ExpectedBalance = Balance.Amount, Format('Expected balance %.2f, but was %.2f',
    [ExpectedBalance, Balance.Amount]));
end;

end.

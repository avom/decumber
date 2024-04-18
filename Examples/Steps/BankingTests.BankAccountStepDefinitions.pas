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

    [Given('I have an empty bank account')]
    procedure i_have_an_empty_bank_account;

    [When('I receive a payment of {} euros')]
    procedure i_receive_a_payment_of_euros(Amount: Currency);

    [&And('I pay a {} electricity bill')]
    procedure i_pay_a_electricity_bill(Amount: Currency);

    [&But('I pay {} for a cell phone bill')]
    procedure i_pay_for_a_cell_phone_bill(Amount: Currency);

    [When('I pay {} euros for rent')]
    procedure i_pay_euros_for_rent(Amount: Currency);

    [&Then('I have {} euros left in my bank account')]
    procedure i_have_euros_left_in_my_bank_account(Balance: Currency);
  end;

implementation

uses
  System.DateUtils,
  System.SysUtils,
  Banking.Iban,
  Banking.Money,
  Banking.Transaction;

{ TBankAccountStepDefinitions }

destructor TBankAccountStepDefinitions.Destroy;
begin
  FAccount.Free;
  inherited;
end;

procedure TBankAccountStepDefinitions.i_have_an_empty_bank_account;
begin
  FAccount := TAccount.Create(TIban.Create('EE391216437287892973'));
end;

procedure TBankAccountStepDefinitions.i_receive_a_payment_of_euros(Amount: Currency);
begin
  const FromIban = TIban.Create('EE251261552788779739');
  const DateTime = EncodeDateTime(2024, 03, 13, 12, 15, 12, 123);
  const Euros = TMoney.Create(Amount, 'EUR');
  const Transaction = TTransaction.Create(FromIban, FAccount.Iban, DateTime, Euros);
  FAccount.AddTransaction(Transaction);
end;

procedure TBankAccountStepDefinitions.i_pay_a_electricity_bill(Amount: Currency);
begin
  const ToIban = TIban.Create('EE571245244333329554');
  const DateTime = EncodeDateTime(2024, 03, 14, 11, 10, 0, 0);
  const Euros = TMoney.Create(Amount, 'EUR');
  const Transaction = TTransaction.Create(FAccount.Iban, ToIban, DateTime, Euros);
  FAccount.AddTransaction(Transaction);
end;

procedure TBankAccountStepDefinitions.i_pay_for_a_cell_phone_bill(Amount: Currency);
begin
  const ToIban = TIban.Create('EE191246579147269985');
  const DateTime = EncodeDateTime(2024, 03, 14, 11, 25, 11, 0);
  const Euros = TMoney.Create(Amount, 'EUR');
  const Transaction = TTransaction.Create(FAccount.Iban, ToIban, DateTime, Euros);
  FAccount.AddTransaction(Transaction);
end;

procedure TBankAccountStepDefinitions.i_pay_euros_for_rent(Amount: Currency);
begin
  const ToIban = TIban.Create('EE491286364634427476');
  const DateTime = EncodeDateTime(2024, 03, 14, 23, 25, 17, 0);
  const Euros = TMoney.Create(Amount, 'EUR');
  const Transaction = TTransaction.Create(FAccount.Iban, ToIban, DateTime, Euros);
  FAccount.AddTransaction(Transaction);
end;

procedure TBankAccountStepDefinitions.i_have_euros_left_in_my_bank_account(Balance: Currency);
begin
  const ActualBalance = FAccount.GetBalance;
  Assert.That(ActualBalance.Amount).IsEqualTo(Balance);
end;

end.

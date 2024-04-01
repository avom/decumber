unit Banking.Account;

interface

uses
  System.Generics.Collections,
  Banking.Iban,
  Banking.Money,
  Banking.Transaction;

type
  TAccount = class
  private
    FIban: TIban;
    FTransactions: TList<TTransaction>;
  public
    constructor Create(const Iban: TIban);
    destructor Destroy; override;

    procedure AddTransaction(Transaction: TTransaction);

    function GetBalance: TMoney;

    property Iban: TIban read FIban;
  end;

implementation

uses
  System.SysUtils;

{ TAccount }

constructor TAccount.Create(const Iban: TIban);
begin
  FIban := Iban;
  FTransactions := TList<TTransaction>.Create;
end;

destructor TAccount.Destroy;
begin
  FTransactions.Free;
  inherited;
end;

function TAccount.GetBalance: TMoney;
begin
  Result := TMoney.Zero;
  for var Transaction in FTransactions do
  begin
    if Transaction.FromIban = FIban then
      Result := Result - Transaction.Amount
    else
      Result := Result + Transaction.Amount;
  end;
end;

procedure TAccount.AddTransaction(Transaction: TTransaction);
begin
  if (Transaction.FromIban <> FIban) and (Transaction.ToIban <> FIban) then
    raise EArgumentException.Create('Transaction is not related to the account');
    
  FTransactions.Add(Transaction);
end;

end.

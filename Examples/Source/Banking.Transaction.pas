unit Banking.Transaction;

interface

uses
  Banking.Iban,
  Banking.Money;

type
  TTransaction = record
  private
    FFromIban: TIban;
    FToIban: TIban;
    FAmount: TMoney;
    FDateTime: TDateTime;
  public
    constructor Create(const FromIban, ToIban: TIban; DateTime: TDateTime; const Amount: TMoney);
    
    property FromIban: TIban read FFromIban;
    property ToIban: TIban read FToIban;
    property DateTime: TDateTime read FDateTime;
    property Amount: TMoney read FAmount;
  end;

implementation

{ TTransaction }

constructor TTransaction.Create(const FromIban, ToIban: TIban; DateTime: TDateTime; 
  const Amount: TMoney);
begin
  FFromIban := FromIban;
  FToIban := ToIban;
  FDateTime := DateTime;
  FAmount := Amount;
end;

end.

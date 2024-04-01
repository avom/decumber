unit Banking.Money;

interface

type
  TMoney = record
  private
    FCurrencyCode: string;
    FAmount: Currency;
  public
    constructor Create(Amount: Currency; const CurrencyCode: string);

    property Amount: Currency read FAmount;
    property CurrencyCode: string read FCurrencyCode;

    class operator Add(const Left, Right: TMoney): TMoney;
    class operator Subtract(const Left, Right: TMoney): TMoney;

    class function Zero: TMoney; static;
  end;

implementation

uses
  System.SysUtils;

{ TMoney }

constructor TMoney.Create(Amount: Currency; const CurrencyCode: string);
begin
  if (FAmount <> 0) and (CurrencyCode = '') then
    raise EArgumentException.Create('Currency code needed for non-zero amounts');
  FAmount := Amount;
  FCurrencyCode := CurrencyCode;
end;

class function TMoney.Zero: TMoney;
begin
  Result.FAmount := 0;
  Result.FCurrencyCode := '';
end;

class operator TMoney.Add(const Left, Right: TMoney): TMoney;
begin
  if (Left.FCurrencyCode <> Right.CurrencyCode) and
    (Left.CurrencyCode <> '') and (Right.CurrencyCode <> '') then
    raise EArgumentException.Create('Addends are in different currencies');

  if Left.Amount = 0 then
    Result := Right
  else if Right.Amount = 0 then
    Result := Left
  else
    Result := TMoney.Create(Left.Amount + Right.Amount, Left.CurrencyCode);
end;

class operator TMoney.Subtract(const Left, Right: TMoney): TMoney;
begin
  Result := Left + TMoney.Create(-Right.FAmount, Right.CurrencyCode);
end;

end.

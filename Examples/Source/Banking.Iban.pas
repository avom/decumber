unit Banking.Iban;

interface

type
  TIban = record
  private
    FIban: string;
  public
    constructor Create(const Iban: string);

    property AsString: string read FIban;

    class operator Equal(const Left, Right: TIban): Boolean;
    class operator NotEqual(const Left, Right: TIban): Boolean;
  end;

implementation

uses
  System.SysUtils;

{ TIban }

constructor TIban.Create(const Iban: string);
begin
  FIban := Iban.Trim;
end;

class operator TIban.Equal(const Left, Right: TIban): Boolean;
begin
  Result := Left.FIban = Right.FIban;
end;

class operator TIban.NotEqual(const Left, Right: TIban): Boolean;
begin
  Result := Left.FIban <> Right.FIban;
end;

end.

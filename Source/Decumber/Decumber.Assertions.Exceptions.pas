unit Decumber.Assertions.Exceptions;

interface

uses
  Decumber.Exceptions;

type
  EAssertError = class(EDecumberException)
  public
    constructor Create(const Expected, Actual: string);
  end;

implementation

{ EAssertError }

constructor EAssertError.Create(const Expected, Actual: string);
begin
  inherited CreateFmt(
    'Expecting: ' + sLineBreak +
    '<%s>' + sLineBreak +
    'to be equal to: ' + sLineBreak +
    '<%s>' + sLineBreak +
    'but was not.',
    [Expected, Actual]);
end;

end.

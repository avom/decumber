unit Decumber.Exceptions;

interface

uses
  System.SysUtils;

type
  EDecumberException = class(Exception);
  EDecumberDuplicateStepDefinitionException = class(EDecumberException);
  EDecumberTestFailure = class(EDecumberException);

implementation

end.

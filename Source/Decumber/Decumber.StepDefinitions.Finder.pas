unit Decumber.StepDefinitions.Finder;

interface

uses
  System.Generics.Collections,
  System.Rtti,
  Decumber.StepDefinitions.Container;

type
  TStepDefinitionsFinder = class
  private
    FContext: TRttiContext;
  public
    constructor Create(const Context: TRttiContext);

    procedure FindAll(const Result: TList<IStepDefinitionsContainer>);
  end;

implementation

uses
  System.SysUtils,
  Decumber.StepDefinitions.Attributes;

{ TStepDefinitionsFinder }

constructor TStepDefinitionsFinder.Create(const Context: TRttiContext);
begin
  FContext := Context;
end;

procedure TStepDefinitionsFinder.FindAll(const Result: TList<IStepDefinitionsContainer>);
begin
  if Result = nil then
    raise EArgumentNilException.Create('Result');

  for var Typ in FContext.GetTypes do
  begin
    if Typ.TypeKind <> TTypeKind.tkClass then
      Continue;

    for var Method in Typ.GetMethods do
    begin
      if Method.HasAttribute<StepAttribute> then
        begin
          Result.Add(TStepDefinitionsContainer.Create(Typ));
          Break;
        end;
    end;
  end;
end;

end.

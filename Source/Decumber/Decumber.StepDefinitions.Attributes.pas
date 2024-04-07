unit Decumber.StepDefinitions.Attributes;

interface

type
  StepAttribute = class(TCustomAttribute)
  private
    FStep: string;
  public
    constructor Create(const Step: string);

    property Step: string read FStep;
  end;

  GivenAttribute = class(StepAttribute);
  WhenAttribute = class(StepAttribute);
  ThenAttribute = class(StepAttribute);
  AndAttribute = class(StepAttribute);
  ButAttribute = class(StepAttribute);

implementation

{ StepAttribute }

constructor StepAttribute.Create(const Step: string);
begin
  FStep := Step;
end;

end.

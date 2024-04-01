unit Decumber.StepDefinitions.Container;

interface

uses
  System.Generics.Collections,
  System.Rtti, System.SysUtils;

type
  IStepDefinitionsContainer = interface
    ['{F48B5B19-1408-4103-AF3D-5F25443CAD63}']
    function GetStepCount: Integer;

    function CreateInstance: TObject;
    procedure InvokeStep(Instance: TObject; const Step: string);

    function HasStep(const Step: string): Boolean;

    property StepCount: Integer read GetStepCount;
  end;

  TStepDefinitionsContainer = class(TInterfacedObject, IStepDefinitionsContainer)
  private
    FRttiType: TRttiType;
    FStepDefinitions: TDictionary<string, TRttiMethod>;
    FFormatSettings: TFormatSettings;
    function GetDefaultConstructor: TRttiMethod;
    function GetStepMethod(const Step: string): TRttiMethod;
    function GetStepCount: Integer;
    function GetStepDefinitions: TDictionary<string, TRttiMethod>;
    procedure InvokeStep(Instance: TObject; const Step: string);
  public
    constructor Create(const RttiType: TRttiType);
    destructor Destroy; override;

    function HasStep(const Step: string): Boolean;

    function CreateInstance: TObject;
  end;

implementation

uses
  System.RegularExpressions,
  System.TypInfo,
  Decumber.Exceptions,
  Decumber.StepDefinitions.Attributes;

{ TStepDefinitionsContainer }

constructor TStepDefinitionsContainer.Create(const RttiType: TRttiType);
begin
  if RttiType = nil then
    raise EArgumentNilException.Create('RttiType');
  FRttiType := RttiType;
  FFormatSettings := TFormatSettings.Create('EN-US');
end;

function TStepDefinitionsContainer.CreateInstance: TObject;
begin
  const Ctor = GetDefaultConstructor;
  Assert(Ctor <> nil, 'Object does not have a default constructor');
  Result := Ctor.Invoke(FRttiType.AsInstance.MetaclassType, []).AsObject;
end;

destructor TStepDefinitionsContainer.Destroy;
begin
  FStepDefinitions.Free;
  inherited;
end;

function TStepDefinitionsContainer.GetDefaultConstructor: TRttiMethod;
begin
  for var Method in FRttiType.GetMethods('Create') do
  begin
    if Method.IsConstructor and (Method.GetParameters = nil) then
      Exit(Method);
  end;
  Result := nil;
end;

function TStepDefinitionsContainer.GetStepCount: Integer;
begin
  Result := GetStepDefinitions.Count;
end;

function TStepDefinitionsContainer.GetStepDefinitions: TDictionary<string, TRttiMethod>;

  procedure AddMethod(const Step: string; Method: TRttiMethod);
  begin
    const Regex = Step.Replace('{}', '^(.*)$');
    if FStepDefinitions.ContainsKey(Regex) then
    begin
      raise EDecumberDuplicateStepDefinitionException.CreateFmt('Duplicate step definition "%s"',
        [Step]);
    end;
    FStepDefinitions.Add(Step, Method);
  end;

begin
  if FStepDefinitions = nil then
  begin
    FStepDefinitions := TDictionary<string, TRttiMethod>.Create;
    for var Method in FRttiType.GetMethods do
    begin
      const StepAttr = Method.GetAttribute<StepAttribute>;
      if StepAttr <> nil then
      begin
        AddMethod(StepAttr.Step, Method);
        Continue;
      end;
    end;
  end;
  Result := FStepDefinitions;
end;

function TStepDefinitionsContainer.GetStepMethod(const Step: string): TRttiMethod;
begin
  Result := nil;
  for var Pattern in GetStepDefinitions.Keys do
  begin
    const Expr = '^' + Pattern.Replace('{}',  '.*') + '$';
    if TRegEx.IsMatch(Step, Expr) then
      Exit(GetStepDefinitions[Pattern]);
  end;
end;

function TStepDefinitionsContainer.HasStep(const Step: string): Boolean;
begin
  Result := GetStepMethod(Step) <> nil;
end;

procedure TStepDefinitionsContainer.InvokeStep(Instance: TObject; const Step: string);

  procedure RaiseNotImplemented(const ArgType: string);
  begin
    raise ENotImplemented.CreateFmt('%s type arguments cannot not yet be passed to', [ArgType]) at
      ReturnAddress;
  end;

  function GetArgValue(const ParamType: TRttiType; const StrValue: string): TValue;
  begin
    case ParamType.TypeKind of
      tkFloat:
        begin
          if ParamType.Handle = TypeInfo(Currency) then
            Result := StrToCurr(StrValue, FFormatSettings)
          else
            RaiseNotImplemented(ParamType.ToString);
        end;
      else
        RaiseNotImplemented(ParamType.ToString);
    end;
  end;

begin
  if Instance = nil then
    raise EArgumentNilException.Create('Instance');

  const Method = GetStepMethod(Step);
  if Method = nil then
    raise EArgumentException.Create('Unknown step');

  const MethodParamCount = Length(Method.GetParameters);
  const Attr = Method.GetAttribute<StepAttribute>;
  const Matches = TRegEx.Matches(Attr.Step, '{}');

  if MethodParamCount <> Matches.Count then
  begin
    raise EDecumberException.CreateFmt(
      'Step "%s" is defined with %d parameters, but gherkin step has %d parameter',
      [Step, MethodParamCount, Matches.Count]);
  end;

  var Args: TArray<TValue>;
  SetLength(Args, MethodParamCount);

  const Pattern = '^' + Attr.Step.Replace('{}', '(.*)') + '$';
  const Match = TRegex.Match(Step, Pattern);

  for var i := 0 to MethodParamCount - 1 do
  begin
    const Param = Method.GetParameters[i];
    const StrValue = Match.Groups[i + 1].Value;
    Args[i] := GetArgValue(Param.ParamType, StrValue);
  end;

  Method.Invoke(Instance, Args);
end;

end.

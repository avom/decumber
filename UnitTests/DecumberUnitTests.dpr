program DecumberUnitTests;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}
{$STRONGLINKTYPES ON}
uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ELSE}
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  {$ENDIF }
  DUnitX.TestFramework,
  DecumberUnitTests.Gherkin.AstNodeTests in 'Tests\DecumberUnitTests.Gherkin.AstNodeTests.pas',
  DecumberUnitTests.Gherkin.LexerTests in 'Tests\DecumberUnitTests.Gherkin.LexerTests.pas',
  DecumberUnitTests.Gherkin.ParserTests in 'Tests\DecumberUnitTests.Gherkin.ParserTests.pas',
  Decumber.Exceptions in '..\Source\Decumber\Decumber.Exceptions.pas',
  Decumber.Gherkin.AstNode in '..\Source\Decumber\Decumber.Gherkin.AstNode.pas',
  Decumber.Gherkin.Exceptions in '..\Source\Decumber\Decumber.Gherkin.Exceptions.pas',
  Decumber.Gherkin.Lexer in '..\Source\Decumber\Decumber.Gherkin.Lexer.pas',
  Decumber.Gherkin.Parser in '..\Source\Decumber\Decumber.Gherkin.Parser.pas',
  Decumber.Gherkin.Token in '..\Source\Decumber\Decumber.Gherkin.Token.pas',
  Decumber in '..\Source\Decumber\Decumber.pas',
  Decumber.StepDefinitions.Attributes in '..\Source\Decumber\Decumber.StepDefinitions.Attributes.pas',
  Decumber.StepDefinitions.Container in '..\Source\Decumber\Decumber.StepDefinitions.Container.pas',
  Decumber.StepDefinitions.Finder in '..\Source\Decumber\Decumber.StepDefinitions.Finder.pas',
  Decumber.TestRunner.Scenario in '..\Source\Decumber\Decumber.TestRunner.Scenario.pas';

{$IFNDEF TESTINSIGHT}
var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
  nunitLogger : ITestLogger;
{$ENDIF}
begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
{$ELSE}
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //When true, Assertions must be made during tests;
    runner.FailsOnNoAsserts := False;

    //tell the runner how we will log things
    //Log to the console window if desired
    if TDUnitX.Options.ConsoleMode <> TDunitXConsoleMode.Off then
    begin
      logger := TDUnitXConsoleLogger.Create(TDUnitX.Options.ConsoleMode = TDunitXConsoleMode.Quiet);
      runner.AddLogger(logger);
    end;
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
{$ENDIF}
end.

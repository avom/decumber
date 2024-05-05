# Decumber

Decumber is a Delphi library for running automated acceptance tests written in plain language ([Gherkin](https://cucumber.io/docs/gherkin/)).

```Gherkin
Feature: Bank account

    Scenario: Money transferred to and from a bank account
        Given I have an empty bank account
        When I receive a payment of 1000 euros
        And I pay 300 euros for rent
        Then I have 700 euros left in my bank account
```

```Delphi
[Given('I have an empty bank account')]
procedure i_have_an_empty_bank_account;

[When('I receive a payment of {} euros')]
procedure i_receive_a_payment_of_euros(Amount: Currency);

[And_('I pay {} euros for rent')]
procedure i_pay_euros_for_rent(Amount: Currency);

[Then_('I have {} euros left in my bank account')]
procedure i_have_euros_left_in_my_bank_account(Balance: Currency);
```

How to use:
1. The library is self-contained. Add the library source path to the project's search path.
2. Set `{$STRONGLINKTYPES ON}` compiler directive in .dpr file.
3. Include unit `Decumber` in uses clauses. You'll never need to include any other unit.
4. Call `TDecumber.RunTests('path\to\features\written\in\gherkin');`

What's supported:
* Feature, Scenario, Given, When, Then, And, But, and * keywords.
* Support for different parameter types in step definitions is limited.

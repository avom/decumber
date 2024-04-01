Feature: Bank account

    Scenario: Money transferred to a bank account
        Given the bank account with empty starting balance
        When 200 euros are transferred to the account
        Then the account balance is 200 euros

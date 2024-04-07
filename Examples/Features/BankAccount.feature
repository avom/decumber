Feature: Bank account

    Scenario: Money transferred to a bank account
        Given I have an empty bank account
        When I receive a payment of 1000 euros
        And I pay a 50.80 electricity bill
        And I pay 15.99 for a cell phone bill
        And I pay 300 euros for rent
        Then I have 633.22 euros left in my bank account

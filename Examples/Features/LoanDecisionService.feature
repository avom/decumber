Feature: Loan Decision Service

    Scenario: Loan applicant is under 18 years old
        Given the loan applicant is 17 years old
          And he has a regular net income of 1000 euros a month
          And has 0 euros of existing monthly financial obligations
         When he applies for a 30000 euro home Loan
          And wants to pay it back in 30 years
         Then the application should be denied

    Scenario: Loan applicant would be 70 years old before the last payment
        Given the loan applicant is 40 years old
          And he has a regular net income of 1000 euros a month
          And has 0 euros of existing monthly financial obligations
         When he applies for a 30000 euro home Loan
          And wants to pay it back in 30 years
         Then the application should be denied

    Scenario: Payments with existing obligations would exceed 30% of the income
        Given the loan applicant is 30 years old
          And he has a regular net income of 1000 euros a month
          And has 290 euros of existing monthly financial obligations
         When he applies for a 30000 euro home Loan
          And wants to pay it back in 30 years
         Then the application should be denied

    Scenario: Approved application
        Given the loan applicant is 30 years old
          And he has a regular net income of 1000 euros a month
          And has 0 euros of existing monthly financial obligations
         When he applies for a 30000 euro home Loan
          And wants to pay it back in 30 years
         Then the application should be approved

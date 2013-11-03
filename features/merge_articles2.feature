Feature: Merge Articles
    As a blog administrator
    In order to remove duplicated articles
    I want to be able to merge articles with same topic

    Background: articles and users have been added to database

        Given the blog is set up

        Given the following users exist:
            | login         | password         | email                    | name             | profile_id |
            | publisher     | publisher_pw     | publisher@domain.org     | Blog Publisher   | 2          |
            | administrator | administrator_pw | administrator@domain.org | Blog Admin       | 1          |

        Given the following articles exist:
            | id | title    | author | user_id | body     | allow_comments | published | published_at        | state     | type    |
            | 3  | Article1 | user_1 | 2       | Content1 | true           | true      | 2012-23-11 21:30:00 | published | Article |
            | 4  | Article2 | user_2 | 3       | Content2 | true           | true      | 2012-24-11 22:00:00 | published | Article |

        Given the following comments exist:
            | id | type    | author | body     | article_id | user_id | created_at          |
            | 1  | Comment | user_1 | Comment1 | 3          | 2       | 2012-23-11 21:31:00 |
            | 2  | Comment | user_1 | Comment2 | 4          | 2       | 2012-24-11 22:01:00 |

    Scenario: An admin can see the option to merge articles
        Given I am logged into the admin panel as "administrator"
        And I visit the the edit page for "Article1"
        Then I should see "Merge Articles"

    Scenario: A non-admin cannot see the option to merge articles
        Given I am logged into the admin panel as "publisher"
        And I visit the the edit page for "Article1"
        Then I should not see "Merge Articles"

    Scenario: The merged articles should contain the text of both previous articles
        Given the articles with ids "3" and "4" were merged
        And I am on the home page
        Then I should see "Article1"
        When I follow "Article1"
        Then I should see "Content1"
        And I should see "Content2"

    Scenario: Comments on each of the two articles need to all be carried over
        Given the articles with ids "3" and "4" were merged
        And I am on the home page
        Then I should see "Article1"
        When I follow "Article1"
        Then I should see "Comment1"
        And I should see "Comment2"

    Scenario: The title should be either one of the merged articles
        Given the articles with ids "3" and "4" were merged
        And I am on the home page
        Then I should see "Article1"
        And I should not see "Article2"
When /^I am logged into the admin panel as "(.*)"$/ do |login|
  visit '/accounts/login'
  fill_in 'user_login', :with => login
  fill_in 'user_password', :with => login + "_pw"
  click_button 'Login'
  if page.respond_to? :should
    page.should have_content('Login successful')
  else
    assert page.has_content?('Login successful')
  end
end

When /^I (re)?visit the the edit page for "(.*)"$/ do |re, title|
  visit 'admin/content/edit/' + Article.find_by_title(title).id.to_s
end

When /^I attempt to merge with "(.*)"$/ do |title|
  fill_in 'merge_with', :with => Article.find_by_title(title).id
  click_button 'Merge'
end


Given /the following (.*?) exist:$/ do |type, table|
  table.hashes.each do |element|
    if    type == "users"    then User.create(element)
    elsif type == "articles" then Article.create(element)
    elsif type == "comments" then Comment.create(element)
    end
  end
end

Given /I am logged in as "(.*?)" with pass "(.*?)"$/ do |user, pass|
  visit '/accounts/login'
  fill_in 'user_login', :with => user
  fill_in 'user_password', :with => pass
  click_button 'Login'
  assert page.has_content? 'Login successful'
end

Given /the articles with ids "(\d+)" and "(\d+)" were merged$/ do |id1, id2|
  article = Article.find_by_id(id1)
  article.merge_with(id2)
end

Then /"(.*?)" should be author of (\d+) articles$/ do |user, count|
  assert Article.find_all_by_author(User.find_by_name(user).login).size == Integer(count)
end

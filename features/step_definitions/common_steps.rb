Then(/^I should see "([^"]*)" message$/) do |message|
  find('.alert').should have_content message
end

And(/^I should have "([^"]*)" actions available for table row "([^"]*)"$/) do |actions, name|
  row_text = find(:xpath, "//tr[contains(td/a, '#{name}')]").text.downcase
  actions_arr = actions.split(',').map{|a| a.strip}

  if actions_arr.include? 'edit'
    row_text[I18n.t('dictionary.edit').downcase].length.should be > 0
  end

  if actions_arr.include? 'delete'
    row_text[I18n.t('dictionary.delete').downcase].length.should be > 0
  end

  if actions_arr.include? 'show'
    row_text[I18n.t('dictionary.show').downcase].length.should be > 0
  end

  if actions_arr.include? 'any'
    row_text[I18n.t('dictionary.show').downcase].should be_nil
    row_text[I18n.t('dictionary.edit').downcase].should be_nil
    row_text[I18n.t('dictionary.delete').downcase].should be_nil
  end
end

And(/^I click button "(.*?)"$/) do |btn_text|
  click_button(btn_text)
end

When /^I confirm popup$/ do
  page.driver.browser.switch_to.alert.accept
end

When /^I dismiss popup$/ do
  page.driver.browser.switch_to.alert.dismiss
end
# encoding: UTF-8

Given /^the user visits the formula search page$/ do
  visit '/'
end

When /^the (symptoms|pulse|tongue|diagnosis) (?:are|is) '([^']*)'$/ do | field, value |
  fill_in field, with: value
end

When /^the search is initiated$/ do
  click_button 'Search'
end

When /^the user searches for '([^']*)', '([^']*)', '([^']*)', and '([^']*)'$/ do | s, p, t, d |
  fill_in 'symptoms', with: s
  fill_in 'pulse', with: p
  fill_in 'tongue', with: t
  fill_in 'diagnosis', with: d
  click_button 'Search'
end

Then /^a results table is shown$/ do
  page.should have_css('table.results-table')
end

Then /^no results table or formulas are displayed$/ do
  page.should_not have_css('table.results-table')
  page.should_not have_css('formula-row')
end

Then /^these formulas and ranking graphs are displayed$/ do | expected_table|
  # the css width of the progress bar corresponds to the relevance of the formula 
  ranks = all('td.progress-bar .progress .bar').map{ |e| e['style'][/\d+/] }
  names = all('td.formula-info').map{ |e| e.text.strip }
  actual_table = ranks.zip(names)

  expected_table.diff! actual_table
end

Then /^the first formula listed should be '([^']+)'\.$/ do | top_formula |
  first('td.formula-info').text.strip.should == top_formula
end

When /^the user types 'fever' into the 'symptoms' field and moves to another field$/ do
  page.execute_script "$('input#symptoms').focus().val('fever').trigger('change')"
end

Then /^the results should immediately update$/ do
  sleep 1
end

Given /^there is no popover displayed for the first formula$/ do
  expect { page.find('.popover-content') }.should raise_error
end

When /^the user hovers over that formula's row$/ do
  page.first('tr.formula-row').text.should == "qīng hào biē jiǎ tāng"
  page.execute_script "$('tr.formula-row').first().trigger('mouseover')"
end

Then /^that row's popover is displayed$/ do
  page.find('.popover-title').text.should match /qīng hào biē jiǎ tāng/
end

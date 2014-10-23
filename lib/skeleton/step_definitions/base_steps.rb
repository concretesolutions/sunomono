######### GIVEN #########

Given(/^I (?:drag|dragged) the screen (down|up|left|right) until I see the element "(.*?)"$/) do |direction, element|
  @page.drag_until_element_is_visible_with_special_query direction.to_sym, element
end

Given(/^I am on a page that contains '(.*?)'$/) do |page_text|
  @page.is_on_page? page_text
end

######### WHEN #########

When(/^I drag the screen (left|right|down|up) (\d+) times$/) do |direction, times|
  @page.drag_for_specified_number_of_times(direction.to_sym, times.to_i)
end

When(/^I (?:touch|touched) the "(.*?)" element$/) do |element|
  @page.touch_screen_element element
end

When(/^I drag the screen (down|up|left|right)$/) do |direction|
  @page.drag_to direction.to_sym
end

######### THEN #########

Then(/^I (?:wait|waited) for the progress bar to vanish$/) do
  # wait_for_progress is a method of the base class, so doesn't matter what is the value
  # of the @page variable, because all screens will have this method
  @page.wait_for_progress
end

Then(/^I should see the page '(.*?)'$/) do |page_text|
  @page.is_on_page? page_text
end

Then(/^I should see a page that contains '(.*?)'$/) do |page_text|
  @page.is_on_page? page_text
end
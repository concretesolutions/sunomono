require 'calabash-android/abase'

class AndroidScreenBase < Calabash::ABase

  def self.element element_name
    define_method element_name.to_s
  end

  class << self
    alias :value :element
    alias :action :element
    alias :trait :element
  end

  element(:loading_screen)      {"insert_loading_view_id"}

  # The progress bar of the application is a custom view
  def wait_for_progress
    wait_for_element_does_not_exist(loading_screen)
  end

  def drag_to direction

    positions = [0,0,0,0] # [ 'from_x', 'to_x', 'from_y', 'to_y' ]

    case(direction)
    when :down
      positions = [30,30,60,30]
    when :up
      positions = [80,80,60,90]
    when :left
      positions = [90,20,80,80]
    when :right
      positions = [20,90,80,80]
    end

    # perform_action( 'action', 'from_x', 'to_x', 'from_y', 'to_y', 'number of steps (in this case, velocity of drag' )
    perform_action('drag', positions[0], positions[1], positions[2], positions[3], 15)
    
    sleep(1)
  end

  def drag_until_element_is_visible_with_special_query direction, element
    drag_until_element_is_visible direction, element, "* {text CONTAINS[c] '#{element}'}"
  end

  def drag_until_element_is_visible direction, element, query = nil, limit = 15
    i = 0

    element_query = ""
    if query.nil?
      element_query = "* marked:'#{element}'"
    else
      element_query = query
    end

    sleep(2)
    while( !element_exists(element_query) and i < limit) do
      drag_to direction
      i = i + 1
    end

    raise ("Executed #{limit} moviments #{direction.to_s} and the element '#{element}' was not found on this view!") unless i < limit
  end

  def drag_for_specified_number_of_times direction, times
    times.times do
      drag_to direction
    end
  end

  def is_on_page? page_text

    begin
      wait_for(:timeout => 5) { has_text? page_text }
    rescue
      raise "Unexpected Page. Expected was: '#{page_text}'"
    end
  end

  def enter text, element, query = nil
    if query.nil?
      query( "* marked:'#{element}'", {:setText => text} )
    else
      query( query, {:setText => text} )
    end
  end

  def touch_element_by_index id, index
    wait_for(:timeout => 5) { element_exists("* id:'#{id}' index:#{index}") }
    touch("* id:'#{id}' index:#{index}")
  end

end

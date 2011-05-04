module ApplicationHelper
  def formatted_date(date)
    date.strftime('%m/%d/%Y') unless date.blank?
  end
  
  def formatted_time(time)
    time.strftime('%m/%d/%Y %I:%M %p') unless time.blank?
  end
end

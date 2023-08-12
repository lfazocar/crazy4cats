module ArticlesHelper
  def time_passed(time)
    seconds = (Time.now - time).round
    if seconds == 0
      return 'Just now'
    end
    minutes, seconds = seconds.divmod(60)
    hours, minutes = minutes.divmod(60)
    result = ""
    if hours > 0
      result += hours.to_s
      if hours > 1
        result += " hours "
      else
        result += " hour "
      end
    end
    if minutes > 0
      result += minutes.to_s
      if minutes > 1
        result += " minutes "
      else
        result += " minute "
      end
    end
    if seconds > 0
      result += seconds.to_s
      if seconds > 1
        result += " seconds "
      else
        result += " second "
      end
    end
    result += "ago"
  end
end

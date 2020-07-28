
require 'ostruct'

class Car_wash 

attr_accessor= :enter_time
def initialize
    @reservation=Array.new
    @enter_time = Time.now
end

START_SCHEDULE = 8
END_SCHEDULE = 16
START_SCHEDULE_WEEKEND= 9
END_SCHEDULE_WEEKEND= 14

def schedule(enter_time) 
    today=enter_time.strftime("%A")
    case today
    when "Saturday"
        open_hour = START_SCHEDULE_WEEKEND
        close_hour = END_SCHEDULE_WEEKEND
    when "Sunday"
        return nil
    else
        open_hour = START_SCHEDULE
        close_hour = END_SCHEDULE
    end

    @today_open = open_hour   
    @today_close = close_hour
    
end

def worker_availability(enter_time)
    if @reservation.empty? 
        return [1, process_request(enter_time)]
    end
    if @reservation.length() == 1
        return [3 - @reservation[0].worker, process_request(enter_time)]
    end
    if @reservation[-2].pickup_time < enter_time
        return [@reservation[-2].worker, process_request(enter_time)]
    end
    if @reservation[-1].pickup_time < enter_time
        return [@reservation[-1].worker, process_request(enter_time)]
    end  
    return [@reservation[-2].worker, process_request(@reservation[-2].pickup_time)]
end

def pickup_time(enter_time)
    #puts enter_time
    schedule(enter_time)
    availability=worker_availability(enter_time)
    #puts availability
    entry=OpenStruct.new
    entry.enter_time=enter_time
    entry.worker=availability[0]
    entry.pickup_time=Time.at(availability[1])
    @reservation.push(entry)
    #print entry
    return entry.pickup_time.strftime("%A %d-%m-%Y %H:%M")   
end

def process_request(process_time)
    process_time = @enter_time + (2*60*60)
    if @today_close >= process_time.hour 
        out_time = process_time 
    elsif @enter_time.saturday?
        out_time = process_time+(43*60*60) 
    elsif @enter_time.friday?
        out_time =process_time+ (17*60*60) 
    else
        out_time = process_time +(16*60*60)         
    end
    return out_time
end

end








require 'ostruct'
require 'byebug'

class Car_wash 

attr_accessor :enter_time, :reservation
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

def can_process_now?(enter_time)
    if @reservation.empty? || @reservation.length() == 1 || [@reservation[-1].pickup_time, @reservation[-2].pickup_time].any? {|pickup_time| pickup_time <enter_time }
        true
   else
        false
   end
end 

def worker_availability(enter_time)
    if @reservation.empty? 
        return [1, true, process_request(enter_time)]
    end
    if @reservation.length() == 1
        return [3 - @reservation[0].worker, true, process_request(enter_time)]
    end
    if @reservation[-2].pickup_time < enter_time
        return [@reservation[-2].worker, true, process_request(enter_time)]
    end
    if @reservation[-1].pickup_time < enter_time
        return [@reservation[-1].worker, true, process_request(enter_time)]
    end  
    
    [@reservation[-2].worker, false, process_request(enter_time)]
end

def pickup_time(enter_time)
    puts enter_time
    schedule(enter_time)
    availability=worker_availability(enter_time)
    #puts availability
    entry=OpenStruct.new
    if can_process_now?(enter_time)
        entry.enter_time=enter_time
    else
        entry.enter_time=@reservation[-2].pickup_time
    end
    
    availability=worker_availability(entry.enter_time)
    entry.worker=availability[0]
    entry.pickup_time=Time.at(availability[2])
    @reservation.push(entry)
    print entry
    #print @reservation
    return entry.pickup_time.strftime("%A %d-%m-%Y %H:%M")   
end

def process_request(process_time)
    process_time = process_time + (2*60*60)
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







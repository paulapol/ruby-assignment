
require 'ostruct'

class Car_wash 

attr_accessor= :enter_time
def initialize
    @reservation=Array.new
    @enter_time = Time.new
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

    @today_open = Time.now(Time.now.year, Time.now.month, Time.now.day, open_hour,0,0)   
    @today_close = Time.now(Time.now.year, Time.now.month, Time.now.day, close_hour,0,0) 
    
end

def worker_availability(enter_time)
    if @reservation.empty? 
        return [1, process_request(@enter_time) ]
    end
    if @reservation.length() == 1
        return [3 - @reservation[0].worker, process_request(@enter_time)]
    end
    if @reservation[-2].pickup_time < @enter_time
        return [@reservation[-2].worker, process_request(@enter_time)]
    end
    if @reservation[-1].pickup_time < @enter_time
        return [@reservation[-1].worker, process_request(@enter_time)]
    end  
    return [@reservation[-2].worker, process_request(@reservation[-2].pickup_time)]
end

def pickup_time(enter_time)
    puts enter_time
    schedule(enter_time)
    availability=worker_availability(enter_time)

    entry=OpenStruct.new
    entry.enter_time=enter_time
    entry.worker=availability[0]
    entry.pickup_time=Time.at(availability[1])
    @reservation.push(entry)
    #print entry
    return entry.pickup_time.strftime("%A %d-%m-%Y %H:%M")   
end

def process_request(process_time)
    process_time = @enter_time + 2*60*60
    if @today_close >= process_time 
        out_time = process_time 
        puts @today_close-@enter_time
    elsif @enter_time.saturday?
        out_time = 43*60*60 + (@today_close-@enter_time)
    elsif @enter_time.friday?
        out_time = 17*60*60 + (@today_close-@enter_time)
    else
        out_time = 16*60*60 + (@today_close-@enter_time)        
    end
end
end






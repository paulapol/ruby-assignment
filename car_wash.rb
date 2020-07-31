require 'ostruct'

class Car_wash 

attr_accessor :enter_time, :reservation
def initialize
    @reservations = Array.new
    @enter_time = Time.now
end

START_SCHEDULE = 8
END_SCHEDULE = 16
START_SCHEDULE_WEEKEND = 9
END_SCHEDULE_WEEKEND = 14
FORTY_THREE_HOURS = 43*60*60
SEVENTEEN_HOURS = 17*60*60
SIXTEEN_HOURS = 16*60*60

def schedule(enter_time) 
    today = enter_time.strftime("%A")
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
    if @reservations.empty? || @reservations.length() == 1 || [@reservations[-1].pickup_time, @reservations[-2].pickup_time].any? { |pickup_time| pickup_time <enter_time }
        true
    else
        false
    end
end 

def worker_availability(enter_time)
    pickup_time = process_request(enter_time)
    if @reservations.empty? 
        return { worker_id: 1, pickup_time: pickup_time }
    end
    if @reservations.length() == 1
        return { worker_id: 3 - @reservations[0].worker, pickup_time: pickup_time }
    end
    if @reservations[-2].pickup_time < enter_time
        return { worker_id: @reservations[-2].worker, pickup_time: pickup_time }
    end
    if @reservations[-1].pickup_time < enter_time
        return { worker_id: @reservations[-1].worker, pickup_time: pickup_time }
    end  
    
    { worker_id: @reservations[-2].worker, pickup_time: pickup_time }
end

def pickup_time(enter_time)
    schedule(enter_time)
    entry=OpenStruct.new
    if can_process_now?(enter_time)
        entry.enter_time = enter_time
    else
        entry.enter_time = @reservations[-2].pickup_time
    end
    availability = worker_availability(entry.enter_time)
    entry.worker = availability[:worker_id]
    entry.pickup_time = Time.at(availability[:pickup_time])
    @reservations.push(entry)

    entry.pickup_time.strftime("%A %d-%m-%Y %H:%M")   
end

def process_request(process_time)
    process_time = process_time + (2*60*60)
    if @today_close >= process_time.hour 
        out_time = process_time 
    elsif @enter_time.saturday?
        out_time = process_time + FORTY_THREE_HOURS 
    elsif @enter_time.friday?
        out_time = process_time + SEVENTEEN_HOURS 
    else
        out_time = process_time + SIXTEEN_HOURS         
    end
    out_time
end

end

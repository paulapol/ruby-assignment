require_relative "../car_wash"
require 'rspec'

include RSpec


describe Car_wash do
    context "leave it today, take it today" do
        it "should print Monday at 14:30" do
            car_wash=Car_wash.new
            allow(Time).to receive(:now).and_return(Time.new(2020,07,27,12,30))
            print Time.now
            expect(car_wash.pickup_time(Time.new)).to eq 'Monday 27-07-2020 14:30 '
        end
    end
    context "leave it today, take it tomorrow" do
        it "should print Tuesday at 9:00" do
            car_wash=Car_wash.new
            allow(Time).to receive(:now).and_return(Time.new(2020,07,27,15,00))
            expect(car_wash.pickup_time(Time.new)).to eq 'Tuesday 28-07-2020 9:00 '
        end
    end
    context "leave it today, take it next week" do
        it "should print Monday at 9:45" do
            car_wash=Car_wash.new
            allow(Time).to receive(:now).and_return(Time.new(2020,8,1,13,45))
            expect(car_wash.pickup_time(Time.new)).to eq 'Monday 03-08-2020 9:45 '
        end
    end
    context "more cars at the same time" do
        it "the first 8 cars should be picked up today, the next the other day" do
            car_wash=Car_wash.new
            allow(Time).to receive(:now).and_return(Time.new(2020,07,27,8,00))
            car_wash.pickup_time(Time.new)
            car_wash.pickup_time(Time.new)
            car_wash.pickup_time(Time.new)
            car_wash.pickup_time(Time.new)
            car_wash.pickup_time(Time.new)
            car_wash.pickup_time(Time.new)
            car_wash.pickup_time(Time.new)
            car_wash.pickup_time(Time.new)
            expect(car_wash.pickup_time(Time.new)).to eq 'Tuesday 28-07-2020 10:00'
        end
    end
    context "2 cars at 8 and one at 9:30" do
        it "should print the first 2 cars at 10 and the 3rd at 12" do
            car_wash=Car_wash.new
            allow(Time).to receive(:now).and_return(Time.new(2020,07,27,8,00))
            car_wash.pickup_time(Time.new)
            expect(car_wash.pickup_time(Time.new)).to eq 'Monday 27-07-2020 10:00'
            allow(Time).to receive(:now).and_return(Time.new(2020,07,27,9,30))
            expect(car_wash.pickup_time(Time.new)).to eq 'Monday 27-07-2020 12:00'
        end
    end
end
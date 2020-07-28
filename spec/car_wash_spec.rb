require_relative "../car_wash"
require 'rspec'

include RSpec


describe Car_wash do
    context "leave it today, take it today" do
        it "should print Wednesday at 14:30" do
            allow(Time).to receive(:now).and_return(Time.new(2020,07,29,12,30))
            car_wash=Car_wash.new
            expect(car_wash.pickup_time(Time.now)).to eq 'Wednesday 29-07-2020 14:30'
        end
    end
    context "leave it today, take it tomorrow" do
        it "should print Tuesday at 9:00" do
            allow(Time).to receive(:now).and_return(Time.new(2020,07,27,15,00))
            car_wash=Car_wash.new
            expect(car_wash.pickup_time(Time.now)).to eq 'Tuesday 28-07-2020 09:00'
        end
    end
    context "leave it today, take it next week" do
        it "should print Monday at 9:45" do
            allow(Time).to receive(:now).and_return(Time.new(2020,8,1,13,45))
            car_wash=Car_wash.new
            expect(car_wash.pickup_time(Time.now)).to eq 'Monday 03-08-2020 10:45'
        end
    end
    context "more cars at the same time" do
        it "the first 8 cars should be picked up today, the next the other day" do
            allow(Time).to receive(:now).and_return(Time.new(2020,07,27,8,00))
            car_wash=Car_wash.new
            car_wash.pickup_time(Time.now)
            car_wash.pickup_time(Time.now)
            car_wash.pickup_time(Time.now)
            car_wash.pickup_time(Time.now)
            car_wash.pickup_time(Time.now)
            car_wash.pickup_time(Time.now)
            car_wash.pickup_time(Time.now)
            car_wash.pickup_time(Time.now)
            expect(car_wash.pickup_time(Time.now)).to eq 'Tuesday 28-07-2020 10:00'
        end
    end
    context "2 cars at 8 and one at 9:30" do
        it "should print the first 2 cars at 10 and the 3rd at 12" do
            allow(Time).to receive(:now).and_return(Time.new(2020,07,27,8,00))
            car_wash=Car_wash.new
            car_wash.pickup_time(Time.now)
            expect(car_wash.pickup_time(Time.now)).to eq 'Monday 27-07-2020 10:00'
            allow(Time).to receive(:now).and_return(Time.new(2020,07,27,9,30))
            car_wash=Car_wash.new
            expect(car_wash.pickup_time(Time.now)).to eq 'Monday 27-07-2020 12:00'
        end
    end
end
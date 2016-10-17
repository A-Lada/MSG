require './app.rb'

describe Timer do
  it "returns 0 because is less then an hour after msg creation" do
    timer = Timer.new
    expect(timer.distance_between( Time.parse("2013-11-21 23:37:49.786056"),  Time.parse("2013-11-22 00:16:23.419408"))).to eq(0)
  end

  it "returns 1 because there was an hour after msg creation" do
    timer = Timer.new
    expect(timer.distance_between( Time.parse("2013-11-21 19:37:49.786056"),  Time.parse("2013-11-21 20:37:49.786056"))).to eq(1)
  end
end
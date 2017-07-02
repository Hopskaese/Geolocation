
def distance loc1, loc2
  rad_per_deg = Math::PI/180  # PI / 180
  rkm = 6371                  # Earth radius in kilometers
  rm = rkm * 1000             # Radius in meters

  dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
  dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

  lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
  lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

  a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
  c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

  rm * c # Delta in meters
end

def number_or_nil(string)
  Float(string || '')
rescue ArgumentError
  nil
end


if(ARGV.length < 5)
	abort("Not enough arguments provided")
	exit(1);
elsif(ARGV.length > 5)
	abort("Too many arguments provided")
end

lat1 = number_or_nil(ARGV[0])
long1 = number_or_nil(ARGV[1])
lat2 = number_or_nil(ARGV[2])
long2 = number_or_nil(ARGV[3])
radius = number_or_nil(ARGV[4])

if(lat1 == nil || long1 == nil || lat2 == nil || long2 == nil || radius == nil)
	abort("Was not able to transfer one or multiple input values to float")
end

#calculating sides
loc1 = Array.new(lat1, long1)
loc2 = Array.new(lat2, long1)

loc3 = Array.new(lat1, long1)
loc4 = Array.new(lat1, long2)

test1 = Array.new(38.0, 50.0)
test2 = Array.new(38.0, 70.0)

a = distance(loc1, loc2)
b = distance(loc3, loc4)
c = distance(test1, test2)
c /= 1000
puts "#{c}"

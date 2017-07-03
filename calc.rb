# [0] = lat -> Breitengrad
# [1] = long -> Längengrad

def distance loc1, loc2
  rad_per_deg = Math::PI/180  # PI / 180                      
  rkm = 6371   # Earth radius in kilometers 
  dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
  dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

  lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
  lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

  a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
  c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

  rkm * c
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
elsif(lat1 > 360 || lat1 < -360|| lat2 > 360 || lat2 < -360)
  abort("Lat cant be bigger than 360 degrees!")
elsif(long1 > 180 || long1 < -180 || long2 > 180 || long2 < -180)
  abort("Long cant be bigger than 180 degrees!")
end

#calculating sides
loc1 = Array[lat1, long1]
loc2 = Array[lat1, long2]

loc3 = Array[lat1, long1]
loc4 = Array[lat2, long1]

a = distance(loc1, loc2)
b = distance(loc3, loc4)

#Calculating max square inside circle
a2 = radius * Math.sqrt(2)

circles_hori = a / a2
circles_verti = b / a2

circles_hori = circles_hori.ceil
circles_verti = circles_verti.ceil

#center_points = Hash.new(Array.new)

new_lat = lat1 + (a2 / 6371) * (180 / Math::PI)
new_long = long1 + (a2 / 6371) * (180 / Math::PI) / Math.cos(lat1 * Math::PI/180)

a2 = new_lat - lat1
b2 = new_long - long1

lat = lat1 + a2
long = long1
cnt = 0

file = open("output.txt", 'w')
line = ""

(1..circles_verti).each do |i|
  lat -= a2
  long = long1
  (1..circles_hori).each do |j|
   line = "#{(lat-a2/2)}, #{(long+b2/2)}"
   file.write(line)
   file.write("\n")
   long += b2
   cnt += 1
  end
end

file.close
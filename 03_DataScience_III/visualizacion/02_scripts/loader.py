# This library helps to clean, load and transform the initial data.


# libraries
from geopy.geocoders import Nominatim




# attributes
def decimal_to_adress(coor = ['40.4165', '-3.70256']):
    geolocator = Nominatim(user_agent = 'carlosgranden@gmail.com')
    location = geolocator.reverse(coor[0] + ',' + coor[1])
    return location.raw['address']




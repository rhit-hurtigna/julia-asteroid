hi = 3

print("$hi\n");
Mercury_a0 = 0.38709927
Mercury_aCy = 0.00000037
Mercury_e0 = 0.20563593
Mercury_eCy = 0.00001906
Mercury_I0 = 7.00497902
Mercury_ICy = -0.00594749
Mercury_L0 =  252.25032350
Mercury_LCy = 149472.67411175
Mercury_longPeri0 = 77.45779628
Mercury_longPeriCy = 0.16047689
Mercury_longNode0 =  48.33076593
Mercury_longNodeCy = -0.12534081
CurrentJulianDay = 2460079.500000000
CurrentT = (CurrentJulianDay - 2451545.0)/36525

Mercury_a = Mercury_a0 + Mercury_aCy*CurrentT
Mercury_e = Mercury_e0 + Mercury_eCy*CurrentT
Mercury_I = Mercury_I0 + Mercury_ICy*CurrentT
Mercury_L = Mercury_L0 + Mercury_LCy*CurrentT
print("Mercury_L is $Mercury_L\n")
Mercury_longPeri = Mercury_longPeri0 + Mercury_longPeriCy*CurrentT
print("Mercury_longPeri is $Mercury_longPeri\n")
Mercury_longNode = Mercury_longNode0 + Mercury_longNodeCy*CurrentT

Mercury_W = Mercury_longPeri - Mercury_longNode
Mercury_M = Mercury_L - Mercury_longPeri
print("Mercury_M is $Mercury_M before modulo\n")
while Mercury_M>180
    global Mercury_M = Mercury_M-360
end
print("Mercury_M is $Mercury_M post modulo\n")
# print("Mercury_M mod is  $(Mercury_M%180)\n")

function iterateOnE(Planet_M,Planet_e,Planet_EN,Planet_EStar)
    Planet_DM = Planet_M-(Planet_EN-Planet_EStar*sind(Planet_EN))
    Planet_DE = Planet_DM/(1-Planet_e*cosd(Planet_EN))
    Planet_EN + Planet_DE
end

Mercury_EStar = (180/pi)*Mercury_e
Mercury_E0 = Mercury_M - Mercury_EStar*sind(Mercury_M)
Mercury_EN = iterateOnE(Mercury_M,Mercury_e,Mercury_E0,Mercury_EStar)
Mercury_ENPrev = Mercury_E0
count = 0
# while count <=100
while (abs(Mercury_EN-Mercury_ENPrev))>0.0000001 && count <= 10
    print("$(Mercury_EN-Mercury_ENPrev)\n")
    global Mercury_ENPrev = Mercury_EN
    global count = count+1
    global Mercury_EN = iterateOnE(Mercury_M,Mercury_e,Mercury_EN,Mercury_EStar)
    # print("$(Mercury_EN)\n")
end
print("$(Mercury_EN-Mercury_ENPrev)\n")
print("EN turned out to be $Mercury_EN\n")
Mercury_XP = Mercury_a*(cosd(Mercury_EN)-Mercury_e)
Mercury_YP = Mercury_a*sqrt(1-Mercury_e^2)*sind(Mercury_EN)
Mercury_ZP = 0
Mercury_XECL = (cosd(Mercury_W)*cosd(Mercury_longNode)-sind(Mercury_W)*sind(Mercury_longNode)*cosd(Mercury_I))*Mercury_XP + (-sind(Mercury_W)*cosd(Mercury_longNode)-cosd(Mercury_W)*sind(Mercury_longNode)*cosd(Mercury_I))*Mercury_YP
Mercury_YECL = (cosd(Mercury_W)*sind(Mercury_longNode)+sind(Mercury_W)*cosd(Mercury_longNode)*cosd(Mercury_I))*Mercury_XP + (-sind(Mercury_W)*sind(Mercury_longNode)+cosd(Mercury_W)*cosd(Mercury_longNode)*cosd(Mercury_I))*Mercury_YP
Mercury_ZECL = (sind(Mercury_W)*sind(Mercury_I))*Mercury_XP+(cosd(Mercury_W)*sind(Mercury_I))*Mercury_YP
ObliquityJ200 = 23.43928
Mercury_XEQ = Mercury_XECL
Mercury_YEQ = cosd(ObliquityJ200)*Mercury_YECL-sind(ObliquityJ200)*Mercury_ZECL
Mercury_ZEQ = sind(ObliquityJ200)*Mercury_YECL+cosd(ObliquityJ200)*Mercury_ZECL 
print("Mercury_XP $Mercury_XP\n")
print("Mercury_XEQ may be $Mercury_XEQ\n")
print("Mercury_YEQ may be $Mercury_YEQ\n")
print("Mercury_ZEQ may be $Mercury_ZEQ\n")
# print("$(Mercury_EN-Mercury_ENPrev) hopefully this works\n")

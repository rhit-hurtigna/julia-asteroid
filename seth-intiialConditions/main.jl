Mercury_InitialValues = Dict([
    ("Planet_a0",0.38709927),("Planet_aCY",0.00000037),
    ("Planet_e0",0.20563593),("Planet_eCy",0.00001906),
    ("Planet_I0",7.00497902),("Planet_ICy",-0.00594749),
    ("Planet_L0",252.25032350),("Planet_LCy",149472.67411175),
    ("Planet_longPeri0",77.45779628),("Planet_longPeriCy",0.16047689),
    ("Planet_longNode0",48.33076593),("Planet_longNodeCy",-0.12534081),
    ("Planet_b",0),
    ("Planet_c",0),
    ("Planet_s",0),
    ("Planet_f",0)]);



function findJulianDayFromGregorian(year, month, dayOfMonth)
    if month==1||month==2
        month=month+12
        year=year-1
    end
    A = trunc(year/100)
    B = trunc(A/4)
    C = 2-A+B
    E = trunc(365.25*(year+4716))
    F = trunc(30.6001*(month+1))
    C+dayOfMonth+E+F-1524.5
    # (367*year - 7 * (year + (month + 9)/12) / 4 - 3 * ((year + (month-9)/7)/100 + 1) / 4 + 275*month/9 + dayOfMonth - 730515)
    # (367*year - 7 * (year + (month+9)/12 ) / 4 - 3 * ( ( year + (month-9)/7)/100 + 1) / 4 + 275*month/9 + dayOfMonth - 730515)
end
# CurrentJulianDay = findJulianDayFromGregorian(2023, 5, 17)
# OneSecondMore = CurrentJulianDay + 0.0000116

# print("Today is $CurrentJulianDay\n")
# CurrentJulianDay = 2460081.500000000
# CurrentT = (CurrentJulianDay - 2451545.0)/36525

function findValuesForPresentDay(Planet_Values, CurrentT)
    Planet_a = Planet_Values["Planet_a0"] + Planet_Values["Planet_aCY"]*CurrentT
    Planet_e = Planet_Values["Planet_e0"]+Planet_Values["Planet_eCy"]*CurrentT
    Planet_I = Planet_Values["Planet_I0"]+Planet_Values["Planet_ICy"]*CurrentT
    Planet_L = Planet_Values["Planet_L0"]+Planet_Values["Planet_LCy"]*CurrentT
    Planet_longPeri = Planet_Values["Planet_longPeri0"]+Planet_Values["Planet_longPeriCy"]*CurrentT
    Planet_longNode = Planet_Values["Planet_longNode0"]+Planet_Values["Planet_longNodeCy"]*CurrentT
    Dict([("Planet_a",Planet_a),("Planet_e",Planet_e),("Planet_I",Planet_I),("Planet_L",Planet_L),("Planet_longPeri",Planet_longPeri),("Planet_longNode",Planet_longNode)])
end
# Mercury_a = Mercury_a0 + Mercury_aCy*CurrentT
# Mercury_e = Mercury_e0 + Mercury_eCy*CurrentT
# Mercury_I = Mercury_I0 + Mercury_ICy*CurrentT
# Mercury_L = Mercury_L0 + Mercury_LCy*CurrentT
# Mercury_longPeri = Mercury_longPeri0 + Mercury_longPeriCy*CurrentT
# print("Mercury_longPeri is $Mercury_longPeri\n")
# Mercury_longNode = Mercury_longNode0 + Mercury_longNodeCy*CurrentT
# Mercury_Values = findValuesForPresentDay(Mercury_InitialValues,CurrentT)
# print("Mercury_L is $(Mercury_Values["Planet_L"])\n")
function iterateOnE(Planet_M,Planet_e,Planet_EN,Planet_EStar)
    Planet_DM = Planet_M-(Planet_EN-Planet_EStar*sind(Planet_EN))
    Planet_DE = Planet_DM/(1-Planet_e*cosd(Planet_EN))
    Planet_EN + Planet_DE
end

function calculateMoreValues(Planet_Values,CurrentT)
    Planet_W = Planet_Values["Planet_longPeri"] - Planet_Values["Planet_longNode"]
    Planet_M = Planet_Values["Planet_L"] - Planet_Values["Planet_longPeri"]
    print("Planet_W is $Planet_W\n")
    print("Planet_M is $Planet_M before modulo\n")
    while(Planet_M>180)
        Planet_M = Planet_M-360
    end
    print("Planet_M is $Planet_M post modulo\n")
    Planet_EStar = (180/pi)*Planet_Values["Planet_e"]
    print("Planet_EStar is $Planet_EStar\n")
    Planet_E0 = Planet_M - Planet_EStar*sind(Planet_M)
    Planet_EN = iterateOnE(Planet_M,Planet_Values["Planet_e"],Planet_E0,Planet_EStar)
    print("Planet_EN first iteration is $Planet_EN\n")
    Planet_ENPrev = Planet_E0
    count = 0
    while(abs(Planet_EN-Planet_ENPrev))>0.0000001 && count <= 100
        print("iteration of EN de is $(Planet_EN-Planet_ENPrev)\n")
        Planet_ENPrev = Planet_EN
        count = count+1
        Planet_EN = iterateOnE(Planet_M,Planet_Values["Planet_e"],Planet_EN,Planet_EStar)
    end
    print("Final DE $(Planet_EN-Planet_ENPrev)\n")
    print("Planet_EN is $Planet_EN\n")
    Planet_Values["Planet_W"] = Planet_W
    Planet_Values["Planet_EN"] = Planet_EN
end

# calculateMoreValues(Mercury_Values,CurrentT)
# function iterateOnE(Planet_M,Planet_e,Planet_EN,Planet_EStar)
#     Planet_DM = Planet_M-(Planet_EN-Planet_EStar*sind(Planet_EN))
#     Planet_DE = Planet_DM/(1-Planet_e*cosd(Planet_EN))
#     Planet_EN + Planet_DE
# end

# get(Planet_Values,"EStar = (180/pi)*get(Planet_Values,"e
# get(Planet_Values,"E0 = get(Planet_Values,"M - get(Planet_Values,"EStar*sind(get(Planet_Values,"M)
# get(Planet_Values,"EN = iterateOnE(get(Planet_Values,"M,get(Planet_Values,"e,get(Planet_Values,"E0,get(Planet_Values,"EStar)
# get(Planet_Values,"ENPrev = get(Planet_Values,"E0
# count = 0
# # while count <=100
# while (abs(get(Planet_Values,"EN-get(Planet_Values,"ENPrev))>0.0000001 && count <= 10
#     print("$(get(Planet_Values,"EN-get(Planet_Values,"ENPrev)\n")
#     global get(Planet_Values,"ENPrev = get(Planet_Values,"EN
#     global count = count+1
#     global get(Planet_Values,"EN = iterateOnE(get(Planet_Values,"M,get(Planet_Values,"e,get(Planet_Values,"EN,get(Planet_Values,"EStar)
#     # print("$(get(Planet_Values,"EN)\n")
# end

# Mercury_EStar = (180/pi)*Mercury_e
# Mercury_E0 = Mercury_M - Mercury_EStar*sind(Mercury_M)
# Mercury_EN = iterateOnE(Mercury_M,Mercury_e,Mercury_E0,Mercury_EStar)
# Mercury_ENPrev = Mercury_E0
# count = 0
# # while count <=100
# while (abs(Mercury_EN-Mercury_ENPrev))>0.0000001 && count <= 10
#     print("$(Mercury_EN-Mercury_ENPrev)\n")
#     global Mercury_ENPrev = Mercury_EN
#     global count = count+1
#     global Mercury_EN = iterateOnE(Mercury_M,Mercury_e,Mercury_EN,Mercury_EStar)
#     # print("$(Mercury_EN)\n")
# end
# print("$(Mercury_EN-Mercury_ENPrev)\n")
# print("EN turned out to be $Mercury_EN\n")
# Mercury_XP = Mercury_a*(cosd(Mercury_EN)-Mercury_e)
# Mercury_YP = Mercury_a*sqrt(1-Mercury_e^2)*sind(Mercury_EN)
# Mercury_ZP = 0
function findPlanetHeliocentricInOwnOrbitalPlaneCoordinates(Planet_a,Planet_EN,Planet_e)
    Planet_XP = Planet_a*(cosd(Planet_EN)-Planet_e)
    print("THE XP IS $Planet_XP\n") # This is wrong, fix this part
    Planet_YP = Planet_a*sqrt(1-Planet_e^2)*sind(Planet_EN)
    Planet_ZP = 0
    [Planet_XP, Planet_YP, Planet_ZP]
end
# Mercury_P = findPlanetHeliocentricInOwnOrbitalPlaneCoordinates(Mercury_Values["Planet_a"],Mercury_Values["Planet_EN"],Mercury_Values["Planet_e"])
#I think these are ecliptic
function findPlanetElipticCordinates(Planet_W, Planet_longNode, Planet_I, Planet_XP, Planet_YP)
    Planet_XECL = (cosd(Planet_W)*cosd(Planet_longNode)-sind(Planet_W)*sind(Planet_longNode)*cosd(Planet_I))*Planet_XP + (-sind(Planet_W)*cosd(Planet_longNode)-cosd(Planet_W)*sind(Planet_longNode)*cosd(Planet_I))*Planet_YP
    Planet_YECL = (cosd(Planet_W)*sind(Planet_longNode)+sind(Planet_W)*cosd(Planet_longNode)*cosd(Planet_I))*Planet_XP + (-sind(Planet_W)*sind(Planet_longNode)+cosd(Planet_W)*cosd(Planet_longNode)*cosd(Planet_I))*Planet_YP
    Planet_ZECL = (sind(Planet_W)*sind(Planet_I))*Planet_XP+(cosd(Planet_W)*sind(Planet_I))*Planet_YP
    [Planet_XECL, Planet_YECL, Planet_ZECL]
end
# Mercury_ECL = findPlanetElipticCordinates(Mercury_Values["Planet_W"], Mercury_Values["Planet_longNode"], Mercury_Values["Planet_I"], Mercury_P[1], Mercury_P[2])
# Mercury_XECL = (cosd(Mercury_W)*cosd(Mercury_longNode)-sind(Mercury_W)*sind(Mercury_longNode)*cosd(Mercury_I))*Mercury_XP + (-sind(Mercury_W)*cosd(Mercury_longNode)-cosd(Mercury_W)*sind(Mercury_longNode)*cosd(Mercury_I))*Mercury_YP
# Mercury_YECL = (cosd(Mercury_W)*sind(Mercury_longNode)+sind(Mercury_W)*cosd(Mercury_longNode)*cosd(Mercury_I))*Mercury_XP + (-sind(Mercury_W)*sind(Mercury_longNode)+cosd(Mercury_W)*cosd(Mercury_longNode)*cosd(Mercury_I))*Mercury_YP
# Mercury_ZECL = (sind(Mercury_W)*sind(Mercury_I))*Mercury_XP+(cosd(Mercury_W)*sind(Mercury_I))*Mercury_YP
ObliquityJ200 = 23.43928
#Maybe these are equitorial
function findEquetorialCordinates(Planet_XECL, Planet_YECL, Planet_ZECL)
    Planet_XEQ = Planet_XECL
    Planet_YEQ = cosd(ObliquityJ200)*Planet_YECL-sind(ObliquityJ200)*Planet_ZECL
    Planet_ZEQ = sind(ObliquityJ200)*Planet_YECL+cosd(ObliquityJ200)*Planet_ZECL
    [Planet_XEQ, Planet_YEQ, Planet_ZEQ]
end
# Mercury_EQ = findEquetorialCordinates(Mercury_ECL[1], Mercury_ECL[2], Mercury_ECL[3])
# Mercury_XEQ = Mercury_XECL
# Mercury_YEQ = cosd(ObliquityJ200)*Mercury_YECL-sind(ObliquityJ200)*Mercury_ZECL
# Mercury_ZEQ = sind(ObliquityJ200)*Mercury_YECL+cosd(ObliquityJ200)*Mercury_ZECL 
# Mercury_R = sqrt(Mercury_XEQ^2+Mercury_YEQ^2+Mercury_ZEQ^2)
# Mercury_RA = atand(Mercury_YEQ,Mercury_XEQ)
# Mercury_Decl = atand(Mercury_ZEQ,sqrt(Mercury_XEQ^2+Mercury_YEQ^2))
# print("Mercury_XP $Mercury_XP\n")
# print("Mercury_R may be $Mercury_R\n")
# print("Mercury_RA may be $Mercury_RA\n")
# print("Mercury_Decl may be $Mercury_Decl\n")

function findPositionFromDate(Year, Month, DayOfMonth)
    CurrentJulianDay = findJulianDayFromGregorian(Year, Month, DayOfMonth)
    CurrentT = (CurrentJulianDay - 2451545.0)/36525
    Planet_Values = findValuesForPresentDay(Mercury_InitialValues,CurrentT)
    calculateMoreValues(Planet_Values,CurrentT)
    Planet_P = findPlanetHeliocentricInOwnOrbitalPlaneCoordinates(Planet_Values["Planet_a"],Planet_Values["Planet_EN"],Planet_Values["Planet_e"])
    Planet_ECL = findPlanetElipticCordinates(Planet_Values["Planet_W"], Planet_Values["Planet_longNode"], Planet_Values["Planet_I"], Planet_P[1], Planet_P[2])
    Planet_ECL
    # Planet_EQ = findEquetorialCordinates(Planet_ECL[1], Planet_ECL[2], Planet_ECL[3])
end

Planet_ECL = findPositionFromDate(2023, 5, 17)
Planet_ECLOffset = findPositionFromDate(2023, 5, 17+0.0000116)
Planet_Velocity = [0.0,0.0,0.0]
for i = 1:3
    Planet_Velocity[i] = Planet_ECLOffset[i]-Planet_ECL[i]
end
# Planet_Velocity = Planet_ECL-Planet_ECLOffset
print("Mercury_XECL may be $(Planet_ECL[1])\n")
print("Mercury_YECL may be $(Planet_ECL[2])\n")
print("Mercury_ZECL may be $(Planet_ECL[3])\n")
print("Finding Mercury Velocity\n")
print("Mercury_XVelocity may be $(Planet_Velocity[1])\n")
print("Mercury_YVelocity may be $(Planet_Velocity[2])\n")
print("Mercury_ZVelocity may be $(Planet_Velocity[3])\n")
# print("Mercury_XEQ may be $(Mercury_EQ[1])\n")
# print("Mercury_YEQ may be $(Mercury_EQ[2])\n")
# print("Mercury_ZEQ may be $(Mercury_EQ[3])\n")
# print("$(Mercury_EN-Mercury_ENPrev) hopefully this works\n")

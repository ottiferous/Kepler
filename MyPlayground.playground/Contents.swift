//: Playground - noun: a place where people can play
//import Darwin
import Foundation

/* astronomic body and associated values
 
 N = longitude of the ascending node
 i = inclination to the ecliptic (plane of the Earth's orbit)
 w = argument of perihelion
 a = semi-major axis, or mean distance from Sun
 e = eccentricity (0=circle, 0-1=ellipse, 1=parabola)
 M = mean anomaly (0 at perihelion; increases uniformly with time)
===========
 w1 = N + w   = longitude of perihelion
 L  = M + w1  = mean longitude
 q  = a*(1-e) = perihelion distance
 Q  = a*(1+e) = aphelion distance
 P  = a ^ 1.5 = orbital period (years if a is in AU, astronomical units)
 T  = Epoch_of_M - (M(deg)/360_deg) / P  = time of perihelion
 v  = true anomaly (angle between position and perihelion)
 E  = eccentric anomaly
*/
class Planet {
    let N: Float
    let i: Float
    let w: Float
    let a: Float
    let e: Float
    let M: Float
    
    init(N: Float, i: Float, w: Float, a: Float, e: Float, M: Float) {
        self.N = N
        self.i = i
        self.w = w
        self.a = a
        self.e = e
        self.M = M
        
    }
}

// build enumeration of the zodiac signs in order
enum ZodiacSigns: Int {
    case Aries, Taurus, Gemini, Cancer, Leo, Virgo, Libra, Scorpio, Sagittarius, Capricorn, Aquarius, Pisces
}

/* method for calculating fractional days since the J2000 epoch */
func daysToJ200Epoch(date: NSDate) -> Float {
    let components = NSDateComponents()
    components.day = 1
    components.month = 1
    components.year = 2000
    components.hour = 0
    components.minute = 0
    let J200Epoch = NSCalendar.currentCalendar().dateFromComponents(components)
    let days = NSCalendar.currentCalendar().components(.Day, fromDate: J200Epoch!, toDate: date, options: []).day
    let fractions = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate: date)
    let hours = Float(fractions.hour)
    let minutes = Float(fractions.minute)
    return Float(days) + ((hours + minutes/60) / 24)
}

/* should be > 5998 & have a fractional component */
let daysFromEpoch = daysToJ200Epoch(NSDate())

let now = NSDate()
let calendar = NSCalendar.currentCalendar()
let comp = calendar.components([.Hour, .Minute], fromDate: now)

/*
 Below are the calculations for planetary procession.
 */

func timeElapsed(date: Float) -> Float {
    return (date - 2451545.0)/36525
}

func calcPerihelion(longPerihelion: Float, longAscendingNode: Float) -> Float {
    return longPerihelion - longAscendingNode
}

func meanAnomoly(meanLongitude: Float, longPerihelion: Float) -> Float {
    let absMeanAnomoly = meanLongitude - longPerihelion
    return absMeanAnomoly % 180
}

func eccentricAnomoly(meanAnomoly: Float, eccentricity: Float) -> Float {
    return meanAnomoly + eccentricity * (180/3.14) * sin(meanAnomoly) * (1 + eccentricity * cos(meanAnomoly))
}

func coordinates(semiMajorAxis: Float, eccentricAnomoly: Float, eccentricity: Float) -> (Float, Float, Float) {
    let xPrime = semiMajorAxis * ( cos(eccentricAnomoly) - eccentricity)
    let yPrime = semiMajorAxis * ( sqrt(1 - (pow(eccentricity, 2))) * sin(eccentricAnomoly))
    let zPrime: Float = 0.0
    return (xPrime, yPrime, zPrime)
}

-73%180

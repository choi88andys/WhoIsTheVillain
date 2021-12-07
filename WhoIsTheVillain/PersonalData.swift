

import Foundation

struct PersonalData: Identifiable{
    var id = UUID()
    
    var isTurnOn: Bool = false
    var timeCount: Double = 0
    var personName: String = ""
    var timeoutCounter: Int = 0
    
    
    var minute: Int{
        get{
            Int(timeCount) / 60
        }
    }
    var second: Int{
        get{
            Int(timeCount) % 60
        }
    }
    var showRemainedTime: String{
        get{
            let stringMinute: String = String(format: "%02d", minute)
            let stringSecond: String = String(format: "%02d", second)
            
            return "\(stringMinute):\(stringSecond)"
        }
    }
        
    init(timeCount: Double, personName: String){
        self.timeCount = timeCount
        self.personName = personName
    }
    
    init(personName: String, timeCount: Double, timeoutCounter: Int){
        self.personName = personName
        self.timeCount = timeCount
        self.timeoutCounter = timeoutCounter
    }
    
}


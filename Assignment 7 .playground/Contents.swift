//4-StationModule-ი
//With properties: moduleName: String და drone: Drone? (optional).
//Method რომელიც დრონს მისცემს თასქს.
class StationModule {
    let moduleName: String
     var drone: Drone?

    init(moduleName: String, drone: Drone? = nil) {
        self.moduleName = moduleName
        self.drone = drone
    }
}
//5-ჩვენი ControlCenter-ი ResearchLab-ი და LifeSupportSystem-ა გავხადოთ StationModule-ის subClass.
//1-ControlCenter-ი.
//With properties: isLockedDown: Bool და securityCode: String, რომელშიც იქნება რაღაც პაროლი შენახული.
//Method lockdown, რომელიც მიიღებს პაროლს, ჩვენ დავადარებთ ამ პაროლს securityCode-ს და თუ დაემთხვა გავაკეთებთ lockdown-ს.
//Method-ი რომელიც დაგვიბეჭდავს ინფორმაციას lockdown-ის ქვეშ ხომ არაა ჩვენი ControlCenter-ი.
class ControlCenter: StationModule {
    var isLockedDown: Bool
    var securityCode: String

    init(moduleName: String, drone: Drone? = nil, isLockedDown: Bool, securityCode: String) {
        self.isLockedDown = isLockedDown
        self.securityCode = securityCode
        super.init(moduleName: moduleName, drone: drone)
    }
    public func lockdown(passcode: String) {
            if passcode == securityCode {
                isLockedDown = true
                print("Control Center is now locked down.")
            } else {
                print("Incorrect passcode. Lockdown failed.")
            }
        }
    public func checkLockdownStatus() -> Bool {
            return isLockedDown
        }
}
//ResearchLab-ი.
//With properties: String Array - ნიმუშების შესანახად.
//Method რომელიც მოიპოვებს(დაამატებს) ნიმუშებს ჩვენს Array-ში.
class ResearchLab: StationModule {
    var researchEquipment: [String]

    init(moduleName: String, drone: Drone? = nil, researchEquipment: [String]) {
        self.researchEquipment = researchEquipment
        super.init(moduleName: moduleName, drone: drone)
    }
    
    public func addSample(sample: String) {
            researchEquipment.append(sample)
            print("Sample '\(sample)' was added.")
        }
}
//LifeSupportSystem-ა.
//With properties: oxygenLevel: Int, რომელიც გააკონტროლებს ჟანგბადის დონეს.
//Method რომელიც გვეტყვის ჟანგბადის სტატუსზე.
class LifeSupportSystem: StationModule {
    var oxygenLevel: Int

    init(moduleName: String, drone: Drone? = nil, oxygenLevel: Int) {
        self.oxygenLevel = oxygenLevel
        super.init(moduleName: moduleName, drone: drone)
    }
    public func getCurrentOxygenLevel() {
            print(oxygenLevel)
        }
}
//6-Drone.
//With properties: task: String? (optional), unowned var assignedModule: StationModule, weak var missionControlLink: MissionControl? (optional).
//Method რომელიც შეამოწმებს აქვს თუ არა დრონს თასქი და თუ აქვს დაგვიბჭდავს რა სამუშაოს ასრულებს ის.
class Drone {
    var task: String?
    unowned var assignedModule: StationModule
    weak var missionControlLink: MissionControl?

    init(task: String? = nil, assignedModule: StationModule, missionControlLink: MissionControl? = nil) {
        self.task = task
        self.assignedModule = assignedModule
        self.missionControlLink = missionControlLink
    }
    public func checkAssignedTask() {
            if let task = task {
                print("Task assigned to the drone: \(task)")
            } else {
                print("No task assigned to the drone.")
            }
        }
}
//8-MissionControl.
//With properties: spaceStation: OrbitronSpaceStation? (optional).
//Method რომ დაუკავშირდეს OrbitronSpaceStation-ს და დაამყაროს მასთან კავშირი.
//Method requestControlCenterStatus-ი.
//Method requestOxygenStatus-ი.
//Method requestDroneStatus რომელიც გაარკვევს რას აკეთებს კონკრეტული მოდულის დრონი.
class MissionControl {
    weak var spaceStation: OrbitronSpaceStation?

    init(spaceStation: OrbitronSpaceStation? = nil) {
        self.spaceStation = spaceStation
    }
    public func connectToSpaceStation() {
            if let spaceStation = spaceStation {
                print("Mission Control is now connected to the Orbitron Space Station.")
            } else {
                print("Mission Control could not connect to the Orbitron Space Station.")
            }
        }
    public func requestControlCenterStatus() {
            if let controlCenter = spaceStation?.controlCenter {
                print("Requesting Control Center status:")
                if controlCenter.isLockedDown {
                    print("Control Center is locked down.")
                } else {
                    print("Control Center is not locked down.")
                }
            } else {
                print("Unable to request Control Center status.")
            }
        }
    public func requestOxygenStatus() {
            if let lifeSupportSystem = spaceStation?.lifeSupportSystem {
                print("Requesting oxygen level status:")
                print("Oxygen Level: \(lifeSupportSystem.oxygenLevel)%")
            } else {
                print("Unable to request oxygen level status.")
            }
        }
    public func requestDroneStatus() {
            if let controlCenterDrone = spaceStation?.controlCenter.drone {
                print("Requesting drone status:")
                controlCenterDrone.checkAssignedTask()
            } else {
                print("Unable to request drone status.")
            }
        }
}

//7-OrbitronSpaceStation-ი შევქმნათ, შიგნით ავაწყოთ ჩვენი მოდულები ControlCenter-ი, ResearchLab-ი და LifeSupportSystem-ა. ასევე ამ მოდულებისთვის გავაკეთოთ თითო დრონი და მივაწოდოთ ამ მოდულებს რათა მათ გამოყენება შეძლონ.
//ასევე ჩვენს OrbitronSpaceStation-ს შევუქმნათ ფუნქციონალი lockdown-ის რომელიც საჭიროების შემთხვევაში controlCenter-ს დალოქავს.
class OrbitronSpaceStation {
    let controlCenter: ControlCenter
    let researchLab: ResearchLab
    let lifeSupportSystem: LifeSupportSystem
    
    init() {
        controlCenter = ControlCenter(moduleName: "Control Center", drone: controlCenterDrone, isLockedDown: false, securityCode: "1234")
        researchLab = ResearchLab(moduleName: "Research Lab", drone: researchLabDrone, researchEquipment: ["Lab Equipment"])
        lifeSupportSystem = LifeSupportSystem(moduleName: "Life Support System", drone: lifeSupportSystemDrone, oxygenLevel: 90)
        
        let controlCenterDrone = Drone(assignedModule: controlCenter)
        let researchLabDrone = Drone(assignedModule: researchLab)
        let lifeSupportSystemDrone = Drone(assignedModule: lifeSupportSystem)
        
        controlCenterDrone.assignedModule = controlCenter
        researchLabDrone.assignedModule = researchLab
        lifeSupportSystemDrone.assignedModule = lifeSupportSystem
        
        
        func lockdownControlCenterIfNeeded(passcode: String) {
            controlCenter.lockdown(passcode: passcode)
        }
    }
}
//9-და ბოლოს
//შევქმნათ OrbitronSpaceStation,
//შევქმნათ MissionControl-ი,
//missionControl-ი დავაკავშიროთ OrbitronSpaceStation სისტემასთან,
//როცა კავშირი შედგება missionControl-ით მოვითხოვოთ controlCenter-ის status-ი.
//controlCenter-ის, researchLab-ის და lifeSupport-ის მოდულების დრონებს დავურიგოთ თასქები.
//შევამოწმოთ დრონების სტატუსები.
//შევამოწმოთ ჟანგბადის რაოდენობა.
//შევამოწმოთ ლოქდაუნის ფუნქციონალი და შევამოწმოთ დაილოქა თუ არა ხომალდი სწორი პაროლი შევიყვანეთ თუ არა.
let spaceStation = OrbitronSpaceStation()

let missionControl = MissionControl(spaceStation: spaceStation)
missionControl.connectToSpaceStation()

missionControl.requestControlCenterStatus()

let controlCenterDrone = spaceStation.controlCenter.drone
let researchLabDrone = spaceStation.researchLab.drone
let lifeSupportSystemDrone = spaceStation.lifeSupportSystem.drone

controlCenterDrone?.task = "Inspect Module"
researchLabDrone?.task = "Conduct Research"
lifeSupportSystemDrone?.task = "Monitor Oxygen Levels"

controlCenterDrone?.checkAssignedTask()
researchLabDrone?.checkAssignedTask()
lifeSupportSystemDrone?.checkAssignedTask()

missionControl.requestOxygenStatus()

let passcode = "12324"
spaceStation.controlCenter.lockdown(passcode: passcode)
spaceStation.controlCenter.checkLockdownStatus()

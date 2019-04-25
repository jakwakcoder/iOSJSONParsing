
import UIKit



class ViewController: UIViewController {
    
    @IBOutlet weak var testTextView: UITextView!
    var oldIncidentList: [IncidentRootJSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getIncidentJSONFromRESTAPI(latitude: 40, longitude: -80, distance: 3000, testData: true, completionHandler: { incidentList, error in
            DispatchQueue.main.async {
                self.testTextView.text = "\(incidentList)"
                print(incidentList)
            }
        })
        
    }
    
    func getIncidentLocationDescription(incidentRoot: IncidentRootJSON) -> String {
        var description: String = "\(incidentRoot.locationdesc)"
        
        
        //if the description with more detail is empty, then use MDOT's location description
        if(description.count == 0){
            description = "\(incidentRoot.locationDescription)"
        }
        description = getStringNoOptionalTag(stringVar: description)
        return description
    }
    
    func getStringNoOptionalTag(stringVar: String) -> String {
        return(stringVar.replacingOccurrences(of: "Optional(\"", with: "").replacingOccurrences(of: "\")", with: ""))
    }
    
    func getIncidentJSONFromRESTAPI(latitude: Int, longitude: Int, distance: Int, testData: Bool, completionHandler: @escaping ([IncidentRootJSON]?, Error?)->Void) {
        var arrayOfIncidentRoot : [IncidentRootJSON] = []
        let jsonUrlString = "http://riismdot-env.zmpgdunpxk.us-east-1.elasticbeanstalk.com/api/Incidents?latitude=\(latitude)&longitude=\(longitude)&distance=\(distance)&TestData=\(testData)"
        let url = URL(string: jsonUrlString)
        
        URLSession.shared.dataTask(with: url!) { (data, response, err) in
            guard let data = data else { return }
            do {
            
                var incidentJSON = try JSONDecoder().decode([IncidentRootJSON].self, from: data)
                
                for tempRootJSON in incidentJSON {
                    //get geolocation
                    let tempGeolocation = Geolocation(latitude: tempRootJSON.geoLocation?.latitude, longitude: tempRootJSON.geoLocation?.longitude)
                    
                    //get incidentTypeName
                    let incidentTypeTemp = IncidentType(name: tempRootJSON.laneClosure?.incidentType?.name)
                    //get laneClosure
                    let laneClosureTemp = LaneClosure(laneThatAreBlocked: tempRootJSON.laneClosure?.laneThatAreBlocked, incidentType: incidentTypeTemp)
                    
                    let incidentRoot = IncidentRootJSON(geoLocation: tempGeolocation, locationDescription: tempRootJSON.locationDescription, locationdesc: tempRootJSON.locationdesc, roadway: tempRootJSON.roadway, laneClosure: laneClosureTemp, countyCode: tempRootJSON.countyCode)
                    arrayOfIncidentRoot.append(incidentRoot)
                }
                
                completionHandler(arrayOfIncidentRoot, nil)
            }catch let jsonErr{
                print("Error serializing json:", jsonErr)
                completionHandler(nil, jsonErr)
            }
            }.resume()
    }
    
}


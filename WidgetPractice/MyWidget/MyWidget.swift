//
//  MyWidget.swift
//  MyWidget
//
//  Created by Ilkay Hamit on 06/10/2020.
//

import WidgetKit
import SwiftUI

//struct Provider: TimelineProvider {
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date())
//    }
//
//    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date())
//        completion(entry)
//    }
//
//    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [SimpleEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate)
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
//    }
//}
//
//struct SimpleEntry: TimelineEntry {
//    let date: Date
//}
//
//struct MyWidgetEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        Text(entry.date, style: .time)
//    }
//}

//Timeline will fetch the latest data from our fake API
struct parkingTimeline: TimelineProvider {
    typealias Entry = LastParkingUpdateEntry
    
    func placeholder(in context: Context) -> LastParkingUpdateEntry {
        LastParkingUpdateEntry(date: Date(), parkingModel: ParkingModel(timeRemaining: "00:00", endTime: "00:00am", parkingArea: "Area Code"))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (LastParkingUpdateEntry) -> Void) {
        let parkingModel = ParkingModel(timeRemaining: "00:00", endTime: "00:00am", parkingArea: "Area Code")
        
        let entry = LastParkingUpdateEntry(date: Date(), parkingModel: parkingModel)
        
        completion(entry)
    }
    
    //True information for the widget
    func getTimeline(in context: Context, completion: @escaping (Timeline<LastParkingUpdateEntry>) -> Void) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
        
        GetParkingInformation.getParkingInformation { (result) in
            var parkingModel = [ParkingModel]()
            if case .success(let fetchedParking) = result {
                parkingModel = fetchedParking
            }
            else {
                parkingModel.append(ParkingModel(timeRemaining: "", endTime: "Fail to Load", parkingArea: ""))
            }
            let i = Int.random(in: 0..<9)
            let entry = LastParkingUpdateEntry(date: currentDate, parkingModel: parkingModel[i])
            
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            
            completion(timeline)
        }
    }
}

struct PlaceholderView: View {
    var body: some View {
        Text("Loading...")
    }
}

struct ParkingWidgetView: View {
    var entry: LastParkingUpdateEntry
  
  @Environment(\.widgetFamily) var family
  
    var body: some View {
      switch family {
      case .systemSmall:
        ZStack {
          Image(uiImage: UIImage(named: "backgroundWidget")!).resizable().scaledToFill().padding(EdgeInsets.init(top: -2, leading: 0, bottom: -2, trailing: 0))
          VStack(alignment: .leading) {
            Text("TIME REMAINING").font(.system(size: 12, weight: .bold, design: .default)).foregroundColor(.white)
            Text("\(entry.parkingModel.timeRemaining)").font(.system(size: 20, weight: .bold, design: .default)).foregroundColor(.cCPGreen)
            Spacer()
            Image(uiImage: UIImage(named: "carWidget")!)
            Text("ENDS").font(.system(size: 10, weight: .bold, design: .default)).foregroundColor(.white)
            Text("Today, \(entry.parkingModel.endTime)").font(.system(size: 16, weight: .bold, design: .default)).foregroundColor(.white)
          }.padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 10))
        }
      case .systemMedium:
        ZStack {
          Image(uiImage: UIImage(named: "backgroundWidget")!).resizable().scaledToFill().padding(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
          HStack {
            VStack(alignment: .leading) {
              Text("TIME REMAINING").font(.system(size: 12, weight: .bold, design: .default)).foregroundColor(.white)
              Text("\(entry.parkingModel.timeRemaining)").font(.system(size: 20, weight: .bold, design: .default)).foregroundColor(.cCPGreen)
              Spacer().frame(height: 35)
              Image(uiImage: UIImage(named: "carWidget")!)
              Text("ENDS").font(.system(size: 10, weight: .bold, design: .default)).foregroundColor(.white)
              Text("Today, \(entry.parkingModel.endTime)").font(.system(size: 14, weight: .bold, design: .default)).foregroundColor(.white)
            }.padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 0))
            Spacer()
            VStack(alignment: .trailing) {
              Image("mapPlaceholder")
                .resizable()
                  .cornerRadius(10)
                  .overlay(RoundedRectangle(cornerRadius: 10)
                      .stroke(Color.clear, lineWidth: 0))
                .frame(width: 200, height: 150)
                .scaledToFit()
            }.padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 20))
          }
        }
      case .systemLarge:
        Text("System Large")
      @unknown default:
        fatalError()
      }
    }
}

struct ParkingModel {
    let timeRemaining: String
    let endTime: String
    let parkingArea: String
}

struct LastParkingUpdateEntry: TimelineEntry {
    let date: Date
    let parkingModel: ParkingModel
    
    var relevance: TimelineEntryRelevance? {
        return TimelineEntryRelevance(score: 100)
    }
}

struct GetParkingInformation {
    static func getParkingInformation(completion: @escaping (Result<[ParkingModel], Error>) -> Void) {
        var parkingModelArray = [ParkingModel]()
        let parkingModel1 = ParkingModel(timeRemaining: "00:15", endTime: "13:00pm", parkingArea: "London")
        let parkingModel2 = ParkingModel(timeRemaining: "59:15", endTime: "12:20pm", parkingArea: "London")
        let parkingModel3 = ParkingModel(timeRemaining: "25:00", endTime: "15:16pm", parkingArea: "London")
        let parkingModel4 = ParkingModel(timeRemaining: "10:00", endTime: "16:16pm", parkingArea: "London")
        let parkingModel5 = ParkingModel(timeRemaining: "20:00", endTime: "18:16pm", parkingArea: "London")
        let parkingModel6 = ParkingModel(timeRemaining: "25:00", endTime: "20:16pm", parkingArea: "London")
        let parkingModel7 = ParkingModel(timeRemaining: "21:00", endTime: "21:16pm", parkingArea: "London")
        let parkingModel8 = ParkingModel(timeRemaining: "15:00", endTime: "11:16pm", parkingArea: "London")
        let parkingModel9 = ParkingModel(timeRemaining: "02:00", endTime: "07:16pm", parkingArea: "London")
        let parkingModel10 = ParkingModel(timeRemaining: "99:00", endTime: "11:11pm", parkingArea: "London")
        
        parkingModelArray.append(parkingModel1)
        parkingModelArray.append(parkingModel2)
        parkingModelArray.append(parkingModel3)
        parkingModelArray.append(parkingModel4)
        parkingModelArray.append(parkingModel5)
        parkingModelArray.append(parkingModel6)
        parkingModelArray.append(parkingModel7)
        parkingModelArray.append(parkingModel8)
        parkingModelArray.append(parkingModel9)
        parkingModelArray.append(parkingModel10)
        
        
        completion(.success(parkingModelArray))
    }
}

@main
struct MyWidget: Widget {
    let kind: String = "MyWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: parkingTimeline()) { entry in
            ParkingWidgetView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct MyWidget_Previews: PreviewProvider {
    static var previews: some View {
        ParkingWidgetView(entry: LastParkingUpdateEntry(date: Date(), parkingModel: ParkingModel(timeRemaining: "00:00", endTime: "00:00am", parkingArea: "Area Code")))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        ParkingWidgetView(entry: LastParkingUpdateEntry(date: Date(), parkingModel: ParkingModel(timeRemaining: "00:00", endTime: "00:00am", parkingArea: "Area Code")))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

extension Color {
    static let cCPGreen = Color("CCPGreen")
    static let cCPBlue = Color("CCPBlue")
}


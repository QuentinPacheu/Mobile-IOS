import SwiftUI

struct ChronometreView: View {
    @State private var timeElapsed: TimeInterval = 0
    @State private var timer: Timer?
    @State private var isRunning = false
    @State private var laps: [TimeInterval] = []
    
    var body: some View {
        VStack(spacing: 20) {
            Text(timeString(from: timeElapsed))
                .font(.system(size: 60, weight: .bold, design: .monospaced))
                .frame(height: 100)
            
            HStack(spacing: 30) {
                Button(action: startStopTimer) {
                    Text(isRunning ? "Arrêter" : "Démarrer")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 130, height: 60)
                        .background(isRunning ? Color.red : Color.green)
                        .cornerRadius(10)
                }
                
                if isRunning {
                    Button(action: lapTimer) {
                        Text("Tour")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 100, height: 60)
                            .background(Color.purple)
                            .cornerRadius(10)
                    }
                } else {
                    Button(action: resetTimer) {
                        Text("Effacer")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 100, height: 60)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
            
            List {
                ForEach(laps.indices, id: \.self) { index in
                    Text("Lap \(index + 1): \(timeString(from: laps[index]))")
                }
            }
            .frame(height: 200)
        }
        .padding()
    }
    
    func startStopTimer() {
        if isRunning {
            timer?.invalidate()
            timer = nil
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                timeElapsed += 0.1
            }
        }
        isRunning.toggle()
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        timeElapsed = 0
        laps.removeAll()
    }
    
    func lapTimer() {
        laps.append(timeElapsed)
    }
    
    func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        let tenths = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 10)
        return String(format: "%02d:%02d.%d", minutes, seconds, tenths)
    }
}

struct ChronometreView_Previews: PreviewProvider {
    static var previews: some View {
        ChronometreView()
    }
}

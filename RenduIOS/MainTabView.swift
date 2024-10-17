import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            CalculatriceView()
                .tabItem {
                    Image(systemName: "number")
                    Text("Calculatrice")
                }
            
            ChronometreView()
                .tabItem {
                    Image(systemName: "stopwatch")
                    Text("Chronomètre")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

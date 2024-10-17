import SwiftUI

struct CalculatriceView: View {
    @State private var affichage = "0"
    @State private var operationEnCours: Operation?
    @State private var premierNombre: Double?
    
    enum Operation {
        case addition, soustraction, multiplication, division
    }
    
    let boutons: [[CalculatriceBouton]] = [
        [.effacer, .operation(.division)],
        [.nombre("7"), .nombre("8"), .nombre("9"), .operation(.multiplication)],
        [.nombre("4"), .nombre("5"), .nombre("6"), .operation(.soustraction)],
        [.nombre("1"), .nombre("2"), .nombre("3"), .operation(.addition)],
        [.nombre("0"), .virgule, .egal]
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            Text(affichage)
                .font(.system(size: 64))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            
            ForEach(boutons, id: \.self) { rangee in
                HStack(spacing: 12) {
                    ForEach(rangee, id: \.self) { bouton in
                        BoutonCalculatrice(bouton: bouton, action: self.appuiSurBouton)
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
    
    func appuiSurBouton(_ bouton: CalculatriceBouton) {
        switch bouton {
        case .nombre(let valeur):
            if affichage == "0" {
                affichage = valeur
            } else {
                affichage += valeur
            }
        case .operation(let op):
            if let nombre = Double(affichage) {
                premierNombre = nombre
                operationEnCours = op
                affichage = "0"
            }
        case .egal:
            calculerResultat()
        case .virgule:
            if !affichage.contains(".") {
                affichage += "."
            }
        case .effacer:
            affichage = "0"
            premierNombre = nil
            operationEnCours = nil
        }
    }
    
    func calculerResultat() {
        if let premier = premierNombre,
           let deuxieme = Double(affichage),
           let operation = operationEnCours {
            let resultat: Double
            switch operation {
            case .addition:
                resultat = premier + deuxieme
            case .soustraction:
                resultat = premier - deuxieme
            case .multiplication:
                resultat = premier * deuxieme
            case .division:
                resultat = deuxieme != 0 ? premier / deuxieme : 0
            }
            affichage = String(format: "%.2f", resultat)
            premierNombre = nil
            operationEnCours = nil
        }
    }
}

enum CalculatriceBouton: Hashable {
    case nombre(String)
    case operation(CalculatriceView.Operation)
    case egal
    case virgule
    case effacer
}

struct BoutonCalculatrice: View {
    let bouton: CalculatriceBouton
    let action: (CalculatriceBouton) -> Void
    
    var body: some View {
        Button(action: {
            self.action(self.bouton)
        }) {
            Text(textePourBouton())
                .font(.title)
                .frame(width: largeurBouton(), height: 70)
                .background(couleurFondBouton())
                .foregroundColor(.white)
                .cornerRadius(35)
        }
    }
    
    private func textePourBouton() -> String {
        switch bouton {
        case .nombre(let valeur): return valeur
        case .operation(let op):
            switch op {
            case .addition: return "+"
            case .soustraction: return "-"
            case .multiplication: return "×"
            case .division: return "÷"
            }
        case .egal: return "="
        case .virgule: return ","
        case .effacer: return "C"
        }
    }
    
    private func couleurFondBouton() -> Color {
        switch bouton {
        case .nombre, .virgule: return .gray
        case .operation, .egal: return .orange
        case .effacer: return .red
        }
    }
    
    private func largeurBouton() -> CGFloat {
        switch bouton {
        case .nombre("0"): return 156
        default: return 70
        }
    }
}

struct CalculatriceView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatriceView()
    }
}

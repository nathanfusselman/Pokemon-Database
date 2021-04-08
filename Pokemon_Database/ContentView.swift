//
//  ContentView.swift
//  Pokemon_Database
//
//  Created by Nathan Fusselman on 4/5/21.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct ContentView: View {
    
    var body: some View {
        PokemonView()
    }
}

struct PokemonView: View {
    
    @ObservedObject var obs = observer(id: 1)
    @State private var imageAnimationAmount: CGFloat = 0.9
    
    var body: some View {
        VStack {
            HStack(alignment: .lastTextBaseline) {
                Text("\(obs.pokemon.name.capitalized)")
                    .font(.system(size: 40, weight: .light, design: .default))
                    .fontWeight(.bold)
                    .foregroundColor(Color("WhiteBlack"))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.leading, 25)
                Spacer()
                Text("#\(obs.pokemon.id)")
                    .font(.system(size: 25, weight: .light, design: .default))
                    .fontWeight(.bold)
                    .foregroundColor(Color("WhiteBlack"))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.trailing, 25)
                    
            }
            .padding(.top, 10)
            ScrollView(.horizontal, content: {
                HStack(spacing: 10) {
                    ForEach(obs.pokemon.type, id: \.self) { typeName in
                        Text("\(typeName.capitalized)")
                            .fontWeight(.bold)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(10)
                            .frame(width: 100)
                            .font(.callout)
                            .foregroundColor(Color("WhiteBlack"))
                            .background(Capsule().fill(Color("\(typeName.capitalized)TagBackground"))) // Fix Later
                    }
                }
                .frame(height: 50)
                .padding(.leading, 10)
            })
            .frame(height: 50)
            HStack {
                Button(action: {
                    obs.getPokemon(id: obs.pokemon.id == 1 ? 898 : obs.pokemon.id - 1)

                }) {
                    Image("Arrow")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .rotationEffect(.degrees(0))
                        .foregroundColor(Color("WhiteBlack"))
                        .frame(width: 25, height: 25, alignment: .center)
                }
                Spacer()
                Image("Pokeball").data(url: URL(string: obs.pokemon.imageURL)!)
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(imageAnimationAmount)
                    .animation(
                        Animation.easeInOut(duration: 2)
                            .repeatForever(autoreverses: true)
                    )
                    .onAppear {
                        self.imageAnimationAmount = 1
                    }
                Spacer()
                Button(action: {
                    obs.getPokemon(id: obs.pokemon.id == 898 ? 1 : obs.pokemon.id + 1)

                }) {
                    Image("Arrow")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .rotationEffect(.degrees(180))
                        .foregroundColor(Color("WhiteBlack"))
                        .frame(width: 25, height: 25, alignment: .center)
                }
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
            .padding(.top, 25)
            .padding(.bottom, 25)
            DetailsView(pokemon: obs.pokemon)
                .clipShape(RoundedCorner(radius: 25, corners: [.topLeft, .topRight]))
                .ignoresSafeArea(.all)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .background(Color("\(obs.pokemon.type[0].capitalized)Type").ignoresSafeArea(.all))
    }
}

struct DetailsView: View {
    
    var pokemon: Pokemon
    
    @State private var selected = "about"
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Button("About") {
                        selected = "about"
                    }
                    .foregroundColor(selected == "about" ? Color("BlackWhite") : .gray)
                    Capsule()
                        .fill(selected == "about" ? Color("Selected") : .clear)
                        .frame(height: 5)
                }
                Spacer()
                VStack {
                    Button("Stats") {
                        selected = "stats"
                    }
                    .foregroundColor(selected == "stats" ? Color("BlackWhite") : .gray)
                    Capsule()
                        .fill(selected == "stats" ? Color("Selected") : .clear)
                        .frame(height: 5)
                }
                Spacer()
//                VStack {
//                    Button("Evolution") {
//                        selected = "evolution"
//                    }
//                    .foregroundColor(selected == "evolution" ? Color("BlackWhite") : .gray)
//                    Capsule()
//                        .fill(selected == "evolution" ? Color("Selected") : .clear)
//                        .frame(height: 5)
//                }
//                Spacer()
            }
            .frame(height: 75)
            ScrollView(.vertical) {
                switch selected {
                case "about":
                    aboutPage(pokemon: pokemon)
                case "stats":
                    statsPage(pokemon: pokemon)
                case "evolution":
                    evolutionPage(pokemon: pokemon)
                default:
                    aboutPage(pokemon: pokemon)
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
        .background(Color("WhiteBlack"))
    }
}

struct aboutPage: View {
    
    var pokemon: Pokemon
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Species")
                    .font(.system(size: 20, weight: .light, design: .default))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.gray)
                    .frame(width: 80)
                Text("\(pokemon.species.capitalized)")
                    .font(.system(size: 20, weight: .light, design: .default))
                    .fontWeight(.regular)
                    .padding(.leading, 10)
            }
            .frame(height: 40)
            HStack {
                Text("Height")
                    .font(.system(size: 20, weight: .light, design: .default))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.gray)
                    .frame(width: 80)
                Text("\(pokemon.height) cm")
                    .font(.system(size: 20, weight: .light, design: .default))
                    .fontWeight(.regular)
                    .padding(.leading, 10)
            }
            .frame(height: 40)
            HStack {
                Text("Weight")
                    .font(.system(size: 20, weight: .light, design: .default))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.gray)
                    .frame(width: 80)
                Text("\(String(format: "%.1f", pokemon.weight)) kg")
                    .font(.system(size: 20, weight: .light, design: .default))
                    .fontWeight(.regular)
                    .padding(.leading, 10)
            }
            .frame(height: 40)
            HStack {
                Text("Abilities")
                    .font(.system(size: 20, weight: .light, design: .default))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.gray)
                    .frame(width: 80)
                ScrollView(.horizontal, content: {
                    Text("\(pokemon.abilities.joined(separator: ", ").capitalized)")
                        .font(.system(size: 20, weight: .light, design: .default))
                        .fontWeight(.regular)
                        .frame(maxWidth: .infinity)
                })
                .padding(.leading, 10)
            }
            .frame(height: 40)
            HStack {
                Text("Gender")
                    .font(.system(size: 20, weight: .light, design: .default))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.gray)
                    .frame(width: 80)
                Text("♂ ♀")
                    .font(.system(size: 20, weight: .light, design: .default))
                    .fontWeight(.regular)
                    .padding(.leading, 10)
            }
            .frame(height: 40)
        }
        .padding([.leading, .trailing], 25)
    }
}

struct statsPage: View {
    
    var pokemon: Pokemon
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("HP")
                    .fontWeight(.semibold)
                    .foregroundColor(Color.gray)
                    .frame(width: 100, height: 20, alignment: .leading)
                Text("\(pokemon.valueHP)")
                    .frame(width: 50, height: 20)
                ProgressView(value: Float(pokemon.valueHP), total: 100)
                    .accentColor(pokemon.valueHP < 50 ? .red : .green)
                    .frame(height: 20)
            }
            HStack {
                Text("Attack")
                    .fontWeight(.semibold)
                    .foregroundColor(Color.gray)
                    .frame(width: 100, height: 20, alignment: .leading)
                Text("\(pokemon.valueAttack)")
                    .frame(width: 50, height: 20)
                ProgressView(value: Float(pokemon.valueAttack), total: 100)
                    .accentColor(pokemon.valueAttack < 50 ? .red : .green)
                    .frame(height: 20)
            }
            HStack {
                Text("Defense")
                    .fontWeight(.semibold)
                    .foregroundColor(Color.gray)
                    .frame(width: 100, height: 20, alignment: .leading)
                Text("\(pokemon.valueDefense)")
                    .frame(width: 50, height: 20)
                ProgressView(value: Float(pokemon.valueDefense), total: 100)
                    .accentColor(pokemon.valueDefense < 50 ? .red : .green)
                    .frame(height: 20)
            }
            HStack {
                Text("Sp. Attack")
                    .fontWeight(.semibold)
                    .foregroundColor(Color.gray)
                    .frame(width: 100, height: 20, alignment: .leading)
                Text("\(pokemon.valueSpecialAttack)")
                    .frame(width: 50, height: 20)
                ProgressView(value: Float(pokemon.valueSpecialAttack), total: 100)
                    .accentColor(pokemon.valueSpecialAttack < 50 ? .red : .green)
                    .frame(height: 20)
            }
            HStack {
                Text("Sp. Defense")
                    .fontWeight(.semibold)
                    .foregroundColor(Color.gray)
                    .frame(width: 100, height: 20, alignment: .leading)
                Text("\(pokemon.valueSpecialDefense)")
                    .frame(width: 50, height: 20)
                ProgressView(value: Float(pokemon.valueSpecialDefense), total: 100)
                    .accentColor(pokemon.valueSpecialDefense < 50 ? .red : .green)
                    .frame(height: 20)
            }
            HStack {
                Text("Speed")
                    .fontWeight(.semibold)
                    .foregroundColor(Color.gray)
                    .frame(width: 100, height: 20, alignment: .leading)
                Text("\(pokemon.valueSpeed)")
                    .frame(width: 50, height: 20)
                ProgressView(value: Float(pokemon.valueSpeed), total: 100)
                    .accentColor(pokemon.valueSpeed < 50 ? .red : .green)
                    .frame(height: 20)
            }
            HStack {
                Text("Total")
                    .fontWeight(.semibold)
                    .foregroundColor(Color.gray)
                    .frame(width: 100, height: 20, alignment: .leading)
                Text("\(pokemon.valueTotal)")
                    .frame(width: 50, height: 20)
                ProgressView(value: Float(pokemon.valueTotal), total: 600)
                    .accentColor(pokemon.valueTotal < 300 ? .red : .green)
                    .frame(height: 20)
            }
        }
        .padding([.leading, .trailing], 25)
    }
}

struct evolutionPage: View {
    
    var pokemon: Pokemon
    
    var body: some View {
        HStack {
            VStack {
                Image("Pokeball").data(url: URL(string: pokemon.imageURL)!).resizable()
                    .aspectRatio(contentMode: .fit)
                HStack {
                    Text("\(pokemon.name)")
                        .fontWeight(.semibold)
                    Text("#\(pokemon.id)")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.gray)
                }
            }
            Image("Arrow")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .foregroundColor(Color("BlackWhite"))
                .frame(width: 50, height: 50, alignment: .center)
            VStack {
                Image("Pokeball").data(url: URL(string: pokemon.evolutionImageURL)!).resizable()
                    .aspectRatio(contentMode: .fit)
                HStack {
                    Text("\(pokemon.evolutionName)")
                        .fontWeight(.semibold)
                    Text("#\(pokemon.evolutionId)")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.gray)
                }
            }
        }
        .padding(25)
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Image {
    func data(url:URL) -> Self {
        if let data = try? Data(contentsOf: url) {
            return Image(uiImage: UIImage(data: data)!).resizable()
        }
        return self.resizable()
    }
}

class observer: ObservableObject {
    
    @Published var pokemon: Pokemon = Pokemon()
    
    init(id: Int) {
        getPokemon(id: id)
    }
    
    func getPokemon(id: Int) {
        AF.request("https://pokeapi.co/api/v2/pokemon/\(id)", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.pokemon.id = json["id"].int ?? 0
                self.pokemon.name = json["name"].string ?? ""
                self.pokemon.imageURL = json["sprites"]["other"]["official-artwork"]["front_default"].string ?? ""
                self.pokemon.type.removeAll()
                for i in 0...json["types"].count-1 {
                    self.pokemon.type.append(json["types"][i]["type"]["name"].string ?? "")
                }
                self.pokemon.species = json["species"]["name"].string ?? ""
                self.pokemon.height = (json["height"].int ?? 0) * 10
                self.pokemon.weight = Float(json["weight"].int ?? 0) / 10
                self.pokemon.abilities.removeAll()
                for i in 0...json["abilities"].count-1 {
                    self.pokemon.abilities.append(json["abilities"][i]["ability"]["name"].string ?? "")
                }
                self.pokemon.valueHP = json["stats"][0]["base_stat"].int ?? 0
                self.pokemon.valueAttack = json["stats"][1]["base_stat"].int ?? 0
                self.pokemon.valueDefense = json["stats"][2]["base_stat"].int ?? 0
                self.pokemon.valueSpecialAttack = json["stats"][3]["base_stat"].int ?? 0
                self.pokemon.valueSpecialDefense = json["stats"][4]["base_stat"].int ?? 0
                self.pokemon.valueSpeed = json["stats"][5]["base_stat"].int ?? 0
                self.pokemon.valueTotal = self.pokemon.valueHP + self.pokemon.valueAttack + self.pokemon.valueDefense + self.pokemon.valueSpecialAttack + self.pokemon.valueSpecialDefense + self.pokemon.valueSpeed
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct Pokemon: Identifiable {
    var id: Int = 1
    var name: String = "bulbasaur"
    var imageURL: String = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
    var type: [String] = ["grass", "poison"]
    var species: String = "bulbasaur"
    var height: Int = 70
    var weight: Float = 6.9
    var abilities: [String] = ["overgrow", "chlorophyll"]
    var valueHP: Int = 45
    var valueAttack: Int = 49
    var valueDefense: Int = 49
    var valueSpecialAttack: Int = 65
    var valueSpecialDefense: Int = 65
    var valueSpeed: Int = 45
    var valueTotal: Int = 318
    var evolutionId: Int = 0
    var evolutionName: String = ""
    var evolutionImageURL: String = ""
}

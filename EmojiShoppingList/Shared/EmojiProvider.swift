import SwiftUI

struct Emoji {
    var emoji: String
    var color: Color
    var products: [String] = []
}

struct EmojiProvider {
    var emoji: (_ string: String) -> Emoji
}

extension EmojiProvider {
    static let `default`: () -> EmojiProvider = {
        
        let emoji: [Emoji] = [
            Emoji(emoji: "🍇", color: .red, products: ["Grape", "Druiven"]),
            Emoji(emoji: "🍈", color: .green, products: ["Melon", "Meloen"]),
            Emoji(emoji: "🍉", color: .red, products: ["Watermelon", "Watermeloen"]),
            Emoji(emoji: "🍊", color: .orange, products: ["Tangerine", "Mandarijn"]),
            Emoji(emoji: "🍋", color: .yellow, products: ["Lemon", "Citroen"]),
            Emoji(emoji: "🍌", color: .yellow, products: ["Banana", "Banaan"]),
            Emoji(emoji: "🍍", color: .yellow, products: ["Pineapple", "Ananas"]),
            Emoji(emoji: "🥭", color: .orange, products: ["Mango", "Mango"]),
            Emoji(emoji: "🍎", color: .red, products: ["Apple", "Appel"]),
            Emoji(emoji: "🍎", color: .red, products: ["Red Apple", "Rode Appel"]),
            Emoji(emoji: "🍏", color: .green, products: ["Green Apple", "Groene Appel"]),
            Emoji(emoji: "🍐", color: .green, products: ["Pear", "Peer"]),
            Emoji(emoji: "🍑", color: .orange, products: ["Peach", "Perzik"]),
            Emoji(emoji: "🍒", color: .red, products: ["Cherry", "Kers"]),
            Emoji(emoji: "🍓", color: .red, products: ["Strawberry", "Aardbei"]),
            Emoji(emoji: "🫐", color: .blue, products: ["Blueberry", "Blauwe bes"]),
            Emoji(emoji: "🥝", color: .green, products: ["Kiwi"]),
            Emoji(emoji: "🍅", color: .red, products: ["Tomato", "Tomaat"]),
            Emoji(emoji: "🫒", color: .green, products: ["Olive", "Olijf"]),
            Emoji(emoji: "🥥", color: .gray, products: ["Coconut", "Kokosnoot"]),
            Emoji(emoji: "🥑", color: .green, products: ["Avocado"]),
            Emoji(emoji: "🍆", color: .indigo, products: ["Eggplant", "Aubergine"]),
            Emoji(emoji: "🥔", color: .brown, products: ["Potato", "Aardappel"]),
            Emoji(emoji: "🥕", color: .orange, products: ["Carrot", "Wortel"]),
            Emoji(emoji: "🌽", color: .yellow, products: ["Corn", "Mais"]),
            Emoji(emoji: "🌶️", color: .red, products: ["Pepper", "Peper"]),
            Emoji(emoji: "🫑", color: .green, products: ["Bell Pepper", "Paprika"]),
            Emoji(emoji: "🥒", color: .green, products: ["Cucumber", "Komkommer"]),
            Emoji(emoji: "🥦", color: .green, products: ["Broccoli"]),
            Emoji(emoji: "🧄", color: .brown, products: ["Garlic", "Knoflook"]),
            Emoji(emoji: "🧅", color: .brown, products: ["Onion", "Ui"]),
            Emoji(emoji: "🍄", color: .brown, products: ["Mushroom", "Paddestoel"]),
            Emoji(emoji: "🥖", color: .brown, products: ["Baguette bread", "Stokbrood"]),
            Emoji(emoji: "🥜", color: .brown, products: ["Peanuts", "Pinda's", "Pindas"]),
            Emoji(emoji: "🫘", color: .brown, products: ["Beans", "Bonen"]),
            Emoji(emoji: "🧀", color: .yellow, products: ["Cheese", "Kaas"]),
            Emoji(emoji: "🥬", color: .yellow, products: ["Salad", "Leafy greens", "Sla"]),
            Emoji(emoji: "🌰", color: .brown, products: ["Chestnut", "Kastanje"]),
            Emoji(emoji: "🍞", color: .brown, products: ["Bread", "Brood"]),
            Emoji(emoji: "🥐", color: .brown, products: ["Croissant"]),
            Emoji(emoji: "🫓", color: .brown, products: ["Flatbread"]),
            Emoji(emoji: "🥨", color: .brown, products: ["Pretzel"]),
            Emoji(emoji: "🥯", color: .brown, products: ["Bagel"]),
            Emoji(emoji: "🥞", color: .brown, products: ["Pancakes"]),
            Emoji(emoji: "🧇", color: .brown, products: ["Waffle"]),
            Emoji(emoji: "🍖", color: .brown, products: ["Meat"]),
            Emoji(emoji: "🍗", color: .brown, products: ["Poultry"]),
            Emoji(emoji: "🥩", color: .brown, products: ["Steak"]),
            Emoji(emoji: "🥓", color: .brown, products: ["Bacon"]),
            Emoji(emoji: "🍔", color: .brown, products: ["Hamburger"]),
            Emoji(emoji: "🍟", color: .yellow, products: ["French Fries"]),
            Emoji(emoji: "🍕", color: .red, products: ["Pizza"]),
            Emoji(emoji: "🌭", color: .brown, products: ["Hot Dog"]),
            Emoji(emoji: "🥪", color: .brown, products: ["Sandwich"]),
            Emoji(emoji: "🌮", color: .yellow, products: ["Taco"]),
            Emoji(emoji: "🌯", color: .brown, products: ["Burrito"]),
            Emoji(emoji: "🧆", color: .brown, products: ["Falafel"]),
            Emoji(emoji: "🥚", color: .gray, products: ["Egg"]),
            Emoji(emoji: "🍿", color: .gray, products: ["Popcorn"]),
            Emoji(emoji: "🧂", color: .gray, products: ["Salt"]),
            Emoji(emoji: "🧈", color: .yellow, products: ["Butter"]),
            Emoji(emoji: "🥫", color: .gray, products: ["Canned"]),
            Emoji(emoji: "🥫", color: .red, products: ["Tomato Saus"]),
            Emoji(emoji: "🍚", color: .gray, products: ["Rice"]),
            Emoji(emoji: "🍠", color: .indigo, products: ["Sweet Potato"]),
            Emoji(emoji: "🍣", color: .orange, products: ["Sushi"]),
            Emoji(emoji: "🍤", color: .orange, products: ["Shrimp"]),
            Emoji(emoji: "🥟", color: .brown, products: ["Dumpling"]),
            Emoji(emoji: "🍩", color: .brown, products: ["Doughnut"]),
            Emoji(emoji: "🍪", color: .brown, products: ["Cookie"]),
            Emoji(emoji: "🦪", color: .gray, products: ["Oyster"]),
            Emoji(emoji: "🦪", color: .gray, products: ["Mussle"]),
            Emoji(emoji: "🧁", color: .brown, products: ["Cupcake"]),
            Emoji(emoji: "🥧", color: .brown, products: ["Pie"]),
            Emoji(emoji: "🍫", color: .brown, products: ["Chocolate"]),
            Emoji(emoji: "🍬", color: .purple, products: ["Candy"]),
            Emoji(emoji: "🍯", color: .brown, products: ["Honey"]),
            Emoji(emoji: "☕", color: .brown, products: ["Coffee"]),
            Emoji(emoji: "🫖", color: .brown, products: ["Tea"]),
            Emoji(emoji: "🍷", color: .red, products: ["Red Wine"]),
            Emoji(emoji: "🍷", color: .gray, products: ["White Wine"]),
            Emoji(emoji: "🍺", color: .brown, products: ["Beer"]),
            Emoji(emoji: "🧊", color: .blue, products: ["Ice"]),
            Emoji(emoji: "🍨", color: .brown, products: ["Ice Cream"]),
            Emoji(emoji: "🧃", color: .brown, products: ["Juice", "Juice Box"]),
            Emoji(emoji: "🥃", color: .brown, products: ["Whiskey"]),
            Emoji(emoji: "🍶", color: .gray, products: ["Sake"]),
        ]
        
        /*
         🫔 Tamale
         🥙 Stuffed Flatbread
         🍲 Pot of Food
         🫕 Fondue
         🥣 Bowl with Spoon
         🥗 Green Salad
         🍱 Bento Box
         🍘 Rice Cracker
         🍙 Rice Ball
         🍛 Curry Rice
         🍜 Steaming Bowl
         🍝 Spaghetti
         🍢 Oden
         🍥 Fish Cake with Swirl
         🥮 Moon Cake
         🍡 Dango
         🥠 Fortune Cookie
         🥡 Takeout Box
         🍦 Soft Ice Cream
         🍧 Shaved Ice
         🎂 Birthday Cake
         🍰 Shortcake
         🍭 Lollipop
         🍮 Custard
         🍼 Baby Bottle
         🥛 Glass of Milk
         🍵 Teacup Without Handle
         🍾 Bottle with Popping Cork
         🍸 Cocktail Glass
         🍹 Tropical Drink
         🍻 Clinking Beer Mugs
         🥂 Clinking Glasses
         🥃 Tumbler Glass
         🥤 Cup with Straw
         🧋 Bubble Tea
         */
        
        return EmojiProvider(
            emoji: { string in
                var defaultEmoji: Emoji = Emoji(emoji: "🤷🏼‍♂️", color: .gray, products: [])
                var foundEmoji: Emoji?
                
                let directMatch = emoji.filter { emoji in
                    emoji.products.contains(string)
                }
                foundEmoji = directMatch.first
                
                if directMatch.isEmpty {
                    let possibleMatch = emoji.filter { emoji in
                        return !emoji.products.filter { $0.lowercased().contains(string.lowercased()) }.isEmpty
                    }
                    foundEmoji = possibleMatch.first
                }
                
                return foundEmoji ?? defaultEmoji
            }
        )
    }
}

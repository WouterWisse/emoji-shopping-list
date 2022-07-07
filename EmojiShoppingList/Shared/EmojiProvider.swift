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
        ]
        
        /*
         🥬 Leafy Green
          Beans
         🌰 Chestnut
         🍞 Bread
         🥐 Croissant
         
         🫓 Flatbread
         🥨 Pretzel
         🥯 Bagel
         🥞 Pancakes
         🧇 Waffle
         🍖 Meat on Bone
         🍗 Poultry Leg
         🥩 Cut of Meat
         🥓 Bacon
         🍔 Hamburger
         🍟 French Fries
         🍕 Pizza
         🌭 Hot Dog
         🥪 Sandwich
         🌮 Taco
         🌯 Burrito
         🫔 Tamale
         🥙 Stuffed Flatbread
         🧆 Falafel
         🥚 Egg
         🍳 Cooking
         🥘 Shallow Pan of Food
         🍲 Pot of Food
         🫕 Fondue
         🥣 Bowl with Spoon
         🥗 Green Salad
         🍿 Popcorn
         🧈 Butter
         🧂 Salt
         🥫 Canned Food
         🍱 Bento Box
         🍘 Rice Cracker
         🍙 Rice Ball
         🍚 Cooked Rice
         🍛 Curry Rice
         🍜 Steaming Bowl
         🍝 Spaghetti
         🍠 Roasted Sweet Potato
         🍢 Oden
         🍣 Sushi
         🍤 Fried Shrimp
         🍥 Fish Cake with Swirl
         🥮 Moon Cake
         🍡 Dango
         🥟 Dumpling
         🥠 Fortune Cookie
         🥡 Takeout Box
         🦪 Oyster
         🍦 Soft Ice Cream
         🍧 Shaved Ice
         🍨 Ice Cream
         🍩 Doughnut
         🍪 Cookie
         🎂 Birthday Cake
         🍰 Shortcake
         🧁 Cupcake
         🥧 Pie
         🍫 Chocolate Bar
         🍬 Candy
         🍭 Lollipop
         🍮 Custard
         🍯 Honey Pot
         🍼 Baby Bottle
         🥛 Glass of Milk
         ☕ Hot Beverage
         🫖 Teapot
         🍵 Teacup Without Handle
         🍶 Sake
         🍾 Bottle with Popping Cork
         🍷 Wine Glass
         🍸 Cocktail Glass
         🍹 Tropical Drink
         🍺 Beer Mug
         🍻 Clinking Beer Mugs
         🥂 Clinking Glasses
         🥃 Tumbler Glass
         🫗 Pouring Liquid
         🥤 Cup with Straw
         🧋 Bubble Tea
         🧃 Beverage Box
         🧉 Mate
         🧊 Ice
         🥢 Chopsticks
         🍽️ Fork and Knife with Plate
         🍴 Fork and Knife
         🥄 Spoon
         🫙 Jar
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
                    foundEmoji = directMatch.first
                }
                
                return foundEmoji ?? defaultEmoji
            }
        )
    }
}

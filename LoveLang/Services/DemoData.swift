import Foundation

/// Dữ liệu demo để test ứng dụng
enum DemoData {
    static let vocabularyList: [Vocabulary] = [
        Vocabulary(
            word: "Serendipity",
            pronunciation: "/ˌser.ənˈdɪp.ə.ti/",
            meaning: "Sự may mắn, điều bất ngờ và thú vị xảy ra một cách tình cờ",
            partOfSpeech: .noun,
            example: "Finding that book was pure serendipity - I wasn't even looking for it.",
            synonyms: ["luck", "fortune", "chance"]
        ),
        Vocabulary(
            word: "Ephemeral",
            pronunciation: "/ɪˈfem.ər.əl/",
            meaning: "Tạm thời, chóng tàn, chỉ tồn tại trong chốc lát",
            partOfSpeech: .adjective,
            example: "The beauty of cherry blossoms is ephemeral - they only last a few days.",
            synonyms: ["transient", "fleeting", "momentary"]
        ),
        Vocabulary(
            word: "Mellifluous",
            pronunciation: "/meˈlɪf.lu.əs/",
            meaning: "Ngọt ngào, êm dịu (thường dùng cho giọng nói hoặc âm nhạc)",
            partOfSpeech: .adjective,
            example: "Her mellifluous voice captivated the entire audience.",
            synonyms: ["sweet-sounding", "dulcet", "melodious"]
        ),
        Vocabulary(
            word: "Petrichor",
            pronunciation: "/ˈpe.trɪ.kɔːr/",
            meaning: "Mùi đặc trưng của mưa rơi xuống đất khô",
            partOfSpeech: .noun,
            example: "After the storm, the petrichor filled the air with its refreshing scent.",
            synonyms: ["rain smell", "earth smell"]
        ),
        Vocabulary(
            word: "Ineffable",
            pronunciation: "/ɪnˈef.ə.bəl/",
            meaning: "Không thể diễn tả bằng lời, quá sâu sắc để nói ra",
            partOfSpeech: .adjective,
            example: "The view from the mountain top was of ineffable beauty.",
            synonyms: ["indescribable", "inexpressible", "unspeakable"]
        ),
        Vocabulary(
            word: "Luminous",
            pronunciation: "/ˈluː.mɪ.nəs/",
            meaning: "Phát sáng, rực rỡ, chiếu sáng",
            partOfSpeech: .adjective,
            example: "The luminous moon lit up the night sky.",
            synonyms: ["glowing", "radiant", "shining"]
        ),
        Vocabulary(
            word: "Eloquent",
            pronunciation: "/ˈel.ə.kwənt/",
            meaning: "Hùng biện, có khả năng diễn đạt tốt bằng lời",
            partOfSpeech: .adjective,
            example: "She gave an eloquent speech that moved everyone in the room.",
            synonyms: ["articulate", "expressive", "fluent"]
        ),
        Vocabulary(
            word: "Resilience",
            pronunciation: "/rɪˈzɪl.i.əns/",
            meaning: "Sự kiên cường, khả năng phục hồi sau khó khăn",
            partOfSpeech: .noun,
            example: "The community showed great resilience after the disaster.",
            synonyms: ["strength", "toughness", "hardiness"]
        ),
        Vocabulary(
            word: "Serene",
            pronunciation: "/səˈriːn/",
            meaning: "Bình yên, tĩnh lặng, thư thái",
            partOfSpeech: .adjective,
            example: "The serene lake reflected the surrounding mountains perfectly.",
            synonyms: ["calm", "peaceful", "tranquil"]
        ),
        Vocabulary(
            word: "Wanderlust",
            pronunciation: "/ˈwɒn.də.lʌst/",
            meaning: "Khao khát được đi du lịch, khám phá những nơi mới",
            partOfSpeech: .noun,
            example: "Her wanderlust took her to over 50 countries.",
            synonyms: ["travel bug", "adventure craving"]
        ),
        Vocabulary(
            word: "Ethereal",
            pronunciation: "/ɪˈθɪə.ri.əl/",
            meaning: "Siêu nhiên, nhẹ như bong bóng, hoàn toàn thanh khiết",
            partOfSpeech: .adjective,
            example: "The dancer moved with ethereal grace across the stage.",
            synonyms: ["delicate", "heavenly", "otherworldly"]
        ),
        Vocabulary(
            word: "Panacea",
            pronunciation: "/ˌpæn.əˈsiː.ə/",
            meaning: "Liều thuốc chữa hết mọi bệnh, giải pháp cho mọi vấn đề",
            partOfSpeech: .noun,
            example: "There is no panacea for all the world's problems.",
            synonyms: ["cure-all", "universal solution"]
        ),
        Vocabulary(
            word: "Quintessential",
            pronunciation: "/ˌkwɪn.tɪˈsen.ʃəl/",
            meaning: "Tiêu biểu nhất, thuộc về bản chất cốt lõi",
            partOfSpeech: .adjective,
            example: "Paris is the quintessential romantic city.",
            synonyms: ["typical", "classic", "definitive"]
        ),
        Vocabulary(
            word: "Cacophony",
            pronunciation: "/kəˈkɒf.ə.ni/",
            meaning: "Tiếng ồn ào hỗn loạn, không hài hòa",
            partOfSpeech: .noun,
            example: "The cacophony of car horns made it impossible to think.",
            synonyms: ["din", "racket", "noise"]
        ),
        Vocabulary(
            word: "Saudade",
            pronunciation: "/saʊˈdɑː.də/",
            meaning: "Nỗi nhớ bittersweet về điều đã mất hoặc người vắng mặt (tiếng Bồ Đào Nha)",
            partOfSpeech: .noun,
            example: "She felt saudade when listening to her grandmother's songs.",
            synonyms: ["longing", "nostalgia", "yearning"]
        )
    ]

    static let categories: [String] = [
        "All Words",
        "Nouns",
        "Verbs",
        "Adjectives",
        "Adverbs",
        "Learned",
        "Reviewing"
    ]
}

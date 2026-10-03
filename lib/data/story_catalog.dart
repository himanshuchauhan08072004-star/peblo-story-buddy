import 'package:flutter/material.dart';

import '../models/quiz_question.dart';
import '../models/story.dart';

/// The whole library. Add a new [Story] here and it appears everywhere —
/// home, discovery, reader, quiz — automatically.
List<Story> buildStoryCatalog() => [
      Story(
        id: 'pip-lost-star',
        title: 'Pip and the Lost Star',
        description:
            'A clever little robot chases a fallen star through the Whispering Woods.',
        character: CharacterKind.pip,
        characterName: 'Pip',
        category: 'Adventure',
        ageRange: '4-7',
        emoji: '🤖',
        environment: EnvironmentKind.nightForest,
        theme: const StoryTheme(
          skyTop: Color(0xFF1B1F4B),
          skyBottom: Color(0xFF3A2E6B),
          accent: Color(0xFF8A4FFF),
        ),
        completionLine: 'Pip made it home with your help!',
        scenes: const [
          StoryScene(
            text:
                'Pip loved exploring the Whispering Woods, where the trees '
                'hummed soft little tunes every time the wind passed through.',
            prop: '🌲',
            pose: CharacterPose.idle,
          ),
          StoryScene(
            text:
                'One evening, a tiny star fell from the sky and landed with '
                'a gentle plink right on the mossy path in front of Pip.',
            prop: '✨',
            pose: CharacterPose.surprised,
          ),
          StoryScene(
            text:
                'Pip picked up the star very gently. It was warm, and it '
                'blinked twice, as if to say thank you for the rescue.',
            prop: '⭐',
            pose: CharacterPose.happy,
          ),
          StoryScene(
            text:
                'Together, Pip and the little star followed the fireflies '
                'all the way back to the sky, lighting the whole forest blue.',
            prop: '🌌',
            pose: CharacterPose.celebrating,
          ),
        ],
        quiz: const [
          QuizQuestion(
            prompt: "Where did Pip's star fall?",
            options: ['The Whispering Woods', 'A big city', 'The ocean', 'A cave'],
            answerIndex: 0,
            emojis: ['🌲', '🏙️', '🌊', '🕳️'],
            explanation: 'That\'s right — right onto the mossy path!',
            hint: 'Think about where Pip loves to explore.',
          ),
          QuizQuestion(
            prompt: 'How did the star say thank you?',
            options: ['It sang a song', 'It blinked twice', 'It ran away', 'It cried'],
            answerIndex: 1,
            emojis: ['🎵', '✨', '🏃', '😢'],
            explanation: 'Yes! A gentle little blink, blink.',
            hint: 'It happened right after Pip picked it up.',
          ),
        ],
      ),
      Story(
        id: 'luna-moon-garden',
        title: 'Luna and the Moon Garden',
        description:
            'Luna waters a secret garden that only blooms under moonlight.',
        character: CharacterKind.luna,
        characterName: 'Luna',
        category: 'Fantasy',
        ageRange: '4-8',
        emoji: '🌙',
        environment: EnvironmentKind.moonGarden,
        theme: const StoryTheme(
          skyTop: Color(0xFF241B4B),
          skyBottom: Color(0xFF4B2E6B),
          accent: Color(0xFFB9A7F5),
        ),
        completionLine: 'The Moon Garden is glowing because of you!',
        scenes: const [
          StoryScene(
            text:
                'Every night, Luna tiptoed to a hidden garden behind the '
                'old well, where the flowers only opened once the moon rose.',
            prop: '🌸',
            pose: CharacterPose.idle,
          ),
          StoryScene(
            text:
                'She carried a tiny silver watering can filled with dew, '
                'and hummed a quiet song as she watered each glowing petal.',
            prop: '💧',
            pose: CharacterPose.talking,
          ),
          StoryScene(
            text:
                'One flower was shy and would not open at all, so Luna sat '
                'beside it and told it a story until it slowly unfurled.',
            prop: '🌺',
            pose: CharacterPose.thinking,
          ),
          StoryScene(
            text:
                'By midnight, the whole garden glimmered like scattered '
                'starlight, and Luna smiled, knowing she would return tomorrow.',
            prop: '✨',
            pose: CharacterPose.celebrating,
          ),
        ],
        quiz: const [
          QuizQuestion(
            prompt: 'When do the flowers in the Moon Garden open?',
            options: ['At sunrise', 'When the moon rises', 'On rainy days', 'Never'],
            answerIndex: 1,
            emojis: ['🌅', '🌙', '🌧️', '🚫'],
            explanation: 'Exactly — only once the moon comes up.',
            hint: 'The garden is named after something in the night sky.',
          ),
          QuizQuestion(
            prompt: 'What did Luna do for the shy flower?',
            options: ['Told it a story', 'Gave it a hat', 'Left it alone', 'Sang loudly'],
            answerIndex: 0,
            emojis: ['📖', '🎩', '🚶', '📣'],
            explanation: 'Right — she sat and told it a story until it opened.',
            hint: 'She used her voice, gently.',
          ),
        ],
      ),
      Story(
        id: 'milo-magical-backpack',
        title: "Milo's Magical Backpack",
        description:
            'Milo discovers his old backpack can pack a surprise for every problem.',
        character: CharacterKind.milo,
        characterName: 'Milo',
        category: 'Adventure',
        ageRange: '5-8',
        emoji: '🎒',
        environment: EnvironmentKind.sunnyAdventure,
        theme: const StoryTheme(
          skyTop: Color(0xFF2E6B8A),
          skyBottom: Color(0xFFFFB84D),
          accent: Color(0xFFFF8A3D),
        ),
        completionLine: "Milo's backpack packed the perfect surprise!",
        scenes: const [
          StoryScene(
            text:
                'Milo found an old backpack in the attic, covered in patches '
                'from places he had never been.',
            prop: '🎒',
            pose: CharacterPose.idle,
          ),
          StoryScene(
            text:
                'When he reached inside for a snack, he pulled out a tiny '
                'umbrella instead — right as the first raindrop fell.',
            prop: '☂️',
            pose: CharacterPose.surprised,
          ),
          StoryScene(
            text:
                'Later, when the path split in three directions, the '
                'backpack handed him a map that only he could read.',
            prop: '🗺️',
            pose: CharacterPose.thinking,
          ),
          StoryScene(
            text:
                'By sunset, Milo understood: the backpack always packed '
                'exactly what a curious explorer needed most.',
            prop: '🧭',
            pose: CharacterPose.celebrating,
          ),
        ],
        quiz: const [
          QuizQuestion(
            prompt: 'What did the backpack give Milo when it started raining?',
            options: ['A sandwich', 'An umbrella', 'A blanket', 'A flashlight'],
            answerIndex: 1,
            emojis: ['🥪', '☂️', '🛏️', '🔦'],
            explanation: 'Yes — a tiny umbrella, right on time!',
            hint: 'Think about what keeps you dry.',
          ),
          QuizQuestion(
            prompt: 'What did the backpack give him at the split path?',
            options: ['A map', 'A key', 'A snack', 'A hat'],
            answerIndex: 0,
            emojis: ['🗺️', '🔑', '🍎', '🎩'],
            explanation: 'Right — a map only Milo could read.',
            hint: 'It helped him choose which way to go.',
          ),
        ],
      ),
      Story(
        id: 'little-cloud-rain',
        title: "The Little Cloud Who Couldn't Rain",
        description:
            'A small cloud learns that asking for help is its own kind of strength.',
        character: CharacterKind.cloud,
        characterName: 'Nimbo',
        category: 'Friendship',
        ageRange: '3-6',
        emoji: '☁️',
        environment: EnvironmentKind.cloudSky,
        theme: const StoryTheme(
          skyTop: Color(0xFF6FA8D6),
          skyBottom: Color(0xFFDCEEFF),
          accent: Color(0xFF7CC4F5),
        ),
        completionLine: 'Nimbo learned that asking for help is brave!',
        scenes: const [
          StoryScene(
            text:
                'Nimbo was the smallest cloud in the sky, and no matter how '
                'hard he tried, he could not make a single drop of rain.',
            prop: '☁️',
            pose: CharacterPose.idle,
          ),
          StoryScene(
            text:
                'Down below, a little garden was wilting in the sun, and '
                'Nimbo felt terrible that he could not help it grow.',
            prop: '🥀',
            pose: CharacterPose.thinking,
          ),
          StoryScene(
            text:
                'A big, kind cloud named Gus floated by and asked Nimbo why '
                'he looked so sad, so Nimbo told him everything.',
            prop: '🌥️',
            pose: CharacterPose.talking,
          ),
          StoryScene(
            text:
                'Gus shared some of his own rain, and together they gave the '
                'garden a soft, gentle shower until every flower stood tall.',
            prop: '🌦️',
            pose: CharacterPose.celebrating,
          ),
        ],
        quiz: const [
          QuizQuestion(
            prompt: 'Why was Nimbo sad?',
            options: [
              'He was lost',
              'He could not make rain',
              'He was too big',
              'He lost a friend'
            ],
            answerIndex: 1,
            emojis: ['🧭', '☁️', '📏', '💔'],
            explanation: 'Right — he could not rain to help the garden.',
            hint: 'It has to do with what clouds usually do.',
          ),
          QuizQuestion(
            prompt: 'How did Nimbo solve the problem?',
            options: [
              'He gave up',
              'He asked Gus for help',
              'He hid in the sky',
              'He flew away'
            ],
            answerIndex: 1,
            emojis: ['😞', '🤝', '🙈', '💨'],
            explanation: 'Yes! Asking for help was the brave choice.',
            hint: 'A bigger, kinder cloud floated by.',
          ),
        ],
      ),
      Story(
        id: 'leo-secret-forest',
        title: 'Leo and the Secret Forest',
        description:
            'Leo follows a trail of glowing mushrooms into a forest no map has ever shown.',
        character: CharacterKind.leo,
        characterName: 'Leo',
        category: 'Discovery',
        ageRange: '5-9',
        emoji: '🦊',
        environment: EnvironmentKind.secretForest,
        theme: const StoryTheme(
          skyTop: Color(0xFF14361F),
          skyBottom: Color(0xFF2E6B4A),
          accent: Color(0xFF5FD3A6),
        ),
        completionLine: 'Leo mapped a forest no one had ever seen!',
        scenes: const [
          StoryScene(
            text:
                'Leo the fox noticed a trail of tiny glowing mushrooms '
                'leading off the path he knew, deeper into the trees.',
            prop: '🍄',
            pose: CharacterPose.idle,
          ),
          StoryScene(
            text:
                'He followed them carefully, counting each glowing cap, '
                'until he reached a clearing that shimmered like glass.',
            prop: '🌟',
            pose: CharacterPose.surprised,
          ),
          StoryScene(
            text:
                'In the middle stood an enormous tree with a door carved '
                'into its trunk, humming with a quiet, curious song.',
            prop: '🌳',
            pose: CharacterPose.thinking,
          ),
          StoryScene(
            text:
                'Leo drew everything he saw into his notebook, so that one '
                'day other explorers could find the secret forest too.',
            prop: '📓',
            pose: CharacterPose.celebrating,
          ),
        ],
        quiz: const [
          QuizQuestion(
            prompt: 'What did Leo follow into the forest?',
            options: [
              'A river',
              'Glowing mushrooms',
              'A trail of leaves',
              'A butterfly'
            ],
            answerIndex: 1,
            emojis: ['🏞️', '🍄', '🍂', '🦋'],
            explanation: 'That\'s it — a trail of glowing mushrooms!',
            hint: 'They were small and lit up.',
          ),
          QuizQuestion(
            prompt: 'What did Leo do at the end of his adventure?',
            options: [
              'He drew it in his notebook',
              'He took the tree home',
              'He forgot about it',
              'He fell asleep'
            ],
            answerIndex: 0,
            emojis: ['📓', '🌳', '🤷', '😴'],
            explanation: 'Yes — so other explorers could find it too.',
            hint: 'He wanted to remember and share what he saw.',
          ),
        ],
      ),
    ];

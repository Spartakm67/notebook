import 'package:hive/hive.dart';
import 'package:english_words/english_words.dart';

part 'word_pair_wrapper.g.dart';

@HiveType(typeId: 0)
class WordPairWrapper extends HiveObject {
  @HiveField(0)
  late String first;

  @HiveField(1)
  late String second;

  WordPairWrapper(this.first, this.second);

  WordPair toWordPair() => WordPair(first, second);

  static WordPairWrapper fromWordPair(WordPair pair) => WordPairWrapper(pair.first, pair.second);
}

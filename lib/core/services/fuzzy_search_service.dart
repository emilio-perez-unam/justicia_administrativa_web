import 'package:fuzzy/fuzzy.dart';
import '../models/matter.dart';

class FuzzySearchService {
  late Fuzzy<Matter> _matterFuzzy;
  bool _isIndexed = false;

  void indexMatters(List<Matter> matters) {
    _matterFuzzy = Fuzzy<Matter>(
      matters,
      options: FuzzyOptions(
        keys: [
          WeightedKey(name: 'title', getter: (m) => m.title, weight: 1.0),
          WeightedKey(
            name: 'referenceCode',
            getter: (m) => m.referenceCode,
            weight: 0.8,
          ),
        ],
      ),
    );
    _isIndexed = true;
  }

  List<Matter> searchMatters(String query) {
    if (!_isIndexed) return [];
    final results = _matterFuzzy.search(query);
    return results.map((r) => r.item).toList();
  }
}

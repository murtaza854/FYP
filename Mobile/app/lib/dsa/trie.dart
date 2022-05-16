import '../models/user_model.dart';

class TrieNode<T> {
  TrieNode({this.key, this.parent});

  // 1
  T? key;

  // 2
  TrieNode<T>? parent;

  // 3
  Map<T, TrieNode<T>?> children = {};

  // 4
  bool isTerminating = false;
}

class StringTrie {
  TrieNode<int> root = TrieNode(key: null, parent: null);

  Map insertUser(UserModel user, Map jsonObj) {
    // 1
    String text = user.getName().toLowerCase();
    if (jsonObj.containsKey(text) == false) {
      jsonObj[text] = [user];
    } else {
      jsonObj[text].add(user);
    }
    var current = root;

    // 2
    for (var codeUnit in text.codeUnits) {
      current.children[codeUnit] ??= TrieNode(
        key: codeUnit,
        parent: current,
      );
      current = current.children[codeUnit]!;
    }

    // 3
    current.isTerminating = true;
    return jsonObj;
  }

  void insertString(String text) {
    var current = root;

    // 2
    for (var codeUnit in text.codeUnits) {
      current.children[codeUnit] ??= TrieNode(
        key: codeUnit,
        parent: current,
      );
      current = current.children[codeUnit]!;
    }

    // 3
    current.isTerminating = true;
  }

  bool contains(String text) {
    var current = root;
    for (var codeUnit in text.codeUnits) {
      final child = current.children[codeUnit];
      if (child == null) {
        return false;
      }
      current = child;
    }
    return current.isTerminating;
  }

  void remove(String text) {
    // 1
    var current = root;
    for (final codeUnit in text.codeUnits) {
      final child = current.children[codeUnit];
      if (child == null) {
        return;
      }
      current = child;
    }
    if (!current.isTerminating) {
      return;
    }
    // 2
    current.isTerminating = false;
    // 3
    while (current.parent != null &&
        current.children.isEmpty &&
        !current.isTerminating) {
      current.parent!.children[current.key!] = null;
      current = current.parent!;
    }
  }

  List<String> matchPrefix(String prefix) {
    // 1
    var current = root;
    for (final codeUnit in prefix.codeUnits) {
      final child = current.children[codeUnit];
      if (child == null) {
        return [];
      }
      current = child;
    }

    // 2 (to be implemented shortly)
    return _moreMatches(prefix, current);
  }

  List<String> _moreMatches(String prefix, TrieNode<int> node) {
    // 1
    List<String> results = [];
    if (node.isTerminating) {
      results.add(prefix);
    }
    // 2
    for (final child in node.children.values) {
      if (child != null) {
        final codeUnit = child.key!;
        results.addAll(
          _moreMatches(
            '$prefix${String.fromCharCode(codeUnit)}',
            child,
          ),
        );
      }
    }
    return results;
  }
}

// void main() {
//   var jsonObj = {};
//   final trie = StringTrie();
//   jsonObj = trie.insert('car', jsonObj);
//   jsonObj = trie.insert('car', jsonObj);
//   jsonObj = trie.insert('care', jsonObj);
//   jsonObj = trie.insert('cared', jsonObj);
//   jsonObj = trie.insert('cars', jsonObj);
//   jsonObj = trie.insert('carbs', jsonObj);
//   jsonObj = trie.insert('cara pace', jsonObj);
//   jsonObj = trie.insert('doll', jsonObj);
//   jsonObj = trie.insert('dog', jsonObj);
//   print(jsonObj);

//   print('Collections starting with "car"');
//   final prefixedWithCar = trie.matchPrefix('car');
//   print(prefixedWithCar);

//   print('\nCollections starting with "do"');
//   final prefixedWithCare = trie.matchPrefix('do');
//   print(prefixedWithCare);
// }

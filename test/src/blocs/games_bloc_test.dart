import 'package:rxdart/rxdart.dart';
import 'package:test_api/test_api.dart';

void main() {
  test("BehaviorSubject seeded first value", () {

    final _subject = BehaviorSubject<int>.seeded(0);

    expect(_subject, emitsInOrder([0]));
//    expect(_subject, emitsInOrder([null,0]));

    _subject.close();
  });
}
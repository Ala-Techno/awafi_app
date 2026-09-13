class Unit {
  const Unit();

  @override
  bool operator ==(Object other) => identical(this, other) || other is Unit;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'Unit';
}

const unit = Unit();
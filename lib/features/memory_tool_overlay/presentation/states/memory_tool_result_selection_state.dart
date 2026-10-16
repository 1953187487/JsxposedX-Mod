class MemoryToolResultSelectionState {
  const MemoryToolResultSelectionState({
    this.selectionLimit = 100,
    this.selectedAddresses = const <int>[],
  });

  final int selectionLimit;
  final List<int> selectedAddresses;

  int get selectedCount => selectedAddresses.length;

  bool contains(int address) {
    return selectedAddresses.contains(address);
  }

  MemoryToolResultSelectionState copyWith({
    int? selectionLimit,
    List<int>? selectedAddresses,
  }) {
    return MemoryToolResultSelectionState(
      selectionLimit: selectionLimit ?? this.selectionLimit,
      selectedAddresses: selectedAddresses ?? this.selectedAddresses,
    );
  }
}

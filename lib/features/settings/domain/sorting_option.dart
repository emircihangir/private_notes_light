enum SortingOption {
  newestFirst('dateCreated DESC'),
  oldestFirst('dateCreated ASC'),
  aToZ('title ASC'),
  zToA('title DESC');

  final String sortingValue;
  const SortingOption(this.sortingValue);
}

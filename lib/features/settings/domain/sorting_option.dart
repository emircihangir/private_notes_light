enum SortingOption {
  newestFirst('dateCreated DESC'),
  oldestFirst('dateCreated ASC'),
  aToZ('title COLLATE NOCASE ASC'),
  zToA('title COLLATE NOCASE DESC');

  final String sortingValue;
  const SortingOption(this.sortingValue);
}

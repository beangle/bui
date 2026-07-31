Compile / packageBin / mappings := {
  (Compile / copyResources).value
  val converter = fileConverter.value
  val prefix = "META-INF/resources/bui/" + version.value
  // 只用 classDirectory：products 同时含 classes / src/main/resources / resource_managed，
  // 相对路径重复会导致 ZipException: duplicate entry
  Path.allSubpaths((Compile / classDirectory).value)
    .iterator
    .filter(_._1.isFile)
    .map { case (file, path) =>
      converter.toVirtualFile(file.toPath) -> s"$prefix/$path"
    }
    .toSeq
}
